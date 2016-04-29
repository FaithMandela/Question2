

CREATE OR REPLACE FUNCTION ins_contrib()
  RETURNS trigger AS
$BODY$
DECLARE
	v_investment_amount			real;
	v_period_id					integer;
	v_org_id					integer;
	v_contribution_type_id		integer;
	v_merry_go_round_amount		real;
	 v_mgr_number				integer;
	 v_merry_go_round_number	integer;
	v_money_in					real;
	v_money_out					real;
	v_entity_id			integer;

BEGIN
	
	SELECT   org_id, contribution_type_id, SUM(investment_amount), SUM(merry_go_round_amount)
	INTO  v_org_id, v_contribution_type_id, v_money_in, v_money_out
	FROM contributions
		WHERE paid = true AND period_id = NEW.period_id 
		GROUP BY contribution_type_id,org_id;
	v_period_id := NEW.period_id;
	

		UPDATE contributions SET money_in  = v_money_in WHERE paid = true AND period_id =  v_period_id AND contribution_type_id = v_contribution_type_id;
			IF (v_money_out = 0)THEN
			UPDATE contributions SET money_out  = 0 WHERE paid = true AND period_id =  v_period_id AND contribution_type_id = v_contribution_type_id;
	ELSIF 	(v_money_out != 0)THEN
	
		SELECT mgr_number INTO v_mgr_number FROM periods  WHERE period_id = NEW.period_id AND org_id = v_org_id;
		SELECT entity_id, merry_go_round_number INTO v_entity_id, v_merry_go_round_number 
		FROM vw_member_contrib 
		WHERE merry_go_round_number = v_mgr_number;
		
			UPDATE contributions SET money_out  = v_money_out WHERE paid = true AND period_id =  v_period_id AND contribution_type_id = v_contribution_type_id AND entity_id = v_entity_id;
	
	END IF;

RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql
  
CREATE TRIGGER ins_contrib
AFTER INSERT OR UPDATE of paid
ON contributions
FOR EACH ROW
EXECUTE PROCEDURE ins_contrib();

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
  
CREATE TRIGGER ins_members
  BEFORE INSERT
  ON members
  FOR EACH ROW
  EXECUTE PROCEDURE ins_members();


CREATE OR REPLACE FUNCTION ins_inv()
  RETURNS trigger AS
$BODY$
DECLARE
total_cost 					real;
v_monthly_returns			real;
v_amount					real;
v_total_returns 			real;
v_total_payment				real;
v_m_payment					real;
v_repayment_period			real;
v_total_repayment_amount	real;
v_default_interest			real;

BEGIN

SELECT repayment_period, default_interest, monthly_returns, monthly_payments, total_payment, total_returns, total_repayment_amount INTO v_repayment_period, v_default_interest, v_monthly_returns, v_m_payment, v_total_payment, v_total_returns, v_total_repayment_amount 
FROM investments 
WHERE investment_id = NEW.investment_id;

	SELECT interest_amount INTO v_interests FROM  investment_types 
	WHERE investment_type_id = NEW. investment_type_id;
	
	NEW.default_interest := v_interests;
	v_amount = (New.total_cost * (v_interests/100)) ;
	NEW.total_repayment_amount := v_amount + New.total_cost;
	
	IF (v_m_payment is null) THEN
		NEW.monthly_payments = v_total_repayment_amount/v_repayment_period;
	ELSIF (v_repayment_period is null) THEN
		NEW.repayment_period = v_total_repayment_amount/v_m_payment;
	ELSIF (v_repayment_period AND v_m_payment is null) THEN
		RAISE EXECPTION 'Please enter the repayment period or the monthly payments';
	ELSEIF (v_m_payment is not null) THEN	
		v_total_payment  = COALESCE(v_m_payment, 0) + COALESCE(NEW.monthly_payments, 0);
		UPDATE investments SET monthly_payments = v_m_payment, total_payment = v_total_payment  WHERE is_complete = false AND investment_id = NEW.investment_id;
	END IF;
	END IF;
	END IF;
	END IF;
	
	IF (v_total_payment >= v_m_payment) THEN
		UPDATE investments SET is_complete = true WHERE is_complete = false;
	END IF;

	IF (v_monthly_returns is not null) THEN
		v_total_returns = COALESCE(v_total_returns, 0) + COALESCE(NEW.monthly_returns,0);
		UPDATE investments SET monthly_returns = v_monthly_returns, total_returns = v_total_returns WHERE investment_id = NEW.investment_id;

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

