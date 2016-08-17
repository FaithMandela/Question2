

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


CREATE OR REPLACE FUNCTION generate_charges(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_year				integer;
	v_quarter			varchar(2);
	v_old_qid			varchar(12);

	msg 				varchar(120);
BEGIN

	msg := 'No Function selected';
	
	SELECT substring(quarters.quarterid from 1 for 4)::integer, 
		trim(substring(quarters.quarterid from 11 for 2)) INTO v_year, v_quarter
	FROM quarters
	WHERE quarterid = $1;
	
	v_old_qid := (v_year-1)::varchar(4) || '/' || v_year::varchar(4) || '.' || v_quarter;

	IF ($3 = '1') THEN
		INSERT INTO qresidences (quarterid, residenceid, org_id, residenceoption, charges, full_charges, active, details)
		SELECT $1, a.residenceid, a.org_id, a.residenceoption, a.charges, a.full_charges, a.active, a.details
		FROM qresidences a LEFT JOIN 
			(SELECT qresidenceid, residenceid FROM qresidences WHERE quarterid = $1) as b ON a.residenceid = b.residenceid
		WHERE (a.quarterid = v_old_qid) AND (b.qresidenceid is null);
		
		INSERT INTO qcharges(quarterid, degreelevelid, org_id, studylevel, fullfees, 
			fullmeal2fees, fullmeal3fees, fees, meal2fees, meal3fees, premiumhall, 
			minimalfees, firstinstalment, firstdate, secondinstalment, seconddate, narrative, sublevelid)
		SELECT $1, a.degreelevelid, a.org_id, a.studylevel, a.fullfees, 
			a.fullmeal2fees, a.fullmeal3fees, a.fees, a.meal2fees, a.meal3fees, a.premiumhall, 
			a.minimalfees, a.firstinstalment, a.firstdate, a.secondinstalment, a.seconddate, a.narrative, a.sublevelid
		FROM qcharges a LEFT JOIN 
			(SELECT qchargeid, degreelevelid, studylevel FROM qcharges WHERE quarterid = $1) b
		ON (a.degreelevelid = b.degreelevelid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qchargeid is null);
		
		INSERT INTO qmcharges(quarterid, majorid, org_id, studylevel, charge, fullcharge, 
			meal2charge, meal3charge, phallcharge, narrative, sublevelid)
		SELECT $1, a.majorid, a.org_id, a.studylevel, a.charge, a.fullcharge, 
			a.meal2charge, a.meal3charge, a.phallcharge, a.narrative, a.sublevelid
		FROM qmcharges a LEFT JOIN 
			(SELECT qmchargeid, majorid, studylevel FROM qmcharges WHERE quarterid = $1) b
		ON (a.majorid = b.majorid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qmchargeid is null);
		
		msg := 'Charges Generated';
	END IF;

	IF ($3 = '2') THEN
		INSERT INTO qchargedefinations(quarterid, chargetypeid, studylevel, amount, narrative, sublevelid, org_id)
		SELECT $1, a.chargetypeid, a.studylevel, a.amount, a.narrative, a.sublevelid, a.org_id
		FROM qchargedefinations a LEFT JOIN
			(SELECT qchargedefinationid, chargetypeid, studylevel FROM qchargedefinations WHERE quarterid = $1) b
		ON (a.chargetypeid = b.chargetypeid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qchargedefinationid is null);
		
		INSERT INTO qmchargedefinations(quarterid, chargetypeid, majorid, org_id, studylevel, amount, narrative, sublevelid)
		SELECT $1, a.chargetypeid, a.majorid, a.org_id, a.studylevel, a.amount, a.narrative, a.sublevelid
		FROM qmchargedefinations a LEFT JOIN
			(SELECT qmchargedefinationid, chargetypeid, majorid, studylevel FROM qmchargedefinations WHERE quarterid = $1) b
		ON (a.chargetypeid = b.chargetypeid) AND (a.majorid = b.majorid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qmchargedefinationid is null);
	
		msg := 'Charges Defination Generated';
	END IF;	

	RETURN msg;
END;
$$ LANGUAGE plpgsql;




