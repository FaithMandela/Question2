CREATE OR REPLACE FUNCTION emailed_dob(integer,character varying)RETURNS character varying AS $$
DECLARE
  v_org_id                integer;
  v_entity_name            varchar(120);
  v_sms_number		varchar(25);
BEGIN
  SELECT org_id, entity_name, primary_telephone INTO v_org_id, v_entity_name, v_sms_number
  FROM entitys WHERE (entity_id = $2::int);
  INSERT INTO sms (folder_id, entity_id, org_id, sms_number, message)
  VALUES (0,$2::int, v_org_id, v_sms_number, 'Its birthday for ' || v_entity_name);

  RETURN 'Done';
END;
$$
  LANGUAGE plpgsql;
