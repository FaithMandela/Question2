

UPDATE adjustments SET currency_id = 1 WHERE currency_id is null;


INSERT INTO default_adjustments (entity_id, adjustment_id, org_id)
SELECT entity_id, 15, 0
FROM employees WHERE contract = false;
INSERT INTO default_adjustments (entity_id, adjustment_id, org_id)
SELECT entity_id, 16, 0
FROM employees WHERE contract = false;

INSERT INTO default_adjustments(entity_id, adjustment_id, org_id, amount, active)
SELECT a.employeeid, 41, 0, 0, true
FROM import.employees as a 
WHERE (a.houserate = 0.025);
INSERT INTO default_adjustments(entity_id, adjustment_id, org_id, amount, active)
SELECT a.employeeid, 42, 0, 0, true
FROM import.employees as a 
WHERE (a.houserate = 0.05);
INSERT INTO default_adjustments(entity_id, adjustment_id, org_id, amount, active)
SELECT a.employeeid, 43, 0, 0, true
FROM import.employees as a 
WHERE (a.houserate = 0.075);

INSERT INTO default_adjustments(entity_id, adjustment_id, org_id, amount, active)
SELECT employeeid,  17, 0, 0, true
FROM import.employees
WHERE ishoused = 'Yes';

CREATE OR REPLACE FUNCTION generate_payroll(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_period_id		integer;
	v_org_id		integer;

	msg 			varchar(120);
BEGIN
	SELECT period_id, org_id INTO v_period_id, v_org_id
	FROM periods
	WHERE (period_id = CAST($1 as integer));

	INSERT INTO period_tax_types (period_id, org_id, tax_type_id, period_tax_type_name, formural, tax_relief, percentage, linear, employer, employer_ps, tax_type_order, in_tax, account_id)
	SELECT v_period_id, org_id, tax_type_id, tax_type_name, formural, tax_relief, percentage, linear, employer, employer_ps, tax_type_order, in_tax, account_id
	FROM tax_types
	WHERE (active = true) AND (org_id = v_org_id);

	INSERT INTO employee_month (period_id, org_id, pay_group_id, entity_id, bank_branch_id, department_role_id, currency_id, bank_account, basic_pay)
	SELECT v_period_id, org_id, pay_group_id, entity_id, bank_branch_id, department_role_id, currency_id, bank_account, basic_salary
	FROM employees
	WHERE (employees.active = true) and (employees.org_id = v_org_id);

	INSERT INTO loan_monthly (period_id, org_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_period_id, org_id, loan_id, monthly_repayment, (loan_balance * interest / 1200), (loan_balance * interest / 1200)
	FROM vw_loans 
	WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  true) AND (org_id = v_org_id);

	INSERT INTO loan_monthly (period_id, org_id, loan_id, repayment, interest_amount, interest_paid)
	SELECT v_period_id, org_id, loan_id, monthly_repayment, (principle * interest / 1200), (principle * interest / 1200)
	FROM vw_loans 
	WHERE (loan_balance > 0) AND (approve_status = 'Approved') AND (reducing_balance =  false) AND (org_id = v_org_id);


	msg := 'Payroll Generated';

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_payroll(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec 		RECORD;
	msg 		varchar(120);
BEGIN
	IF ($3 = '1') THEN
		UPDATE employee_adjustments SET amount = 0
		FROM employee_month 
		WHERE (adjustment_id IN (15,16,17))
			AND (employee_adjustments.employee_month_id = employee_month.employee_month_id) 
			AND (employee_month.period_id = CAST($1 as int));
			
		UPDATE employee_adjustments SET tax_reduction_amount = 0 
		FROM employee_month 
		WHERE (employee_adjustments.employee_month_id = employee_month.employee_month_id) 
			AND (employee_month.period_id = CAST($1 as int));
			
		UPDATE employee_adjustments SET amount = 0 
		FROM employee_month 
		WHERE (employee_adjustments.employee_month_id = employee_month.employee_month_id) 
			AND (employee_month.period_id = CAST($1 as int))
			AND (adjustment_id IN (SELECT adjustment_id FROM adjustments WHERE formural is not null));

		UPDATE employee_adjustments 
			SET amount = ((vw_employee_month.basic_pay + vw_employee_month.full_allowance) * 0.15) - get_house_rent(vw_employee_month.employee_month_id)
		FROM vw_employee_month 
		WHERE (adjustment_id = 17)
			AND (employee_adjustments.employee_month_id = vw_employee_month.employee_month_id) 
			AND (vw_employee_month.period_id = CAST($1 as int));
	
		PERFORM updTax(employee_month_id, period_id)
		FROM employee_month
		WHERE (period_id = CAST($1 as int));
		PERFORM updTax(employee_month_id, period_id)
		FROM employee_month
		WHERE (period_id = CAST($1 as int));
		PERFORM updTax(employee_month_id, period_id)
		FROM employee_month
		WHERE (period_id = CAST($1 as int));
		
		msg := 'Payroll Processed';
	ELSIF ($3 = '2') THEN
		UPDATE periods SET entity_id = CAST($2 as int), approve_status = 'Completed'
		WHERE (period_id = CAST($1 as int));

		msg := 'Application for approval';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upd_employee_adjustments() RETURNS trigger AS $$
DECLARE
	rec 		RECORD;
	entityid 	integer;
	periodid 	integer;
BEGIN
	SELECT monthly_update, running_balance INTO rec
	FROM adjustments WHERE adjustment_id = NEW.Adjustment_ID;

	SELECT entity_id, period_id INTO entityid, periodid
	FROM employee_month WHERE employee_month_id = NEW.employee_month_id;

	IF(rec.running_balance = true) AND (NEW.balance is not null)THEN
		UPDATE default_adjustments SET balance = NEW.balance
		WHERE (entity_id = entityid) AND (adjustment_id = NEW.adjustment_id);
	END IF;

	IF(TG_OP = 'UPDATE')THEN
		IF (OLD.amount <> NEW.amount)THEN
			IF(rec.monthly_update = true)THEN
				UPDATE default_adjustments SET amount = NEW.amount 
				WHERE (entity_id = entityid) AND (adjustment_id = NEW.adjustment_id);
			END IF;
		END IF;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updtax(int, int) RETURNS float AS $$
DECLARE
	reca 					RECORD;
	income 					REAL;
	tax 					REAL;
	InsuranceRelief 		REAL;
	v_income				real;
BEGIN

	FOR reca IN SELECT employee_tax_types.employee_tax_type_id, employee_tax_types.tax_type_id, period_tax_types.formural,
			 period_tax_types.employer, period_tax_types.employer_ps
		FROM employee_tax_types INNER JOIN period_tax_types ON (employee_tax_types.tax_type_id = period_tax_types.tax_type_id)
		WHERE (employee_month_id = $1) AND (Period_Tax_Types.Period_ID = $2)
		ORDER BY Period_Tax_Types.Tax_Type_order LOOP

		EXECUTE 'SELECT ' || reca.formural || ' FROM employee_tax_types WHERE employee_tax_type_id = ' || reca.employee_tax_type_id 
		INTO tax;
		
		IF(reca.tax_type_id = 1)THEN 	---- PAYE
			UPDATE employee_adjustments SET amount = tax * .9
			WHERE (employee_month_id = $1) AND (adjustment_id = 15);
		END IF;
		
		IF(reca.tax_type_id = 3)THEN 	---- NHIF
			UPDATE employee_adjustments SET amount = tax * .75
			WHERE (employee_month_id = $1) AND (adjustment_id = 16);
		END IF;
		
		EXECUTE 'SELECT ' || reca.formural || ' FROM employee_tax_types WHERE employee_tax_type_id = ' || reca.employee_tax_type_id 
		INTO tax;

		UPDATE employee_tax_types SET amount = tax, employer = reca.employer + (tax * reca.employer_ps / 100)
		WHERE employee_tax_type_id = reca.employee_tax_type_id;
	END LOOP;

	RETURN tax;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_formula_adjustment(int, int, real) RETURNS float AS $$
DECLARE
	v_employee_month_id		integer;
	v_basic_pay				float;
	v_adjustment			float;
	v_prof_allowance		float;
BEGIN

	SELECT employee_month.employee_month_id, employee_month.basic_pay INTO v_employee_month_id, v_basic_pay
	FROM employee_month
	WHERE (employee_month.employee_month_id = $1);

	IF ($2 = 1) THEN
		v_adjustment := v_basic_pay * $3;
	ELSIF ($2 = 2) THEN
		SELECT amount INTO v_prof_allowance
		FROM employee_adjustments
		WHERE (employee_month_id = v_employee_month_id) AND (adjustment_id = 5);
		
		v_adjustment := (v_basic_pay + v_prof_allowance) * $3;
	ELSE
		v_adjustment := 0;
	END IF;

	IF(v_adjustment is null) THEN
		v_adjustment := 0;
	END IF;

	RETURN v_adjustment;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_house_rent(integer) RETURNS real AS $$
    SELECT sum(amount)
	FROM employee_adjustments
	WHERE (adjustment_id IN (41,42,43))
	AND (employee_adjustments.employee_month_id = $1);
$$ LANGUAGE SQL;

