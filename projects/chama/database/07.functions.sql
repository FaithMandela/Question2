CREATE OR REPLACE FUNCTION ins_contribs() RETURNS trigger AS
$$
DECLARE
	v_investment_amount			real;
	v_period_id					integer;
	v_contribution_type_id			integer;
	v_merry_go_round_amount		real;
	v_money_in					real;
	v_money_out					real;

BEGIN

	SELECT  period_id, contribution_type_id, SUM(investment_amount), merry_go_round_amount
	INTO v_period_id, v_contribution_type_id, v_money_in, v_merry_go_round_amount
		FROM contributions
		WHERE paid = true AND period_id = NEW.period_id 
		GROUP BY period_id,contribution_type_id, merry_go_round_amount;
	
		UPDATE contributions SET money_in  = v_money_in WHERE paid = true AND period_id =  v_period_id AND contribution_type_id = v_contribution_type_id;
RETURN NEW;
END;
$$
  LANGUAGE plpgsql;

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
	reca			RECORD;
	v_org_id		integer;
	v_month_name	varchar(50);

	msg 			varchar(120);
BEGIN
	SELECT period_id, org_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
	FROM periods
	WHERE (period_id = $1::integer);

	FOR reca IN SELECT entity_id FROM entitys WHERE (org_id = v_org_id) LOOP
		
	FOR rec IN SELECT org_id, contribution_type_id, investment_amount, merry_go_round_amount 
	FROM contribution_types WHERE (applies_to_all = true)  AND (org_id = v_org_id) LOOP
		
		INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,entity_id)
		VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
		 reca.entity_id);
	
	END LOOP;
	
	END LOOP;
	msg := 'Contributions Generated';

	RETURN msg;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE


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

