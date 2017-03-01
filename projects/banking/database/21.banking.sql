---Project Database File
CREATE TABLE clients (
	client_id				integer references entitys primary key,
	org_id					integer references orgs,

	person_title			varchar(7),
	surname					varchar(50) not null,
	first_name				varchar(50) not null,
	middle_name				varchar(50),
	identity_card			varchar(50) not null,
	
	applicant_email			varchar(50) not null unique,
	telephone_number		varchar(20) not null,
	telephone_number2		varchar(20),
	
	address					varchar(50),
	town					varchar(50),
	zip_code				varchar(50),
	
	date_of_birth			date not null,
	gender					varchar(1),
	nationality				char(2) references sys_countrys,
	marital_status 			varchar(2),
	picture_file			varchar(32),

	employed				boolean default true not null,
	self_employed			boolean default false not null,
	employer_name			varchar(120),
	monthly_salary			real,
	monthly_net_income		real,
	
	employer_address		text,
	introduced_by			varchar(100),

	details					text
);
CREATE INDEX clients_org_id ON clients(org_id);

CREATE TABLE client_entitys (
	deposit_account_id		serial primary key,
	client_id				integer references clients,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX client_entitys_client_id ON client_entitys(client_id);
CREATE INDEX client_entitys_entity_id ON client_entitys(entity_id);
CREATE INDEX client_entitys_org_id ON client_entitys(org_id);

CREATE TABLE activity_types (
	activity_type_id		serial primary key,
	account_id				integer references accounts,
	org_id					integer references orgs,
	activity_type_name		varchar(120) not null,
	details					text,
	UNIQUE(org_id, activity_type_name)
);
CREATE INDEX activity_types_account_id ON activity_types(account_id);
CREATE INDEX activity_types_org_id ON activity_types(org_id);

CREATE TABLE interest_methods (
	interest_method_id		serial primary key,
	org_id					integer references orgs,
	interest_method_name	varchar(120) not null,
	formural				varchar(320) not null,
	details					text,
	UNIQUE(org_id, interest_method_name)
);
CREATE INDEX interest_methods_org_id ON interest_methods(org_id);

CREATE TABLE products (
	product_id				serial primary key,
	account_id				integer references accounts,
	interest_method_id 		integer references interest_methods,
	currency_id				integer references currency,
	org_id					integer references orgs,
	account_type_name		varchar(100) not null,
	description				varchar(320),
	loan_account			boolean default true not null,
	is_active				boolean default true not null,
	
	interest_rate			real not null,
	interest_frequency		integer not null,
	repay_every 			integer not null,
	min_opening_balance		real,
	lockin_period_frequency real,
	
	details					text,
	UNIQUE(org_id, account_type_name)
);
CREATE INDEX products_account_id ON products(account_id);
CREATE INDEX products_interest_method_id ON products(interest_method_id);
CREATE INDEX products_currency_id ON products(currency_id);
CREATE INDEX products_org_id ON products(org_id);

CREATE TABLE account_fees (
	account_fee_id			serial primary key,
	product_id 				integer references products,
	activity_type_id		integer references activity_types,
	org_id					integer references orgs,
	account_fee_name		varchar(50) not null,
	fee_frequency			integer,
	start_date				date,
	end_date				date,
	fee_amount				real not null,
	details					text
);
CREATE INDEX account_fees_product_id ON account_fees(product_id);
CREATE INDEX account_fees_activity_type_id ON account_fees(activity_type_id);
CREATE INDEX account_fees_org_id ON account_fees(org_id);

CREATE TABLE deposit_accounts (
	deposit_account_id		serial primary key,
	client_id				integer references clients,
	product_id 				integer references products,
	org_id					integer references orgs,

	is_active				boolean default false not null,
	account_no				varchar(20) not null,
	
	created					timestamp default current_timestamp not null,
	last_closing_date		date,
	
	credit_limit			real,
	minimum_balance			real,
	maximum_balance			real,
	
	interest_rate			real not null,
	interest_frequency		integer not null,
	lockin_period_frequency	real,
	lockedin_until_date		date,

	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX deposit_accounts_client_id ON deposit_accounts(client_id);
CREATE INDEX deposit_accounts_product_id ON deposit_accounts(product_id);
CREATE INDEX deposit_accounts_org_id ON deposit_accounts(org_id);

CREATE TABLE account_activity (
	activity_id				serial primary key,
	deposit_account_id		integer references deposit_accounts,
	activity_type_id		integer references activity_types,
	currency_id				integer references currency,
	org_id					integer references orgs,
	
	activity_date			date default current_date not null,
	
	account_credit			real default 0 not null,
	account_debit			real default 0 not null,
	balance					real not null,
	exchange_rate			real default 1 not null,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX account_activity_deposit_account_id ON account_activity(deposit_account_id);
CREATE INDEX account_activity_activity_type_id ON account_activity(activity_type_id);
CREATE INDEX account_activity_currency_id ON account_activity(currency_id);
CREATE INDEX account_activity_org_id ON account_activity(org_id);

CREATE TABLE account_notes (
	account_note_id			serial primary key,
	deposit_account_id		integer references deposit_accounts,
	org_id					integer references orgs,
	comment_date			timestamp default now() not null,
	note					text not null
);
CREATE INDEX account_notes_deposit_account_id ON account_notes(deposit_account_id);
CREATE INDEX account_notes_org_id ON account_notes(org_id);

