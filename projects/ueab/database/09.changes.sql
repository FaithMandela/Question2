

DROP VIEW fullsummary;
DROP VIEW schoolmajorsummary;
DROP VIEW qstudentmajorsummary;
DROP VIEW qstudentmajorview;
DROP VIEW vw_apply_grad_year;
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
		
		to_char(grad_apply_date, 'Mon YYYY') as grad_apply_month,
		to_char(grad_accept_date, 'Mon YYYY') as grad_accept_month,
		to_char(grad_accept_date, 'YYYY') as grad_accept_year,
		
		getcoremajor(studentdegrees.studentdegreeid) as core_major,
		getcummcredit(studentdegrees.studentdegreeid) as cumm_credits,
		getcummgpa(studentdegrees.studentdegreeid) as cumm_gpa
	FROM ((studentview INNER JOIN studentdegrees ON studentview.studentid = studentdegrees.studentid)
		INNER JOIN sublevelview ON studentdegrees.sublevelid = sublevelview.sublevelid)
		INNER JOIN degrees ON studentdegrees.degreeid = degrees.degreeid;
		
CREATE VIEW vw_apply_grad_year AS
	SELECT grad_accept_year as apply_grad_year
	FROM vw_studentdegrees
	WHERE (graduated = true)
	GROUP BY grad_accept_year
	ORDER BY grad_accept_year;
	
	
	
CREATE VIEW qstudentmajorview AS 
	SELECT studentmajorview.religionid, studentmajorview.religionname, studentmajorview.denominationid, studentmajorview.denominationname,
		studentmajorview.schoolid as studentschoolid, studentmajorview.schoolname as studentschoolname, studentmajorview.studentid,
		studentmajorview.studentname, studentmajorview.Nationality, studentmajorview.Nationalitycountry, studentmajorview.Sex,
		studentmajorview.MaritalStatus, studentmajorview.birthdate, 
		studentmajorview.degreelevelid, studentmajorview.degreelevelname,
		studentmajorview.freshman, studentmajorview.sophomore, studentmajorview.junior, studentmajorview.senior,
		studentmajorview.levellocationid, studentmajorview.levellocationname,
		studentmajorview.sublevelid, studentmajorview.sublevelname, studentmajorview.specialcharges,
		studentmajorview.degreeid, studentmajorview.degreename,
		studentmajorview.studentdegreeid, studentmajorview.completed, studentmajorview.started, studentmajorview.cleared, studentmajorview.clearedate,
		studentmajorview.graduated, studentmajorview.graduatedate, studentmajorview.dropout, studentmajorview.transferin, studentmajorview.transferout,
		studentmajorview.mathplacement, studentmajorview.englishplacement,
		studentmajorview.schoolid, studentmajorview.schoolname, studentmajorview.departmentid, studentmajorview.departmentname,
		studentmajorview.majorid, studentmajorview.majorname, studentmajorview.electivecredit, studentmajorview.domajor, studentmajorview.dominor,
		studentmajorview.majoroptionid, studentmajorview.majoroptionname, studentmajorview.primarymajor,
		studentmajorview.studentmajorid, studentmajorview.major, studentmajorview.nondegree, studentmajorview.premajor,
		qstudents.org_id, qstudents.qstudentid, qstudents.quarterid, qstudents.charges as additionalcharges, 
		qstudents.approved, qstudents.probation,
		qstudents.roomnumber, qstudents.currbalance, qstudents.finaceapproval, qstudents.majorapproval,
		qstudents.departapproval, qstudents.overloadapproval, qstudents.finalised, qstudents.printed,
		qstudents.noapproval, qstudents.exam_clear, qstudents.exam_clear_date, qstudents.exam_clear_balance,
		qstudents.qresidenceid,
		quarters.active, quarters.closed,
		substring(quarters.quarterid from 1 for 9)  as quarteryear, 
		trim(substring(quarters.quarterid from 11 for 2)) as quarter
	FROM (studentmajorview INNER JOIN qstudents ON studentmajorview.studentdegreeid = qstudents.studentdegreeid)
		INNER JOIN quarters ON qstudents.quarterid = quarters.quarterid;

CREATE VIEW qstudentmajorsummary AS
	SELECT qstudentmajorview.schoolid, qstudentmajorview.schoolname, qstudentmajorview.departmentid, qstudentmajorview.departmentname,
		qstudentmajorview.degreelevelid, qstudentmajorview.degreelevelname, qstudentmajorview.sublevelid, qstudentmajorview.sublevelname,
		qstudentmajorview.majorid, qstudentmajorview.majorname, qstudentmajorview.premajor, qstudentmajorview.major,qstudentmajorview.probation,
		qstudentmajorview.studentdegreeid, qstudentmajorview.primarymajor,
		qstudentmajorview.sex, qstudentmajorview.quarterid, count(qstudentmajorview.studentdegreeid) as studentcount
	FROM qstudentmajorview
	GROUP BY qstudentmajorview.schoolid, qstudentmajorview.schoolname, qstudentmajorview.departmentid, qstudentmajorview.departmentname,
		qstudentmajorview.degreelevelid, qstudentmajorview.degreelevelname, qstudentmajorview.sublevelid, qstudentmajorview.sublevelname,
		qstudentmajorview.majorid, qstudentmajorview.majorname, qstudentmajorview.premajor, qstudentmajorview.major,
		qstudentmajorview.studentdegreeid, qstudentmajorview.primarymajor,qstudentmajorview.probation,
		qstudentmajorview.sex, qstudentmajorview.quarterid;

		
CREATE VIEW schoolmajorsummary AS
	SELECT qstudentmajorview.quarterid, substring(quarterid from 1 for 9) as quarteryear, 
		substring(quarterid from 11 for 2) as quarter, majorview.schoolname, qstudentmajorview.sex, 
		varchar 'School' as "defination", count(qstudentid) as studentcount
	FROM qstudentmajorview
	INNER JOIN majorview ON majorview.majorid = qstudentmajorview.majorid
	GROUP BY qstudentmajorview.quarterid, substring(quarterid from 1 for 9), substring(quarterid from 11 for 2),majorview.schoolname,qstudentmajorview.sex
	ORDER BY qstudentmajorview.quarterid, substring(quarterid from 1 for 9), substring(quarterid from 11 for 2),majorview.schoolname,qstudentmajorview.sex;


CREATE VIEW fullsummary AS
	(SELECT * FROM schoolmajorsummary) UNION
	(SELECT * FROM levelsummary) UNION
	(SELECT * FROM sublevelsummary) UNION
	(SELECT * FROM newstudentssummary) UNION
	(SELECT * FROM religionsummary) UNION
	(SELECT * FROM denominationsummary) UNION
	(SELECT * FROM nationalitysummary) UNION
	(SELECT * FROM residencesummary) UNION
	(SELECT * FROM locationsummary);
		
		