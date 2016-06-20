
CREATE OR REPLACE FUNCTION ins_contributions()
  RETURNS trigger AS
$BODY$
DECLARE
v_contrib_amount	real;
v_loan vw_loans%rowtype;
BEGIN
FOR v_loan IN SELECT * FROM vw_loans WHERE approve_status = 'Approved'
LOOP
INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
	
INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
END LOOP;

NEW.contribution_amount = NEW.deposit_amount - v_loan.monthly_repayment; 


INSERT INTO investments (entity_id,investment_type_id, org_id, invest_amount, period_years)
VALUES (New.entity_id, 0,New.org_id,NEW.contribution_amount,4);

   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

  
  
  
  CREATE OR REPLACE FUNCTION get_payment_period(real, real, real) RETURNS real AS $$
DECLARE
	paymentperiod real;
	q real;
BEGIN
	q := $3/1200;
	
	IF ($2 = 0) OR (q = -1) OR ((q * $1) >= $2) THEN
		paymentperiod := 1;
	ELSIF (log(q + 1) = 0) THEN
		paymentperiod := 1;
	ELSE
		paymentperiod := (log($2) - log($2 - (q * $1))) / log(q + 1);
	END IF;

	RETURN paymentperiod;
END;
$$ LANGUAGE plpgsql;







CREATE OR REPLACE FUNCTION get_investments(varchar(12)) RETURNS varchar(120) AS $$
DECLARE
investments real;
BEGIN

	SELECT investment_amount FROM investments WHERE (investment_id = CAST($1 as int)) into investments;
	RETURN real;
END;
