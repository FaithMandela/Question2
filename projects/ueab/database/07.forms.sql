
ALTER TABLE fields ADD label_positon varchar(16);

SELECT pg_catalog.setval('forms_form_id_seq', 20, true);

INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (8, 0, 'STUDENT SIGN OUT FORM', 'SSOF', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle">
<p></p><div align="center">UNIVERSITY OF EASTERN AFRICA, BARTON UNIVERSITY OF EASTERN AFRICA, BARTON<br>P.O. BOX 2500  30100 ELDORET, KENYA, EAST AFRICA <br>&nbsp; TELEPHONE: 52471 <br>&nbsp; FAX:020-0023017 <br>&nbsp; FOR BOARDING STUDENTS ONLY <br></div><div align="right"><br></div><p></p>', '<div align="center">A SEVENTH-DAY ADVENTIST INSTITUTION OF HIGHER LEARNING<br>CHARTERED 1991<br></div><div align="center"><br></div>', NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (5, 0, 'UNIVERSITY OF EASTERN AFRICA, BARATON CHARTERED LEGAL NOTICE No. 111, 1991 ', 'ADD AND DROP FORM', '1', '0', '0', '<p><img align="center"  src="ueab.png" alt="No  image"><br></p>

<p align="center"> ADD AND DROP FORM</p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (6, 0, 'GRADUATION APPLICATION AND AGREEMENT FORM', 'GRA', '1', '0', '0', '<p><br></p>
<p><img src="ueab.png" alt="No  image" align="middle"></p><p>GRADUATION APPLICATION AND AGREEMENT FORM</p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (7, 0, 'Examination Request Form', 'ERF', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle">
<p></p><div align="center">UNIVERSITY OF EASTERN AFRICA, BARATON<br></div><div align="center">CHARTERED LEGAL NOTICE No. 111, 1991<br>REGISTRARS OFFICE<br>&nbsp;Examination Request Form<br></div><p></p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (13, 0, 'APPLICATION TO REPEAT A COURSE FORM', 'ATRCF', '1', '0', '0', '<p><img src="ueab.png" alt="No  image" align="middle"></p><p>UNIVERSITY OF EASTERN AFRICA, BARATON<br>P.O Box 2500-30100<br>CHARTERED LEGAL NOTICE No. 111, 1991</p><p><br>APPLICATION TO REPEAT A COURSE FORM<br><br></p>', 'When this form is dully filled, take it to the registrar who will present it to the Academic Standards Committee (ASC) for approval.<br><br>', NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (9, 0, 'CHANGE/ADDITION OF MAJOR REQUEST FORM', 'C/AHRF', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle">

<p>UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br></p>', '<p>NOTE: No action will be taken if the student fails to submit a letter of consent from the Sponsor(s). The student is responsible for bringing all these Forms together with the attachments, to the registrars office.<br><br></p>', NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (11, 0, 'DIFERRED GRADE(DG) FORM', 'DGF', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle"><br><br>UNIVERSITY OF EASTERN AFRICA, BARATON<br>P.O Box 2500-30100<br>ELDORET<br>CHARTERED LEGAL NOTICE No. 111, 1991<br><br>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (12, 0, 'PETITION TO RECEIVE AN INCOMPLETE WORK (IW)', 'PTRAIW', '1', '0', '0', '<p><img src="ueab.png" alt="No  image" align="middle"><br></p><div align="center">UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br><b>PETITION TO RECEIVE AN INCOMPLETE WORK (IW)</b><br><br></div><p></p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (2, 0, 'APPLICATION FOR ADMISSION INTO CERTIFICATE/DIPLOMA COURSE', '2', '1', '0', '0', '<img src="ueab.png" alt="No  image">
<p><b>A Chartered-Seventh Day Adventist Institution of Higher Learning</b><br></p><p>The Registrar, Admissions and Records<br>P.O Box 2500, ELDORET, KENYA<br>Phone: 0326- 2625<br>Fax: (254) 0325- 2526<br><br>Please include the following when returning this form:<br>a. Certified photocopies of credentials<br>b. Application fee of Kshs. 1000 (non-refundable)<br>c. Two recent passport photographs (attach one to the form)<br>Please write legibly and in BLOCK LETTERS<br></p>', '<p>NOTE: The University of Eastern Africa, Baraton is a No Smoking, No Drinking and No Addictive Drug Use zone<br><br></p>', NULL, 'registrations');
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (3, 0, 'Application for Admission to Graduate Studies', '1', '1', '0', '0', '<img src="ueab.png" alt="No  image"></img>
<p>Please complete and sign this form and return it to the Registrar, University of Eastern Africa, Baraton, P.O. Box 2500, Eldoret, Kenya with:<br>1) A non-refundable application fee of US$ 30.00 or its equivalent in Kenya Shilling. 2) Certified photocopies of your College or University diplomas or&nbsp; certificates. 3) Two recent passport-size photos. 4) Three letters of recommendation from your referees in sealed envelopes. 5) Two certified copies of official transcripts from each College and University that you have attended (Ask the concerned institution to send the transcripts directly to the University). 6. Certified photocopy of your secondary school certificate. 7. Updated CV. If&nbsp; accepted you will be notified in writing. No applicant should make arrangements to report to the University 
until he/she has received official letter of acceptance<br></p>', '<p>Important: If a document is written in a language other than English, please submit a certified copy of the document in the original language and its translated version in English. Incomplete supporting documents will cause delay in the admission process.<br><br></p>', NULL, 'registrations');
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (10, 0, 'INSTRUCTORS PETITION FORM FOR CHANGE OF GRADE', 'IPFCOG', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle">

<p>UNIVERSITY OF EASTERN AFRICA, BARATON<br>P.O Box 2500-30100<br>ELDORET<br>CHARTERED LEGAL NOTICE No. 111, 1991</p><p align="center"><b>INSTRUCTORS PETITION FORM FOR CHANGE OF GRADE</b><br>NOTE: This form is filled by the instructor after being satisfied that there is a genuine reason to change of grade. It is required that the instructor fills this form within the first three weeks of the current trimester for change of a grade of the previous trimester. The instructor must make four copies of the duly filled and signed form and give the following.<br></p><ol><li>The Department Chairperson</li><li>The School Dean</li><li>The Registrar</li><li>The Instructor remains with copy<br></li></ol>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (1, 0, 'APPLICATION FOR ADMISSION FOR UNDERGRADUATES', 'AAU', '1', '0', '0', '<img src="ueab.png" alt="No  image">
<p align="center">CHARTERED, LEGAL NOTICE NO. 111.1991<br><br>

</p><table>
<tbody><tr>
<td align="right">
P.O Box 2500, Eldoret  30100, Kenya<br>Fax (254) 053-52263<br>Website: www.ueab.ac.ke<br><br>
</td><td>
East Africa callers. Tel: 053-522625<br>International callers. Tel: (254) 053-522625<br>E-mail: admissions@ueab.ac.ke
</td>
</tr>
</tbody></table><p></p>

Please include the following when returning this form:
<br>a. Certified photocopy(s) of Secondary School Certificate(s)<br>b. Other certified certificates/diplomas if applicable
<br>c. Application fee of Ksh. 1,500/=/US $ 20 (non-refundable)
<br>d. Two clear, recent passport-size photographs (4.5 sq.cm or 2 in. by 2 in.)
Both ears should be clearly seen.
<br>e. Two Application Evaluation/Recommendation in sealed envelopes.<br>f. Signed affidavit of support by parents/sponsor (for international students).



', '<p></p><p>NOTIFICATION OF ACCEPTANCE: If admitted,&nbsp; you will be notified in writing. No student should come to the University until he/she receives a formal admission letter. Comply with the information given in the admission letter. Failure to comply with the instructions may lead to cancellation of the admission. International students must also comply with the Kenya Immigration&nbsp; Regulations.</p><br><br><p></p>', NULL, 'registrations');
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (14, 0, 'CHALLENGE EXAMINATION APPLICATION FORM', 'CEAF', '1', '0', '0', '<img src="ueab.png" alt="No  image">

<p></p><div align="center"><b>UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br>CHALLENGE EXAMINATION APPLICATION FORM</b><br></div><p></p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (15, 0, 'CAMPUS TRANSFER FORM', 'CTF', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle">

<p></p><div align="center"><b>UNIVERSITY OF EASTERN AFRICA, BARATON</b><br><b>P.O Box 2500-30100</b><br><b>ELDORET</b><br><b>CHARTERED LEGAL NOTICE No. 111, 1991</b><br></div><p></p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (16, 0, 'CHANGE OF PROGRAMME REQUEST FORM', 'COPRF', '1', '0', '0', '<img src="ueab.png" alt="No  image" align="middle">

<p></p><div align="center">UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br>CHANGE OF PROGRAMME REQUEST FORM<br></div><p></p>', 'NOTE: No action will be taken if the student fails to submit a letter of consent from the Sponsor(s) and letter of agreement from the chairperson of the New Department. The Student is responsible for bringing all these Forms together with the attachments, to the registrars office.<br><br>', NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (17, 0, 'TRANSFER OF CREDITS REQUEST FORM', 'TOCRF', '1', '0', '0', '<img src="ueab.png" alt="No  image">

<p></p><div align="center">UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br>(OFFICE OF THE REGISTRAR)<br>TRANSFER OF CREDITS REQUEST FORM<br></div><p></p>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (18, 0, 'GROUP DIFERRED GRADE (DG) FORM', 'GDGF', '1', '0', '0', '<img src="ueab.png" alt="No  image">

<div align="center">

UNIVERSITY OF EASTERN AFRICA, BARATON<br>P.O Box 2500-30100, ELDORET, KENYA<br>CHARTERED LEGAL NOTICE No. 111, 1991<br>GROUP DIFERRED GRADE (DG) FORM</div>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (19, 0, 'NG Examination Request Form', 'NGERF', '1', '0', '0', '<img src="ueab.png" alt="No  image">

<div align="center">UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br>REGISTRARS OFFICE<br>NG Examination Request Form<br></div>', NULL, NULL, NULL);
INSERT INTO forms (form_id, org_id, form_name, form_number, version, completed, is_active, form_header, form_footer, details, table_name) VALUES (20, 0, 'PETITION FOR REMARK OF FINAL TRIMESTER EXAMINATION', 'PFROFTE', '1', '0', '0', '<img src="ueab.png" alt="No  image">

<div align="center">UNIVERSITY OF EASTERN AFRICA, BARATON<br>CHARTERED LEGAL NOTICE No. 111, 1991<br>PETITION FOR REMARK OF FINAL TRIMESTER EXAMINATION<br></div>NOTE: This form is to be filled in pentaruplicate (five copies) and distributed as follows:<br><ol><li>Student</li><li>Department Chairperson</li><li>School Dean</li><li>DVC-Academics</li><li>Registrar</li></ol>', NULL, NULL, NULL);


SELECT pg_catalog.setval('fields_field_id_seq', 705, true);


INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (3, 0, 1, 'Middle name', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 10, 20, '0', '1', 'L', NULL, NULL, NULL, 'middlename', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (25, 0, 1, 'Name and address of Church where you are a member
', NULL, 'TEXTFIELD', NULL, '0', '0', 250, NULL, 39, '0', '1', 'L', NULL, NULL, NULL, 'churchaddress', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (44, 0, 1, 'Have you ever smoked?
', 'No#Yes', 'LIST', NULL, '0', '0', 440, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'hsmoke', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (60, 0, 1, 'Give dates
', NULL, 'TEXTFIELD', NULL, '0', '0', 600, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, 'attendeddate', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (61, 0, 1, 'Have you ever been expelled/dismissed or refused admission to any institution of learning? If yes Explain
', NULL, 'TEXTFIELD', NULL, '0', '0', 610, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, 'expelled', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (69, 0, 1, '17. Date for which you are applying:(Note: The 1st semester begins in August, inter-semester January, 2nd semester March
', NULL, 'DATE', NULL, '0', '0', 690, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, 'applicationdate', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (126, 0, 2, '4. Marital Status:
', 'Single#Married', 'LIST', NULL, '0', '0', 1260, 1260, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'MaritalStatus', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (210, 0, 3, '7. Where do you plan to stay while attending University of Eastern Africa, Baraton?
', 'On Campus#Off Campus', 'LIST', NULL, '0', '0', 540, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, 'campusresidence', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (405, 0, 9, 'FIRST NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 20, 17, '0', '1', 'L', NULL, NULL, NULL, 'firstname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (186, 0, 3, '12. Do you have any physical handicaps?
', 'NO#YES', 'LIST', NULL, '0', '0', 310, NULL, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'handicap', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (211, 0, 3, 'If Off Campus, state location
', NULL, 'TEXTFIELD', NULL, '0', '0', 550, 550, 51, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (215, 0, 3, 'If Other, specify
', NULL, 'TEXTFIELD', NULL, '0', '0', 590, NULL, 57, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (216, 0, 3, '9. Provide the names of three referees who can completely comment on your character and ability to pursue post graduate studies. Two of
them must come from the College or University last attended, and the third one from your Religious leader or place of work or profession.
', NULL, 'TABLE', NULL, '0', '0', 600, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (124, 0, 2, 'Telephone', NULL, 'TEXTFIELD', NULL, '0', '0', 1240, 1230, 31, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (476, 0, 12, 'a ) STUDENT NAME:
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 20, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (477, 0, 12, 'STUDENT ID NUMBER
', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 20, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (479, 0, 12, 'Phone Number
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 40, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (485, 0, 12, 'Credit 
', NULL, 'TEXTFIELD', NULL, '0', '0', 110, 90, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (486, 0, 12, 'Trimester 
', NULL, 'TEXTFIELD', NULL, '0', '0', 120, 90, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (487, 0, 12, 'Academic Year
', NULL, 'TEXTFIELD', NULL, '0', '0', 130, 90, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (494, 0, 12, '(ii) If additional required work is not returned in by
', NULL, 'TEXTFIELD', NULL, '0', '0', 200, NULL, 54, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (498, 0, 12, 'Date', NULL, 'DATE', NULL, '0', '0', 240, 230, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (499, 0, 12, 'Dept Chairpersons Signature 
', NULL, 'TEXTFIELD', NULL, '0', '0', 250, 230, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (500, 0, 12, 'Date', NULL, 'TEXTFIELD', NULL, '0', '0', 260, 230, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (511, 0, 12, 'date', NULL, 'TEXTFIELD', NULL, '0', '0', 370, 360, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (512, 0, 12, 'INSTRUCTORS SIGN
', NULL, 'TEXTFIELD', NULL, '0', '0', 380, 360, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (510, 0, 12, 'FINAL GRADE
', NULL, 'TEXTFIELD', NULL, '0', '0', 360, 360, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (520, 0, 13, 'FIRST NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 10, 18, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (151, 0, 2, 'I', NULL, 'TEXTFIELD', NULL, '0', '0', 1510, 1510, 70, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (152, 0, 2, 'Parent/Guardian/Sponsor
', NULL, 'TITLE', NULL, '0', '0', 1520, 1510, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (138, 0, 2, 'If Yes, please explain
', NULL, 'TEXTFIELD', NULL, '0', '0', 1380, NULL, 59, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (153, 0, 2, 'commit myself to pay all the fees to the University. Further I undertake to urge the applicant to abide by university rules and regulations.
', NULL, 'TITLE', NULL, '0', '0', 1530, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (147, 0, 2, '15. Which centre do you choose: (Main Campus, Nairobi, Eldoret)? 
', NULL, 'TEXTFIELD', NULL, '0', '0', 1470, NULL, 38, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (408, 0, 9, 'TO
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 60, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (141, 0, 2, 'Educational background. List all institutions of learning attended:
', NULL, 'TABLE', NULL, '0', '0', 1410, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (413, 0, 9, 'MY SPONSOR(S) HAS/HAVE AGREED. MY SPONSORS LETTER OF AGREEMENT TO MY TRANSFER/ADDITION IS
ATTACHED TO THIS FORM
', 'Yes#No', 'LIST', NULL, '0', '0', 110, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (410, 0, 9, 'REASON
', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 80, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (415, 0, 9, 'I HAVE APPROVED THE REQUEST OF ADDITION OF MAJOR/CHANGE OF MAJOR
', NULL, 'TEXTFIELD', NULL, '0', '0', 130, NULL, 37, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (418, 0, 9, 'NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 160, 160, 23, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (148, 0, 2, '16. Give name and address of two referees', NULL, 'TABLE', NULL, '0', '0', 1480, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (414, 0, 9, 'DECLARATION OF THE CHAIRPERSON OF THE ADDED MAJOR/NEW DEPARTMENT
', NULL, 'TITLE', NULL, '0', '0', 120, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (417, 0, 9, 'CHAIRPERSON (Second Major/New Department)
', NULL, 'TITLE', NULL, '0', '0', 150, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (234, 0, 3, 'APPLICANTâS CERTIFICATION
', NULL, 'TITLE', NULL, '0', '0', 770, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (235, 0, 3, 'I hereby certify that all information supplied by me in this application is accurate and complete, I understand that any misrepresentation of
fact will constitute cause for nullification of my application prior to admission or dismissal following admission. I have attached the following
supporting documents to this application form (tick those that apply to you):
', NULL, 'TITLE', NULL, '0', '0', 790, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (238, 0, 3, '3. two recent passport-size photos
', NULL, 'TEXTFIELD', NULL, '0', '0', 820, NULL, 49, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (236, 0, 3, '1. official receipt of application fee payment (US $30.00) :
', NULL, 'TEXTFIELD', NULL, '0', '0', 800, NULL, 37, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (134, 0, 2, '8. Passport/ID No.
', NULL, 'TEXTFIELD', NULL, '0', '0', 1340, 1330, 12, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (422, 0, 9, 'NAME', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 200, 23, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (178, 0, 3, '8. Country of Residence
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 230, 230, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'residenceid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (145, 0, 2, '13. Course you are applying for: Tick ( ) against preferred course
', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 1450, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'majorid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (427, 0, 9, 'SIGN', NULL, 'TEXTFIELD', NULL, '0', '0', 250, 240, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (425, 0, 9, 'DEAN OF SCHOOL (Current School)
', NULL, 'TITLE', NULL, '0', '0', 230, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (426, 0, 9, 'NAME', NULL, 'TEXTFIELD', NULL, '0', '0', 240, 240, 23, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (431, 0, 10, 'COURSE FOR WHICH GRADE IS TO BE CHANGED
', NULL, 'TITLE', NULL, '0', '0', 30, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (443, 0, 10, 'APPROVAL OF CHANGE OF GRADE
', NULL, 'TITLE', NULL, '0', '0', 150, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (407, 0, 9, 'I WOULD LIKE TO CHANGE/ADD SECOND MAJOR FROM/OF
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, NULL, 47, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (440, 0, 10, 'Instructor Name
', NULL, 'TEXTFIELD', NULL, '0', '0', 120, 120, 24, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (430, 0, 10, 'STUDENT ID NO
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (442, 0, 10, 'Date', NULL, 'DATE', NULL, '0', '0', 140, 120, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (429, 0, 10, 'STUDENTS NAME: 
', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (437, 0, 10, 'GRADE IS TO BE CHANGED FROM
', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 90, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (439, 0, 10, 'REASONS FOR CHANGE OF GRADE
', NULL, 'TEXTFIELD', NULL, '0', '0', 110, NULL, 67, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (432, 0, 10, 'Course Code
', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (433, 0, 10, 'Course Title
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 40, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (434, 0, 10, 'Credits
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (435, 0, 10, 'Trimester Taken
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 40, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (436, 0, 10, 'Academic Year
', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 40, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (444, 0, 10, 'CHAIRPERSON NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 160, 160, 21, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (438, 0, 10, 'TO
', NULL, 'TEXTFIELD', NULL, '0', '0', 100, 90, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (447, 0, 10, 'SCHOOL DEAN  NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 190, 190, 21, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (441, 0, 10, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 130, 120, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (445, 0, 10, 'Signature 
', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 160, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (463, 0, 11, 'Academic Year
', NULL, 'TEXTFIELD', NULL, '0', '0', 110, 80, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (450, 0, 10, 'REGISTRAR  NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 220, 220, 23, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (464, 0, 11, 'Trimester
', NULL, 'TEXTFIELD', NULL, '0', '0', 120, 80, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (446, 0, 10, 'Date', NULL, 'DATE', NULL, '0', '0', 180, 160, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (448, 0, 10, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 190, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (449, 0, 10, 'Date', NULL, 'DATE', NULL, '0', '0', 210, 190, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (451, 0, 10, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 230, 220, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (452, 0, 10, 'Date', NULL, 'DATE', NULL, '0', '0', 240, 220, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (409, 0, 9, 'UNDER THE BULLETIN
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 60, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (416, 0, 9, 'TO THE NEW MAJOR OF
', NULL, 'TEXTFIELD', NULL, '0', '0', 140, NULL, 65, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (411, 0, 9, 'SIGNATURE

', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 80, 21, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (412, 0, 9, 'DATE', NULL, 'DATE', NULL, '0', '0', 100, 80, 21, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (421, 0, 9, 'CHAIRPERSON (First Major/Current Department)
', NULL, 'TITLE', NULL, '0', '0', 190, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (423, 0, 9, 'SIGN', NULL, 'TEXTFIELD', NULL, '0', '0', 210, 200, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (419, 0, 9, 'SIGN
', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 160, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (420, 0, 9, 'DATE', NULL, 'DATE', NULL, '0', '0', 180, 160, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (424, 0, 9, 'DATE', NULL, 'DATE', NULL, '0', '0', 220, 200, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (428, 0, 9, 'DATE', NULL, 'DATE', NULL, '0', '0', 260, 240, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (202, 0, 3, '6. Proficiency in English: (a) Written
', 'Excellent#Good#Poor


', 'LIST', NULL, '0', '0', 460, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (206, 0, 3, '(b) Spoken
', 'Excellent#Good#Poor


', 'LIST', NULL, '0', '0', 500, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (213, 0, 3, '8. How will you finance your studies at UEAB?
', 'Self-Sponsorship# Other', 'LIST', NULL, '0', '0', 570, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (227, 0, 3, 'PART 4 EMPLOYMENT RECORD
', NULL, 'TABLE', NULL, '0', '0', 710, NULL, 15, '0', '1', 'L', NULL, 'PART FOUR', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (129, 0, 2, '4. Sex:
', 'Male#Female', 'LIST', NULL, '0', '0', 1290, 1290, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'Sex', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (135, 0, 2, '9. Do you have any disability?
', 'No#Yes', 'LIST', NULL, '0', '0', 1350, NULL, 60, '0', '1', 'L', NULL, 'PART ONE', NULL, 'handicap', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (404, 0, 9, 'LAST NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 20, 17, '0', '1', 'L', NULL, NULL, NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (453, 0, 11, 'DIFERRED GRADE(DG) FORM
', NULL, 'TITLE', NULL, '0', '0', 10, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (232, 0, 3, 'PART 5 CAREER/PROFESSIONAL OBJECTIVES
', NULL, 'TITLE', NULL, '0', '0', 750, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (240, 0, 3, '5. two certified copies of official transcript from each college/university attended (certified by the institution or Commissioner of Oath)
', NULL, 'TEXTFIELD', NULL, '0', '0', 840, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (237, 0, 3, '2. certified photocopies of college or university diplomas or degree certificates
', NULL, 'TEXTFIELD', NULL, '0', '0', 810, NULL, 27, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (239, 0, 3, '4. three letters of recommendation from referees in sealed envelopes
', NULL, 'TEXTFIELD', NULL, '0', '0', 830, NULL, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (241, 0, 3, '6. certified photocopy of secondary school certificate
', NULL, 'TEXTFIELD', NULL, '0', '0', 850, NULL, 40, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (242, 0, 3, '7. updated curriculum vitae (CV)
', NULL, 'TEXTFIELD', NULL, '0', '0', 860, NULL, 50, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (243, 0, 3, '8. essay (response to Part 5 of this form)
', NULL, 'TEXTFIELD', NULL, '0', '0', 870, NULL, 46, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (291, 0, 5, 'Instructions: Have this form completed according to numbered sequence.
', NULL, 'TITLE', NULL, '0', '0', 80, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (459, 0, 11, 'COURSE FOR WHICH THE DEFFERED GRADE IS APPLIED
', NULL, 'TITLE', NULL, '0', '0', 70, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (189, 0, 3, 'PART 2 GENERAL BACKGROUND AND STUDY PREFERENCE (Refer to the attached information sheet to answer some questions in this section)
', NULL, 'TITLE', NULL, '0', '0', 340, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (221, 0, 3, 'PART 3 EDUCATIONAL BACKGROUND Please list High/Secondary School, Colleges and Universities that you have attended
', NULL, 'TABLE', NULL, '0', '0', 650, NULL, 15, '0', '1', 'L', NULL, 'PART THREE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (122, 0, 2, '2. Present mailing address
', NULL, 'TEXTFIELD', NULL, '0', '0', 1220, NULL, 57, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (469, 0, 11, 'DEANS/CHAIRPERSONS SIGNATURE
', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 170, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (470, 0, 11, 'DATE', NULL, 'TEXTFIELD', NULL, '0', '0', 180, 170, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (471, 0, 11, 'Note: The Deans signs only if the Department Chairperson is the instructor or he/she is absent
', NULL, 'TITLE', NULL, '0', '0', 190, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (472, 0, 11, 'NOTE: THE UNIVERSITY OF EASTERN AFRICA, BARATON POLICY WITH RESPECT TO DIFFERED GRADES READS; COURSES FOR WHICH A DG IS USED NORMALLY RUN OVER TWO OR THREE TRIMESTERS, ANY EXTENSION BEYOND THIS NEEDS THE APPROVAL OF THE ACADEMIC STANDARDS COMMITTEE.
', NULL, 'TITLE', NULL, '0', '0', 200, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (473, 0, 11, 'REGISTRARS SIGNATURE
', NULL, 'TEXTFIELD', NULL, '0', '0', 210, 210, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (474, 0, 11, 'DATE', NULL, 'DATE', NULL, '0', '0', 220, 210, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (475, 0, 12, 'Please note (a, b, c and d to be filled by the student)
', NULL, 'TITLE', NULL, '0', '0', 10, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (119, 0, 2, 'Last Name (Surname)
', NULL, 'TEXTFIELD', NULL, '0', '0', 1190, 1190, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (121, 0, 2, 'Middle Name
', NULL, 'TEXTFIELD', NULL, '0', '0', 1210, 1190, 16, '0', '1', 'L', NULL, 'PART ONE', NULL, 'middlename', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (457, 0, 11, 'TEACHERS NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 50, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (465, 0, 11, 'TRIMESTER IN WHICH THE GRADE IS EXPECTED TO BE TURNED IN
', NULL, 'TEXTFIELD', NULL, '0', '0', 130, NULL, 43, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (454, 0, 11, 'STUDENT ID NO.
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 20, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (458, 0, 11, 'SIGNATURE:
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 50, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (455, 0, 11, 'NAME', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 20, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (456, 0, 11, 'DATE', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 20, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (467, 0, 11, 'INSTRUCTORS SIGN
', NULL, 'TEXTFIELD', NULL, '0', '0', 150, 140, 18, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (468, 0, 11, 'DATE', NULL, 'TEXTFIELD', NULL, '0', '0', 160, 140, 18, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (460, 0, 11, 'Course Code
', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 80, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (461, 0, 11, 'Course Title
', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 80, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (462, 0, 11, 'Credits
', NULL, 'TEXTFIELD', NULL, '0', '0', 100, 80, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (466, 0, 11, 'FINAL GRADE
', NULL, 'TEXTFIELD', NULL, '0', '0', 140, 140, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (482, 0, 12, 'c ) COURSE FOR WHICH THE INCOMPLETE WORK (IW) IS REQUIRED
', NULL, 'TITLE', NULL, '0', '0', 80, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (132, 0, 2, '6. Date of Birth : Day/Month/Year
', NULL, 'DATE', NULL, '0', '0', 1320, NULL, 54, '0', '1', 'L', NULL, 'PART ONE', NULL, 'birthdate', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (233, 0, 3, 'Explain your educational goals, career objectives, work experience, awards, and/or extracurricular activities. Write in a paragraph
form (preferably type-written) on a separate sheet of paper and submit as supporting document.
', NULL, 'TEXTFIELD', NULL, '0', '0', 760, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (393, 0, 8, 'DATE OF RETURN 
', NULL, 'TIME', NULL, '0', '0', 110, 110, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (492, 0, 12, 'e ) TO BE FILLED BY THE INSTRUCTOR
', NULL, 'TITLE', NULL, '0', '0', 180, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (125, 0, 2, '3. Name and address of Next of Kin
', NULL, 'TEXTFIELD', NULL, '0', '0', 1250, NULL, 53, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (123, 0, 2, 'Fax:
', NULL, 'TEXTFIELD', NULL, '0', '0', 1230, 1230, 31, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (478, 0, 12, 'Postal Address
', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (483, 0, 12, 'Course Code
', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 90, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (484, 0, 12, 'Title
', NULL, 'TEXTFIELD', NULL, '0', '0', 100, 90, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (480, 0, 12, 'e-mail
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (481, 0, 12, 'b ) Major

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, NULL, 74, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (488, 0, 12, 'TEACHERS NAME
', NULL, 'TEXTFIELD', NULL, '0', '0', 140, NULL, 70, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (490, 0, 12, 'Student Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 160, 160, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (489, 0, 12, 'd ) REASON FOR REQUEST (If poor health attach medical certificate/report)
', NULL, 'TEXTFIELD', NULL, '0', '0', 150, NULL, 42, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (493, 0, 12, '(i) Additional work required to clear the incomplete work
', NULL, 'TEXTFIELD', NULL, '0', '0', 190, NULL, 51, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (491, 0, 12, 'Date', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 160, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (140, 0, 2, '11. How did you know about UEAB?
', NULL, 'TEXTFIELD', NULL, '0', '0', 1400, NULL, 52, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (149, 0, 2, 'Students Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 1490, 1490, 29, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (150, 0, 2, 'Date', NULL, 'DATE', NULL, '0', '0', 1500, 1490, 29, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (155, 0, 2, 'Date', NULL, 'DATE', NULL, '0', '0', 1550, 1540, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (171, 0, 3, '4. Are you coming with family?
', 'No#Yes', 'LIST', NULL, '0', '0', 160, 160, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (160, 0, 3, 'Telephone  :
', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 25, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (120, 0, 2, 'First Name
', NULL, 'TEXTFIELD', NULL, '0', '0', 1200, 1190, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'firstname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (162, 0, 3, 'Permanent Mailing address
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, NULL, 51, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (182, 0, 3, 'Year of entry to Kenya
', NULL, 'TEXTFIELD', NULL, '0', '0', 270, NULL, 54, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (174, 0, 3, 'Number of Children 
', NULL, 'TEXTFIELD', NULL, '0', '0', 190, 170, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (188, 0, 3, 'Yes, Explain 
', NULL, 'TEXTFIELD', NULL, '0', '0', 330, NULL, 59, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (179, 0, 3, '9. If not a Kenyan but a resident of Kenya, what type of visa do you hold?
', 'Student Visa#Other', 'LIST', NULL, '0', '0', 240, NULL, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (154, 0, 2, 'Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 1540, 1540, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (315, 0, 6, 'I know the responsibility for meeting the degree requirements rests upon me
I WILL MAKE NO CHANGES IN THIS PROGRAM WITHOUT THE APPROVAL OF MY ADVISOR AND REGISTRARS 

    OFFICE.Signature 
', NULL, 'TEXTFIELD', NULL, '0', '0', 130, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (322, 0, 6, 'Advisor: SECOND MAJOR 
', NULL, 'TITLE', NULL, '0', '0', 200, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (295, 0, 5, '3. I wish to DROP the following class(es)
', NULL, 'TABLE', NULL, '0', '0', 120, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (346, 0, 6, 'Your Contacts:
', NULL, 'TITLE', NULL, '0', '0', 390, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (368, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 610, 600, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (194, 0, 3, 'Area
', NULL, 'TEXTFIELD', NULL, '0', '0', 390, 390, 29, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (196, 0, 3, '4. Mode of Study:
', 'Full Time#Part Time (Block Release)#Executive Block Release

', 'LIST', NULL, '0', '0', 410, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (191, 0, 3, '2. Proposed date of entrance: Month
', NULL, 'DATE', NULL, '0', '0', 360, NULL, 48, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (201, 0, 3, '5. Language of instruction in home country :
', NULL, 'TEXTFIELD', NULL, '0', '0', 450, NULL, 43, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (195, 0, 3, 'Option', NULL, 'TEXTFIELD', NULL, '0', '0', 400, 390, 29, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (200, 0, 3, 'Which campus?
', NULL, 'TEXTFIELD', NULL, '0', '0', 450, NULL, 57, '0', '1', 'L', NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (495, 0, 12, '(Date no later than the last day of examination of the regular end-trimester examination week scheduled for the following trimester); and if the extension has not been approved by the Academic Standards Committee (ASC), then the final grade will be computed based on the marks earned in the work already done by the student out of the total marks of the course.
', NULL, 'TITLE', NULL, '0', '0', 210, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (496, 0, 12, 'f) Approved by the following
', NULL, 'TITLE', NULL, '0', '0', 220, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (139, 0, 2, '10. If employed, what is your current job?
', NULL, 'TEXTFIELD', NULL, '0', '0', 1390, NULL, 49, '0', '1', 'L', NULL, 'PART ONE', NULL, 'employername', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (156, 0, 3, 'Last name 
', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (384, 0, 8, 'DATE', NULL, 'DATE', NULL, '0', '0', 20, 10, 30, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (97, 0, 1, 'Is any of your parents employed by the SDA Church?
', 'Yes#No', 'LIST', NULL, '0', '0', 970, NULL, 50, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (311, 0, 6, 'Second Trimester
', NULL, 'TABLE', NULL, '0', '0', 90, NULL, 15, '0', '1', NULL, NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (316, 0, 6, '1. Advisor: FIRST MAJOR', NULL, 'TITLE', NULL, '0', '0', 140, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (245, 0, 3, 'APPLICANTS SIGNATURE:
', NULL, 'TEXTFIELD', NULL, '0', '0', 890, 890, 24, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (244, 0, 3, '9. certified copy of current practice license (for MScN applicants only)
', NULL, 'TEXTFIELD', NULL, '0', '0', 880, NULL, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (246, 0, 3, 'DATE:
', NULL, 'DATE', NULL, '0', '0', 900, 890, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (394, 0, 8, 'TIME OF RETURN 
', NULL, 'TIME', NULL, '0', '0', 120, 110, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (293, 0, 5, 'I wish to ADD the following class(es)
', NULL, 'TABLE', NULL, '0', '0', 100, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (292, 0, 5, '1. Advisors signature (to sign first)
', NULL, 'TEXTFIELD', NULL, '0', '0', 90, NULL, 43, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (329, 0, 6, 'MINOR. 
', NULL, 'TEXTFIELD', NULL, '0', '0', 270, NULL, 64, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (395, 0, 8, 'If You Are Missing Classes List them below and Obtain Instructors Signature: 
', NULL, 'TABLE', NULL, '0', '0', 130, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (399, 0, 8, 'NOTE:
', NULL, 'TITLE', NULL, '0', '0', 170, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (401, 0, 8, '2. Form is to be filled out in triplicate, once copy for Student, one for Dorm Dean and one for Registrars Office.
', NULL, 'TITLE', NULL, '0', '0', 190, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (286, 0, 5, 'DATE', NULL, 'DATE', NULL, '0', '0', 30, 10, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (497, 0, 12, 'Instructors Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 230, 230, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (505, 0, 12, 'DVC-Academic Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 310, 310, 39, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (502, 0, 12, 'Date', NULL, 'TEXTFIELD', NULL, '0', '0', 280, 270, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (503, 0, 12, 'Registrars Signature 
', NULL, 'TEXTFIELD', NULL, '0', '0', 290, 270, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (504, 0, 12, 'Date', NULL, 'TEXTFIELD', NULL, '0', '0', 300, 270, 12, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (501, 0, 12, 'School Deans Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 270, 270, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (157, 0, 3, 'First name
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'firstname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (158, 0, 3, 'Middle name
', NULL, 'TEXTFIELD', NULL, '0', '0', 25, 10, 16, '0', '1', 'L', NULL, 'PART ONE', NULL, 'middlename', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (161, 0, 3, 'Email Address:
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 26, '0', '1', 'L', NULL, 'PART ONE', NULL, 'email', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (163, 0, 3, '1. Marital Status
', 'Single#Married#Others', 'LIST', NULL, '0', '0', 80, 80, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'maritalstatus', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (170, 0, 3, '3. Date of Birth
', NULL, 'DATE', NULL, '0', '0', 150, NULL, 58, '0', '1', 'L', NULL, 'PART ONE', NULL, 'birthdate', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (167, 0, 3, '2. Gender
', 'Male#Female', 'LIST', NULL, '0', '0', 120, 120, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'Sex', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (175, 0, 3, '5. Place of Birth
', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 200, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'birthplace', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (177, 0, 3, '7. Passport/National ID No
', NULL, 'TEXTFIELD', NULL, '0', '0', 220, 230, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'nationalityid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (190, 0, 3, '1. Name of College or University currently attending or last attended
', NULL, 'TEXTFIELD', NULL, '0', '0', 350, NULL, 31, '0', '1', 'L', NULL, 'PART TWO', NULL, 'attendedsecondary', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (285, 0, 5, 'NAME', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 15, '0', '1', NULL, NULL, NULL, NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (284, 0, 5, 'ID NO', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 19, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (302, 0, 5, '9. Registrar
', NULL, 'TEXTFIELD', NULL, '0', '0', 190, NULL, 55, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (296, 0, 5, 'Total credits
', NULL, 'TEXTFIELD', NULL, '0', '0', 130, NULL, 54, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (330, 0, 6, 'Signature of Advisor
', NULL, 'TEXTFIELD', NULL, '0', '0', 280, NULL, 58, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (331, 0, 6, 'Signature of Department Chair', NULL, 'TEXTFIELD', NULL, '0', '0', 290, NULL, 53, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (402, 0, 8, '3. Request is to be made no late than 3 Days before Intended Departure
', NULL, 'TITLE', NULL, '0', '0', 200, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (387, 0, 8, ' DESTINATION :
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 30, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (391, 0, 8, 'DATE OF DEPARTURE 
', NULL, 'DATE', NULL, '0', '0', 90, 90, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (294, 0, 5, 'Total credits
', NULL, 'TEXTFIELD', NULL, '0', '0', 110, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (299, 0, 5, '6. With this change my load credit hours will be
', NULL, 'TEXTFIELD', NULL, '0', '0', 160, NULL, 37, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (298, 0, 5, '5. My present load in credit hours is
', NULL, 'TEXTFIELD', NULL, '0', '0', 150, NULL, 43, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (301, 0, 5, '8. Student Finance clearance (when adding)
', NULL, 'TEXTFIELD', NULL, '0', '0', 180, NULL, 40, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (379, 0, 7, '2. Student Finance 
', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 90, 25, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (380, 0, 7, 'Date
', NULL, 'DATE', NULL, '0', '0', 100, 90, 25, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (381, 0, 7, '3. Registrar 
', NULL, 'TEXTFIELD', NULL, '0', '0', 110, 110, 25, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (297, 0, 5, '4. Reason for change_
', NULL, 'TEXTFIELD', NULL, '0', '0', 140, NULL, 50, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (382, 0, 7, 'Date', NULL, 'TEXTFIELD', NULL, '0', '0', 120, 110, 28, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (313, 0, 6, 'I here petition to graduate in the year 
', NULL, 'DATE', NULL, '0', '0', 110, NULL, 50, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (314, 0, 6, 'My bulletin is 
', NULL, 'TEXTFIELD', NULL, '0', '0', 120, NULL, 61, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (506, 0, 12, 'Date', NULL, 'DATE', NULL, '0', '0', 320, 310, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (323, 0, 6, 'MAJOR OR CONC. 
', NULL, 'TEXTFIELD', NULL, '0', '0', 210, NULL, 59, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (324, 0, 6, 'Signature of Advisor
', NULL, 'TEXTFIELD', NULL, '0', '0', 220, NULL, 58, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (326, 0, 6, 'Signature of Department Chair ', NULL, 'TEXTFIELD', NULL, '0', '0', 240, NULL, 53, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (325, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 230, NULL, 66, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (327, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 250, NULL, 66, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (332, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 300, NULL, 66, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (388, 0, 8, 'MEANS OF TRAVEL :
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 60, 22, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (385, 0, 8, 'ID NO:', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 30, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (389, 0, 8, 'PURPOSE  OF TRAVEL 
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 60, 22, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (390, 0, 8, 'CHECK ONE: 
', 'DAY LEAVE #OVERNIGHT#WEEKEND#OTHER', 'LIST', NULL, '0', '0', 80, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (392, 0, 8, 'TIME OF DEPARTURE:
', NULL, 'TIME', NULL, '0', '0', 100, 90, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (400, 0, 8, '1.Form is for All campus leaves other than field trips and other official off campus leaves.
', NULL, 'TITLE', NULL, '0', '0', 180, NULL, 20, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (397, 0, 8, 'DEAN OF STUDENTS SIGNATURE 
', NULL, 'TEXTFIELD', NULL, '0', '0', 150, NULL, 50, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (396, 0, 8, 'DORMITORY DEANS SIGNATURE 
', NULL, 'TEXTFIELD', NULL, '0', '0', 140, NULL, 51, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (108, 0, 1, 'Date', NULL, 'DATE', NULL, '0', '0', 1080, 1070, 27, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (398, 0, 8, 'REGISTRARS SIGNATURE 
', NULL, 'TEXTFIELD', NULL, '0', '0', 160, NULL, 54, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (507, 0, 12, 'g ) Student returns the completed form to the Registrars Office
', NULL, 'TITLE', NULL, '0', '0', 330, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (303, 0, 6, 'DATE
', NULL, 'DATE', NULL, '0', '0', 10, NULL, 63, '0', '1', NULL, NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (309, 0, 6, 'COURSES YET TO BE COMPLETED AT UNIVERSITY OF EASTERN AFRICA, BARATON
', NULL, 'TITLE', NULL, '0', '0', 70, NULL, 15, '0', '1', NULL, NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (403, 0, 9, 'STUDENT ID NUMBER.', NULL, 'TEXTFIELD', NULL, '0', '0', 10, NULL, 65, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (317, 0, 6, 'MAJOR OR CONC.
', NULL, 'TEXTFIELD', NULL, '0', '0', 150, NULL, 58, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (318, 0, 6, 'Signature of Advisor
', NULL, 'TEXTFIELD', NULL, '0', '0', 160, NULL, 57, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (321, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 190, NULL, 65, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (319, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 170, NULL, 65, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (406, 0, 9, 'YEAR OF GRADUATION
', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 20, 17, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (334, 0, 6, 'I have checked the courses against the students check sheet. If these courses are completed successfully, this will meet all the requirements for this major.', NULL, 'TITLE', NULL, '0', '0', 141, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (335, 0, 6, 'I have checked the courses against the students check sheet. If these courses are completed successfully, this will meet all the requirements for this major', NULL, 'TITLE', NULL, '0', '0', 320, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (193, 0, 3, '3. Degree desired: 
', 'select degreeid,degreename from degrees;', 'SELECT', NULL, '0', '0', 380, NULL, 15, '0', '1', 'L', NULL, 'PART TWO', NULL, 'degreeid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (336, 0, 6, 'I have checked the courses against the students check sheet. If these courses are completed successfully, this will meet all the requirements for this major', NULL, 'TITLE', NULL, '0', '0', 201, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (328, 0, 6, 'Advisor: MINOR 
', NULL, 'TITLE', NULL, '0', '0', 260, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (333, 0, 6, '4. The School Dean

', NULL, 'TITLE', NULL, '0', '0', 310, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (337, 0, 6, 'I have checked the courses against the students check sheet. If these courses are completed successfully, this will meet all the requirements for this major.', NULL, 'TITLE', NULL, '0', '0', 261, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (338, 0, 6, 'I approve this arrangement of the student to cover
the courses as recorded.

', NULL, 'TITLE', NULL, '0', '0', 311, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (339, 0, 6, 'NOTE: ORDER OF NAMES
', NULL, 'TITLE', NULL, '0', '0', 312, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (340, 0, 6, 'The order of names above will be the same order that will be used in all your official documents including the degree certificate(s).', NULL, 'TITLE', NULL, '0', '0', 315, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (345, 0, 6, '5. Registrar
', NULL, 'TITLE', NULL, '0', '0', 380, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (352, 0, 6, 'PARENTS/GUARDIANS CONTACTS:
', NULL, 'TITLE', NULL, '0', '0', 450, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (358, 0, 6, 'GENERAL INFORMATION
', NULL, 'TITLE', NULL, '0', '0', 510, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (359, 0, 6, '2. Make sure that you have been financially cleared one month earlier before the date of graduation.
', NULL, 'TITLE', NULL, '0', '0', 520, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (360, 0, 6, '3. The graduation fee must be paid 6 weeks before graduation.
', NULL, 'TITLE', NULL, '0', '0', 530, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (361, 0, 6, '4. If you plan to graduate in absentia, you must submit a petition in writing to the Registrar
', NULL, 'TITLE', NULL, '0', '0', 540, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (362, 0, 6, '5. PRINT your name exactly as it appears in the application form you submitted for admission to UEAB.
', NULL, 'TITLE', NULL, '0', '0', 550, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (304, 0, 6, 'First Name', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 20, 10, '0', '1', NULL, NULL, 'PART ONE', NULL, 'firstname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (305, 0, 6, 'Middle Name', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 20, 10, '0', '1', NULL, NULL, 'PART ONE', NULL, 'middlename', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (306, 0, 6, 'Last Name', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 20, 10, '0', '1', NULL, NULL, 'PART ONE', NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (308, 0, 6, 'Degree Title:
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, NULL, 61, '0', '1', NULL, NULL, 'PART TWO', NULL, 'degreeid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (363, 0, 6, 'First Name', NULL, 'TEXTFIELD', NULL, '0', '0', 560, 560, 15, '0', '1', NULL, NULL, NULL, NULL, 'firstname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (364, 0, 6, 'Middle Name', NULL, 'TEXTFIELD', NULL, '0', '0', 570, 560, 15, '0', '1', NULL, NULL, NULL, NULL, 'middlename', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (369, 0, 6, 'UEAB ID NUMBER:
', NULL, 'TEXTFIELD', NULL, '0', '0', 620, 600, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (370, 0, 6, 'NOTE: ORDER OF NAMES:
The order of names above will be the same order that will be used in all your official documents including the degree certificate(s).
', NULL, 'TITLE', NULL, '0', '0', 630, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (374, 0, 7, 'Request to sit for Final Examination for my NGs in the following courses in Trimester 
', NULL, 'TABLE', NULL, '0', '0', 40, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (376, 0, 7, 'Confirmed by:
', NULL, 'TITLE', NULL, '0', '0', 60, NULL, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (371, 0, 7, 'Student ID NO
', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (372, 0, 7, 'NAME:
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (373, 0, 7, 'MAJOR:', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 10, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (290, 0, 5, 'YEAR', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 40, 10, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (289, 0, 5, 'SEMESTER
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 10, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (378, 0, 7, 'Date', NULL, 'DATE', NULL, '0', '0', 80, 70, 25, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (377, 0, 7, '1. Head of Department 
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 70, 23, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (347, 0, 6, 'Home Postal Address 
', NULL, 'TEXTFIELD', NULL, '0', '0', 400, NULL, 57, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (341, 0, 6, 'Signature of School Dean
', NULL, 'TEXTFIELD', NULL, '0', '0', 330, 330, 26, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (343, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 350, 330, 26, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (342, 0, 6, 'Signature of Registrar
', NULL, 'TEXTFIELD', NULL, '0', '0', 360, 360, 27, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (344, 0, 6, 'Date', NULL, 'DATE', NULL, '0', '0', 370, 360, 27, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (355, 0, 6, 'Mobile Phone
', NULL, 'TEXTFIELD', NULL, '0', '0', 480, NULL, 61, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (348, 0, 6, 'Phone:
', NULL, 'TEXTFIELD', NULL, '0', '0', 410, 410, 28, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (349, 0, 6, 'Mobile Phone: 
', NULL, 'TEXTFIELD', NULL, '0', '0', 420, 410, 28, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (353, 0, 6, 'Postal Address:
', NULL, 'TEXTFIELD', NULL, '0', '0', 460, NULL, 60, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (351, 0, 6, 'Fax:
', NULL, 'TEXTFIELD', NULL, '0', '0', 440, 430, 31, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (354, 0, 6, 'Phone:
', NULL, 'TEXTFIELD', NULL, '0', '0', 470, NULL, 64, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (357, 0, 6, 'Fax:
', NULL, 'TEXTFIELD', NULL, '0', '0', 500, 490, 30, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (356, 0, 6, 'E-Mail

', NULL, 'TEXTFIELD', NULL, '0', '0', 490, 490, 31, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (367, 0, 6, 'Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 600, 600, 20, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (300, 0, 5, '7. School Deans signature for overload
', NULL, 'TEXTFIELD', NULL, '0', '0', 170, NULL, 42, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (375, 0, 7, 'Students Signature (I certify that the information given above is correct)
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, NULL, 27, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (366, 0, 6, 'PLEASE NOTE: IF ANY CHANGES ARE MADE IN YOUR SENIOR PROGRAM WITHOUT THE
APPROVAL OF THE REGISTRARS OFFICE, THEN YOUR NAME WILL BE DELETED
FROM THE GRADUATION LIST.
', NULL, 'TITLE', NULL, '0', '0', 590, NULL, 19, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (159, 0, 3, 'Present Mailing address  :
', NULL, 'TEXTFIELD', NULL, '0', '0', 30, NULL, 52, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (114, 0, 1, 'Do you have an unpaid school account?
', 'Yes#No', 'LIST', NULL, '0', '0', 1140, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (383, 0, 8, 'NAME 
', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 29, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (386, 0, 8, 'ROOM NUMBER', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 30, 15, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (106, 0, 1, 'Parent or Guardianâs commitment: I agree that the applicant may be a student at the University of Eastern Africa, Baraton. I am
ready to support the university in its effort to ensure that the applicant abides by the rules and principles of the university and
accepts the authority of its administration.
', NULL, 'TITLE', NULL, '0', '0', 1060, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (104, 0, 1, 'Signature of Applicant
', NULL, 'TEXTFIELD', NULL, '0', '0', 1040, 1040, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (310, 0, 6, 'First Trimester
', NULL, 'TABLE', NULL, '0', '0', 80, NULL, 15, '0', '1', NULL, NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (312, 0, 6, 'Third Trimester
', NULL, 'TABLE', NULL, '0', '0', 100, NULL, 15, '0', '1', NULL, NULL, 'PART TWO', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (307, 0, 6, 'UEAB ID No.
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 20, 10, '0', '1', NULL, NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (105, 0, 1, 'Date', NULL, 'DATE', NULL, '0', '0', 1050, 1040, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (249, 0, 1, 'If Yes, please explain
', NULL, 'TEXTFIELD', NULL, '0', '0', 320, 310, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (111, 0, 1, 'I, the above named, agree to be responsible for the payment of the total school fees of the applicant and to make this payment at the
beginning of each semester. I agree to abide by the financial policies of the University of Eastern Africa, Baraton.
', NULL, 'TITLE', NULL, '0', '0', 1110, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (22, 0, 1, 'Other languages spoken
', NULL, 'TEXTFIELD', NULL, '0', '0', 220, 210, 18, '0', '1', 'L', NULL, NULL, NULL, 'otherlanguages', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (24, 0, 1, 'Date of Baptism: Day/Month/Year
', NULL, 'DATE', NULL, '0', '0', 240, 230, 19, '0', '1', 'L', NULL, NULL, NULL, 'churchname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (247, 0, 3, '10. Religious affiliation :
', 'SELECT denominationid,denominationname from denominations;', 'SELECT', NULL, '0', '0', 275, NULL, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'denominationid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (101, 0, 1, '22. Recommendations: Give names and addresses of two individuals who can give character recommendation. Give the enclosed
evaluation/recommendation form to these individuals and ask them to return the forms to you in sealed and rubber-stamped
envelopes. One of the recommendations must be from the PRINCIPAL of the school last attended and another one from your
CHURCH PASTOR or RELIGIOUS LEADER (if you are a church member)
', NULL, 'TABLE', NULL, '0', '0', 1010, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (508, 0, 12, 'NOTE:
The University of Eastern Africa, Baraton policy with respect to Incomplete Work reads, Incomplete Work indicates that some work has not been completed because of illness or emergency and not because of negligence, late work or low performance. An Incomplete Work is not automatically assigned but must be petitioned for in writing by the student prior to the final examination period, and requires the
approval of the persons mentioned above. The petition must designate what work is to be completed and the time limit which shall not be later than by end of the following trimester. If there is need to extend the period of incomplete work, the student must petition to the Academic Standards Committee for an extension by filling the extension form from the registrars office before the expiry of the date when the missing work is suppose to be handed in. An Incomplete Work not removed on time will result in a grade calculated using marks earned from the work already done out of the total marks of the course.
', NULL, 'TITLE', NULL, '0', '0', 340, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (509, 0, 12, 'h ) TO BE FILLED IN TRIPLICATE FOR STUDENT, INSTRUCTOR AND REGISTRAR
', NULL, 'TITLE', NULL, '0', '0', 350, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (103, 0, 1, 'Applicants commitment: I certify that to the best of my knowledge, the above information is complete and true. I promise that is
accepted I will cooperate in following the rules of University of Eastern Africa, Baraton and respect the principles of the institution
as they are set forth in the STUDENT HANDBOOK and any other that is communicated by the university.
', NULL, 'TITLE', NULL, '0', '0', 1030, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (50, 0, 1, 'Have you ever used addictive drugs?
', 'No#Yes', 'LIST', NULL, '0', '0', 500, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'hdrugs', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (72, 0, 1, '19. Degree desired:
', 'B.A#B.Sc#B.B.A#B.T#BEd#BBIT', 'LIST', NULL, '0', '0', 720, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, 'degreeid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (89, 0, 1, 'Mothers name
', NULL, 'TEXTFIELD', NULL, '0', '0', 890, 890, 15, '0', '1', 'L', NULL, 'Family', NULL, 'mname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (287, 0, 5, 'MAJOR:
', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 10, '0', '1', NULL, NULL, NULL, NULL, 'majorid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (288, 0, 5, 'DEGREE', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 40, 10, '0', '1', NULL, NULL, NULL, NULL, 'degreeid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (350, 0, 6, 'E-Mail
', NULL, 'TEXTFIELD', NULL, '0', '0', 430, 430, 30, '0', '1', NULL, NULL, NULL, NULL, 'email', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (365, 0, 6, 'Last Name', NULL, 'TEXTFIELD', NULL, '0', '0', 580, 560, 18, '0', '1', NULL, NULL, NULL, NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (53, 0, 1, 'How did you know about UEAB? 
', NULL, 'TEXTFIELD', NULL, '0', '0', 530, NULL, 51, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (20, 0, 1, '10. Passport/ID No
', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 170, 14, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (107, 0, 1, 'Signature of parent/guardian
', NULL, 'TEXTFIELD', NULL, '0', '0', 1070, 1070, 26, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (112, 0, 1, 'Signature of Parent/Guardian/Sponso
', NULL, 'TEXTFIELD', NULL, '0', '0', 1120, 1120, 24, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (110, 0, 1, 'Name and address of person responsible for payment of school fees
', NULL, 'TEXTFIELD', NULL, '0', '0', 1100, NULL, 37, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (117, 0, 1, ' If Yes, how much?

', NULL, 'TEXTFIELD', NULL, '0', '0', 1170, 1170, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (118, 0, 1, 'Where?', NULL, 'TEXTFIELD', NULL, '0', '0', 1180, 1170, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (113, 0, 1, 'Date
', NULL, 'DATE', NULL, '0', '0', 1130, 1120, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (109, 0, 1, 'Statement of financial responsibility:
', NULL, 'TITLE', NULL, '0', '0', 1090, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (8, 0, 1, 'Permanent Telephone
', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 70, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (7, 0, 1, '3. Permanent mailing address
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 70, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (9, 0, 1, 'Permanent Fax', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 70, 10, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (6, 0, 1, 'Present Fax', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (65, 0, 1, '16. Work experience: If you held a job, give details about employment (use additional sheet if necessary)
', NULL, 'TABLE', NULL, '0', '0', 650, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (84, 0, 1, '21. Family Information:
', NULL, 'TITLE', NULL, '0', '0', 840, NULL, 15, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (96, 0, 1, 'Gurdian''s Telephone', NULL, 'TEXTFIELD', NULL, '0', '0', 960, 950, 22, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (248, 0, 1, '<strong>PART 1:  PERSONAL DETAILS</strong>', NULL, 'TITLE', NULL, '0', '0', 5, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (54, 0, 1, 'Educational Background. List institutions of learning attended at each level including Primary school:
', NULL, 'TABLE', NULL, '0', '0', 540, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (95, 0, 1, 'e-mail of Parent(s) or Guardian(s)
', NULL, 'TEXTFIELD', NULL, '0', '0', 950, 950, 21, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (93, 0, 1, 'Name of legal guardian if not parent(s)
', NULL, 'TEXTFIELD', NULL, '0', '0', 930, NULL, 52, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (100, 0, 1, 'If Yes, give name and address of employer
', NULL, 'TEXTFIELD', NULL, '0', '0', 1000, NULL, 50, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (94, 0, 1, 'Address of Parent(s) or Guardian(s)
', NULL, 'TEXTFIELD', NULL, '0', '0', 940, NULL, 54, '0', '1', 'L', NULL, 'Family', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (10, 0, 1, '4. Married Status', 'Single# Married', 'LIST', NULL, '0', '0', 100, 100, 15, '0', '1', 'L', NULL, NULL, NULL, 'MaritalStatus', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (2, 0, 1, 'First name', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 10, '0', '1', 'L', NULL, NULL, NULL, 'firstname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (320, 0, 6, 'Signature of Department Chair

', NULL, 'TEXTFIELD', NULL, '0', '0', 180, NULL, 52, '0', '1', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (1, 0, 1, '1. Last name (surname)', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 10, '0', '1', 'L', NULL, NULL, NULL, 'lastname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (514, 0, 12, 'DATE', NULL, 'TEXTFIELD', NULL, '0', '0', 400, 390, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (515, 0, 12, 'NOTE: The School dean only signs if the department chairperson is the instructor or He/ She is absent
', NULL, 'TITLE', NULL, '0', '0', 410, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (4, 0, 1, '2. Present mailing address', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 10, '0', '1', 'L', NULL, NULL, NULL, 'homeaddress', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (516, 0, 12, 'DATE STAMP WHEN THE FORM WAS RETURNED
', NULL, 'DATE', NULL, '0', '0', 420, NULL, 56, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (513, 0, 12, 'Dept Chairpersons/(School Deans) Signature
', NULL, 'TEXTFIELD', NULL, '0', '0', 390, 390, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (5, 0, 1, 'Present Telephone', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 40, 10, '0', '1', 'L', NULL, NULL, NULL, 'phonenumber', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (517, 0, 12, 'DATE STAMP WHEN THE GRADE WAS SUBMITTED
', NULL, 'DATE', NULL, '0', '0', 430, NULL, 55, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (518, 0, 13, 'STUDENT ID NO.
', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 18, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (519, 0, 13, 'LAST NAME:
', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 18, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (13, 0, 1, '5. Sex', 'Male# Female', 'LIST', NULL, '0', '0', 130, 130, 15, '0', '1', 'L', NULL, NULL, NULL, 'Sex', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (16, 0, 1, '6. Birth Date: Day/Month/Year e.g 14/02/2013

', NULL, 'DATE', NULL, '0', '0', 160, NULL, 42, '0', '1', 'L', NULL, NULL, NULL, 'birthdate', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (21, 0, 1, '11. What is your first language?
', NULL, 'TEXTFIELD', NULL, '0', '0', 210, 210, 19, '0', '1', 'L', NULL, NULL, NULL, 'firstlanguage', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (19, 0, 1, '9. Country of Residence
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 190, 170, 15, '0', '1', 'L', NULL, NULL, NULL, 'residenceid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (86, 0, 1, 'Nationality
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 860, 850, 15, '0', '1', 'L', NULL, 'Family', NULL, 'fnationalityid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (26, 0, 1, '13. Personal Health Information:
', 'Excellent#Good#Fair#Poor', 'LIST', NULL, '0', '0', 260, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'personalhealth', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (31, 0, 1, 'Do you have any physical handicaps?
', 'No#Yes', 'LIST', NULL, '0', '0', 310, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'handicap', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (35, 0, 1, 'Do you smoke?
', 'No#Yes', 'LIST', NULL, '0', '0', 330, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'smoke', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (57, 0, 1, 'Have you ever attended the University of Eastern Africa, Baraton before?
', 'No#Yes', 'LIST', NULL, '0', '0', 570, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, 'attendedueab', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (79, 0, 1, '20. Where do you plan to live while attending UEAB?	(Note: Any student who does not reside with parents or spouse is expected to live in one of the campus residence halls.) 
', 'Campus Residence Halls#Off Campus#Faculty/Staff Home
', 'LIST', NULL, '0', '0', 790, NULL, 15, '0', '1', 'L', NULL, 'Education', NULL, 'campusresidence', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (85, 0, 1, 'Fathers  Name
', NULL, 'TEXTFIELD', NULL, '0', '0', 850, 850, 15, '0', '1', 'L', NULL, 'Family', NULL, 'fname', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (87, 0, 1, 'Fathers Occupation
', NULL, 'TEXTFIELD', NULL, '0', '0', 870, 870, 25, '0', '1', 'L', NULL, 'Family', NULL, 'foccupation', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (88, 0, 1, 'Religious Affiliation
', NULL, 'TEXTFIELD', NULL, '0', '0', 880, 870, 25, '0', '1', 'L', NULL, 'Family', NULL, 'fdenominationid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (91, 0, 1, 'Mothers Occupation
', NULL, 'TEXTFIELD', NULL, '0', '0', 910, 910, 25, '0', '1', 'L', NULL, 'Family', NULL, 'moccupation', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (92, 0, 1, 'Religious Affiliation
', NULL, 'TEXTFIELD', NULL, '0', '0', 920, 910, 25, '0', '1', 'L', NULL, 'Family', NULL, 'mdenominationid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (521, 0, 13, 'Major
', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 20, '0', '1', 'L', NULL, NULL, NULL, 'majorid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (251, 0, 1, 'Do Use addictive drugs?
', 'No#Yes', 'LIST', NULL, '0', '0', 350, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'drugs', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (250, 0, 1, 'Do you Drink alcohol?
', 'No#Yes', 'LIST', NULL, '0', '0', 340, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, 'drink', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (533, 0, 13, 'Year and Trimester the course was taken
', NULL, 'TABLE', NULL, '0', '0', 160, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (522, 0, 13, 'Minor
', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 40, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (523, 0, 13, 'Year of Graduation
', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 21, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (524, 0, 13, 'My Bulletin
', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 70, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (525, 0, 13, 'Course Code
', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 70, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (526, 0, 13, 'Course Title
', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 70, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (540, 0, 13, 'School Dean 
', NULL, 'TEXTFIELD', NULL, '0', '0', 230, 230, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (541, 0, 13, 'Date', NULL, 'DATE', NULL, '0', '0', 240, 230, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (527, 0, 13, 'Year and Trimester you want to repeat course: Academic Year
', NULL, 'TEXTFIELD', NULL, '0', '0', 100, 100, 21, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (542, 0, 13, 'DVC-Academics 
', NULL, 'TEXTFIELD', NULL, '0', '0', 250, 250, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (528, 0, 13, 'Trimester
', NULL, 'TEXTFIELD', NULL, '0', '0', 110, 100, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (543, 0, 13, 'Date', NULL, 'DATE', NULL, '0', '0', 260, 250, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (529, 0, 13, 'Reason for repeating the course
', NULL, 'TEXTFIELD', NULL, '0', '0', 120, NULL, 61, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (530, 0, 13, 'The grade required in the course for graduation or in order to take a higher course
', NULL, 'TEXTFIELD', NULL, '0', '0', 130, NULL, 37, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (532, 0, 13, 'Number of Times the course has been repeated
', NULL, 'TEXTFIELD', NULL, '0', '0', 150, 140, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (531, 0, 13, 'Number of times the course has been taken
', NULL, 'TEXTFIELD', NULL, '0', '0', 140, 140, 16, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (534, 0, 13, 'Students Signature 
', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 170, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (535, 0, 13, 'Date', NULL, 'DATE', NULL, '0', '0', 180, 170, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (537, 0, 13, 'Date', NULL, 'DATE', NULL, '0', '0', 200, 190, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (536, 0, 13, 'Instructor 
', NULL, 'TEXTFIELD', NULL, '0', '0', 190, 190, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (538, 0, 13, 'Department Chairperson 
', NULL, 'TEXTFIELD', NULL, '0', '0', 210, 210, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (539, 0, 13, 'Date', NULL, 'DATE', NULL, '0', '0', 220, 210, 31, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (47, 0, 1, 'Have you ever drunk alcohol?
', 'No#Yes', 'LIST', NULL, '0', '0', 470, NULL, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (17, 0, 1, '7. Nationality
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 170, 170, 15, '0', '1', 'L', NULL, NULL, NULL, 'nationalityid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (18, 0, 1, '8. Citizenship', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 180, 170, 15, '0', '1', 'L', NULL, NULL, NULL, 'citizenshipid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (90, 0, 1, 'Nationality
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 900, 890, 15, '0', '1', 'L', NULL, 'Family', NULL, 'mnationalityid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (133, 0, 2, '7. Nationality
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 1330, 1330, 15, '0', '1', 'L', NULL, 'PART ONE', NULL, 'nationalityid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (176, 0, 3, '6. Country of Citizenship
', 'SELECT sys_country_id,sys_country_name FROM sys_countrys;', 'SELECT', NULL, '0', '0', 210, 200, 60, '0', '1', 'L', NULL, 'PART ONE', NULL, 'citizenshipid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (71, 0, 1, '18. Course/major field of study for which you are applying
', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 710, NULL, 39, '0', '1', 'L', NULL, 'Education', NULL, 'majorid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (23, 0, 1, '12. Religious Affiliation
', 'SELECT denominationid,denominationname FROM denominations;', 'SELECT', NULL, '0', '0', 230, 230, 18, '0', '1', 'L', NULL, NULL, NULL, 'denominationid', NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (146, 0, 2, '14. When (month) would you like to start your studies?
', NULL, 'TEXTFIELD', NULL, '0', '0', 1460, NULL, 43, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (185, 0, 3, '11. Name and address of Church where you are a member 
', NULL, 'TEXTFIELD', NULL, '0', '0', 300, NULL, 37, '0', '1', 'L', NULL, 'PART ONE', NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (545, 0, 14, 'Department Chairpersons Recommendation

', NULL, 'TITLE', NULL, '0', '0', 10, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (546, 0, 14, 'I recommend that this student be allowed to do challenge examination for the indicated course:

', NULL, 'TITLE', NULL, '0', '0', 20, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (552, 0, 14, 'The basis for recommendation (Attach Evidence)

', NULL, 'TEXTFIELD', NULL, '0', '0', 80, NULL, 52, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (553, 0, 14, 'PLEASE OBTAIN THEN FOLLOWING SIGNATURES TO ENDORSE THE RECOMMENDATION

', NULL, 'TITLE', NULL, '0', '0', 90, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (549, 0, 14, 'COURSE CODE

', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 50, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (556, 0, 14, 'Department Chairperson 

', NULL, 'TEXTFIELD', NULL, '0', '0', 120, 120, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (563, 0, 14, 'Date', NULL, 'DATE', NULL, '0', '0', 190, 180, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (547, 0, 14, 'STUDENTS NAME:

', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 30, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (548, 0, 14, 'STUDENT ID NO.

', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 30, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (554, 0, 14, 'Instructor 

', NULL, 'TEXTFIELD', NULL, '0', '0', 100, 100, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (551, 0, 14, 'CREDITS

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 50, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (555, 0, 14, 'Date', NULL, 'DATE', NULL, '0', '0', 110, 100, 34, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (557, 0, 14, 'Date', NULL, 'DATE', NULL, '0', '0', 130, 120, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (560, 0, 14, 'Students consent to pay examination fee:

', NULL, 'TITLE', NULL, '0', '0', 160, NULL, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (561, 0, 14, 'I agree to pay the examination and recording fees for this class as per the University policy

', NULL, 'TITLE', NULL, '0', '0', 170, NULL, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (558, 0, 14, 'School Dean 

', NULL, 'TEXTFIELD', NULL, '0', '0', 140, 140, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (559, 0, 14, 'Date', NULL, 'DATE', NULL, '0', '0', 150, 140, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (550, 0, 14, 'COURSE TITLE

', 'SELECT majorid,majorname  FROM majors;', 'SELECT', NULL, '0', '0', 60, 50, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (610, 0, 16, 'DATE', NULL, 'DATE', NULL, '0', '0', 210, 190, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (562, 0, 14, 'Students Signature/Phone number 

', NULL, 'TEXTFIELD', NULL, '0', '0', 180, 180, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (598, 0, 16, 'MY SPONSOR(S) HAS/HAVE AGREED. MY SPONSORS LETTER OF AGREEMENT IS ATTACHED TO THIS FORM.

', 'YES#NO', 'LIST', NULL, '0', '0', 90, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (599, 0, 16, 'THE CHAIRPERSON OF MY NEW DEPARTMENT HAS CONSENTED TO THE CHANGE INTO THE PROGRAMME

', NULL, 'TITLE', NULL, '0', '0', 100, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (564, 0, 14, 'Business Office 

', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 200, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (565, 0, 14, 'Date', NULL, 'DATE', NULL, '0', '0', 210, 200, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (566, 0, 14, 'Registrars Office 

', NULL, 'DATE', NULL, '0', '0', 220, 220, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (567, 0, 14, 'Date', NULL, 'DATE', NULL, '0', '0', 230, 220, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (569, 0, 15, 'STUDENT ID NO

', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (568, 0, 15, 'STUDENTS NAME: 

', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (570, 0, 15, 'Major

', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 30, 30, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (576, 0, 15, 'I certify that the information I have given above is correct to the best of my knowledge

', NULL, 'TITLE', NULL, '0', '0', 90, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (579, 0, 15, 'INSTRUCTIONS:

', NULL, 'TITLE', NULL, '0', '0', 120, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (580, 0, 15, 'A) The student should attach a consent letter from the sponsor(s). No action will be taken if consent letter from the sponsor(s) is not attached.

', NULL, 'TITLE', NULL, '0', '0', 130, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (581, 0, 15, 'B) Fill the form in triplicate.

', NULL, 'TITLE', NULL, '0', '0', 140, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (600, 0, 16, 'SIGNATURE

', NULL, 'TEXTFIELD', NULL, '0', '0', 110, 110, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (585, 0, 15, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 180, 170, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (586, 0, 15, 'Date', NULL, 'DATE', NULL, '0', '0', 190, 170, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (588, 0, 15, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 210, 200, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (589, 0, 15, 'Date', NULL, 'DATE', NULL, '0', '0', 220, 200, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (602, 0, 16, 'DECLARATION OF THE CHAIRPERSON OF THE DEPARTMENT OFFERING THE NEW PROGRAMME REQUESTED

', NULL, 'TITLE', NULL, '0', '0', 130, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (603, 0, 16, 'I HAVE APPROVED THE CHANGE OF PROGRAMME AS REQUESTED IN THE FORM

', NULL, 'TITLE', NULL, '0', '0', 140, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (571, 0, 15, 'Date', NULL, 'DATE', NULL, '0', '0', 40, 30, 32, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (611, 0, 16, 'CHAIRPERSON (Current Department)

', NULL, 'TITLE', NULL, '0', '0', 220, NULL, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (572, 0, 15, 'Transfer from:

', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 50, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (573, 0, 15, 'To', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 50, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (574, 0, 15, 'Date of Admission:

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, NULL, 70, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (575, 0, 15, 'Reason for Transfer

', NULL, 'TEXTFIELD', NULL, '0', '0', 80, NULL, 70, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (577, 0, 15, 'Students Signature

', NULL, 'TEXTFIELD', NULL, '0', '0', 100, 100, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (578, 0, 15, 'Date', NULL, 'DATE', NULL, '0', '0', 110, 100, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (582, 0, 15, 'Department Chairpersons Signature:

', NULL, 'TEXTFIELD', NULL, '0', '0', 150, 150, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (607, 0, 16, 'DEAN OF SCHOOL (New School)

', NULL, 'TITLE', NULL, '0', '0', 180, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (583, 0, 15, 'Date', NULL, 'DATE', NULL, '0', '0', 160, 150, 22, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (587, 0, 15, 'Registrars Name

', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 200, 26, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (584, 0, 15, 'School Dean Name

', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 170, 24, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (612, 0, 16, 'NAME

', NULL, 'TEXTFIELD', NULL, '0', '0', 230, 230, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (615, 0, 16, 'DEAN OF SCHOOL (Current School)

', NULL, 'TITLE', NULL, '0', '0', 260, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (616, 0, 16, 'NAME

', NULL, 'TEXTFIELD', NULL, '0', '0', 270, 270, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (590, 0, 16, 'LAST NAME:

', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (591, 0, 16, 'FIRST NAME', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (601, 0, 16, 'DATE', NULL, 'DATE', NULL, '0', '0', 120, 110, 35, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (594, 0, 16, 'Year of Graduation

', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 30, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (592, 0, 16, 'Student Id Number

', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 30, 16, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (593, 0, 16, 'Date of Admission

', NULL, 'DATE', NULL, '0', '0', 40, 30, 16, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (608, 0, 16, 'NAME

', NULL, 'TEXTFIELD', NULL, '0', '0', 190, 190, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (605, 0, 16, 'SIGNATURE

', NULL, 'TEXTFIELD', NULL, '0', '0', 160, 150, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (595, 0, 16, 'I WOULD LIKE TO CHANGE MY PROGRAMME FROM

', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 60, 55, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (613, 0, 16, 'SIGNATURE', NULL, 'TEXTFIELD', NULL, '0', '0', 240, 230, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (606, 0, 16, 'DATE

', NULL, 'DATE', NULL, '0', '0', 170, 150, 18, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (596, 0, 16, 'TO

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, NULL, 79, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (604, 0, 16, 'NAME OF CHAIRPERSON

', NULL, 'TEXTFIELD', NULL, '0', '0', 150, 150, 19, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (597, 0, 16, 'REASON', NULL, 'TEXTFIELD', NULL, '0', '0', 80, NULL, 76, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (614, 0, 16, 'DATE', NULL, 'DATE', NULL, '0', '0', 250, 230, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (628, 0, 17, 'UNIVERSITY OF EASTERN AFRICA, BARATON

', NULL, 'TITLE', NULL, '0', '0', 100, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (617, 0, 16, 'SIGNATURE', NULL, 'TEXTFIELD', NULL, '0', '0', 280, 270, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (624, 0, 17, 'MINOR:

', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 60, 50, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (609, 0, 16, 'SIGNATURE

', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 190, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (618, 0, 16, 'DATE', NULL, 'DATE', NULL, '0', '0', 290, 270, 20, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (619, 0, 17, 'Date:

', NULL, 'DATE', NULL, '0', '0', 10, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (620, 0, 17, 'LAST NAME:

', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 20, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (621, 0, 17, 'FIRST NAME:

', NULL, 'TEXTFIELD', NULL, '0', '0', 30, 20, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (622, 0, 17, 'ID NO.

', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 20, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (623, 0, 17, 'MAJOR(S)

', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 50, 50, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (626, 0, 17, 'TO: THE DEAN

', NULL, 'TITLE', NULL, '0', '0', 80, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (627, 0, 17, 'SCHOOL OF

', NULL, 'TEXTFIELD', NULL, '0', '0', 90, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (629, 0, 17, 'P.O BOX 2500

', NULL, 'TITLE', NULL, '0', '0', 110, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (630, 0, 17, 'ELDORET

', NULL, 'TITLE', NULL, '0', '0', 120, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (631, 0, 17, 'FROM: REGISTRAR

', NULL, 'TITLE', NULL, '0', '0', 130, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (632, 0, 17, 'Dear Sir/Madam

', NULL, 'TITLE', NULL, '0', '0', 140, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (633, 0, 17, 'RE: TRANSFER OF CREDITS

', NULL, 'TITLE', NULL, '0', '0', 150, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (634, 0, 17, 'PLEASE FIND ATTACHED A COPY OF THE ACADEMIC TRANSCRIPT FROM

', NULL, 'TEXTFIELD', NULL, '0', '0', 160, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (635, 0, 17, '(UNIVERSITY/COLLEGE) TOGETHER WITH A COPY OF THE COURSE DESCRIPTION(S) FROM THE SAME INSTITUTION, FOR YOUR USE IN EVALUATING THE ENCLOSED ACADEMIC TRANSCRIPT.

', NULL, 'TITLE', NULL, '0', '0', 170, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (636, 0, 17, 'ACTION TAKEN BY THE DEAN OF THE SCHOOL

', NULL, 'TITLE', NULL, '0', '0', 180, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (637, 0, 17, 'TO:

REGISTRAR

UNIVERSITY OF EASTERN AFRICA, BARATON



', NULL, 'TITLE', NULL, '0', '0', 190, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (638, 0, 17, 'P.O BOX 2500

ELDORET', NULL, 'TITLE', NULL, '0', '0', 200, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (639, 0, 17, 'FROM: DEAN, SCHOOL OF

', NULL, 'TEXTFIELD', NULL, '0', '0', 210, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (640, 0, 17, 'UNIVERSITY OF EASTERN AFRICA, BARATON

', NULL, 'DATE', NULL, '0', '0', 220, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (641, 0, 17, 'P.O BOX 2500 ELDORET

', NULL, 'TITLE', NULL, '0', '0', 230, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (642, 0, 17, 'Name of Dean

', NULL, 'TEXTFIELD', NULL, '0', '0', 240, 240, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (643, 0, 17, 'ID No.:

', NULL, 'TEXTFIELD', NULL, '0', '0', 250, 240, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (644, 0, 17, 'And I am pleased to state that the credits on the UEAB transfer form from

', NULL, 'TEXTFIELD', NULL, '0', '0', 260, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (645, 0, 17, 'University/college are transferable to University of Eastern Africa, Baraton.

', NULL, 'TITLE', NULL, '0', '0', 270, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (646, 0, 17, 'UEAB TRANSFER CREDIT EVALUATION

(OFFICE OF THE REGISTRAR)

', NULL, 'TABLE', NULL, '0', '0', 280, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (625, 0, 17, 'YEAR OF GRADUATION

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (647, 0, 18, 'COURSE FOR WHICH THE DEFFERED GRADE WAS GIVEN

', NULL, 'TITLE', NULL, '0', '0', 10, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (648, 0, 18, 'Course Code

', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 20, 20, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (649, 0, 18, 'Course Title

', 'SELECT majorname FROM majors;', 'SELECT', NULL, '0', '0', 30, 20, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (650, 0, 18, 'Credits

', NULL, 'TEXTFIELD', NULL, '0', '0', 40, 40, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (651, 0, 18, 'Academic Year

', NULL, 'TEXTFIELD', NULL, '0', '0', 50, 40, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (652, 0, 18, 'Trimester', NULL, 'TEXTFIELD', NULL, '0', '0', 60, 40, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (653, 0, 18, 'TEACHERS NAME

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 70, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (654, 0, 18, 'SIGNATURE', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 70, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (658, 0, 18, 'STUDENTS  LIST

', NULL, 'TABLE', NULL, '0', '0', 120, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (687, 0, 20, 'Academic Year

', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 50, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (662, 0, 18, 'NOTE: THE UNIVERSITY OF EASTERN AFRICA, BARATON POLICY WITH RESPECT TO DIFFERED GRADES READS;

COURSES FOR WHICH A DG IS USED NORMALLY RUN OVER TWO OR THREE TRIMESTERS, ANY EXTENSION BEYOND

THIS NEEDS THE APPROVAL OF THE ACADEMIC STANDARDS COMMITTEE.

', NULL, 'TITLE', NULL, '0', '0', 160, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (672, 0, 19, 'Confirmed by:

', NULL, 'TITLE', NULL, '0', '0', 80, 80, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (655, 0, 18, 'DATE', NULL, 'DATE', NULL, '0', '0', 90, 70, 24, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (656, 0, 18, 'REASON FOR DEFFERING THE GRADE

', NULL, 'TEXTFIELD', NULL, '0', '0', 100, NULL, 75, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (657, 0, 18, 'TRIMESTER IN WHICH THE GRADE IS EXPECTED TO BE TURNED IN

', NULL, 'TEXTFIELD', NULL, '0', '0', 110, NULL, 60, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (674, 0, 19, 'Date', NULL, 'DATE', NULL, '0', '0', 100, 90, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (676, 0, 19, 'Date

', NULL, 'DATE', NULL, '0', '0', 120, 110, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (661, 0, 18, 'Note: The Deans signs only if the Department Chairperson is the instructor or he/she is absent

', NULL, 'TITLE', NULL, '0', '0', 150, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (659, 0, 18, 'Deans/ Department Chairpersons Signature

', NULL, 'TEXTFIELD', NULL, '0', '0', 130, 130, 40, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (660, 0, 18, 'Date', NULL, 'DATE', NULL, '0', '0', 140, 130, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (663, 0, 18, 'REGISTRARS SIGNATURE

', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 170, 50, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (664, 0, 18, 'DATE', NULL, 'DATE', NULL, '0', '0', 180, 170, 29, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (665, 0, 19, 'Student ID NO

', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (666, 0, 19, 'NAME:

', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (668, 0, 19, 'Request to sit for Final Examination for my NGs in the following courses in Trimester

', NULL, 'TEXTFIELD', NULL, '0', '0', 40, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (669, 0, 19, 'COURSES

', NULL, 'TABLE', NULL, '0', '0', 50, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (671, 0, 19, '(I certify that the information given above is correct)

', NULL, 'TITLE', NULL, '0', '0', 70, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (689, 0, 20, 'C) Reason for Requesting the Remark.

', NULL, 'TITLE', NULL, '0', '0', 110, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (667, 0, 19, 'MAJOR:

', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 30, 10, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (673, 0, 19, '1. Head of Department 

', NULL, 'TEXTFIELD', NULL, '0', '0', 90, 90, 27, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (675, 0, 19, '2. Student Finance 

', NULL, 'TEXTFIELD', NULL, '0', '0', 110, 110, 29, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (692, 0, 20, 'Date', NULL, 'DATE', NULL, '0', '0', 140, 130, 28, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (678, 0, 19, 'Date', NULL, 'DATE', NULL, '0', '0', 140, 130, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (693, 0, 20, 'D) Acknowledged by the following (to be signed in the order the listing appears)

', NULL, 'TITLE', NULL, '0', '0', 150, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (677, 0, 19, '3. Registrar 

', NULL, 'TEXTFIELD', NULL, '0', '0', 130, 130, 33, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (680, 0, 20, 'STUDENT ID NO.

', NULL, 'TEXTFIELD', NULL, '0', '0', 20, 10, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (682, 0, 20, 'B) Course for which the Remark is petitioned

', NULL, 'TITLE', NULL, '0', '0', 40, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (683, 0, 20, 'Course Title

', 'SELECT majorid,majorname FROM majors;', 'SELECT', NULL, '0', '0', 50, 50, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (685, 0, 20, 'Credits

', NULL, 'TEXTFIELD', NULL, '0', '0', 70, 50, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (686, 0, 20, 'Trimester

', NULL, 'TEXTFIELD', NULL, '0', '0', 80, 50, 15, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (694, 0, 20, 'INSTRUCTOR 

', NULL, 'TITLE', NULL, '0', '0', 160, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (697, 0, 20, 'DEPT. CHAIRPERSON 

', NULL, 'TITLE', NULL, '0', '0', 190, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (701, 0, 20, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 230, 230, 38, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (699, 0, 20, 'Date', NULL, 'DATE', NULL, '0', '0', 210, 200, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (700, 0, 20, 'SCHOOL DEAN 

', NULL, 'TITLE', NULL, '0', '0', 220, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (702, 0, 20, 'Date', NULL, 'DATE', NULL, '0', '0', 240, 230, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (703, 0, 20, 'DVC-ACADEMICS 

', NULL, 'TITLE', NULL, '0', '0', 250, 230, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (705, 0, 20, 'Date', NULL, 'DATE', NULL, '0', '0', 270, 260, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (670, 0, 19, 'Students Signature

', NULL, 'TEXTFIELD', NULL, '0', '0', 60, NULL, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (679, 0, 20, 'A) STUDENTS NAME

', NULL, 'TEXTFIELD', NULL, '0', '0', 10, 10, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (681, 0, 20, 'ADDRESS

', NULL, 'TEXTFIELD', NULL, '0', '0', 30, NULL, 66, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (691, 0, 20, 'Students Signature

', NULL, 'TEXTFIELD', NULL, '0', '0', 130, 130, 30, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (688, 0, 20, 'INSTRUCTORS NAME

', NULL, 'TEXTFIELD', NULL, '0', '0', 100, NULL, 60, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (690, 0, 20, 'Reason', NULL, 'TEXTFIELD', NULL, '0', '0', 120, NULL, 67, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (696, 0, 20, 'Date', NULL, 'DATE', NULL, '0', '0', 180, 170, 25, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (695, 0, 20, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 170, 170, 38, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (698, 0, 20, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 200, 200, 38, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);
INSERT INTO fields (field_id, org_id, form_id, question, field_lookup, field_type, field_class, field_bold, field_italics, field_order, share_line, field_size, manditory, show, label_position, details, tab, label_positon, field_name, field_fnct) VALUES (704, 0, 20, 'Signature', NULL, 'TEXTFIELD', NULL, '0', '0', 260, 260, 38, '0', '1', 'L', NULL, NULL, NULL, NULL, NULL);



SELECT pg_catalog.setval('sub_fields_sub_field_id_seq', 425, true);


INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (1, 0, 293, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Abbr
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (2, 0, 293, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (3, 0, 293, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Credit');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (4, 0, 293, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Audits
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (5, 0, 293, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title 
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (6, 0, 293, 6, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Instructors  Signature
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (7, 0, 295, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Abbr
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (8, 0, 295, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Section
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (9, 0, 295, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Credits
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (10, 0, 295, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Audits
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (11, 0, 295, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title 
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (12, 0, 295, 6, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Instructors  Signature
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (13, 0, 310, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (14, 0, 310, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'No
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (15, 0, 310, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (16, 0, 310, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Sem. Crs
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (17, 0, 311, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (18, 0, 311, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'No');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (19, 0, 311, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (20, 0, 311, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Sem. Crs
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (21, 0, 374, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Code
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (22, 0, 374, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (23, 0, 374, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Credits
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (24, 0, 374, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Trimester Registered
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (25, 0, 374, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Exam Date
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (26, 0, 374, 6, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Lecturer
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (27, 0, 374, 16, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Signature
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (28, 0, 374, 26, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Date');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (29, 0, 395, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'CLASS');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (30, 0, 395, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'SIGNATURE
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (31, 0, 312, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (32, 0, 312, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'No
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (33, 0, 312, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (34, 0, 312, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Sem. Crs
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (35, 0, 54, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Name of School
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (36, 0, 54, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Dates of Attendance
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (37, 0, 65, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Employer
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (38, 0, 65, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Position held/type
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (39, 0, 65, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Dates of employment
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (40, 0, 101, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Name
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (41, 0, 101, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Address of Referee');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (42, 0, 141, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Name of School
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (43, 0, 141, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Address');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (44, 0, 141, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Certificate
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (45, 0, 141, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Start Date');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (46, 0, 141, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'End Date');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (47, 0, 148, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Name of Referee');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (48, 0, 148, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Address');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (49, 0, 216, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Name of Referee
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (50, 0, 216, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Address');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (51, 0, 221, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Institution
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (53, 0, 221, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'From: Month/Year
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (54, 0, 221, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'To: Month/Year
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (55, 0, 221, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Degree Classification
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (52, 0, 221, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Country
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (56, 0, 227, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'From
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (57, 0, 227, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'To');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (58, 0, 227, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Employer
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (59, 0, 227, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Position/ Experience
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (403, 0, 533, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Attempt eg 1,2..');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (404, 0, 533, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Trimester
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (405, 0, 533, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Year
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (406, 0, 533, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Grade
');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (408, 0, 646, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'GRADE

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (409, 0, 646, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'CR.

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (411, 0, 646, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'CR');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (412, 0, 646, 6, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'APPROVED

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (413, 0, 646, 7, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'HOD SIGN');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (416, 0, 658, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'FINAL GRADE

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (417, 0, 669, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Code

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (418, 0, 669, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Course Title

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (419, 0, 669, 3, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Credits

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (407, 0, 646, 1, NULL, 'SELECT', 'SELECT majorid, majorname FROM majors;', 5, 1, '0', '0', '(UNIVERSITY/COLLEGE)

COURSE CODE AND TITLE

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (410, 0, 646, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', '(UEAB EQUIVALENT)

COURSE CODE AND TITLE 

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (420, 0, 669, 4, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Trimester Registered

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (414, 0, 658, 1, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'STUDENTS NAME

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (415, 0, 658, 2, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'ID NO.

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (421, 0, 669, 5, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Trimester Registered

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (422, 0, 669, 6, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Exam Date

');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (423, 0, 669, 7, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Lecturer');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (424, 0, 669, 8, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Signature');
INSERT INTO sub_fields (sub_field_id, org_id, field_id, sub_field_order, sub_title_share, sub_field_type, sub_field_lookup, sub_field_size, sub_col_spans, manditory, show, question) VALUES (425, 0, 669, 9, NULL, 'TEXTFIELD', NULL, 5, 1, '0', '0', 'Date');

