

CREATE TABLE school_officers (
	school_officer_id	serial primary key,
	schoolid			varchar(12) references schools,
	entity_id			integer references entitys,
	org_id				integer references orgs,
	details				text,
	UNIQUE(entity_id)
);
CREATE INDEX school_officers_schoolid ON school_officers (schoolid);
CREATE INDEX school_officers_entity_id ON school_officers (entity_id);
CREATE INDEX school_officers_org_id ON school_officers (org_id);


CREATE VIEW vw_school_officers AS
	SELECT schools.schoolid, schools.schoolname,
		entitys.entity_id, entitys.entity_name, entitys.user_name,
		school_officers.org_id, school_officers.school_officer_id, school_officers.details
	FROM school_officers INNER JOIN schools ON school_officers.schoolid = schools.schoolid
		INNER JOIN entitys ON school_officers.entity_id = entitys.entity_id;


CREATE OR REPLACE FUNCTION get_officer_school(integer) RETURNS varchar(16) AS $$
	SELECT school_officers.schoolid
	FROM school_officers
	WHERE (school_officers.entity_id = $1);
$$ LANGUAGE SQL;


DROP VIEW qstudentsummary;
DROP VIEW qcurrstudentdegreeview;
DROP VIEW qstudentdegreeview;

CREATE VIEW qstudentdegreeview AS
	SELECT students.studentid, students.studentname, students.Sex, students.Nationality, students.MaritalStatus,
		students.birthdate, students.email, 
		departments.schoolid, departments.departmentid, departments.departmentname,
		studentdegrees.studentdegreeid, studentdegrees.degreeid,
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
		INNER JOIN departments ON students.departmentid = departments.departmentid
		LEFT JOIN qresidenceview ON qstudents.qresidenceid = qresidenceview.qresidenceid);
		
CREATE VIEW qcurrstudentdegreeview AS 
	SELECT qstudentdegreeview.studentid, qstudentdegreeview.studentname, qstudentdegreeview.sex, 
		qstudentdegreeview.nationality, qstudentdegreeview.maritalstatus, qstudentdegreeview.birthdate, qstudentdegreeview.email, 
		qstudentdegreeview.schoolid, qstudentdegreeview.departmentid, qstudentdegreeview.departmentname,
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
	
	