

INSERT INTO pensions(entity_id, adjustment_id, contribution_id, org_id, 
	pension_company, pension_number, active, amount, use_formura, 
	employer_ps, employer_amount, employer_formural)
SELECT entity_id, adjustment_id, 35, org_id, 
	'BRITAM', trim(replace(narrative, 'BRITAM', '')), true, amount, false,
	0, 0, true
FROM default_adjustments
WHERE adjustment_id = 66 and amount > 0;

DELETE FROM default_adjustments WHERE adjustment_id = 35;
DELETE FROM default_adjustments WHERE adjustment_id = 66;

INSERT INTO pensions(entity_id, adjustment_id, contribution_id, org_id, 
	pension_company, pension_number, active, amount, use_formura, 
	employer_ps, employer_amount, employer_formural)
SELECT entity_id, adjustment_id, 71, org_id, 
	'BRITAM', trim(replace(narrative, 'BRITAM', '')), true, amount, false,
	0, 0, true
FROM default_adjustments
WHERE adjustment_id = 76 and amount > 0;

DELETE FROM default_adjustments WHERE adjustment_id = 76;
DELETE FROM default_adjustments WHERE adjustment_id = 71;


UPDATE pensions SET pension_company = 'JUBILEE', pension_number = 'PPP050149' WHERE entity_id = 47;


UPDATE employee_adjustments SET pension_id = aa.pension_id
FROM (SELECT vw_employee_adjustments.employee_adjustment_id, pensions.pension_id
FROM vw_employee_adjustments INNER JOIN pensions ON 
vw_employee_adjustments.entity_id = pensions.entity_id
WHERE vw_employee_adjustments.adjustment_id IN (35, 66, 71, 76)) as aa
WHERE employee_adjustments.employee_adjustment_id = aa.employee_adjustment_id;

DROP VIEW vw_loan_projection;
DROP VIEW vw_period_loans;
DROP VIEW vw_loan_payments;
DROP VIEW vw_loan_monthly;
DROP VIEW vw_loans;

CREATE VIEW vw_loans AS
	SELECT vw_loan_types.adjustment_id, vw_loan_types.adjustment_name, vw_loan_types.account_number,
		vw_loan_types.currency_id, vw_loan_types.currency_name, vw_loan_types.currency_symbol,
		vw_loan_types.loan_type_id, vw_loan_types.loan_type_name, 
		entitys.entity_id, entitys.entity_name, employees.employee_id,
		loans.org_id, loans.loan_id, loans.principle, loans.interest, loans.monthly_repayment, loans.reducing_balance, 
		loans.repayment_period, loans.application_date, loans.approve_status, loans.initial_payment, 
		loans.loan_date, loans.action_date, loans.details,
		get_repayment(loans.principle, loans.interest, loans.repayment_period) as repayment_amount, 
		loans.initial_payment + get_total_repayment(loans.loan_id) as total_repayment, get_total_interest(loans.loan_id) as total_interest,
		(loans.principle + get_total_interest(loans.loan_id) - loans.initial_payment - get_total_repayment(loans.loan_id)) as loan_balance,
		get_payment_period(loans.principle, loans.monthly_repayment, loans.interest) as calc_repayment_period
	FROM loans INNER JOIN entitys ON loans.entity_id = entitys.entity_id
		INNER JOIN employees ON loans.entity_id = employees.entity_id
		INNER JOIN vw_loan_types ON loans.loan_type_id = vw_loan_types.loan_type_id;

CREATE VIEW vw_loan_monthly AS
	SELECT  vw_loans.adjustment_id, vw_loans.adjustment_name, vw_loans.account_number,
		vw_loans.currency_id, vw_loans.currency_name, vw_loans.currency_symbol,
		vw_loans.loan_type_id, vw_loans.loan_type_name, 
		vw_loans.entity_id, vw_loans.entity_name, vw_loans.employee_id, vw_loans.loan_date,
		vw_loans.loan_id, vw_loans.principle, vw_loans.interest, vw_loans.monthly_repayment, vw_loans.reducing_balance, 
		vw_loans.repayment_period, vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.activated, vw_periods.closed,
		loan_monthly.org_id, loan_monthly.loan_month_id, loan_monthly.interest_amount, loan_monthly.repayment, loan_monthly.interest_paid, 
		loan_monthly.employee_adjustment_id, loan_monthly.penalty, loan_monthly.penalty_paid, loan_monthly.details,
		get_total_interest(vw_loans.loan_id, vw_periods.start_date) as total_interest,
		get_total_repayment(vw_loans.loan_id, vw_periods.start_date) as total_repayment,
		(vw_loans.principle + get_total_interest(vw_loans.loan_id, vw_periods.start_date + 1) + get_penalty(vw_loans.loan_id, vw_periods.start_date + 1)
		- vw_loans.initial_payment - get_total_repayment(vw_loans.loan_id, vw_periods.start_date + 1)) as loan_balance
	FROM loan_monthly INNER JOIN vw_loans ON loan_monthly.loan_id = vw_loans.loan_id
		INNER JOIN vw_periods ON loan_monthly.period_id = vw_periods.period_id;

CREATE VIEW vw_loan_payments AS
	SELECT vw_loans.adjustment_id, vw_loans.adjustment_name, vw_loans.account_number,
		vw_loans.currency_id, vw_loans.currency_name, vw_loans.currency_symbol,
		vw_loans.loan_type_id, vw_loans.loan_type_name, 
		vw_loans.entity_id, vw_loans.entity_name, vw_loans.employee_id, vw_loans.loan_date,
		vw_loans.loan_id, vw_loans.principle, vw_loans.interest, vw_loans.monthly_repayment, vw_loans.reducing_balance, 
		vw_loans.repayment_period, vw_loans.application_date, vw_loans.approve_status, vw_loans.initial_payment, 
		vw_loans.org_id, vw_loans.action_date,
		generate_series(1, repayment_period) as months,
		get_loan_period(principle, interest, generate_series(1, repayment_period), repayment_amount) as loan_balance, 
		(get_loan_period(principle, interest, generate_series(1, repayment_period) - 1, repayment_amount) * (interest/1200)) as loan_intrest 
	FROM vw_loans;

CREATE VIEW vw_period_loans AS
	SELECT vw_loan_monthly.org_id, vw_loan_monthly.period_id, 
		sum(vw_loan_monthly.interest_amount) as sum_interest_amount, sum(vw_loan_monthly.repayment) as sum_repayment, 
		sum(vw_loan_monthly.penalty) as sum_penalty, sum(vw_loan_monthly.penalty_paid) as sum_penalty_paid, 
		sum(vw_loan_monthly.interest_paid) as sum_interest_paid, sum(vw_loan_monthly.loan_balance) as sum_loan_balance
	FROM vw_loan_monthly
	GROUP BY vw_loan_monthly.org_id, vw_loan_monthly.period_id;
	
CREATE VIEW vw_loan_projection AS
	SELECT org_id, loan_id, loan_type_name, entity_name, principle, monthly_repayment, loan_date, 
		(EXTRACT(YEAR FROM age(current_date, '2010-05-01')) * 12) + EXTRACT(MONTH FROM age(current_date, loan_date)) as loan_months,
		get_total_repayment(loan_id, CAST((EXTRACT(YEAR FROM age(current_date, '2010-05-01')) * 12) + EXTRACT(MONTH FROM age(current_date, loan_date)) as integer)) as loan_paid
	FROM vw_loans;	
	