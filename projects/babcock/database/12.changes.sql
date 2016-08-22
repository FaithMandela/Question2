
ALTER TABLE residences 
ADD	min_level			integer default 100,
ADD	max_level			integer default 500,
ADD	majors				text;


ALTER TABLE studentpayments ADD old_amount			real;

CREATE OR REPLACE FUNCTION updstudentpayments() RETURNS trigger AS $$
DECLARE
	reca 					RECORD;
	old_studentpaymentid 	integer;
BEGIN
	SELECT departments.schoolid, departments.departmentid, students.accountnumber, qstudents.quarterid, qstudents.studylevel 
		INTO reca
	FROM ((departments INNER JOIN students ON students.departmentid = departments.departmentid)
		INNER JOIN studentdegrees ON students.studentid = studentdegrees.studentid)
		INNER JOIN qstudents ON studentdegrees.studentdegreeid = qstudents.studentdegreeid
	WHERE (qstudents.qstudentid = NEW.qstudentid);

	IF (TG_OP = 'INSERT') THEN
		SELECT studentpaymentid INTO old_studentpaymentid
		FROM studentpayments 
		WHERE (approved = false) AND (qstudentid = NEW.qstudentid);

		IF(old_studentpaymentid is not null)THEN
			RAISE EXCEPTION 'You have another uncleared payment, ammend that first and pay';
		END IF;
	ELSE
		IF(OLD.approved = true) AND (NEW.approved = true)THEN
			IF(OLD.amount <> NEW.amount)THEN
				RAISE EXCEPTION 'You cannot change amount value after transaction approval.';
			END IF;
		ELSE
			IF(OLD.amount <> NEW.amount)THEN
				new.old_amount := NEW.amount;
			END IF;
		END IF;
	END IF;

	IF (reca.schoolid = 'COEN') THEN
		NEW.terminalid = '7000000089';
	ELSE
		NEW.terminalid = '0690000082';
	END IF;

	IF(NEW.narrative is null) THEN
		NEW.narrative = CAST(NEW.studentpaymentid as text) || ';Pay;' || reca.quarterid || ';' || reca.accountnumber;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
