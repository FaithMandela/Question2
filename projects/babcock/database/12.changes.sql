


ALTER TABLE studentpayments ADD first_attempt timestamp;
ALTER TABLE studentpayments ADD mechant_code varchar(16);

UPDATE studentpayments SET approved = true, amount = 400000.00 WHERE narrative = '178662;Pay;2016/2017.1M;SAMOIJ0001';
UPDATE studentpayments SET approved = true, amount = 691153.00 WHERE narrative = '59128Fees;2016/2017.1;SIHAAN0001';
UPDATE studentpayments SET approved = true, amount = 2640700.00 WHERE narrative = '59501Fees;2016/2017.1M;SOKHIN0001';
UPDATE studentpayments SET approved = true, amount = 870180.00 WHERE narrative = '60007Fees;2016/2017.1;SUKAMA0004';
UPDATE studentpayments SET approved = true, amount = 898408.00 WHERE narrative = '60501Fees;2016/2017.1;SIKUOL0004';
UPDATE studentpayments SET approved = true, amount = 485618.00 WHERE narrative = '61224Fees;2016/2017.1;SBASPR0001';
UPDATE studentpayments SET approved = true, amount = 524070.00 WHERE narrative = '61263Fees;2016/2017.1;SIFIDE0001';
UPDATE studentpayments SET approved = true, amount = 551003.00 WHERE narrative = '61444Fees;2016/2017.1;SADEOG0012';
UPDATE studentpayments SET approved = true, amount = 1028240.00 WHERE narrative = '61455Fees;2016/2017.1;SALOCH0005';
UPDATE studentpayments SET approved = true, amount = 1596000.00 WHERE narrative = '61551Fees;2016/2017.1M;SBABOY0002';


ALTER TABLE registrations ADD admission_level	integer default 100 not null;

DROP VIEW registrymarkview;
DROP VIEW registrationview;
CREATE VIEW registrationview AS
	SELECT registrations.registrationid, registrations.email, registrations.phonenumber,
		registrations.submitapplication, 
		registrations.isaccepted, registrations.isreported, registrations.isdeferred, registrations.isrejected,
		registrations.applicationdate, ca.countryname as nationality,
		registrations.sex, registrations.surname, registrations.firstname, registrations.othernames, 
		(registrations.surname || ', ' ||  registrations.firstname || ' ' || registrations.othernames) as fullname,
		registrations.existingid, registrations.firstchoiceid, registrations.secondchoiceid, registrations.offcampus,
		registrations.org_id, registrations.entry_form_id, registrations.admission_level,
		
		(CASE WHEN registrations.org_id = 0 THEN 'UNDERGRADUATE' ELSE 'POSTGRADUATE' END) as selection_name,
		(CASE WHEN registrations.af_success = '0' THEN 'The payment is completed' ELSE 'Payment has not been done' END) as paymentStatus,
		
		registrations.acceptance_fees, registrations.af_date, registrations.af_amount, registrations.af_success,
		registrations.af_payment_code, registrations.af_trans_no, registrations.af_card_type, 
		registrations.af_picked, registrations.af_picked_date, registrations.account_number,
		
		applications.applicationid, applications.exam_date_id, applications.quarterid,
		
		majorview.majorid, majorview.majorname, majorview.minlevel, majorview.maxlevel, majorview.major_title,
		majorview.departmentid, majorview.departmentname, majorview.schoolid, majorview.schoolname,
		
		firstchoice.majorname as firstchoice, secondmajor.majorname as secondchoise
	FROM registrations 
		INNER JOIN applications ON registrations.registrationid = applications.applicationid
		LEFT JOIN majorview ON registrations.majorid = majorview.majorid
		INNER JOIN majors as firstchoice ON registrations.firstchoiceid = firstchoice.majorid
		INNER JOIN majors as secondmajor ON registrations.secondchoiceid = secondmajor.majorid
		INNER JOIN countrys as ca ON registrations.nationalityid = ca.countryid;

CREATE VIEW registrymarkview AS
	SELECT registrationview.registrationid, registrationview.fullname, 
		registrationview.org_id, registrationview.entry_form_id,
		subjects.subjectid, subjects.subjectname, 
		marks.markid, marks.grade, registrymarks.registrymarkid, registrymarks.narrative
	FROM ((registrationview INNER JOIN registrymarks ON registrationview.registrationid = registrymarks.registrationid)
		INNER JOIN subjects ON registrymarks.subjectid = subjects.subjectid)
		INNER JOIN marks ON registrymarks.markid =  marks.markid;