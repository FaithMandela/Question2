

--- Data
INSERT INTO currency (currency_id, currency_name, currency_symbol) VALUES (5, 'Kenya Shillings', 'KES');
INSERT INTO orgs (org_id, org_name, org_sufix, currency_id, default_country_id, logo) VALUES (1, 'Open Baraza', 'ob', 5, 'KE', 'logo.png');
UPDATE currency SET org_id = 1 WHERE currency_id = 5;
SELECT pg_catalog.setval('orgs_org_id_seq', 1, true);
SELECT pg_catalog.setval('currency_currency_id_seq', 5, true);

INSERT INTO currency_rates (org_id, currency_id, exchange_rate) VALUES (1, 5, 1);

INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key_id) VALUES (1, 'Users', 'user', 0);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key_id) VALUES (1, 'Staff', 'staff', 1);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key_id) VALUES (1, 'Client', 'client', 2);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key_id) VALUES (1, 'Supplier', 'supplier', 3);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key_id) VALUES (1, 'Applicant', 'applicant', 4);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key_id) VALUES (1, 'Bank Customers', 'client', 100);

INSERT INTO subscription_levels (org_id, subscription_level_name) VALUES (1, 'Basic');
INSERT INTO subscription_levels (org_id, subscription_level_name) VALUES (1, 'Consumer');
INSERT INTO subscription_levels (org_id, subscription_level_name) VALUES (1, 'Manager');

INSERT INTO locations (org_id, location_name) VALUES (1, 'Head Office');
INSERT INTO departments (org_id, department_name) VALUES (1, 'Board of Directors');

INSERT INTO tax_types (org_id, tax_type_id, use_key_id, tax_type_name, tax_rate, account_id) VALUES (1, 11, 15, 'Exempt', 0, '42000');
INSERT INTO tax_types (org_id, tax_type_id, use_key_id, tax_type_name, tax_rate, account_id) VALUES (1, 12, 15, 'VAT', 16, '42000');
SELECT pg_catalog.setval('tax_types_tax_type_id_seq', 12, true);

INSERT INTO account_class (org_id, account_class_no, chat_type_id, chat_type_name, account_class_name)
SELECT 1, account_class_no, chat_type_id, chat_type_name, account_class_name
FROM account_class
WHERE org_id = 0;

INSERT INTO account_types (org_id, account_class_id, account_type_no, account_type_name)
SELECT a.org_id, a.account_class_id, b.account_type_no, b.account_type_name
FROM account_class a INNER JOIN account_types b ON a.account_class_no = b.account_class_id
WHERE (a.org_id = 1) AND (b.org_id = 0);

INSERT INTO accounts (org_id, account_type_id, account_no, account_name)
SELECT a.org_id, a.account_type_id, b.account_no, b.account_name
FROM account_types a INNER JOIN accounts b ON a.account_type_no = b.account_type_id
WHERE (a.org_id = 1) AND (b.org_id = 0);

INSERT INTO default_accounts (org_id, use_key_id, account_id)
SELECT b.org_id, a.use_key_id, b.account_id
FROM default_accounts a INNER JOIN accounts b ON a.account_id = b.account_no
WHERE (a.org_id = 0) AND (b.org_id = 1);

INSERT INTO collateral_types (org_id, collateral_type_name) VALUES (1, 'Property Title Deed');

INSERT INTO activity_types (cr_account_id, dr_account_id, use_key_id, org_id, activity_type_name, is_active, activity_type_no)
SELECT dra.account_id, cra.account_id, activity_types.use_key_id, 1, activity_types.activity_type_name, activity_types.is_active, 
	activity_types.activity_type_no
FROM activity_types
INNER JOIN accounts dra ON activity_types.dr_account_id = dra.account_no
INNER JOIN accounts cra ON activity_types.cr_account_id = cra.account_no
WHERE (dra.org_id = 1) AND (cra.org_id = 1) AND (activity_types.org_id = 0)
ORDER BY activity_types.activity_type_id;

INSERT INTO interest_methods (activity_type_id, org_id, interest_method_name, reducing_balance, reducing_payments, formural, account_number, interest_method_no)
SELECT oa.activity_type_id, oa.org_id, interest_methods.interest_method_name, 
       interest_methods.reducing_balance, interest_methods.reducing_payments, 
       interest_methods.formural, interest_methods.account_number,
       interest_methods.interest_method_no
FROM interest_methods INNER JOIN activity_types ON interest_methods.activity_type_id = activity_types.activity_type_id
INNER JOIN activity_types oa ON activity_types.use_key_id = oa.use_key_id
WHERE (activity_types.org_id = 0) AND (oa.org_id = 1)
ORDER BY interest_methods.interest_method_id;

INSERT INTO penalty_methods(activity_type_id, org_id, penalty_method_name, formural, account_number, penalty_method_no)
SELECT oa.activity_type_id, oa.org_id, penalty_methods.penalty_method_name, penalty_methods.formural, penalty_methods.account_number,
	penalty_methods.penalty_method_no
FROM penalty_methods INNER JOIN activity_types ON penalty_methods.activity_type_id = activity_types.activity_type_id
INNER JOIN activity_types oa ON activity_types.use_key_id = oa.use_key_id
WHERE (activity_types.org_id = 0) AND (oa.org_id = 1)
ORDER BY penalty_methods.penalty_method_id;

INSERT INTO products (product_id, activity_frequency_id, interest_method_id, penalty_method_id, currency_id, org_id, product_name, description, loan_account, is_active, interest_rate, min_opening_balance, lockin_period_frequency, minimum_balance, maximum_balance, minimum_day, maximum_day, minimum_trx, maximum_trx) VALUES
(7, 4, 0, 0, 5, 1, 'Banking', 'Banking', false, false, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(8, 4, 0, 0, 5, 1, 'Transaction account', 'Account to handle transactions', false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(9, 4, 1, 1, 5, 1, 'Basic loans', 'Basic loans', true, true, 12, 0, 0, 0, 0, 0, 0, 0, 0);
SELECT pg_catalog.setval('products_product_id_seq', 10, true);

INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active) VALUES 
(2, 1, 1, 7, 1, 'Cash Deposit', '2017-01-01', NULL, '400000001', true),
(3, 1, 1, 7, 1, 'Cheque Deposit', '2017-01-01', NULL, '400000001', true),
(4, 1, 1, 7, 1, 'MPESA Deposit', '2017-01-01', NULL, '400000001', true),
(5, 1, 1, 7, 1, 'Cash Withdraw', '2017-01-01', NULL, '400000001', true),
(6, 1, 1, 7, 1, 'Cheque Withdraw', '2017-01-01', NULL, '400000001', true),
(7, 1, 1, 7, 1, 'MPESA Withdraw', '2017-01-01', NULL, '400000001', true);
INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active) VALUES 
(2, 1, 1, 8, 1, 'Cash Deposit', '2017-01-01', NULL, '400000001', true),
(3, 1, 1, 8, 1, 'Cheque Deposit', '2017-01-01', NULL, '400000001', true),
(4, 1, 1, 8, 1, 'MPESA Deposit', '2017-01-01', NULL, '400000001', true),
(5, 1, 1, 8, 1, 'Cash Withdraw', '2017-01-01', NULL, '400000001', true),
(6, 1, 1, 8, 1, 'Cheque Withdraw', '2017-01-01', NULL, '400000001', true),
(7, 1, 1, 8, 1, 'MPESA Withdraw', '2017-01-01', NULL, '400000001', true);
INSERT INTO account_definations (activity_type_id, charge_activity_id, activity_frequency_id, product_id, org_id, account_defination_name, start_date, end_date, account_number, is_active) VALUES
(11, 1, 1, 9, 1, 'Loan Disbursement', '2017-01-01', NULL, '400000001', true),
(10, 1, 1, 9, 1, 'Loan Payment', '2017-01-01', NULL, '400000001', true);

INSERT INTO sys_emails (org_id, use_type,  sys_email_name, title, details) 
SELECT 1, use_type, sys_email_name, title, details
FROM sys_emails
WHERE org_id = 0;

INSERT INTO workflows (link_copy, org_id, source_entity_id, workflow_name, table_name, approve_email, reject_email) 
SELECT aa.workflow_id, bb.org_id, bb.entity_type_id, aa.workflow_name, aa.table_name, aa.approve_email, aa.reject_email
FROM workflows aa INNER JOIN entity_types bb ON aa.source_entity_id = bb.use_key_id
WHERE aa.org_id = 0 AND bb.org_id = 1
ORDER BY aa.workflow_id;

INSERT INTO workflow_phases (org_id, workflow_id, approval_entity_id, approval_level, return_level, 
	escalation_days, escalation_hours, required_approvals, advice, notice, 
	phase_narrative, advice_email, notice_email) 
SELECT bb.org_id, bb.workflow_id, cc.entity_type_id, aa.approval_level, aa.return_level, 
	aa.escalation_days, aa.escalation_hours, aa.required_approvals, aa.advice, aa.notice, 
	aa.phase_narrative, aa.advice_email, aa.notice_email
FROM workflow_phases aa INNER JOIN workflows bb ON aa.workflow_id = bb.link_copy
	INNER JOIN entity_types cc ON aa.approval_entity_id = cc.use_key_id
WHERE aa.org_id = 0 AND bb.org_id = 1 AND cc.org_id = 1;

INSERT INTO sys_emails (org_id, use_type, sys_email_name, title, details)
SELECT 1, use_type, sys_email_name, title, details
FROM sys_emails
WHERE org_id = 0;

UPDATE transaction_counters SET document_number = '10001';

