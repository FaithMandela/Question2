
CREATE VIEW vw_qresidence AS
	SELECT residences.residenceid, residences.residencename, residences.offcampus, residences.Sex, residences.residencedean, 
		qresidences.qresidenceid, qresidences.quarterid, qresidences.residenceoption, qresidences.charges, qresidences.details,
		qresidences.org_id,
		students.studentid, students.studentname,
		quarters.active,
		resc.res_capacity, resn.resCount, (resc.res_capacity - resn.resCount) as space_left
	FROM ((residences INNER JOIN qresidences ON residences.residenceid = qresidences.residenceid)
	INNER JOIN quarters ON qresidences.quarterid = quarters.quarterid)
	INNER JOIN students ON ((residences.Sex = students.Sex) OR (residences.Sex = 'N'))
	LEFT JOIN (SELECT residenceid, sum(residencecapacitys.capacity) as res_capacity FROM residencecapacitys
			GROUP BY residenceid) as resc
		ON residences.residenceid = resc.residenceid
	LEFT JOIN (SELECT qresidenceid, count(qstudentid) as resCount FROM qstudents
			GROUP BY qresidenceid) as resn
		ON qresidences.qresidenceid = resn.qresidenceid;
		

CREATE OR REPLACE FUNCTION selQResidence(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(120) AS $$
DECLARE
	myrec 				RECORD;
	resrec				RECORD;
	myqstud 			int;
	myres				int;
	resCapacity			int;
	resCount			int;
	v_qstudentid		int;
	allowMajors			boolean;
	mystr 				varchar(120);
BEGIN
	myqstud := getqstudentid($2);
	myres := $1::integer;

	SELECT qstudentid, quarterid, finalised, financeclosed, finaceapproval, mealtype, mealticket, studylevel INTO myrec
	FROM qstudents WHERE (qstudentid = myqstud);
	
	SELECT sex, min_level, max_level, majors INTO resrec
	FROM residences INNER JOIN qresidences ON residences.residenceid = qresidences.residenceid
	WHERE (qresidenceid = myres);	
	
	SELECT sum(residencecapacitys.capacity) INTO resCapacity
	FROM residencecapacitys INNER JOIN qresidences ON residencecapacitys.residenceid = qresidences.residenceid
	WHERE (qresidenceid = myres);
	
	UPDATE qstudents SET qresidenceid = null, financeclosed = false
	FROM vwqstudentbalances 
	WHERE (qstudents.finaceapproval = false) AND (age(qstudents.residence_time) > '1 day'::interval) AND (qstudents.offcampus = false)
		AND (qstudents.qresidenceid is not null) AND (qstudents.quarterid = myrec.quarterid)
		AND (qstudents.qstudentid = vwqstudentbalances.qstudentid) AND (vwqstudentbalances.finalbalance < 10000)
		AND (vwqstudentbalances.finaceapproval = false) AND (vwqstudentbalances.quarterid = myrec.quarterid);
	
	SELECT count(qstudentid) INTO resCount
	FROM qstudents
	WHERE (qresidenceid = myres);
	
	allowMajors := true;
	IF(resrec.majors is not null)THEN
		SELECT qstudents.qstudentid INTO v_qstudentid
		FROM qstudents INNER JOIN qresidences ON qstudents.qresidenceid = qresidences.qresidenceid
			INNER JOIN residences ON qresidences.residenceid = residences.residenceid
			INNER JOIN studentdegrees ON qstudents.studentdegreeid = studentdegrees.studentdegreeid
			INNER JOIN studentmajors ON studentdegrees.studentdegreeid = studentmajors.studentdegreeid
		WHERE (qstudents.qstudentid = myqstud) AND (residences.majors ILIKE '%' || studentmajors.majorid || '%');
		IF(v_qstudentid is not null)THEN
			allowMajors := false;
		END IF;
	END IF;

	IF (myrec.qstudentid is null) THEN
		RAISE EXCEPTION 'Register for the semester first';
	ELSIF (myrec.financeclosed = true) OR (myrec.finaceapproval = true) THEN
		RAISE EXCEPTION 'You cannot make changes after submiting your payment unless you apply on the post for it to be opened by finance.';
	ELSIF (myrec.finalised = true) THEN
		RAISE EXCEPTION 'You have closed the selection.';
	ELSIF (myrec.studylevel < resrec.min_level) OR (myrec.studylevel > resrec.max_level) THEN
		RAISE EXCEPTION 'The study levels allowed are between % and % for your level %', resrec.min_level, resrec.max_level, myrec.studylevel;
	ELSIF (resCount > resCapacity) THEN
		RAISE EXCEPTION 'The residence you have selected is full.';
	ELSIF(allowMajors = false)THEN
		RAISE EXCEPTION 'The hall selected is not for the course you are doing';
	ELSE
		UPDATE qstudents SET qresidenceid = myres, roomnumber = null, residence_time = now() WHERE (qstudentid = myqstud);
		mystr := 'Residence registered. You need to pay fees and get finacial approval today or you will loose the residence selection.';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;


CREATE VIEW ws_hall_service AS
	SELECT studentid, studentname, mealtype, studylevel, majorid, majorname, finaceapproval,
		quarterid, schoolid, schoolname, departmentid, departmentname, residenceid, residencename
	FROM vwqstudentbalances
	WHERE (active = true);