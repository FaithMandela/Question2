
ALTER TABLE entity_types ADD 	start_view				varchar(120);

ALTER TABLE exam_centers ADD center_capacity			integer default 100;

CREATE OR REPLACE FUNCTION select_exam_date(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar AS $$
DECLARE
	v_app_id			int;
	v_exam_id			int;
	v_capacity			int;
	v_count				int;
	v_paid 				boolean;
	msg					varchar;
BEGIN
	v_app_id := CAST($2 AS int);
	v_exam_id := CAST($1 AS int);
	
	SELECT exam_centers.center_capacity INTO v_capacity
	FROM exam_centers INNER JOIN exam_dates ON exam_centers.exam_center_id = exam_dates.exam_center_id
	WHERE (exam_dates.exam_date_id = v_exam_id);
	
	SELECT count(applicationid) INTO v_count
	FROM applications
	WHERE (paid = true) AND (exam_date_id = v_exam_id);
	
	SELECT paid INTO v_paid
	FROM applications
	WHERE (applicationid = v_app_id);

	IF(v_exam_id is null) THEN
		msg:= 'Not Updated';
		RAISE EXCEPTION 'The exam center for this date is full select another one.';
	ELSIF(v_count >= v_capacity) THEN
		msg:= 'Not Updated';
		RAISE EXCEPTION 'The exam center for this date is full select another one.';
	ELSIF(v_paid = false) THEN
		msg:= 'You need to pay before selecting the exam center';
		RAISE EXCEPTION 'You need to pay before selecting the exam center';
	ELSE
		UPDATE applications SET exam_date_id = v_exam_id
		WHERE applicationid = v_app_id;
		msg:= 'Updated'|| ' Application ID ' || v_app_id || ' exam center and date ID ' || v_exam_id;
	END IF;

	RETURN msg;
END;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION submitapplication(varchar(12), varchar(12), varchar(12)) RETURNS VARCHAR(120) AS $$
DECLARE
	myrec				RECORD;
	v_approve_status	VARCHAR(16);
	mystr 				VARCHAR(120);
BEGIN
	SELECT applications.applicationid, applications.exam_date_id, applications.paid, 
		entitys.entity_id, entitys.picture_file,
		registrations.registrationid, registrations.firstchoiceid, registrations.secondchoiceid,
		registrations.denominationid, age(registrations.birthdate) as app_age
	INTO myrec
	FROM applications INNER JOIN registrations ON applications.applicationid = registrations.registrationid
		INNER JOIN entitys ON applications.applicationid = entitys.entity_id
	WHERE (applications.applicationid = CAST($1 as integer));

	SELECT approve_status INTO v_approve_status
	FROM entry_forms
	WHERE (entity_id = myrec.entity_id);

	IF (myrec.picture_file is null) THEN
		mystr := 'You must upload your photo before submission';
	ELSIF (myrec.paid = false) THEN
		mystr := 'You must first make full payment before submiting the application.';
	ELSIF (myrec.exam_date_id is null) THEN
		mystr := 'Select exam center date';
	ELSIF (app_age < '16 years'::interval) THEN
		mystr := 'You need to be older than 16 years to apply for this programme';
	ELSIF (myrec.firstchoiceid is null) THEN
		mystr := 'Select First Programme Choice';
	ELSIF (myrec.secondchoiceid is null) THEN
		mystr := 'Select Second Programme Choice';
	ELSIF (myrec.denominationid is null) THEN
		mystr := 'Select Denomination';
	ELSIF (v_approve_status = 'Draft') THEN
		mystr := 'You need the form submited first';
	ELSE
		UPDATE applications SET openapplication = false
		WHERE (applicationid = myrec.applicationid);

		UPDATE registrations SET submitapplication = true, submitdate = now(), majorid = firstchoiceid
		WHERE (registrationid = myrec.applicationid);

		mystr := 'Submitted the application.';
	END IF;

	RETURN mystr;
END;
$$ LANGUAGE plpgsql;

