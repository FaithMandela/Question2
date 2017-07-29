
CREATE OR REPLACE FUNCTION ins_emailed_clients()  RETURNS trigger AS
$$
DECLARE
   v_entity_id		integer;
   v_org_id			integer;
   v_email			varchar(32);
   v_balance        real;
   rec              RECORD;
BEGIN
FOR rec IN SELECT entity_id, org_id, primary_email,client_code
FROM entitys
WHERE is_active is true LOOP

	IF(NEW.redeem is true) THEN
v_balance := getPointsBalance(rec.entity_id,rec.client_code);
	   IF(rec.primary_email is not null AND v_balance > 0.0) THEN

		   INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name)
		   VALUES(rec.org_id, 11, rec.entity_id, 'entitys');
	   END IF;
   END IF;
END LOOP;

   RETURN NULL;
END;
$$
  LANGUAGE plpgsql;

  CREATE TRIGGER ins_emailed_clients  AFTER UPDATE  ON periods
    FOR EACH ROW
    EXECUTE PROCEDURE ins_emailed_clients();
