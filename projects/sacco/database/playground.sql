
CREATE OR REPLACE FUNCTION ins_members()
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
			WHERE function_role = 'member';
				
			IF(v_entity_id is null)THEN
				SELECT org_id INTO rec
				FROM orgs WHERE (is_default = true);

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO members (entity_id, org_id, full_names, surname,first_name, middle_name, User_name, 
					primary_email, primary_telephone, function_role)
					
				VALUES(NEW.entity_id, rec.org_id,NEW.entity_name,(NEW.surname || ' ' || NEW.first_name || ' ' ||COALESCE(NEW.middle_name, '')), NEW.primary_email, NEW.phone, NEW.appointment_date)
			ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE members  SET full_names = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;   

CREATE TRIGGER ins_members BEFORE INSERT OR UPDATE ON members
  FOR EACH ROW  EXECUTE PROCEDURE ins_members();

  