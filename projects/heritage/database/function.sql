CREATE FUNCTION get_benefit_section_a(integer) RETURNS text AS $$
    SELECT individual AS result from vw_benefits WHERE rate_type_id = $1 AND benefit_section IN('1');
$$LANGUAGE SQL;
CREATE FUNCTION get_benefit_section_b(integer) RETURNS text AS $$
    SELECT individual AS result from vw_benefits WHERE rate_type_id = $1 AND benefit_section IN('1');
$$LANGUAGE SQL;

CREATE OR REPLACE FUNCTION ins_policy_number()  RETURNS trigger AS $$
DECLARE
  base_val  char(50);
  yr 	integer;
  passenger_no char(4);
  sequence_no char(50);
BEGIN
	yr := (SELECT to_char as year from to_char(current_timestamp, 'YY'));
	passenger_no := (SELECT TO_CHAR(NEW.passenger_id,'fm0000'));

	sequence_no :=(SELECT policy_sequence_no from policy_sequence);
	base_val := trim(11||yr||sequence_no || passenger_no);
	NEW.policy_number := base_val;
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
