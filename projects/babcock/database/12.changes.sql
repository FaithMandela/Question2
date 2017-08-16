
DROP VIEW qstudentsummary;
DROP VIEW qcurrstudentdegreeview;
DROP VIEW qstudentdegreeview;

ALTER TABLE qstudents ADD so_approval			boolean default false not null;


CREATE VIEW qstudentdegreeview AS
	SELECT students.studentid, students.departmentid, students.studentname, students.Sex, students.Nationality, students.MaritalStatus,
		students.birthdate, students.email, studentdegrees.studentdegreeid, studentdegrees.degreeid,
		sublevels.sublevelid, sublevels.degreelevelid, sublevels.levellocationid, sublevels.sublevelname,
        qstudents.qstudentid, qstudents.quarterid, qstudents.charges, 
		qstudents.probation, qstudents.roomnumber, qstudents.currbalance, qstudents.applicationtime, qstudents.studylevel,
		qstudents.finalised, qstudents.finaceapproval, qstudents.majorapproval, qstudents.chaplainapproval, qstudents.studentdeanapproval, 
		qstudents.overloadapproval, qstudents.overloadhours, qstudents.intersession, qstudents.closed, qstudents.printed, qstudents.approved, qstudents.noapproval,
		qstudents.org_id, qstudents.so_approval,
		qresidenceview.residenceid, qresidenceview.residencename, qresidenceview.defaultrate,
		qresidenceview.offcampus, qresidenceview.Sex as residencesex, qresidenceview.residencedean, qresidenceview.charges as residencecharges,
		qresidenceview.qresidenceid, qresidenceview.residenceoption, (qresidenceview.qresidenceid || 'R' || qstudents.roomnumber) as roomid  
	FROM (((students INNER JOIN (studentdegrees INNER JOIN sublevels ON studentdegrees.sublevelid = sublevels.sublevelid) ON students.studentid = studentdegrees.studentid)
		INNER JOIN qstudents ON studentdegrees.studentdegreeid = qstudents.studentdegreeid)
		LEFT JOIN qresidenceview ON qstudents.qresidenceid = qresidenceview.qresidenceid);
		
CREATE VIEW qcurrstudentdegreeview AS 
	SELECT qstudentdegreeview.studentid, qstudentdegreeview.departmentid, qstudentdegreeview.studentname, qstudentdegreeview.sex, 
		qstudentdegreeview.nationality, qstudentdegreeview.maritalstatus, qstudentdegreeview.birthdate, qstudentdegreeview.email, 
		qstudentdegreeview.studentdegreeid, qstudentdegreeview.degreeid, qstudentdegreeview.sublevelid, qstudentdegreeview.qstudentid, 
		qstudentdegreeview.quarterid, qstudentdegreeview.charges, qstudentdegreeview.probation, qstudentdegreeview.roomnumber, 
		qstudentdegreeview.currbalance, qstudentdegreeview.finaceapproval, qstudentdegreeview.studylevel, 
		qstudentdegreeview.finalised, qstudentdegreeview.majorapproval, 
		qstudentdegreeview.chaplainapproval, qstudentdegreeview.overloadapproval, 
		qstudentdegreeview.studentdeanapproval, qstudentdegreeview.overloadhours, qstudentdegreeview.intersession, 
		qstudentdegreeview.closed, qstudentdegreeview.printed, qstudentdegreeview.approved, qstudentdegreeview.noapproval, 
		qstudentdegreeview.org_id, qstudentdegreeview.so_approval,
		qstudentdegreeview.qresidenceid, qstudentdegreeview.residenceid, qstudentdegreeview.residencename, qstudentdegreeview.roomid
	FROM qstudentdegreeview JOIN quarters ON qstudentdegreeview.quarterid = quarters.quarterid
	WHERE quarters.active = true;

CREATE VIEW qstudentsummary AS
	SELECT qsd.studentid, qsd.studentname, qsd.quarterid, qsd.approved, qsd.studentdegreeid, qsd.qstudentid,
		qsd.sex, qsd.Nationality, qsd.MaritalStatus, qsd.studylevel, qsd.org_id,
		getcurrcredit(qsd.qstudentid) as credit, getcurrgpa(qsd.qstudentid) as gpa,
		getcummcredit(qsd.studentdegreeid, qsd.quarterid) as cummcredit,
		getcummgpa(qsd.studentdegreeid, qsd.quarterid) as cummgpa, 
		quarters.publishgrades
	FROM qstudentdegreeview as qsd INNER JOIN quarters ON qsd.quarterid = quarters.quarterid;
	
CREATE OR REPLACE FUNCTION approve_so(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(240) AS $$
DECLARE
	mystr VARCHAR(120);
BEGIN
	UPDATE qstudents SET so_approval = true WHERE (qstudentid = $1::integer);
	mystr := 'School officers approval';
	RETURN mystr;
END;
$$ LANGUAGE plpgsql;

