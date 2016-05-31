

--- Data
INSERT INTO currency (currency_id, currency_name, currency_symbol) VALUES (5, 'US Dollar', 'USD');
INSERT INTO orgs (org_id, org_name, org_sufix, currency_id, logo) VALUES (1, 'Default', 'df', 5, 'logo.png');
UPDATE currency SET org_id = 1 WHERE currency_id = 5;
SELECT pg_catalog.setval('orgs_org_id_seq', 1, true);
SELECT pg_catalog.setval('currency_currency_id_seq', 5, true);

INSERT INTO currency_rates (org_id, currency_id, exchange_rate) VALUES (1, 5, 1);

INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key) VALUES (1, 'Users', 'user', 0);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key) VALUES (1, 'Staff', 'staff', 1);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key) VALUES (1, 'Client', 'client', 2);
INSERT INTO entity_types (org_id, entity_type_name, entity_role, use_key) VALUES (1, 'Supplier', 'supplier', 3);

INSERT INTO subscription_levels (org_id, subscription_level_name) VALUES (1, 'Basic');
INSERT INTO subscription_levels (org_id, subscription_level_name) VALUES (1, 'Manager');
INSERT INTO subscription_levels (org_id, subscription_level_name) VALUES (1, 'Consumer');


--- Copy over data
INSERT INTO jobs_category (org_id, jobs_category) VALUES (1, 'General Management');

INSERT INTO contract_status (org_id, contract_status_name)
SELECT 1, contract_status_name
FROM contract_status
WHERE org_id = 0;


INSERT INTO kin_types (org_id, kin_type_name)
SELECT 1, kin_type_name
FROM kin_types
WHERE org_id = 0;

INSERT INTO education_class (org_id, education_class_name)
SELECT 1, education_class_name
FROM education_class
WHERE org_id = 0
ORDER BY education_class_id;

INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_name, visible, in_tax) VALUES (1, 41, 'Sitting Allowance', true, true);
INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_Name, Visible, In_Tax) VALUES (1, 42, 'Bonus', true, true);
INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_Name, Visible, In_Tax) VALUES (2, 43, 'External Loan', true, false);
INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_Name, Visible, In_Tax) VALUES (2, 44, 'Home Ownership saving plan', true, false);
INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_Name, Visible, In_Tax) VALUES (2, 45, 'Staff contribution', true, false);
INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_Name, Visible, In_Tax) VALUES (3, 46, 'Travel', true, false);
INSERT INTO adjustments (adjustment_type, adjustment_id, adjustment_Name, Visible, In_Tax) VALUES (3, 47, 'Communcation', true, false);
UPDATE adjustments SET org_id = 1, currency_id = 5 WHERE org_id is null;
SELECT pg_catalog.setval('adjustments_adjustment_id_seq', 50, true);

INSERT INTO tax_types (tax_type_id, use_key, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active) VALUES (7, 3, 'PAYE', 'get_employee_tax(employee_tax_type_id, 2)', 1162, 1, false, true, true, 0, 0, true);
INSERT INTO tax_types (tax_type_id, use_key, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active) VALUES (8, 3, 'FULL PAYE', 'get_employee_tax(employee_tax_type_id, 2)', 0, 0, false, false, false, 0, 0, false);
INSERT INTO tax_types (tax_type_id, use_key, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active) VALUES (9, 1, 'NSSF', 'get_employee_tax(employee_tax_type_id, 1)', 0, 0, true, true, true, 0, 0, true);
INSERT INTO tax_types (tax_type_id, use_key, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active) VALUES (10, 1, 'NHIF', 'get_employee_tax(employee_tax_type_id, 1)', 0, 0, false, false, false, 0, 0, true);
INSERT INTO tax_types (tax_type_id, use_key, org_id, tax_type_name, tax_rate) VALUES (11, 2, 1, 'Exempt', 0);
INSERT INTO tax_types (tax_type_id, use_key, org_id, tax_type_name, tax_rate) VALUES (12, 2, 1, 'VAT', 16);
UPDATE tax_types SET org_id = 1, currency_id = 5 WHERE org_id is null;
SELECT pg_catalog.setval('tax_types_tax_type_id_seq', 12, true);


INSERT INTO tax_rates (org_id, tax_type_id, tax_range, tax_rate)
SELECT 1,  tax_type_id + 4, tax_range, tax_rate
FROM tax_rates
WHERE org_id = 0;

INSERT INTO sys_emails (org_id, use_type,  sys_email_name, title, details) 
SELECT 1, use_type, sys_email_name, title, details
FROM sys_emails
WHERE org_id = 0;

INSERT INTO accounts_class (org_id, accounts_class_no, chat_type_id, chat_type_name, accounts_class_name)
SELECT 1, accounts_class_no, chat_type_id, chat_type_name, accounts_class_name
FROM accounts_class
WHERE org_id = 0;


INSERT INTO account_types (org_id, accounts_class_id, account_type_no, account_type_name)
SELECT a.org_id, a.accounts_class_id, b.account_type_no, b.account_type_name
FROM accounts_class a INNER JOIN account_types b ON a.accounts_class_no = b.accounts_class_id
WHERE (a.org_id = 1) AND (b.org_id = 0);


INSERT INTO accounts (org_id, account_type_id, account_no, account_name)
SELECT a.org_id, a.account_type_id, b.account_no, b.account_name
FROM account_types a INNER JOIN accounts b ON a.account_type_no = b.account_type_id
WHERE (a.org_id = 1) AND (b.org_id = 0);


INSERT INTO workflows (workflow_id, org_id, source_entity_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details) 
VALUES (9, 1, 7, 'Leave', 'employee_leave', NULL, NULL, 'Leave approved', 'Leave rejected', NULL, NULL, NULL);
INSERT INTO workflows (workflow_id, org_id, source_entity_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details) 
VALUES (10, 1, 7, 'Claims', 'claims', NULL, NULL, 'Claims approved', 'Claims rejected', NULL, NULL, NULL);
INSERT INTO workflows (workflow_id, org_id, source_entity_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details) 
VALUES (11, 1, 7, 'Advances', 'employee_advances', NULL, NULL, 'Advance approved', 'Advance rejected', NULL, NULL, NULL);
SELECT pg_catalog.setval('workflows_workflow_id_seq', 11, true);


INSERT INTO workflow_phases (workflow_phase_id, org_id, workflow_id, approval_entity_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details) 
VALUES (9, 1, 9, 0, 1, 0, 0, 6, 1, false, false, 'Approve', 'For your approval', 'Phase approved', NULL, NULL, NULL);
INSERT INTO workflow_phases (workflow_phase_id, org_id, workflow_id, approval_entity_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details) 
VALUES (10, 1, 10, 0, 1, 0, 0, 6, 1, false, false, 'Approve', 'For your approval', 'Phase approved', NULL, NULL, NULL);
INSERT INTO workflow_phases (workflow_phase_id, org_id, workflow_id, approval_entity_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details) 
VALUES (11, 1, 11, 0, 1, 0, 0, 6, 1, false, false, 'Approve', 'For your approval', 'Phase approved', NULL, NULL, NULL);
SELECT pg_catalog.setval('workflow_phases_workflow_phase_id_seq', 11, true);


