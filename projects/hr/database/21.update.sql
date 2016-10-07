
ALTER TABLE contract_types ADD notice_period			integer default 30 not null;

ALTER TABLE applications ADD 	notice_email			boolean default false not null;
	
ALTER TABLE applicants ADD currency_id				integer references currency;
CREATE INDEX applicants_currency_id ON applicants(currency_id);

ALTER TABLE applications ADD	currency_id				integer references currency;
ALTER TABLE applications ADD	exchange_rate			real default 1;

DROP VIEW vw_contracting;
DROP VIEW vw_intern_evaluations;
DROP VIEW vw_applications;
DROP VIEW vw_applicants;

DROP VIEW vw_employee_tax_month;

CREATE VIEW vw_employee_tax_month AS
	SELECT emp.period_id, emp.start_date, emp.end_date, emp.overtime_rate, 
		emp.activated, emp.closed, emp.month_id, emp.period_year, emp.period_month,
		emp.quarter, emp.semister, emp.bank_header, emp.bank_address,
		emp.gl_payroll_account, emp.gl_bank_account, emp.is_posted,
		emp.bank_id, emp.bank_name, emp.bank_branch_id, 
		emp.bank_branch_name, emp.bank_branch_code,
		emp.pay_group_id, emp.pay_group_name, emp.department_id, emp.department_name,
		emp.department_role_id, emp.department_role_name, 
		emp.entity_id, emp.entity_name,
		emp.employee_id, emp.surname, emp.first_name, emp.middle_name, emp.date_of_birth, 
		emp.gender, emp.nationality, emp.marital_status, emp.appointment_date, emp.exit_date, 
		emp.contract, emp.contract_period, emp.employment_terms, emp.identity_card,
		emp.employee_name,
		emp.currency_id, emp.currency_name, emp.currency_symbol, emp.exchange_rate,
		
		emp.org_id, emp.employee_month_id, emp.bank_account, emp.basic_pay, emp.details,
		emp.overtime, emp.full_allowance, emp.payroll_allowance, emp.tax_allowance,
		emp.full_deduction, emp.payroll_deduction, emp.tax_deduction, emp.full_expense,
		emp.payroll_expense, emp.tax_expense, emp.payroll_tax, emp.tax_tax,
		emp.net_adjustment, emp.per_diem, emp.advance, emp.advance_deduction,
		emp.net_pay, emp.banked, emp.cost,
		(CASE WHEN emp.nationality = 'KE' THEN 'Resident' ELSE 'Non resident') as residence,
		
		tax_types.tax_type_id, tax_types.tax_type_name, tax_types.account_id, tax_types.use_type,
		employee_tax_types.employee_tax_type_id, employee_tax_types.tax_identification, 
		employee_tax_types.amount, employee_tax_types.exchange_rate as tax_exchange_rate,
		employee_tax_types.additional, employee_tax_types.employer, employee_tax_types.narrative,
		
		(employee_tax_types.amount * employee_tax_types.exchange_rate) as tax_base_amount

	FROM vw_employee_month as emp INNER JOIN employee_tax_types ON emp.employee_month_id = employee_tax_types.employee_month_id
		INNER JOIN tax_types ON employee_tax_types.tax_type_id = tax_types.tax_type_id;


CREATE VIEW vw_applicants AS
	SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		applicants.org_id, applicants.entity_id, applicants.surname, 
		applicants.first_name, applicants.middle_name, applicants.date_of_birth, applicants.nationality, 
		applicants.identity_card, applicants.language, applicants.objective, applicants.interests, applicants.picture_file, applicants.details,
		applicants.person_title, applicants.field_of_study, applicants.applicant_email, applicants.applicant_phone, 
		applicants.previous_salary, applicants.expected_salary,
		(applicants.Surname || ' ' || applicants.First_name || ' ' || COALESCE(applicants.Middle_name, '')) as applicant_name,
		to_char(age(applicants.date_of_birth), 'YY') as applicant_age,
		(CASE WHEN applicants.gender = 'M' THEN 'Male' ELSE 'Female' END) as gender_name,
		(CASE WHEN applicants.marital_status = 'M' THEN 'Married' ELSE 'Single' END) as marital_status_name,

		vw_education_max.education_class_id, vw_education_max.education_class_name, 
		vw_education_max.education_id, vw_education_max.date_from, vw_education_max.date_to, 
		vw_education_max.name_of_school, vw_education_max.examination_taken,
		vw_education_max.grades_obtained, vw_education_max.certificate_number,
		
		vw_employment_max.employers_name, vw_employment_max.position_held,
		vw_employment_max.date_from as emp_date_from, vw_employment_max.date_to as emp_date_to, 
		vw_employment_max.employment_duration, vw_employment_max.employment_experince,
		round((date_part('year', vw_employment_max.employment_duration) + date_part('month', vw_employment_max.employment_duration)/12)::numeric, 1) as emp_duration,
		round((date_part('year', vw_employment_max.employment_experince) + date_part('month', vw_employment_max.employment_experince)/12)::numeric, 1) as emp_experince
		
	FROM applicants INNER JOIN sys_countrys ON applicants.nationality = sys_countrys.sys_country_id
		LEFT JOIN vw_education_max ON applicants.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON applicants.entity_id = vw_employment_max.entity_id
		LEFT JOIN currency ON applicants.currency_id = currency.currency_id;


CREATE VIEW vw_applications AS
	SELECT vw_intake.department_id, vw_intake.department_name, vw_intake.department_description, vw_intake.department_duties,
		vw_intake.department_role_id, vw_intake.department_role_name, vw_intake.parent_role_name,
		vw_intake.job_description, vw_intake.job_requirements, vw_intake.duties, vw_intake.performance_measures, 
		vw_intake.intake_id, vw_intake.opening_date, vw_intake.closing_date, vw_intake.positions, 
		vw_intake.org_name, vw_intake.org_detail,
		entitys.entity_id, entitys.entity_name, entitys.primary_email,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		
		applications.org_id,
		applications.application_id, applications.employee_id, applications.contract_date, applications.contract_close, 
		applications.contract_start, applications.contract_period, applications.contract_terms, applications.initial_salary, 
		applications.application_date, applications.approve_status, applications.workflow_table_id, applications.action_date, 
		applications.applicant_comments, applications.review, applications.short_listed,
		applications.previous_salary, applications.expected_salary, applications.exchange_rate, applications.review_rating,

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
		LEFT JOIN vw_employment_max ON entitys.entity_id = vw_employment_max.entity_id
		LEFT JOIN currency ON applications.currency_id = currency.currency_id;
		
		
CREATE VIEW vw_intern_evaluations AS 
	SELECT vw_applicants.entity_id, vw_applicants.sys_country_name, vw_applicants.applicant_name, 
		vw_applicants.applicant_age, vw_applicants.gender_name, vw_applicants.marital_status_name, vw_applicants.language, 
		vw_applicants.objective, vw_applicants.interests, education.date_from, education.date_to, education.name_of_school, 
		education.examination_taken, vw_internships.department_id, vw_internships.department_name, 
		vw_internships.internship_id, vw_internships.positions, vw_internships.opening_date, vw_internships.closing_date, 

		interns.intern_id, interns.payment_amount, interns.start_date, interns.end_date, interns.application_date, 
		interns.approve_status, interns.action_date, interns.workflow_table_id, interns.applicant_comments, interns.review
	FROM vw_applicants JOIN education ON vw_applicants.entity_id = education.entity_id
		JOIN interns ON interns.entity_id = vw_applicants.entity_id
		JOIN vw_internships ON interns.internship_id = vw_internships.internship_id
		JOIN (SELECT education.entity_id, max(education.education_class_id) AS mx_class_id FROM education
			WHERE education.entity_id IS NOT NULL
			GROUP BY education.entity_id) a ON education.entity_id = a.entity_id AND education.education_class_id = a.mx_class_id
		WHERE education.education_class_id > 6
		ORDER BY vw_applicants.entity_id;
		
CREATE VIEW vw_contracting AS
	SELECT vw_intake.department_id, vw_intake.department_name, vw_intake.department_description, vw_intake.department_duties,
		vw_intake.department_role_id, vw_intake.department_role_name, 
		vw_intake.job_description, vw_intake.parent_role_name,
		vw_intake.job_requirements, vw_intake.duties, vw_intake.performance_measures, 
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
		LEFT JOIN vw_intake ON applications.intake_id = vw_intake.intake_id
		LEFT JOIN contract_types ON applications.contract_type_id = contract_types.contract_type_id
		LEFT JOIN contract_status ON applications.contract_status_id = contract_status.contract_status_id
		LEFT JOIN vw_education_max ON entitys.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON entitys.entity_id = vw_employment_max.entity_id;
		
CREATE OR REPLACE FUNCTION ins_applications(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_entity_id				integer;
	v_application_id		integer;
	v_sys_email_id			integer;
	v_address				integer;
	c_education_id			integer;
	c_referees				integer;
	c_files					integer;
	reca					RECORD;
	msg 					varchar(120);
BEGIN
	SELECT application_id INTO v_application_id
	FROM applications 
	WHERE (intake_id = $1::int) AND (entity_id = $2::int);
	
	SELECT org_id, entity_id, currency_id, previous_salary, expected_salary INTO reca
	FROM applicants
	WHERE (entity_id = $2::int);
	v_entity_id := reca.entity_id;
	IF(reca.entity_id is null) THEN
		SELECT org_id, entity_id, currency_id, basic_salary as previous_salary, basic_salary as expected_salary INTO reca
		FROM employees
		WHERE (entity_id = $2::int);
		v_entity_id := reca.entity_id;
	END IF;
	
	SELECT count(address_id) INTO v_address
	FROM vw_address
	WHERE (table_name = 'applicant') AND (is_default = true) AND (table_id  = v_entity_id);
	IF(v_address is null) THEN v_address = 0; END IF;
	
	SELECT count(education_id) INTO c_education_id
	FROM education
	WHERE (entity_id  = v_entity_id);
	IF(c_education_id is null) THEN c_education_id = 0; END IF;
	
	SELECT count(address_id) INTO c_referees
	FROM vw_referees
	WHERE (table_id  = v_entity_id);
	IF(c_referees is null) THEN c_referees = 0; END IF;
	
	SELECT count(sys_file_id) INTO c_files
	FROM sys_files
	WHERE (table_id  = v_entity_id);
	IF(c_files is null) THEN c_files = 0; END IF;

	IF v_application_id is not null THEN
		msg := 'There is another application for the post.';
		RAISE EXCEPTION '%', msg;
	ELSIF (reca.previous_salary is null) OR (reca.expected_salary is null) THEN
		msg := 'Kindly indicate your previous and expected salary';
		RAISE EXCEPTION '%', msg;
	ELSIF (v_address < 1) THEN
		msg := 'You need to have at least one full address added';
		RAISE EXCEPTION '%', msg;
	ELSIF (c_education_id < 2) THEN
		msg := 'You need to have at least two education levels added';
		RAISE EXCEPTION '%', msg;
	ELSIF (c_referees < 3) THEN
		msg := 'You need to have at least three referees added';
		RAISE EXCEPTION '%', msg;
	ELSIF (c_files < 2) THEN
		msg := 'CV and Cover Letter MUST be uploaded';
		RAISE EXCEPTION '%', msg;
	ELSE
		v_application_id := nextval('applications_application_id_seq');
		INSERT INTO applications (application_id, intake_id, org_id, entity_id, currency_id, previous_salary, expected_salary, approve_status)
		VALUES (v_application_id, $1::int, reca.org_id, reca.entity_id, reca.currency_id, reca.previous_salary, reca.expected_salary, 'Completed');
		
		SELECT sys_email_id INTO v_sys_email_id FROM sys_emails
		WHERE (use_type = 10) AND (org_id = reca.org_id);
		
		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name, email_type)
		VALUES (v_sys_email_id, reca.org_id, v_application_id, 'applications', 10);
		
		msg := 'Added Job application';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION emailed_dob(integer, varchar(64)) RETURNS varchar(120) AS $$
DECLARE
	v_org_id				integer;
	v_entity_name			varchar(120);
BEGIN
	SELECT org_id, entity_name INTO v_org_id, v_entity_name
	FROM entitys WHERE (entity_id = $2::int);
	
	INSERT INTO sys_emailed (sys_email_id, org_id, email_type, narrative)
	VALUES (9, 0, 9, 'Its birthday for ' || v_entity_name);

	UPDATE employees SET dob_email = current_date WHERE (entity_id = $2::int);

	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION emailed_contract(integer, varchar(64)) RETURNS varchar(120) AS $$
BEGIN
	UPDATE applications SET notice_email = true WHERE (application_id = $2::int);
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

INSERT INTO sys_emails (sys_email_id, use_type, org_id, sys_email_name, title, details) 
VALUES (12, 12, 0, 'Contract Ending', 'Contract Ending - {{entity_name}}', 'Hello,<br><br>
Kindly note that the contract for {{entity_name}} is due to employment.<br><br>
Regards,<br>
HR Manager<br>');

