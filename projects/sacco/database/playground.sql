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
		
	SELECT CASE WHEN  sum(contribution_paid) IS NULL THEN 0   
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



CREATE OR REPLACE FUNCTION get_total_repayment(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment + interest_paid + penalty_paid - additional_payments) is null THEN 0 
		ELSE sum(repayment + interest_paid + penalty_paid - additional_payments) END
	FROM loan_monthly
	WHERE (loan_id = $1);
$$ LANGUAGE SQL;
