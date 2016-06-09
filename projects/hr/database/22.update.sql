
ALTER TABLE tax_types ADD use_type				integer default 0 not null;
UPDATE tax_types SET use_type = 3, use_key = 1 WHERE tax_type_id IN (1, 4, 8, 11);

UPDATE employee_tax_types SET tax_identification = a.tax_identification
FROM (SELECT default_tax_types.tax_identification, default_tax_types.tax_type_id, employee_month.employee_month_id
FROM default_tax_types, employee_month WHERE default_tax_types.entity_id = employee_month.entity_id) as a
WHERE employee_tax_types.employee_month_id = a.employee_month_id and (employee_tax_types.tax_type_id = a.tax_type_id);


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
	
	SELECT org_id, entity_id, previous_salary, expected_salary INTO reca
	FROM applicants
	WHERE (entity_id = $2::int);
	v_entity_id := reca.entity_id;
	IF(reca.entity_id is null) THEN
		SELECT org_id, entity_id, basic_salary as previous_salary, basic_salary as expected_salary INTO reca
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
		INSERT INTO applications (application_id, intake_id, org_id, entity_id, previous_salary, expected_salary, approve_status)
		VALUES (v_application_id, $1::int, reca.org_id, reca.entity_id, reca.previous_salary, reca.expected_salary, 'Completed');
		
		SELECT sys_email_id INTO v_sys_email_id FROM sys_emails
		WHERE (use_type = 10) AND (org_id = reca.org_id);
		
		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name, email_type)
		VALUES (v_sys_email_id, reca.org_id, v_application_id, 'applications', 10);
		
		msg := 'Added Job application';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;


