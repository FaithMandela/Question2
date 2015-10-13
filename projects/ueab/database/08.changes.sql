
----- Do a backend approve
CREATE OR REPLACE FUNCTION upd_qapprove(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(250) AS $$
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

	SELECT studentid, studentdegreeid,
		qstudentid, finalised, finaceapproval, totalfees, finalbalance, gpa, hours, quarterid, quarter, feesline, 
		resline, offcampus, residenceoffcampus, overloadapproval,
		degreelevelid, getcummcredit(studentdegreeid, quarterid) as cummcredit, 
		getcummgpa(studentdegreeid, quarterid) as cummgpa 
		INTO myrec
	FROM studentquarterview
	WHERE (qstudentid = $1::integer);
	
	mydegreeid := myrec.studentdegreeid;

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
		mystr := 'Probation issue to be resolved first before approval ';
		IF(studentrec.probationdetail != null) THEN
			mystr := mystr || ' ' || studentrec.probationdetail;
		END IF;
	ELSIF (studentrec.seeregistrar = true) THEN
		mystr := 'Probation issue to be resolved first before approval ';
		IF(studentrec.probationdetail != null) THEN
			mystr := mystr || ' ' || studentrec.probationdetail;
		END IF;
	ELSIF (ttb.coursetitle IS NOT NULL) THEN
		mystr := 'You have an timetable clashing for ' || ttb.coursetitle;
	ELSIF (courserec.courseid IS NOT NULL) THEN
		mystr := 'The class ' || courserec.courseid || ', ' || courserec.coursetitle || ' is full';
	ELSIF (prererec.courseid IS NOT NULL) THEN
		mystr := 'You need to complete the prerequisites or placement for course , ' || prererec.courseid || ', ' || prererec.coursetitle;
	ELSIF (getprobation(myrec.quarter, myrec.cummgpa, myrec.hours) = true) THEN
		mystr := 'See your major adviser for courses you need to pick, get financial approval and then visit records office for approval ';
	ELSIF (myoverload = true) THEN
		mystr := 'You have an overload';
	ELSIF (myrec.offcampus = false) and (myrec.residenceoffcampus = true) THEN
		mystr := 'You have no clearence to be off campus';
	ELSIF (myrec.finaceapproval = false) THEN
		mystr := 'Your need finance approved before final approval';
	ELSE
		UPDATE qstudents SET approved = true, sys_audit_trail_id = $4::int
		WHERE qstudentid = myrec.qstudentid;
		mystr := 'You have successful approved the student';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;

