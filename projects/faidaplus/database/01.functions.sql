CREATE OR REPLACE FUNCTION generate_points(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec						RECORD;
	v_period				date;
	v_points				real;
	v_points_id				integer;
	v_amount				real;
	msg 					varchar(120);
BEGIN

	SELECT start_date INTO v_period FROM periods WHERE period_id = $1::integer AND closed = false;
	IF(v_period IS NULL)THEN RAISE EXCEPTION 'Period is closed';	END IF;

	FOR rec IN SELECT pcc,son,ticket_period,total_segs
	FROM vw_son_segs WHERE (ticket_period = to_char(v_period, 'mm') ||to_char(v_period, 'yyyy') ) LOOP

		IF(1<= rec.total_segs::integer AND rec.total_segs::integer <=250 ) THEN
			v_amount := 12;
			v_points := rec.total_segs * 12 ;
		END IF;

		IF(251>= rec.total_segs::integer AND rec.total_segs::integer <=500) THEN
			v_amount := 16;
			v_points := rec.total_segs * 16 ;
		END IF;

		IF(rec.total_segs::integer >=501 ) THEN
			v_amount := 20;
			v_points := rec.total_segs * 20 ;
		END IF;

		SELECT points_id INTO v_points_id
		FROM points WHERE period_id = $1::integer AND pcc = rec.pcc AND son = rec.son;

		IF(v_points_id is null)THEN
			INSERT INTO points (period,period_id,pcc,son,segments,amount,points)
			VALUES (v_period,$1::integer,rec.pcc,rec.son,rec.total_segs,v_amount,v_points);
		END IF;

		IF(v_points_id is not null)THEN
			UPDATE points SET segments = rec.total_segs, amount = v_amount, points = v_points
			WHERE points_id = v_points_id;
		END IF;

	END LOOP;

	IF(rec IS NULL)THEN RAISE EXCEPTION 'There are no segments for this month'; END IF;
	msg := 'Points computed';
    --UPDATE periods SET closed = true WHERE period_id = $1::integer;
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

	FOR rec IN SELECT points_id, period_id, pcc, son, segments, amount, points, bonus
	FROM points WHERE (period_id = $1::integer) LOOP

		SELECT percentage, amount INTO v_pcc_bonus_ps, v_pcc_bonus_amount
		FROM bonus
		WHERE (pcc = rec.pcc) AND (is_active = true) AND (approve_status = 'Approved');
		IF(v_pcc_bonus_ps is null)THEN v_pcc_bonus_ps := 0; END IF;
		IF(v_pcc_bonus_amount is null)THEN v_pcc_bonus_amount := 0; END IF;

		SELECT percentage, amount INTO v_son_bonus_ps, v_son_bonus_amount
		FROM bonus
		WHERE (son = rec.son) AND (is_active = true) AND (approve_status = 'Approved');
		IF(v_son_bonus_ps is null)THEN v_son_bonus_ps := 0; END IF;
		IF(v_son_bonus_amount is null)THEN v_son_bonus_amount := 0; END IF;

		v_bonus := (rec.points * v_period_bonus_ps / 100) + v_period_bonus_amount;
		v_bonus := v_bonus + (rec.points * v_pcc_bonus_ps) + v_pcc_bonus_amount;
		v_bonus := v_bonus + (rec.points * v_son_bonus_ps) + v_son_bonus_amount;

		UPDATE points SET bonus = v_bonus WHERE points_id = rec.points_id;

	END LOOP;

	msg := 'Bonus computed';
	RETURN msg;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION upd_orders_status(varchar(12), varchar(12), varchar(12),varchar(12))	RETURNS character varying(120) AS $BODY$
DECLARE
	msg 		character varying(20);
	details 	text;
BEGIN

	IF ($3::integer = 1) THEN
		UPDATE orders SET order_status = 'Awaiting Collection' WHERE order_id = $1::integer;
		details :='Your Order is ready for collection';
	END IF;

	IF ($3::integer = 2) THEN
		UPDATE orders SET order_status = 'Collected' WHERE order_id = $1::integer;
		details := 'Your Order has been collected';
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE orders SET order_status = 'Closed' WHERE order_id = $1::integer;
	END IF;

	INSERT INTO sys_emailed (table_id, sys_email_id, table_name, email_type, org_id,narrative)
	VALUES ($1::integer,2 ,'orders', 1, 0,details);
	RETURN 'Successfully Updated';
END;
$BODY$ LANGUAGE plpgsql;
