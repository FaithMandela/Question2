CREATE OR REPLACE FUNCTION ins_applications(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_intake_id				integer;
	v_org_id				integer;
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
	FROM applications WHERE (intake_id = $1::int) AND (entity_id = $2::int);
	
	SELECT intake_id, org_id INTO v_intake_id, v_org_id
	FROM intake WHERE (intake_id = $1::int);
	
	SELECT entity_id, currency_id, previous_salary, expected_salary INTO reca
	FROM applicants
	WHERE (entity_id = $2::int);
	
	v_entity_id := reca.entity_id;
	IF(reca.entity_id is null) THEN
		SELECT entity_id, currency_id, basic_salary as previous_salary, basic_salary as expected_salary INTO reca
		FROM employees
		WHERE (entity_id = $2::int);
		v_entity_id := reca.entity_id;
	END IF;
	
	SELECT count(address_id) INTO v_address
	FROM vw_address
	WHERE ((table_name = 'applicant') OR (table_name = 'employees'))
		AND (is_default = true) AND (table_id  = v_entity_id);
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
	ELSIF (c_referees < 2) THEN
		msg := 'You need to have at least two referees added';
		RAISE EXCEPTION '%', msg;
	ELSE
		v_application_id := nextval('applications_application_id_seq');
		INSERT INTO applications (application_id, intake_id, org_id, entity_id, currency_id, previous_salary, expected_salary, approve_status)
		VALUES (v_application_id, v_intake_id, v_org_id, reca.entity_id, reca.currency_id, reca.previous_salary, reca.expected_salary, 'Completed');
		
		SELECT sys_email_id INTO v_sys_email_id FROM sys_emails
		WHERE (use_type = 10) AND (org_id = v_org_id);
		
		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name, email_type)
		VALUES (v_sys_email_id, v_org_id, v_application_id, 'applications', 10);
		
		msg := 'Added Job application';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_interns(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_internship_id			integer;
	v_intern_id				integer;
	v_org_id				integer;
	v_sys_email_id			integer;
	msg						varchar(120);
BEGIN
	SELECT internship_id, org_id INTO v_internship_id, v_org_id
	FROM internships WHERE (internship_id = $1::int);
	
	SELECT intern_id INTO v_intern_id
	FROM interns WHERE (internship_id = $1::int) AND (entity_id = $2::int);
	
	IF v_intern_id is null THEN
		v_intern_id := nextval('interns_intern_id_seq');
		INSERT INTO interns (intern_id, org_id, internship_id, entity_id, approve_status)
		VALUES (v_intern_id, v_org_id, v_internship_id, $2::int, 'Completed');
		
		SELECT sys_email_id INTO v_sys_email_id FROM sys_emails
		WHERE (use_type = 11) AND (org_id = v_org_id);
		
		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name, email_type)
		VALUES (v_sys_email_id, v_org_id, v_intern_id, 'interns', 1);
		
		msg := 'Added internship application';
	ELSE
		msg := 'There is another application for the internship.';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;
