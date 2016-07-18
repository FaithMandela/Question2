CREATE OR REPLACE FUNCTION upd_bonus( character varying, character varying,  character varying,  character varying)
 RETURNS character varying AS $$
DECLARE
ps		varchar(16);
msg		varchar(50);
BEGIN
	ps := 'Approved';
	UPDATE bonus SET approve_status = ps WHERE (bonus_id = $1::int);
	msg := 'Bonus Approved';
	RETURN msg;
END;
$$
  LANGUAGE plpgsql;
