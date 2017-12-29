
--- Uganda Payroll tax
INSERT INTO tax_types (tax_type_id, org_id, currency_id, use_key_id, account_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, tax_rate, tax_inclusive, linear, percentage, employer, employer_ps, account_number, active, sys_country_id) VALUES 
(14, 1, 5, 11, NULL, 'PAYE', 'Get_Employee_Tax(employee_tax_type_id, 2)', 0, 1, false, 0, false, true, true, 0, 0, NULL, true, 'UG'),
(15, 1, 5, 12, NULL, 'NSSF', 'Get_Employee_Tax(employee_tax_type_id, 1)', 0, 0, false, 0, false, true, true, 0, 200, NULL, true, 'UG'),
(16, 1, 5, 12, NULL, 'Local Service Tax', 'Get_Employee_Tax(employee_tax_type_id, 1)', 0, 0, false, 0, false, false, false, 0, 0, NULL, true, 'UG');

INSERT INTO tax_rates (tax_type_id, org_id, tax_range, tax_rate, narrative) VALUES 
(14, 1, 235000, 0, NULL),
(14, 1, 335000, 10, NULL),
(14, 1, 410000, 20, NULL),
(14, 1, 100000000, 10, NULL),
(14, 1, 10000000, 30, NULL),
(15, 1, 100000000, 5, NULL),
(16, 1, 100000, 0, NULL),
(16, 1, 200000, 5000, NULL),
(16, 1, 300000, 10000, NULL),
(16, 1, 400000, 20000, NULL),
(16, 1, 500000, 30000, NULL),
(16, 1, 600000, 40000, NULL),
(16, 1, 700000, 60000, NULL),
(16, 1, 800000, 70000, NULL),
(16, 1, 900000, 80000, NULL),
(16, 1, 1000000, 90000, NULL),
(16, 1, 1000000000, 100000, NULL);

---- Zibambwe Payroll tax
INSERT INTO tax_types (tax_type_id, org_id, currency_id, use_key_id, account_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, tax_rate, tax_inclusive, linear, percentage, employer, employer_ps, account_number, active, sys_country_id) VALUES 
(21, 1, 5, 11, NULL, 'PAYE', 'Get_Employee_Tax(employee_tax_type_id, 2)', 0, 1, false, 0, false, true, false, 0, 0, NULL, true, 'ZW');

INSERT INTO tax_rates (tax_type_id, org_id, tax_range, tax_rate, employer_rate, rate_relief) VALUES 
(21,1,300,0,0,0),
(21,1,1500,20,0,60),
(21,1,3000,25,0,135),
(21,1,5000,30,0,285),
(21,1,10000,35,0,535),
(21,1,15000,40,0,1035),
(21,1,20000,45,0,1785),
(21,1,100000000,50,0,2785);

---- Ghana Payroll tax
INSERT INTO tax_types (tax_type_id, org_id, currency_id, use_key_id, account_id, tax_type_name, formural, employer_formural, tax_relief, tax_type_order, in_tax, tax_rate, tax_inclusive, linear, percentage, employer, employer_ps, account_number, active, sys_country_id) VALUES 
(31, 1, 5, 11, NULL, 'PAYE', 'Get_Employee_Tax(employee_tax_type_id, 2)', null, 0, 1, false, 0, false, true, false, 0, 0, NULL, true, 'GH'),
(32, 1, 5, 11, NULL, 'SSF', 'Get_Employee_Tax(employee_tax_type_id, 2)', 'Get_Employee_Tax(employee_tax_type_id, 5)', 0, 1, false, 0, false, true, false, 0, 0, NULL, true, 'GH');

INSERT INTO tax_rates (tax_type_id, org_id, tax_range, tax_rate, employer_rate, rate_relief) VALUES 
(31,1,1000000000,25,0,0),
(32,1,1000000000,5.5,0,0),
(32,1,1000000000,13,1,0);


---- Nigeria Payroll tax
INSERT INTO tax_types (tax_type_id, org_id, currency_id, use_key_id, account_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, tax_rate, tax_inclusive, linear, percentage, employer, employer_ps, account_number, active, sys_country_id) VALUES 
(41, 1, 5, 11, NULL, 'PAYE', 'Get_Employee_Tax(employee_tax_type_id, 7)', 0, 1, false, 0, false, true, true, 0, 0, NULL, true, 'NG'),
(42, 1, 5, 12, NULL, 'NHF', 'Get_Employee_Tax(employee_tax_type_id, 1)', 0, 0, false, 0, false, true, true, 0, 200, NULL, true, 'NG'),
(43, 1, 5, 12, NULL, 'NHIS', 'Get_Employee_Tax(employee_tax_type_id, 1)', 0, 0, false, 0, false, false, false, 0, 0, NULL, true, 'NG');

INSERT INTO tax_rates (tax_type_id, org_id, tax_range, tax_rate, employer_rate, rate_relief) VALUES 
(41,1,25000,7,0,0),
(41,1,50000,11,0,0),
(41,1,91667,15,0,0),
(41,1,133333,19,0,0),
(41,1,160737,21,0,0),
(41,1,833333,24,0,0),
(42,1,1000000000,2.5,0,0),
(43,1,1000000000,5,0,0);


---- Update 
SELECT pg_catalog.setval('tax_types_tax_type_id_seq', 50, true);