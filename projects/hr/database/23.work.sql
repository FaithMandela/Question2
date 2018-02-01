

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



----------- Kenya Tax rate increase
select * from tax_types order by tax_type_id;
select * from tax_rates where tax_type_id = 1 order by tax_rate_id;

UPDATE tax_rates SET tax_range = 12298 WHERE tax_rate_id = 1;
UPDATE tax_rates SET tax_range = 23885 WHERE tax_rate_id = 2;
UPDATE tax_rates SET tax_range = 35472 WHERE tax_rate_id = 3;
UPDATE tax_rates SET tax_range = 47059 WHERE tax_rate_id = 4;

UPDATE tax_types SET tax_relief = 1408 WHERE tax_type_id = 1;

UPDATE tax_rates SET tax_range = 12298 WHERE tax_rate_id = 26;
UPDATE tax_rates SET tax_range = 23885 WHERE tax_rate_id = 27;
UPDATE tax_rates SET tax_range = 35472 WHERE tax_rate_id = 28;
UPDATE tax_rates SET tax_range = 47059 WHERE tax_rate_id = 29;

UPDATE tax_types SET tax_relief = 1408 WHERE tax_type_id = 8;


SELECT pg_catalog.setval('tax_rates_tax_rate_id_seq', 1, false);


----------- Update tax on a larger scale using work join
INSERT INTO tax_rates (tax_type_id, org_id, tax_range, tax_rate)
SELECT aa.tax_type_id, aa.org_id, bb.tax_range, bb.tax_rate
FROM (SELECT tax_type_id, tax_type_name, org_id FROM tax_types WHERE org_id <> 0) aa INNER JOIN
(SELECT tax_types.tax_type_name, tax_rates.tax_type_id, tax_rates.tax_range, tax_rates.tax_rate
FROM tax_types INNER JOIN tax_rates ON tax_types.tax_type_id = tax_rates.tax_type_id
WHERE tax_types.org_id = 0) bb
ON aa.tax_type_name = bb.tax_type_name
ORDER BY aa.tax_type_id, bb.tax_range




SELECT sys_emailed_id, vw_approvals_entitys.primary_email as emailaddress, 
	vw_approvals_entitys.phase_narrative as emailsubject, vw_approvals_entitys.advice_email, 
	vw_approvals_entitys.org_entity_name, vw_approvals_entitys.table_id, vw_approvals_entitys.notice_file 
FROM sys_emailed, vw_approvals_entitys  
WHERE (vw_approvals_entitys.approval_id = sys_emailed.table_id) AND (sys_emailed.emailed = false)       
AND (sys_emailed.email_type = 1) AND (vw_approvals_entitys.use_reporting = true)


