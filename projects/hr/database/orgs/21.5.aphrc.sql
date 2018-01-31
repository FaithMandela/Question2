		
CREATE OR REPLACE FUNCTION leave_aplication(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_leave_balance			real;
	v_leave_total			real;
	v_leave_overlap			integer;
	v_approve_status		varchar(16);
	v_table_id				integer;
	v_employee_month_id		integer;
	v_month_leave			real;
	v_leave_ending			date;
	rec						RECORD;
	msg 					varchar(120);
BEGIN
	msg := 'Leave applied';

	SELECT leave_types.leave_days_span, leave_types.month_limit, leave_types.maximum_days,
		employee_leave.employee_leave_id, employee_leave.entity_id, employee_leave.leave_type_id,
		employee_leave.leave_days, employee_leave.leave_from, employee_leave.leave_to,
		employee_leave.contact_entity_id, employee_leave.narrative,
		adjustments.adjustment_id, adjustments.adjustment_type
		INTO rec
	FROM leave_types INNER JOIN employee_leave ON leave_types.leave_type_id = employee_leave.leave_type_id
		LEFT JOIN adjustments ON leave_types.adjustment_id = adjustments.adjustment_id
	WHERE (employee_leave.employee_leave_id = CAST($1 as int));
	
	SELECT leave_ending INTO v_leave_ending 
	FROM employee_leave_types 
	WHERE (entity_id = rec.entity_id) AND (leave_type_id = rec.leave_type_id);

	v_leave_balance := get_leave_balance(rec.entity_id, rec.leave_type_id);
	
	SELECT sum(employee_leave.leave_days) INTO v_leave_total
	FROM employee_leave 
	WHERE (entity_id = rec.entity_id) AND (leave_type_id = rec.leave_type_id) AND (approve_status = 'Rejected');

	SELECT count(employee_leave_id) INTO v_leave_overlap
	FROM employee_leave
	WHERE (entity_id = rec.entity_id) AND (approve_status <> 'Rejected')
		AND (employee_leave_id <> rec.employee_leave_id)
		AND (((leave_from, leave_to) OVERLAPS (rec.leave_from - 1, rec.leave_to + 1)) = true);
		
	SELECT sum(employee_leave_id) INTO v_month_leave
	FROM employee_leave
	WHERE (entity_id = rec.entity_id) AND (approve_status <> 'Rejected')
		AND (leave_type_id = rec.leave_type_id)
		AND (to_char(leave_from, 'YYYYMM') =  to_char(current_date, 'YYYYMM'));
	IF(v_month_leave is null)THEN v_month_leave := 0; END IF;

	SELECT approve_status INTO v_approve_status
	FROM employee_leave
	WHERE (employee_leave_id = CAST($1 as int));
	
	IF(rec.adjustment_id is not null)THEN
		SELECT employee_month.employee_month_id INTO v_employee_month_id
		FROM periods INNER JOIN employee_month ON periods.period_id = employee_month.period_id
		WHERE (employee_month.entity_id = rec.entity_id)
		AND (rec.leave_from BETWEEN periods.start_date AND periods.end_date);
	END IF;
	
	IF(rec.contact_entity_id is null)THEN
		RAISE EXCEPTION 'You must enter a contact person.';
	ELSIF(v_approve_status <> 'Draft')THEN
		msg := 'Your application is not a draft.';
		RAISE EXCEPTION '%', msg;
	ELSIF(rec.leave_days > rec.leave_days_span)THEN
		msg := 'Days applied for excced the span allowed';
		RAISE EXCEPTION '%', msg;
	ELSIF(rec.leave_from < current_date - 60)THEN
		msg := 'Apply leave within correct period';
		RAISE EXCEPTION '%', msg;
	ELSIF(v_leave_balance <= 0)THEN
		msg := 'You do not have enough days to apply for this leave';
		RAISE EXCEPTION '%', msg;
	ELSIF(v_leave_overlap > 0)THEN
		msg := 'You have applied for overlaping leave days';
		RAISE EXCEPTION '%', msg;
	ELSIF((rec.month_limit > 0) AND (v_month_leave > rec.month_limit))THEN
		msg := 'You exceed the month limit';
		RAISE EXCEPTION '%', msg;
	ELSIF((rec.maximum_days > 0) AND (v_leave_total > rec.maximum_days))THEN
		msg := 'You exceed the total allowed leave day limit';
		RAISE EXCEPTION '%', msg;
	ELSIF((v_leave_ending is not null) AND (v_leave_ending < rec.leave_to))THEN
		msg := 'You are not allowed to apply for the leave past ' || to_char(v_leave_ending, 'DD Mon YYYY');
		RAISE EXCEPTION '%', msg;
	ELSIF((rec.adjustment_id is not null) AND (v_employee_month_id is null))THEN
		msg := 'This leave has an allowance or deduction and needs to be applied on a valid month';
		RAISE EXCEPTION '%', msg;
	ELSE
		UPDATE employee_leave SET approve_status = 'Completed'
		WHERE (employee_leave_id = CAST($1 as int));
		
		SELECT workflow_table_id INTO v_table_id
		FROM employee_leave
		WHERE (employee_leave_id = CAST($1 as int));
		
		UPDATE approvals SET approval_narrative = rec.narrative
		WHERE (table_name = 'employee_leave') AND (table_id = v_table_id);
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

--------- New update

CREATE OR REPLACE FUNCTION add_employee(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_application_id		integer;
	v_applicant_id			integer;
	v_entity_id				integer;
	v_employee_id			integer;
	v_intake_id				integer;
	v_department_role_id	integer;
	v_org_id				integer;
	v_initial_salary		real;
	msg		 				varchar(120);
BEGIN

	v_application_id := $1::int;
	SELECT employees.entity_id, applications.employee_id, applications.intake_id, applications.initial_salary, 
			applications.entity_id, applications.org_id, applications.department_role_id
		INTO v_entity_id, v_employee_id, v_intake_id, v_initial_salary, v_applicant_id, v_org_id, v_department_role_id
	FROM applications LEFT JOIN employees ON applications.entity_id = employees.entity_id
	WHERE (application_id = v_application_id);

	IF(v_employee_id is null) AND (v_entity_id is null)THEN	
		INSERT INTO employees (org_id, currency_id, bank_branch_id,
			department_role_id, pay_scale_id, pay_group_id, location_id,  
			person_title, surname, first_name, middle_name,
			date_of_birth, gender, nationality, marital_status,
			picture_file, identity_card, language, interests, objective,
			contract, appointment_date, current_appointment, contract_period,
			basic_salary)

		SELECT orgs.org_id, orgs.currency_id, 0,
			intake.department_role_id, intake.pay_scale_id, intake.pay_group_id, intake.location_id,
			applicants.person_title, applicants.surname, applicants.first_name, applicants.middle_name,  
			applicants.date_of_birth, applicants.gender, applicants.nationality, applicants.marital_status, 
			applicants.picture_file, applicants.identity_card, applicants.language, applicants.interests, applicants.objective,
			
			intake.contract, applications.contract_date, applications.contract_start, 
			applications.contract_period, applications.initial_salary
		FROM applicants INNER JOIN applications ON applicants.entity_id = applications.entity_id
			INNER JOIN intake ON applications.intake_id = intake.intake_id
			INNER JOIN orgs ON intake.org_id = orgs.org_id
			
		WHERE (applications.application_id = v_application_id);
		
		v_entity_id := currval('entitys_entity_id_seq');
		
		UPDATE applications SET employee_id = v_entity_id, approve_status = 'Completed',
			department_role_id = v_department_role_id
		WHERE (application_id = v_application_id);
		
		--- Copy address
		INSERT INTO address(address_type_id, sys_country_id, org_id, address_name, 
			table_name, table_id, post_office_box, postal_code, premises, 
			street, town, phone_number, extension, mobile, fax, email, website, 
			is_default, first_password, details, company_name, position_held)
		SELECT address_type_id, sys_country_id, v_org_id, address_name, 
			'employees', v_entity_id, post_office_box, postal_code, premises, 
			street, town, phone_number, extension, mobile, fax, email, website, 
			is_default, first_password, details, company_name, position_held
		FROM address
		WHERE (table_id = v_applicant_id) AND (table_name = 'applicant');
		
		--- Copy education
		INSERT INTO education(entity_id, education_class_id, org_id, date_from, 
			date_to, name_of_school, examination_taken, grades_obtained, certificate_number, details)
		SELECT v_entity_id, education_class_id, v_org_id, date_from, 
			date_to, name_of_school, examination_taken, grades_obtained, certificate_number, details
		FROM education
		WHERE (entity_id = v_applicant_id);
		
		--- Copy employment
		INSERT INTO employment(entity_id, org_id, date_from, date_to, employers_name, position_held, details)
		SELECT v_entity_id, v_org_id, date_from, date_to, employers_name, position_held, details
		FROM employment
		WHERE (entity_id = v_applicant_id);
		
		--- Copy Seminars
		INSERT INTO cv_seminars(entity_id, org_id, cv_seminar_name, cv_seminar_date, details)
		SELECT v_entity_id, v_org_id, cv_seminar_name, cv_seminar_date, details
		FROM cv_seminars
		WHERE (entity_id = v_applicant_id);

		INSERT INTO cv_projects(entity_id, org_id, cv_project_name, cv_project_date, details)
		SELECT v_entity_id, v_org_id, cv_project_name, cv_project_date, details
		FROM cv_projects
		WHERE (entity_id = v_applicant_id);

		--- Copy skills
		INSERT INTO skills(entity_id, skill_type_id, skill_level_id, org_id, state_skill, 
			aquired, training_date, trained, training_institution, training_cost, details)
		SELECT v_entity_id, skill_type_id, skill_level_id, v_org_id, state_skill, 
			aquired, training_date, trained, training_institution, training_cost, details
		FROM skills
		WHERE (entity_id = v_applicant_id);
		
		--- Copy referees
		INSERT INTO address(address_type_id, sys_country_id, org_id, address_name, 
			table_name, table_id, post_office_box, postal_code, premises, 
			street, town, phone_number, extension, mobile, fax, email, website, 
			details, company_name, position_held)
		SELECT address_type_id, sys_country_id, v_org_id, address_name, 
			'referees', v_entity_id, post_office_box, postal_code, premises, 
			street, town, phone_number, extension, mobile, fax, email, website, 
			details, company_name, position_held
		FROM address
		WHERE (table_id = v_applicant_id) AND (table_name = 'referees');
			
		msg := 'Employee added';
	ELSIF(v_employee_id is null) AND (v_entity_id is not null)THEN
		UPDATE employees SET department_role_id = intake.department_role_id, pay_scale_id = intake.pay_scale_id, 
			pay_group_id = intake.pay_group_id, location_id = intake.location_id,
			basic_salary = v_initial_salary
		FROM intake
		WHERE (employees.entity_id = v_entity_id) AND (intake.intake_id = v_intake_id);
		
		UPDATE applications SET employee_id = v_entity_id, approve_status = 'Completed'
		WHERE (application_id = v_application_id);
		
		msg := 'Employee details updated';
	ELSE
		msg := 'Employeed already added to the system';
	END IF;
	

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE applications ADD department_role_id	integer references department_roles;
CREATE INDEX applications_department_role_id ON applications (department_role_id);

UPDATE applications SET department_role_id = intake.department_role_id
FROM intake WHERE (applications.intake_id = intake.intake_id);

DROP VIEW vw_contracting;
CREATE VIEW vw_contracting AS
	SELECT vw_department_roles.department_id, vw_department_roles.department_name, 
		vw_department_roles.department_description, vw_department_roles.department_duties,
		vw_department_roles.department_role_id, vw_department_roles.department_role_name, 
		vw_department_roles.job_description, vw_department_roles.parent_role_name,
		vw_department_roles.job_requirements, vw_department_roles.duties, vw_department_roles.performance_measures,
		vw_intake.intake_id, vw_intake.opening_date, vw_intake.closing_date, vw_intake.positions, 
		entitys.entity_id, entitys.entity_name, orgs.org_id, orgs.org_name,
		
		contract_types.contract_type_id, contract_types.contract_type_name, contract_types.notice_period, contract_types.contract_text,
		contract_status.contract_status_id, contract_status.contract_status_name,
		
		applications.application_id, applications.employee_id, applications.contract_date, applications.contract_close, 
		applications.contract_start, applications.contract_period, applications.contract_terms, applications.initial_salary, 
		applications.application_date, applications.approve_status, applications.workflow_table_id, applications.action_date, 
		applications.applicant_comments, applications.review, 
		applications.notice_email, (current_date - applications.contract_close) as days_end_contract,

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
		LEFT JOIN vw_department_roles ON applications.department_role_id = vw_department_roles.department_role_id
		LEFT JOIN vw_intake ON applications.intake_id = vw_intake.intake_id
		LEFT JOIN contract_types ON applications.contract_type_id = contract_types.contract_type_id
		LEFT JOIN contract_status ON applications.contract_status_id = contract_status.contract_status_id
		LEFT JOIN vw_education_max ON entitys.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON entitys.entity_id = vw_employment_max.entity_id;
