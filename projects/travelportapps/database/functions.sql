
CREATE FUNCTION ins_policy_number() RETURNS trigger AS $$
	DECLARE
	  base_val  char(50);
	  yr 	integer;
	  passenger_no char(4);
	  v_policy_no integer;
	  sequence_no char(50);
	BEGIN
	IF(NEW.approved is true)THEN
		v_policy_no := nextval('policy_no_seq'),
		yr :=(SELECT to_char as year from to_char(current_timestamp, 'YY'));
		passenger_no := (SELECT TO_CHAR(v_policy_no,'fm0000'));

		sequence_no :=(SELECT policy_sequence_no from policy_sequence);
		base_val := trim(sequence_no || passenger_no || '-' || yr);
		NEW.policy_number := base_val;
		END IF;
		RETURN NEW;
END; $$ LANGUAGE plpgsql;


CREATE TRIGGER ins_policy_number
  BEFORE INSERT ON passengers
  FOR EACH ROW EXECUTE PROCEDURE ins_policy_number();


      CREATE OR REPLACE FUNCTION upd_passengers()
        RETURNS trigger AS
      	$BODY$
      	DECLARE
      	BEGIN
      	IF(NEW.approved = true) THEN
      		NEW.approved_date = CURRENT_TIMESTAMP;
      	END IF;
      	RETURN NEW;
      	END;
      	$BODY$
        LANGUAGE plpgsql VOLATILE
        COST 100;



CREATE OR REPLACE FUNCTION ins_passengers()  RETURNS trigger AS
	$BODY$
	BEGIN
	 INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, narrative)
	 VALUES(1,NEW.org_id,NEW.passenger_id,'passengers','Certificate Number:'||NEW.passenger_id||'\n\nPassanger Name:'||NEW.passenger_name);

	RETURN NEW;
	END;
	$BODY$
	LANGUAGE plpgsql;

CREATE TRIGGER ins_passengers AFTER INSERT ON passengers
FOR EACH ROW  EXECUTE PROCEDURE ins_passengers();
