

ALTER TABLE employees ADD 	bio_metric_number		varchar(32);

UPDATE employees SET bio_metric_number = '22736267004240' WHERE entity_id = 20;
UPDATE employees SET bio_metric_number = '15035373000600' WHERE entity_id = 58;
UPDATE employees SET bio_metric_number = '10734554004240' WHERE entity_id = 31;
UPDATE employees SET bio_metric_number = '22553634000520' WHERE entity_id = 2;
UPDATE employees SET bio_metric_number = '66474355004340' WHERE entity_id = 12;
UPDATE employees SET bio_metric_number = '5650654004240' WHERE entity_id = 19;
UPDATE employees SET bio_metric_number = '54642404000110' WHERE entity_id = 57;
UPDATE employees SET bio_metric_number = '1715554004240' WHERE entity_id = 22;
UPDATE employees SET bio_metric_number = '35717071004360' WHERE entity_id = 53;
UPDATE employees SET bio_metric_number = '40447355004340' WHERE entity_id = 38;
UPDATE employees SET bio_metric_number = '42401654004240' WHERE entity_id = 37;
UPDATE employees SET bio_metric_number = '77022654004240' WHERE entity_id = 59;
UPDATE employees SET bio_metric_number = '13675355004340' WHERE entity_id = 46;
UPDATE employees SET bio_metric_number = '65352552004300' WHERE entity_id = 56;
UPDATE employees SET bio_metric_number = '54444123000450' WHERE entity_id = 52;
UPDATE employees SET bio_metric_number = '30132407604000' WHERE entity_id = 60;
UPDATE employees SET bio_metric_number = '42510455004340' WHERE entity_id = 41;
UPDATE employees SET bio_metric_number = '55102367004240' WHERE entity_id = 33;
UPDATE employees SET bio_metric_number = '47045355004340' WHERE entity_id = 45;
UPDATE employees SET bio_metric_number = '14325554004240' WHERE entity_id = 34;
UPDATE employees SET bio_metric_number = '35724634000520' WHERE entity_id = 27;
UPDATE employees SET bio_metric_number = '47415554004240' WHERE entity_id = 17;
UPDATE employees SET bio_metric_number = '36650654004240' WHERE entity_id = 8;
UPDATE employees SET bio_metric_number = '42016520000240' WHERE entity_id = 26;
UPDATE employees SET bio_metric_number = '15146554004240' WHERE entity_id = 35;
UPDATE employees SET bio_metric_number = '65142622000440' WHERE entity_id = 28;
UPDATE employees SET bio_metric_number = '25603355004340' WHERE entity_id = 47;

CREATE TABLE access_logs (
	access_log_id			integer primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	log_time				timestamp,
	log_name				varchar(50),
	log_machine				varchar(50),
	log_access				varchar(50),
	log_id					varchar(50),
	log_area				varchar(50),
	log_in_out				varchar(50),

	is_picked				boolean default false,
	narrative				varchar(240)
);
CREATE INDEX access_logs_entity_id ON access_logs (entity_id);
CREATE INDEX access_logs_org_id ON access_logs (org_id);

CREATE OR REPLACE FUNCTION process_bio_imports1(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_org_id				integer;
	msg		 				varchar(120);
BEGIN

	SELECT org_id INTO v_org_id FROM entitys
	WHERE entity_id = $2::integer;

	INSERT INTO access_logs (access_log_id, entity_id, org_id, log_time, log_name, log_machine, log_access, log_id, log_area, log_in_out)
	SELECT bio_imports1_id, e.entity_id, v_org_id, to_timestamp(col1, 'DD/MM/YYYY hh:MI:SS pm'), col2, col4, col5, col6, col7, col10
	FROM bio_imports1 LEFT JOIN access_logs ON bio_imports1.bio_imports1_id = access_logs.access_log_id
		LEFT JOIN employees as e ON trim(bio_imports1.col6) = trim(e.bio_metric_number)
	WHERE access_logs.access_log_id is null
	ORDER BY to_timestamp(col1, 'DD/MM/YYYY hh:MI:SS pm');

	DELETE FROM bio_imports1;

	INSERT INTO attendance (entity_id, org_id, attendance_date, time_in, time_out)
	SELECT entity_id, org_id, log_time::date, min(log_time::time), max(log_time::time)
	FROM access_logs
	WHERE (is_picked = false) AND (entity_id is not null)
	GROUP BY entity_id, org_id, log_time::date
	ORDER BY entity_id, log_time::date;

	UPDATE access_logs SET is_picked = true
	WHERE (is_picked = false) AND (entity_id is not null);

	msg := 'Uploaded the file';
	
	return msg;
END;
$$ LANGUAGE plpgsql;


ALTER TABLE entitys ALTER COLUMN entity_password DROP DEFAULT;
ALTER TABLE entitys ALTER COLUMN first_password DROP DEFAULT;


CREATE OR REPLACE FUNCTION ins_password() RETURNS trigger AS $$
DECLARE
	v_entity_id		integer;
BEGIN

	SELECT entity_id INTO v_entity_id
	FROM entitys
	WHERE (trim(lower(user_name)) = trim(lower(NEW.user_name)))
		AND entity_id <> NEW.entity_id;
		
	IF(v_entity_id is not null)THEN
		RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
	END IF;

	IF(TG_OP = 'INSERT') THEN
		IF(NEW.first_password is null)THEN
			NEW.first_password := first_password();
		END IF;

		IF (NEW.entity_password is null) THEN
			NEW.entity_password := md5(NEW.first_password);
		END IF;
	ELSIF(OLD.first_password <> NEW.first_password) THEN
		NEW.Entity_password := md5(NEW.first_password);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE org_events (
	org_event_id			serial primary key,
	org_id					integer references orgs,
	org_event_name			varchar(50) not null,
	start_date				date,
	end_date				date,
	details					text
);
CREATE INDEX org_events_id ON org_events (org_id);

CREATE OR REPLACE FUNCTION ins_projects() RETURNS trigger AS $$
DECLARE
    myrec RECORD;
	start_days integer;
BEGIN
	start_days := 0;
	FOR myrec IN SELECT entity_type_id, Define_phase_name,  
		CAST(((NEW.ending_date - NEW.start_date) * Define_phase_time / 100) as integer) as date_range, 
		(NEW.project_cost * Define_phase_cost / 100) as phase_cost
		FROM Define_Phases
		WHERE (project_type_id = NEW.project_type_id)
		ORDER BY define_phases.phase_order 
	LOOP

		INSERT INTO Phases (org_id, project_id, entity_type_id, phase_name, start_date, end_date, phase_cost)
		VALUES(NEW.org_id, NEW.project_id, myrec.entity_type_id, myrec.Define_phase_name, 
			NEW.start_date + start_days, 
			NEW.start_date + myrec.date_range + start_days, 
			myrec.phase_cost);
		
		start_days := start_days + myrec.date_range + 1;
	END LOOP;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_project_staff(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg		 				varchar(120);
	v_entity_id				integer;
	v_org_id				integer;
BEGIN

	SELECT entity_id INTO v_entity_id
	FROM project_staff WHERE (entity_id = CAST($1 as int)) AND (project_id = CAST($3 as int));
	
	IF(v_entity_id is null)THEN
		SELECT org_id INTO v_org_id
		FROM projects WHERE (project_id = CAST($3 as int));
		
		INSERT INTO  project_staff (project_id, entity_id, org_id)
		VALUES (CAST($3 as int), CAST($1 as int), v_org_id);

		msg := 'Added to project';
	ELSE
		msg := 'Already Added to project';
	END IF;
	
	return msg;
END;
$$ LANGUAGE plpgsql;

