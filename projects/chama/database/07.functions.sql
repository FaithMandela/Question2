
CREATE OR REPLACE FUNCTION ins_periods()
  RETURNS trigger AS
$BODY$
DECLARE
	v_period_id		integer;
	v_mgr_number	integer;
	v_org_id		integer;
	v_merry_go_round_number	integer;
BEGIN
	
	IF (NEW.approve_status = 'Approved') THEN
		NEW.opened = false;
		NEW.activated = false;
		NEW.closed = true;
	END IF;
	
	IF(TG_OP = 'INSERT')THEN
		SELECT mgr_number, org_id INTO v_mgr_number, v_org_id
		FROM periods
		WHERE (period_id = (SELECT max(period_id) FROM periods WHERE org_id = NEW.org_id));
		
		IF(v_mgr_number is null)THEN
			SELECT min(merry_go_round_number) INTO v_mgr_number
			FROM members
			WHERE org_id = NEW.org_id;
			
		ELSE
			v_mgr_number := v_mgr_number + 1;
		END IF;
		
		SELECT merry_go_round_number INTO v_merry_go_round_number 
		FROM members
		WHERE org_id = NEW.org_id and merry_go_round_number = v_mgr_number;
		
		IF (v_merry_go_round_number is null) THEN
			SELECT min(merry_go_round_number) INTO v_merry_go_round_number 
			FROM members
			WHERE org_id = NEW.org_id and merry_go_round_number > v_mgr_number;
	
			v_mgr_number := v_merry_go_round_number;
		END IF;
		
		NEW.mgr_number := v_mgr_number;
	END IF;


	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql 
  
  CREATE TRIGGER ins_contribs
  AFTER INSERT OR UPDATE of paid
  ON contributions
  FOR EACH ROW
  EXECUTE PROCEDURE ins_contribs();

  CREATE OR REPLACE FUNCTION generate_contribs(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	rec						RECORD;
	v_period_id		integer;
	vi_period_id		integer;
	reca			RECORD;
	v_org_id		integer;
	v_month_name	varchar(50);
	v_member_id		integer;

	msg 			varchar(120);
BEGIN
	SELECT period_id, org_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
	FROM periods
	WHERE (period_id = $1::integer);

	SELECT period_id INTO vi_period_id FROM contributions WHERE period_id in (v_period_id) AND org_id in (v_org_id);

	IF( vi_period_id is null) THEN

	FOR reca IN SELECT member_id, entity_id FROM members WHERE (org_id = v_org_id) LOOP
	
	FOR rec IN SELECT org_id, frequency, contribution_type_id, investment_amount, merry_go_round_amount 
	FROM contribution_types WHERE (applies_to_all = true)  AND (org_id = v_org_id) LOOP
		IF (rec.frequency = 'Weekly') THEN
		FOR i in 1..4 LOOP
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount, member_id, entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END LOOP;
		END IF;
		IF (rec.frequency = 'Fortnightly') THEN
		FOR i in 1..2 LOOP
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id, entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END LOOP;
		END IF;
		IF (rec.frequency = 'Monthly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
	
	END LOOP;
	
	END LOOP;
	msg := 'Contributions Generated';
	ELSE
	msg := 'Contributions already exist';
	END IF;
	

RETURN msg;	
END;
$BODY$
  LANGUAGE plpgsql
  
CREATE OR REPLACE FUNCTION ins_investments()
  RETURNS trigger AS
$BODY$
DECLARE
	v_investment_amount		real;
	v_total_cost			real;
    v_amount				real;
    v_total_payment			real;
    v_m_payment				real;
	v_monthly_returns		real;
    v_period                real;
    v_interests		        real;
BEGIN

		SELECT sum(investment_amount) INTO v_investment_amount FROM contributions
		WHERE org_id = New.org_id AND period_id = NEW.period_id;
		SELECT total_payment INTO v_m_payment FROM investments WHERE is_complete = false;
		

IF (v_investment_amount is not null) THEN	
	v_total_payment  = COALESCE(v_m_payment, 0) + COALESCE(v_investment_amount, 0);

	UPDATE investments SET monthly_payments = v_investment_amount, total_payment = v_total_payment  WHERE is_complete = false;

	
	IF (v_total_payment >= v_m_payment) THEN
	UPDATE investments SET is_complete = true WHERE is_complete = false;

	END IF;
END IF;
		

RETURN NEW;
END;
$BODY$

CREATE TRIGGER ins_investments
  AFTER INSERT OR UPDATE
  ON contributions
  FOR EACH ROW
  EXECUTE PROCEDURE ins_investments();

 CREATE OR REPLACE FUNCTION ins_members()
  RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
	
BEGIN
	IF (TG_OP = 'INSERT') THEN
	NEW.entity_id := nextval('entitys_entity_id_seq');
	
	INSERT INTO entitys (entity_id,entity_name,org_id,entity_type_id,user_name,primary_email,primary_telephone,function_role,details)
	VALUES (New.entity_id,New.surname,New.org_id::INTEGER,1,NEW.email,NEW.email,NEW.phone,'member',NEW.details) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;

	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE members  SET full_name = 
(NEW.Surname || ' ' 
|| NEW.First_name || ' ' 
|| COALESCE(NEW.Middle_name, ''))
	WHERE entity_id = NEW.entity_id;
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
  
CREATE TRIGGER ins_meeting
  BEFORE INSERT OR UPDATE
  ON meetings
  FOR EACH ROW
  EXECUTE PROCEDURE ins_meeting();

CREATE OR REPLACE FUNCTION ins_inv()
  RETURNS trigger AS
$BODY$
DECLARE
v_monthly_returns		real;
v_total_returns 		real;

BEGIN
v_total_returns := null;
SELECT monthly_returns, total_returns INTO v_monthly_returns, v_total_returns FROM investments where investment_id = NEW.investment_id;

IF (v_monthly_returns is not null) THEN
v_total_returns = COALESCE(v_total_returns, 0) + COALESCE(NEW.monthly_returns,0);

END IF;

IF(v_total_returns is not null)THEN
UPDATE investments SET total_returns = v_total_returns where investment_id = NEW.investment_id;

END IF;

RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_inv
  AFTER INSERT OR UPDATE OF monthly_returns
  ON investments
  FOR EACH ROW
  EXECUTE PROCEDURE ins_inv();

