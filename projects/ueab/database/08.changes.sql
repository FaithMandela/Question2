

CREATE OR REPLACE FUNCTION getcummcredit(int) RETURNS float AS $$
	SELECT sum(qgrades.credit)
	FROM (qgrades INNER JOIN qstudents ON qgrades.qstudentid = qstudents.qstudentid)
		INNER JOIN grades ON qgrades.gradeid = grades.gradeid
	WHERE (qstudents.studentdegreeid = $1) AND (qstudents.approved = true) AND (qgrades.dropped = false)
		AND (grades.gpacount = true) AND (qgrades.repeated = false) AND (qgrades.gradeid <> 'W') AND (qgrades.gradeid <> 'AW');
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getcummgpa(int) RETURNS float AS $$
	SELECT (CASE sum(qgrades.credit) WHEN 0 THEN 0 ELSE (sum(grades.gradeweight * qgrades.credit)/sum(qgrades.credit)) END)
	FROM (qgrades INNER JOIN qstudents ON qgrades.qstudentid = qstudents.qstudentid)
		INNER JOIN grades ON qgrades.gradeid = grades.gradeid
	WHERE (qstudents.studentdegreeid = $1) AND (qstudents.approved = true)
		AND (qgrades.dropped = false) AND (grades.gpacount = true) 
		AND (qgrades.repeated = false) AND (qgrades.gradeid <> 'W') AND (qgrades.gradeid <> 'AW');
$$ LANGUAGE SQL;

DROP VIEW vw_studentdegrees;
CREATE VIEW vw_studentdegrees AS
	SELECT studentview.religionid, studentview.religionname, studentview.denominationid, studentview.denominationname,
		studentview.schoolid, studentview.schoolname, studentview.studentid, studentview.studentname, studentview.address, studentview.zipcode,
		studentview.town, studentview.addresscountry, studentview.telno, studentview.email,  studentview.guardianname, studentview.gaddress,
		studentview.gzipcode, studentview.gtown, studentview.gaddresscountry, studentview.gtelno, studentview.gemail,
		studentview.accountnumber, studentview.Nationality, studentview.Nationalitycountry, studentview.Sex,
		studentview.MaritalStatus, studentview.birthdate, studentview.firstpass, studentview.alumnae, studentview.postcontacts,
		studentview.onprobation, studentview.offcampus, studentview.currentcontact, studentview.currentemail, studentview.currenttel,
		studentview.org_id,
		sublevelview.degreelevelid, sublevelview.degreelevelname,
		sublevelview.freshman, sublevelview.sophomore, sublevelview.junior, sublevelview.senior,
		sublevelview.levellocationid, sublevelview.levellocationname,
		sublevelview.sublevelid, sublevelview.sublevelname, sublevelview.specialcharges,
		degrees.degreeid, degrees.degreename,
		studentdegrees.studentdegreeid, studentdegrees.completed, studentdegrees.started, studentdegrees.cleared, studentdegrees.clearedate,
		studentdegrees.graduated, studentdegrees.graduatedate, studentdegrees.dropout, studentdegrees.transferin, studentdegrees.transferout,
		
		studentdegrees.grad_apply, studentdegrees.grad_apply_date, studentdegrees.grad_finance, studentdegrees.grad_finance_date,
		studentdegrees.grad_accept, studentdegrees.grad_accept_date,
		
		studentdegrees.mathplacement, studentdegrees.englishplacement, studentdegrees.details,
		
		getcummcredit(studentdegrees.studentdegreeid) as cumm_credits,
		getcummgpa(studentdegrees.studentdegreeid) as cumm_gpa
	FROM ((studentview INNER JOIN studentdegrees ON studentview.studentid = studentdegrees.studentid)
		INNER JOIN sublevelview ON studentdegrees.sublevelid = sublevelview.sublevelid)
		INNER JOIN degrees ON studentdegrees.degreeid = degrees.degreeid;

CREATE OR REPLACE FUNCTION getoverload(real, float, float, float, boolean, float) RETURNS boolean AS $$
DECLARE
	myoverload boolean;
BEGIN
	myoverload := false;

	IF ($1=14) THEN
		IF (($3<1.99) AND ($2<>9)) THEN
			myoverload := true;
		ELSIF ($3 is null) AND ($2 > 14) THEN
			myoverload := true;
		ELSIF (($4>=110) AND ($3>=2.70) AND ($2<=17)) THEN
			myoverload := false;
		ELSE
			IF (($3<3) AND ($2>14)) THEN
				myoverload := true;
			ELSIF (($3<3.5) AND ($2>15)) THEN
				myoverload := true;
			ELSIF ($2>16) THEN
				myoverload := true;
			END IF;
		END IF;
	ELSE
		IF($2 > $1)THEN
			myoverload := true;
		END IF;
	END IF;

	IF (myoverload = true) THEN
		IF ($5 = true) AND ($2 <= $6) THEN
			myoverload := false;
		END IF;
	END IF;

    RETURN myoverload;
END;
$$ LANGUAGE plpgsql;


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
		charges.last_reg_date,
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
		myfeesline := myrec.totalfees * (100 - myrec.feesline) /100;
		mysabathclass := false;
	ELSE
		myfeesline := myrec.totalfees * (100 - myrec.resline) / 100;
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
		RAISE EXCEPTION 'Student on Probation, See the Dean of Students % ', mystr;
	ELSIF (studentrec.seeregistrar = true) THEN
		IF(studentrec.probationdetail != null) THEN
			mystr := '<br/>' || studentrec.probationdetail;
		END IF;
		RAISE EXCEPTION 'Cannot Proceed, Go to records office for clearance  % ', mystr;
	ELSIF (myrec.qstudentid IS NULL) THEN 
		RAISE EXCEPTION 'Please register for the trimester, residence first before closing';
	ELSIF (myrec.finalised = true) THEN
		RAISE EXCEPTION 'The trimester is closed for registration';
    ELSIF (studentrec.gaddress IS NULL) THEN
		RAISE EXCEPTION 'Cannot Proceed, See Records office, Wrong Guardian Address';
	ELSIF (studentrec.address IS NULL) THEN
		RAISE EXCEPTION 'Cannot Proceed, See Records office, Wrong Student Address';
	ELSIF (myrec.finalised = true) THEN
		RAISE EXCEPTION 'The trimester is closed for registration';
	ELSIF (myprobation = true) THEN
		RAISE EXCEPTION 'Your Cumm. GPA is below the required level, you need to see the registrar for apporval.';
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

CREATE OR REPLACE FUNCTION getPGgradeid(integer) RETURNS varchar(2) AS $$
	SELECT CASE WHEN max(gradeid) is null THEN 'NG' ELSE max(gradeid) END
	FROM grades 
	WHERE (p_minrange <= $1) AND (p_maxrange > $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION updComputeGrade(varchar(12), varchar(12), varchar(12)) RETURNS varchar(240) AS $$
DECLARE
	v_qgradeid		integer;
	msg				varchar(240);
BEGIN
	SELECT qgradeid INTO v_qgradeid
	FROM qgrades
	WHERE (qcourseid = CAST($1 as int)) AND ((lecture_marks + lecture_cat_mark) > 100);

	IF(v_qgradeid is null)THEN
		IF($3 = '1')THEN
			UPDATE qgrades SET lecture_gradeid = getdbgradeid(round((lecture_marks + lecture_cat_mark)::double precision)::integer)
			WHERE (qcourseid = CAST($1 as int));

			msg := 'Lecturer Grade Computed Correctly';
		END IF;
		IF($3 = '2')THEN
			UPDATE qgrades SET lecture_gradeid = getPGgradeid(round((lecture_marks + lecture_cat_mark)::double precision)::integer)
			WHERE (qcourseid = CAST($1 as int));

			msg := 'Lecturer Grade Computed Correctly';
		END IF;
	ELSE
		msg := 'Some marks add up to more than 100';
		RAISE EXCEPTION 'Some marks add up to more than 100';
	END IF;
	
	RETURN msg;
END;
$$ LANGUAGE plpgsql;

