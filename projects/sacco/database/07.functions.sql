
ALTER TABLE members DROP contribution cascade;

alter table members ADD contribution real not null default 0;

alter table contributions add receipt real default 0 ;
alter table contributions add receipt_date date;

alter table contributions add  contribution_paid real not null default 0;

alter table contributions add repayment_paid real default 0 not null;
alter table loan_monthly add repayment_paid real default 0 not null;

ALTER TABLE contributions ALTER COLUMN contribution_amount SET DEFAULT 0;


DROP FUNCTION compute_contributions(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION compute_contributions(
    v_period_id character varying,
    v_org_id character varying,
    v_approval character varying)
  RETURNS character varying AS
$BODY$
DECLARE
    msg                 varchar(120);
BEGIN
    DELETE FROM loan_monthly WHERE period_id = v_period_id::integer AND org_id = v_org_id::integer;
    
    
    DELETE FROM contributions WHERE period_id = v_period_id::integer;

    
    INSERT INTO contributions(period_id, org_id, entity_id,  payment_type_id, contribution_type_id, 
            entity_name, receipt,  entry_date,
             transaction_ref, deposit_amount,is_paid)
		
             
    SELECT v_period_id::integer, org_id::integer,entity_id, 0,0, first_name, contribution,  
            now()::date, 'Auto generated', 0, 'False'
        FROM members;
msg = ' Its done';
    
    RETURN msg;
END;
$BODY$
   LANGUAGE plpgsql;
   
   
CREATE OR REPLACE FUNCTION get_balance_new ( entity_id integer)   RETURNS real AS
  $$
DECLARE
     	
		v_loans 			real;
		v_contributions 	real;
		v_receipt 			real;
		balance 			real;
BEGIN
	SELECT CASE WHEN sum(loan_monthly.penalty_paid + loan_monthly.interest_paid + loan_monthly.repayment_paid) IS NULL THEN 0
		ELSE sum(loan_monthly.penalty_paid + loan_monthly.interest_paid + loan_monthly.repayment_paid) END 
		INTO v_loans
		FROM loan_monthly INNER JOIN loans ON loan_monthly.loan_id = loans.loan_id
		WHERE(loans.entity_id = $1);
		
	SELECT CASE WHEN  sum(contribution_paid ) IS NULL THEN 0   
	ELSE sum(contribution_paid) END 
	 INTO v_contributions
		FROM contributions
		WHERE (contributions.entity_id = $1);
		
	SELECT CASE WHEN sum (receipt) IS NULL THEN 0
		ELSE sum (receipt)  END
		INTO  v_receipt
			FROM contributions
			WHERE (contributions.entity_id = $1);
	
	balance = v_receipt - (v_loans + v_contributions) ;
		IF(balance is null)THEN balance = 0; END IF;
	
	RETURN balance;
	END;
$$ LANGUAGE plpgsql;


 
CREATE OR REPLACE FUNCTION get_balances ( entity_id integer)   RETURNS real AS
  $$
DECLARE
     	
		v_loans 			real;
		v_contributions 	real;
		v_receipt 			real;
		balance 			real;
BEGIN

	SELECT sum(contribution_paid), sum (receipt) INTO v_contributions, v_receipt
		FROM contributions
		WHERE (contributions.entity_id = $1);
	
	balance = v_receipt - v_contributions;
		IF(balance is null)THEN balance = 0; END IF;
	
	RETURN balance;
	END;
$$ LANGUAGE plpgsql;

  
CREATE OR REPLACE FUNCTION compute_contributions(v_period_id varchar(12), v_org_id varchar(12), v_approval varchar(12)) RETURNS varchar(120) AS $$
DECLARE
    msg                 varchar(120);
BEGIN
	msg := 'Contributions generated';
    DELETE FROM loan_monthly WHERE period_id = v_period_id::integer AND org_id =  v_org_id::integer AND is_paid = false ;
    DELETE FROM contributions WHERE period_id = v_period_id::integer;
    
    INSERT INTO contributions(period_id, org_id, entity_id,  payment_type_id, contribution_type_id, 
             contribution_amount,  entry_date,
             transaction_ref, is_paid)
             
    SELECT v_period_id::integer, org_id::integer ,entity_id, 0,0,  contribution,
            now()::date, 'Auto generated','False'
        FROM members;

    RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_total_repayment(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment_paid + interest_paid + penalty_paid) is null THEN 0 
		ELSE sum(repayment_paid + interest_paid + penalty_paid) END
	FROM loan_monthly
	WHERE (loan_id = $1);
$$ LANGUAGE SQL;

DROP VIEW vw_contributions cascade;


   
CREATE OR REPLACE FUNCTION get_total_repayment(integer, integer) RETURNS real AS $$
	SELECT sum(interest_paid + penalty_paid + repayment_paid)
	FROM loan_monthly
	WHERE (loan_id = $1) and (loan_month_id <= $2);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION get_loan_balance (integer, integer) RETURNS double precision AS $$
	SELECT sum(monthly_repayment + loan_intrest)
	FROM vw_loan_payments 
	WHERE (loan_id = $1) and (months <= $2);
$$ LANGUAGE SQL;

ALTER TABLE contributions ADD COLUMN additional_funds integer references additional_funds ;

CREATE INDEX contributions_additional_funds ON contributions (additional_funds_id);
   
 DROP TRIGGER ins_contributions on contributions;
 
CREATE OR REPLACE FUNCTION ins_contributions() RETURNS trigger AS $$
DECLARE
	v_amount				real;
	reca					RECORD;
	v_loans					real;
	v_contributions			real;
	v_penalty				real;
	v_intrest				real;
	v_repayment				real;
	v_contribution			real;
BEGIN
	IF((NEW.is_paid = true) AND (NEW.receipt > 0))THEN
	IF (New.receipt_date IS NULL) THEN New.receipt_date = now()::date; END IF;
		
		NEW.deposit_amount= NEW.receipt;
		-- get 
	
			--- Compute the full previous balance
		SELECT sum(loan_monthly.penalty_paid + loan_monthly.interest_paid + loan_monthly.repayment_paid)
			INTO v_loans
		FROM loan_monthly INNER JOIN loans ON loan_monthly.loan_id = loans.loan_id
			INNER JOIN periods ON loan_monthly.period_id = periods.period_id
		WHERE (loans.entity_id = NEW.entity_id) AND (periods.end_date <= NEW.entry_date);
		IF(v_loans is null)THEN v_loans = 0; END IF;
		--Get new  amount on previous contributions 
		
		SELECT sum(contributions.receipt - contributions.contribution_paid+ additional_funds.additional_amount) INTO v_contributions
		FROM contributions INNER JOIN periods ON contributions.period_id = periods.period_id INNER JOIN  additional_funds ON additional_funds.contribution_id = contributions.contribution_id
		WHERE (contributions.contribution_id <> NEW.contribution_id) AND (contributions.entity_id = NEW.entity_id)
			AND (periods.end_date <= NEW.entry_date);
		IF(v_contributions is null)THEN v_contributions = 0; END IF;
		
		v_amount := NEW.receipt + v_contributions - v_loans;
		
	
		FOR reca IN SELECT loan_monthly.loan_id, sum(loan_monthly.penalty - loan_monthly.penalty_paid) as s_penalty, 
				sum(loan_monthly.interest_amount - loan_monthly.interest_paid) as s_intrest, 
				sum(loan_monthly.repayment - loan_monthly.repayment_paid) as s_repayment
			FROM loan_monthly INNER JOIN loans ON loan_monthly.loan_id = loans.loan_id
			WHERE (loans.entity_id = NEW.entity_id)
			GROUP BY loan_monthly.loan_id
		LOOP
			v_penalty := reca.s_penalty;
 			v_intrest := reca.s_intrest;
			v_repayment := reca.s_repayment;
		
			IF(v_penalty > 0)THEN
				IF(v_penalty <= v_amount)THEN
					v_amount := v_amount - v_penalty;
					
				ELSE
					v_penalty := v_amount;
					v_amount := 0;
				END IF;
			END IF;

			IF(v_intrest > 0)THEN
				IF(v_intrest <= v_amount)THEN
					v_amount := v_amount - v_intrest;
				ELSE
					v_intrest := v_amount;
					v_amount := 0;
				END IF;
			END IF;

			IF(v_repayment > 0)THEN
				IF(v_repayment <= v_amount)THEN
					v_amount := v_amount - v_repayment;
				ELSE
					v_repayment := v_amount;
					v_amount := 0;
				END IF;
			END IF;
			IF (v_intrest is null) THEN v_intrest = 0; END IF;
			UPDATE loan_monthly SET penalty_paid = v_penalty, interest_paid = v_intrest, repayment_paid = v_repayment, is_paid = true
			WHERE loan_id = reca.loan_id AND period_id = NEW.period_id;
		END LOOP;
		
		-- get sum before doing the insert not to affect current insert 

		
		SELECT sum(contribution_amount - contribution_paid +  additional_funds.additional_amount) INTO v_contribution
		FROM contributions INNER JOIN periods ON contributions.period_id = periods.period_id  INNER JOIN  additional_funds on additional_funds.contribution_id = contributions.contribution_id
		WHERE (contributions.contribution_id <> NEW.contribution_id) AND (contributions.entity_id = NEW.entity_id)
			AND (periods.end_date <= NEW.entry_date);
		IF(v_contribution is null)THEN v_contribution = 0; END IF;
		
		Raise notice 'this contribution ni hii %', v_contribution;
		Raise notice ' contribution ni hii %', NEW.contribution_amount;
		
		v_contribution := v_contribution + NEW.contribution_amount;
		
		Raise notice ' contribution ni hii %', v_contribution;
		Raise notice ' Amount ni hii %', v_amount;
		
		IF(v_contribution > 0)THEN
			IF(v_contribution <= v_amount)THEN
				NEW.contribution_paid := v_contribution;
			ELSE
				IF(v_amount is null)THEN v_amount = 0; END IF;
				NEW.contribution_paid := v_amount;
			END IF;
		END IF;
		
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
  
CREATE TRIGGER ins_contributions BEFORE INSERT OR UPDATE  ON contributions FOR EACH ROW
EXECUTE PROCEDURE ins_contributions();






CREATE OR REPLACE VIEW vw_contributions AS 
 SELECT contributions.contribution_id,
    contributions.org_id,
    contributions.entity_id,
    contributions.period_id,
    contributions.payment_type_id,
    contributions.receipt,
    contributions.receipt_date,
    
     contributions.entry_date,
    contributions.transaction_ref,
    contributions.contribution_amount,
    contributions.contribution_paid,
    contributions.deposit_amount,
    contributions.deposit_date AS deposit_dates,
    contributions.is_paid,
    entitys.entity_name,
    entitys.is_active AS member_is_active,
    contribution_types.contribution_type_id,
    contribution_types.contribution_type_name,
    payment_types.payment_type_name,
    payment_types.payment_narrative,
    get_balance_new (contributions.entity_id) AS active_balance,
    to_char(periods.start_date::timestamp with time zone, 'YYYY'::text) AS deposit_year,
    to_char(periods.start_date::timestamp with time zone, 'Month'::text) AS deposit_date
   FROM contributions
     JOIN entitys ON contributions.entity_id = entitys.entity_id
     JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
     JOIN payment_types ON payment_types.payment_type_id = contributions.payment_type_id
     JOIN periods ON contributions.period_id = periods.period_id;


  



   CREATE OR REPLACE VIEW vw_contributions_month AS 
SELECT vw_periods.period_id,
    vw_periods.start_date,
    vw_periods.end_date,
    vw_periods.overtime_rate,
    vw_periods.activated,
    vw_periods.closed,
    vw_periods.month_id,
    vw_periods.period_year,
    vw_periods.period_month,
    vw_periods.quarter,
    vw_periods.semister,
    vw_periods.bank_header,
    vw_periods.bank_address,
    vw_periods.is_posted,
    contributions.contribution_id,
    contributions.org_id,
     contributions.entity_id,
    contributions.payment_type_id,
     contributions.contribution_amount,
      contributions.contribution_paid ,
    contributions.deposit_amount,
	contributions.entry_date,
	contributions.transaction_ref,
      contributions.is_paid,
    get_balance_new(contributions.entity_id) AS active_balance,
	members.contribution AS intial_contribution,
    members.first_name,
    members.expired,
    contribution_types.contribution_type_id,
    contribution_types.contribution_type_name,
    payment_types.payment_type_name,
    payment_types.payment_narrative,
    to_char(vw_periods.start_date::timestamp with time zone, 'YYYY'::text) AS year,
    to_char(vw_periods.start_date::timestamp with time zone, 'Month'::text) AS deposit_date
   FROM contributions
     JOIN members ON contributions.entity_id = members.entity_id
     JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
     JOIN payment_types ON payment_types.payment_type_id = contributions.payment_type_id
     JOIN vw_periods ON contributions.period_id = vw_periods.period_id;
   
	
	

	
 -
	
	
