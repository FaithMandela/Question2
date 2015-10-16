
DROP VIEW vw_payroll_ledger_trx;
DROP VIEW vw_payroll_ledger;
DROP VIEW vw_employee_per_diem_ledger;
DROP VIEW vw_employee_overtime;
DROP VIEW vw_employee_per_diem;
DROP VIEW vw_employee_banking;
DROP VIEW vw_employee_adjustments;
DROP VIEW vw_employee_tax_types;
DROP VIEW vw_advance_statement;
DROP VIEW vw_employee_advances;
DROP VIEW vw_advance_deductions;
DROP VIEW vw_employee_month_list;

CREATE VIEW vw_employee_month_list AS
	SELECT vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.overtime_rate, 
		vw_periods.activated, vw_periods.closed, vw_periods.month_id, vw_periods.period_year, vw_periods.period_month,
		vw_periods.quarter, vw_periods.semister, vw_periods.bank_header, vw_periods.bank_address,
		vw_periods.gl_payroll_account, vw_periods.gl_bank_account, vw_periods.is_posted, 
		entitys.entity_id, entitys.entity_name,
		employees.employee_id, employees.surname, employees.first_name, employees.middle_name, employees.date_of_birth, 
		employees.gender, employees.nationality, employees.marital_status, employees.appointment_date, employees.exit_date, 
		employees.contract, employees.contract_period, employees.employment_terms, employees.identity_card,
		(employees.Surname || ' ' || employees.First_name || ' ' || COALESCE(employees.Middle_name, '')) as employee_name,
		employee_month.pay_group_id,
		employee_month.org_id, employee_month.employee_month_id, employee_month.bank_account, employee_month.basic_pay
		
	FROM employee_month INNER JOIN vw_periods ON employee_month.period_id = vw_periods.period_id
		INNER JOIN entitys ON employee_month.entity_id = entitys.entity_id
		INNER JOIN employees ON employee_month.entity_id = employees.entity_id;

CREATE VIEW vw_employee_tax_types AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.end_date, eml.gl_payroll_account,
		eml.entity_id, eml.entity_name, eml.employee_id, eml.identity_card,
		tax_types.tax_type_id, tax_types.tax_type_name, tax_types.account_id, 
		employee_tax_types.org_id, employee_tax_types.employee_tax_type_id, employee_tax_types.tax_identification, 
		employee_tax_types.amount, 
		employee_tax_types.additional, employee_tax_types.employer, employee_tax_types.narrative,
		currency.currency_id, currency.currency_name, currency.currency_symbol, employee_tax_types.exchange_rate,
		
		(employee_tax_types.exchange_rate * employee_tax_types.amount) as base_amount,
		(employee_tax_types.exchange_rate * employee_tax_types.employer) as base_employer,
		(employee_tax_types.exchange_rate * employee_tax_types.additional) as base_additional
		
	FROM employee_tax_types INNER JOIN vw_employee_month_list as eml ON employee_tax_types.employee_month_id = eml.employee_month_id
		INNER JOIN tax_types ON (employee_tax_types.tax_type_id = Tax_Types.tax_type_id)
		INNER JOIN currency ON tax_types.currency_id = currency.currency_id;

CREATE VIEW vw_employee_advances AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		employee_advances.org_id, employee_advances.employee_advance_id, employee_advances.pay_date, employee_advances.pay_period, 
		employee_advances.Pay_upto, employee_advances.amount, employee_advances.in_payroll, employee_advances.completed, 
		employee_advances.approve_status, employee_advances.Action_date, employee_advances.narrative
	FROM employee_advances INNER JOIN vw_employee_month_list as eml ON employee_advances.employee_month_id = eml.employee_month_id;

CREATE VIEW vw_advance_deductions AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		advance_deductions.org_id, advance_deductions.advance_deduction_id, advance_deductions.pay_date, advance_deductions.amount, 
		advance_deductions.in_payroll, advance_deductions.narrative
	FROM advance_deductions INNER JOIN vw_employee_month_list as eml ON advance_deductions.employee_month_id = eml.employee_month_id;

CREATE VIEW vw_advance_statement AS
	(SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		employee_advances.org_id, employee_advances.pay_date, employee_advances.in_payroll, employee_advances.narrative,
		employee_advances.amount, cast(0 as real) as recovery
	FROM employee_advances INNER JOIN vw_employee_month_list as eml ON employee_advances.employee_month_id = eml.employee_month_id
	WHERE (employee_advances.approve_status = 'Approved'))
	UNION
	(SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		advance_deductions.org_id, advance_deductions.pay_date, advance_deductions.in_payroll, advance_deductions.narrative, 
		cast(0 as real), advance_deductions.amount
	FROM advance_deductions INNER JOIN vw_employee_month_list as eml ON advance_deductions.employee_month_id = eml.employee_month_id);


CREATE VIEW vw_employee_adjustments AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.end_date, 
		eml.entity_id, eml.entity_name, eml.employee_id,
		adjustments.adjustment_id, adjustments.adjustment_name, adjustments.adjustment_type, adjustments.account_number, 
		adjustments.earning_code,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		employee_adjustments.org_id, employee_adjustments.employee_adjustment_id, employee_adjustments.pay_date, employee_adjustments.amount, 
		employee_adjustments.in_payroll, employee_adjustments.in_tax, employee_adjustments.visible, employee_adjustments.exchange_rate,
		employee_adjustments.paid_amount, employee_adjustments.balance, employee_adjustments.narrative,
		employee_adjustments.tax_relief_amount,
		(employee_adjustments.exchange_rate * employee_adjustments.amount) as base_amount		
	FROM employee_adjustments INNER JOIN adjustments ON employee_adjustments.adjustment_id = adjustments.adjustment_id
		INNER JOIN vw_employee_month_list as eml ON employee_adjustments.employee_month_id = eml.employee_month_id
		INNER JOIN currency ON adjustments.currency_id = currency.currency_id;
		
		
CREATE VIEW vw_employee_overtime AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		employee_overtime.org_id, employee_overtime.employee_overtime_id, employee_overtime.overtime_date, employee_overtime.overtime, 
		employee_overtime.overtime_rate, employee_overtime.narrative, employee_overtime.approve_status, 
		employee_overtime.Action_date, employee_overtime.details
	FROM employee_overtime INNER JOIN vw_employee_month_list as eml ON employee_overtime.employee_month_id = eml.employee_month_id;

CREATE VIEW vw_employee_per_diem AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		employee_per_diem.org_id, employee_per_diem.employee_per_diem_id, employee_per_diem.travel_date, employee_per_diem.return_date, employee_per_diem.days_travelled, 
		employee_per_diem.per_diem, employee_per_diem.cash_paid, employee_per_diem.tax_amount, employee_per_diem.full_amount,
		employee_per_diem.travel_to,  employee_per_diem.approve_status, employee_per_diem.action_date, 
		employee_per_diem.completed, employee_per_diem.post_account, employee_per_diem.details,
		(employee_per_diem.exchange_rate * employee_per_diem.tax_amount) as base_tax_amount, 
		(employee_per_diem.exchange_rate *  employee_per_diem.full_amount) as base_full_amount
	FROM employee_per_diem INNER JOIN vw_employee_month_list as eml ON employee_per_diem.employee_month_id = eml.employee_month_id;
	
CREATE VIEW vw_employee_banking AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		eml.pay_group_id, eml.bank_Header, eml.bank_address,
		vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, 
		vw_bank_branch.bank_branch_name, vw_bank_branch.bank_branch_code,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		
		employee_banking.org_id, employee_banking.employee_banking_id, employee_banking.amount, 
		employee_banking.exchange_rate, employee_banking.active, employee_banking.bank_account,
		employee_banking.narrative,
		(employee_banking.exchange_rate * employee_banking.amount) as base_amount
	FROM employee_banking INNER JOIN vw_employee_month_list as eml ON employee_banking.employee_month_id = eml.employee_month_id
		INNER JOIN vw_bank_branch ON employee_banking.bank_branch_id = vw_bank_branch.bank_branch_id
		INNER JOIN currency ON employee_banking.currency_id = currency.currency_id;

		
CREATE VIEW vw_employee_per_diem_ledger AS
	(SELECT vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, 'Transport' as description, 
		vw_employee_per_diem.post_account, vw_employee_per_diem.entity_name, vw_employee_per_diem.full_amount as dr_amt, 0.0 as cr_amt
	FROM vw_employee_per_diem
	WHERE (vw_employee_per_diem.approve_status = 'Approved'))
	UNION
	(SELECT vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, 'Travel Petty Cash' as description, 
		'3305', vw_employee_per_diem.entity_name, 0.0 as dr_amt, cash_paid as cr_amt
	FROM vw_employee_per_diem
	WHERE (vw_employee_per_diem.approve_status = 'Approved'))
	UNION
	(SELECT  vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, 'Transport PAYE' as description, 
		'4045', vw_employee_per_diem.entity_name, 0.0 as dr_amt, full_amount - cash_paid as cr_amt
	FROM vw_employee_per_diem
	WHERE (vw_employee_per_diem.approve_status = 'Approved'));

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
