CREATE TABLE subjects (
	subject_id 					serial primary key,
	org_id						integer references orgs,
	subject_name				varchar (120),
	details						text
);
CREATE INDEX subjects_org_id ON subjects (org_id);

CREATE TABLE staff (
	staff_id					serial primary key,
	entity_id					integer references entitys,
	org_id						integer references orgs,
	staff_role					varchar (60),
		
	full_name					varchar (120),
	surname 					varchar(50) NOT NULL,
	first_name 					varchar(50) NOT NULL,
  	middle_name 				varchar(50),
  	date_of_birth 				date,
  	gender 						character varying(1),
 	phone						character varying(120),
  	primary_email				character varying(120),
  	
  	place_of_birth				character varying(50),
  	marital_status 				character varying(2),
  	appointment_date 			timestamp default now(),
 
  	exit_date 					date,
  	picture_file 				varchar(32),
  	active 						boolean NOT NULL DEFAULT true,
  	language 					character varying(320),
	interests 					text,
	narrative					text
);
CREATE INDEX staff_org_id ON staff (org_id);
CREATE INDEX staff_entity_id ON staff (entity_id);

CREATE TABLE stream_classes (
	stream_class_id					serial primary key,
	org_id						integer references orgs,
	class_level					integer,
	stream						varchar(60),
	narrative					varchar(320),
	details						text
);
CREATE INDEX stream_classes_org_id ON stream_classes (org_id);
--
CREATE TABLE students (
	student_id					serial primary key,
	entity_id					integer references entitys,
	org_id						integer references orgs,
	class_id					integer references stream_classes,
	
	student_name				varchar(50) not null,
	Sex							varchar(1),
	nationality					varchar(2) not null references sys_countrys,
	birth_date					date not null,
	address						varchar(50),
	zipcode						varchar(50),
	town						varchar(50),
	country_code_id				char(2) not null references sys_countrys,
	telno						varchar(50),
	email						varchar(240),
	
	fathers_name				varchar(320),
	fathers_tel_no				varchar(50),
	fathers_email				varchar(240),

	mothers_name				varchar(320),
	mothers_tel_no				varchar(50),
	mothers_email				varchar(240),

	guardian_name				varchar(50),
	g_address					varchar(50),
	g_zipcode					varchar(50),
	g_town						varchar(50),
	g_countrycodeid				char(2) not null references sys_countrys,
	g_telno						varchar(50),
	g_email						varchar(240),
	
	current_contact				text,
	registrar_details			text,
	details						text
);

CREATE INDEX students_org_id ON students (org_id);
CREATE INDEX students_entity_id ON students (entity_id);
CREATE INDEX students_class_id ON students (class_id);
CREATE INDEX students_nationality ON students (nationality);
CREATE INDEX students_country_code_id ON students (country_code_id);
CREATE INDEX students_g_countrycodeid ON students (g_countrycodeid);

---Project Database File


CREATE TABLE grades (
	grade_id 					varchar(2) primary key,
	org_id						integer references orgs,
	grade_range					real,
	details						text
);
CREATE INDEX grades_org_id ON grades (org_id);

CREATE TABLE sessions (
<<<<<<< HEAD
	session_id					serial primary key,
=======
	sesion_id					serial primary key,
>>>>>>> 0d1345827be20df978696da1bb70570deef519cf
	org_id						integer references orgs,
	session_name				varchar(32),
	session_start_date			date,
	session_end_date			date,
	details						text
);

CREATE INDEX session_org_id ON sessions(org_id);

CREATE TABLE students_session (
	student_session_id			serial primary key,
	org_id 						integer references orgs,
	session_id					integer	references sessions,
	student_id					integer references students,
	details						text
);
CREATE INDEX students_session_org_id ON students_session(org_id);
CREATE INDEX students_session_student_id ON students_session(student_id);


CREATE TABLE exams (
	exam_id							serial primary key,
	session_id					integer references sessions,
	subject_id					integer references subjects,
<<<<<<< HEAD
	class_level					integer references stream_classes,				
=======
	class_level					integer references stream_classes,				,
>>>>>>> 0d1345827be20df978696da1bb70570deef519cf
	org_id							integer references orgs,
	exam_file						varchar(32),
	exam_narrative					text
);
CREATE INDEX exams_org_id on exams(org_id);
CREATE INDEX exams_session_id on exams(session_id);
CREATE INDEX exams_subject_id on exams(subject_id);
CREATE INDEX exams_class_level on exams(class_level);


CREATE TABLE timetable (
	timetable_id				serial primary key,
	class_id					integer references stream_classes,
	session_id					integer references sessions,
	subject_id					integer references subjects,
	staff_id					integer references staff,	
	org_id						integer references orgs,
	monday						boolean not null default false,
	tuesday						boolean not null default false,
	wednesday					boolean not null default false,
	thursday					boolean not null default false,
	friday						boolean not null default false,
	saturday					boolean not null default false,
	start_time					time,
	end_time					time,
	narrative					text
);
CREATE INDEX timetable_class_id ON timetable(class_id);
CREATE INDEX timetable_org_id ON timetable(org_id);
CREATE INDEX timetable_session_id ON timetable(session_id);
CREATE INDEX timetable_subject_id ON timetable(subject_id);
CREATE INDEX timetable_staff_id ON timetable(staff_id);

