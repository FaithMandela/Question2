

--- Updating tax types

UPDATE employee_tax_types SET tax_identification = a.tax_identification
FROM (SELECT default_tax_types.tax_identification, default_tax_types.tax_type_id, employee_month.employee_month_id
FROM default_tax_types, employee_month WHERE default_tax_types.entity_id = employee_month.entity_id) as a
WHERE employee_tax_types.employee_month_id = a.employee_month_id and (employee_tax_types.tax_type_id = a.tax_type_id);


---- Get the data for employees

SELECT department_name, department_role_name, location_name, employee_name, date_of_birth, gender, 
	appointment_date, identity_card, language, employee_age, gender_name, marital_status_name, 
	education_class_name, date_from, date_to, name_of_school, examination_taken, grades_obtained
FROM vw_employees
WHERE active = true
ORDER BY department_name, department_role_name;
