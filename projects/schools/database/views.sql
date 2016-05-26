CREATE VIEW vw_subjects AS 
		SELECT subjects.org_id,subjects.subject_id, subjects.subject_name, subjects.details
	FROM subjects;

CREATE VIEW vw_staff AS 
		SELECT entitys.entity_id, entitys.entity_name,
		staff.org_id, staff.staff_id, staff.staff_role, staff.full_name, staff.surname, staff.first_name, staff.middle_name, staff.date_of_birth, staff.gender, staff.phone, staff.primary_email, staff.place_of_birth,
		staff.marital_status, staff.appointment_date, staff.exit_date, staff.picture_file, staff.active, staff.language, staff.interests, staff.narrative
	FROM staff JOIN entitys ON staff.entity_id = entitys.entity_id;

CREATE OR REPLACE VIEW vw_stream_classes AS
		SELECT stream_classes.org_id, 
		stream_classes.stream_class_id, stream_classes.class_level, stream_classes.stream, stream_classes.narrative, stream_classes.details
	FROM stream_classes;

CREATE OR REPLACE VIEW vw_students AS 
		SELECT entitys.entity_id, entitys.entity_name,
		stream_classes.stream_class_id, stream_classes.stream,
		sys_countrys.sys_country_id, sys_countrys.sys_country_name,
		students.org_id, students.student_id, students.student_name,
		 students.sex, students.nationality, students.birth_date, students.address, students.zipcode,
		 students.town, students.country_code_id, students.telno, students.email, students.fathers_name, students.fathers_tel_no, students.fathers_email, students.mothers_name, students.mothers_tel_no, students.mothers_email, students.guardian_name, students.g_address, students.g_zipcode, students.g_town, students.g_countrycodeid, students.g_telno, students.g_email, students.current_contact, students.registrar_details, students.details
	FROM students	
		JOIN stream_classes ON students.stream_class_id = stream_classes.stream_class_id
		JOIN entitys ON students.entity_id = entitys.entity_id
		JOIN sys_countrys ON students.country_code_id = sys_countrys.sys_country_id;
		
CREATE VIEW vw_grades AS 
		SELECT grades.org_id, grades.grade_id, grades.grade_range, grades.details
	FROM grades;

CREATE VIEW vw_sessions AS 
		SELECT sessions.org_id, sessions.session_id, sessions.session_name, sessions.session_start_date, sessions.session_end_date, sessions.details
	FROM sessions;

CREATE VIEW vw_students_session AS 
		SELECT sessions.session_id, sessions.session_name,
		students.student_id, students.student_name,
		students_session.org_id, 
		students_session.student_session_id, students_session.details
	FROM students_session	
		JOIN sessions ON students_session.session_id = sessions.session_id
		JOIN students ON students_session.student_id = students.student_id;

CREATE VIEW vw_exams AS 
		SELECT sessions.session_id, sessions.session_name, 
		stream_classes.stream_class_id, stream_classes.stream,
		exams.org_id, exams.exam_id, exams.class_level, exams.exam_file, exams.exam_narrative
	FROM exams
		JOIN sessions ON exams.session_id = sessions.session_id
		JOIN stream_classes ON exams.class_level = stream_classes.stream_class_id
		JOIN subjects ON exams.subject_id = subjects.subject_id;


CREATE VIEW vw_timetable AS 
		SELECT  sessions.session_id, sessions.session_name, 
		staff.staff_id, staff.surname,
		stream_classes.stream_class_id, stream_classes.stream, 
		subjects.org_id, subjects.subject_id, subjects.subject_name,
		timetable.timetable_id,timetable.monday, timetable.tuesday, timetable.wednesday, timetable.thursday, timetable.friday, timetable.saturday, timetable.start_time, timetable.end_time, timetable.narrative
	FROM timetable	
		JOIN stream_classes ON timetable.stream_class_id = stream_classes.stream_class_id
		JOIN subjects ON timetable.subject_id = subjects.subject_id
		JOIN staff ON timetable.staff_id = staff.staff_id
		JOIN sessions ON timetable.session_id = sessions.session_id;
		
CREATE VIEW vw_exams_subjects AS
	SELECT exams.exam_id, exams.exam_name, 
	subjects.subject_id, subjects.subject_name, 
	exams_subjects.org_id, exams_subjects.exams_subjects_id, exams_subjects.exam_file, exams_subjects.exam_description, exams_subjects.narrative
	FROM exams_subjects
		JOIN exams ON exams_subjects.exam_id = exams.exam_id
		JOIN subjects ON exams_subjects.subject_id = subjects.subject_id;

CREATE VIEW vw_fees_structure AS
	SELECT sessions.session_id, sessions.session_name,
	stream_classes.stream_class_id, stream_classes.stream,
	fees_structure.org_id, fees_structure.fees_structure_id, fees_structure.fees_amount,  fees_structure.additional_amounts, fees_structure.description
	FROM fees_structure
		JOIN sessions ON fees_structure.session_id = sessions.session_id
		JOIN stream_classes ON fees_structure.stream_class_id = stream_classes.stream_class_id;

CREATE VIEW vw_students_fees AS
	SELECT fees_structure.fees_structure_id,
	students.student_id, students.student_name,
	students_fees.student_fee_id, students_fees.fees_charged, students_fees.fees_paid, students_fees.paid_date, students_fees.fees_balance, students_fees.cleared, students_fees.description
	FROM students_fees
	INNER JOIN fees_structure ON students_fees.fees_structure_id = fees_structure.fees_structure_id
	INNER JOIN students ON students_fees.student_id = students.student_id;


CREATE VIEW vw_applicant AS
	SELECT orgs.org_id, orgs.org_name, sessions.session_id, sessions.session_name, 
	stream_classes.stream_class_id, stream_classes.stream,
	 students.student_id, students.student_name, sys_countrys.sys_country_id, 
	 sys_countrys.sys_country_name, applicant.applicant_name, applicant.applicant_dob, 
	 applicant.applicants_address, applicant.gender, applicant.country_code_id, applicant.telno,
	 applicant.email, applicant.approve_status, applicant.workflow_table_id, applicant.action_date, 
	 applicant.fathers_name, applicant.fathers_tel_no, applicant.fathers_email, applicant.mothers_name,
	 applicant.mothers_tel_no, applicant.mothers_email, applicant.guardian_name, applicant.g_address,
	 applicant.g_zipcode, applicant.g_town, applicant.g_countrycodeid, applicant.g_telno, applicant.g_email,
	  applicant.current_contact, applicant.registrar_details, applicant.details
	FROM applicant
	INNER JOIN orgs ON applicant.org_id = orgs.org_id
	INNER JOIN sessions ON applicant.session_id = sessions.session_id
	INNER JOIN stream_classes ON applicant.stream_class_id = stream_classes.stream_class_id
	INNER JOIN students ON applicant.student_id = students.student_id
	INNER JOIN sys_countrys ON applicant.g_countrycodeid = sys_countrys.sys_country_id;
