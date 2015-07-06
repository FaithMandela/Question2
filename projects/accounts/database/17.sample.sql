UPDATE orgs SET org_name = 'Dew CIS Solutions Ltd', cert_number = 'C.102554', pin = 'P051165288J', vat_number = '0142653A', 
invoice_footer = 'Make all payments to : Dew CIS Solutions ltd
Thank you for your Business
We Turn your information into profitability';

UPDATE transaction_types SET document_number = '10001';

INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, user_name, super_user, entity_leader, function_role, date_enroled, is_active, entity_password, first_password, details, account_id, attention) 
VALUES (2, 0, 2, 'Kenya Aiways', 'travelport', false, false, 'client', '2011-11-16 09:48:12.983091', true, 'cdaab4aa7870bb7758599fb9473bf16a', '94J860RR', NULL, 30000, 'Travelport Kenya');

INSERT INTO address (address_id, address_name, sys_country_id, table_name, table_id, post_office_box, postal_code, premises, street, town, phone_number, extension, mobile, fax, email, website, is_default, first_password, details) VALUES (1, NULL, 'KE', 'orgs', 0, '45689', '00100', '16th Floor, view park towers', 'Utalii Lane', 'Nairobi', '+254 (20) 2227100/2243097', NULL, '+254 725 819505 or +254 738 819505', NULL, 'accounts@dewcis.com', 'www.dewcis.com', true, NULL, NULL);
INSERT INTO address (address_id, address_name, sys_country_id, table_name, table_id, post_office_box, postal_code, premises, street, town, phone_number, extension, mobile, fax, email, website, is_default, first_password, details) VALUES (2, NULL, 'KE', 'entitys', 2, '41010', '00100', 'Barclays Plaza, 6th Floor', 'Loita Street', 'Nairobi', '+254 20 3274233/5', NULL, NULL, NULL, 'info@travelport-kenya.com', 'www.travelport-kenya.com', true, NULL, NULL);


INSERT INTO items (item_id, org_id, item_category_id, tax_type_id, item_unit_id, sales_account_id, purchase_account_id, item_name, bar_code, inventory, for_sale, for_purchase, sales_price, purchase_price, reorder_level, lead_time, is_active, details) VALUES (1, 0, 1, 2, 1, 70010, 80000, 'Domains', NULL, false, true, false, 5000, 0, NULL, NULL, true, NULL);
INSERT INTO items (item_id, org_id, item_category_id, tax_type_id, item_unit_id, sales_account_id, purchase_account_id, item_name, bar_code, inventory, for_sale, for_purchase, sales_price, purchase_price, reorder_level, lead_time, is_active, details) VALUES (2, 0, 1, 2, 1, 70010, 80000, 'Baraza HCMS', NULL, false, true, false, 0, 0, NULL, NULL, true, NULL);
INSERT INTO items (item_id, org_id, item_category_id, tax_type_id, item_unit_id, sales_account_id, purchase_account_id, item_name, bar_code, inventory, for_sale, for_purchase, sales_price, purchase_price, reorder_level, lead_time, is_active, details) VALUES (3, 0, 1, 2, 1, 70010, 80000, 'Systems Support', NULL, false, true, false, 0, 0, NULL, NULL, false, NULL);
INSERT INTO items (item_id, org_id, item_category_id, tax_type_id, item_unit_id, sales_account_id, purchase_account_id, item_name, bar_code, inventory, for_sale, for_purchase, sales_price, purchase_price, reorder_level, lead_time, is_active, details) VALUES (4, 0, 3, 2, 1, 70005, 95500, 'Office Rent', NULL, false, false, true, 0, 0, NULL, NULL, true, NULL);
SELECT pg_catalog.setval('items_item_id_seq', 4, true);


