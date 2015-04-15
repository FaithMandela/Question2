

CREATE OR REPLACE FUNCTION selQResidence(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(120) AS $$
DECLARE
	mystr 			VARCHAR(120);
	myrec 			RECORD;
	myqstud 		int;
	myres			int;
	resCapacity		int;
	resCount		int;
BEGIN
	myqstud := getqstudentid($2);
	myres := CAST($1 AS integer);

	SELECT qstudentid, finalised, financeclosed, finaceapproval, mealtype, mealticket INTO myrec
	FROM qstudents WHERE (qstudentid = myqstud);
	
	SELECT sum(residencecapacitys.capacity) INTO resCapacity
	FROM residencecapacitys INNER JOIN qresidences ON residencecapacitys.residenceid = qresidences.residenceid
	WHERE (qresidenceid = myres);
	IF(resCapacity is null) THEN resCapacity := 0; END IF;
	
	SELECT count(qstudentid) INTO resCount
	FROM qstudents WHERE (qresidenceid = myres);
	IF(resCount is null) THEN resCount := 0; END IF;

	IF (myrec.qstudentid is null) THEN
		RAISE EXCEPTION 'Register for the semester first';
	ELSIF (myrec.financeclosed = true) OR (myrec.finaceapproval = true) THEN
		RAISE EXCEPTION 'You cannot make changes after submiting your payment unless you apply on the post for it to be opened by finance.';
	ELSIF (myrec.finalised = true) THEN
		RAISE EXCEPTION 'You have closed the selection.';
	ELSIF (resCount > resCapacity) THEN
		RAISE EXCEPTION 'The residence you have selected is full.';
	ELSE
		UPDATE qstudents SET qresidenceid = myres, roomnumber = null WHERE (qstudentid = myqstud);
		mystr := 'Residence registered awaiting approval';
	END IF;

    RETURN mystr;
END;
$$ LANGUAGE plpgsql;

-- update students email address
CREATE OR REPLACE FUNCTION insstudentname() RETURNS trigger AS $$
DECLARE
	v_entity_id		integer;
BEGIN
	NEW.studentname := UPPER(NEW.surname)	|| ', ' || UPPER(NEW.firstname) || ' ' || UPPER(COALESCE(NEW.othernames, ''));
	NEW.accountnumber := trim(upper(NEW.accountnumber));
	NEW.emailuser := lower(NEW.surname) || lower(replace(NEW.studentid, '/', ''));

	IF(TG_OP = 'INSERT')THEN
		NEW.firstpasswd = first_password();

		SELECT entity_id INTO v_entity_id FROM entitys WHERE user_name = NEW.studentid;
		IF(v_entity_id is null)THEN
			
			INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, 
				mail_user, primary_email, 
				function_role, first_password, entity_password)
			VALUES (NEW.org_id, 21, NEW.studentname, NEW.studentid, 
				NEW.emailuser, NEW.emailuser || '@std.babcock.edu.ng', 
				'student', NEW.firstpasswd, md5(NEW.firstpasswd));
				
			INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, 
				mail_user, primary_email, 
				function_role, first_password, entity_password)
			VALUES (NEW.org_id, 22, COALESCE(NEW.guardianname, NEW.studentname), ('G' || NEW.studentid), 
				NEW.emailuser, NEW.emailuser || '@std.babcock.edu.ng', 
				'student', NEW.firstpasswd, md5(NEW.firstpasswd));
		END IF;
	ELSIF(TG_OP = 'UPDATE')THEN
		UPDATE entitys SET entity_name = NEW.studentname, mail_user = NEW.emailuser, primary_email = NEW.emailuser || '@std.babcock.edu.ng'
		WHERE user_name = NEW.studentid;
		
		IF (OLD.guardianname IS NULL) and (NEW.guardianname IS NOT NULL) THEN
			UPDATE entitys SET entity_name = NEW.guardianname
			WHERE user_name = ('G' || NEW.studentid);
		END IF;
	END IF;

	IF(NEW.org_id = 2)THEN
		NEW.offcampus = true;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP VIEW vw_students;
CREATE VIEW vw_students AS
	SELECT denominationview.religionid, denominationview.religionname, denominationview.denominationid, denominationview.denominationname,
		schools.schoolid, schools.schoolname, departments.departmentid, departments.departmentname,
		students.studentid, students.studentname, students.address, students.zipcode, students.town, 
		students.seeregistrar, students.seesecurity,
		c1.countryname as addresscountry, students.telno, students.email,  students.guardianname, students.gaddress,
		students.gzipcode, students.gtown, c2.countryname as gaddresscountry, students.gtelno, students.gemail,
		students.accountnumber, students.Nationality, c3.countryname as Nationalitycountry, students.Sex,
		students.MaritalStatus, students.birthdate, students.firstpasswd, students.alumnae, students.postcontacts, students.onprobation,
		students.offcampus, students.currentcontact, students.staff, students.fullbursary, students.newstudent, 
		students.picturefile, students.emailuser, students.matriculate, students.details, 
		students.etranzact_card_no, students.org_id,
		entitys.first_password, ('G' || students.studentid) as gstudentid
	FROM (((denominationview INNER JOIN students ON denominationview.denominationid = students.denominationid)
		INNER JOIN departments ON departments.departmentid = students.departmentid)
		INNER JOIN schools ON schools.schoolid = departments.schoolid)
		INNER JOIN countrys as c1 ON students.countrycodeid = c1.countryid
		INNER JOIN countrys as c2 ON students.gcountrycodeid = c2.countryid
		INNER JOIN countrys as c3 ON students.Nationality = c3.countryid
		INNER JOIN entitys ON students.studentid = entitys.user_name;
		
CREATE VIEW vw_active_studentid AS
	SELECT studentdegrees.studentid
	FROM studentdegrees INNER JOIN qstudents ON studentdegrees.studentdegreeid = qstudents.studentdegreeid
		INNER JOIN quarters ON qstudents.quarterid = quarters.quarterid
	WHERE (quarters.active = true) AND (qstudents.approved = true)
	GROUP BY studentdegrees.studentid;
GRANT ALL ON radcheck TO radius;

CREATE OR REPLACE VIEW radcheck (id, username, attribute, op, value) AS
	SELECT entity_id, user_name, 'MD5-Password'::character(12), ':='::character(2), entity_password
	FROM entitys INNER JOIN vw_active_studentid ON entitys.user_name = vw_active_studentid.studentid
	WHERE (entity_type_id = 21) AND (is_active = true);
GRANT ALL ON radcheck TO radius;
	
	