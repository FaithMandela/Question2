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

