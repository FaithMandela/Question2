
--data

-------- Data
INSERT INTO payment_types(payment_type_id, payment_type_name, org_id) VALUES
	(1, 'Bank',0),
	(2, 'Mpesa',0),
	(3, 'Cash', 0),
	(4, 'Airtel Money', 0 );


INSERT INTO contribution_types(contribution_type_id, contribution_type_name, org_id, interval_days) VALUES
	(1, 'Daily', 0, 1),
	(2, 'Weekly', 0, 7),
	(3, 'fortnight', 0, 14),
	(4, 'Monthly', 0, 30);
	
INSERT INTO loan_types(loan_type_id, org_id, loan_type_name, default_interest) VALUES 
	(0, 0, 'Emergency', 15),
	(1, 0, 'Education', 9),
	(2, 0, 'Development', 10);

INSERT INTO fiscal_years(fiscal_year_id, org_id, fiscal_year_start, fiscal_year_end, year_opened,year_closed, details) VALUES
	(1, 0, '2016-01-01', '2016-05-31', 'true', 'false', 'jajajaja');

INSERT INTO collateral_types(collateral_type_id, org_id, collateral_type_name, details) VALUES 
	(0, 0, 'plot', 'my plot number LR/70/L'),
    (1, 0, 'Car', 'Chasis NO'),
	(2, 0, 'Mortage', 'my plot No and HSE'),
    (3, 0, 'Motor Cycle', 'Chasis No');
INSERT INTO investment_types( investment_type_id, org_id, investment_type_name, interest_type) VALUES 
	(0,0,'Land',15),
	(1,0,'Real Estate',25),
	(2,0,'Buy Equity',24);

DELETE FROM currency WHERE currency_id > 1;

INSERT INTO members(entity_id, member_id,org_id,person_title, full_name, surname, first_name, middle_name, 
            gender, phone, primary_email, marital_status,active)
    VALUES (2,0,0,'mr', 'member member member','member','member','member','M',234,'member@member.org','m','true');
INSERT INTO applicants(
            org_id, person_title, surname, first_name, middle_name, 
            applicant_email, applicant_phone, approve_status, 
            workflow_table_id)
    VALUES (0, 'mr', 'applicant', 'applicant', 'applicant', 
            'applicant@applicant.com',4545 ,'Completed' , 3);



INSERT INTO industry (org_id, industry_name) VALUES (0, 'Aerospace');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Agriculture');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Automotive');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Business and Consultancy Services');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'ICT - Reseller');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'ICT - Services and Consultancy');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'ICT - Manufacturer');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'ICT - Software Development');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Investments');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Education');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Electronics');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Finance, Banking, Insurance');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Government - National or Federal');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Government - State, Country or Local');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Healthcare');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Hotel and Leisure');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Legal');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Manufacturing');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Media, Marketing, Entertainment, Publishing, PR');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Real Estate');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Retail, Wholesale');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Telecoms');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Transportation and Distribution');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Travel and Tours');
INSERT INTO industry (org_id, industry_name) VALUES (0, 'Other');


INSERT INTO bank_accounts ( org_id, currency_id, bank_branch_id, account_id, bank_account_name, is_default) 
VALUES ( 0, 1, 0, '33000', 'Cash Account', true);


UPDATE tax_types SET currency_id = 1;
UPDATE tax_types SET account_id = 90000;

INSERT INTO workflows (workflow_id, org_id, source_entity_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details) 
VALUES (10, 0, 1, 'Leave', 'employee_leave', NULL, NULL, 'Leave approved', 'Leave rejected', NULL, NULL, NULL);
INSERT INTO workflows (workflow_id, org_id, source_entity_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details) 
VALUES (11, 0, 5, 'subscriptions', 'subscriptions', NULL, NULL, 'subscription approved', 'subscription rejected', NULL, NULL, NULL);
SELECT pg_catalog.setval('workflows_workflow_id_seq', 5, true);



INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (1, 0, 'Application', 'Thank you {{name}},<br><br> Thank for your application,<br>
Your user name is {{username}}<br><br>
Your password is {{first_password}}<br><br>

Regards<br>
Human Resources Manager<br>
{{org_name}}, Sacco' <br>
');

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (3, 0, 'Password reset', 'Password reset', 'Hello {{name}},<br><br>
Your password has been reset to:<br><br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
Regards<br>
Human Resources Manager<br>
');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (4, 0, 'Subscription', 'Subscription', 'Hello {{name}},<br><br>
Welcome to Sacco Application<br><br>
Your password is:<br><br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
Regards,<br>
Sacco Admin<br>
');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (5, 0, 'Subscription', 'Subscription', 'Hello {{name}},

Welcome to Baraza Sacco Application

Your user name is:  {{username}}
Your password is:  {{passwd}}

login at: http://demo.dewcis.com/sacco'
');

SELECT pg_catalog.setval('sys_emails_sys_email_id_seq', 7, true);

INSERT INTO Departments (org_id, Department_id, LN_Department_id, Department_name) VALUES (0, 1, 0, 'Human Resources and Administration');
INSERT INTO Departments (org_id, Department_id, LN_Department_id, Department_name) VALUES (0, 2, 0, 'Sales and Marketing');
INSERT INTO Departments (org_id, Department_id, LN_Department_id, Department_name) VALUES (0, 3, 0, 'Finance');
INSERT INTO Departments (org_id, Department_id, LN_Department_id, Department_name) VALUES (0, 4, 4, 'Procurement');
SELECT pg_catalog.setval('departments_department_id_seq', 5, true);

INSERT INTO default_accounts (default_account_id, account_id, narrative) VALUES ( 3,99999, 'SURPLUS/DEFICIT ACCOUNT');
INSERT INTO default_accounts (default_account_id, account_id, narrative) VALUES ( 4,61000, 'RETAINED EARNINGS ACCOUNT');
UPDATE default_accounts set org_id = 0;

