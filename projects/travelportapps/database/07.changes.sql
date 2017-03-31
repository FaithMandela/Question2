CREATE OR REPLACE FUNCTION upd_passengers() RETURNS trigger AS	$$
	DECLARE
		base_val  char(50);
		yr 	integer;
		passenger_no char(4);
		v_policy_no integer;
		sequence_no char(50);
	BEGIN
		IF(NEW.approved = true) THEN
			NEW.approved_date = CURRENT_TIMESTAMP;
			v_policy_no := nextval('policy_no_seq');
			yr :=(SELECT to_char as year from to_char(current_timestamp, 'YY'));
			passenger_no := (SELECT TO_CHAR(v_policy_no,'fm0000'));

			sequence_no :=(SELECT policy_sequence_no from policy_sequence);
			base_val := trim(sequence_no || passenger_no || '-' || yr);
			NEW.policy_number := base_val;

			INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, narrative)
			VALUES(2,NEW.org_id,NEW.passenger_id,'passengers','Certificate Number:'||NEW.passenger_id||'\n\nPassanger Name:'||NEW.passenger_name);

		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;
