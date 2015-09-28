CREATE OR REPLACE FUNCTION getdbgradeid(integer) RETURNS varchar(2) AS $$
	SELECT CASE WHEN max(gradeid) is null THEN 'NG' WHEN $1 = -1 THEN 'DG' ELSE max(gradeid) END
	FROM grades 
	WHERE (minrange <= $1) AND (maxrange > $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getPGgradeid(integer) RETURNS varchar(2) AS $$
	SELECT CASE WHEN max(gradeid) is null THEN 'NG' WHEN $1 = -1 THEN 'DG' ELSE max(gradeid) END
	FROM grades 
	WHERE (p_minrange <= $1) AND (p_maxrange > $1);
$$ LANGUAGE SQL;

 
CREATE OR REPLACE VIEW studentcounty AS
SELECT students.county_id, students.studentid, countys.county_name
FROM students
INNER JOIN countys ON students.county_id=countys.county_id;
 
 CREATE OR REPLACE VIEW qstudentviewc AS
SELECT q.religionid, q.religionname, q.denominationid, q.denominationname, q.schoolid, 
       q.schoolname, q.studentid, q.studentname, q.address, q.zipcode, q.town, q.addresscountry, 
       q.telno, q.email, q.guardianname, q.gaddress, q.gzipcode, q.gtown, q.gaddresscountry, 
       q.gtelno, q.gemail, q.accountnumber, q.nationality, q.nationalitycountry, 
       q.sex, q.maritalstatus, q.birthdate, q.firstpass, q.alumnae, q.postcontacts, 
       q.onprobation, q.offcampus, q.currentcontact, q.currentemail, q.currenttel, 
       q.freshman, q.sophomore, q.junior, q.senior, q.degreeid, q.degreename, q.studentdegreeid, 
       q.completed, q.started, q.cleared, q.clearedate, q.graduated, q.graduatedate, 
       dropout, transferin, transferout, mathplacement, englishplacement, 
       quarterid, qstart, qlatereg, qlatechange, qlastdrop, qend, active, 
       chalengerate, feesline, resline, quarteryear, quarter, closed, 
       q.quarter_name, q.degreelevelid, q.degreelevelname, q.charge_id, q.unit_charge, 
       q.lab_charges, q.exam_fees, q.levellocationid, q.levellocationname, q.sublevelid, 
       q.sublevelname, q.specialcharges, q.sun_posted, q.session_active, q.session_closed, 
       q.general_fees, q.residence_stay, q.currency, q.exchange_rate, q.residenceid, 
       q.residencename, q.capacity, q.defaultrate, q.residenceoffcampus, q.residencesex, 
       q.residencedean, q.qresidenceid, q.residenceoption, q.org_id, q.qstudentid, 
       q.additionalcharges, q.approved, q.probation, q.roomnumber, q.currbalance, 
       q.finaceapproval, q.majorapproval, q.studentdeanapproval, q.intersession, 
       q.exam_clear, q.exam_clear_date, q.exam_clear_balance, q.request_withdraw, 
      q.request_withdraw_date, q.withdraw, q.ac_withdraw, q.withdraw_date, 
       q.withdraw_rate, q.departapproval, q.overloadapproval, q.finalised, q.printed, 
       q.details, q.ucharge, q.residencecharge, q.lcharge, q.feescharge,studentcounty.county_name,studentcounty.county_id
  FROM qstudentview as q
  INNER JOIN studentcounty ON q.studentid= studentcounty.county_id ;
  
ALTER TABLE students
  ADD COLUMN passport boolean DEFAULT false,
  ADD COLUMN national_id  boolean DEFAULT false,
  ADD COLUMN identification_no varchar(20);
  
  
  
CREATE OR REPLACE VIEW qstudentviewid AS 
	SELECT
	qstudentview.denominationname,
	qstudentview.schoolname,
    qstudentview.studentid,
	qstudentview.studentname,
    qstudentview.nationalitycountry,
    qstudentview.sex,
    qstudentview.maritalstatus,
	qstudentview.degreename,
    qstudentview.studentdegreeid,
    qstudentview.quarterid,
    qstudentview.degreelevelname,
    qstudentview.sublevelname,
    qstudentview.approved,
	students.identification_no,
	students.passport,
	students.national_id,
	qstudentview.nationality
    FROM qstudentview
    INNER JOIN students ON qstudentview.studentid=students.studentid;
  
  

UPDATE fields SET question = 'Parent or Guardians commitment: I agree that the applicant may be a student at the University of Eastern Africa, Baraton. I am
ready to support the university in its effort to ensure that the applicant abides by the rules and principles of the university and
accepts the authority of its administration.'
WHERE field_id = 106;


UPDATE fields SET field_size = 150 WHERE field_id = 106;


	
ALTER TABLE charges ADD charge_feesline		float;
ALTER TABLE charges ADD charge_resline		float;

UPDATE fields SET field_fnct = E'to_date(\'#\', \'DD/MM/YYYY\')'
WHERE field_type = 'DATE';

UPDATE fields SET field_type = 'DATE' WHERE field_id = 60;
UPDATE fields SET field_lookup='Yes#No', field_type = 'LIST' WHERE field_id = 61;
UPDATE fields SET field_lookup='SELECT denominationid,denominationname FROM denominations;', field_type = 'SELECT' 
WHERE field_id = 88;
UPDATE fields SET field_lookup='SELECT denominationid,denominationname FROM denominations;', field_type = 'SELECT' 
WHERE field_id = 92;

UPDATE forms SET table_name = 'application_forms' WHERE form_id = 1;


CREATE TABLE application_forms (
	application_form_id	serial primary key,
	markid				integer references marks,
	entity_id			integer references entitys,
	degreeid			varchar(12) references degrees,
	majorid				varchar(12) references majors,
	sublevelid			varchar(12) references sublevels,
	county_id			integer references counties,
	org_id				integer references orgs,
	entry_form_id		integer references entry_forms,
	session_id			varchar(12),
	email				varchar(120),
	entrypass			varchar(32) not null default md5('enter'),
	firstpass			varchar(32) not null default first_password(),
	existingid			varchar(12),
	scheduledate		date not null default current_date,
	applicationdate     date not null default current_date,
	accepted			boolean not null default false,
	premajor			boolean not null default false,

	submitapplication		boolean not null default false,
	submitdate				timestamp,
	isaccepted				boolean not null default false,
	isreported				boolean not null default false,
	isdeferred				boolean not null default false,
	isrejected				boolean not null default false,
	evaluationdate			date,

	homeaddress			varchar(120),
	phonenumber			varchar(50),

	accepteddate		date,

	reported			boolean not null default false,
	reporteddate		date,
	denominationid		varchar(12) references denominations,
	mname				varchar(50),
	fname				varchar(50),
	fdenominationid		varchar(12) references denominations,
	mdenominationid		varchar(12) references denominations,
	foccupation         varchar(50),
	fnationalityid      char(2) references countrys,
	moccupation			varchar(50),
	mnationalityid		char(2) references countrys,	
	parentchurch		boolean,
	parentemployer		varchar(120),
	birthdate			date not null,
	baptismdate			date,
	lastname			varchar(50) not null,
	firstname			varchar(50) not null,
	middlename			varchar(50),
	Sex					varchar(12),
	MaritalStatus		varchar(12),
	nationalityid		char(2) references countrys,
	citizenshipid		char(2) references countrys,
	residenceid			char(2) references countrys,
	firstlanguage		varchar(50),
	otherlanguages		varchar(120),
	churchname			varchar(50),
	churcharea			varchar(50),
	churchaddress		text,
	handicap			varchar(120),
	personalhealth		varchar(50),
	smoke				boolean,
	drink				boolean,
	drugs				boolean,
	hsmoke				boolean,
	hdrink				boolean,
	hdrugs				boolean,
	attendedprimary     varchar(50),
	attendedsecondary   varchar(50),
	expelled			boolean,
	previousrecord		varchar(50),
	workexperience	    varchar(50),
	employername        varchar(50),
	postion				varchar(50),
	attendedueab		boolean not null default false,
	attendeddate		date,
	dateemployed        date,
	campusresidence		varchar(50),
	details				text
);


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
		mystr := 'You have successful approvaled the student';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;


----- Do a backend un approve
CREATE OR REPLACE FUNCTION upd_qunapprove(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(250) AS $$
DECLARE
	mystr			varchar(250);
BEGIN

	UPDATE qstudents SET approved = false, sys_audit_trail_id = $4::int
	WHERE qstudentid = $1::int;
	mystr := 'You have successful approvaled the student';

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ins_qgrades() RETURNS trigger AS $$
DECLARE
	v_approved			boolean;
BEGIN
	
	SELECT org_id, approved INTO NEW.org_id, v_approved
	FROM qstudents
	WHERE (qstudentid = NEW.qstudentid);
	
	IF(v_approved = true)THEN
		RAISE EXCEPTION 'You cannot add a course for an approved student';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

