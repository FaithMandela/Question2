
DROP VIEW vw_applicant_payments;
DROP VIEW vwstudentpayments;


ALTER TABLE phistory ALTER COLUMN phistoryname TYPE varchar(320);

INSERT INTO phistory(phistoryid, phistoryname) VALUES (1002, 'CHECKSUM/FINAL_CHECKSUM error');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (100, 'Duplicate session id');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (200, 'Invalid client id');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (300, 'Invalid mac');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (400, 'Expired session');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (500, 'You have entered an account number that is not tied to your phone number with bank. Pls contact your bank for assistance.');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (600, 'Invalid account id');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (700, 'Security violation Please contact support@etranzact.com');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (800, 'Invalid esa code');
INSERT INTO phistory(phistoryid, phistoryname) VALUES (900, 'Transaction limit exceeded');


CREATE VIEW vwstudentpayments AS
	SELECT students.studentid, students.studentname, students.accountnumber,
		qstudents.qstudentid, qstudents.quarterid, qstudents.financeclosed, qstudents.org_id, 
		studentpayments.studentpaymentid, studentpayments.applydate, studentpayments.amount, 
		studentpayments.approved, studentpayments.approvedtime,
		studentpayments.narrative, studentpayments.Picked, studentpayments.Pickeddate,
		studentpayments.terminalid, phistory.phistoryid, phistory.phistoryname, 
		students.emailuser || '@std.babcock.edu.ng' as student_email,
		(CASE WHEN studentpayments.approved = false THEN 
		'<a href="payments/paymentClient.jsp?TRANSACTION_ID='|| studentpayments.studentpaymentid
		|| '" target="_blank"><IMG SRC="resources/images/etranzact.jpg" WIDTH=120 HEIGHT=24 ALT=""></a>'
		ELSE 'The payment is completed and updated' END) as makepayment,

		(CASE WHEN studentpayments.approved = false THEN 
		'<a href="payments/paymentVisa.jsp?TRANSACTION_ID='|| studentpayments.studentpaymentid
		|| '" target="_blank"><IMG SRC="resources/images/visa.jpeg" WIDTH=380 HEIGHT=29 ALT=""></a>'
		ELSE 'The payment is completed and updated' END) as visapayment,
		
		(CASE WHEN studentpayments.approved = false THEN 
		'<a href="payments/paymentBankit.jsp?TRANSACTION_ID='|| studentpayments.studentpaymentid
		|| '" target="_blank"><IMG SRC="resources/images/bankit.png" WIDTH=198 HEIGHT=58 ALT=""></a>'
		ELSE 'The payment is completed and updated' END) as bankit,

		(CASE WHEN studentpayments.approved = false THEN 
		'<a href="payments/query.jsp?TRANSACTION_ID='|| studentpayments.studentpaymentid
		|| '" target="_blank">Query Payment Status</a>'
		ELSE 'Ok' END) as querypayment
		
	FROM (((students INNER JOIN studentdegrees ON students.studentid = studentdegrees.studentid)
		INNER JOIN qstudents ON studentdegrees.studentdegreeid = qstudents.studentdegreeid)
		INNER JOIN studentpayments ON studentpayments.qstudentid = qstudents.qstudentid)
		INNER JOIN PHistory ON PHistory.PHistoryid = studentpayments.PHistoryid;
		
CREATE VIEW vw_applicant_payments AS
	SELECT registrations.registrationid, registrations.email, registrations.submitapplication, 
		registrations.isaccepted, registrations.isreported, registrations.isdeferred, registrations.isrejected,
		registrations.applicationdate, 
		registrations.sex, registrations.surname, registrations.firstname, registrations.othernames, 
		(registrations.surname || ', ' ||  registrations.firstname || ' ' || registrations.othernames) as fullname,
		registrations.existingid, registrations.firstchoiceid, registrations.secondchoiceid, registrations.offcampus,
		registrations.org_id, registrations.entry_form_id,
		studentpayments.studentpaymentid, studentpayments.applydate, studentpayments.amount, 
		studentpayments.approved, studentpayments.approvedtime,
		studentpayments.narrative, studentpayments.Picked, studentpayments.Pickeddate,
		studentpayments.terminalid, phistory.phistoryid, phistory.phistoryname, 
		(CASE WHEN studentpayments.approved = false THEN 
		'<a href="paymentClient.jsp?TRANSACTION_ID='|| studentpayments.studentpaymentid
		|| '"><IMG SRC="images/etranzact.jpg" WIDTH=120 HEIGHT=24 ALT=""></a>'
		ELSE 'The payment is completed and updated' END) as makepayment,

		(CASE WHEN studentpayments.approved = false THEN 
		'<a href="query.jsp?TRANSACTION_ID='|| studentpayments.studentpaymentid
		|| '">Query Payment Status</a>'
		ELSE 'Ok' END) as querypayment
	FROM (registrations INNER JOIN studentpayments ON studentpayments.registrationid = registrations.registrationid)
		INNER JOIN PHistory ON PHistory.PHistoryid = studentpayments.PHistoryid;
		
		
CREATE OR REPLACE FUNCTION updstudentpayments() RETURNS trigger AS $$
DECLARE
	reca 						RECORD;
	old_studentpaymentid 		integer;
BEGIN
	SELECT departments.schoolid, departments.departmentid, students.accountnumber, qstudents.quarterid, qstudents.studylevel,
		qstudents.org_id
	INTO reca
	FROM ((departments INNER JOIN students ON students.departmentid = departments.departmentid)
		INNER JOIN studentdegrees ON students.studentid = studentdegrees.studentid)
		INNER JOIN qstudents ON studentdegrees.studentdegreeid = qstudents.studentdegreeid
	WHERE (qstudents.qstudentid = NEW.qstudentid);

	IF (TG_OP = 'INSERT') THEN
		SELECT studentpaymentid INTO old_studentpaymentid
		FROM studentpayments 
		WHERE (approved = false) AND (qstudentid = NEW.qstudentid);

		IF(old_studentpaymentid is not null)THEN
			RAISE EXCEPTION 'You have another uncleared payment, ammend that first and pay';
		END IF;
	ELSE
		IF(OLD.approved = true) AND (NEW.approved = true)THEN
			IF(OLD.amount <> NEW.amount)THEN
				RAISE EXCEPTION 'You cannot change amount value after transaction approval.';
			END IF;
		ELSE
			IF(OLD.amount <> NEW.amount)THEN
				new.old_amount := NEW.amount;
			END IF;
		END IF;
	END IF;

	IF(reca.schoolid = 'COEN')THEN
		NEW.terminalid = '7000000089';
	ELSIF(reca.org_id = 1)THEN
		NEW.terminalid = '7007139046';
	ELSIF(reca.schoolid = 'MBBS')THEN
		NEW.terminalid = '7007139046';
	ELSIF(reca.schoolid = 'BCSM')THEN
		NEW.terminalid = '7007139046';
	ELSE
		NEW.terminalid = '0690000082';
	END IF;
	
	IF(NEW.narrative is null) THEN
		NEW.narrative = CAST(NEW.studentpaymentid as text) || ';Pay;' || reca.quarterid || ';' || reca.accountnumber;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


UPDATE qstudents SET Picked = false
WHERE quarterid = '2017/2018.1' and sublevelid = 'UGPM' and finaceapproval = true and Picked = true;


