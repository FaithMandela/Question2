


INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('4', '2016-01-01','2016-01-31','To handle segments discrepancies in Aug 2015','2RJ');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('50', '2016-01-01','2016-02-29','kes. 50 to push share to 50% from 10%','7PX1');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('50', '2016-01-01','2016-02-29','kes. 50 to push share to 50% from 10%','B30');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('25', '2016-01-01','2016-02-29','50% bonus to push share from 10% to 50%','75M5');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('40', '2016-01-01','2016-03-31','Shiamsy extension from Jan-Mar to push more share','7GQ4');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('5', '2016-01-01','2016-02-29','Discrepancies Aug and Dec 2015','757E');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('8', '2016-02-01','2016-03-31','points difference in Jan','8GH');

UPDATE bonus SET org_id = bonus.org_id
FROM orgs WHERE orgs.pcc = bonus.pcc;

DELETE FROM points WHERE period_id IN (109, 110);
DELETE FROM periods WHERE period_id IN (109, 110);


CREATE EXTENSION postgres_fdw;

CREATE SERVER t_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '62.24.122.1', dbname 'tickets', port '5432');

CREATE USER MAPPING FOR postgres SERVER t_server OPTIONS (user 'root', password 'invent');

SELECT pcc, agencyname, son, ticketperiod, segperiod, totalsegs
FROM vwsonsegs;

CREATE FOREIGN TABLE t_sonsegs (
	pcc					varchar(4),
	agencyname			varchar(120),
	son					varchar(4),
	ticketperiod		varchar(7),
	segperiod			varchar(7),
	totalsegs			integer
)
SERVER t_server OPTIONS(table_name 'vwsonsegs');

CREATE OR REPLACE FUNCTION generate_points(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec						RECORD;
	v_period				varchar(7);
	v_period_id				integer;
	v_org_id				integer;
	v_entity_id				integer;
	v_points				real;
	v_points_id				integer;
	v_amount				real;
	msg 					varchar(120);
BEGIN

	v_period_id = $1::integer;
	SELECT to_char(start_date, 'mmyyyy') INTO v_period
	FROM periods WHERE period_id = v_period_id AND closed = false;
	IF(v_period IS NULL)THEN RAISE EXCEPTION 'Period is closed'; END IF;

	FOR rec IN SELECT pcc, son, ticketperiod, totalsegs
	FROM t_sonsegs WHERE (ticketperiod = v_period) LOOP

		IF(1<= rec.totalsegs::integer AND rec.totalsegs::integer <=250 ) THEN
			v_amount := 12;
			v_points := rec.totalsegs * 12 ;
		END IF;

		IF(251>= rec.totalsegs::integer AND rec.total_segs::integer <=500) THEN
			v_amount := 16;
			v_points := rec.totalsegs * 16 ;
		END IF;

		IF(rec.totalsegs::integer >=501 ) THEN
			v_amount := 20;
			v_points := rec.totalsegs * 20 ;
		END IF;

		SELECT orgs.org_id, entitys.entity_id INTO v_org_id, v_entity_id
		FROM orgs INNER JOIN entitys ON orgs.org_id = entitys.org_id
		WHERE (entitys.is_active = true) AND (orgs.pcc = rec.pcc) AND (entitys.son = rec.son);
		IF(v_entity_id is null)THEN v_entity_id := 0; v_org_id := 0; END IF;

		SELECT points_id INTO v_points_id
		FROM points WHERE (period_id = v_period_id) AND (entity_id = v_entity_id)
			AND (pcc = rec.pcc) AND (son = rec.son);

		IF(v_points_id is null)THEN
			INSERT INTO points (period, period_id, entity_id, pcc, son, segments, amount, points)
			VALUES (v_period, v_period_id, v_entity_id, rec.pcc, rec.son, rec.total_segs, v_amount, v_points);
		ELSE
			UPDATE points SET segments = rec.total_segs, amount = v_amount, points = v_points
			WHERE points_id = v_points_id;
		END IF;
	END LOOP;

	IF(rec IS NULL)THEN
		msg := 'There are no segments for this month';
	ELSE
		msg := 'Points computed';
	END IF;


	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_bonus(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec						RECORD;
	v_period_bonus_ps		real;
	v_period_bonus_amount	real;
	v_pcc_bonus_ps			real;
	v_pcc_bonus_amount		real;
	v_son_bonus_ps			real;
	v_son_bonus_amount		real;
	v_bonus					real;
	msg 					varchar(120);
BEGIN


	SELECT percentage, amount INTO v_period_bonus_ps, v_period_bonus_amount
	FROM bonus
	WHERE (period_id = $1::integer) AND (is_active = true) AND (approve_status = 'Approved');
	IF(v_period_bonus_ps is null)THEN v_period_bonus_ps := 0; END IF;
	IF(v_period_bonus_amount is null)THEN v_period_bonus_amount := 0; END IF;


	FOR rec IN SELECT points_id, entity_id, period_id, pcc, son, segments, amount, points, bonus
	FROM points WHERE (period_id = $1::integer) LOOP

		SELECT percentage, amount INTO v_pcc_bonus_ps, v_pcc_bonus_amount
		FROM bonus
		WHERE (pcc = rec.pcc) AND (is_active = true) AND (approve_status = 'Approved')
			AND (start_date <= current_date) AND ((end_date is null) OR (end_date >= current_date));
		IF(v_pcc_bonus_ps is null)THEN v_pcc_bonus_ps := 0; END IF;
		IF(v_pcc_bonus_amount is null)THEN v_pcc_bonus_amount := 0; END IF;

		SELECT percentage, amount INTO v_son_bonus_ps, v_son_bonus_amount
		FROM bonus
		WHERE (consultant_id = rec.entity_id) AND (is_active = true) AND (approve_status = 'Approved')
			AND (start_date <= current_date) AND ((end_date is null) OR (end_date >= current_date));
		IF(v_son_bonus_ps is null)THEN v_son_bonus_ps := 0; END IF;
		IF(v_son_bonus_amount is null)THEN v_son_bonus_amount := 0; END IF;

		v_bonus := (rec.points * v_period_bonus_ps / 100) + (rec.points * v_period_bonus_amount);
		v_bonus := v_bonus + (rec.points * v_pcc_bonus_ps / 100) + (rec.points * v_pcc_bonus_amount);
		v_bonus := v_bonus + (rec.points * v_son_bonus_ps / 100) + (rec.points * v_son_bonus_amount);

		UPDATE points SET bonus = v_bonus WHERE points_id = rec.points_id;

	END LOOP;

	msg := 'Bonus computed';
	RETURN msg;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION ins_orgs() RETURNS trigger AS $$
BEGIN
	NEW.pcc = trim(upper(NEW.pcc));
	RETURN NEW
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_orgs BEFORE INSERT OR UPDATE ON orgs
    FOR EACH ROW EXECUTE PROCEDURE ins_orgs();

CREATE OR REPLACE FUNCTION upd_entitys() RETURNS trigger AS $$
BEGIN

	IF((OLD.change_pcc <> NEW.change_pcc) or (OLD.change_son <> NEW.change_son))THEN
		INSERT INTO change_pccs (entity_id, son, pcc, change_son, change_pcc)
		VALUES (NEW.entity_id, NEW.son, NEW.pcc, NEW.change_son, NEW.change_pcc);
 	END IF;

	RETURN NEW
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_entitys BEFORE UPDATE ON entitys
    FOR EACH ROW EXECUTE PROCEDURE upd_entitys();

CREATE OR REPLACE FUNCTION upd_change_pccs() RETURNS trigger AS $$
DECLARE
	v_org_id				integer;
	v_entity_id				integer;
BEGIN

	IF((OLD.approve_status = 'Completed') AND (NEW.approve_status = 'Approved'))THEN
		SELECT orgs.org_id INTO v_org_id
		FROM orgs WHERE (orgs.pcc = NEW.change_pcc);
		IF((NEW.change_pcc is null) or (v_org_id is null))THEN RAISE EXCEPTION 'No Travel Agency with new PCC'; END IF;

		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (org_id = v_org_id) AND (entitys.son = NEW.change_son);
		IF(v_entity_id is not null)THEN RAISE EXCEPTION 'A consultant with that SON already exists'; END IF;

		UPDATE entitys SET org_id = v_org_id, pcc = NEW.change_pcc, son = NEW.change_son
		WHERE entity_id = v_entity_id;
 	END IF;

	RETURN NEW
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_change_pccs BEFORE UPDATE ON change_pccs
    FOR EACH ROW EXECUTE PROCEDURE upd_change_pccs();


ALTER TABLE orgs ADD CONSTRAINT orgs_pcc_unique UNIQUE (pcc);
