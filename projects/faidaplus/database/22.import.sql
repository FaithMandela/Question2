
-- load extension first time after install
CREATE EXTENSION mysql_fdw;

-- create server object
CREATE SERVER mysql_server
	FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host '127.0.0.1', port '3306');

-- create user mapping
CREATE USER MAPPING FOR postgres SERVER mysql_server
OPTIONS (username 'root');

CREATE FOREIGN TABLE i_salutation (
	id_salutation			integer, 
	salutation			varchar(7), 
	"order"			integer
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'salutation');

CREATE FOREIGN TABLE i_staff (
	id_staff			integer, 
	"group"			char(7), 
	comp_position			varchar(37), 
	rel_id_salutation			integer, 
	first_name			varchar(22), 
	last_name			varchar(22), 
	other_name			varchar(37), 
	email			varchar(150), 
	cellphone			varchar(22), 
	landline			varchar(22), 
	shipping			VARCHAR, 
	rel_id_staff			integer
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'staff');

CREATE FOREIGN TABLE i_user (
	id_user			integer, 
	rel_id			integer, 
	newsletter			char(1), 
	email			varchar(191), 
	new_email			varchar(191), 
	email_token			varchar(15), 
	username			varchar(23), 
	"password"			varchar(15), 
	salt			varchar(192), 
	hash			varchar(192), 
	sign_up_token			varchar(15), 
	password_token			varchar(15), 
	create_date			timestamp, 
	last_login			timestamp, 
	active			char(1), 
	rel_id_user_status			integer, 
	permanent			char(1), 
	"group"			char(7), 
	archive			integer, 
	cellphone			varchar(15), 
	profile_photo			varchar(75), 
	sms_alert			char(1), 
	email_alert			char(1)
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'user');



CREATE FOREIGN TABLE i_agency (
	id_agency			integer, 
	rel_id_agency			integer, 
	agency_name			varchar(191), 
	pcc			varchar(3), 
	rel_pcc			varchar(3), 
	rel_id_staff			integer, 
	status			char(1), 
	date_added			timestamp, 
	last_production			DATE, 
	rel_id_town			integer, 
	iata			char(1), 
	galileo			char(1), 
	amadeus			char(1), 
	sabre			char(1)
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'agency');


