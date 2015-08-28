
	
ALTER TABLE charges ADD charge_feesline		float;
ALTER TABLE charges ADD charge_resline		float;

DROP VIEW qetimetableview;
CREATE VIEW qetimetableview AS
	SELECT assets.assetid, assets.assetname, assets.location, assets.building, assets.capacity, 
		qcourseview.qcourseid, qcourseview.courseid, qcourseview.coursetitle, qcourseview.instructorid,
		qcourseview.instructorname, qcourseview.quarterid, qcourseview.maxclass, qcourseview.classoption,
		qcourseview.levellocationid, qcourseview.levellocationname,
		optiontimes.optiontimeid, optiontimes.optiontimename,
		qexamtimetable.org_id, qexamtimetable.qexamtimetableid, qexamtimetable.starttime, qexamtimetable.endtime, 
		qexamtimetable.lab, qexamtimetable.examdate, qexamtimetable.details 
	FROM ((assets INNER JOIN qexamtimetable ON assets.assetid = qexamtimetable.assetid)
		INNER JOIN qcourseview ON qexamtimetable.qcourseid = qcourseview.qcourseid)
		INNER JOIN optiontimes ON qexamtimetable.optiontimeid = optiontimes.optiontimeid
	ORDER BY qexamtimetable.examdate, qexamtimetable.starttime;


CREATE OR REPLACE FUNCTION grade_updates(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(240) AS $$
BEGIN
	IF($3 = '1')THEN
		UPDATE qgrades SET gradeid = 'F', sys_audit_trail_id = $4::integer
		FROM qstudents WHERE (qgrades.qstudentid = qstudents.qstudentid) 
			AND (qgrades.dropped = false) AND (qgrades.gradeid = 'NG')
			AND (qstudents.exam_clear = true) AND (qstudents.quarterid = $1);

		UPDATE qgrades SET gradeid = 'UE', sys_audit_trail_id = $4::integer
		FROM qstudents WHERE (qgrades.qstudentid = qstudents.qstudentid) 
			AND (qgrades.dropped = false) AND (qgrades.gradeid = 'NG')
			AND (qstudents.finaceapproval = true) AND (qstudents.exam_clear = false) AND (qstudents.quarterid = $1);
	END IF;

	IF($3 = '2')THEN
		UPDATE qgrades SET gradeid = 'F', sys_audit_trail_id = $4::integer
		FROM qstudents WHERE (qgrades.qstudentid = qstudents.qstudentid) 
			AND (qgrades.dropped = false) AND (qgrades.gradeid = 'UE')
			AND (qstudents.quarterid = $1);
	END IF;

	IF($3 = '3')THEN
		UPDATE qgrades SET gradeid = 'AW', sys_audit_trail_id = $4::integer
		FROM qstudents WHERE (qgrades.qstudentid = qstudents.qstudentid) 
			AND (qgrades.dropped = false) AND (gradeid = 'DG')
			AND (qstudents.quarterid = $1);
	END IF;
	
	IF($3 = '4')THEN
		UPDATE qgrades SET gradeid = 'F', sys_audit_trail_id = $4::integer
		FROM qstudents WHERE (qgrades.qstudentid = qstudents.qstudentid) 
			AND (qgrades.dropped = false) AND (gradeid = 'IW')
			AND (qstudents.quarterid = $1);
	END IF;
	
	IF($3 = '5')THEN
		UPDATE qgrades SET gradeid = 'AW', sys_audit_trail_id = $4::integer
		FROM qstudents WHERE (qgrades.qstudentid = qstudents.qstudentid) 
			AND (qgrades.dropped = false) AND (gradeid = 'UE')
			AND (qstudents.quarterid = $1);
	END IF;

	RETURN 'Grade updates';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insQClose(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(250) AS $$
DECLARE
	myrec 			RECORD;
	myqrec 			RECORD;
	ttb 			RECORD;
	fnar 			RECORD;
	courserec 		RECORD;
	placerec 		RECORD;
	prererec 		RECORD;
	studentrec 		RECORD;
	mystr 			varchar(250);
	myrepeatapprove	varchar(12);
	mydegreeid 		int;
	myoverload 		boolean;
	myprobation 	boolean;
	mysabathclass	boolean;
	v_last_reg		boolean;
	myfeesline 		real;
BEGIN
	mydegreeid := getstudentdegreeid($2);

	SELECT qstudentid, finalised, finaceapproval, totalfees, finalbalance, gpa, hours, quarterid, quarter, feesline, 
		resline, offcampus, residenceoffcampus, overloadapproval,
		degreelevelid, getcummcredit(studentdegreeid, quarterid) as cummcredit, 
		getcummgpa(studentdegreeid, quarterid) as cummgpa 
		INTO myrec
	FROM studentquarterview
	WHERE (studentdegreeid = mydegreeid) AND (quarterid = $1);

	SELECT studentdegrees.sublevelid, students.fullbursary, students.seeregistrar, students.onprobation, 
		students.details as probationdetail, students.gaddress, students.address 
		INTO studentrec
	FROM students INNER JOIN studentdegrees ON students.studentid = studentdegrees.studentid  
	WHERE (studentdegrees.studentdegreeid = mydegreeid);

	SELECT qstudents.roomnumber, qstudents.qresidenceid, qstudents.sabathclassid, qstudents.overloadapproval, 
		qstudents.overloadhours, qstudents.financenarrative, qstudents.firstinstalment, 
		qstudents.firstdate, qstudents.secondinstalment, qstudents.seconddate, qstudents.registrarapproval, 
		qstudents.approve_late_fee, qstudents.late_fee_date,
		charges.last_reg_date, charges.charge_feesline, charges.charge_resline,
		sublevels.max_credits
		INTO myqrec
	FROM qstudents INNER JOIN charges ON qstudents.charge_id = charges.charge_id
		INNER JOIN sublevels ON charges.sublevelid = sublevels.sublevelid 
	WHERE qstudents.qstudentid = myrec.qstudentid;

	SELECT courseid, coursetitle INTO courserec
	FROM selcourseview WHERE (qstudentid = myrec.qstudentid) AND (maxclass < qcoursestudents);

	SELECT courseid, coursetitle, placementpassed, prereqpassed INTO prererec
	FROM selectedgradeview 
	WHERE (qstudentid = myrec.qstudentid) AND ((prereqpassed = false) OR (placementpassed = false));

	myoverload := getoverload(myqrec.max_credits, myrec.hours, myrec.cummgpa, myrec.cummcredit, myqrec.overloadapproval, myqrec.overloadhours);

	SELECT coursetitle INTO ttb 
	FROM studenttimetableview WHERE (qstudentid=myrec.qstudentid)
	AND (gettimecount(qstudentid, starttime, endtime, cmonday, ctuesday, cwednesday, cthursday, cfriday, csaturday, csunday) >1);

	myrepeatapprove := getrepeatapprove(myrec.qstudentid);

	IF (myrec.offcampus = TRUE) THEN
		IF(myqrec.charge_feesline is not null)THEN
			myfeesline := myrec.totalfees * (100 - myqrec.charge_feesline) / 100;
		ELSE
			myfeesline := myrec.totalfees * (100 - myrec.feesline) /100;
		END IF;
		mysabathclass := false;
	ELSE
		IF(myqrec.charge_resline is not null)THEN
			myfeesline := myrec.totalfees * (100 - myrec.charge_resline) / 100;
		ELSE
			myfeesline := myrec.totalfees * (100 - myrec.resline) / 100;
		END IF;
		IF (myqrec.sabathclassid is null) THEN
			mysabathclass := true;
		ELSIF (myqrec.sabathclassid = 0) THEN
			mysabathclass := true;
		ELSE
			mysabathclass := false;
		END IF;
	END IF;
	
	myprobation := false;
	IF (myrec.cummgpa is not null) THEN
		IF (((myrec.degreelevelid = 'MAS') OR (upper(myrec.degreelevelid) = 'PHD')) AND (myrec.cummgpa < 2.99)) THEN
			myprobation := true;
		END IF;
		IF (myrec.cummgpa < 1.99) THEN
			myprobation := true;
		END IF;
	END IF;
	IF (myqrec.registrarapproval = true) THEN
		myprobation := false;
	END IF;

	v_last_reg := false;
	IF(myqrec.last_reg_date <= current_date) THEN
		IF(myqrec.approve_late_fee = false)THEN
			v_last_reg := true;
		ELSIF((current_date - myqrec.late_fee_date) > 14)THEN
			v_last_reg := true;
		END IF;
	END IF;

	mystr := '';
	IF (studentrec.onprobation = true) THEN
		IF(studentrec.probationdetail != null) THEN
			mystr := '<br/>' || studentrec.probationdetail;
		END IF;
		RAISE EXCEPTION 'See your major adviser for courses you need to pick, get financial approval and the visit records office for approval % ', mystr;
	ELSIF (studentrec.seeregistrar = true) THEN
		IF(studentrec.probationdetail != null) THEN
			mystr := '<br/>' || studentrec.probationdetail;
		END IF;
		RAISE EXCEPTION 'Go to records office for clearance  % ', mystr;
	ELSIF (myrec.qstudentid IS NULL) THEN 
		RAISE EXCEPTION 'Please register for the trimester, residence first before closing';
	ELSIF (myrec.finalised = true) THEN
		RAISE EXCEPTION 'The trimester is closed for registration';
    ELSIF (studentrec.gaddress IS NULL) THEN
		RAISE EXCEPTION 'Go to records office for clearance, Wrong Guardian Address';
	ELSIF (studentrec.address IS NULL) THEN
		RAISE EXCEPTION 'Go to records office for clearance, Wrong Student Address';
	ELSIF (myrec.finalised = true) THEN
		RAISE EXCEPTION 'The trimester is closed for registration';
	ELSIF (myprobation = true) THEN
		RAISE EXCEPTION 'See your major adviser for courses you need to pick, get financial approval and the visit records office for approval';
	ELSIF (v_last_reg = true) THEN
		RAISE EXCEPTION 'You need to clear for late registration with the Registars office';
	ELSIF (myqrec.qresidenceid is null) THEN
		RAISE EXCEPTION 'You have to select your residence first';
	ELSIF (myrec.offcampus = false) AND (myqrec.roomnumber is null) THEN
		RAISE EXCEPTION 'You have to select your residence room first';
	ELSIF (mysabathclass = true) THEN
		RAISE EXCEPTION 'You have to select your sabbath class first';
	ELSIF (myrepeatapprove IS NOT NULL) THEN
		RAISE EXCEPTION 'You need repeat approval for % from the registrar', myrepeatapprove;
	ELSIF (ttb.coursetitle IS NOT NULL) THEN
		RAISE EXCEPTION 'You have an timetable clashing for % ', ttb.coursetitle;
	ELSIF (courserec.courseid IS NOT NULL) THEN
		RAISE EXCEPTION 'The class %, % is full', courserec.courseid, courserec.coursetitle;
	ELSIF (prererec.courseid IS NOT NULL) THEN
		RAISE EXCEPTION 'You need to complete the prerequisites or placement for course %, % ', prererec.courseid, prererec.coursetitle;
	ELSIF (getprobation(myrec.quarter, myrec.cummgpa, myrec.hours) = true) THEN
		RAISE EXCEPTION 'See your major adviser for courses you need to pick, get financial approval and then visit records office for approval ';
	ELSIF (myoverload = true) THEN
		RAISE EXCEPTION 'You have an overload';
	ELSIF (myrec.offcampus = false) and (myrec.residenceoffcampus = true) THEN
		RAISE EXCEPTION 'You have no clearence to be off campus';
	ELSIF (studentrec.fullbursary = true) THEN
		UPDATE qstudents SET finalised = true, finaceapproval = true WHERE qstudentid = myrec.qstudentid;
		UPDATE qstudents SET firstclosetime = now() WHERE (firstclosetime is null) AND (qstudentid = myrec.qstudentid); 
		mystr := 'You have successful closed trimester based on bursary status';
	ELSIF (studentrec.sublevelid = 'EAUP') THEN
		UPDATE qstudents SET finalised = true, finaceapproval = true WHERE qstudentid = myrec.qstudentid;
		UPDATE qstudents SET firstclosetime = now() WHERE (firstclosetime is null) AND (qstudentid = myrec.qstudentid); 
		mystr := 'You have successful closed trimester based on bursary status';
	ELSIF (myrec.finaceapproval = true) THEN
		UPDATE qstudents SET finalised = true WHERE qstudentid = myrec.qstudentid;
		UPDATE qstudents SET firstclosetime = now() WHERE (firstclosetime is null) AND (qstudentid = myrec.qstudentid);
		mystr := 'Successful trimester closed based on financial approval';
	ELSIF (myrec.finalbalance IS NULL) THEN
		RAISE EXCEPTION 'Financial balance not updated, make payments, then check your statement.';
	ELSIF (myrec.finalbalance > myfeesline) THEN
		RAISE EXCEPTION 'Not Enough financial credit, make payments, then check your statement.';
	ELSIF (myrec.finalbalance < 2000) THEN
		UPDATE qstudents SET finalised = true, finaceapproval = true WHERE qstudentid = myrec.qstudentid;
		UPDATE qstudents SET firstclosetime = now() WHERE (firstclosetime is null) AND (qstudentid = myrec.qstudentid);
		mystr := 'The trimester Closed based on financial promise';
	ELSE
		UPDATE qstudents SET finalised = true, finaceapproval = true WHERE qstudentid = myrec.qstudentid;
		UPDATE qstudents SET firstclosetime = now() WHERE (firstclosetime is null) AND (qstudentid = myrec.qstudentid);
		mystr := 'You have successful Closed trimester, Check required approvals';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;

