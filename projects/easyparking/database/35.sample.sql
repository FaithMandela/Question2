UPDATE orgs SET org_name = 'Dew CIS Solutions Ltd', cert_number = 'C.102554', pin = 'P051165288J', vat_number = '0142653A', 
default_country_id = 'KE', currency_id = 1,
org_full_name = 'Dew CIS Solutions Ltd',
invoice_footer = 'Make all payments to : Dew CIS Solutions ltd
Thank you for your Business
We Turn your information into profitability'
WHERE org_id = 0;


DELETE FROM currency WHERE currency_id IN (2, 3, 4);

INSERT INTO fiscal_years (fiscal_year_id, fiscal_year, org_id, fiscal_year_start, fiscal_year_end)
VALUES (2, '2017/2018', 0, '2017-07-01', '2018-06-30');
SELECT add_periods('2', '0', '0');
UPDATE periods SET opened = true, activated = true WHERE start_date = '2017-10-01'::date;


INSERT INTO mpesa_trxs (org_id, mpesa_id, mpesa_orig, mpesa_dest, mpesa_tstamp, mpesa_text, mpesa_code, mpesa_acc, mpesa_msisdn, mpesa_trx_date, mpesa_trx_time, mpesa_amt, mpesa_sender, mpesa_pick_time) 
VALUES (0, 1453224215, 'MPESA', '254708008000', '2017-10-18 11:02:00', 'LJI7QV5BP9 Confirmed. on 18/10/17 at 11:01 AM Ksh5,000.00 received from MERCY NJERI 254725866734.  Account Number Jeanah ventures New Utility balance is ', 'LJI7QV5BP9', 'KBU124C', '254725866734', '2017-10-18', '11:01:00', 3000, 'MERCY NJERI', '2017-10-18 11:02:10.490789');
INSERT INTO mpesa_trxs (org_id, mpesa_id, mpesa_orig, mpesa_dest, mpesa_tstamp, mpesa_text, mpesa_code, mpesa_acc, mpesa_msisdn, mpesa_trx_date, mpesa_trx_time, mpesa_amt, mpesa_sender, mpesa_pick_time) 
VALUES (0, 1454098806, 'MPESA', '254708008000', '2017-10-18 16:45:42', 'LJI8R261VQ Confirmed. on 18/10/17 at 4:45 PM Ksh5,000.00 received from CHARLES MOGUSU MEKUBO 254722721788.  Account Number Touchpoint New Utility balance', 'LJI8R261VQ', 'KCC210D', '254722721788', '2017-10-18', '16:45:00', 5000, 'CHARLES MOGUSU MEKUBO', '2017-10-18 16:45:52.201819');
