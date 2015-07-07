
CREATE TABLE countys(

county_id		char(2) primary key,
county_name		varchar(50)


);

ALTER TABLE students 
ADD COLUMN disability varchar(5),
ADD COLUMN dis_details text,
ADD COLUMN county_id char(2) references countys;

CREATE INDEX students_county_id ON students (county_id);

INSERT INTO countys(county_id, county_name)
VALUES	('MO', 'Mombasa'),
		('KW','Kwale'),
		('KI','Kilifi'),
		('TR','Tana River'),
		('LA','Lamu'),
		('TT','Taita-Taveta'),
		('GA','Garissa'),
		('WA','Wajir'),
		('MA','Mandera'),
		('MR','Marsabit'),
		('IS','Isiolo'),
		('ME','Meru'),
		('TN','Tharaka-Nithi'),
		('EB','Embu'),
		('KT','Kitui'),
		('MC','Machakos'),
		('MK','Makueni'),
		('NY','Nyandarua'),
		('NR','Nyeri'),
		('KR','Kirinyaga'),
		('MU','Muranga'),
		('KB','Kiambu'),
		('TK','Turkana'),
		('WP','West Pokot'),
		('SA','Samburu'),
		('TZ','Trans Nzoia'),
		('UG','Uasin Gishu'),
		('EM','Elgeyo-Marakwet'),
		('ND','Nandi'),
		('BR','Baringo'),
		('LP','Laikipia'),
		('NK','Nakuru'),
		('NO','Narok'),
		('KJ','kajiado');
		
	
ALTER TABLE grades
ADD COLUMN p_minrange integer,
ADD COLUMN p_maxrange integer;
	

CREATE OR REPLACE FUNCTION ins_application() RETURNS trigger AS $$
DECLARE
	reca			RECORD;
	v_org_id		INTEGER;
BEGIN	
	IF(NEW.selection_id is not null) THEN
		IF(TG_WHEN = 'BEFORE')THEN
			IF((NEW.user_name is null) OR (NEW.primary_email is null))THEN
				RAISE EXCEPTION 'You need to enter the email address';
			END IF;

			IF(NEW.user_name != NEW.primary_email)THEN
				RAISE EXCEPTION 'The email and confirmation email should match.';
			END IF;

			SELECT org_id INTO v_org_id
			FROM forms WHERE (form_id = NEW.selection_id);

			NEW.user_name := lower(trim(NEW.user_name));
			NEW.primary_email := lower(trim(NEW.user_name));

			NEW.first_password := upper(substring(md5(random()::text) from 3 for 9));
			NEW.entity_password := md5(NEW.first_password);

			NEW.org_id = v_org_id;

			RETURN NEW;
		END IF;

		IF(TG_WHEN = 'AFTER')THEN
			INSERT INTO entry_forms (org_id, entity_id, entered_by_id, form_id)
			VALUES(NEW.org_id, NEW.entity_id, NEW.entity_id, NEW.selection_id);

			INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name)
			VALUES(NEW.org_id, 1, NEW.entity_id, 'entitys');

			SELECT quarterid INTO reca
			FROM quarters 
			WHERE (quarterid IN (SELECT max(quarterid) FROM quarters));

			INSERT INTO applications (org_id, applicationid, quarterid)
			VALUES(NEW.org_id, NEW.entity_id, reca.quarterid, reca.applicationfees);
		END IF;
	ELSE
		IF(TG_WHEN = 'BEFORE')THEN
			RETURN NEW;
		END IF;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_bf_application BEFORE INSERT ON entitys
    FOR EACH ROW EXECUTE PROCEDURE ins_application();

    
 ALTER TABLE quarters
 ADD COLUMN dean_cert_date date default null,
 ADD COLUMN hon_cert_date date default null,
 ADD COLUMN grad_date date default null;
 
 CREATE OR REPLACE VIEW studentcounty AS
SELECT students.county_id, students.studentid, countys.county_name
FROM students
INNER JOIN countys ON students.county_id=countys.county_id;
 
 CREATE OR REPLACE VIEW qstudentviewc AS
SELECT q.religionid, q.religionname, q.denominationid, q.denominationname, q.schoolid, 
       q.schoolname, q.studentid, q.studentname, q.address, q.zipcode, q.town, q.addresscountry, 
       q.telno, q.email, q.guardianname, q.gaddress, q.gzipcode, q.gtown, q.gaddresscountry, 
       q.gtelno, q.gemail, q.accountnumber, q.nationality, q.nationalitycountry, 
       q.sex, q.maritalstatus, q.birthdate, q.firstpass, q.alumnae, q.postcontacts, 
       q.onprobation, q.offcampus, q.currentcontact, q.currentemail, q.currenttel, 
       q.freshman, q.sophomore, q.junior, q.senior, q.degreeid, q.degreename, q.studentdegreeid, 
       q.completed, q.started, q.cleared, q.clearedate, q.graduated, q.graduatedate, 
       dropout, transferin, transferout, mathplacement, englishplacement, 
       quarterid, qstart, qlatereg, qlatechange, qlastdrop, qend, active, 
       chalengerate, feesline, resline, quarteryear, quarter, closed, 
       q.quarter_name, q.degreelevelid, q.degreelevelname, q.charge_id, q.unit_charge, 
       q.lab_charges, q.exam_fees, q.levellocationid, q.levellocationname, q.sublevelid, 
       q.sublevelname, q.specialcharges, q.sun_posted, q.session_active, q.session_closed, 
       q.general_fees, q.residence_stay, q.currency, q.exchange_rate, q.residenceid, 
       q.residencename, q.capacity, q.defaultrate, q.residenceoffcampus, q.residencesex, 
       q.residencedean, q.qresidenceid, q.residenceoption, q.org_id, q.qstudentid, 
       q.additionalcharges, q.approved, q.probation, q.roomnumber, q.currbalance, 
       q.finaceapproval, q.majorapproval, q.studentdeanapproval, q.intersession, 
       q.exam_clear, q.exam_clear_date, q.exam_clear_balance, q.request_withdraw, 
      q.request_withdraw_date, q.withdraw, q.ac_withdraw, q.withdraw_date, 
       q.withdraw_rate, q.departapproval, q.overloadapproval, q.finalised, q.printed, 
       q.details, q.ucharge, q.residencecharge, q.lcharge, q.feescharge,studentcounty.county_name,studentcounty.county_id
  FROM qstudentview as q
  INNER JOIN studentcounty ON q.studentid= studentcounty.county_id ;
  
  
  
  
 



