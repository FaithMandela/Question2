

CREATE TABLE content_levels (
	content_level		integer primary key,
	required_courses	integer default 1 not null,
	narrative			varchar(250)
);

ALTER  TABLE students 
ADD sys_audit_trail_id	integer references sys_audit_trail;

CREATE INDEX students_org_id ON students (org_id);
CREATE INDEX students_sys_audit_trail_id ON students (sys_audit_trail_id);

<<<<<<< HEAD
=======
CREATE OR REPLACE FUNCTION getcoursedone(varchar(12), varchar(12)) RETURNS float AS $$
	SELECT max(grades.gradeweight)
	FROM (((qcourses INNER JOIN qgrades ON qcourses.qcourseid = qgrades.qcourseid)
		INNER JOIN qstudents ON qgrades.qstudentid = qstudents.qstudentid)
		INNER JOIN grades ON qgrades.gradeid = grades.gradeid)
		INNER JOIN studentdegrees ON qstudents.studentdegreeid = studentdegrees.studentdegreeid
	WHERE (qstudents.approved = true) AND (qgrades.gradeid <> 'W') AND (qgrades.gradeid <> 'AW')
		AND (qgrades.dropped = false)
		AND (studentdegrees.studentid = $1) AND (qcourses.courseid = $2);		
$$ LANGUAGE SQL;
>>>>>>> b77a21891ef11990fadb44f8af13b2f22a66677d

CREATE OR REPLACE FUNCTION updstudents() RETURNS trigger AS $$
DECLARE
	v_user_id		varchar(50);
	v_user_ip		varchar(50);
BEGIN
	IF (OLD.fullbursary = false) and (NEW.fullbursary = true) THEN
		SELECT user_id, user_ip INTO v_user_id, v_user_ip
		FROM sys_audit_trail
		WHERE (sys_audit_trail_id = NEW.sys_audit_trail_id);
		IF(v_user_id is null)THEN
			v_user_id := current_user;
			v_user_ip := cast(inet_client_addr() as varchar);
		ELSE
			SELECT user_name INTO v_user_id
			FROM entitys WHERE entity_id::varchar = v_user_id;
		END IF;
	
		INSERT INTO sys_audit_trail (user_id, user_ip, table_name, record_id, change_type, narrative)
		VALUES (v_user_id, v_user_ip, 'students', NEW.studentid, 'approve', 'Approve full Bursary');
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_passed(double precision, double precision, integer, varchar(12), varchar(12)) RETURNS boolean AS $$
DECLARE
	passed 				boolean;
	v_required_courses	integer;
	v_courses			integer;
BEGIN
	passed := false;
	
	IF($1 >= $2) THEN
		passed := true;
	ELSIF($3 is not null)THEN
		SELECT count(courseid) INTO v_courses
		FROM courseoutline
		WHERE (content_level = $3) AND (studentid = $4) AND (majorid = $5)
			AND (courseweight >= gradeweight);
		IF(v_courses is null)THEN v_courses := 0; END IF;
		
		SELECT required_courses INTO v_required_courses
		FROM content_levels
		WHERE (content_level = $3);
		IF(v_required_courses is null)THEN v_required_courses := 1; END IF;
		
		IF(v_courses >=  v_required_courses)THEN passed := true; END IF;
	END IF;

    RETURN passed;
END;
$$ LANGUAGE plpgsql;
<<<<<<< HEAD
			
=======


DROP VIEW coregradeview;
DROP VIEW qcoursecheckpass;
DROP VIEW studentchecklist;
DROP VIEW coursechecklist;

CREATE VIEW coursechecklist AS
	SELECT DISTINCT courseoutline.orderid, courseoutline.studentid, courseoutline.studentdegreeid, courseoutline.degreeid, 
		courseoutline.degreelevelid, courseoutline.description, courseoutline.courseid,
		courseoutline.coursetitle, courseoutline.minor, courseoutline.elective, courseoutline.credithours, courseoutline.nogpa, courseoutline.gradeid,
		courseoutline.content_level, courseoutline.gradeweight, courseoutline.courseweight, courseoutline.prereqpassed,
		
		get_passed(courseoutline.courseweight, courseoutline.gradeweight, courseoutline.content_level, courseoutline.studentid, courseoutline.majorid) as coursepased
		
	FROM courseoutline;

	
CREATE VIEW studentchecklist AS
	SELECT coursechecklist.orderid, coursechecklist.studentid, coursechecklist.studentdegreeid, coursechecklist.degreeid, 
		coursechecklist.degreelevelid, coursechecklist.description, coursechecklist.courseid,
		coursechecklist.coursetitle, coursechecklist.minor, coursechecklist.elective, coursechecklist.credithours, coursechecklist.nogpa, coursechecklist.gradeid,
		coursechecklist.courseweight, coursechecklist.coursepased, coursechecklist.prereqpassed,
		students.studentname
	FROM coursechecklist INNER JOIN students ON coursechecklist.studentid = students.studentid;

	
CREATE VIEW qcoursecheckpass AS
	SELECT coursechecklist.orderid, coursechecklist.studentid, coursechecklist.studentdegreeid, coursechecklist.degreeid, coursechecklist.description,
		coursechecklist.minor, coursechecklist.elective, coursechecklist.gradeid,
		coursechecklist.gradeweight, coursechecklist.courseweight, coursechecklist.coursepased, coursechecklist.prereqpassed,
		qcourseview.org_id, qcourseview.schoolid, qcourseview.schoolname, qcourseview.departmentid, qcourseview.departmentname,
		qcourseview.degreelevelid, qcourseview.degreelevelname, qcourseview.coursetypeid, qcourseview.coursetypename,
		qcourseview.courseid, qcourseview.credithours, qcourseview.maxcredit, qcourseview.iscurrent,
		qcourseview.nogpa, qcourseview.yeartaken, qcourseview.mathplacement, qcourseview.englishplacement,
		qcourseview.instructorid, qcourseview.quarterid, qcourseview.qcourseid, qcourseview.classoption, qcourseview.maxclass,
		qcourseview.labcourse, qcourseview.extracharge, qcourseview.approved, qcourseview.attendance, qcourseview.oldcourseid,
		qcourseview.fullattendance, qcourseview.instructorname, qcourseview.coursetitle,
		qcourseview.levellocationid, qcourseview.levellocationname
	FROM coursechecklist INNER JOIN qcourseview ON (coursechecklist.courseid = qcourseview.courseid) AND (coursechecklist.degreelevelid = qcourseview.degreelevelid)
	WHERE (qcourseview.active = true) AND (qcourseview.approved = false) 
		AND (coursechecklist.coursepased = false) AND (coursechecklist.prereqpassed = true);

CREATE VIEW coregradeview AS 
	SELECT studentgradeview.schoolid, studentgradeview.schoolname, studentgradeview.studentid, studentgradeview.studentname, studentgradeview.sex,
		studentgradeview.degreeid, studentgradeview.degreename, studentgradeview.studentdegreeid, studentgradeview.quarterid, studentgradeview.quarteryear,
		studentgradeview.quarter, studentgradeview.coursetypeid, studentgradeview.coursetypename, studentgradeview.courseid, studentgradeview.nogpa,
		studentgradeview.instructorid, studentgradeview.qcourseid, studentgradeview.classoption, studentgradeview.labcourse, studentgradeview.instructorname,
		studentgradeview.coursetitle, studentgradeview.qgradeid, studentgradeview.hours, studentgradeview.credit, studentgradeview.gpa, studentgradeview.gradeid,
		studentgradeview.repeated, studentgradeview.gpahours, studentgradeview.chargehours, 
		corecourseoutline.description, corecourseoutline.minor, corecourseoutline.elective,
		corecourseoutline.contenttypeid, corecourseoutline.contenttypename
	FROM corecourseoutline INNER JOIN studentgradeview ON (corecourseoutline.studentdegreeid = studentgradeview.studentdegreeid) AND (corecourseoutline.courseid = studentgradeview.courseid)
	WHERE (studentgradeview.approved = true) AND (corecourseoutline.minor = false);
>>>>>>> b77a21891ef11990fadb44f8af13b2f22a66677d
