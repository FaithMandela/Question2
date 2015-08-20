

DROP TABLE app_students;
CREATE TABLE app_students (
	app_student_id		integer primary key,
	student_number		serial,
	studentid			varchar(12),
	departmentid		varchar(12),
	denominationid		varchar(12),
	org_id				integer references orgs,
	surname				varchar(50) not null,
	firstname			varchar(50) not null,
	othernames			varchar(50),
	Sex					varchar(1),
	Nationality			char(2) references countrys,
	MaritalStatus		varchar(2),
	birthdate			date,
	address				varchar(240),
	zipcode				varchar(50),
	town				varchar(50),
	countrycodeid		char(2) references countrys,
	stateid				integer references states,
	telno				varchar(50),
	mobile				varchar(75),
	BloodGroup			varchar(12),
	email				varchar(240),
	guardianname		varchar(150),
	gaddress			varchar(250),
	gzipcode			varchar(50),
	gtown				varchar(50),
	gcountrycodeid		char(2) references countrys,
	gtelno				varchar(50),
	gemail				varchar(240),

	degreeid			varchar(12) references degrees,
	sublevelid			varchar(12) references sublevels,
	
	majorid				varchar(12),
	
	account_number		varchar(50),
	e_tranzact_no		varchar(50),
	first_password		varchar(50),
	
	denomination_name	varchar(50),
	state_name			varchar(50),
	degree_name			varchar(50),
	programme_name		varchar(50),
	
	is_picked			boolean default false
);
