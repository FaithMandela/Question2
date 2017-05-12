---Project Database File
CREATE TABLE customers (
	customer_id				serial primary key,
	org_id					integer references orgs,
	business_account		integer default 0 not null,
	
	person_title			varchar(7),
	customer_name			varchar(150) not null,
	identification_number	varchar(50) not null,
	identification_type		varchar(50) not null,
	
	client_email			varchar(50) not null,
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
	
	annual_turnover			real,
	annual_net_income		real,
	
	employer_address		text,
	introduced_by			varchar(100),
	
	application_date		timestamp default now() not null,
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,

	details					text,
	
	UNIQUE (org_id, identification_number),
	UNIQUE (org_id, client_email)
);
CREATE INDEX customers_org_id ON customers(org_id);

ALTER TABLE entitys ADD 	customer_id		integer references customers;
CREATE INDEX entitys_customer_id ON entitys(customer_id);

CREATE TABLE activity_types (
	activity_type_id		serial primary key,
	account_id				integer references accounts,
	use_key_id				integer not null references use_keys,
	org_id					integer references orgs,
	activity_type_name		varchar(120) not null,
	is_active				boolean default true not null,
	details					text,
	UNIQUE(org_id, activity_type_name)
);
CREATE INDEX activity_types_account_id ON activity_types(account_id);
CREATE INDEX activity_types_use_key_id ON activity_types(use_key_id);
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
	product_name			varchar(120) not null,
	description				varchar(320),
	loan_account			boolean default true not null,
	is_active				boolean default true not null,
	
	interest_rate			real not null,
	interest_frequency		integer not null,
	repay_every 			integer not null,
	min_opening_balance		real,
	lockin_period_frequency real,
	minimum_balance			real,
	maximum_balance			real,
	minimum_day				real,
	maximum_day				real,
	minimum_trx				real,
	maximum_trx				real,
	
	details					text,
	UNIQUE(org_id, product_name)
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
	customer_id				integer references customers,
	product_id 				integer references products,
	org_id					integer references orgs,

	is_active				boolean default false not null,
	account_number			varchar(32) not null,
	last_closing_date		date,
	
	credit_limit			real,
	minimum_balance			real,
	maximum_balance			real,
	
	interest_rate			real not null,
	interest_frequency		integer not null,
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
	currency_id				integer references currency,
	org_id					integer references orgs,
	
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
CREATE INDEX account_activity_activity_type_id ON account_activity(activity_type_id);
CREATE INDEX account_activity_currency_id ON account_activity(currency_id);
CREATE INDEX account_activity_org_id ON account_activity(org_id);


CREATE VIEW vw_activity_types AS
	SELECT vw_accounts.account_type_name, vw_accounts.account_id, vw_accounts.account_no, vw_accounts.account_name,
		activity_types.org_id, activity_types.activity_type_id, activity_types.activity_type_name, 
		activity_types.is_active, activity_types.details
	FROM activity_types INNER JOIN vw_accounts ON activity_types.account_id = vw_accounts.account_id;

CREATE VIEW vw_products AS
	SELECT vw_accounts.account_type_name, vw_accounts.account_id, vw_accounts.account_no, vw_accounts.account_name,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		interest_methods.interest_method_id, interest_methods.interest_method_name, 
		products.org_id, products.product_id, products.product_name, products.description, 
		products.loan_account, products.is_active, products.interest_rate, products.interest_frequency, 
		products.repay_every, products.min_opening_balance, products.lockin_period_frequency, 
		products.minimum_balance, products.maximum_balance, products.minimum_day, products.maximum_day,
		products.minimum_trx, products.maximum_trx, products.details
	FROM products INNER JOIN vw_accounts ON products.account_id = vw_accounts.account_id
		INNER JOIN currency ON products.currency_id = currency.currency_id
		INNER JOIN interest_methods ON products.interest_method_id = interest_methods.interest_method_id;

CREATE VIEW vw_account_fees AS
	SELECT activity_types.activity_type_id, activity_types.activity_type_name, 
		products.product_id, products.product_name,
		account_fees.org_id, account_fees.account_fee_id, account_fees.account_fee_name, 
		account_fees.fee_frequency, account_fees.start_date, account_fees.end_date, 
		account_fees.fee_amount, account_fees.details
	FROM account_fees INNER JOIN activity_types ON account_fees.activity_type_id = activity_types.activity_type_id
		INNER JOIN products ON account_fees.product_id = products.product_id;

CREATE VIEW vw_deposit_accounts AS
	SELECT customers.customer_id, customers.customer_name, products.product_id, products.product_name, 
		deposit_accounts.org_id, deposit_accounts.deposit_account_id, deposit_accounts.is_active, 
		deposit_accounts.account_number, deposit_accounts.last_closing_date, 
		deposit_accounts.credit_limit, deposit_accounts.minimum_balance, deposit_accounts.maximum_balance, 
		deposit_accounts.interest_rate, deposit_accounts.interest_frequency, deposit_accounts.lockin_period_frequency, 
		deposit_accounts.lockedin_until_date, deposit_accounts.application_date, deposit_accounts.approve_status, 
		deposit_accounts.workflow_table_id, deposit_accounts.action_date, deposit_accounts.details
	FROM deposit_accounts INNER JOIN customers ON deposit_accounts.customer_id = customers.customer_id
		INNER JOIN products ON deposit_accounts.product_id = products.product_id;

CREATE VIEW vw_account_notes AS
	SELECT vw_deposit_accounts.customer_id, vw_deposit_accounts.customer_name, 
		vw_deposit_accounts.product_id, vw_deposit_accounts.product_name, 
		vw_deposit_accounts.deposit_account_id, vw_deposit_accounts.is_active, 
		vw_deposit_accounts.account_number, vw_deposit_accounts.last_closing_date,
		account_notes.org_id, account_notes.account_note_id, account_notes.comment_date, 
		account_notes.narrative, account_notes.note
	FROM account_notes INNER JOIN vw_deposit_accounts ON account_notes.deposit_account_id = vw_deposit_accounts.deposit_account_id;

CREATE VIEW vw_account_activity AS
	SELECT vw_deposit_accounts.customer_id, vw_deposit_accounts.customer_name, 
		vw_deposit_accounts.product_id, vw_deposit_accounts.product_name, 
		vw_deposit_accounts.deposit_account_id, vw_deposit_accounts.is_active, 
		vw_deposit_accounts.account_number, vw_deposit_accounts.last_closing_date, 
		activity_types.activity_type_id, activity_types.activity_type_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		account_activity.org_id, account_activity.account_activity_id, account_activity.activity_date, 
		account_activity.value_date,
		account_activity.account_credit, account_activity.account_debit, account_activity.balance, 
		account_activity.exchange_rate, account_activity.application_date, account_activity.approve_status, 
		account_activity.workflow_table_id, account_activity.action_date, account_activity.details
	FROM account_activity INNER JOIN vw_deposit_accounts ON account_activity.deposit_account_id = vw_deposit_accounts.deposit_account_id
		INNER JOIN activity_types ON account_activity.activity_type_id = activity_types.activity_type_id
		INNER JOIN currency ON account_activity.currency_id = currency.currency_id;

	
CREATE OR REPLACE FUNCTION aft_customers() RETURNS trigger AS $$
DECLARE
	v_entity_type_id		integer;
	v_entity_id				integer;
	v_user_name				varchar(32);
BEGIN

	IF((TG_OP = 'INSERT') AND (NEW.business_account = 0))THEN
		SELECT entity_type_id INTO v_entity_type_id
		FROM entity_types 
		WHERE (org_id = NEW.org_id) AND (use_key_id = 100);
		v_entity_id := nextval('entitys_entity_id_seq');
		v_user_name := 'OR' || NEW.org_id || 'EN' || v_entity_id;
		
		INSERT INTO entitys (entity_id, org_id, use_key_id, entity_type_id, customer_id, entity_name, user_name, primary_email, primary_telephone, function_role)
		VALUES (v_entity_id, NEW.org_id, 100, v_entity_type_id, NEW.customer_id, NEW.customer_name, v_user_name, lower(trim(NEW.client_email)), NEW.telephone_number, 'client');
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aft_customers AFTER INSERT OR UPDATE ON customers
    FOR EACH ROW EXECUTE PROCEDURE aft_customers();

CREATE OR REPLACE FUNCTION ins_deposit_accounts() RETURNS trigger AS $$
DECLARE
	myrec			RECORD;
BEGIN


	IF(TG_OP = 'INSERT')THEN
		SELECT interest_rate, interest_frequency, repay_every, min_opening_balance, lockin_period_frequency,
			minimum_balance, maximum_balance INTO myrec
		FROM products WHERE product_id = NEW.product_id;
	
		NEW.account_number := '4' || lpad(NEW.org_id::varchar, 4, '0')  || lpad(NEW.customer_id::varchar, 4, '0') || lpad(NEW.deposit_account_id::varchar, 4, '0');
		
		NEW.minimum_balance = myrec.minimum_balance;
		NEW.maximum_balance = myrec.maximum_balance;
	
		NEW.interest_rate = myrec.interest_rate;
		NEW.interest_frequency = myrec.interest_frequency;
		NEW.lockin_period_frequency = myrec.lockin_period_frequency;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_deposit_accounts BEFORE INSERT OR UPDATE ON deposit_accounts
    FOR EACH ROW EXECUTE PROCEDURE ins_deposit_accounts();
