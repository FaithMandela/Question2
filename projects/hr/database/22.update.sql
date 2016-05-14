

ALTER TABLE employees ADD dob_email				date;

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (8, 0, 'Happy Birthday', 'Happy Birthday', 'Happy Birthday {{name}},<br><br>
A very happy birhday to you.<br><br>
Regards,<br>
HR Manager<br>
');

DROP VIEW vw_employees;
CREATE VIEW vw_employees AS
	SELECT vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, vw_bank_branch.bank_branch_name, 
		vw_bank_branch.bank_branch_code, vw_department_roles.department_id, vw_department_roles.department_name, 
		vw_department_roles.department_role_id, vw_department_roles.department_role_name, 
		locations.location_id, locations.location_name,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		sys_countrys.sys_country_name, nob.sys_country_name as birth_nation_name,  
		disability.disability_id, disability.disability_name,		
		employees.org_id, employees.entity_id, employees.employee_id, employees.surname, employees.first_name, employees.middle_name, 
		employees.person_title, employees.field_of_study,
		(employees.Surname || ' ' || employees.First_name || ' ' || COALESCE(employees.Middle_name, '')) as employee_name,
		employees.date_of_birth, employees.dob_email, employees.place_of_birth, employees.gender, 
		employees.nationality, employees.nation_of_birth, 
		employees.marital_status, employees.appointment_date, 
		employees.exit_date, employees.contract, employees.contract_period, employees.employment_terms, employees.identity_card, 
		employees.basic_salary, employees.bank_account, employees.language, employees.picture_file, employees.active, 
		employees.height, employees.weight, employees.blood_group, employees.allergies,
		employees.phone, employees.objective, employees.interests, employees.details, 
		to_char(age(employees.date_of_birth), 'YY') as employee_age,
		(CASE WHEN employees.gender = 'M' THEN 'Male' ELSE 'Female' END) as gender_name,
		(CASE WHEN employees.marital_status = 'M' THEN 'Married' ELSE 'Single' END) as marital_status_name,

		vw_education_max.education_class_name, vw_education_max.date_from, vw_education_max.date_to, 
		vw_education_max.name_of_school, vw_education_max.examination_taken, 
		vw_education_max.grades_obtained, vw_education_max.certificate_number
	FROM employees INNER JOIN vw_bank_branch ON employees.bank_branch_id = vw_bank_branch.bank_branch_id
		INNER JOIN vw_department_roles ON employees.department_role_id = vw_department_roles.department_role_id
		INNER JOIN locations ON employees.location_id = locations.location_id
		INNER JOIN currency ON employees.currency_id = currency.currency_id
		INNER JOIN sys_countrys ON employees.nationality = sys_countrys.sys_country_id		
		LEFT JOIN sys_countrys as nob ON employees.nation_of_birth = nob.sys_country_id
		LEFT JOIN disability ON employees.disability_id = disability.disability_id
		LEFT JOIN vw_education_max ON employees.entity_id = vw_education_max.entity_id;

DROP VIEW vw_entity_employees;
CREATE VIEW vw_entity_employees AS
	SELECT entitys.entity_id, entitys.org_id, entitys.entity_type_id, entitys.entity_name, entitys.user_name,
		entitys.primary_email, entitys.super_user, entitys.entity_leader, entitys.function_role,
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, entitys.is_picked,
		employees.employee_id, employees.surname, employees.first_name, employees.middle_name,
		employees.date_of_birth, employees.dob_email, employees.gender, employees.nationality, 
		employees.marital_status, employees.appointment_date, 
		employees.exit_date, employees.contract, employees.contract_period, employees.employment_terms, employees.identity_card, 
		employees.basic_salary, employees.bank_account, employees.language, employees.objective, employees.Active
	FROM entitys INNER JOIN employees ON entitys.entity_id = employees.entity_id;
	
	

CREATE FUNCTION emailed_dob(integer, varchar(64)) RETURNS void AS $$
    UPDATE employees SET dob_email = current_date WHERE (entity_id = $2::int));
$$ LANGUAGE SQL;



