
--- Create use key types
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (100, 'Customers', 0);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (101, 'Receipts', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (102, 'Payments', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (103, 'Opening Account', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (104, 'Transfer', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (110, 'Account Penalty', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (120, 'Parking Charge', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (201, 'Initial Charges', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (202, 'Transaction Charges', 4);


INSERT INTO activity_frequency (activity_frequency_id, activity_frequency_name) 
VALUES (1, 'Once'), (4, 'Monthly');
--- (1, 'Once'), (2, 'Daily'), (3, 'Weekly'), (4, 'Monthly'), (5, 'Quartely'), (6, 'Half Yearly'), (7, 'Yearly');

INSERT INTO activity_status (activity_status_id, activity_status_name) VALUES (1, 'Completed');
INSERT INTO activity_status (activity_status_id, activity_status_name) VALUES (2, 'UnCleared');
INSERT INTO activity_status (activity_status_id, activity_status_name) VALUES (3, 'Processing');
INSERT INTO activity_status (activity_status_id, activity_status_name) VALUES (4, 'Commited');

INSERT INTO entity_types (org_id, use_key_id, entity_type_name, entity_role) VALUES (0, 100, 'Customers', 'client');

INSERT INTO locations (org_id, location_name) VALUES (0, 'Head Office');
INSERT INTO departments (org_id, department_name) VALUES (0, 'Board of Directors');

INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (1, 34005, 34005, 202, 0, 'No Charges', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (2, 34005, 34005, 101, 0, 'Cash Deposits', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (3, 34005, 34005, 101, 0, 'Cheque Deposits', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (4, 34005, 34005, 101, 0, 'MPESA Deposits', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (5, 34005, 34005, 102, 0, 'Cash Withdrawal', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (6, 34005, 34005, 102, 0, 'Cheque Withdrawal', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (7, 34005, 34005, 102, 0, 'MPESA Withdrawal', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (12, 34005, 34005, 104, 0, 'Account Transfer', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (15, 70025, 34005, 110, 0, 'Account Penalty', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (16, 34005, 34005, 120, 0, 'Parking payment', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (21, 70020, 34005, 201, 0, 'Account opening charges', true);
INSERT INTO activity_types (activity_type_id, cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active) VALUES (22, 70020, 34005, 202, 0, 'Transfer fees', true);
SELECT pg_catalog.setval('activity_types_activity_type_id_seq', 22, true);


INSERT INTO penalty_methods (penalty_method_id, activity_type_id, org_id, penalty_method_name, formural, account_number) VALUES
(0, 15, 0, 'No penalty', null, null),
(2, 15, 0, 'Account Penalty 15', 'get_penalty(1, deposit_account_id, period_id, 15)', '400000004');
SELECT pg_catalog.setval('penalty_methods_penalty_method_id_seq', 2, true);

INSERT INTO products (product_id, penalty_method_id, currency_id, org_id, product_name, description, loan_account, is_active, interest_rate, min_opening_balance, minimum_balance, maximum_balance, minimum_day, maximum_day, minimum_trx, maximum_trx) VALUES
(0, 0, 1, 0, 'Banking', 'Banking', false, false, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 0, 1, 0, 'Transaction', 'Account to handle transactions', false, true, 0, 0, 0, 0, 0, 0, 0, 0);
(2, 0, 1, 0, 'Parking Fee', 'Account to Parking fee', false, true, 0, 0, 0, 0, 0, 0, 0, 0);
SELECT pg_catalog.setval('products_product_id_seq', 2, true);


INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active) VALUES 
(2, 1, 1, 0, 0, 'Cash Deposit', '2017-01-01', NULL, '400000001', true),
(3, 1, 1, 0, 0, 'Cheque Deposit', '2017-01-01', NULL, '400000001', true),
(4, 1, 1, 0, 0, 'MPESA Deposit', '2017-01-01', NULL, '400000002', true),
(5, 1, 1, 0, 0, 'Cash Withdraw', '2017-01-01', NULL, '400000001', true),
(6, 1, 1, 0, 0, 'Cheque Withdraw', '2017-01-01', NULL, '400000001', true),
(7, 1, 1, 0, 0, 'MPESA Withdraw', '2017-01-01', NULL, '400000002', true);
INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active) VALUES 
(2, 1, 1, 1, 0, 'Cash Deposit', '2017-01-01', NULL, '400000001', true),
(3, 1, 1, 1, 0, 'Cheque Deposit', '2017-01-01', NULL, '400000001', true),
(4, 1, 1, 1, 0, 'MPESA Deposit', '2017-01-01', NULL, '400000002', true),
(5, 1, 1, 1, 0, 'Cash Withdraw', '2017-01-01', NULL, '400000001', true),
(6, 1, 1, 1, 0, 'Cheque Withdraw', '2017-01-01', NULL, '400000001', true),
(7, 1, 1, 1, 0, 'MPESA Withdraw', '2017-01-01', NULL, '400000002', true);
INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active) VALUES 
(2, 1, 1, 3, 0, 'Cash Deposit', '2017-01-01', NULL, '400000001', true),
(3, 1, 1, 3, 0, 'Cheque Deposit', '2017-01-01', NULL, '400000001', true),
(4, 1, 1, 3, 0, 'MPESA Deposit', '2017-01-01', NULL, '400000002', true),
(5, 1, 1, 3, 0, 'Cash Withdraw', '2017-01-01', NULL, '400000001', true),
(6, 1, 1, 3, 0, 'Cheque Withdraw', '2017-01-01', NULL, '400000001', true),
(7, 1, 1, 3, 0, 'MPESA Withdraw', '2017-01-01', NULL, '400000002', true);
INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active, fee_amount) 
VALUES (14, 1, 1, 3, 0, 'Parking Fee', '2017-01-01', NULL, '400000003', true, 30);

--- Create Initial customer and customer account
INSERT INTO customers (entity_id, org_id, business_account, customer_name, identification_number, identification_type, customer_email, telephone_number, date_of_birth, nationality, approve_status)
VALUES (10, 0, 2, 'City Council', '101', 'Org', 'info@city.or.ke', '+254', current_date, 'KE', 'Approved');
INSERT INTO customers (entity_id, org_id, business_account, customer_name, identification_number, identification_type, customer_email, telephone_number, date_of_birth, nationality, approve_status)
VALUES (11, 0, 2, 'Cars', '102', 'Org', 'info@city.or.ke', '+254', current_date, 'KE', 'Approved');
SELECT pg_catalog.setval('entitys_entity_id_seq', 11, true);

INSERT INTO deposit_accounts (entity_id, product_id, org_id, is_active, approve_status, narrative, minimum_balance, account_number) VALUES 
(10, 0, 0, true, 'Approved', 'Deposits', -100000000000, '400000001'),
(10, 0, 0, true, 'Approved', 'MPESA', -100000000000, '400000002'),
(10, 0, 0, true, 'Approved', 'Parking Fee', -100000000000, '400000003'),
(10, 0, 0, true, 'Approved', 'Penalty', -100000000000, '400000004');


---- Workflow setup
INSERT INTO workflows (workflow_id, org_id, source_entity_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details) VALUES
(20, 0, 0, 'Customer Application', 'customers', NULL, NULL, 'Request approved', 'Request rejected', NULL, NULL, NULL),
(21, 0, 0, 'Account opening', 'deposit_accounts', NULL, NULL, 'Request approved', 'Request rejected', NULL, NULL, NULL);
SELECT pg_catalog.setval('workflows_workflow_id_seq', 30, true);

INSERT INTO workflow_phases (workflow_phase_id, org_id, workflow_id, approval_entity_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details) VALUES
(20, 0, 20, 0, 1, 0, 0, 3, 1, false, false, 'Approve', 'For your approval', 'Phase approved', NULL, NULL, NULL),
(21, 0, 21, 0, 1, 0, 0, 3, 1, false, false, 'Approve', 'For your approval', 'Phase approved', NULL, NULL, NULL);
SELECT pg_catalog.setval('workflow_phases_workflow_phase_id_seq', 30, true);


------ emails

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (1, 0, 'Application', 'Thank you for your Application', 'Thank you {{name}} for your application.<br><br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
Regards<br>
Human Resources Manager<br>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (2, 0, 'New Customer', 'Your credentials ', 'Hello {{name}},<br><br>
Your credentials to the banking system have been created.<br>
Your user name is {{username}}<br>
Regards<br>
Human Resources Manager<br>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (3, 0, 'Password reset', 'Password reset', 'Hello {{name}},<br><br>
Your password has been reset to:<br><br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
Regards<br>
Human Resources Manager<br>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (4, 0, 'Subscription', 'Subscription', 'Hello {{name}},<br><br>
Welcome to OpenBaraza SaaS Platform<br><br>
Your password is:<br><br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
Regards,<br>
OpenBaraza<br>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (5, 0, 'Subscription', 'Subscription', 'Hello {{name}},<br><br>
Your OpenBaraza SaaS Platform application has been approved<br><br>
Welcome to OpenBaraza SaaS Platform<br><br>
Regards,<br>
OpenBaraza<br>');

SELECT pg_catalog.setval('sys_emails_sys_email_id_seq', 5, true);
UPDATE sys_emails SET use_type = sys_email_id;
