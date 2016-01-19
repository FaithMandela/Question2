
ALTER TABLE adjustments ADD default_amount			real default 0 not null;

CREATE OR REPLACE FUNCTION add_adjustment(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	adj							RECORD;
	rec							RECORD;
	v_period_id					integer;
	v_org_id					integer;
	v_adjustment_factor			integer;
	v_default_adjustment_id		integer;
	v_amount					real;
	msg							varchar(120);
BEGIN

	SELECT adjustment_id, adjustment_name, org_id, adjustment_type, formural, default_amount, in_payroll, in_tax, visible INTO adj
	FROM adjustments
	WHERE (adjustment_id = $1::integer);
	
	IF(adj.adjustment_type = 2)THEN
		v_adjustment_factor := -1;
	ELSE
		v_adjustment_factor := 1;
	END IF;
	
	IF ($3 = '1') THEN
		SELECT max(period_id) INTO v_period_id
		FROM periods
		WHERE (closed = false) AND (org_id = adj.org_id);
		
		FOR rec IN SELECT employee_month_id, exchange_rate
			FROM employee_month 
			WHERE (period_id = v_period_id) LOOP
			
			IF(adj.formural is not null)THEN
				EXECUTE 'SELECT ' || adj.formural || ' FROM employee_month WHERE employee_month_id = ' || rec.employee_month_id
				INTO v_amount;
			END IF;
			IF(v_amount is null)THEN
				v_amount := adj.default_amount;
			END IF;
	
			IF(v_amount is not null)THEN
				INSERT INTO employee_adjustments (employee_month_id, adjustment_id, org_id,
					adjustment_type, adjustment_factor, pay_date, amount,
					exchange_rate, in_payroll, in_tax, visible)
				VALUES(rec.employee_month_id, adj.adjustment_id, adj.org_id,
					adj.adjustment_type, v_adjustment_factor, current_date, v_amount,
				(1 / rec.exchange_rate), adj.in_payroll, adj.in_tax, adj.visible);
			END IF;
		END LOOP;
		msg := 'Added ' || adj.adjustment_name || ' to month';
	ELSIF ($3 = '2') THEN	
		FOR rec IN SELECT entity_id
			FROM employees
			WHERE (active = true) AND (org_id = adj.org_id) LOOP
			
			SELECT default_adjustment_id INTO v_default_adjustment_id
			FROM default_adjustments
			WHERE (entity_id = rec.entity_id) AND (adjustment_id = adj.adjustment_id);
			
			IF(v_default_adjustment_id is null)THEN
				INSERT INTO default_adjustments (entity_id, adjustment_id, org_id,
					amount, active)
				VALUES (rec.entity_id, adj.adjustment_id, adj.org_id,
					adj.default_amount, true);
			END IF;
		END LOOP;
		msg := 'Added ' || adj.adjustment_name || ' to employees';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;
	
CREATE OR REPLACE FUNCTION process_pensions(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec							RECORD;
	adj							RECORD;
	v_period_id					integer;
	v_org_id					integer;
	v_employee_month_id			integer;
	v_employee_adjustment_id	integer;
	v_currency_id				integer;
	v_exchange_rate				real;
	a_exchange_rate				real;
	v_amount					real;
	msg							varchar(120);
BEGIN

	SELECT period_id, org_id INTO v_period_id, v_org_id
	FROM periods WHERE period_id = $1::int;
	
	FOR rec IN SELECT pension_id, entity_id, adjustment_id, contribution_id, 
       pension_company, pension_number, amount, use_formura, 
       employer_ps, employer_amount, employer_formural
	FROM pensions WHERE (active = true) AND (org_id = v_org_id) LOOP
	
		SELECT employee_month_id, currency_id, exchange_rate 
			INTO v_employee_month_id, v_currency_id, v_exchange_rate
		FROM employee_month
		WHERE (period_id = v_period_id) AND (entity_id = rec.entity_id);
		
		--- Deduction
		SELECT employee_adjustment_id INTO v_employee_adjustment_id
		FROM employee_adjustments
		WHERE (employee_month_id = v_employee_month_id) AND (pension_id = rec.pension_id)
			AND (adjustment_id = rec.adjustment_id);
		
		SELECT adjustment_id, currency_id, org_id, adjustment_name, adjustment_type, 
			adjustment_order, earning_code, formural, monthly_update, in_payroll, 
			in_tax, visible, running_balance, reduce_balance, tax_reduction_ps, 
			tax_relief_ps, tax_max_allowed, account_number
		INTO adj
		FROM adjustments
		WHERE (adjustment_id = rec.adjustment_id);
		
		IF(rec.use_formura = true) AND (adj.formural is not null) AND (v_employee_month_id is not null) THEN
			EXECUTE 'SELECT ' || adj.formural || ' FROM employee_month WHERE employee_month_id = ' || v_employee_month_id
			INTO v_amount;
			IF(v_currency_id <> adj.currency_id)THEN
				v_amount := v_amount * v_exchange_rate;
			END IF;
		ELSIF(rec.amount > 0)THEN
			v_amount := rec.amount;
		END IF;
		
		a_exchange_rate := v_exchange_rate;
		IF(v_currency_id <> adj.currency_id)THEN
			a_exchange_rate := 1 / v_exchange_rate;
		END IF;
		
		IF(v_employee_adjustment_id is null) AND (v_employee_month_id is not null) THEN
			INSERT INTO employee_adjustments(employee_month_id, pension_id, org_id, 
				adjustment_id, adjustment_type, adjustment_factor, 
				in_payroll, in_tax, visible,
				exchange_rate, pay_date, amount)
			VALUES (v_employee_month_id, rec.pension_id, v_org_id,
				adj.adjustment_id, adj.adjustment_type, -1, 
				adj.in_payroll, adj.in_tax, adj.visible,
				a_exchange_rate, current_date, v_amount);
		ELSIF (v_employee_month_id is not null) THEN
			UPDATE employee_adjustments SET amount = v_amount, exchange_rate = a_exchange_rate
			WHERE employee_adjustment_id = v_employee_adjustment_id;
		END IF;
	
		--- Employer contribution
		IF((rec.employer_ps > 0) OR (rec.employer_amount > 0) OR (rec.employer_formural = true))THEN
			SELECT employee_adjustment_id INTO v_employee_adjustment_id
			FROM employee_adjustments
			WHERE (employee_month_id = v_employee_month_id) AND (pension_id = rec.pension_id)
				AND (adjustment_id = rec.contribution_id);
			
			SELECT adjustment_id, currency_id, org_id, adjustment_name, adjustment_type, 
				adjustment_order, earning_code, formural, monthly_update, in_payroll, 
				in_tax, visible, running_balance, reduce_balance, tax_reduction_ps, 
				tax_relief_ps, tax_max_allowed, account_number
			INTO adj
			FROM adjustments
			WHERE (adjustment_id = rec.contribution_id);
			
			IF(v_currency_id <> adj.currency_id)THEN
				a_exchange_rate := 1 / v_exchange_rate;
			END IF;
			
			IF(rec.employer_formural = true) AND (adj.formural is not null) AND (v_employee_month_id is not null) THEN
				EXECUTE 'SELECT ' || adj.formural || ' FROM employee_month WHERE employee_month_id = ' || v_employee_month_id
				INTO v_amount;
				IF(v_currency_id <> adj.currency_id)THEN
					v_amount := v_amount * v_exchange_rate;
				END IF;
			ELSIF(rec.employer_ps > 0)THEN
				v_amount := v_amount * rec.employer_ps / 100;
			ELSIF(rec.employer_amount > 0)THEN
				v_amount := rec.employer_amount;
			END IF;
			
			IF(v_employee_adjustment_id is null) AND (v_employee_month_id is not null)THEN
				INSERT INTO employee_adjustments(employee_month_id, pension_id, org_id, 
					adjustment_id, adjustment_type, adjustment_factor, 
					in_payroll, in_tax, visible,
					exchange_rate, pay_date, amount)
				VALUES (v_employee_month_id, rec.pension_id, v_org_id,
					adj.adjustment_id, adj.adjustment_type, 1, 
					adj.in_payroll, adj.in_tax, adj.visible,
					a_exchange_rate, current_date, v_amount);
			ELSIF (v_employee_month_id is not null) THEN
				UPDATE employee_adjustments SET amount = v_amount, exchange_rate = a_exchange_rate
				WHERE employee_adjustment_id = v_employee_adjustment_id;
			END IF;
		END IF;
		
	END LOOP;

	msg := 'Pension Processed';

	RETURN msg;
END;
$$ LANGUAGE plpgsql;


DROP VIEW vw_sun_ledger_trx;
DROP VIEW vw_payroll_ledger;
DROP VIEW vw_payroll_ledger_trx;
DROP VIEW vw_employee_tax_types;

CREATE VIEW vw_employee_tax_types AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.end_date, eml.gl_payroll_account,
		eml.entity_id, eml.entity_name, eml.employee_id, eml.identity_card,
		eml.surname, eml.first_name, eml.middle_name, eml.date_of_birth, 
		eml.department_id, eml.department_name, eml.department_account, eml.function_code,
		eml.department_role_id, eml.department_role_name,
		tax_types.tax_type_id, tax_types.tax_type_name, tax_types.account_id, tax_types.tax_type_number,
		tax_types.account_number, tax_types.employer_account,
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
	SELECT org_id, period_id, end_date, description, gl_payroll_account, entity_name, employee_id,
		dr_amt, cr_amt 
	FROM 
	((SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'BASIC SALARY' as description, 
		vw_employee_month.gl_payroll_account, vw_employee_month.entity_name, vw_employee_month.employee_id,
		vw_employee_month.basic_pay as dr_amt, 0.0 as cr_amt
	FROM vw_employee_month)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, 'SALARY PAYMENTS',
		vw_employee_month.gl_bank_account, vw_employee_month.entity_name, vw_employee_month.employee_id,
		0.0 as sum_basic_pay, 
		vw_employee_month.banked as sum_banked
	FROM vw_employee_month)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_number, vw_employee_tax_types.entity_name, vw_employee_tax_types.employee_id,
		0.0, 
		(vw_employee_tax_types.amount + vw_employee_tax_types.additional + vw_employee_tax_types.employer) 
	FROM vw_employee_tax_types)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, 'Employer - ' || vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_number, vw_employee_tax_types.entity_name, vw_employee_tax_types.employee_id,
		vw_employee_tax_types.employer, 0.0
	FROM vw_employee_tax_types
	WHERE (vw_employee_tax_types.employer <> 0))
	UNION
	(SELECT vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.adjustment_name, vw_employee_adjustments.account_number, 
		vw_employee_adjustments.entity_name, vw_employee_adjustments.employee_id,
		SUM(CASE WHEN vw_employee_adjustments.adjustment_type = 1 THEN vw_employee_adjustments.amount - vw_employee_adjustments.paid_amount ELSE 0 END) as dr_amt,
		SUM(CASE WHEN vw_employee_adjustments.adjustment_type = 2 THEN vw_employee_adjustments.amount - vw_employee_adjustments.paid_amount ELSE 0 END) as cr_amt
	FROM vw_employee_adjustments
	WHERE (vw_employee_adjustments.visible = true) AND (vw_employee_adjustments.adjustment_type < 3)
	GROUP BY vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.adjustment_name, vw_employee_adjustments.account_number, 
		vw_employee_adjustments.entity_name, vw_employee_adjustments.employee_id)
	UNION
	(SELECT vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, 'Transport' as description, 
		vw_employee_per_diem.post_account, vw_employee_per_diem.entity_name, vw_employee_per_diem.employee_id,
		(vw_employee_per_diem.full_amount - vw_employee_per_diem.Cash_paid) as dr_amt, 0.0 as cr_amt
	FROM vw_employee_per_diem
	WHERE (vw_employee_per_diem.approve_status = 'Approved'))
	UNION
	(SELECT ea.org_id, ea.period_id, ea.end_date, 'SALARY ADVANCE' as description, 
		ea.gl_payroll_account, ea.entity_name, ea.employee_id,
		ea.amount as dr_amt, 
		0.0 as cr_amt
	FROM vw_employee_advances as ea
	WHERE (ea.in_payroll = true))
	UNION
	(SELECT ead.org_id, ead.period_id, ead.end_date, 'ADVANCE DEDUCTION' as description, 
		ead.gl_payroll_account, ead.entity_name, ead.employee_id,
		0.0 as dr_amt, 
		ead.amount as cr_amt
	FROM vw_advance_deductions as ead
	WHERE (ead.in_payroll = true))) as a
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
	GROUP BY vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.gl_bank_account)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_number, 0.0, 
		sum(vw_employee_tax_types.amount + vw_employee_tax_types.additional + vw_employee_tax_types.employer) 
	FROM vw_employee_tax_types
	GROUP BY vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_number)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, 'Employer - ' || vw_employee_tax_types.tax_type_name, 
		vw_employee_tax_types.account_number, SUM(vw_employee_tax_types.employer), 0.0
	FROM vw_employee_tax_types
	WHERE (vw_employee_tax_types.employer <> 0)
	GROUP BY vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.tax_type_name,
		vw_employee_tax_types.account_number)
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
	GROUP BY vw_employee_per_diem.org_id, vw_employee_per_diem.period_id, vw_employee_per_diem.travel_date, vw_employee_per_diem.post_account)
	UNION
	(SELECT ea.org_id, ea.period_id, ea.end_date, 'SALARY ADVANCE' as description, 
		ea.gl_payroll_account, 
		sum(ea.amount) as dr_amt, 
		0.0 as cr_amt
	FROM vw_employee_advances as ea
	WHERE (ea.in_payroll = true)
	GROUP BY ea.org_id, ea.period_id, ea.end_date, ea.gl_payroll_account)
	UNION
	(SELECT ead.org_id, ead.period_id, ead.end_date, 'ADVANCE DEDUCTION' as description, 
		ead.gl_payroll_account, 
		0.0 as dr_amt, 
		sum(ead.amount) as cr_amt
	FROM vw_advance_deductions as ead
	WHERE (ead.in_payroll = true)
	GROUP BY ead.org_id, ead.period_id, ead.end_date, ead.gl_payroll_account)) as a
	ORDER BY gl_payroll_account desc, dr_amt desc, cr_amt desc;
	
CREATE VIEW vw_sun_ledger_trx AS
	SELECT org_id, period_id, end_date, entity_id,
		gl_payroll_account, description,
		department_account,  employee_id, function_code,
		description2, round(amount::numeric, 1) as gl_amount, debit_credit,
		(period_id::varchar || '.' || entity_id::varchar || '.' || COALESCE(gl_payroll_account, '')) as sun_ledger_id
	FROM 
	((SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.entity_id,
		vw_employee_month.gl_payroll_account, 'Payroll' as description, 
		departments.department_account, vw_employee_month.employee_id, departments.function_code,
		to_char(vw_employee_month.start_date, 'Month YYYY') || ' - Basic Pay' as description2, 
		vw_employee_month.basic_pay as amount,
		'D' as debit_credit
	FROM vw_employee_month INNER JOIN departments ON vw_employee_month.department_id = departments.department_id)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.entity_id,
		vw_employee_month.employee_id, vw_employee_month.entity_name,
		'', '', '',
		to_char(vw_employee_month.start_date, 'Month YYYY') || ' - Netpay' as description2, 
		net_pay as amount,
		'C' as debit_credit
	FROM vw_employee_month)
	UNION
	(SELECT vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.entity_id,
		vw_employee_adjustments.account_number, vw_employee_adjustments.adjustment_name, 
		vw_employee_adjustments.department_account, vw_employee_adjustments.employee_id, vw_employee_adjustments.function_code,
		to_char(vw_employee_adjustments.start_date, 'Month YYYY') || ' - ' || vw_employee_adjustments.adjustment_name as description2, 
			
		sum(vw_employee_adjustments.amount),
		'D' as debit_credit
	FROM vw_employee_adjustments
	WHERE (vw_employee_adjustments.visible = true) AND (vw_employee_adjustments.adjustment_type = 1)
	GROUP BY vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.entity_id,
		vw_employee_adjustments.account_number, vw_employee_adjustments.adjustment_name, 
		vw_employee_adjustments.department_account, vw_employee_adjustments.employee_id, vw_employee_adjustments.function_code,
		vw_employee_adjustments.start_date)
	UNION
	(SELECT vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.entity_id,
		vw_employee_adjustments.account_number, vw_employee_adjustments.adjustment_name, 
		vw_employee_adjustments.department_account, vw_employee_adjustments.employee_id, vw_employee_adjustments.function_code,
		to_char(vw_employee_adjustments.start_date, 'Month YYYY') || ' - ' || vw_employee_adjustments.adjustment_name as description2, 
			
		sum(vw_employee_adjustments.amount),
		'C' as debit_credit
	FROM vw_employee_adjustments
	WHERE (vw_employee_adjustments.visible = true) AND (vw_employee_adjustments.adjustment_type = 2)
	GROUP BY vw_employee_adjustments.org_id, vw_employee_adjustments.period_id, vw_employee_adjustments.end_date, vw_employee_adjustments.entity_id,
		vw_employee_adjustments.account_number, vw_employee_adjustments.adjustment_name, 
		vw_employee_adjustments.department_account, vw_employee_adjustments.employee_id, vw_employee_adjustments.function_code,
		vw_employee_adjustments.start_date)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.entity_id,
		vw_employee_tax_types.account_number, vw_employee_tax_types.tax_type_name,
		vw_employee_tax_types.department_account, vw_employee_tax_types.employee_id, vw_employee_tax_types.function_code,
		to_char(vw_employee_tax_types.start_date, 'Month YYYY') || ' - ' || vw_employee_tax_types.tax_type_name || ' - Deduction',
		(vw_employee_tax_types.amount + vw_employee_tax_types.additional + vw_employee_tax_types.employer),
		'C' as debit_credit
	FROM vw_employee_tax_types)
	UNION
	(SELECT vw_employee_tax_types.org_id, vw_employee_tax_types.period_id, vw_employee_tax_types.end_date, vw_employee_tax_types.entity_id,
		vw_employee_tax_types.employer_account, vw_employee_tax_types.tax_type_name,
		vw_employee_tax_types.department_account, vw_employee_tax_types.employee_id, vw_employee_tax_types.function_code,
		to_char(vw_employee_tax_types.start_date, 'Month YYYY') || ' - ' || vw_employee_tax_types.tax_type_name || ' - Contribution',
		vw_employee_tax_types.employer,
		'D' as debit_credit
	FROM vw_employee_tax_types
	WHERE vw_employee_tax_types.employer > 0)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.entity_id,
		vw_employee_month.employee_id, vw_employee_month.entity_name,
		'', '', '',
		to_char(vw_employee_month.start_date, 'Month YYYY') || ' - Payroll Banking' as description2, 
		banked as amount,
		'D' as debit_credit
	FROM vw_employee_month)
	UNION
	(SELECT vw_employee_month.org_id, vw_employee_month.period_id, vw_employee_month.end_date, vw_employee_month.entity_id,
		vw_employee_month.gl_bank_account, 'Bank Account',
		'', '', '',
		to_char(vw_employee_month.start_date, 'Month YYYY') || ' - Payroll Banking' as description2, 
		banked as amount,
		'C' as debit_credit
	FROM vw_employee_month)) as a
	ORDER BY gl_payroll_account desc, amount desc, debit_credit desc;

CREATE OR REPLACE FUNCTION getAdjustment(int, int, int) RETURNS float AS $$
DECLARE
	adjustment float;
BEGIN

	IF ($3 = 1) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2);
	ELSIF ($3 = 2) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (In_payroll = true) AND (Visible = true);
	ELSIF ($3 = 3) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (In_Tax = true);
	ELSIF ($3 = 4) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (In_payroll = true);
	ELSIF ($3 = 5) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (Visible = true);
	ELSIF ($3 = 11) THEN
		SELECT SUM(exchange_rate * (amount + additional)) INTO adjustment
		FROM employee_tax_types
		WHERE (Employee_Month_ID = $1);
	ELSIF ($3 = 12) THEN
		SELECT SUM(exchange_rate * (amount + additional)) INTO adjustment
		FROM employee_tax_types
		WHERE (Employee_Month_ID = $1) AND (In_Tax = true);
	ELSIF ($3 = 14) THEN
		SELECT SUM(exchange_rate * (amount + additional)) INTO adjustment
		FROM employee_tax_types
		WHERE (Employee_Month_ID = $1) AND (Tax_Type_ID = $2);
	ELSIF ($3 = 21) THEN
		SELECT SUM(exchange_rate * amount * adjustment_factor) INTO adjustment
		FROM employee_adjustments
		WHERE (employee_month_id = $1) AND (in_tax = true);
	ELSIF ($3 = 22) THEN
		SELECT SUM(exchange_rate * amount * adjustment_factor) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (In_payroll = true) AND (Visible = true);
	ELSIF ($3 = 23) THEN
		SELECT SUM(exchange_rate * amount * adjustment_factor) INTO adjustment
		FROM employee_adjustments
		WHERE (employee_month_id = $1) AND (in_tax = true) AND (adjustment_factor = 1);
	ELSIF ($3 = 24) THEN
		SELECT SUM(exchange_rate * tax_reduction_amount) INTO adjustment
		FROM employee_adjustments
		WHERE (employee_month_id = $1) AND (in_tax = true) AND (adjustment_factor = -1);
	ELSIF ($3 = 25) THEN
		SELECT SUM(exchange_rate * tax_relief_amount) INTO adjustment
		FROM employee_adjustments
		WHERE (employee_month_id = $1) AND (in_tax = true) AND (adjustment_factor = -1);
	ELSIF ($3 = 31) THEN
		SELECT SUM(overtime * overtime_rate) INTO adjustment
		FROM employee_overtime
		WHERE (Employee_Month_ID = $1) AND (approve_status = 'Approved');
	ELSIF ($3 = 32) THEN
		SELECT SUM(exchange_rate * tax_amount) INTO adjustment
		FROM employee_per_diem
		WHERE (Employee_Month_ID = $1) AND (approve_status = 'Approved');
	ELSIF ($3 = 33) THEN
		SELECT SUM(exchange_rate * (full_amount -  cash_paid)) INTO adjustment
		FROM Employee_Per_Diem
		WHERE (Employee_Month_ID = $1) AND (approve_status = 'Approved');
	ELSIF ($3 = 34) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_advances
		WHERE (Employee_Month_ID = $1) AND (in_payroll = true);
	ELSIF ($3 = 35) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM advance_deductions
		WHERE (Employee_Month_ID = $1) AND (In_payroll = true);
	ELSIF ($3 = 36) THEN
		SELECT SUM(exchange_rate * paid_amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1) AND (In_payroll = true) AND (Visible = true);
	ELSIF ($3 = 37) THEN
		SELECT SUM(exchange_rate * tax_relief_amount) INTO adjustment
		FROM employee_adjustments
		WHERE (Employee_Month_ID = $1);

		IF(adjustment IS NULL)THEN
			adjustment := 0;
		END IF;
	ELSIF ($3 = 41) THEN
		SELECT SUM(exchange_rate * amount) INTO adjustment
		FROM employee_banking
		WHERE (Employee_Month_ID = $1);
	ELSE
		adjustment := 0;
	END IF;

	IF(adjustment is null) THEN
		adjustment := 0;
	END IF;

	RETURN adjustment;
END;
$$ LANGUAGE plpgsql;

