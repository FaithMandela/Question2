
---Project Database File
DELETE FROM currency where currency_id != 1;
INSERT INTO departments (org_id, department_id, ln_department_id, department_name) VALUES (0, 1, 1, 'Administration'); 

INSERT INTO entitys (entity_id, org_id, entity_type_id, use_key_id, user_name, entity_name, primary_email, entity_leader, super_user, no_org, first_password,function_role)
VALUES (2, 0, 0, 0, 'admin', 'admin', 'admin@admin.com', true, false, false, 'baraza','admin');

INSERT INTO entitys (entity_id, org_id, entity_type_id, use_key_id, user_name, entity_name, primary_email, entity_leader, super_user, no_org, first_password,function_role)
VALUES (3, 0, 0, 0, 'member', 'member', 'member@member.com', true, false, false, 'baraza','member');

--INSERT INTO members( entity_id, member_id, org_id, person_title,  surname, first_name, middle_name, 
  --          gender, primary_email, active, expired, contribution)
    --VALUES (0,0,0, 'mr', 'Member','member', 'member', 'm', 'member@member.com','true','false',0)


SELECT pg_catalog.setval('entitys_entity_id_seq', 3, true);

CREATE TABLE payment_types (
	payment_type_id			serial primary key,
	org_id					integer references orgs,
	payment_type_name		varchar (50),
	payment_narrative 		text
);
CREATE INDEX payment_types_org_id ON payment_types (org_id);

CREATE TABLE bank_accounts (
	bank_account_id			serial primary key,
	org_id					integer references orgs,
	bank_branch_id			integer references bank_branch,
	bank_account_name		varchar(120),
	bank_account_number		varchar(50),
    narrative				varchar(240),
	is_default				boolean default false not null,
	is_active				boolean default true not null,
    details					text
);
CREATE INDEX bank_accounts_org_id ON bank_accounts (org_id);
CREATE INDEX bank_accounts_bank_branch_id ON bank_accounts (bank_branch_id);

CREATE TABLE contribution_types (
	contribution_type_id	serial primary key,
	org_id					integer references orgs,
	contribution_type_name	varchar(20),
	interval_days			integer,
	amount                  real default 3000,
	details					text
);
CREATE INDEX contribution_types_org_id ON contribution_types (org_id);

--Contributions
CREATE TABLE contributions (
	contribution_id			serial primary key,
	entity_id				integer references entitys,  
	period_id				integer references periods, 
	payment_type_id         integer references payment_types,
	contribution_type_id 	integer references contribution_types,
	org_id					integer references orgs, 

	entity_name 			varchar(120),
	contribution_amount		real default 0 not null,
	contribution_paid		real default 0 not null,

	loan_repayment			boolean default false,
	is_paid 				boolean default false,
	
	deposit_date			date,
	receipt					real default 0 not null,
	
	entry_date              timestamp default CURRENT_TIMESTAMP,
	additional_payments 	real not null default 0,
	transaction_ref         varchar(50),
	
	narrative				varchar(255)
);


CREATE INDEX contributions_entity_id ON contributions (entity_id);
CREATE INDEX contributions_period_id ON contributions (period_id);
CREATE INDEX contributions_payment_type_id ON contributions (payment_type_id);
CREATE INDEX contributions_contribution_type_id ON contributions (contribution_type_id);
CREATE INDEX contributions_orgs_id ON contributions (org_id);


CREATE TABLE additional_funds (
	additional_funds_id		serial primary key,
	contribution_id			integer references contributions,  
	payment_type_id       	integer references payment_types,
	org_id					integer references orgs, 
	
	additional_amount		real not null default 0,
	deposit_date			date,
	
	entry_date              timestamp default CURRENT_TIMESTAMP,
	transaction_ref         varchar(50),
	narrative				varchar(255)
);
CREATE INDEX additional_funds_contribution_id on additional_funds(contribution_id);
CREATE INDEX additional_funds_payment_type_id on additional_funds(payment_type_id);


--- 


CREATE TABLE investment_types (
	investment_type_id 			serial primary key,
	org_id						integer references orgs,
	investment_type_name		varchar(120),
	interest_type				real not null default 0,
	details 					text
);
CREATE INDEX investment_types_org_id ON investment_types (org_id);

CREATE TABLE investments (
	investment_id     			serial primary key,
	entity_id					integer references entitys,
	investment_type_id			integer references investment_types,
	org_id						integer references orgs,
	period_id  					integer references periods,
	entity_name 				varchar(120),
	maturity_date				date,
	invest_amount				real,
	yearly_dividend				real,
	withdrawal_date				date,
	withdrwal_amount			real,
	period_years				real not null default 1,
	default_interest 			real NOT NULL DEFAULT 1,
	return_on_investment 		real NOT NULL DEFAULT 0,
	
	expenses 					real,
	application_date			timestamp default now() not null,
	approve_status				varchar(16) default 'Draft' not null,
	workflow_table_id			integer,
	action_date					timestamp,
	details 					text
);
CREATE INDEX investments_investment_type_id ON investments (investment_type_id);
CREATE INDEX investments_entity_id ON investments (entity_id);
CREATE INDEX investments_period_id ON investments (period_id);
CREATE INDEX investments_org_id ON investments (org_id);

CREATE TABLE applicants	(
	applicant_id			serial primary key,
	entity_id			integer references entitys,
	org_id 				integer references orgs,
	person_title			character varying(7),
	surname 			character varying(50) NOT NULL,
	first_name 			character varying(50) NOT NULL,
	middle_name			character varying(50),
	applicant_email			character varying(50) NOT NULL,
	applicant_phone			character varying(50),
	date_of_birth			date,
	gender 				character varying(1),
	nationality 			character(2),
	marital_status 			character varying(2),
	picture_file 			character varying(32),
	identity_card 			character varying(50),
	language 			character varying(320),

	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date			timestamp,
	
	salary 				real,
	how_you_heard 			character varying(320),
	created 			timestamp without time zone DEFAULT now(),
	interests			text,
	objective 			text,
	details 			text
);		
 CREATE INDEX applicants_org_id ON applicants (org_id);
 CREATE INDEX applicants_entity_id ON applicants (entity_id);
 

CREATE TABLE recruiting_agent(
	recruiting_agent_id  		serial primary key,
	entity_id			integer references entitys,
	entity_name			 varchar(120),
	org_id				integer references orgs,
	details				text
);
CREATE INDEX recruiting_agent_entity_id ON recruiting_agent (entity_id);
CREATE INDEX recruiting_agent_org_id ON recruiting_agent (org_id);


CREATE TABLE members (
	entity_id 			integer NOT NUll references entitys,
	member_id					serial primary key,
	address_id					integer references address,
  	bank_id                 	integer references banks,
 	org_id 						integer references orgs,
	recruiting_agent_id 		integer references recruiting_agent,

	person_title				character varying(7),
	
	full_name					varchar (120),
	surname 					character varying(50) NOT NULL,
	first_name		 			character varying(50) NOT NULL,
  	middle_name 				character varying(50),
  	date_of_birth 				date,
  	gender 						character varying(1),
 	phone						character varying(120),
  	primary_email				character varying(120),
  	
  	place_of_birth				character varying(50),
  	marital_status 				character varying(2),
  	appointment_date 			timestamp default now(),
 
  	exit_date 					date,
	picture_file 				character varying(32),
  	active 						boolean NOT NULL DEFAULT true,
  	language 					character varying(320),
	interests 					text,
  	objective 					text,
  	details 					text,
  	division 					varchar (120),
	location 					varchar (120),
	 sub_location				varchar (120),
  	 district					varchar (120),
  	 county						varchar (120) not null default 'Nairobi',
  	 residential_address 		varchar (120),
  	 
  	 expired 					boolean default 'false',
  	 contribution				real not null default 0
  	);
  	
	 
CREATE INDEX members_org_id ON members (org_id);
CREATE INDEX members_bank_id ON members (bank_id);
CREATE INDEX members_address_id ON members (address_id);
CREATE INDEX members_recruiting_agent_id ON members (recruiting_agent_id); 
 
ALTER TABLE entitys ADD exit_amount REAL default 0;

CREATE TABLE kin_types (
	kin_type_id				serial primary key,
	org_id					integer references orgs,
	kin_type_name			varchar(50),
	details					text
);
CREATE INDEX kin_types_org_id ON kin_types(org_id);
--here
CREATE TABLE kins (
	kin_id					serial primary key,
	entity_id				integer references entitys,
	kin_type_id				integer references kin_types,
	org_id					integer references orgs,
	full_names				varchar(120),
	date_of_birth			date,
	identification			varchar(50),
	relation				varchar(50),
	emergency_contact		boolean default false not null,
	
	beneficiary				boolean default false not null,
	beneficiary_ps			real,
	
	postal_address 			varchar (120) ,
	tel_number 			varchar (120) ,
	email_address			varchar (120) ,
	pin				varchar (120) ,
	postal_code 			varchar (120),
	details					text
);
CREATE INDEX kins_entity_id ON kins (entity_id);
CREATE INDEX kins_kin_type_id ON kins (kin_type_id);
CREATE INDEX kins_org_id ON kins(org_id);



CREATE TABLE employment (
	employment_id				serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	employer_names				varchar(120),
	current_branch				varchar (120),
	staff_number				varchar(120),			
	employer_address			varchar(50),
	employer_postal_code			varchar(50),
	employer_contact_person			varchar(120),
	employer_email				varchar(50),
	telephone_number 			varchar(60),
	details					text
);
CREATE INDEX employment_entity_id ON employment (entity_id);
CREATE INDEX employment_org_id ON employment(org_id);


CREATE TABLE member_business(
	member_business_id 			serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	business_name				varchar(120),
	nature_of_business			varchar(120),
	business_address			varchar(120),
	business_location			varchar(120),
	business_telephone			varchar(120),
	business_telephone_1			varchar(120),			
	business_email				varchar(120),
	business_area_code			varchar(120),
	registration_particulars		varchar(240),
	details					text
);
CREATE INDEX member_business_entity_id ON member_business (entity_id);
CREATE INDEX member_business_org_id ON member_business(org_id);



CREATE TABLE sacco_investments (
   	sacco_investment_id               serial primary key,
	investment_type_id			integer references investment_types, 
	currency_id                 integer references currency,
    org_id                      integer references orgs,
    bank_account_id 			integer references bank_accounts,
    
    investment_name 			varchar(120),
	investment_status			character varying(25) NOT NULL DEFAULT 'Prospective',
	date_of_accrual             date,
	principal 					real,
	interest					real,
	repayment_period			real,
	initial_payment				real default 0 not null,
	monthly_payments			real,
	
	approve_status				varchar(16) default 'Draft' not null,
	workflow_table_id			integer,
	action_date					timestamp,
	
	is_active                   boolean default true not null,
	details                     text
);
CREATE INDEX sacco_investments_bank_account_id ON sacco_investments (bank_account_id);
CREATE INDEX sacco_investments_investment_type_id ON sacco_investments (investment_type_id);
CREATE INDEX sacco_investments_currency_id ON sacco_investments (currency_id);
CREATE INDEX sacco_investments_org_id ON sacco_investments (org_id);
