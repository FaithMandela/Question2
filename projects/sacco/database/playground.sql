CREATE OR REPLACE FUNCTION ins_applicants()
RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		
		IF(NEW.entity_id IS NULL) THEN
			SELECT entity_id INTO v_entity_id
			FROM entitys
			WHERE (trim(lower(user_name)) = trim(lower(NEW.applicant_email)));
				
			IF(v_entity_id is null)THEN
				SELECT org_id INTO rec
				FROM orgs WHERE (is_default = true);

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, 
					primary_email, primary_telephone, function_role)
				VALUES (NEW.entity_id, rec.org_id, 0, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant');
			ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

		INSERT INTO sys_emailed (table_id, table_name)
		VALUES (NEW.entity_id, 'applicant');
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;

			
	END IF;
	
	IF (NEW.approve_status = 'Approved') THEN 
	INSERT INTO members(
            entity_id,org_id, surname, first_name, middle_name,phone, 
            gender,marital_status,salary,nationality,objective, details)
    VALUES (New.entity_id,New.org_id,New.Surname,NEW.First_name,NEW.Middle_name,
    New.applicant_phone,New.gender,New.marital_status,NEW.salary,NEW.nationality,NEW.objective, new.details);
	ELSE
	END IF;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
