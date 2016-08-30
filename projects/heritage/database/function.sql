CREATE FUNCTION get_benefit_section_a(integer) RETURNS text AS $$
    SELECT individual AS result from vw_benefits WHERE rate_type_id = $1 AND benefit_section IN('1');
$$LANGUAGE SQL;
CREATE FUNCTION get_benefit_section_b(integer) RETURNS text AS $$
    SELECT individual AS result from vw_benefits WHERE rate_type_id = $1 AND benefit_section IN('1');
$$LANGUAGE SQL;

CREATE OR REPLACE FUNCTION ins_policy_number()  RETURNS trigger AS $$
DECLARE
  base_val          char(50);
  yr 	             char(4);
  passenger_no      char(4);
  sequence_no       char(50);
  v_policy_no       integer;
BEGIN
	yr := (SELECT to_char as year from to_char(current_timestamp, 'YY'));
    IF (NEW.incountry is false) THEN
        v_policy_no := nextval('policy_no_seq');
    	passenger_no := (SELECT TO_CHAR(v_policy_no,'fm0000'));
    	sequence_no :=(SELECT policy_sequence_no from policy_sequence);
    	base_val := trim(11||yr||sequence_no || passenger_no);
    	NEW.policy_number := base_val;
    END IF;

    IF(NEW.incountry is true)THEN
        v_policy_no := nextval('policy_no_incountry_seq');
        passenger_no := (SELECT TO_CHAR(v_policy_no,'fm0000'));
        sequence_no :=(SELECT policy_sequence_no from policy_sequence);
        base_val := trim(12||yr||sequence_no || passenger_no);
        NEW.policy_number := base_val;
    END IF;
	RETURN NEW ;
END;
$$
LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION ins_passengers() RETURNS trigger AS $$
BEGIN
	INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, narrative)
	VALUES(2, NEW.org_id, NEW.passenger_id, 'passengers','Policy Number:'||NEW.policy_number||'\n\nPassanger Name:'||NEW.passenger_name);

RETURN NEW;
END;
$$
  LANGUAGE plpgsql;


  CREATE TRIGGER ins_passengers
    BEFORE INSERT
    ON passengers
    FOR EACH ROW
    EXECUTE PROCEDURE ins_passengers();

CREATE TRIGGER ins_policy_number
    BEFORE INSERT
    ON passengers
    FOR EACH ROW
    EXECUTE PROCEDURE ins_policy_number();



CREATE OR REPLACE FUNCTION upd_passenger(varchar(20),varchar(20),varchar(20),varchar(20)) RETURNS varchar(120) AS $$
DECLARE
	msg 		varchar(50);
BEGIN
	IF ($3::integer = 1) THEN

		UPDATE passengers SET approved = false WHERE passenger_id = $1::integer;
		msg := 'Emergency Card Canceled Successfully';
	END IF;

	IF($3::integer = 2)THEN
    UPDATE passengers SET approved = true WHERE passenger_id = $1::integer;
    msg := 'Emergency Card Reverted Successfully';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;


CREATE SEQUENCE policy_no_seq  INCREMENT 1  MINVALUE 1  MAXVALUE 9223372036854775807  START 1  CACHE 1;
CREATE SEQUENCE policy_no_incountry_seq  INCREMENT 1  MINVALUE 1  MAXVALUE 9223372036854775807  START 1  CACHE 1;
