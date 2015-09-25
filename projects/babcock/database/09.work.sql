SELECT 'UPDATE qstudents SET qresidenceid = ' || aa.qresidenceid || ' WHERE qstudentid = ' || qstudents.qstudentid || ''';'
FROM qstudents INNER JOIN qresidences ON qstudents.qresidenceid = qresidences.qresidenceid
LEFT JOIN 
(SELECT * FROM qresidences WHERE residenceid = 'OC') as aa
ON qstudents.quarterid = aa.quarterid
WHERE (qresidences.residenceid = 'NA')

UPDATE students SET residenceid = null WHERE residenceid = 'NA';

DELETE FROM qresidences WHERE residenceid = 'NA';
DELETE FROM residences WHERE residenceid = 'NA';

update entitys set entity_password = md5('baraza') where entity_type_id <> 20;

---------------------- importing admisions
select max(entity_id) from entitys;
select max(studentdegreeid) from studentdegrees;
select max(studentmajorid) from studentmajors;

 
SELECT pg_catalog.setval('entitys_entity_id_seq', 42442, true);
SELECT pg_catalog.setval('studentdegrees_studentdegreeid_seq', 62019, true);
SELECT pg_catalog.setval('studentmajors_studentmajorid_seq', 374699, true);

UPDATE registrations  SET account_number = 'SABDAB0007' WHERE registrationid = 43511;
UPDATE registrations  SET account_number = 'SADAAB0003' WHERE registrationid = 38241;

UPDATE registrations  SET e_tranzact_no = '7079890205240005' WHERE registrationid = 43511;
UPDATE registrations  SET e_tranzact_no = '7079890197680001' WHERE registrationid = 38241;

UPDATE registrations SET is_newstudent = false;

SELECT admit_applicant('38241', '0', '0');
SELECT admit_applicant('40815', '0', '0');

UPDATE registrations SET is_newstudent = true WHERE registrationid = 46366;

UPDATE students SET newstudent = false;
UPDATE students SET newstudent = true
FROM registrations WHERE (registrations.existingid = students.studentid)
AND (registrations.is_newstudent = true);

SELECT registrations.registrationid, registrations.surname, registrations.firstname, 
	registrations.othernames, registrations.email, registrations.sex, registrations.account_number, 
	registrations.e_tranzact_no, registrations.af_amount, registrations.af_card_type, 
	registrations.existingid, students.firstpasswd
FROM registrations INNER JOIN students ON registrations.existingid = students.studentid
WHERE students.newstudent = true
ORDER BY registrations.registrationid;


DROP TABLE tb1;
DROP TABLE tb2;
DROP TABLE tb3;

SELECT * INTO tb1
FROM students WHERE newstudent = true;
SELECT * INTO tb2
FROM studentdegrees WHERE studentid IN
(SELECT studentid FROM students WHERE newstudent = true);
SELECT * INTO tb3
FROM studentmajors WHERE studentdegreeid IN
(SELECT studentdegrees.studentdegreeid 
FROM students INNER JOIN studentdegrees ON students.studentid = studentdegrees.studentid
WHERE students.newstudent = true);

pg_dump -h 62.24.122.19 -t tb1 --inserts babcock > tb1.sql
pg_dump -h 62.24.122.19 -t tb2 --inserts babcock > tb2.sql
pg_dump -h 62.24.122.19 -t tb3 --inserts babcock > tb3.sql


INSERT INTO students
SELECT tb1.* 
FROM tb1 LEFT JOIN students ON tb1.studentid = students.studentid
WHERE students.studentid is null;

INSERT INTO studentdegrees
SELECT tb2.* 
FROM tb2 LEFT JOIN studentdegrees ON tb2.studentid = studentdegrees.studentid
WHERE studentdegrees.studentid is null;

INSERT INTO studentmajors
SELECT tb3.* 
FROM tb3 LEFT JOIN studentmajors ON tb3.studentdegreeid = studentmajors.studentdegreeid
WHERE studentmajors.studentdegreeid is null;


UPDATE students SET firstpasswd = tb1.firstpasswd
FROM tb1 WHERE students.studentid = tb1.studentid;
UPDATE entitys SET first_password = tb1.firstpasswd
FROM tb1 WHERE entitys.user_name = tb1.studentid;

UPDATE students SET newstudent = true WHERE studentid ilike 'NV/%';


 
--- Repeat course adjustment for repeat
SELECT studentdegreeid, courseid, coursecount, updaterepeats(studentdegreeid, courseid)
FROM gradecountview
WHERE coursecount > 1;

SELECT new_students.degree_code
FROM new_students LEFT JOIN majors ON trim(upper(new_students.degree_code)) = trim(upper(majors.majorid))
WHERE majors.majorid is null
GROUP BY new_students.degree_code
ORDER BY new_students.degree_code;


SELECT org_id FROM studentdegrees WHERE studentdegreeid IN
(SELECT studentdegreeid FROM studentmajors WHERE majorid = 'ANAT');

SELECT org_id FROM students WHERE studentid IN
(SELECT studentdegrees.studentid 
FROM studentdegrees INNER JOIN studentmajors ON studentdegrees.studentdegreeid = studentmajors.studentdegreeid
WHERE studentmajors.majorid = 'ANAT');

---------------- Update the date

UPDATE entitys SET org_id = 0 WHERE user_name IN
(SELECT studentdegrees.studentid 
FROM studentdegrees INNER JOIN studentmajors ON studentdegrees.studentdegreeid = studentmajors.studentdegreeid
WHERE studentmajors.majorid = 'BIOC');

UPDATE students SET org_id = 0 WHERE studentid IN
(SELECT studentdegrees.studentid 
FROM studentdegrees INNER JOIN studentmajors ON studentdegrees.studentdegreeid = studentmajors.studentdegreeid
WHERE studentmajors.majorid = 'BIOC');

UPDATE studentdegrees SET org_id = 0 WHERE studentdegreeid IN
(SELECT studentdegreeid FROM studentmajors WHERE majorid = 'BIOC');

UPDATE studentmajors SET org_id = 0 WHERE majorid = 'BIOC';


------------ get change in fees amount
SELECT vwqstudentcharges.qstudentid, vwqstudentcharges.studentid, vwqstudentcharges.accountnumber, 
	vwqstudentcharges.studentname, vwqstudentcharges.majorid, vwqstudentcharges.majorname, vwqstudentcharges.studylevel, 
	vwqstudentcharges.mealtype, vwqstudentcharges.residenceid, vwqstudentcharges.residencename, vwqstudentcharges.fees,
	qposting_logs.posted_amount, vwqstudentcharges.fees - qposting_logs.posted_amount
FROM vwqstudentcharges INNER JOIN qposting_logs ON vwqstudentcharges.qstudentid = qposting_logs.qstudentid
WHERE (vwqstudentcharges.quarterid = '2013/2014.1') AND (vwqstudentcharges.finaceapproval = true) AND (vwqstudentcharges.picked = true)
	AND (vwqstudentcharges.fees <> qposting_logs.posted_amount)
ORDER BY vwqstudentcharges.residencename;


UPDATE registrations  SET af_amount = '150000.00', af_success = '0', af_payment_code = '' WHERE registrationid = 43511;



---------------- Matriculation

ALTER TABLE studentdegrees ALTER COLUMN studentid DROP NOT NULL;

SELECT deldupstudent(studentid, null, '14') FROM students WHERE studentid like 'NV/%' ORDER BY studentid;

ALTER TABLE studentdegrees ALTER COLUMN studentid SET NOT NULL;


--------------- Adding a new student

UPDATE registrations SET is_newstudent = true,
	account_number = adm_import1.bussary_code, e_tranzact_no = adm_import1.card_number, 
	first_password = adm_import1.first_password, babcock_email = adm_import1.email_address
FROM adm_import1 WHERE registrations.registrationid = adm_import1.app_id;

SELECT app_students.majorid
FROM app_students LEFT JOIN majors ON app_students.majorid = majors.majorid
WHERE majors.majorid is null
ORDER BY app_students.majorid;

UPDATE app_students SET studentid = 'NR/' || lpad(student_number::varchar, 4, '0') WHERE studentid is null;
UPDATE app_students SET guardianname = trim(substr(guardianname, 1, 50)) WHERE length(guardianname) > 50;


INSERT INTO students (studentid, denominationid, 
	surname, firstname, othernames, sex, nationality, maritalstatus, 
	birthdate, address, zipcode, town, countrycodeid, stateid, telno, 
	mobile, bloodgroup, email, guardianname, gaddress, gzipcode, 
	gtown, gcountrycodeid, gtelno, gemail,
	accountnumber, etranzact_card_no, firstpasswd,
	org_id, departmentid, newstudent)
	
SELECT a.studentid,  a.denominationid, 
	a.surname, a.firstname, a.othernames, a.sex, a.nationality, a.maritalstatus, 
	a.birthdate, a.address, a.zipcode, a.town, a.countrycodeid, a.stateid, a.telno, 
	a.mobile, a.bloodgroup, a.email, a.guardianname, a.gaddress, a.gzipcode, 
	a.gtown, a.gcountrycodeid, a.gtelno, a.gemail,
	a.account_number, a.e_tranzact_no, a.first_password,
	b.org_id, b.departmentid, true
FROM app_students as a INNER JOIN majors as b ON a.majorid = b.majorid
WHERE a.is_picked = false;
       

INSERT INTO studentdegrees (degreeid, studentid, sublevelid, bulletingid, org_id)
SELECT 'B.A', studentid, 'UNDM', 3, majors.org_id
FROM app_students INNER JOIN majors ON app_students.majorid = majors.majorid
WHERE app_students.is_picked = false;


INSERT INTO studentmajors (studentdegreeid, majorid, org_id)
SELECT studentdegrees.studentdegreeid, app_students.majorid, majors.org_id
FROM app_students INNER JOIN studentdegrees ON studentdegrees.studentid = app_students.studentid
	INNER JOIN majors ON app_students.majorid = majors.majorid
WHERE app_students.is_picked = false;


UPDATE app_students SET is_picked = true;
 

--- Update the maric numbers
UPDATE app_students SET e_tranzact_no = '' WHERE app_student_id = ;
UPDATE app_students SET account_number = '' WHERE app_student_id = ;


UPDATE students SET etranzact_card_no = app_students.e_tranzact_no
FROM app_students WHERE students.studentid = app_students.studentid;

UPDATE students SET accountnumber = app_students.account_number
FROM app_students WHERE students.studentid = app_students.studentid;

----- Ecceptance fees reconsilation
UPDATE registrations SET af_date = pin_acc1.PAYMENT_DATE::timestamp, 
	af_amount pin_acc1.AMOUNT_PAID,
	af_success = '0',
	af_payment_code = pin_acc1.RECEIPT_NO,
	af_trans_no	= pin_acc1.CONFIRMATION_ORDER,
	af_card_type = 'eTrazact'
FROM pin_acc1 
WHERE (registrations.af_success is null) AND (registrations.registrationid = pin_acc1.MATRIC_TELLER);


