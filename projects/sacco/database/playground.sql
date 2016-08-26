alter table contributions add additional_payments real not null default 0;
alter table loan_monthly add additional_payments real not null default 0;


CREATE OR REPLACE FUNCTION get_total_repayment(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment + interest_paid + penalty_paid - additional_payments) is null THEN 0 
		ELSE sum(repayment + interest_paid + penalty_paid - additional_payments) END
	FROM loan_monthly
	WHERE (loan_id = $1);
$$ LANGUAGE SQL;


 CREATE OR REPLACE FUNCTION generate_contributions(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_period_id			integer;
	v_org_id			integer;
	msg					varchar(120);
BEGIN

	SELECT period_id, org_id INTO v_period_id, v_org_id
	FROM periods
	WHERE (period_id = $1::integer);
	
	--DELETE FROM contributions WHERE period_id = v_period_id;

	INSERT INTO loan_monthly (period_id, org_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_period_id, org_id, loan_id, monthly_repayment, (loan_balance * interest / 1200), (loan_balance * interest / 1200)
	FROM vw_loans 
	WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  true) AND (org_id = v_org_id);

	INSERT INTO loan_monthly (period_id, org_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_period_id, org_id, loan_id, monthly_repayment, (principle * interest / 1200), (principle * interest / 1200)
	FROM vw_loans 
	WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  false) AND (org_id = v_org_id);

	msg := 'Loans re-computed';
	
	
	INSERT INTO contributions(period_id, org_id, entity_id, , payment_type_id, contribution_type_id, 
            , entity_name, contribution_amount, loan_repayment, deposit_date, 
            deposit_amount, entry_date, transaction_ref, narrative, additional_payments)
		SELECT v_period_id, org_id,entity_id 0,0, entity_name
		from vw_contributions_month
		where (for_repayment = 'True')
		
    VALUES (?, ?, ?, ?, ?, 

	RETURN msg;
END;
$$ LANGUAGE plpgsql;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 REATE OR REPLACE FUNCTION compute_contributions(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	v_period_id			integer;
	v_org_id			integer;
	msg					varchar(120);
BEGIN

	SELECT period_id, org_id INTO v_period_id, v_org_id
	FROM periods
	WHERE (period_id = $1::integer);
	
	DELETE FROM contributions WHERE period_id = v_period_id;

	INSERT INTO contributions (period_id, org_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_period_id, org_id, loan_id, monthly_repayment, (loan_balance * interest / 1200), (loan_balance * interest / 1200)
	FROM vw_loans 
	WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  true) AND (org_id = v_org_id);

	INSERT INTO loan_monthly (period_id, org_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_period_id, org_id, loan_id, monthly_repayment, (principle * interest / 1200), (principle * interest / 1200)
	FROM vw_loans 
	WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  false) AND (org_id = v_org_id);

	msg := 'Loans re-computed';

	RETURN msg;
END;
$BODY$
  LANGUAGE plpgsql
