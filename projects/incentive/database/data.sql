
--
-- Data for Name: booking_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO booking_types (booking_type_id, booking_type_name, details) VALUES (1, 'Local', NULL);
INSERT INTO booking_types (booking_type_id, booking_type_name, details) VALUES (2, 'East Africa', NULL);
INSERT INTO booking_types (booking_type_id, booking_type_name, details) VALUES (3, 'Rest of Africa', NULL);
INSERT INTO booking_types (booking_type_id, booking_type_name, details) VALUES (4, 'International', NULL);


--
-- Name: booking_types_booking_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('booking_types_booking_type_id_seq', 4, true);


INSERT INTO class_categorys (class_id, booking_type_id, class_name, details) VALUES (1, 1, 'Domestic', NULL);
INSERT INTO class_categorys (class_id, booking_type_id, class_name, details) VALUES (2, 2, 'East Africa', NULL);
INSERT INTO class_categorys (class_id, booking_type_id, class_name, details) VALUES (3, 3, 'Rest Of Africa', NULL);
INSERT INTO class_categorys (class_id, booking_type_id, class_name, details) VALUES (4, 4, 'Economy Class', NULL);
INSERT INTO class_categorys (class_id, booking_type_id, class_name, details) VALUES (5, 4, 'Business Class', NULL);


--
-- Name: class_categorys_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('class_categorys_class_id_seq', 5, true);

INSERT INTO points_scaling (scaling_id, class_id, one_way, isreturn, start_date, end_date, details, code) VALUES (1, 1, 5, 10, now(), now()+ interval '1 year', NULL, 'L');
INSERT INTO points_scaling (scaling_id, class_id, one_way, isreturn, start_date, end_date, details, code) VALUES (2, 2, 15, 20, now(), now()+ interval '1 year', NULL, 'RE');
INSERT INTO points_scaling (scaling_id, class_id, one_way, isreturn, start_date, end_date, details, code) VALUES (3, 3, 20, 25, now(), now()+ interval '1 year', NULL, 'RR');
INSERT INTO points_scaling (scaling_id, class_id, one_way, isreturn, start_date, end_date, details, code) VALUES (4, 4, 25, 30, now(), now()+ interval '1 year', NULL, 'IE');
INSERT INTO points_scaling (scaling_id, class_id, one_way, isreturn, start_date, end_date, details, code) VALUES (5, 5, 30, 40, now(), now()+ interval '1 year', NULL, 'IB');
--
-- Name: points_scaling_scaling_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--
SELECT pg_catalog.setval('points_scaling_scaling_id_seq', 5, true);

INSERT INTO suppliers (supplier_id, supplier_name, create_date, contact_name, email, website, address, details) VALUES (1, 'Safaricom', 'now()', NULL, NULL, NULL, NULL, NULL);
INSERT INTO suppliers (supplier_id, supplier_name, create_date, contact_name, email, website, address, details) VALUES (2, 'Airtel', 'now()', NULL, NULL, NULL, NULL, NULL);
INSERT INTO suppliers (supplier_id, supplier_name, create_date, contact_name, email, website, address, details) VALUES (3, 'Tusky''s', 'now()', NULL, NULL, NULL, NULL, NULL);
INSERT INTO suppliers (supplier_id, supplier_name, create_date, contact_name, email, website, address, details) VALUES (4, 'Nakumatt', 'now()', NULL, NULL, NULL, NULL, NULL);
INSERT INTO suppliers (supplier_id, supplier_name, create_date, contact_name, email, website, address, details) VALUES (5, 'Airport', 'now()', NULL, NULL, NULL, NULL, NULL);



--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('suppliers_supplier_id_seq', 5, true);

INSERT INTO points_value (point_value_id, point_value, start_date, end_date, details) VALUES (1, 5, now(), now()+ interval '1 year', NULL);


--
-- Name: points_value_point_value_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('points_value_point_value_id_seq', 1, true);

INSERT INTO product_category (product_category_id, product_category_name, details, icon) VALUES (1, 'Super Markets', NULL, 'fa-cart-plus');
INSERT INTO product_category (product_category_id, product_category_name, details, icon) VALUES (2, 'Airtime', NULL, 'fa-credit-card');
INSERT INTO product_category (product_category_id, product_category_name, details, icon) VALUES (3, 'Airport transfers', NULL, NULL);


--
-- Name: product_category_product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('product_category_product_category_id_seq', 3, true);


INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (1, 1, 3, NULL, 'Tusky''s Kshs 1,000 Voucher', 1000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, '1pic.jpg', NULL);
INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (2, 1, 3, NULL, 'Tusky''s Kshs 2,000 Voucher', 2000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);
INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (3, 1, 3, NULL, 'Tusky''s Kshs 5,000 Voucher', 5000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);

INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (4, 1, 4, NULL, 'Nakumatt Ksh 1,000 Voucher', 1000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, '2pic.jpg', NULL);
INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (5, 1, 4, NULL, 'Nakumatt Ksh 2,000 Voucher', 2000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);
INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (6, 1, 4, NULL, 'Nakumatt Ksh 5,000 Voucher', 5000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);
INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (7, 3, 5, NULL, 'Airport transfer Ksh 2,000', 2000, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);

INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (8, 2, 1, NULL, 'SAfaricom Ksh 100 Airtime', 100, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);
INSERT INTO products (product_id, product_category_id, supplier_id, created_by, product_name, product_uprice, product_ucost, created, product_details, terms, weight, remarks, is_active, updated_by, updated, narrative, image, details) VALUES (9, 2, 2, NULL, 'Airtel Ksh 100 Airtime', 100, NULL, now(), NULL, NULL, NULL, NULL, true, NULL, now(), NULL, NULL, NULL);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('products_product_id_seq', 9, true);




--
-- Data for Name: sys_emails; Type: TABLE DATA; Schema: public; Owner: root
--
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (1, 0, 'Application', NULL, 'Application', '<p>Dear {{name}}</p>
<p>Your have successfully register with incentive loyalty program.&nbsp;</p>
<p>&nbsp;We shall respond within the next 48hrs with your username and password.</p>
<p>&nbsp;</p>
<p>Thank you</p>
<p>&nbsp;</p>
<p>Incentive Travel</p>', 2);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (2, 0, 'Clients account Activated', NULL, 'Clients Activated', '<p>Dear {{name}},</p>
<p>&nbsp;</p>
<p>Welcome to Incentive Travel</p>
<p>&nbsp;</p>
<p>We are happy to inform you that your application for our loyalty program has been accepted.&nbsp;</p>
<p>&nbsp;</p>
<p>Username:{{username}}</p>
<p>password : {{password}}</p>
<p>Thank you</p>
<p>&nbsp;</p>
<p>Incentive Travel</p>', 2);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (3, NULL, 'Clients Rejected', NULL, 'Clients Rejected', '<p>Dear{{name}},</p>
<p>Welcome to Incentive Travel</p>
<p>&nbsp;</p>
<p>Thank you for applying for membership to our loyalty program</p>
<p>&nbsp;</p>
<p>We appreciate your interest&nbsp; in our program, unfortunately you don&rsquo;t qualify for membership.</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><strong>Terms &amp; Conditions</strong></p>
<p>&nbsp;</p>
<p>Thank you</p>
<p>&nbsp;</p>
<p>Incentive Travel</p>', 2);

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (4, 0, 'Order submitted', NULL, 'Order submitted', '<p>Dear {{name}}</p>
<p>&nbsp;</p>
<p><span style="color:#0075B0">Your order of </span>{{mailbody}} <span style="color:#0075B0">has been submitted, you will be notified once the order processing begins. </span></p>
<p>&nbsp;</p>
<p>Regards,</p>
<p>Incentive Travel</p>', 3);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (5, NULL, 'Order on processing ', NULL, 'Order on processing ', '<p><span style="color:#0075B0">Dear {{name}},</span></p>

<p><span style="color:#0075B0">Your order of </span>{{mailbody}}<span style="color:#0075B0"> is being processed, once ready for collection an email notification will be sent to you. </span></p>

<p>Regards,</p>

<p>Incentive Travel</p>', 3);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (6, 0, 'Order awaiting collection', NULL, 'Order awaiting collection', '<p>Dear {{name}},</p>

<p><span style="color:#0075B0">Your order&nbsp;</span>{{mailbody}}<span style="color:#0075B0"> is ready for collection. Please login to Travelcreactions go to the orders tab, download and print the collection document and present at the office during collection.</span></p>

<p>Regards,</p>

<p>Travel Creations Team</p>
', 3);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (7, NULL, 'Order Collected', NULL, 'Order Collected', '<p><span style="color:#0075B0">Dear {{name}},</span></p>

<p><span style="color:#0075B0">Thank you for collecting the order in the subject line. Happy selling!</span></p>

<p>&nbsp;</p>

<p>Regards,</p>

<p>Travel Creations Team</p>
', 3);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (8, NULL, 'Reset Password', NULL, 'Password Reset', '<p>Dear {{name}},</p>

<p>Username: {{username}}</p>

<p>&nbsp;</p>

<p>Password : {{password}}</p>
', 1);
INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (9, NULL, 'Points', NULL, 'Points Generated', '<p>Dear {{name}}</p>

<p>Congratulations!!! Your points are ready for you to redeem.</p>

<p>&nbsp;</p>

<p>Sit back, &nbsp;choose by clicking a button of your preferred reward/s for delivery.</p>

<p>&nbsp;</p>

<p>Thank you</p>

<p>&nbsp;</p>

<p>Incentive Travel</p>
', 3);

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details, use_type)
VALUES (10, NULL, 'Donation', NULL, 'Sambaza Update status', NULL, 3);




--
-- Name: sys_emails_sys_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_emails_sys_email_id_seq', 10, true);


--
-- PostgreSQL database dump complete
--

--
-- Data for Name: workflows; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO workflows (workflow_id, source_entity_id, org_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details)
VALUES (1, 1, NULL, 'Applicant', 'entitys', NULL, NULL, '<p>Request approved</p>', '<p>Request rejected</p>', NULL, NULL, NULL);
INSERT INTO workflows (workflow_id, source_entity_id, org_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details)
 VALUES (2, 1, NULL, 'Period points approval', 'periods', NULL, NULL, '<p>Request approved</p>
', '<p>Request rejected</p>', NULL, NULL, NULL);
INSERT INTO workflows (workflow_id, source_entity_id, org_id, workflow_name, table_name, table_link_field, table_link_id, approve_email, reject_email, approve_file, reject_file, details)
 VALUES (3, 1, NULL, 'Batch Orders ', 'orders', NULL, NULL, '<p>Request approved</p>
', '<p>Request rejected</p>', NULL, NULL, NULL);


--
-- Name: workflows_workflow_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('workflows_workflow_id_seq', 3, true);


--
-- Data for Name: workflow_phases; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO workflow_phases (workflow_phase_id, workflow_id, approval_entity_id, org_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, reporting_level, use_reporting, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details)
VALUES (1, 1, 0, NULL, 1, 0, 0, 3, 1, 1, false, false, false, '', '<p>For your approval</p>
', '<p>Phase approved</p>
', NULL, NULL, NULL);
INSERT INTO workflow_phases (workflow_phase_id, workflow_id, approval_entity_id, org_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, reporting_level, use_reporting, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details)
VALUES (2, 2, 4, NULL, 1, 0, 0, 3, 1, 1, false, false, false, '', '<p>For your approval</p>
', '<p>Phase approved</p>
', NULL, NULL, NULL);
INSERT INTO workflow_phases (workflow_phase_id, workflow_id, approval_entity_id, org_id, approval_level, return_level, escalation_days, escalation_hours, required_approvals, reporting_level, use_reporting, advice, notice, phase_narrative, advice_email, notice_email, advice_file, notice_file, details)
VALUES (3, 3, 4, NULL, 1, 0, 0, 3, 1, 1, false, false, false, '', '<p>For your approval</p>
', '<p>Phase approved</p>
', NULL, NULL, NULL);


--
-- Name: workflow_phases_workflow_phase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('workflow_phases_workflow_phase_id_seq', 3, true);

INSERT INTO entitys( entity_id, entity_type_id, use_key_id, org_id, entity_name, user_name,
            primary_email,function_role, is_active, first_password)
    VALUES (2, 1, 0, 1, 'Joy Makena', 'joymakena@gmail.com','joymakena@gmail.com', 'admin', true, 'baraza');
INSERT INTO entitys( entity_id, entity_type_id,use_key_id, org_id, entity_name, user_name,
            primary_email,function_role, is_active, first_password)
    VALUES (3, 1, 0, 1, 'Jacklyne Njeri', 'njeri@gmail.com','njeri@gmail.com', 'admin', true, 'baraza');
INSERT INTO entitys( entity_id, entity_type_id, use_key_id,org_id, entity_name, user_name,
            primary_email,function_role, is_active, first_password)
    VALUES (4, 1  0,1, 'Christine Nyambura', 'nyambura@gmail.com','nyambura@gmail.com', 'admin', true, 'baraza');
INSERT INTO entitys( entity_id, entity_type_id, use_key_id,org_id, entity_name, user_name,
            primary_email,function_role, is_active, first_password)
    VALUES (5, 1, 0, 1, 'Solomon Murug', 'solomon@gmail.com','solomon@gmail.com', 'admin', true, 'baraza');
    SELECT pg_catalog.setval('entitys_entity_id_seq', 5, true);
