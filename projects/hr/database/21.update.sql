ALTER TABLE orgs ADD default_country_id		char(2) references sys_countrys;
ALTER TABLE orgs ADD license				text;
CREATE INDEX orgs_default_country_id ON orgs(default_country_id);


UPDATE orgs SET default_country_id = 'KE';

CREATE OR REPLACE FUNCTION get_default_country(int) RETURNS char(2) AS $$
    SELECT default_country_id::varchar(12)
	FROM orgs
	WHERE (org_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_default_currency(int) RETURNS int AS $$
    SELECT currency_id
	FROM orgs
	WHERE (org_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION ins_subscriptions() RETURNS trigger AS $$
DECLARE
	v_entity_id		integer;
	v_org_id		integer;
	v_currency_id	integer;
	v_department_id	integer;
	v_bank_id		integer;
	v_org_suffix    char(2);
	rec 			RECORD;
BEGIN

	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys WHERE lower(trim(user_name)) = lower(trim(NEW.primary_email));

		IF(v_entity_id is null)THEN
			NEW.entity_id := nextval('entitys_entity_id_seq');
			INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, primary_email,  function_role, first_password)
			VALUES (NEW.entity_id, 0, 5, NEW.primary_contact, lower(trim(NEW.primary_email)), lower(trim(NEW.primary_email)), 'subscription', null);
		
			INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name)
			VALUES (4, 0, NEW.entity_id, 'subscription');
		
			NEW.approve_status := 'Completed';
		ELSE
			RAISE EXCEPTION 'You already have an account, login and request for services';
		END IF;
	ELSIF(NEW.approve_status = 'Approved')THEN

		NEW.org_id := nextval('orgs_org_id_seq');
		INSERT INTO orgs(org_id, currency_id, org_name, org_sufix, default_country_id)
		VALUES(NEW.org_id, 2, NEW.business_name, NEW.org_id, NEW.country_id);
		
		v_currency_id := nextval('currency_currency_id_seq');
		INSERT INTO currency (org_id, currency_id, currency_name, currency_symbol) VALUES (NEW.org_id, v_currency_id, 'US Dollar', 'USD');
		v_currency_id := nextval('currency_currency_id_seq');
		INSERT INTO currency (org_id, currency_id, currency_name, currency_symbol) VALUES (NEW.org_id, v_currency_id, 'Euro', 'ERO');
		UPDATE orgs SET currency_id = v_currency_id WHERE org_id = NEW.org_id;
		
		INSERT INTO pay_scales (org_id, pay_scale_name, min_pay, max_pay) VALUES (NEW.org_id, 'Basic', 0, 1000000);
		INSERT INTO pay_groups (org_id, pay_group_name) VALUES (NEW.org_id, 'Default');
		INSERT INTO locations (org_id, location_name) VALUES (NEW.org_id, 'Main office');

		v_department_id := nextval('departments_department_id_seq');
		INSERT INTO Departments (org_id, department_id, department_name) VALUES (NEW.org_id, v_department_id, 'Board of Directors');
		INSERT INTO department_roles (org_id, department_id, department_role_name, active) VALUES (NEW.org_id, v_department_id, 'Board of Directors', true);
		
		v_bank_id := nextval('banks_bank_id_seq');
		INSERT INTO banks (org_id, bank_id, bank_name) VALUES (NEW.org_id, v_bank_id, 'Cash');
		INSERT INTO bank_branch (org_id, bank_id, bank_branch_name) VALUES (NEW.org_id, v_bank_id, 'Cash');
		
		UPDATE entitys SET org_id = NEW.org_id, function_role='subscription,admin,staff,finance'
		WHERE entity_id = NEW.entity_id;

		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name)
		VALUES (5, NEW.org_id, NEW.entity_id, 'subscription');
			
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


ALTER TABLE applications ADD	previous_salary			real;
ALTER TABLE applications ADD	expected_salary			real;
ALTER TABLE applications ADD	review_rating			integer;

ALTER TABLE contract_types ADD contract_text text;
	
DROP VIEW vw_contracting;
DROP VIEW vw_applications;
DROP VIEW vw_intake;

CREATE VIEW vw_intake AS
	SELECT vw_department_roles.department_id, vw_department_roles.department_name, vw_department_roles.department_description, 
		vw_department_roles.department_duties, vw_department_roles.department_role_id, vw_department_roles.department_role_name,
		vw_department_roles.parent_role_name,
		vw_department_roles.job_description, vw_department_roles.job_requirements, vw_department_roles.duties, 
		vw_department_roles.performance_measures, 
		
		locations.location_id, locations.location_name, pay_groups.pay_group_id, pay_groups.pay_group_name, 
		pay_scales.pay_scale_id, pay_scales.pay_scale_name, 
		
		intake.org_id, intake.intake_id, intake.opening_date, intake.closing_date, intake.positions, intake.contract, 
		intake.contract_period, intake.details,
		
		(vw_department_roles.department_name || ', ' || vw_department_roles.department_role_name || ', ' || to_char(intake.opening_date, 'YYYY, Mon')) as intake_disp
	FROM intake INNER JOIN vw_department_roles ON intake.department_role_id = vw_department_roles.department_role_id
		INNER JOIN locations ON intake.location_id = locations.location_id
		INNER JOIN pay_groups ON intake.pay_group_id = pay_groups.pay_group_id
		INNER JOIN pay_scales ON intake.pay_scale_id = pay_scales.pay_scale_id;

CREATE VIEW vw_applications AS
	SELECT vw_intake.department_id, vw_intake.department_name, vw_intake.department_description, vw_intake.department_duties,
		vw_intake.department_role_id, vw_intake.department_role_name, vw_intake.parent_role_name,
		vw_intake.job_description, vw_intake.job_requirements, vw_intake.duties, vw_intake.performance_measures, 
		vw_intake.intake_id, vw_intake.opening_date, vw_intake.closing_date, vw_intake.positions, 
		entitys.entity_id, entitys.entity_name, entitys.primary_email,
		
		applications.org_id,
		applications.application_id, applications.employee_id, applications.contract_date, applications.contract_close, 
		applications.contract_start, applications.contract_period, applications.contract_terms, applications.initial_salary, 
		applications.application_date, applications.approve_status, applications.workflow_table_id, applications.action_date, 
		applications.applicant_comments, applications.review, applications.short_listed,
		applications.previous_salary, applications.expected_salary, applications.review_rating,

		vw_education_max.education_class_name, vw_education_max.date_from, vw_education_max.date_to, 
		vw_education_max.name_of_school, vw_education_max.examination_taken, 
		vw_education_max.grades_obtained, vw_education_max.certificate_number,

		vw_employment_max.employment_id, vw_employment_max.employers_name, vw_employment_max.position_held,
		vw_employment_max.date_from as emp_date_from, vw_employment_max.date_to as emp_date_to, 
		vw_employment_max.employment_duration, vw_employment_max.employment_experince,
		round((date_part('year', vw_employment_max.employment_duration) + date_part('month', vw_employment_max.employment_duration)/12)::numeric, 1) as emp_duration,
		round((date_part('year', vw_employment_max.employment_experince) + date_part('month', vw_employment_max.employment_experince)/12)::numeric, 1) as emp_experince
		
	FROM applications INNER JOIN entitys ON applications.entity_id = entitys.entity_id
		INNER JOIN vw_intake ON applications.intake_id = vw_intake.intake_id
		LEFT JOIN vw_education_max ON entitys.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON entitys.entity_id = vw_employment_max.entity_id;
		
CREATE VIEW vw_contracting AS
	SELECT vw_intake.department_id, vw_intake.department_name, vw_intake.department_description, vw_intake.department_duties,
		vw_intake.department_role_id, vw_intake.department_role_name, 
		vw_intake.job_description, vw_intake.parent_role_name,
		vw_intake.job_requirements, vw_intake.duties, vw_intake.performance_measures, 
		vw_intake.intake_id, vw_intake.opening_date, vw_intake.closing_date, vw_intake.positions, 
		entitys.entity_id, entitys.entity_name, 
		
		orgs.org_id, orgs.org_name,
		
		contract_types.contract_type_id, contract_types.contract_type_name, contract_types.contract_text,
		contract_status.contract_status_id, contract_status.contract_status_name,
		
		applications.application_id, applications.employee_id, applications.contract_date, applications.contract_close, 
		applications.contract_start, applications.contract_period, applications.contract_terms, applications.initial_salary, 
		applications.application_date, applications.approve_status, applications.workflow_table_id, applications.action_date, 
		applications.applicant_comments, applications.review, 

		vw_education_max.education_class_name, vw_education_max.date_from, vw_education_max.date_to, 
		vw_education_max.name_of_school, vw_education_max.examination_taken, 
		vw_education_max.grades_obtained, vw_education_max.certificate_number,

		vw_employment_max.employment_id, vw_employment_max.employers_name, vw_employment_max.position_held,
		vw_employment_max.date_from as emp_date_from, vw_employment_max.date_to as emp_date_to, 
		
		vw_employment_max.employment_duration, vw_employment_max.employment_experince,
		round((date_part('year', vw_employment_max.employment_duration) + date_part('month', vw_employment_max.employment_duration)/12)::numeric, 1) as emp_duration,
		round((date_part('year', vw_employment_max.employment_experince) + date_part('month', vw_employment_max.employment_experince)/12)::numeric, 1) as emp_experince

	FROM applications INNER JOIN entitys ON applications.employee_id = entitys.entity_id
		INNER JOIN orgs ON applications.org_id = orgs.org_id
		LEFT JOIN vw_intake ON applications.intake_id = vw_intake.intake_id
		LEFT JOIN contract_types ON applications.contract_type_id = contract_types.contract_type_id
		LEFT JOIN contract_status ON applications.contract_status_id = contract_status.contract_status_id
		LEFT JOIN vw_education_max ON entitys.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON entitys.entity_id = vw_employment_max.entity_id;

CREATE OR REPLACE FUNCTION process_pensions(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec							RECORD;
	adj							RECORD;
	v_period_id					integer;
	v_org_id					integer;
	v_employee_month_id			integer;
	v_employee_adjustment_id	integer;
	v_exchange_rate				real;
	v_amount					real;
	msg							varchar(120);
BEGIN

	SELECT period_id, org_id INTO v_period_id, v_org_id
	FROM periods WHERE period_id = $1::int;
	
	FOR rec IN SELECT pension_id, entity_id, adjustment_id, contribution_id, 
       pension_company, pension_number, amount, use_formura, 
       employer_ps, employer_amount, employer_formural
	FROM pensions WHERE (active = true) AND (org_id = v_org_id) LOOP
	
		SELECT employee_month_id INTO v_employee_month_id
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
		
		IF(rec.use_formura = true) AND (adj.formural is not null)THEN
			EXECUTE 'SELECT ' || adj.formural || ' FROM employee_month WHERE employee_month_id = ' || v_employee_month_id
			INTO v_amount;
		ELSIF(rec.amount > 0)THEN
			v_amount := rec.amount;
		END IF;
		
		IF(v_employee_adjustment_id is null)THEN
			INSERT INTO employee_adjustments(employee_month_id, pension_id, org_id, 
				adjustment_id, adjustment_type, adjustment_factor, 
				in_payroll, in_tax, visible,
				exchange_rate, pay_date, amount)
			VALUES (v_employee_month_id, rec.pension_id, v_org_id,
				adj.adjustment_id, adj.adjustment_type, -1, 
				adj.in_payroll, adj.in_tax, adj.visible,
				1, current_date, v_amount);
		ELSE
			UPDATE employee_adjustments SET amount = v_amount
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
			
			IF(rec.employer_formural = true) AND (adj.formural is not null)THEN
				EXECUTE 'SELECT ' || adj.formural || ' FROM employee_month WHERE employee_month_id = ' || v_employee_month_id
				INTO v_amount;
			ELSIF(rec.employer_ps > 0)THEN
				v_amount := v_amount * rec.employer_ps / 100;
			ELSIF(rec.employer_amount > 0)THEN
				v_amount := rec.employer_amount;
			END IF;
			
			IF(v_employee_adjustment_id is null)THEN
				INSERT INTO employee_adjustments(employee_month_id, pension_id, org_id, 
					adjustment_id, adjustment_type, adjustment_factor, 
					in_payroll, in_tax, visible,
					exchange_rate, pay_date, amount)
				VALUES (v_employee_month_id, rec.pension_id, v_org_id,
					adj.adjustment_id, adj.adjustment_type, 1, 
					adj.in_payroll, adj.in_tax, adj.visible,
					1, current_date, v_amount);
			ELSE
				UPDATE employee_adjustments SET amount = v_amount
				WHERE employee_adjustment_id = v_employee_adjustment_id;
			END IF;
		END IF;
		
	END LOOP;

	msg := 'Pension Processed';

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

