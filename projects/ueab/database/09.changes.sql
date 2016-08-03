


ALTER TABLE studentdegrees ADD expected_grad_date	date;

DROP VIEW vw_apply_grad_year;
DROP VIEW vwgradyear;
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
		studentdegrees.grad_accept, studentdegrees.grad_accept_date, studentdegrees.expected_grad_date,
		
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
		
		
CREATE VIEW vwgradyear AS
	SELECT EXTRACT(YEAR FROM graduatedate) as gradyear
	FROM vw_studentdegrees
	WHERE (graduated = true)
	GROUP BY EXTRACT(YEAR FROM graduatedate)
	ORDER BY EXTRACT(YEAR FROM graduatedate);

CREATE VIEW vw_apply_grad_year AS
	SELECT grad_accept_year as apply_grad_year
	FROM vw_studentdegrees
	WHERE (graduated = true)
	GROUP BY grad_accept_year
	ORDER BY grad_accept_year;