


--------- Stupid clean up work

CREATE OR REPLACE FUNCTION deldupstudent(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	myrec RECORD;
	myreca RECORD;
	myrecb RECORD;
	myrecc RECORD;
	myqtr RECORD;
	newid VARCHAR(16);
	mystr VARCHAR(120);
BEGIN
	IF($2 is null) THEN 
		newid := $3 || substring($1 from 3 for 5);
	ELSE
		newid := $2;
	END IF;
	
	SELECT INTO myrec studentid, studentname FROM students WHERE (studentid = newid);
	SELECT INTO myreca studentdegreeid, studentid FROM studentdegrees WHERE (studentid = $2);
	SELECT INTO myrecb studentdegreeid, studentid FROM studentdegrees WHERE (studentid = $1);
	SELECT INTO myrecc a.studentdegreeid, a.quarterid FROM
	((SELECT studentdegreeid, quarterid FROM qstudents WHERE studentdegreeid = myreca.studentdegreeid)
	EXCEPT (SELECT studentdegreeid, quarterid FROM qstudents WHERE studentdegreeid = myrecb.studentdegreeid)) as a;
	
	IF ($1 = $2) THEN
		mystr := 'That the same ID no change';
	ELSIF (myrecc.quarterid IS NOT NULL) THEN
		mystr := 'Conflict in quarter ' || myrecc.quarterid;
	ELSIF (myreca.studentdegreeid IS NOT NULL) AND (myrecb.studentdegreeid IS NOT NULL) THEN
		UPDATE qstudents SET studentdegreeid = myreca.studentdegreeid WHERE studentdegreeid = myrecb.studentdegreeid;
		UPDATE studentrequests SET studentid = $2 WHERE studentid = $1;
		DELETE FROM studentmajors WHERE studentdegreeid = myrecb.studentdegreeid;
		DELETE FROM studentdegrees WHERE studentdegreeid = myrecb.studentdegreeid;
		DELETE FROM students WHERE studentid = $1;	
		mystr := 'Changes to ' || $2;
	ELSIF (myrec.studentid is not null) THEN
		UPDATE studentdegrees SET studentid = $2 WHERE studentid = $1;
		UPDATE studentrequests SET studentid = $2 WHERE studentid = $1;
		DELETE FROM students WHERE studentid = $1;
		mystr := 'Changes to ' || $2;
	ELSIF ($2 is null) THEN
		DELETE FROM studentdegrees WHERE studentid is null;
		UPDATE studentdegrees SET studentid = null WHERE studentid = $1;
		UPDATE studentrequests SET studentid = null WHERE studentid = $1;
		UPDATE sun_audits SET studentid = null WHERE studentid = $1;
		
		UPDATE students SET studentid = newid, newstudent = false  WHERE studentid = $1;
		UPDATE studentdegrees SET studentid = newid WHERE studentid is null;
		UPDATE studentrequests SET studentid = newid WHERE studentid is null;
		UPDATE sun_audits SET studentid = newid WHERE studentid = null;
		UPDATE entitys SET user_name = newid WHERE user_name = $1;
		mystr := 'Changes to ' || newid;
	ELSIF ($2 is not null) AND (newid is not null) THEN
		DELETE FROM studentdegrees WHERE studentid is null;
		UPDATE studentdegrees SET studentid = null WHERE studentid = $1;
		UPDATE studentrequests SET studentid = null WHERE studentid = $1;
		UPDATE probation_list SET studentid = null WHERE studentid = $1;
		UPDATE sun_audits SET studentid = null WHERE studentid = $1;
		
		UPDATE students SET studentid = newid, newstudent = false  WHERE studentid = $1;
		UPDATE studentdegrees SET studentid = newid WHERE studentid is null;
		UPDATE studentrequests SET studentid = newid WHERE studentid is null;
		UPDATE sun_audits SET studentid = newid WHERE studentid = null;
		UPDATE probation_list SET studentid = newid WHERE studentid = null;
		UPDATE entitys SET user_name = newid WHERE user_name = $1;
		mystr := 'Changes to ' || newid;
	END IF;
	
	RETURN mystr;
END;
$$ LANGUAGE plpgsql;

DELETE FROM students WHERE studentid IN
(SELECT students.studentid
FROM students LEFT JOIN studentdegrees ON students.studentid = studentdegrees.studentid
WHERE studentdegrees.studentid is null);


ALTER TABLE students ADD old_studentid varchar(12);
UPDATE students SET old_studentid = studentid;

ALTER TABLE qstudents DISABLE TRIGGER updb_qstudents;
ALTER TABLE studentdegrees ALTER COLUMN studentid DROP NOT NULL;

SELECT a.studentid, deldupstudent(a.studentid, '16/' || lpad(a.rnum::text, 4, '0'), null)

FROM (SELECT studentdegrees.studentid, min(substr(qstudents.quarterid, 1, 4)) as study_year,
row_number() OVER () as rnum
FROM studentdegrees INNER JOIN qstudents ON studentdegrees.studentdegreeid = qstudents.studentdegreeid
WHERE studentdegrees.studentid not like '%/%'
GROUP BY studentdegrees.studentid
ORDER BY studentdegrees.studentid) a

WHERE a.study_year = '2016'
ORDER BY a.rnum;

ALTER TABLE studentdegrees ALTER COLUMN studentid SET NOT NULL;
ALTER TABLE qstudents ENABLE TRIGGER updb_qstudents;

