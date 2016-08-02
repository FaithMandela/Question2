CREATE OR REPLACE FUNCTION ins_passengers()  RETURNS trigger AS
	$BODY$
	BEGIN
	 INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, narrative)
	 VALUES(2,NEW.org_id,NEW.passenger_id,'passengers','Certificate Number:'||NEW.passenger_id||'\n\nPassanger Name:'||NEW.passenger_name);

	RETURN NEW;
	END;
	$BODY$
	LANGUAGE plpgsql;
