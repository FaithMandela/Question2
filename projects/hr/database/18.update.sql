

CREATE VIEW vw_pension_adjustments AS
	SELECT c.period_id, c.start_date,
		a.employee_adjustment_id, a.employee_month_id, a.adjustment_id, a.pension_id, 
		a.org_id, a.adjustment_type, a.adjustment_factor, a.pay_date, a.amount, 
		a.exchange_rate, a.in_payroll, a.in_tax, a.visible,
		(a.amount * a.exchange_rate) as base_amount
	FROM employee_adjustments as a INNER JOIN employee_month as b ON a.employee_month_id = b.employee_month_id
		INNER JOIN periods as c ON b.period_id = c.period_id
	WHERE (a.pension_id is not null);

CREATE VIEW vw_employee_pensions AS
	SELECT a.entity_id, a.entity_name, a.adjustment_id, a.adjustment_name, a.contribution_id, 
		a.contribution_name, a.org_id, a.pension_id, a.pension_company, a.pension_number, 
		a.active,
		b.period_id, b.start_date, b.employee_month_id, 
		b.amount, b.base_amount,
		COALESCE(c.amount, 0) as employer_amount, 
		COALESCE(c.base_amount, 0) as employer_base_amount,
		(b.amount + COALESCE(c.amount, 0)) as pension_amount, 
		(b.base_amount + COALESCE(c.base_amount, 0)) as pension_base_amount
	FROM (vw_pensions as a INNER JOIN vw_pension_adjustments as b 
		ON (a.pension_id = b.pension_id) AND (a.adjustment_id = b.adjustment_id))
		LEFT JOIN vw_pension_adjustments as c
		ON (a.pension_id = c.pension_id) AND (a.contribution_id = c.adjustment_id)
		AND (b.employee_month_id = c.employee_month_id);
		

CREATE TABLE pay_scale_steps (
	pay_scale_step_id		serial primary key,
	pay_scale_id			integer references pay_scales,
	org_id					integer references orgs,
	pay_step				integer not null,
	pay_amount				real not null
);
CREATE INDEX pay_scale_steps_pay_scale_id ON pay_scale_steps(pay_scale_id);
CREATE INDEX pay_scale_steps_org_id ON pay_scale_steps(org_id);


ALTER TABLE pay_scales ADD currency_id integer references currency;
CREATE INDEX pay_scales_currency_id ON pay_scales(currency_id);


ALTER TABLE employees ADD 	pay_scale_step_id		integer references pay_scale_steps;
CREATE INDEX employees_pay_scale_step_id ON employees (pay_scale_step_id);

CREATE VIEW vw_pay_scale_steps AS
	SELECT currency.currency_id, currency.currency_name, currency.currency_symbol,
		pay_scales.pay_scale_id, pay_scales.pay_scale_name, 
		pay_scale_steps.org_id, pay_scale_steps.pay_scale_step_id, pay_scale_steps.pay_step, 
		pay_scale_steps.pay_amount,
		(pay_scales.pay_scale_name || '-' || currency.currency_symbol || '-' || pay_scale_steps.pay_step) as pay_step_name
	FROM pay_scale_steps INNER JOIN pay_scales ON pay_scale_steps.pay_scale_id = pay_scales.pay_scale_id
		INNER JOIN currency ON pay_scales.currency_id = currency.currency_id;
		

ALTER TABLE tax_types ADD currency_id integer references currency;
ALTER TABLE adjustments ADD currency_id integer references currency;
ALTER TABLE employee_adjustments ADD exchange_rate real default 1;
ALTER TABLE employee_tax_types ADD exchange_rate real default 1;
ALTER TABLE employee_per_diem ADD exchange_rate real default 1;

CREATE TABLE employee_banking (
	employee_banking_id		serial primary key,
	employee_month_id		integer references employee_month not null,
	bank_branch_id			integer references bank_branch,
	currency_id				integer references currency,
	org_id					integer references orgs,
	
	amount					float default 0 not null,
	exchange_rate			real default 1 not null,
	active					boolean default true,
	
	bank_account			varchar(64),

	Narrative				varchar(240)
);
CREATE INDEX employee_banking_employee_month_id ON employee_banking (employee_month_id);
CREATE INDEX employee_banking_bank_branch_id ON employee_banking (bank_branch_id);
CREATE INDEX employee_banking_currency_id ON employee_banking (currency_id);
CREATE INDEX employee_banking_org_id ON employee_banking(org_id);

CREATE VIEW vw_employee_month AS
	SELECT vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.overtime_rate, 
		vw_periods.activated, vw_periods.closed, vw_periods.month_id, vw_periods.period_year, vw_periods.period_month,
		vw_periods.quarter, vw_periods.semister, vw_periods.bank_header, vw_periods.bank_address,
		vw_periods.gl_payroll_account, vw_periods.gl_bank_account, vw_periods.is_posted,
		vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, 
		vw_bank_branch.bank_branch_name, vw_bank_branch.bank_branch_code,
		pay_groups.pay_group_id, pay_groups.pay_group_name, vw_department_roles.department_id, vw_department_roles.department_name,
		vw_department_roles.department_role_id, vw_department_roles.department_role_name, 
		entitys.entity_id, entitys.entity_name,
		employees.employee_id, employees.surname, employees.first_name, employees.middle_name, employees.date_of_birth, 
		employees.gender, employees.nationality, employees.marital_status, employees.appointment_date, employees.exit_date, 
		employees.contract, employees.contract_period, employees.employment_terms, employees.identity_card,
		(employees.Surname || ' ' || employees.First_name || ' ' || COALESCE(employees.Middle_name, '')) as employee_name,
		currency.currency_id, currency.currency_name, currency.currency_symbol, employee_month.exchange_rate,
		
		employee_month.org_id, employee_month.employee_month_id, employee_month.bank_account, employee_month.basic_pay, employee_month.details,
		getAdjustment(employee_month.employee_month_id, 4, 31) as overtime,
		getAdjustment(employee_month.employee_month_id, 1, 1) as full_allowance,
		getAdjustment(employee_month.employee_month_id, 1, 2) as payroll_allowance,
		getAdjustment(employee_month.employee_month_id, 1, 3) as tax_allowance,
		getAdjustment(employee_month.employee_month_id, 2, 1) as full_deduction,
		getAdjustment(employee_month.employee_month_id, 2, 2) as payroll_deduction,
		getAdjustment(employee_month.employee_month_id, 2, 3) as tax_deduction,
		getAdjustment(employee_month.employee_month_id, 3, 1) as full_expense,
		getAdjustment(employee_month.employee_month_id, 3, 2) as payroll_expense,
		getAdjustment(employee_month.employee_month_id, 3, 3) as tax_expense,
		getAdjustment(employee_month.employee_month_id, 4, 11) as payroll_tax,
		getAdjustment(employee_month.employee_month_id, 4, 12) as tax_tax,
		getAdjustment(employee_month.employee_month_id, 4, 22) as net_Adjustment,
		getAdjustment(employee_month.employee_month_id, 4, 33) as per_diem,
		getAdjustment(employee_month.employee_month_id, 4, 34) as advance,
		getAdjustment(employee_month.employee_month_id, 4, 35) as advance_deduction,
		(employee_month.Basic_Pay + getAdjustment(employee_month.employee_month_id, 4, 31) + getAdjustment(employee_month.employee_month_id, 4, 22) 
		+ getAdjustment(employee_month.employee_month_id, 4, 33) - getAdjustment(employee_month.employee_month_id, 4, 11)) as net_pay,
		(employee_month.Basic_Pay + getAdjustment(employee_month.employee_month_id, 4, 31) + getAdjustment(employee_month.employee_month_id, 4, 22) 
		+ getAdjustment(employee_month.employee_month_id, 4, 33) + getAdjustment(employee_month.employee_month_id, 4, 34)
		- getAdjustment(employee_month.employee_month_id, 4, 11) - getAdjustment(employee_month.employee_month_id, 4, 35)
		- getAdjustment(employee_month.employee_month_id, 4, 36)
		- getAdjustment(employee_month.employee_month_id, 4, 41)) as banked,
		(employee_month.Basic_Pay + getAdjustment(employee_month.employee_month_id, 4, 31) + getAdjustment(employee_month.employee_month_id, 1, 1) 
		+ getAdjustment(employee_month.employee_month_id, 3, 1) + getAdjustment(employee_month.employee_month_id, 4, 33)) as cost
	FROM employee_month INNER JOIN vw_bank_branch ON employee_month.bank_branch_id = vw_bank_branch.bank_branch_id
		INNER JOIN vw_periods ON employee_month.period_id = vw_periods.period_id
		INNER JOIN pay_groups ON employee_month.pay_group_id = pay_groups.pay_group_id
		INNER JOIN entitys ON employee_month.entity_id = entitys.entity_id
		INNER JOIN vw_department_roles ON employee_month.department_role_id = vw_department_roles.department_role_id
		INNER JOIN employees ON employee_month.entity_id = employees.entity_id
		INNER JOIN currency ON employee_month.currency_id = currency.currency_id;
