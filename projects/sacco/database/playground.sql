
CREATE OR REPLACE FUNCTION ins_contributions()
  RETURNS trigger AS
$BODY$
DECLARE
v_contrib_amount	real;
v_loan vw_loans%rowtype;
BEGIN
v_contrib_amount := 0;
FOR v_loan IN
SELECT *
FROM vw_loans WHERE approve_status = 'Completed' AND is_closed = false AND entity_id = 0
LOOP
       -- for all loans insert loan repayment
RAISE NOTICE 'Loan Id : %' , v_loan.loan_id;
-- here you can check for balance to chose whether or not to close loan
INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
	v_contrib_amount := v_contrib_amount - v_loan.monthly_repayment;

INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
	
END LOOP;
NEW.contribution_amount = v_contrib_amount;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
