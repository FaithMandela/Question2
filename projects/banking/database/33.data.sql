
--- Create use key types
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (100, 'Customers', 0);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (101, 'Receipts', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (102, 'Payments', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (103, 'Charges', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (104, 'Transfer', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (105, 'Loan Intrests', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (106, 'Loan Penalty', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (107, 'Loan Payment', 4);
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (108, 'Loan Disbursement', 4);


INSERT INTO entity_types (org_id, use_key_id, entity_type_name, entity_role) VALUES (0, 100, 'Bank Customers', 'client');


INSERT INTO activity_types (activity_type_id, account_id, use_key_id, org_id, activity_type_name, is_active, details) VALUES (1, 34005, 101, 0, 'Customer Deposits', true, NULL);
INSERT INTO activity_types (activity_type_id, account_id, use_key_id, org_id, activity_type_name, is_active, details) VALUES (2, 34005, 102, 0, 'Customer Withdrawal', true, NULL);
INSERT INTO activity_types (activity_type_id, account_id, use_key_id, org_id, activity_type_name, is_active, details) VALUES (3, 34005, 108, 0, 'Loan Disbursement', true, NULL);
INSERT INTO activity_types (activity_type_id, account_id, use_key_id, org_id, activity_type_name, is_active, details) VALUES (4, 34005, 103, 0, 'Account opening charges', true, NULL);
SELECT pg_catalog.setval('activity_types_activity_type_id_seq', 4, true);


INSERT INTO interest_methods (interest_method_id, org_id, interest_method_name, formural, details) VALUES (1, 0, 'Loan Fixed Intrest', 'get_intrest(1, loan_id)', NULL);
INSERT INTO interest_methods (interest_method_id, org_id, interest_method_name, formural, details) VALUES (2, 0, 'Loan reducing balnace', 'get_intrest(2, loan_id)', NULL);
INSERT INTO interest_methods (interest_method_id, org_id, interest_method_name, formural, details) VALUES (3, 0, 'Savings intrest', 'get_intrest(1, loan_id)', NULL);
INSERT INTO interest_methods (interest_method_id, org_id, interest_method_name, formural, details) VALUES (4, 0, 'No Intrest', 'get_intrest(1, loan_id)', NULL);
SELECT pg_catalog.setval('interest_methods_interest_method_id_seq', 4, true);


INSERT INTO products (product_id, account_id, interest_method_id, currency_id, org_id, product_name, description, loan_account, is_active, interest_rate, interest_frequency, repay_every, min_opening_balance, lockin_period_frequency, minimum_balance, maximum_balance, minimum_day, maximum_day, minimum_trx, maximum_trx, details) VALUES (1, 34005, 4, 1, 0, 'Transaction account', 'Account to handle transactions', false, true, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
INSERT INTO products (product_id, account_id, interest_method_id, currency_id, org_id, product_name, description, loan_account, is_active, interest_rate, interest_frequency, repay_every, min_opening_balance, lockin_period_frequency, minimum_balance, maximum_balance, minimum_day, maximum_day, minimum_trx, maximum_trx, details) VALUES (2, 34005, 2, 1, 0, 'Basic loans', 'Basic loans', true, true, 12, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, NULL);
SELECT pg_catalog.setval('products_product_id_seq', 2, true);


INSERT INTO account_fees (account_fee_id, product_id, activity_type_id, org_id, account_fee_name, fee_frequency, start_date, end_date, fee_amount, details) VALUES (1, 1, 4, 0, 'Opening account', 0, '2017-01-01', NULL, 1000, NULL);
SELECT pg_catalog.setval('account_fees_account_fee_id_seq', 1, true);

