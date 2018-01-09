
DROP VIEW vwstudentpayments;
CREATE VIEW vwstudentpayments AS
	SELECT students.studentid, students.studentname, students.accountnumber,
		qstudents.qstudentid, qstudents.quarterid, qstudents.financeclosed, qstudents.org_id, 
		qstudents.studylevel, qstudents.sublevelid,
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
		INNER JOIN phistory ON phistory.phistoryid = studentpayments.phistoryid;
		
		
CREATE OR REPLACE FUNCTION update_posting(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(50) AS $$
BEGIN
	INSERT INTO qposting_logs (sys_audit_trail_id, posted_type_id, qstudentid, posted_amount, narrative)
	SELECT CAST($4 as int), 1, qstudentid, fees, (majorid || ',' || studylevel || ',' || mealtype || ',' || residenceid)
	FROM vwqstudentcharges
	WHERE (quarterid = $1) AND (finaceapproval = true) AND (picked = false)
		AND (sublevelid <> 'UGPM')
	ORDER BY qstudentid;

	UPDATE studentpayments SET Picked = true, Pickeddate  = now() FROM qstudents
	WHERE (studentpayments.qstudentid = qstudents.qstudentid) 
	AND (qstudents.quarterid = $1) AND (studentpayments.approved = true)
	AND (qstudents.sublevelid <> 'UGPM') AND (studentpayments.Picked = false);
	
	UPDATE qstudents SET Picked = true, Pickeddate  = now(), LRFPicked = true, LRFPickeddate  = now()
	WHERE (quarterid = $1) AND (finaceapproval = true) AND (picked = false)
	AND (sublevelid <> 'UGPM');

	UPDATE scholarships SET posted = true, dateposted = now()
	WHERE (quarterid = $1) AND (approved = true) AND (posted = false);
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_posting_pm(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(50) AS $$
BEGIN
	INSERT INTO qposting_logs (sys_audit_trail_id, posted_type_id, qstudentid, posted_amount, narrative)
	SELECT CAST($4 as int), 1, qstudentid, fees, (majorid || ',' || studylevel || ',' || mealtype || ',' || residenceid)
	FROM vwqstudentcharges
	WHERE (quarterid = $1) AND (finaceapproval = true) AND (picked = false)
		AND (sublevelid = 'UGPM')
	ORDER BY qstudentid;

	UPDATE studentpayments SET Picked = true, Pickeddate  = now() FROM qstudents
	WHERE (studentpayments.qstudentid = qstudents.qstudentid) 
	AND (qstudents.quarterid = $1) AND (studentpayments.approved = true)
	AND (qstudents.sublevelid = 'UGPM') AND (studentpayments.Picked = false);
	
	UPDATE qstudents SET Picked = true, Pickeddate  = now(), LRFPicked = true, LRFPickeddate  = now()
	WHERE (quarterid = $1) AND (finaceapproval = true) AND (picked = false)
	AND (sublevelid = 'UGPM');

	UPDATE scholarships SET posted = true, dateposted = now()
	WHERE (quarterid = $1) AND (approved = true) AND (posted = false);
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insQStudent(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(120) AS $$
DECLARE
	mystud RECORD;
	myrec RECORD;
	mycourse RECORD;
	myquarter RECORD;
	mymajor RECORD;
	mystr VARCHAR(120);
	mydegreeid int;
	creditcount real;
	mycurrqs int;
	mystudylevel int;
	myqresidentid int;
	mylatefees real;
	mycurrbalance real;
	mynarrative VARCHAR(120);
BEGIN
	SELECT s.org_id, s.onprobation, s.residenceid, s.blockname, s.roomnumber,
		s.currentbalance, s.accountnumber, s.newstudent, 
		s.sex, s.nationality, s.maritalstatus, s.birthdate, s.address, s.zipcode, s.town, s.countrycodeid, 
		s.stateid, s.telno, s.mobile, s.email,  s.guardianname, s.gaddress, s.gzipcode, s.gtown, 
		s.gcountrycodeid, s.gtelno, s.gemail, 
		s.seeregistrar, s.seesecurity, s.seesss, s.seesdc, s.seehalls, s.seechaplain, 
		entitys.entity_password, entitys.first_password
		INTO mystud
	FROM students as s INNER JOIN entitys ON s.studentid = entitys.user_name
	WHERE (studentid = $2);

	mydegreeid := getstudentdegreeid($2);
	mystudylevel := getstudylevel(mydegreeid);
	myqresidentid := get_qresidentid(mystud.residenceid, $1);
	
	SELECT majors.majorid, majors.minlevel, majors.maxlevel INTO mymajor
	FROM majors INNER JOIN studentmajors ON majors.majorid = studentmajors.majorid
	WHERE (studentmajors.studentdegreeid = mydegreeid);
	
	SELECT qstudents.qstudentid, studentdegrees.sublevelid INTO myrec
	FROM qstudents INNER JOIN studentdegrees ON qstudents.studentdegreeid = studentdegrees.studentdegreeid
	WHERE (qstudents.studentdegreeid = mydegreeid) AND (qstudents.quarterid = $1);
	
	SELECT qlatereg, qlastdrop, lateregistrationfee, getchargedays(qlatereg, current_date) as latedays,
		lateregistrationfee * getchargedays(qlatereg, current_date) as latefees,
		quarterid, substring(quarterid from 11 for 1) as quarter,
		length(quarterid) as q_length
	INTO myquarter
	FROM quarters WHERE (quarterid = $1);
	
	IF (mystud.currentbalance IS NOT NULL) THEN
		mycurrbalance := mystud.currentbalance;
	ELSIF (mystud.newstudent = true) THEN
		mycurrbalance := 0;
	END IF;

	mylatefees := 0;
	mynarrative := '';
	IF (myquarter.latefees > 0) AND ((mystud.newstudent = false) OR (myquarter.quarter != '1')) THEN 
		mylatefees := myquarter.latefees;
		mynarrative := 'Late Registration fees charges for ' || CAST(myquarter.latedays as text) || ' days at a rate of ' || CAST(myquarter.lateregistrationfee as text) || ' Per day.';
	END IF;

	IF (mystudylevel is null) AND (mymajor.minlevel is not null) THEN
		mystudylevel := mymajor.minlevel;
	ELSIF (mystudylevel is null) THEN
		mystudylevel := 100;
	ELSIF (substring($1 from 11 for 1) = '1') THEN
			mystudylevel := mystudylevel + 100;
	END IF;

	IF (mymajor.maxlevel is not null) THEN
		IF (mystudylevel > mymajor.maxlevel) THEN
			mystudylevel := mymajor.maxlevel;
		END IF;
	ELSE
		IF (mystudylevel > 500) THEN
			mystudylevel := 500;
		END IF;
	END IF;

	IF (myquarter.qlastdrop < current_date) THEN
		RAISE EXCEPTION 'The registration is closed for this session.';
	ELSIF (mystud.sex is null) or (mystud.nationality is null) or (mystud.maritalstatus is null) or (mystud.birthdate is null) THEN
		RAISE EXCEPTION 'Your students details are in complete and need to be updated by registry';
	ELSIF (mystud.address is null) or (mystud.town is null) or (mystud.countrycodeid is null) or (mystud.stateid is null) THEN
		RAISE EXCEPTION 'Your students address details are in complete and need to be updated by registry';
	ELSIF (mystud.telno is null) or (mystud.mobile is null) or (mystud.email is null) THEN
		RAISE EXCEPTION 'Your students contact details are in complete and need to be updated by registry';
	ELSIF (mystud.guardianname is null) THEN
		RAISE EXCEPTION 'Your guardian details are in complete and need to be updated by registry';
	ELSIF (mystud.gaddress is null) or (mystud.gzipcode is null) or (mystud.gtown is null) or (mystud.gcountrycodeid is null) or (mystud.gtelno is null) or (mystud.gemail is null) THEN
		RAISE EXCEPTION 'Your guardian address details are in complete and need to be updated by registry';
	ELSIF (mystud.onprobation = true) THEN
		RAISE EXCEPTION 'Student on Probation cannot proceed.';
	ELSIF (mystud.seeregistrar = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See Registars office.';
	ELSIF (mystud.seesecurity = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See security office.';
	ELSIF (mystud.seesss = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See Student Support office.';
	ELSIF (mystud.seesdc = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See the dean of students.';
	ELSIF (mystud.seehalls = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See hall dean office.';
	ELSIF (mystud.seechaplain = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See the chaplain office.';
	ELSIF (mystud.entity_password = md5(mystud.first_password)) THEN
		RAISE EXCEPTION 'You must change your password first before proceeding.';
	ELSIF (mystud.accountnumber IS NULL) THEN
		RAISE EXCEPTION 'You must have an account number, contact Finance office.';
	ELSIF (mydegreeid IS NULL) THEN
		RAISE EXCEPTION 'No Degree Indicated contact Registrars Office';
	ELSIF (getcoremajor(mydegreeid) IS NULL) THEN
		RAISE EXCEPTION 'No Major Indicated contact Registrars Office';
	ELSIF ((myrec.sublevelid = 'MEDI') AND (myquarter.q_length <> 12)) THEN
		RAISE EXCEPTION 'Select the session with either 1M, 2M or 3M';
	ELSIF (myrec.qstudentid IS NULL) THEN
		INSERT INTO qstudents(quarterid, studentdegreeid, studylevel, currbalance, charges, financenarrative, paymenttype, org_id)
		VALUES ($1, mydegreeid, mystudylevel, mycurrbalance, mylatefees, mynarrative, 1, mystud.org_id);
		
		mycurrqs := getqstudentid($2);
		creditcount := 0;
		FOR mycourse IN SELECT yeartaken, courseid, min(qcourseid) as qcourseid, max(credithours) as credithours
			FROM qcoursecheckpass
			WHERE (elective = false) AND (coursepased = false) AND (prereqpassed = true)
				AND (yeartaken <= (mystudylevel/100)) AND (studentid = $2) AND (quarterid = $1)
			GROUP BY yeartaken, courseid
			ORDER BY yeartaken, courseid
		LOOP
			IF (creditcount < 16) THEN
				INSERT INTO qgrades(qstudentid, qcourseid, hours, credit, approved) 
				VALUES (mycurrqs, mycourse.qcourseid, mycourse.credithours, mycourse.credithours, true);
				creditcount := creditcount + mycourse.credithours;
			END IF;
		END LOOP;
		
		mystr := 'Semester registered confirm course selection and awaiting approval';
	ELSE
		mystr := 'You are already registered for the Semester proceed with course selection';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;


--- Finance payment
CREATE OR REPLACE FUNCTION insQPayment(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(120) AS $$
DECLARE
	myrec				RECORD;
	myqrec				RECORD;
	mypayrec 			RECORD;
	mypayreccheck 		RECORD;
	myquarter 			RECORD;
	mystud 				RECORD;
	mystr 				varchar(120);
	mycurrqs 			int;
	myamount 			real;
	mylatefees 			int;
	mymaxcredit 		real;
	mydegreeid 			int;
	p_major				varchar(12);
	m_load				real;
	ml_load				real;
	v_charges			float;
	mynarrative 		varchar(120);
BEGIN
	mycurrqs := getqstudentid($2);
	
	SELECT currentbalance, accountnumber, newstudent, seeregistrar
	INTO mystud
	FROM students WHERE (studentid = $2);
	
	SELECT studentpaymentid INTO mypayrec
	FROM studentpayments WHERE (qstudentid = mycurrqs) AND (approved = false);
	
	SELECT studentpaymentid INTO mypayreccheck
	FROM studentpayments WHERE (qstudentid = mycurrqs) AND (approved = true);
	
	SELECT charges INTO v_charges
	FROM qstudents WHERE (qstudentid = mycurrqs);
	
	SELECT quarterid, quarter, mincredits, maxcredits, org_id,
		studentid, studentdegreeid, qstudentid, finalised, finaceapproval, gpa, hours, studylevel,
		offcampus, residenceoffcampus, overloadapproval, overloadhours, studentdeanapproval
	INTO myqrec
	FROM studentquarterview
	WHERE (qstudentid = CAST($1 as int));
	
	SELECT qlatereg, qlastdrop, lateregistrationfee, getchargedays(qlatereg, current_date) as latedays,
		lateregistrationfee * getchargedays(qlatereg, current_date) as latefees,
		quarterid, substring(quarterid from 11 for 1) as quarter
	INTO myquarter
	FROM quarters 
	WHERE (active = true) and (org_id = myqrec.org_id);
	
	mylatefees := 0;
	mynarrative := '';
	IF (myquarter.latefees > 0) AND (v_charges = 0) AND ((mystud.newstudent = false) OR (myquarter.quarter != '1')) THEN 
		mylatefees := myquarter.latefees;
		mynarrative := 'Late Registration fees charges for ' || CAST(myquarter.latedays as text) || ' days at a rate of ' || CAST(myquarter.lateregistrationfee as text) || ' Per day.';
	END IF;

	IF (mycurrqs is not null) THEN
		UPDATE qstudents SET charges = mylatefees, financenarrative = mynarrative
		WHERE (qstudentid = mycurrqs);
	END IF;
	
	SELECT accountnumber, quarterid, currbalance, fullfinalbalance, finalbalance, studylevel,
		paymenttype, ispartpayment, offcampus, studentdeanapproval, financeclosed, finaceapproval
	INTO myrec
	FROM vwqstudentbalances
	WHERE (qstudentid = mycurrqs);
	
	mydegreeid := myqrec.studentdegreeid;
	mymaxcredit := myqrec.maxcredits;
	SELECT majors.majorid, majors.quarterload INTO p_major, m_load
	FROM (majors INNER JOIN studentmajors ON majors.majorid = studentmajors.majorid)
	WHERE (studentmajors.primarymajor = true) AND (studentmajors.studentdegreeid = mydegreeid);

	SELECT quarterload INTO ml_load
	FROM major_levels WHERE (majorid = p_major) AND (major_level = myrec.studylevel);
	
	IF (ml_load IS NOT NULL) THEN
		mymaxcredit := ml_load;
	ELSIF (m_load IS NOT NULL) THEN
		mymaxcredit := m_load;
	END IF;

	myamount := 0;
	mystr := null;
	
	IF (myqrec.qstudentid IS NULL) THEN 
		RAISE EXCEPTION 'Please register for the semester and make course selections first before applying for payment';
	ELSIF (myqrec.hours < myqrec.mincredits) AND (myqrec.overloadapproval = false) THEN
		RAISE EXCEPTION 'You have an underload, the required minimum is % credits.', CAST(myqrec.mincredits as text);
	ELSIF (myqrec.hours < myqrec.mincredits) AND (myqrec.overloadapproval = true) AND (myqrec.hours < myqrec.overloadhours) THEN
		RAISE EXCEPTION 'You have an underload, you can only take the approved minimum of % ', CAST(myqrec.overloadhours as text);
	ELSIF (myqrec.hours > mymaxcredit) AND (myqrec.overloadapproval = false) THEN
		RAISE EXCEPTION 'You have an overload, the required maximum is % ', CAST(mymaxcredit as text);
	ELSIF (myqrec.hours > mymaxcredit) AND (myqrec.overloadapproval = true) AND (myqrec.hours > myqrec.overloadhours) THEN
		RAISE EXCEPTION 'You have an overload, you can only take the approved maximum of % ', CAST(myqrec.overloadhours as text);
	ELSIF (myqrec.offcampus = true) AND (myqrec.studentdeanapproval = false) THEN
		RAISE EXCEPTION 'You have no clearence to be off campus';
	ELSIF (myrec.currbalance is null) THEN
		RAISE EXCEPTION 'Application for payment rejected because your current credit is not updated, send a post to Bursary.';
	ELSIF (myrec.financeclosed = true) OR (myrec.finaceapproval = true) THEN
		RAISE EXCEPTION 'You cannot make changes after submiting your payment unless you apply on the post for it to be opened by finance.';
	ELSIF (myrec.offcampus = true) AND (myrec.studentdeanapproval = false) THEN
		RAISE EXCEPTION 'Application for payment rejected, first get off campus approval.';
	ELSIF (myrec.paymenttype = 1) THEN
		myamount := myrec.fullfinalbalance;
	ELSIF (myrec.paymenttype = 2) THEN
		myamount := myrec.finalbalance;
	ELSIF (myrec.paymenttype = 3) AND (myrec.ispartpayment = false) THEN
		RAISE EXCEPTION 'Application for payment rejected, your require approval for the payment plan';
	ELSIF (myrec.paymenttype = 3) AND (myrec.ispartpayment = true) THEN
		myamount := myrec.currbalance + (myrec.finalbalance - myrec.currbalance) / 2;
	ELSIF (myrec.paymenttype = 4) AND (myrec.studylevel = 100) THEN
		myamount := -209000.0;
	ELSIF (myrec.paymenttype = 4) AND (myrec.studylevel != 100) THEN
		RAISE EXCEPTION 'You can only apply for acceptance fee.';
	ELSE
		RAISE EXCEPTION 'Application for payment rejected, verify application and approvals';
	END IF;

	IF (myamount < 0) THEN
		IF (mypayrec.studentpaymentid is null) THEN
			INSERT INTO studentpayments (org_id, qstudentid, amount, narrative) 
			VALUES (myqrec.org_id, mycurrqs, myamount * (-1), CAST(nextval('studentpayment_seq') as text) || 'Fees;' || myrec.quarterid || ';' || myrec.accountnumber);
		ELSE
			UPDATE studentpayments SET amount = myamount * (-1)
			WHERE studentpaymentid = mypayrec.studentpaymentid;
		END IF;
		UPDATE qstudents SET financeclosed = true WHERE (qstudentid = mycurrqs);
		mystr := 'Application for payment accepted, proceed';
	END IF;

	IF (myamount >= 0) AND (mystr is null) THEN
		UPDATE qstudents SET financeclosed = true WHERE qstudentid = mycurrqs;
		mystr := 'Fees indicated as fully paid';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;


