



ALTER TABLE project_staff ADD payroll_ps				real default 0 not null;
ALTER TABLE project_staff ADD is_active					boolean default true not null;

DROP VIEW vw_project_staff_costs;
DROP TABLE project_staff_costs;
CREATE TABLE project_staff_costs (
	project_staff_cost_id	serial primary key,
	project_id				integer references projects not null,
	employee_month_id		integer references employee_month not null,
	org_id					integer references orgs,
	project_role			varchar(240),
	payroll_ps				real default 0 not null,
	staff_cost				real default 0 not null,
	tax_cost				real default 0 not null,
	Details					text
);
CREATE INDEX project_staff_costs_project_id ON project_staff_costs (project_id);
CREATE INDEX project_staff_costs_employee_month_id ON project_staff_costs (employee_month_id);
CREATE INDEX project_staff_costs_org_id ON project_staff_costs(org_id);

DROP VIEW vw_project_staff;
CREATE VIEW vw_project_staff AS
	SELECT vw_projects.client_id, vw_projects.client_name, vw_projects.project_type_id, vw_projects.project_type_name, 
		vw_projects.project_id, vw_projects.project_name, vw_projects.signed, vw_projects.contract_ref, 
		vw_projects.monthly_amount, vw_projects.full_amount, vw_projects.project_cost, vw_projects.narrative, 
		vw_projects.project_account, vw_projects.start_date, vw_projects.ending_date,
		entitys.entity_id as staff_id, entitys.entity_name as staff_name, 
		project_staff.org_id, project_staff.project_staff_id, project_staff.project_role, 
		project_staff.is_active, project_staff.payroll_ps,
		project_staff.monthly_cost, project_staff.staff_cost, project_staff.tax_cost, project_staff.details
	FROM project_staff INNER JOIN entitys ON project_staff.entity_id = entitys.entity_id
		INNER JOIN vw_projects ON project_staff.project_id = vw_projects.project_id;

CREATE VIEW vw_project_staff_costs AS
	SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, 
		vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month,
		vw_employee_month.end_date, vw_employee_month.gl_payroll_account,
		vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id,
		projects.project_id, projects.project_name, projects.project_account,
		project_staff_costs.org_id, project_staff_costs.project_staff_cost_id, 
		project_staff_costs.project_role, project_staff_costs.payroll_ps,
		project_staff_costs.staff_cost, project_staff_costs.tax_cost, project_staff_costs.details
	FROM project_staff_costs INNER JOIN vw_employee_month ON project_staff_costs.employee_month_id = vw_employee_month.employee_month_id
		INNER JOIN projects ON project_staff_costs.project_id = projects.project_id;
		
		
CREATE OR REPLACE FUNCTION upd_employee_month() RETURNS trigger AS $$
BEGIN
	INSERT INTO employee_tax_types (org_id, employee_month_id, tax_type_id, tax_identification, additional, amount, employer, in_tax, exchange_rate)
	SELECT NEW.org_id, NEW.employee_month_id, default_tax_types.tax_type_id, default_tax_types.tax_identification, 
		Default_Tax_Types.Additional, 0, 0, Tax_Types.In_Tax,
		(CASE WHEN Tax_Types.currency_id = NEW.currency_id THEN 1 ELSE 1 / NEW.exchange_rate END)
	FROM Default_Tax_Types INNER JOIN Tax_Types ON Default_Tax_Types.Tax_Type_id = Tax_Types.Tax_Type_id
	WHERE (Default_Tax_Types.active = true) AND (Default_Tax_Types.entity_ID = NEW.entity_ID);

	INSERT INTO employee_adjustments (org_id, employee_month_id, adjustment_id, amount, adjustment_type, in_payroll, in_tax, visible, adjustment_factor, balance, tax_relief_amount, exchange_rate)
	SELECT NEW.org_id, NEW.employee_month_id, default_adjustments.adjustment_id, default_adjustments.amount,
		adjustments.adjustment_type, adjustments.in_payroll, adjustments.in_tax, adjustments.visible,
		(CASE WHEN adjustments.adjustment_type = 2 THEN -1 ELSE 1 END),
		(CASE WHEN (adjustments.running_balance = true) AND (adjustments.reduce_balance = false) THEN (default_adjustments.balance + default_adjustments.amount)
			WHEN (adjustments.running_balance = true) AND (adjustments.reduce_balance = true) THEN (default_adjustments.balance - default_adjustments.amount) END),
		(default_adjustments.amount * adjustments.tax_relief_ps / 100),
		(CASE WHEN adjustments.currency_id = NEW.currency_id THEN 1 ELSE 1 / NEW.exchange_rate END)
	FROM default_adjustments INNER JOIN adjustments ON default_adjustments.adjustment_id = adjustments.adjustment_id
	WHERE ((default_adjustments.final_date is null) OR (default_adjustments.final_date > current_date))
		AND (default_adjustments.active = true) AND (default_adjustments.entity_id = NEW.entity_id);

	INSERT INTO advance_deductions (org_id, amount, employee_month_id)
	SELECT NEW.org_id, (Amount / Pay_Period), NEW.Employee_Month_ID
	FROM Employee_Advances INNER JOIN Employee_Month ON Employee_Advances.Employee_Month_ID = Employee_Month.Employee_Month_ID
	WHERE (entity_ID = NEW.entity_ID) AND (Pay_Period > 0) AND (completed = false)
		AND (Pay_upto >= current_date);
		
	INSERT INTO project_staff_costs (org_id, employee_month_id, project_id, project_role, payroll_ps, staff_cost, tax_cost)
	SELECT NEW.org_id, NEW.employee_month_id, 
		project_staff.project_id, project_staff.project_role, project_staff.payroll_ps, project_staff.staff_cost, project_staff.tax_cost
	FROM project_staff
	WHERE (project_staff.entity_id = NEW.entity_id) AND (project_staff.monthly_cost = true);


	RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_payroll(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_period_id		integer;
	v_org_id		integer;

	msg 			varchar(120);
BEGIN
	SELECT period_id, org_id INTO v_period_id, v_org_id
	FROM periods
	WHERE (period_id = CAST($1 as integer));

	INSERT INTO period_tax_types (org_id, period_id, tax_type_id, period_tax_type_name, formural, tax_relief, percentage, linear, employer, employer_ps, tax_type_order, in_tax, account_id)
	SELECT v_org_id, v_period_id, tax_type_id, tax_type_name, formural, tax_relief, percentage, linear, employer, employer_ps, tax_type_order, in_tax, account_id
	FROM Tax_Types
	WHERE (active = true);

	INSERT INTO employee_month (org_id, period_id, pay_group_id, entity_id, bank_branch_id, department_role_id, currency_id, bank_account, basic_pay)
	SELECT v_org_id, v_period_id, pay_group_id, entity_id, bank_branch_id, department_role_id, currency_id, bank_account, basic_salary
	FROM employees
	WHERE (employees.active = true) and (employees.org_id = v_org_id);

	INSERT INTO loan_monthly (org_id, period_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_org_id, v_Period_ID, loan_id, monthly_repayment, (loan_balance * interest / 1200), (loan_balance * interest / 1200)
	FROM vw_loans WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  true);

	INSERT INTO loan_monthly (org_id, period_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_org_id, v_period_id, loan_id, monthly_repayment, (principle * interest / 1200), 0
	FROM vw_loans WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  false);

	PERFORM updTax(employee_month_id, Period_id)
	FROM employee_month
	WHERE (period_id = v_period_id);

	msg := 'Payroll Generated';

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_loans() RETURNS trigger AS $$
BEGIN

	IF(NEW.principle is null) OR (NEW.interest is null)THEN
		RAISE EXCEPTION 'You have to enter a principle and interest amount';
	ELSIF(NEW.monthly_repayment is null) AND (NEW.repayment_period is null)THEN
		RAISE EXCEPTION 'You have need to enter either monthly repayment amount or repayment period';
	ELSIF(NEW.monthly_repayment is null) AND (NEW.repayment_period is not null)THEN
		IF(NEW.repayment_period > 0)THEN
			NEW.monthly_repayment := NEW.principle / NEW.repayment_period;
		ELSE
			RAISE EXCEPTION 'The repayment period should be greater than 0';
		END IF;
	ELSIF(NEW.monthly_repayment is not null) AND (NEW.repayment_period is null)THEN
		IF(NEW.monthly_repayment > 0)THEN
			NEW.repayment_period := NEW.principle / NEW.monthly_repayment;
		ELSE
			RAISE EXCEPTION 'The monthly repayment should be greater than 0';
		END IF;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_loans BEFORE INSERT ON loans
    FOR EACH ROW EXECUTE PROCEDURE ins_loans();
    
