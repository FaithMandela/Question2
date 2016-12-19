---Project Database File

CREATE TABLE institution(
	inst_id 		serial primary key,
	inst_name		varchar(90),
	school_name		varchar(80)
);

CREATE TABLE lecturers (
	lec_id			serial primary key,
	lec_name			varchar(80),
	faculty_name		varchar(80),
	inst_id      		integer
);
CREATE TABLE department(
	dep_id 		serial primary key,
	dep_name			varchar(90),
	supervisor_name		varchar(80),
	inst-id				integer
);

CREATE TABLE staff (
	staff_id			serial primary key,
	staff_name			varchar(80),
	dep_id      		integer,
	inst-id				integer
);
