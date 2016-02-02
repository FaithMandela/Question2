

DROP VIEW vw_pensions CASCADE;
CREATE VIEW vw_pensions AS
	SELECT entitys.entity_id, entitys.entity_name,
		adjustments.adjustment_id, adjustments.adjustment_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		pensions.contribution_id, contributions.adjustment_name as contribution_name, 
		pensions.org_id, pensions.pension_id, pensions.pension_company, pensions.pension_number, 
		pensions.amount, pensions.use_formura, pensions.employer_ps, pensions.employer_amount, 
		pensions.employer_formural, pensions.active, pensions.details
	FROM pensions INNER JOIN entitys ON pensions.entity_id = entitys.entity_id
		INNER JOIN adjustments ON pensions.adjustment_id = adjustments.adjustment_id
		INNER JOIN adjustments as contributions ON pensions.contribution_id = contributions.adjustment_id
		INNER JOIN currency ON adjustments.currency_id = currency.currency_id;
		
CREATE VIEW vw_employee_pensions AS
	SELECT a.entity_id, a.entity_name, a.adjustment_id, a.adjustment_name, a.contribution_id, 
		a.contribution_name, a.org_id, a.pension_id, a.pension_company, a.pension_number, 
		a.active, a.currency_id, a.currency_name, a.currency_symbol,
		b.period_id, b.start_date, b.employee_month_id, 
		COALESCE(b.amount, 0) as amount, 
		COALESCE(b.base_amount, 0) as base_amount,
		COALESCE(c.amount, 0) as employer_amount, 
		COALESCE(c.base_amount, 0) as employer_base_amount,
		(b.amount + COALESCE(c.amount, 0)) as pension_amount, 
		(b.base_amount + COALESCE(c.base_amount, 0)) as pension_base_amount
	FROM (vw_pensions as a INNER JOIN vw_pension_adjustments as b 
		ON (a.pension_id = b.pension_id) AND (a.adjustment_id = b.adjustment_id))
		LEFT JOIN vw_pension_adjustments as c
		ON (a.pension_id = c.pension_id) AND (a.contribution_id = c.adjustment_id)
		AND (b.employee_month_id = c.employee_month_id);

		
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
		
		v_amount := 0;
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
			
			v_amount := 0;
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
			
			IF(v_employee_adjustment_id is null) AND (v_employee_month_id is not null) AND (v_amount > 0) THEN
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

