UPDATE orgs SET org_name = 'OpenBaraza', cert_number = 'C.102554', pin = 'P051165288J', vat_number = '0142653A', 
default_country_id = 'KE', currency_id = 1,
org_full_name = 'OpenBaraza',
invoice_footer = 'Make all payments to : Dew CIS Solutions ltd
Thank you for your Business
We Turn your information into profitability'
WHERE org_id = 0;


INSERT INTO members (org_id, person_title, member_name, id_number, email, phone_number, phone_number2, address, town, zip_code, date_of_birth, gender, nationality, marital_status) VALUES (0, 'Mr', 'Dennis Wachira Gichangi', '787897897', 'dennis@dennis.me.ke', '797897897', NULL, '23423', 'Nairobi', NULL, '2010-06-08', 'M', 'KE', 'M');
INSERT INTO members (org_id, person_title, member_name, id_number, email, phone_number, phone_number2, address, town, zip_code, date_of_birth, gender, nationality, marital_status) VALUES (0, 'Mrs', 'Rachel Mogire', '9898989', 'rachel@gmail.com', '79878977', NULL, '778778', 'Nairobi', '00100', '1980-02-05', 'F', 'KE', 'M');


DELETE FROM currency WHERE currency_id > 1;