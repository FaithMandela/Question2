
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
	ELSIF ($3 = '3') THEN
		UPDATE periods SET closed = true
		WHERE (period_id = CAST($1 as int));

		msg := 'Period closed';
	ELSIF ($3 = '4') THEN
		UPDATE periods SET closed = false
		WHERE (period_id = CAST($1 as int));

		msg := 'Period opened';
	END IF;

	RETURN msg;
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
			UPDATE employee_adjustments SET amount = tax * .7
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


CREATE OR REPLACE FUNCTION ins_employees() RETURNS trigger AS $$
DECLARE
	v_entity_type_id		integer;
	v_use_type				integer;
	v_org_sufix 			varchar(4);
	v_first_password		varchar(12);
	v_user_count			integer;
	v_user_name				varchar(120);
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF(NEW.entity_id IS NULL) THEN
			SELECT org_sufix INTO v_org_sufix
			FROM orgs WHERE (org_id = NEW.org_id);
			
			IF(v_org_sufix is null)THEN v_org_sufix := ''; END IF;

			NEW.entity_id := nextval('entitys_entity_id_seq');

			IF(NEW.employee_id is null) THEN
				NEW.employee_id := NEW.entity_id;
			END IF;
			
			SELECT entity_type_id INTO v_entity_type_id
			FROM entity_types 
			WHERE (org_id = NEW.org_id) AND (use_key_id = 1);

			v_first_password := first_password();
			v_user_name := NEW.employee_id;

			SELECT count(entity_id) INTO v_user_count
			FROM entitys
			WHERE (org_id = NEW.org_id) AND (user_name = v_user_name);
			IF(v_user_count > 0) THEN v_user_name := v_user_name || v_user_count::varchar; END IF;

			INSERT INTO entitys (entity_id, org_id, entity_type_id, use_key_id,
				entity_name, user_name, primary_email, function_role, 
				first_password, entity_password)
			VALUES (NEW.entity_id, NEW.org_id, v_entity_type_id, 1, 
				(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
				v_user_name, NEW.employee_email, 'staff',
				v_first_password, md5(v_first_password));
				
			INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name, email_type)
			SELECT org_id, sys_email_id, NEW.entity_id, 'entitys', 1
			FROM sys_emails
			WHERE (use_type = 2) AND (org_id = NEW.org_id);
			
			INSERT INTO e_fields (et_field_id, org_id, table_code, table_id)
			SELECT et_fields.et_field_id, et_fields.org_id, et_fields.table_code, NEW.entity_id
			FROM et_fields
			WHERE (et_fields.org_id = NEW.org_id) AND (et_fields.table_code = 101);
		ELSE
			INSERT INTO e_fields (et_field_id, org_id, table_code, table_id)
			SELECT et_fields.et_field_id, et_fields.org_id, et_fields.table_code, NEW.entity_id
			FROM et_fields LEFT JOIN 
			(SELECT et_field_id FROM e_fields WHERE (org_id = NEW.org_id) AND (table_id = NEW.entity_id)) as ef
			ON et_fields.et_field_id = ef.et_field_id
			WHERE (et_fields.org_id = NEW.org_id) AND (et_fields.table_code = 101) AND (ef.et_field_id is null);
		END IF;

		v_use_type := 2;
		IF(NEW.gender = 'M')THEN v_use_type := 3; END IF;

		--- Add default leave types
		INSERT INTO employee_leave_types (entity_id, org_id, leave_type_id, leave_balance)
		SELECT NEW.entity_id, NEW.org_id, leave_type_id, 0
		FROM leave_types
		WHERE (org_id = NEW.org_id) AND ((use_type = 1) OR (use_type = v_use_type));
		
		--- Add default task rate definations
		INSERT INTO task_entitys (entity_id, org_id, task_type_id, task_entity_cost, task_entity_price)
		SELECT NEW.entity_id, NEW.org_id, task_type_id, default_cost, default_price
		FROM task_types
		WHERE (org_id = NEW.org_id);
	
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
			primary_email = NEW.employee_email
		WHERE entity_id = NEW.entity_id;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

