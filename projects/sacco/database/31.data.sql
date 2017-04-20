

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (1, 0, 'Application', 'Thank you for your Application', 'Thank you {{name}} for your application.<br><br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
Regards<br>
Human Resources Manager<br>');
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, title, details) 
VALUES (2, 0, 'New Staff', 'HR Your credentials ', 'Hello {{name}},<br><br>
Your credentials to the HR system have been created.<br>
Your user name is {{username}}<br> 
Your password is {{password}}<br><br>
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


