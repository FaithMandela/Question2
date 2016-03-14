
UPDATE orders SET batch_no = 1;
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (1, NULL, 'Application', NULL, 'Application', '<p>Dear{{name}},</p><p>Thank you for registering with faidaplus, your details are been verified.</p>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (2, NULL, 'Application Approval', NULL, 'Account Activated', NULL);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (3, NULL, 'Application Rejected', NULL, 'Application Rejected', '<p>Dear{{name}},</p><p>We sorry your application was rejected, check your pcc/son if valid.</p>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (4, NULL, 'Orders', NULL, 'Orders Update status', '<p>Dear {{name}} ,</p><p>{{narative}}</p>');


INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('4', '2016-01-01','2016-01-31','To handle segments discrepancies in Aug 2015','2RJ');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('50', '2016-01-01','2016-02-29','kes. 50 to push share to 50% from 10%','7PX1');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('50', '2016-01-01','2016-02-29','kes. 50 to push share to 50% from 10%','B30');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('25', '2016-01-01','2016-02-29','50% bonus to push share from 10% to 50%','75M5');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('40', '2016-01-01','2016-03-31','Shiamsy extension from Jan-Mar to push more share','7GQ4');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('5', '2016-01-01','2016-02-29','Discrepancies Aug and Dec 2015','757E');
INSERT INTO bonus (amount, start_date, end_date, details, pcc) VALUES ('8', '2016-02-01','2016-03-31','points difference in Jan','8GH');


INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('51', '2016-01-01','2016-01-31','Recovery', 1701);
INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('42', '2016-02-01','2016-02-29','Recovery', 1701);


INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('30', '2016-01-01','2016-01-31','Recovery', 505);
INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('1', '2016-01-01','2016-01-31','Recovery', 2028);
INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('25', '2016-01-01','2016-01-31','Recovery', 180);

INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('15', '2016-02-01','2016-02-29','Recovery', 139);
INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('27', '2016-02-01','2016-02-29','Recovery', 505);
INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('16', '2016-02-01','2016-02-29','Recovery', 2031);
INSERT INTO bonus (percentage, start_date, end_date, details, consultant_id) VALUES ('11', '2016-02-01','2016-02-29','Recovery', 2028);

INSERT INTO bonus (percentage, start_date, end_date, details, period_id) VALUES ('50', '2016-02-01','2016-02-29','Recovery', 110);


UPDATE bonus SET approve_status = 'Approved', is_active = true;

