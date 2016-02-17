
---Project Database File

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
	details					text
);
CREATE INDEX contribution_types_org_id ON contribution_types (org_id);

--Contributions
CREATE TABLE contributions (
	contribution_id			serial primary key,
	entity_id				integer references entitys,  --available in base sql
	period_id				integer references periods,  --available in base sql
	payment_type_id         integer references payment_types,
	contribution_type_id 	integer references contribution_types,
	org_id					integer references orgs, --available in base sql
	contribution_amount		real,
	deposit_date			date,
	deposit_amount			real,
	entry_date              timestamp default CURRENT_TIMESTAMP,
	transaction_ref         varchar(50),
	narrative				varchar(255)
);
ALTER TABLE contributions add ;
CREATE INDEX contributions_entity_id ON contributions (entity_id);
CREATE INDEX contributions_period_id ON contributions (period_id);
CREATE INDEX contributions_payment_type_id ON contributions (payment_type_id);
CREATE INDEX contributions_contribution_type_id ON contributions (contribution_type_id);
CREATE INDEX contributions_orgs_id ON contributions (org_id);


---alter entities
/*
ALTER TABLE entitys ADD entry_amount real not null default 0;
ALTER TABLE entitys ADD exit_amount real not null default 0;
ALTER TABLE entitys ADD entry_date date not null default current_date;
ALTER TABLE entitys ADD exit_date date check (entry_date > exit_date);
ALTER TABLE entitys ADD national_id_no varchar (89) not null default 000000;
ALTER TABLE entitys ADD secondary_telephone varchar (89);
ALTER TABLE entitys ADD contribution_type_id integer references contribution_types;
CREATE INDEX entitys_contribution_type_id ON entitys (contribution_type_id);
*/
CREATE TABLE loan_repayment (
	loan_repayment_id		serial primary key,
	loan_id				integer references loans,
	period_id			integer references periods,
	org_id				integer references orgs,
	repayment_amount		real not null default 0,
	repayment_interest		real not null default 0,
	penalty				real default 0 not null,
	penalty_paid			real default 0 not null,
	repayment_narrative		text
);
CREATE INDEX loan_repayment_loan_id ON loan_repayment (loan_id);
CREATE INDEX loan_repayment_period_id ON loan_repayment (period_id);
CREATE INDEX loan_repayment_org_id ON loan_repayment (org_id);

CREATE TABLE collateral_types (
  collateral_type_id 		serial primary key,
  org_id					integer references orgs,
  collateral_type_name		varchar(120),
  details 					text
);
CREATE INDEX collateral_types_org_id ON collateral_types (org_id);

CREATE TABLE collateral (
	collateral_id			serial primary key,
	loan_id					integer references loans,
	collateral_type_id		integer references collateral_types,
	org_id					integer references orgs,
	reference_number		varchar(50),
	collateral_amount		real,
	narrative 				text	
);
CREATE INDEX collateral_loan_id ON collateral (loan_id);
CREATE INDEX collateral_collateral_type on collateral (collateral_type_id);
CREATE INDEX collateral_org_id ON collateral (org_id);

CREATE TABLE gurrantors (
	gurrantor_id			serial primary key,
	entity_id				integer references entitys,
	loan_id					integer references loans,
	org_id					integer references orgs,
	is_accepted				boolean default false,
	is_approved				boolean default false,
	amount					real not null default 0,
	details					text
);
CREATE INDEX gurrantors_entity_id ON gurrantors (entity_id);
CREATE INDEX gurrantors_loan_id ON gurrantors (loan_id);
CREATE INDEX gurrantors_org_id ON gurrantors (org_id);

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
	maturity_date				date,
	invest_amount						real,
	yearly_dividend				real,
	withdrawal_date				date,
	withdrwal_amount			real,
	period_years				real not null default 1,
	default_interest 			real NOT NULL DEFAULT 1,
	return_on_investment 		real NOT NULL DEFAULT 0,
	
	application_date			timestamp default now(),
	approve_status				varchar(16) default 'Draft' not null,
	workflow_table_id			integer,
	action_date				timestamp,
	
	details 					text
);
CREATE INDEX investments_investment_type_id ON investments (investment_type_id);
CREATE INDEX investments_entity_id ON investments (entity_id);
CREATE INDEX investments_org_id ON investments (org_id);

CREATE TABLE applicants	(
	entity_id			integer references entitys primary key
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
 
 
CREATE TABLE members (
	entity_id 			integer NOT NUll references entitys,
	address_id			integer references address,
  	bank_id                 	integer references banks,
 	org_id 				integer references orgs,
	person_title			character varying(7),
	
	full_name			 varchar (120),
	surname 			character varying(50) NOT NULL,
	first_name 			character varying(50) NOT NULL,
  	middle_name 			character varying(50),
  	date_of_birth 			date,
  	gender 				character varying(1),
 	phone				character varying(120),
  	primary_email			character varying(120),
  	
  	place_of_birth			character varying(50),
  	marital_status 			character varying(2),
  	appointment_date 		timestamp default now(),
 
  	exit_date 			date,
  	
  	picture_file 			character varying(32),
  	active 				boolean NOT NULL DEFAULT true,
  	language 			character varying(320),
	interests 			text,
  	objective 			text,
  	details 			text
  	);
 
	CREATE INDEX members_org_id ON members (org_id);
	CREATE INDEX members_bank_id ON members (bank_id);
	CREATE INDEX members_address_id ON members (address_id);
 
 
ALTER TABLE entitys ADD exit_amount REAL default 0;