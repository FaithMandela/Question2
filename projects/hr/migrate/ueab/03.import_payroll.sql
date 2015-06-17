
ALTER TABLE departments ADD dept_account varchar(25);
ALTER TABLE departments ADD dept_function varchar(25);
ALTER TABLE departments ADD dept_project varchar(25);

INSERT INTO departments(department_id, ln_department_id, org_id, department_name, dept_account, dept_function, dept_project, details)
SELECT departmentid, 0, 0, departmentname, accountnumber, depfunction, deptproject, details
FROM import.departments
ORDER BY departmentid;


INSERT INTO banks(bank_id, sys_country_id, org_id, bank_name)
SELECT bankid, 'KE', 0, bankname
FROM import.banks
ORDER BY bankid;

INSERT INTO bank_branch(bank_branch_id, bank_id, org_id, bank_branch_name, bank_branch_code)
SELECT b.id, b.bankid, 0, a.branchname, b.bankbranchid
FROM import.branch as a INNER JOIN import.bankbranch b ON a.branchid = b.branchid
ORDER BY b.id;


INSERT INTO adjustments(adjustment_id, currency_id, org_id, adjustment_name, adjustment_type)
SELECT allowanceid, 1, 0, allowancename, 1
FROM import.allowances
ORDER BY allowanceid;

INSERT INTO adjustments(adjustment_id, currency_id, org_id, adjustment_name, adjustment_type, account_number)
SELECT 20 + deductionid, 1, 0, deductionname, 2, accountnumber
FROM import.deductions
ORDER BY deductionid;

INSERT INTO tax_types (use_key, tax_type_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active, details) VALUES (1, 1, 'PAYE', 'Get_Employee_Tax(employee_tax_type_id, 2)', 1162, 1, false, true, true, 0, 0, true, NULL);
INSERT INTO tax_types (use_key, tax_type_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active, details) VALUES (1, 2, 'NSSF', 'Get_Employee_Tax(employee_tax_type_id, 1)', 0, 0, true, true, true, 0, 0, true, NULL);
INSERT INTO tax_types (use_key, tax_type_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active, details) VALUES (1, 3, 'NHIF', 'Get_Employee_Tax(employee_tax_type_id, 1)', 0, 0, false, false, false, 0, 0, true, NULL);
INSERT INTO tax_types (use_key, tax_type_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active, details) VALUES (1, 4, 'FULL PAYE', 'Get_Employee_Tax(employee_tax_type_id, 2)', 0, 0, false, false, false, 0, 0, false, NULL);
SELECT pg_catalog.setval('tax_types_tax_type_id_seq', 4, true);
UPDATE tax_types SET org_id = 0, currency_id = 1;

INSERT INTO tax_rates(tax_type_id, org_id, tax_range, tax_rate)
SELECT 1, 0, upperrange, taxrate
FROM import.taxrates;

INSERT INTO tax_rates(tax_type_id, org_id, tax_range, tax_rate)
SELECT 2 ,0, lowerrange, nssfrate
FROM import.nssfrates;

INSERT INTO tax_rates(tax_type_id, org_id, tax_range, tax_rate)
SELECT 3, 0, upperrange, amount
FROM import.nhifrates
ORDER BY nhisrateid;

ALTER TABLE periods ADD acc_period	varchar(12);

UPDATE import.monthrates SET startdate = '2013-04-01'::date WHERE monthrateid = 144;
INSERT INTO periods(period_id, org_id, start_date, end_date, acc_period)
SELECT monthrateid, startdate, enddate, accperiod
FROM import.monthrates
ORDER BY monthrateid;


INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Wife');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Husband');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Daughter');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Son');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Mother');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Father');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Brother');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Sister');
INSERT INTO kin_types (org_id, kin_type_name) VALUES (0, 'Others');

INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 1, 'Primary School');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 2, 'Secondary School');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 3, 'High School');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 4, 'Certificate');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 5, 'Diploma');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 6, 'Profesional Qualifications');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 7, 'Higher Diploma');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 8, 'Under Graduate');
INSERT INTO education_class (org_id, education_class_id, education_class_name) VALUES (0, 9, 'Post Graduate');
SELECT pg_catalog.setval('education_class_education_class_id_seq', 9, true);

INSERT INTO pay_scales (org_id, pay_scale_id, pay_scale_name, min_pay, max_pay) VALUES (0, 0, 'Basic', 0, 1000000);
INSERT INTO pay_groups (org_id, pay_group_id, pay_group_name) VALUES (0, 0, 'Default');
INSERT INTO locations (org_id, location_id, location_name) VALUES (0, 0, 'Main office');




