CREATE TABLE admission_types(
	admission_type_id		serial primary key,
	org_id					integer references orgs,
	admission_type_name		varchar(50),
	narrative				varchar(225),
	details					text
);
CREATE INDEX admission_types_org_id ON admission_types (org_id);


CREATE TABLE classes (
	class_id					serial primary key,
	org_id						integer references orgs,
	class_level					varchar(50),
	stream						varchar(60),
	max_student					float,
	quorum						float,
	narrative					varchar(320),
	details						text
);
CREATE INDEX classes_org_id ON classes (org_id);

CREATE TABLE grades (
	grade_id 					serial primary key,
	org_id						integer references orgs,
	grade						varchar(5) not null,
	grade_range_from			float not null,
	grade_range_to				float not null,
	grade_points				float,
	grade_desc					varchar(50) ,
	details						varchar(150)
);
CREATE INDEX grades_org_id ON grades (org_id);

CREATE TABLE subject_categorys (
	subject_category_id		serial primary key,
	org_id					integer references orgs,
	category_name			varchar(50),
	narrative				varchar(320),
	details					text
);
CREATE INDEX subject_categorys_org_id ON subject_categorys (org_id);

CREATE TABLE subjects (
	subject_id				serial primary key,
	org_id					integer references orgs,
	subject_category_id		integer references subject_categorys,
	subject_code			varchar(8),
	subject_name			varchar(50),
	narrative				varchar(320),
	details					text,
	UNIQUE(subject_code)	
);
CREATE INDEX subjects_org_id ON subjects (org_id);
CREATE INDEX subjects_subject_category_id ON subjects (subject_category_id);

CREATE TABLE academic_years (
	academic_year_id			serial primary key,
	org_id						integer references orgs,
	academic_year				varchar(9) not null,
	academic_year_start			date not null,
	academic_year_end			date not null,
	is_active					boolean default false not null,
	narrative					varchar(320),
	details						text,
	UNIQUE(academic_year, org_id)
);
CREATE INDEX academic_years_org_id ON academic_years (org_id);

CREATE TABLE sessions (
	session_id				serial primary key,
	academic_year_id		integer references academic_years,
	org_id					integer references orgs,
	session_name			varchar(32),
	session_start_date		date,
	session_end_date		date,
	is_active  				boolean default false not null,
	details					text
);
CREATE INDEX session_academic_year_id ON sessions(academic_year_id);
CREATE INDEX session_org_id ON sessions(org_id);

CREATE TABLE sch_holidays (
	sch_holiday_id		serial primary key,
	academic_year_id		integer references academic_years,
	org_id				integer references orgs,
	holiday_name			varchar(50) not null,
	begin_date			date,
	end_date			date,
	details				text
);
CREATE INDEX sch_holidays_org_id ON sch_holidays (org_id);
CREATE INDEX sch_holidays_academic_year_id ON sch_holidays (academic_year_id);

CREATE TABLE school_events(
	school_event_id 	serial primary key,
	org_id 				integer,
	school_event_name 	character varying(50) NOT NULL,
	start_date 			date,
	start_time 			time,
	end_date 			date,
	end_time			time,
	details 			text
);
CREATE INDEX school_events_org_id ON school_events (org_id);

