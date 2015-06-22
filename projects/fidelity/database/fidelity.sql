---Project Database File
CREATE TABLE account_types (
	account_type_id			serial	primary key,
	org_id					integer references orgs,
	account_type_name		varchar(50),
	details					text
);

CREATE TABLE corporate_types (
	corporate_type_id		serial	primary key,
	org_id					integer references orgs,
	corporate_type_name		varchar(50),
	details					text
);

CREATE TABLE clients (
	entity_id				integer references entitys primary key,
	currency_id				integer references currency,
	account_type_id			integer references account_types,
	corporate_type_id		integer references corporate_types,
	country_id				char(2) references sys_countrys,
	org_id					integer references orgs,
	client_name				varchar(50),
	business_address		varchar(100),
	city					varchar(30),
	lga						varchar(50),
	state					varchar(50),
	phone					varchar(50),
	email					varchar(50),
	commencement_date		date,
	incorporation_date		date,
	incorporation_no		varchar(50),
	industry_sector			varchar(50),
	line_of_business		varchar(50),
	annual_revenue			float,
	tax_id_number			varchar(50),
	employees_no			integer,
	activity				varchar(10),
	other_banks				varchar(50),
	approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	details					text
	
);

CREATE TABLE id_types (
	id_type_id				serial	primary key,
	org_id					integer references orgs,
	id_type_name			varchar(50),
	details					text
);


CREATE TABLE directors (
	director_id				serial primary key,
	entity_id				integer references entitys,
	id_type_id				integer references id_types,
	org_id					integer references orgs,
	director_name			varchar(50),
	id_no					varchar(20),
    email					varchar(50),
	gsm_no					varchar(20),
	approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,	
	signatory				bytea,
	details					text	

);

CREATE TABLE loan_types (
	loan_type_id			serial primary key,
	org_id					integer references orgs,
	loan_type_name			varchar(50),
	default_interest		integer,
	details					text
);
CREATE INDEX loan_types_org_id ON loan_types(org_id);

CREATE TABLE loans (
	loan_id 				serial primary key,
	loan_type_id			integer references loan_types,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	loan_date				date not null default current_date,
	principle				real not null,
	interest				real not null,
	monthly_repayment		real not null,
	repayment_period		integer not null CHECK (repayment_period > 0),
    approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	guarantor1_name			varchar(50),
	guarantor1_address		varchar(50),
	guarantor2_name			varchar(50),
	guarantor2_address		varchar(50),
	security1_desc			text,
	security2_desc			text,
	security3_desc			text,
	details				    text
);
CREATE INDEX loans_loan_type_id ON loans(loan_type_id);
CREATE INDEX loans_entity_id ON loans(entity_id);
CREATE INDEX loans_org_id ON loans(org_id);


CREATE VIEW vw_loans AS
	SELECT entitys.entity_id, entitys.entity_name, loan_types.loan_type_id, loan_types.loan_type_name, 
		loans.org_id, loans.loan_id, loans.loan_date, loans.principle, loans.interest, loans.monthly_repayment, 
		loans.repayment_period, loans.approve_status, loans.workflow_table_id, loans.application_date, 
		loans.action_date, loans.details
	FROM loans INNER JOIN entitys ON loans.entity_id = entitys.entity_id
		INNER JOIN loan_types ON loans.loan_type_id = loan_types.loan_type_id;


 INSERT INTO id_types (id_type_name) VALUES ('international passport'),('national drivers licence'),('national id card');
 INSERT INTO account_types (account_type_name) VALUES ('Corporate'),('DBXA starter'),('DBXA growing'),('Established'),('Govt agency'),('MIDs'), ('PMIs'),('Others(specify)');
 INSERT INTO corporate_types (corporate_type_name) VALUES ('PLC'),('LTD'),('Enterprise'),('Ass & club'),('Govt agency'),('Unlimited'),('Partnership'),('Enterprise'),('Others(specify)');
 
 





 
		
		
		

		
