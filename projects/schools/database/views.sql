CREATE VIEW vw_subjects AS 
		subjects.org_id,subjects.subject_id, subjects.subject_name, subjects.details
	FROM subjects;

CREATE VIEW vw_staff AS 
		entitys.entity_id, entitys.entity_name,
		staff.org_id, staff.staff_id, staff.staff_role, staff.full_name, staff.surname, staff.first_name, staff.middle_name, staff.date_of_birth, staff.gender, staff.phone, staff.primary_email, staff.place_of_birth,
		staff.marital_status, staff.appointment_date, staff.exit_date, staff.picture_file, staff.active, staff.language, staff.interests, staff.narrative
	FROM staff JOIN entitys ON staff.entity_id = entitys.entity_id;

CREATE VIEW stream_classes AS
		stream_classes.org_id, 
		stream_classes.class_id, stream_classes.stream, stream_classes.narrative, stream_classes.details
	FROM stream_classes;

CREATE VIEW students AS 
		entitys.entity_id, entitys.entity_name,
		stream_classes.class_id, stream_classes.stream,
		countrys.nationality, countrys.country_code_id,
		countrys.g_countrycodeid,students.org_id, students.student_id,
		students.student_name,students.Sex, students.birth_date, students.address,
		students.zipcode, students.town, students.telno, students.email,
		students.fathers_name, students.fathers_tel_no, students.fathers_email,
		students.mothers_name, students.mothers_tel_no, students.mothers_email, 
		students.guardian_name, students.g_address, students.g_zipcode, students.g_town, students.g_telno, students.g_email, students.current_contact, students.registrar_details, students.details
	FROM students	JOIN stream_classes ON students.class_id = stream_classes.class_id
					JOIN entitys ON students.entity_id = entitys.entity_id
					JOIN countrys ON students.nationality = countrys.nationality;

CREATE VIEW vw_grades AS 
		grades.org_id,grades.grade_id, grades.grade_range, grades.details
	FROM grades;

CREATE VIEW sessions AS 
		sessions.org_id,sessions.sessions_id, sessions.session_narrative,
		sessions.session_start_date, sessions.session_end_date, sessions.details
	FROM sessions;

CREATE VIEW students_session AS 
		sessions.sessions_id, sessions.session_narrative,
		students.student_id, students.student_name,
		students_session.org_id, 
		students_session.students_session_id, students_session.details
	FROM students_session	
		JOIN sessions ON students_session.sessions_id = sessions.sessions_id
		JOIN ON students_session.student_id = students.student_id;

CREATE VIEW exams AS 
		exams.org_id,exams.exam_id, exams.exam_file, exams.exam_narrative
	FROM exams;

CREATE VIEW timetable AS 
		stream_classes.class_id, stream_classes.stream,
		subjects.subject_id, subjects.subject_name, 
		sessions.sessions_id, sessions.session_narrative,
		timetable.org_id, timetable.timetable_id, timetable.week_day, timetable.start_time, timetable.end_time, timetable.narrative
	FROM timetable	
		JOIN stream_classes ON timetable.class_id = stream_classes.class_id
		JOIN subjects ON timetable.subject_id = subjects.subject_id
		JOIN sessions ON timetable.sessions_id = sessions.sessions_id;
