---Project Database File
CREATE TABLE account_types (
	id int(11) NOT NULL AUTO_INCREMENT,
	name varchar(100) NOT NULL,
	charge_mode varchar(2) NOT NULL,
	run_mode varchar(1) NOT NULL,
	payment_direction varchar(1) NOT NULL,
	enabled bit(1) NOT NULL,
	amount decimal(15,6) NOT NULL,
	account_type_id int(11) NOT NULL,
	invoice_mode varchar(1) DEFAULT NULL,
	description longtext,
	enabled_since datetime DEFAULT NULL,
	day tinyint(4) DEFAULT NULL,
	hour tinyint(4) DEFAULT NULL,
	free_base decimal(15,6) DEFAULT NULL,
	transfer_type_id int(11) NOT NULL,
	recurrence_number int(11) DEFAULT NULL,
	recurrence_field int(11) DEFAULT NULL,
);


CREATE TABLE accounts (
	id int(11) NOT NULL AUTO_INCREMENT,
	currency_id int(11) NOT NULL,
	subclass varchar(1) NOT NULL,
	creation_date datetime NOT NULL,
	last_closing_date date DEFAULT NULL,
	owner_name varchar(255) NOT NULL,
	type_id int(11) DEFAULT NULL,
	credit_limit decimal(15,6) DEFAULT NULL,
	upper_credit_limit decimal(15,6) DEFAULT NULL,
	member_id int(11) DEFAULT NULL,
	member_status varchar(1) DEFAULT NULL,
	last_low_units_sent datetime DEFAULT NULL,
	member_action varchar(1) DEFAULT NULL
);

CREATE TABLE account_fee_amounts (
	id int(11) NOT NULL AUTO_INCREMENT,
	account_id int(11) NOT NULL,
	date date NOT NULL,
	available_balance decimal(18,6) NOT NULL,
	amount decimal(15,6) NOT NULL,
	account_fee_id int(11) NOT NULL
);
