---Project Database File
CREATE TABLE members (
	entity_id 					integer primary key references entitys,
	bank_branch_id 				integer references bank_branch,
 	org_id 						integer references orgs,

	person_title				varchar(50),
	surname 					varchar(50) ,
	first_name 					varchar(50) ,
  	middle_name 				varchar(50),
  	full_name					varchar(50),
  	id_number					varchar(50) ,
  	email						varchar(50),
  	date_of_birth 				date,
  	
	gender 						varchar(10),
 	phone						varchar(50),
 	bank_account_number			varchar(50),
  	nationality 				char(2) references sys_countrys,
  	marital_status 				varchar(20),
	joining_date				date,
	exit_date					date,
	merry_go_round_number 		integer,

 	picture_file 				character varying(32),
  	active 						boolean DEFAULT true,
  	details 					text
);
CREATE INDEX members_bank_branch_id ON members (bank_branch_id);
CREATE INDEX members_nationality ON members (nationality);
CREATE INDEX members_org_id ON members (org_id);

CREATE TABLE meetings (
	meeting_id					serial primary key,
	org_id                      integer references orgs,
	meeting_date				date,
	meeting_place				varchar (120) not null,
	status						varchar (16) default 'Draft' not null,
	minutes						text,
	details						text
);
CREATE INDEX meetings_org_id ON meetings (org_id);

CREATE TABLE activity_frequency (
	activity_frequency_id	integer primary key,
	activity_frequency_name	varchar(50)
);

CREATE TABLE activity_status (
	activity_status_id		integer primary key,
	activity_status_name	varchar(50)
);

CREATE TABLE activity_types (
	activity_type_id		serial primary key,
	dr_account_id			integer not null references accounts,
	cr_account_id			integer not null references accounts,
	use_key_id				integer not null references use_keys,
	org_id					integer references orgs,
	activity_type_name		varchar(120) not null,
	is_active				boolean default true not null,
	details					text,
	UNIQUE(org_id, activity_type_name)
);
CREATE INDEX activity_types_dr_account_id ON activity_types(dr_account_id);
CREATE INDEX activity_types_cr_account_id ON activity_types(cr_account_id);
CREATE INDEX activity_types_use_key_id ON activity_types(use_key_id);
CREATE INDEX activity_types_org_id ON activity_types(org_id);

CREATE TABLE interest_methods (
	interest_method_id		serial primary key,
	activity_type_id		integer not null references activity_types,
	org_id					integer references orgs,
	interest_method_name	varchar(120) not null,
	reducing_balance		boolean not null default false,
	reducing_payments		boolean not null default false,
	formural				varchar(320),
	account_number			varchar(32),
	details					text,
	UNIQUE(org_id, interest_method_name)
);
CREATE INDEX interest_methods_activity_type_id ON interest_methods(activity_type_id);
CREATE INDEX interest_methods_org_id ON interest_methods(org_id);

CREATE TABLE penalty_methods (
	penalty_method_id		serial primary key,
	activity_type_id		integer not null references activity_types,
	org_id					integer references orgs,
	penalty_method_name		varchar(120) not null,
	formural				varchar(320),
	account_number			varchar(32),
	details					text,
	UNIQUE(org_id, penalty_method_name)
);
CREATE INDEX penalty_methods_activity_type_id ON penalty_methods(activity_type_id);
CREATE INDEX penalty_methods_org_id ON penalty_methods(org_id);

CREATE TABLE products (
	product_id				serial primary key,
	interest_method_id 		integer references interest_methods,
	penalty_method_id		integer references penalty_methods,
	activity_frequency_id	integer references activity_frequency,
	currency_id				integer references currency,
	entity_id 				integer references entitys,
	org_id					integer references orgs,
	product_name			varchar(120) not null,
	description				varchar(320),
	loan_account			boolean default true not null,
	is_active				boolean default true not null,
	
	interest_rate			real not null,
	min_opening_balance		real,
	lockin_period_frequency real,
	minimum_balance			real,
	maximum_balance			real,
	minimum_day				real,
	maximum_day				real,
	minimum_trx				real,
	maximum_trx				real,
	maximum_repayments		integer default 100 not null,
	
	application_date		timestamp default now() not null,
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
	
	details					text,
	UNIQUE(org_id, product_name)
);
CREATE INDEX products_interest_method_id ON products(interest_method_id);
CREATE INDEX products_activity_frequency_id ON products(activity_frequency_id);
CREATE INDEX products_currency_id ON products(currency_id);
CREATE INDEX products_entity_id ON products(entity_id);
CREATE INDEX products_org_id ON products(org_id);

CREATE TABLE account_definations (
	account_defination_id	serial primary key,
	product_id 				integer not null references products,
	activity_type_id		integer not null references activity_types,
	charge_activity_id		integer not null references activity_types,
	activity_frequency_id	integer not null references activity_frequency,
	org_id					integer references orgs,
	account_defination_name		varchar(50) not null,
	start_date				date not null,
	end_date				date,
	fee_amount				real default 0 not null,
	fee_ps					real default 0 not null,
	has_charge				boolean default false not null,
	is_active				boolean default false not null,
	account_number			varchar(32) not null,
	details					text,
	
	UNIQUE(product_id, activity_type_id)
);
CREATE INDEX account_definations_product_id ON account_definations(product_id);
CREATE INDEX account_definations_activity_type_id ON account_definations(activity_type_id);
CREATE INDEX account_definations_charge_activity_id ON account_definations(charge_activity_id);
CREATE INDEX account_definations_activity_frequency_id ON account_definations(activity_frequency_id);
CREATE INDEX account_definations_org_id ON account_definations(org_id);

CREATE TABLE deposit_accounts (
	deposit_account_id		serial primary key,
	customer_id				integer references customers,
	product_id 				integer references products,
	activity_frequency_id	integer references activity_frequency,
	entity_id 				integer references entitys,
	org_id					integer references orgs,

	is_active				boolean default false not null,
	account_number			varchar(32) not null unique,
	narrative				varchar(120),
	last_closing_date		date,
	
	credit_limit			real,
	minimum_balance			real,
	maximum_balance			real,
	
	interest_rate			real not null,
	lockin_period_frequency	real,
	lockedin_until_date		date,

	application_date		timestamp default now() not null,
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
	
	details					text
);
CREATE INDEX deposit_accounts_customer_id ON deposit_accounts(customer_id);
CREATE INDEX deposit_accounts_product_id ON deposit_accounts(product_id);
CREATE INDEX deposit_accounts_activity_frequency_id ON deposit_accounts(activity_frequency_id);
CREATE INDEX deposit_accounts_entity_id ON deposit_accounts(entity_id);
CREATE INDEX deposit_accounts_org_id ON deposit_accounts(org_id);

CREATE TABLE account_notes (
	account_note_id			serial primary key,
	deposit_account_id		integer references deposit_accounts,
	org_id					integer references orgs,
	comment_date			timestamp default now() not null,
	narrative				varchar(320) not null,
	note					text not null
);
CREATE INDEX account_notes_deposit_account_id ON account_notes(deposit_account_id);
CREATE INDEX account_notes_org_id ON account_notes(org_id);

CREATE TABLE account_activity (
	account_activity_id		serial primary key,
	deposit_account_id		integer references deposit_accounts,
	transfer_account_id		integer references deposit_accounts,
	activity_type_id		integer references activity_types,
	activity_frequency_id	integer references activity_frequency,
	activity_status_id		integer references activity_status,
	currency_id				integer references currency,
	period_id				integer references periods,
	entity_id 				integer references entitys,
	org_id					integer references orgs,
	
	link_activity_id		integer not null,
	deposit_account_no		varchar(32),
	transfer_account_no		varchar(32),
	activity_date			date default current_date not null,
	value_date				date not null,
	
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
CREATE INDEX account_activity_transfer_account_id ON account_activity(transfer_account_id);
CREATE INDEX account_activity_activity_frequency_id ON account_activity(activity_frequency_id);
CREATE INDEX account_activity_activity_status_id ON account_activity(activity_status_id);
CREATE INDEX account_activity_activity_type_id ON account_activity(activity_type_id);
CREATE INDEX account_activity_currency_id ON account_activity(currency_id);
CREATE INDEX account_activity_link_activity_id ON account_activity(link_activity_id);
CREATE INDEX account_activity_entity_id ON account_activity(entity_id);
CREATE INDEX account_activity_org_id ON account_activity(org_id);

CREATE SEQUENCE link_activity_id_seq START 101;

ALTER TABLE gls ADD account_activity_id		integer references account_activity;
CREATE INDEX gls_account_activity_id ON gls (account_activity_id);

CREATE TABLE account_activity_log (
	account_activity_log_id	serial primary key,
	account_activity_id		integer references account_activity,
	deposit_account_id		integer,
	transfer_account_id		integer,
	activity_type_id		integer,
	activity_frequency_id	integer,
	activity_status_id		integer,
	currency_id				integer,
	period_id				integer,
	entity_id 				integer,
	loan_id					integer,
	transfer_loan_id		integer,
	org_id					integer references orgs,
	
	link_activity_id		integer not null,
	deposit_account_no		varchar(32),
	transfer_account_no		varchar(32),
	activity_date			date default current_date not null,
	value_date				date not null,
	
	account_credit			real,
	account_debit			real,
	balance					real,
	exchange_rate			real,
	
	application_date		timestamp,
	approve_status			varchar(16),
	workflow_table_id		integer,
	action_date				timestamp,	
	details					text,
	
	created					timestamp default now() not null
);
CREATE INDEX account_activity_log_account_activity_id ON account_activity_log(account_activity_id);
CREATE INDEX account_activity_log_org_id ON account_activity_log(org_id);

CREATE VIEW vw_interest_methods AS
	SELECT activity_types.activity_type_id, activity_types.activity_type_name, activity_types.use_key_id,
		interest_methods.org_id, interest_methods.interest_method_id, interest_methods.interest_method_name, 
		interest_methods.reducing_balance, interest_methods.formural, interest_methods.account_number, 
		interest_methods.details
	FROM interest_methods INNER JOIN activity_types ON interest_methods.activity_type_id = activity_types.activity_type_id;
	
CREATE VIEW vw_penalty_methods AS
	SELECT activity_types.activity_type_id, activity_types.activity_type_name, activity_types.use_key_id,
		penalty_methods.org_id, penalty_methods.penalty_method_id, penalty_methods.penalty_method_name, 
		penalty_methods.formural, penalty_methods.account_number, penalty_methods.details
	FROM penalty_methods INNER JOIN activity_types ON penalty_methods.activity_type_id = activity_types.activity_type_id;

CREATE VIEW vw_activity_types AS
	SELECT activity_types.dr_account_id, dra.account_no as dr_account_no, dra.account_name as dr_account_name,
		activity_types.cr_account_id, cra.account_no as cr_account_no, cra.account_name as cr_account_name,
		use_keys.use_key_id, use_keys.use_key_name, 
		activity_types.org_id, activity_types.activity_type_id, activity_types.activity_type_name, 
		activity_types.is_active, activity_types.details
	FROM activity_types INNER JOIN vw_accounts dra ON activity_types.dr_account_id = dra.account_id
		INNER JOIN vw_accounts cra ON activity_types.cr_account_id = cra.account_id
		INNER JOIN use_keys ON activity_types.use_key_id = use_keys.use_key_id;

CREATE VIEW vw_products AS
	SELECT activity_frequency.activity_frequency_id, activity_frequency.activity_frequency_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		vw_interest_methods.interest_method_id, vw_interest_methods.interest_method_name, vw_interest_methods.reducing_balance, 
		penalty_methods.penalty_method_id, penalty_methods.penalty_method_name,
		products.org_id, products.product_id, products.product_name, products.description, 
		products.loan_account, products.is_active, products.interest_rate, 
		products.min_opening_balance, products.lockin_period_frequency, 
		products.minimum_balance, products.maximum_balance, products.minimum_day, products.maximum_day,
		products.minimum_trx, products.maximum_trx, products.details
	FROM products INNER JOIN activity_frequency ON products.activity_frequency_id = activity_frequency.activity_frequency_id
		INNER JOIN currency ON products.currency_id = currency.currency_id
		INNER JOIN vw_interest_methods ON products.interest_method_id = vw_interest_methods.interest_method_id
		INNER JOIN penalty_methods ON products.penalty_method_id = penalty_methods.penalty_method_id;

CREATE VIEW vw_account_definations AS
	SELECT products.product_id, products.product_name,
		vw_activity_types.activity_type_id, vw_activity_types.activity_type_name, 
		vw_activity_types.use_key_id, vw_activity_types.use_key_name,
		account_definations.charge_activity_id, charge_activitys.activity_type_name as charge_activity_name,
		activity_frequency.activity_frequency_id, activity_frequency.activity_frequency_name, 
		account_definations.org_id, account_definations.account_defination_id, account_definations.account_defination_name, 
		account_definations.start_date, account_definations.end_date, account_definations.is_active, 
		account_definations.account_number, account_definations.fee_amount, account_definations.fee_ps, 
		account_definations.has_charge, account_definations.details
	FROM account_definations INNER JOIN vw_activity_types ON account_definations.activity_type_id = vw_activity_types.activity_type_id
		INNER JOIN products ON account_definations.product_id = products.product_id
		INNER JOIN activity_frequency ON account_definations.activity_frequency_id = activity_frequency.activity_frequency_id
		LEFT JOIN activity_types charge_activitys ON account_definations.charge_activity_id = charge_activitys.activity_type_id;
		
CREATE VIEW vw_deposit_balance AS
	SELECT cb.deposit_account_id, cb.current_balance, COALESCE(ab.c_balance, 0) as cleared_balance,
		COALESCE(uc.u_credit, 0) as unprocessed_credit
	FROM 
		(SELECT deposit_account_id, sum((account_credit - account_debit) * exchange_rate) as current_balance
			FROM account_activity GROUP BY deposit_account_id) cb
	LEFT JOIN
		(SELECT deposit_account_id, sum((account_credit - account_debit) * exchange_rate) as c_balance
			FROM account_activity WHERE activity_status_id < 3
			GROUP BY deposit_account_id) ab
		ON cb.deposit_account_id = ab.deposit_account_id
	LEFT JOIN
		(SELECT deposit_account_id, sum(account_credit * exchange_rate) as u_credit
			FROM account_activity WHERE activity_status_id > 2
			GROUP BY deposit_account_id) uc
		ON cb.deposit_account_id = uc.deposit_account_id;

CREATE VIEW vw_deposit_accounts AS
	SELECT customers.customer_id, customers.customer_name, customers.business_account,
		vw_products.product_id, vw_products.product_name, 
		vw_products.currency_id, vw_products.currency_name, vw_products.currency_symbol,
		activity_frequency.activity_frequency_id, activity_frequency.activity_frequency_name, 
		deposit_accounts.org_id, deposit_accounts.deposit_account_id, deposit_accounts.is_active, 
		deposit_accounts.account_number, deposit_accounts.narrative, deposit_accounts.last_closing_date, 
		deposit_accounts.credit_limit, deposit_accounts.minimum_balance, deposit_accounts.maximum_balance, 
		deposit_accounts.interest_rate, deposit_accounts.lockin_period_frequency, 
		deposit_accounts.lockedin_until_date, deposit_accounts.application_date, deposit_accounts.approve_status, 
		deposit_accounts.workflow_table_id, deposit_accounts.action_date, deposit_accounts.details,
		
		vw_deposit_balance.current_balance, vw_deposit_balance.cleared_balance, vw_deposit_balance.unprocessed_credit,
		(vw_deposit_balance.cleared_balance - vw_deposit_balance.unprocessed_credit) AS available_balance
	FROM deposit_accounts INNER JOIN customers ON deposit_accounts.customer_id = customers.customer_id
		INNER JOIN vw_products ON deposit_accounts.product_id = vw_products.product_id
		INNER JOIN activity_frequency ON deposit_accounts.activity_frequency_id = activity_frequency.activity_frequency_id
		LEFT JOIN vw_deposit_balance ON deposit_accounts.deposit_account_id = vw_deposit_balance.deposit_account_id;

CREATE VIEW vw_account_notes AS
	SELECT vw_deposit_accounts.customer_id, vw_deposit_accounts.customer_name, 
		vw_deposit_accounts.product_id, vw_deposit_accounts.product_name, 
		vw_deposit_accounts.deposit_account_id, vw_deposit_accounts.is_active, 
		vw_deposit_accounts.account_number, vw_deposit_accounts.last_closing_date,
		account_notes.org_id, account_notes.account_note_id, account_notes.comment_date, 
		account_notes.narrative, account_notes.note
	FROM account_notes INNER JOIN vw_deposit_accounts ON account_notes.deposit_account_id = vw_deposit_accounts.deposit_account_id;

CREATE VIEW vw_account_activity AS
	SELECT vw_deposit_accounts.customer_id, vw_deposit_accounts.customer_name, vw_deposit_accounts.business_account,
		vw_deposit_accounts.product_id, vw_deposit_accounts.product_name, 
		vw_deposit_accounts.deposit_account_id, vw_deposit_accounts.is_active, 
		vw_deposit_accounts.account_number, vw_deposit_accounts.last_closing_date,
		vw_activity_types.activity_type_id, vw_activity_types.activity_type_name, 
		vw_activity_types.dr_account_id, vw_activity_types.dr_account_no, vw_activity_types.dr_account_name,
		vw_activity_types.cr_account_id, vw_activity_types.cr_account_no, vw_activity_types.cr_account_name,
		vw_activity_types.use_key_id, vw_activity_types.use_key_name, 
		activity_frequency.activity_frequency_id, activity_frequency.activity_frequency_name, 
		activity_status.activity_status_id, activity_status.activity_status_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		
		account_activity.transfer_account_id, trnf_accounts.account_number as trnf_account_number,
		trnf_accounts.customer_id as trnf_customer_id, trnf_accounts.customer_name as trnf_customer_name,
		trnf_accounts.product_id as trnf_product_id,  trnf_accounts.product_name as trnf_product_name,
		
		vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.fiscal_year_id, vw_periods.fiscal_year,
		
		account_activity.org_id, account_activity.account_activity_id, account_activity.activity_date, 
		account_activity.value_date, account_activity.transfer_account_no,
		account_activity.account_credit, account_activity.account_debit, account_activity.balance, 
		account_activity.exchange_rate, account_activity.application_date, account_activity.approve_status, 
		account_activity.workflow_table_id, account_activity.action_date, account_activity.details,
		
		(account_activity.account_credit * account_activity.exchange_rate) as base_credit,
		(account_activity.account_debit * account_activity.exchange_rate) as base_debit
	FROM account_activity INNER JOIN vw_deposit_accounts ON account_activity.deposit_account_id = vw_deposit_accounts.deposit_account_id
		INNER JOIN vw_activity_types ON account_activity.activity_type_id = vw_activity_types.activity_type_id
		INNER JOIN activity_frequency ON account_activity.activity_frequency_id = activity_frequency.activity_frequency_id
		INNER JOIN activity_status ON account_activity.activity_status_id = activity_status.activity_status_id
		INNER JOIN currency ON account_activity.currency_id = currency.currency_id
		LEFT JOIN vw_periods ON account_activity.period_id = vw_periods.period_id
		LEFT JOIN vw_deposit_accounts trnf_accounts ON account_activity.transfer_account_id =  trnf_accounts.deposit_account_id;


------------Hooks to approval trigger
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON customers
	FOR EACH ROW EXECUTE PROCEDURE upd_action();
    
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON products
	FOR EACH ROW EXECUTE PROCEDURE upd_action();

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON deposit_accounts
	FOR EACH ROW EXECUTE PROCEDURE upd_action();
    
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON account_activity
	FOR EACH ROW EXECUTE PROCEDURE upd_action();
	