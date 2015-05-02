

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
	ELSIF (myrec.app_age < '14 years'::interval) THEN
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

