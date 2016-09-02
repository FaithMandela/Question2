
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