ALTER TABLE tax_types ADD 	tax_type_number			varchar(50);

DROP VIEW vw_payroll_ledger;
DROP VIEW vw_payroll_ledger_trx;
DROP VIEW vw_employee_tax_types;
DROP VIEW vw_default_tax_types;
DROP VIEW vw_period_tax_types;
DROP VIEW vw_tax_types;

CREATE VIEW vw_tax_types AS
	SELECT vw_accounts.account_type_id, vw_accounts.account_type_name, vw_accounts.account_id, vw_accounts.account_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		tax_types.org_id, tax_types.tax_type_id, tax_types.tax_type_name, tax_types.formural, tax_types.tax_relief, 
		tax_types.tax_type_order, tax_types.in_tax, tax_types.tax_rate, tax_types.tax_inclusive, tax_types.linear, 
		tax_types.percentage, tax_types.employer, tax_types.employer_ps, tax_types.account_number, tax_types.active, 
		tax_types.tax_type_number, tax_types.use_key, tax_types.details
	FROM tax_types INNER JOIN currency ON tax_types.currency_id = currency.currency_id
		LEFT JOIN vw_accounts ON tax_types.account_id = vw_accounts.account_id;


CREATE VIEW vw_period_tax_types AS
	SELECT vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.overtime_rate,  
		vw_periods.activated, vw_periods.closed, vw_periods.month_id, vw_periods.period_year, vw_periods.period_month,
		vw_periods.quarter, vw_periods.semister,
		tax_types.tax_type_id, tax_types.tax_type_name, period_tax_types.period_tax_type_id, tax_types.tax_type_number,
		period_tax_types.period_tax_type_name, tax_types.use_key,
		period_tax_types.org_id, period_tax_types.Pay_Date, period_tax_types.tax_relief, period_tax_types.linear, period_tax_types.percentage, 
		period_tax_types.formural, period_tax_types.details
	FROM period_tax_types INNER JOIN vw_periods ON period_tax_types.period_id = vw_periods.period_id
		INNER JOIN tax_types ON period_tax_types.tax_type_id = tax_types.tax_type_id;
		
CREATE VIEW vw_default_tax_types AS
	SELECT entitys.entity_id, entitys.entity_name, 
		vw_tax_types.tax_type_id, vw_tax_types.tax_type_name, vw_tax_types.tax_type_number,
		vw_tax_types.currency_id, vw_tax_types.currency_name, vw_tax_types.currency_symbol,
		default_tax_types.default_tax_type_id, 
		default_tax_types.org_id, default_tax_types.tax_identification, default_tax_types.active, default_tax_types.narrative
	FROM default_tax_types INNER JOIN entitys ON default_tax_types.entity_id = entitys.entity_id
		INNER JOIN vw_tax_types ON default_tax_types.tax_type_id = vw_tax_types.tax_type_id;
		
		
CREATE VIEW vw_employee_tax_types AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.end_date, eml.gl_payroll_account,
		eml.entity_id, eml.entity_name, eml.employee_id, eml.identity_card,
		tax_types.tax_type_id, tax_types.tax_type_name, tax_types.account_id, tax_types.tax_type_number,
		employee_tax_types.org_id, employee_tax_types.employee_tax_type_id, employee_tax_types.tax_identification, 
		employee_tax_types.amount, 
		employee_tax_types.additional, employee_tax_types.employer, employee_tax_types.narrative,
		currency.currency_id, currency.currency_name, currency.currency_symbol, employee_tax_types.exchange_rate,
		
		(employee_tax_types.exchange_rate * employee_tax_types.amount) as base_amount,
		(employee_tax_types.exchange_rate * employee_tax_types.employer) as base_employer,
		(employee_tax_types.exchange_rate * employee_tax_types.additional) as base_additional
		
	FROM employee_tax_types INNER JOIN vw_employee_month_list as eml ON employee_tax_types.employee_month_id = eml.employee_month_id
		INNER JOIN tax_types ON (employee_tax_types.tax_type_id = tax_types.tax_type_id)
		INNER JOIN currency ON tax_types.currency_id = currency.currency_id;

CREATE VIEW vw_payroll_ledger_trx AS
	SELECT org_id, period_id, end_date, description, gl_payroll_account, entity_name, dr_amt, cr_amt 
	FROM 
	((SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'BASIC SALARY' as description, 
		vw_employee_month.gl_payroll_account, vw_employee_month.entity_name, 
		vw_employee_month.basic_pay as dr_amt, 0.0 as cr_amt
	FROM vw_employee_month)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'SALARY PAYMENTS',
		vw_employee_month.gl_bank_account, vw_employee_month.entity_name, 0.0 as sum_basic_pay, 
		vw_employee_month.banked as sum_banked
	FROM vw_employee_month
	WHERE (vw_employee_month.bank_branch_id <> 0) AND (vw_employee_month.banked <> 0))
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'PETTY CASH PAYMENTS', 
		'3305', vw_employee_month.entity_name, 0.0 as sum_basic_pay, vw_employee_month.banked as sum_banked
	FROM vw_employee_month
	WHERE (vw_employee_month.bank_branch_id = 0) AND (vw_employee_month.banked <> 0))
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_id::varchar(32), vw_employee_tax_types.entity_name, 0.0, 
		(vw_employee_tax_types.amount + vw_employee_tax_types.additional + vw_employee_tax_types.employer) 
	FROM vw_employee_tax_types)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, 'Employer - ' || vw_employee_tax_types.tax_type_name, 
		'8025', vw_employee_tax_types.entity_name, vw_employee_tax_types.employer, 0.0
	FROM vw_employee_tax_types
	WHERE (vw_employee_tax_types.employer <> 0))
	UNION
	(SELECT vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.adjustment_name, vw_employee_adjustments.account_number, 
		vw_employee_adjustments.entity_name,
		SUM(CASE WHEN vw_employee_adjustments.adjustment_type = 1 THEN vw_employee_adjustments.amount - vw_employee_adjustments.paid_amount ELSE 0 END) as dr_amt,
		SUM(CASE WHEN vw_employee_adjustments.adjustment_type = 2 THEN vw_employee_adjustments.amount - vw_employee_adjustments.paid_amount ELSE 0 END) as cr_amt
	FROM vw_employee_adjustments
	WHERE (vw_employee_adjustments.visible = true) AND (vw_employee_adjustments.adjustment_type < 3)
	GROUP BY vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.adjustment_name, vw_employee_adjustments.account_number, 
		vw_employee_adjustments.entity_name)
	UNION
	(SELECT vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, 'Transport' as description, 
		vw_employee_per_diem.post_account, vw_employee_per_diem.entity_name, 
		(vw_employee_per_diem.full_amount - vw_employee_per_diem.Cash_paid) as dr_amt, 0.0 as cr_amt
	FROM vw_employee_per_diem
	WHERE (vw_employee_per_diem.approve_status = 'Approved'))) as a
	ORDER BY gl_payroll_account desc, dr_amt desc, cr_amt desc;

CREATE VIEW vw_payroll_ledger AS
	SELECT org_id, period_id, end_date, description, gl_payroll_account, dr_amt, cr_amt 
	FROM 
	((SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'BASIC SALARY' as description, 
		vw_employee_month.gl_payroll_account, 
		sum(vw_employee_month.basic_pay) as dr_amt, 
		0.0 as cr_amt
	FROM vw_employee_month
	GROUP BY vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.gl_payroll_account)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'SALARY PAYMENTS',
		vw_employee_month.gl_bank_account, 0.0 as sum_basic_pay, sum(vw_employee_month.banked) as sum_banked
	FROM vw_employee_month
	WHERE (vw_employee_month.bank_branch_id <> 0) AND (vw_employee_month.banked <> 0)
	GROUP BY vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.gl_bank_account)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'PETTY CASH PAYMENTS', 
		'3305', 0.0 as sum_basic_pay, sum(vw_employee_month.banked) as sum_banked
	FROM vw_employee_month
	WHERE (vw_employee_month.bank_branch_id = 0) AND (vw_employee_month.banked <> 0)
	GROUP BY vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.gl_bank_account)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_id::varchar(32), 0.0, 
		sum(vw_employee_tax_types.amount + vw_employee_tax_types.additional + vw_employee_tax_types.employer) 
	FROM vw_employee_tax_types
	GROUP BY vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_id)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, 'Employer - ' || vw_employee_tax_types.tax_type_name, 
		'8025', SUM(vw_employee_tax_types.employer), 0.0
	FROM vw_employee_tax_types
	WHERE (vw_employee_tax_types.employer <> 0)
	GROUP BY vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name)
	UNION
	(SELECT vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.adjustment_name, vw_employee_adjustments.account_number, 
		SUM(CASE WHEN vw_employee_adjustments.adjustment_type = 1 THEN vw_employee_adjustments.amount - vw_employee_adjustments.paid_amount ELSE 0 END) as dr_amt,
		SUM(CASE WHEN vw_employee_adjustments.adjustment_type = 2 THEN vw_employee_adjustments.amount - vw_employee_adjustments.paid_amount ELSE 0 END) as cr_amt
	FROM vw_employee_adjustments
	WHERE (vw_employee_adjustments.in_payroll = true) AND (vw_employee_adjustments.visible = true) AND (vw_employee_adjustments.adjustment_type < 3)
	GROUP BY vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.adjustment_name, 
		vw_employee_adjustments.account_number, vw_employee_adjustments.adjustment_type)
	UNION
	(SELECT vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, 'Transport' as description, 
		vw_employee_per_diem.post_account, 
		sum(vw_employee_per_diem.full_amount - vw_employee_per_diem.Cash_paid) as dr_amt, 0.0 as cr_amt
	FROM vw_employee_per_diem
	WHERE (vw_employee_per_diem.approve_status = 'Approved')
	GROUP BY vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, vw_employee_per_diem.post_account)) as a
	ORDER BY gl_payroll_account desc, dr_amt desc, cr_amt desc;

	
CREATE OR REPLACE FUNCTION get_leave_approved_balance(integer, integer) RETURNS real AS $$
DECLARE
	reca					RECORD;
	v_months				integer;
	v_leave_starting		date;
	v_leave_carryover		real;
	v_leave_balance			real;
	v_leave_days			real;
	v_leave_work_days		real;
	v_leave_initial			real;
	v_year_leave			real;
BEGIN

	SELECT allowed_leave_days, month_quota, initial_days, maximum_carry 
		INTO reca
	FROM leave_types
	WHERE (leave_type_id = $2);

	SELECT leave_balance, leave_starting INTO v_leave_carryover, v_leave_starting
	FROM employee_leave_types
	WHERE (entity_id = $1) AND (leave_type_id = $2);
	IF(v_leave_carryover is null) THEN v_leave_carryover := 0; END IF;
	IF(v_leave_carryover > reca.maximum_carry) THEN v_leave_carryover := reca.maximum_carry; END IF;
	IF(v_leave_starting is null) THEN v_leave_starting := current_date; END IF;

	v_months := EXTRACT(MONTH FROM CURRENT_TIMESTAMP) - 1;
	v_leave_balance := reca.initial_days + reca.month_quota * v_months;
	if(reca.month_quota = 0)THEN v_leave_balance := reca.allowed_leave_days; END IF;

	IF(reca.maximum_carry = 0)THEN
		SELECT sum(employee_leave.leave_days) INTO v_leave_days
		FROM employee_leave 
		WHERE (entity_id = $1) AND (leave_type_id = $2)
			AND (approve_status = 'Approved')
			AND (EXTRACT(YEAR FROM leave_from) = EXTRACT(YEAR FROM now()));
		IF(v_leave_days is null) THEN v_leave_days := 0; END IF;

		SELECT SUM(CASE WHEN leave_work_days.half_day = true THEN 0.5 ELSE 1 END) INTO v_leave_work_days
		FROM leave_work_days INNER JOIN employee_leave ON leave_work_days.employee_leave_id = employee_leave.employee_leave_id
		WHERE (employee_leave.entity_id = $1) AND (employee_leave.leave_type_id = $2)
			AND (leave_work_days.approve_status = 'Approved')
			AND (EXTRACT(YEAR FROM employee_leave.leave_from) = EXTRACT(YEAR FROM now()));
		IF(v_leave_work_days is null) THEN v_leave_work_days := 0; END IF;
		v_leave_days := v_leave_days - v_leave_work_days;

		IF(v_leave_balance > reca.allowed_leave_days) THEN v_leave_balance := reca.allowed_leave_days; END IF;
		v_leave_balance := v_leave_balance - v_leave_days;
	ELSE
		SELECT sum(employee_leave.leave_days) INTO v_leave_days
		FROM employee_leave 
		WHERE (entity_id = $1) AND (leave_type_id = $2)
			AND (approve_status = 'Approved');
		IF(v_leave_days is null) THEN v_leave_days := 0; END IF;
		
		SELECT sum(employee_leave.leave_days) INTO v_year_leave
		FROM employee_leave 
		WHERE (entity_id = $1) AND (leave_type_id = $2)
			AND (approve_status = 'Approved')
			AND (EXTRACT(YEAR FROM leave_from) = EXTRACT(YEAR FROM now()));
		IF(v_year_leave is null) THEN v_year_leave := 0; END IF;

		SELECT SUM(CASE WHEN leave_work_days.half_day = true THEN 0.5 ELSE 1 END) INTO v_leave_work_days
		FROM leave_work_days INNER JOIN employee_leave ON leave_work_days.employee_leave_id = employee_leave.employee_leave_id
		WHERE (employee_leave.entity_id = $1) AND (employee_leave.leave_type_id = $2)
			AND (leave_work_days.approve_status = 'Approved');
		IF(v_leave_work_days is null) THEN v_leave_work_days := 0; END IF;
		v_leave_days := v_leave_days - v_leave_work_days;
		
		v_leave_initial := v_leave_carryover + (EXTRACT(YEAR FROM now()) - EXTRACT(YEAR FROM v_leave_starting)) * reca.allowed_leave_days;
		IF(EXTRACT(MONTH FROM v_leave_starting) > 1)THEN
			v_leave_initial := v_leave_carryover + (EXTRACT(YEAR FROM now()) - EXTRACT(YEAR FROM v_leave_starting) - 1) * reca.allowed_leave_days;
			IF(reca.month_quota = 0)THEN v_leave_initial := v_leave_initial + (13 - EXTRACT(MONTH FROM v_leave_starting)) * reca.month_quota;
			ELSE v_leave_initial := v_leave_initial + reca.allowed_leave_days;
			END IF;
		END IF;
		v_leave_initial := v_leave_initial - (v_leave_days - v_year_leave);
		IF(v_leave_initial > reca.maximum_carry) THEN v_leave_initial := reca.maximum_carry; END IF;		
		v_leave_balance := v_leave_initial + v_leave_balance - v_year_leave;
	END IF;

	RETURN v_leave_balance;
END;
$$ LANGUAGE plpgsql;

