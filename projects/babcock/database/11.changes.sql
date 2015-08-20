
		
-- update students email address
CREATE OR REPLACE FUNCTION insstudentname() RETURNS trigger AS $$
DECLARE
	v_entity_id			integer;
	v_guardian_id		integer;
BEGIN
	NEW.studentname := UPPER(NEW.surname)	|| ', ' || UPPER(NEW.firstname) || ' ' || UPPER(COALESCE(NEW.othernames, ''));
	NEW.accountnumber := trim(upper(NEW.accountnumber));
	NEW.emailuser := lower(NEW.surname) || lower(replace(NEW.studentid, '/', ''));
	
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


CREATE OR REPLACE FUNCTION insQStudent(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(120) AS $$
DECLARE
	mystud RECORD;
	myrec RECORD;
	mycourse RECORD;
	myquarter RECORD;
	mymajor RECORD;
	mystr VARCHAR(120);
	mydegreeid int;
	creditcount real;
	mycurrqs int;
	mystudylevel int;
	myqresidentid int;
	mylatefees real;
	mycurrbalance real;
	mynarrative VARCHAR(120);
BEGIN
	SELECT s.org_id, s.onprobation, s.residenceid, s.blockname, s.roomnumber,
		s.currentbalance, s.accountnumber, s.newstudent, s.seeregistrar,		
		s.sex, s.nationality, s.maritalstatus, s.birthdate, s.address, s.zipcode, s.town, s.countrycodeid, 
		s.stateid, s.telno, s.mobile, s.email,  s.guardianname, s.gaddress, s.gzipcode, s.gtown, 
		s.gcountrycodeid, s.gtelno, s.gemail, 
		entitys.entity_password, entitys.first_password
		INTO mystud
	FROM students as s INNER JOIN entitys ON s.studentid = entitys.user_name
	WHERE (studentid = $2);

	mydegreeid := getstudentdegreeid($2);
	mystudylevel := getstudylevel(mydegreeid);
	myqresidentid := get_qresidentid(mystud.residenceid, $1);
	
	SELECT majors.majorid, majors.minlevel, majors.maxlevel INTO mymajor
	FROM majors INNER JOIN studentmajors ON majors.majorid = studentmajors.majorid
	WHERE (studentmajors.studentdegreeid = mydegreeid);
	
	SELECT qstudents.qstudentid, studentdegrees.sublevelid INTO myrec
	FROM qstudents INNER JOIN studentdegrees ON qstudents.studentdegreeid = studentdegrees.studentdegreeid
	WHERE (qstudents.studentdegreeid = mydegreeid) AND (qstudents.quarterid = $1);
	
	SELECT qlatereg, qlastdrop, lateregistrationfee, getchargedays(qlatereg, current_date) as latedays,
		lateregistrationfee * getchargedays(qlatereg, current_date) as latefees,
		quarterid, substring(quarterid from 11 for 1) as quarter,
		length(quarterid) as q_length
	INTO myquarter
	FROM quarters WHERE (quarterid = $1);
	
	IF (mystud.currentbalance IS NOT NULL) THEN
		mycurrbalance := mystud.currentbalance;
	ELSIF (mystud.newstudent = true) THEN
		mycurrbalance := 0;
	END IF;

	mylatefees := 0;
	mynarrative := '';
	IF (myquarter.latefees > 0) AND ((mystud.newstudent = false) OR (myquarter.quarter != '1')) THEN 
		mylatefees := myquarter.latefees;
		mynarrative := 'Late Registration fees charges for ' || CAST(myquarter.latedays as text) || ' days at a rate of ' || CAST(myquarter.lateregistrationfee as text) || ' Per day.';
	END IF;

	IF (mystudylevel is null) AND (mymajor.minlevel is not null) THEN
		mystudylevel := mymajor.minlevel;
	ELSIF (mystudylevel is null) THEN
		mystudylevel := 100;
	ELSIF (substring($1 from 11 for 1) = '1') THEN
			mystudylevel := mystudylevel + 100;
	END IF;

	IF (mymajor.maxlevel is not null) THEN
		IF (mystudylevel > mymajor.maxlevel) THEN
			mystudylevel := mymajor.maxlevel;
		END IF;
	ELSE
		IF (mystudylevel > 500) THEN
			mystudylevel := 500;
		END IF;
	END IF;

	IF (myquarter.qlastdrop < current_date) THEN
		RAISE EXCEPTION 'The registration is closed for this session.';
	ELSIF (mystud.sex is null) or (mystud.nationality is null) or (mystud.maritalstatus is null) or (mystud.birthdate is null) THEN
		RAISE EXCEPTION 'Your students details are in complete and need to be updated by registry';
	ELSIF (mystud.address is null) or (mystud.town is null) or (mystud.countrycodeid is null) or (mystud.stateid is null) THEN
		RAISE EXCEPTION 'Your students address details are in complete and need to be updated by registry';
	ELSIF (mystud.telno is null) or (mystud.mobile is null) or (mystud.email is null) THEN
		RAISE EXCEPTION 'Your students contact details are in complete and need to be updated by registry';
	ELSIF (mystud.guardianname is null) THEN
		RAISE EXCEPTION 'Your guardian details are in complete and need to be updated by registry';
	ELSIF (mystud.gaddress is null) or (mystud.gzipcode is null) or (mystud.gtown is null) or (mystud.gcountrycodeid is null) or (mystud.gtelno is null) or (mystud.gemail is null) THEN
		RAISE EXCEPTION 'Your guardian address details are in complete and need to be updated by registry';
	ELSIF (mystud.onprobation = true) THEN
		RAISE EXCEPTION 'Student on Probation cannot proceed.';
	ELSIF (mystud.seeregistrar = true) THEN
		RAISE EXCEPTION 'Cannot Proceed, See Registars office.';
	ELSIF (mystud.entity_password = md5(mystud.first_password)) THEN
		RAISE EXCEPTION 'You must change your password first before proceeding.';
	ELSIF (mystud.accountnumber IS NULL) THEN
		RAISE EXCEPTION 'You must have an account number, contact Finance office.';
	ELSIF (mydegreeid IS NULL) THEN
		RAISE EXCEPTION 'No Degree Indicated contact Registrars Office';
	ELSIF (getcoremajor(mydegreeid) IS NULL) THEN
		RAISE EXCEPTION 'No Major Indicated contact Registrars Office';
	ELSIF ((myrec.sublevelid = 'UGPM') AND (myquarter.q_length <> 12)) THEN
		RAISE EXCEPTION 'Select the session with either 1M, 2M or 3M';
	ELSIF (myrec.qstudentid IS NULL) THEN
		IF (myqresidentid is null) THEN
			INSERT INTO qstudents(quarterid, studentdegreeid, studylevel, currbalance, charges, financenarrative, paymenttype, org_id)
			VALUES ($1, mydegreeid, mystudylevel, mycurrbalance, mylatefees, mynarrative, 1, mystud.org_id);
		ELSE
			INSERT INTO qstudents(quarterid, studentdegreeid, studylevel, qresidenceid, blockname, roomnumber, currbalance, charges, financenarrative, paymenttype, org_id)
			VALUES ($1, mydegreeid, mystudylevel, myqresidentid, mystud.blockname, mystud.roomnumber, mycurrbalance, mylatefees, mynarrative, 1, mystud.org_id);
		END IF;
		
		mycurrqs := getqstudentid($2);
		creditcount := 0;
		FOR mycourse IN SELECT yeartaken, courseid, min(qcourseid) as qcourseid, max(credithours) as credithours
			FROM qcoursecheckpass
			WHERE (elective = false) AND (coursepased = false) AND (prereqpassed = true)
				AND (yeartaken <= (mystudylevel/100)) AND (studentid = $2) AND (quarterid = $1)
			GROUP BY yeartaken, courseid
			ORDER BY yeartaken, courseid
		LOOP
			IF (creditcount < 16) THEN
				INSERT INTO qgrades(qstudentid, qcourseid, hours, credit, approved) 
				VALUES (mycurrqs, mycourse.qcourseid, mycourse.credithours, mycourse.credithours, true);
				creditcount := creditcount + mycourse.credithours;
			END IF;
		END LOOP;
		
		mystr := 'Semester registered confirm course selection and awaiting approval';
	ELSE
		mystr := 'You are already registered for the Semester proceed with course selection';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;


