UPDATE orders SET batch_no = 1;
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (1, NULL, 'Application', NULL, 'Application', '<p>Dear{{name}},</p><p>Thank you for registering with faidaplus, your details are been verified.</p>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (2, NULL, 'Application Approval', NULL, 'Account Activated', NULL);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (3, NULL, 'Application Rejected', NULL, 'Application Rejected', '<p>Dear{{name}},</p><p>We sorry your application was rejected, check your pcc/son if valid.</p>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (4, NULL, 'Orders', NULL, 'Orders Update status', '<p>Dear {{name}} ,</p><p>{{narative}}</p>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) VALUES (5, NULL, 'New Orders', NULL, 'New Orders', '<p>Dear {{name}} ,</p><p>{{narative}}</p>');
