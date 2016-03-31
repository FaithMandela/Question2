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
		students.org_id, students.student_id, students.class_id, students.student_name, students.sex, students.nationality, students.birth_date, students.address, students.zipcode, students.town, students.country_code_id, students.telno, students.email, students.fathers_name, students.fathers_tel_no, students.fathers_email, students.mothers_name, students.mothers_tel_no, students.mothers_email, students.guardian_name, students.g_address, students.g_zipcode, students.g_town, students.g_countrycodeid, students.g_telno, students.g_email, students.current_contact, students.registrar_details, students.details
	FROM students	
		JOIN stream_classes ON students.class_id = stream_classes.stream_class_id
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
		timetable.timetable_id, timetable.class_id, timetable.monday, timetable.tuesday, timetable.wednesday, timetable.thursday, timetable.friday, timetable.saturday, timetable.start_time, timetable.end_time, timetable.narrative
	FROM timetable	
		JOIN stream_classes ON timetable.class_id = stream_classes.stream_class_id
		JOIN subjects ON timetable.subject_id = subjects.subject_id
		JOIN staff ON timetable.staff_id = staff.staff_id
		JOIN sessions ON timetable.session_id = sessions.session_id;
