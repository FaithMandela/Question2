
ALTER TABLE qstudents ADD approved_hours		real;
ALTER TABLE qstudents ADD approved_fees			real;

ALTER TABLE approvallist ADD narrative			varchar(120);


CREATE OR REPLACE FUNCTION ins_qstudents() RETURNS trigger AS $$
DECLARE
	myrec RECORD;
	mystr VARCHAR(120);
BEGIN
	SELECT org_id INTO NEW.org_id
	FROM charges
	WHERE (charge_id = NEW.charge_id);

	IF(TG_OP = 'UPDATE')THEN
		IF (OLD.approved = false) AND (NEW.approved = true) THEN
			IF (NEW.finaceapproval = false) THEN
				RAISE EXCEPTION 'You cannot close without financial approval';
			END IF;
		END IF;
		
		IF (OLD.finaceapproval = false) AND (NEW.finaceapproval = true) THEN
			SELECT hours, totalfees INTO NEW.approved_hours, NEW.approved_fees
			FROM studentquarterview
			WHERE (qstudentid = NEW.qstudentid);
		END IF;

		IF (OLD.finaceapproval = true) AND (NEW.finaceapproval = false) THEN
			NEW.finalised := false;
			NEW.printed := false;
			NEW.approved := false;
		END IF;
		
		IF (OLD.finalised = true) AND (NEW.finalised = false) THEN
			NEW.finaceapproval := false;
			NEW.printed := false;
			NEW.approved := false;
			NEW.majorapproval := false;		
		END IF;

		IF (OLD.withdraw = false) AND (NEW.withdraw = true) THEN
			NEW.withdraw_date := current_date;
			NEW.withdraw_rate := calcWithdrawRate();
		END IF;

		IF (OLD.ac_withdraw = false) AND (NEW.ac_withdraw = true) THEN
			NEW.withdraw_date := current_date;
			NEW.withdraw_rate := calcWithdrawRate();
		END IF;

		IF(OLD.approve_late_fee = false) AND (NEW.approve_late_fee = true) THEN
			NEW.late_fee_date := current_date;
		END IF;
		
	ELSIF(TG_OP = 'INSERT')THEN
		IF (NEW.approved = true) AND (NEW.finaceapproval = false) THEN
			RAISE EXCEPTION 'You cannot close without financial approval';
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- update the person who finacially approved a student
CREATE OR REPLACE FUNCTION updqstudents() RETURNS trigger AS $$
DECLARE
	v_user_id		varchar(50);
	v_user_ip		varchar(50);
	v_narrative		varchar(120);
	mystr 			varchar(120);
BEGIN

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

	IF (OLD.finaceapproval = false) AND (NEW.finaceapproval = true) THEN
		SELECT 'Hours ' || hours::varchar || ', fees ' || totalfees::varchar INTO v_narrative
		FROM studentquarterview
		WHERE (qstudentid = NEW.qstudentid);
		
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid, narrative)
		VALUES (NEW.qstudentid, v_user_id, 'Finance', now(), v_user_ip, v_narrative);
	END IF;
	
	IF (OLD.exam_clear = false) AND (NEW.exam_clear = true) THEN
		SELECT 'Balance ' || finalbalance::varchar INTO v_narrative
		FROM studentquarterview
		WHERE (qstudentid = NEW.qstudentid);
		
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid, narrative) 
		VALUES (NEW.qstudentid, v_user_id, 'Exam Clear', now(), v_user_ip, v_narrative);
	END IF;

	IF (OLD.finaceapproval = true) AND (NEW.finaceapproval = false) THEN
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid) 
		VALUES (NEW.qstudentid, v_user_id, 'Finance Open', now(), v_user_ip);
	END IF;
	
	IF (OLD.studentdeanapproval = false) AND (NEW.studentdeanapproval = true) THEN
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid) 
		VALUES (NEW.qstudentid, v_user_id, 'Dean', now(), v_user_ip);
	END IF;

	IF (OLD.approved = false) AND (NEW.approved = true) THEN
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid) 
		VALUES (NEW.qstudentid, v_user_id, 'Registry', now(), v_user_ip);
	END IF;

	IF (OLD.withdraw = false) AND (NEW.withdraw = true) THEN
		UPDATE qgrades SET gradeid = 'W' WHERE qstudentID = NEW.qstudentID;
	END IF;

	IF (OLD.ac_withdraw = false) AND (NEW.ac_withdraw = true) THEN
		UPDATE qgrades SET gradeid = 'AW' WHERE qstudentID = NEW.qstudentID;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION approve_finance(varchar(12), varchar(12), varchar(12)) RETURNS varchar(240) AS $$
DECLARE
	v_user_name			varchar(50);
	reca				RECORD;
BEGIN
	
	SELECT qstudentid, finaceapproval, exam_clear INTO reca
	FROM qstudents WHERE (qstudentid = CAST($1 as int));

	SELECT user_name INTO v_user_name
	FROM entitys WHERE (entity_id = CAST($2 as int));

	IF($3 = '1') AND (reca.finaceapproval = false) THEN
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid) 
		VALUES (CAST($1 as int), v_user_name, 'Finance Approval', now(), cast(inet_client_addr() as varchar));

		UPDATE qstudents SET finaceapproval = true
		WHERE (qstudentid = CAST($1 as int));
	END IF;

	IF($3 = '2') AND (reca.finaceapproval = true) THEN
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid) 
		VALUES (CAST($1 as int), v_user_name, 'Finance Opening', now(), cast(inet_client_addr() as varchar));

		UPDATE qstudents SET finaceapproval = false
		WHERE (qstudentid = CAST($1 as int));
	END IF;

	IF($3 = '3') AND (reca.exam_clear = false) THEN
		INSERT INTO approvallist(qstudentid, approvedby, approvaltype, approvedate, clientid) 
		VALUES (CAST($1 as int), v_user_name, 'Exam Clearance', now(), cast(inet_client_addr() as varchar));
		
		UPDATE qstudents SET exam_clear = true, exam_clear_date = now()
		WHERE (qstudentid = CAST($1 as int));
	END IF;

	RETURN 'Approved';
END;
$$ LANGUAGE plpgsql;


