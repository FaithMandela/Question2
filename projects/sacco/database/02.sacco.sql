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

--Contributions
CREATE TABLE contributions (
	contribution_id			serial primary key,
	org_id					integer references orgs, --available in base sql
	entity_id				integer references entitys,  --available in base sql
	period_id				integer references periods,  --available in base sql
	payment_type_id         integer references payment_types,
	deposit_date			date,
	deposit_amount			real,
	entry_date              timestamp default CURRENT_TIMESTAMP,
	transaction_ref         varchar(50),
	narrative				varchar(255)
);

CREATE TABLE contribution_types (
	contribution_type_id	serial primary key,
	org_id					integer references orgs,
	contribution_type_name	varchar(20),
	interval_days			integer,
	details					text
);

---alter entities
ALTER TABLE entitys ADD entry_amount real not null default 0;
ALTER TABLE entitys ADD exit_amount real not null default 0;
ALTER TABLE entitys ADD entry_date date not null default current_date;
ALTER TABLE entitys ADD exit_date date check (entry_date > exit_date);
ALTER TABLE entitys ADD national_id_no varchar (89) not null default 000000;
ALTER TABLE entitys ADD secondary_telephone varchar (89);
ALTER TABLE entitys ADD contribution_type_id integer references contribution_types;

	
CREATE TABLE loan_types (
	loan_type_id			serial primary key,
	org_id					integer references orgs,
	loan_type_name			varchar(50),
	default_interest		real,
	details					text
);

CREATE TABLE loans (
	loan_id 				serial primary key,
	loan_type_id			integer references loan_types,
	org_id					integer references orgs,
	loan_request_date		date not null default current_date,
	loan_principle			real not null default 0,
	loan_interest			real not null default 0,
	expenses     			real not null default 0,
	period_id				integer references periods,
	repayment_start_date	date not null,
	repayment_period		integer not null default 0,
	interest_amount			real default 0,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
	
	details					text
);

CREATE TABLE loan_repayment (
	loan_repayment_id		serial primary key,
	loan_id					integer references loans,
	org_id					integer references orgs,
	repayment_amount		real not null default 0,
	repayment_interest		real not null default 0,
	penalty					real default 0 not null,
	penalty_paid			real default 0 not null,
	repayment_narrative		text
);

CREATE TABLE collateral_types (
  collateral_type_id 		serial primary key,
  collateral_type_name		varchar(120),
  details 					text
);

CREATE TABLE collateral (
	collateral_id		serial primary key,
	loan_id				integer references loans,
	collateral_type_id	integer references collateral_types,
	reference_number	varchar(50),
	collateral_amount	real,
	narrative 			text	
);
	
CREATE TABLE gurrantors (
	gurrantor_id		serial primary key,
	entity_id			integer references entitys,
	loan_id				integer references loans,
	org_id				integer references orgs,
	amount				real not null default 0,
	details				text
);



-------- Data
INSERT INTO payment_types(payment_type_id, payment_type_name, org_id) VALUES
	(1, 'Bank',0),
	(2, 'Mpesa',0),
	(3, 'Cash', 0),
	(4, 'Airtel Money', 0 );
--end payments


INSERT INTO contribution_types(contribution_type_id, contribution_type_name, org_id, interval_days) VALUES
	(1, 'Daily', 0, 1),
	(2, 'Weekly', 0, 7),
	(3, 'fortnight', 0, 14),
	(4, 'Monthly', 0, 30);
	
INSERT INTO loan_types(loan_type_id, org_id, loan_type_name, loan_type_default_interest) VALUES 
	(0, 0, 'Emergency', 15),
	(1, 0, 'Education', 9),
	(2, 0, 'Development', 10);

	
	
