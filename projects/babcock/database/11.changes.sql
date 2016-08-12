

-- update students email address
CREATE OR REPLACE FUNCTION insstudentname() RETURNS trigger AS $$
DECLARE
	v_entity_id			integer;
	v_guardian_id		integer;
BEGIN
	NEW.studentname := UPPER(NEW.surname)	|| ', ' || UPPER(NEW.firstname) || ' ' || UPPER(COALESCE(NEW.othernames, ''));
	NEW.accountnumber := trim(upper(NEW.accountnumber));
	NEW.emailuser := lower(NEW.surname) || lower(replace(NEW.studentid, '/', ''));
	NEW.studentid := trim(upper(NEW.studentid));
	
	SELECT entity_id INTO v_entity_id FROM entitys WHERE user_name = trim(NEW.studentid);
	SELECT entity_id INTO v_guardian_id FROM entitys WHERE user_name = trim('G' || NEW.studentid);

	IF((NEW.birthdate is null) OR (NEW.guardianname is null) OR (NEW.gaddress is null))THEN
		NEW.student_edit = 'allow';
	ELSIF(NEW.address is null) or (NEW.town is null) or (NEW.countrycodeid is null) or (NEW.stateid is null) THEN
		NEW.student_edit = 'allow';
	ELSIF((NEW.telno is null) or (NEW.mobile is null) or (NEW.email is null))THEN
		NEW.student_edit = 'allow';
	ELSE
		NEW.student_edit = 'none';
	END IF;
	
	IF(TG_OP = 'INSERT')THEN
		IF(NEW.firstpasswd is null)THEN
			NEW.firstpasswd := first_password();
		END IF;

		SELECT entity_id INTO v_entity_id FROM entitys WHERE user_name = NEW.studentid;
		IF(v_entity_id is null)THEN
			INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, 
				mail_user, primary_email, 
				function_role, first_password, entity_password)
			VALUES (NEW.org_id, 21, NEW.studentname, trim(NEW.studentid), 
				NEW.emailuser, NEW.emailuser || '@std.babcock.edu.ng', 
				'student', NEW.firstpasswd, md5(NEW.firstpasswd));
		END IF;
		
		IF(v_guardian_id is null)THEN
			INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, 
				mail_user, primary_email, 
				function_role, first_password, entity_password)
			VALUES (NEW.org_id, 22, COALESCE(NEW.guardianname, NEW.studentname), ('G' || trim(NEW.studentid)),
				NEW.emailuser, NEW.emailuser || '@std.babcock.edu.ng', 
				'student', NEW.firstpasswd, md5(NEW.firstpasswd));
		END IF;
	ELSIF(TG_OP = 'UPDATE')THEN
		UPDATE entitys SET entity_name = NEW.studentname, mail_user = NEW.emailuser, primary_email = NEW.emailuser || '@std.babcock.edu.ng'
		WHERE user_name = trim(NEW.studentid);
		
		IF (NEW.guardianname IS NOT NULL) THEN
			IF(v_guardian_id is null)THEN
				INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, 
					mail_user, primary_email, 
					function_role, first_password, entity_password)
				VALUES (NEW.org_id, 22, COALESCE(NEW.guardianname, NEW.studentname), ('G' || trim(NEW.studentid)), 
					NEW.emailuser, NEW.emailuser || '@std.babcock.edu.ng', 
					'student', NEW.firstpasswd, md5(NEW.firstpasswd));
			ELSE
				UPDATE entitys SET entity_name = NEW.guardianname
				WHERE user_name = ('G' || trim(NEW.studentid));
			END IF;
		END IF;
	END IF;

	IF(NEW.org_id = 2)THEN
		NEW.offcampus = true;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- update students email address
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
		UPDATE sun_audits SET studentid = null WHERE studentid = $1;
		
		UPDATE students SET studentid = newid, newstudent = false  WHERE studentid = $1;
		UPDATE studentdegrees SET studentid = newid WHERE studentid is null;
		UPDATE studentrequests SET studentid = newid WHERE studentid is null;
		UPDATE sun_audits SET studentid = newid WHERE studentid = null;
		UPDATE entitys SET user_name = newid WHERE user_name = $1;
		mystr := 'Changes to ' || newid;
	END IF;
	
	RETURN mystr;
END;
$$ LANGUAGE plpgsql;




