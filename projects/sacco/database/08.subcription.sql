alter table orgs add default_country_id varchar(6); 

<<<<<<< HEAD:projects/sacco/database/08.subcription.sql

=======
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8:projects/sacco/database/08.subcription.sql
CREATE TABLE locations
(
	location_id			serial primary key,
	org_id 				integer references orgs,
	location_name 			character varying(50),
	details			 text
);




CREATE TABLE members (
	entity_id			integer references entitys primary key,
	bank_branch_id			integer not null references bank_branch, 
	member_id			varchar(12) not null unique ,
	location_id			integer references locations,
	currency_id			integer references currency,
	org_id				integer references orgs unique,

	person_title			varchar(7),
	surname				varchar(50) not null,
	first_name			varchar(50) not null,
	middle_name			varchar(50),
	date_of_birth			date,
	
	gender				varchar(1),
	phone				varchar(120),
	nationality			char(2) not null references sys_countrys,
	
	nation_of_birth			char(2) references sys_countrys,
	place_of_birth			varchar(50),
	
	salary 				real,
	marital_status 			varchar(2),
	appointment_date		date,
	current_appointment		date,

	exit_date			date,
	bank_account			varchar(32),
	picture_file			varchar(32),
	active				boolean default true not null,
	language			varchar(320),
	desg_code			varchar(16),
	inc_mth				varchar(16),
	
	interests			text,
	objective			text,
	details				text

);

ALTER TABLE orgs ADD member_limit integer default 5 not null;
ALTER TABLE orgs ADD transaction_limit integer default 100 not null;


CREATE TABLE industry (
	industry_id			serial primary key,
	org_id				integer references orgs,
	industry_name			varchar(50) not null,
	details				text
);
CREATE INDEX industry_org_id ON industry(org_id);

CREATE TABLE subscriptions (
	subscription_id			serial primary key,
	industry_id			integer references industry,
	entity_id			integer references entitys,
	account_manager_id		integer references entitys,
	org_id				integer references orgs,

	business_name			varchar(50),
	business_address		varchar(100),
	city				varchar(30),
	state				varchar(50),
	country_id			char(2) references sys_countrys,
	number_of_members		integer,
	telephone			varchar(50),
	website				varchar(120),
	
	primary_contact			varchar(120),
	job_title				varchar(120),
	primary_email			varchar(120),
	confirm_email			varchar(120),
	
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	
	details					text
);
CREATE INDEX subscriptions_industry_id ON subscriptions(industry_id);
CREATE INDEX subscriptions_entity_id ON subscriptions(entity_id);
CREATE INDEX subscriptions_account_manager_id ON subscriptions(account_manager_id);
CREATE INDEX subscriptions_country_id ON subscriptions(country_id);
CREATE INDEX subscriptions_org_id ON subscriptions(org_id);

CREATE TABLE products (
	product_id				serial primary key,
	org_id					integer references orgs,
	product_name			varchar(50),
	is_montly_bill			boolean default false not null,
	montly_cost				real default 0 not null,
	is_annual_bill			boolean default true not null,
	annual_cost				real default 0 not null,
	
	transaction_limit		integer not null,
	
	details					text
);
CREATE INDEX products_org_id ON products(org_id);

INSERT INTO products (org_id, product_name, transaction_limit) VALUES (0, 'HCM Hosting', 5);

CREATE TABLE productions (
	production_id			serial primary key,
	subscription_id			integer references subscriptions,
	product_id				integer references products,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	
	approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	
	montly_billing			boolean default false not null,
	is_active				boolean default false not null,
	
	details					text
);
CREATE INDEX productions_subscription_id ON productions(subscription_id);
CREATE INDEX productions_product_id ON productions(product_id);
CREATE INDEX productions_org_id ON productions(org_id);

CREATE VIEW vw_subscriptions AS
	SELECT industry.industry_id, industry.industry_name, sys_countrys.sys_country_id, sys_countrys.sys_country_name,
		entitys.entity_id, entitys.entity_name, 
		account_manager.entity_id as account_manager_id, account_manager.entity_name as account_manager_name,
		orgs.org_id, orgs.org_name, 
		
		subscriptions.subscription_id, subscriptions.business_name, 
		subscriptions.business_address, subscriptions.city, subscriptions.state, subscriptions.country_id, 
		subscriptions.number_of_members, subscriptions.telephone, subscriptions.website, 
		subscriptions.primary_contact, subscriptions.job_title, subscriptions.primary_email, 
		subscriptions.approve_status, subscriptions.workflow_table_id, subscriptions.application_date, subscriptions.action_date, 
		subscriptions.details
	FROM subscriptions INNER JOIN industry ON subscriptions.industry_id = industry.industry_id
		INNER JOIN sys_countrys ON subscriptions.country_id = sys_countrys.sys_country_id
		LEFT JOIN entitys ON subscriptions.entity_id = entitys.entity_id
		LEFT JOIN entitys as account_manager ON subscriptions.account_manager_id = account_manager.entity_id
		LEFT JOIN orgs ON subscriptions.org_id = orgs.org_id;	
		
CREATE VIEW vw_productions AS
	SELECT orgs.org_id, orgs.org_name, 
		products.product_id, products.product_name, products.transaction_limit,
		subscriptions.subscription_id, subscriptions.business_name, 
		
		productions.production_id, productions.approve_status, productions.workflow_table_id, productions.application_date, 
		productions.action_date, productions.montly_billing, productions.is_active, 
		productions.details
	FROM productions INNER JOIN orgs ON productions.org_id = orgs.org_id
		INNER JOIN products ON productions.product_id = products.product_id
		INNER JOIN subscriptions ON productions.subscription_id = subscriptions.subscription_id;

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON subscriptions
    FOR EACH ROW EXECUTE PROCEDURE upd_action();
    
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON productions
    FOR EACH ROW EXECUTE PROCEDURE upd_action();


CREATE OR REPLACE FUNCTION ins_subscriptions()
  RETURNS trigger AS
$BODY$
DECLARE
	v_entity_id		integer;
	v_org_id		integer;
	v_currency_id	integer;
	v_department_id	integer;
	v_bank_id		integer;
	v_org_suffix    char(2);
	rec 			RECORD;
BEGIN

	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys WHERE lower(trim(user_name)) = lower(trim(NEW.primary_email));
		IF(v_entity_id is null)THEN
			NEW.entity_id := nextval('entitys_entity_id_seq');
			INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, primary_email,  function_role, first_password)
			VALUES (NEW.entity_id, 0, 1, NEW.primary_contact, lower(trim(NEW.primary_email)), lower(trim(NEW.primary_email)), 'subscription', null);
		
			INSERT INTO sys_emailed ( org_id, table_id, table_name)
			VALUES ( 0, 1, 'subscription');
		
			ELSE
			RAISE EXCEPTION 'You already have an account, login and request for services';
		END IF ;
		
	ELSIF(NEW.approve_status = 'Approved')THEN

		NEW.org_id := nextval('orgs_org_id_seq');
<<<<<<< HEAD:projects/sacco/database/08.subcription.sql
		INSERT INTO orgs(org_id, currency_id, org_name, org_sufix, default_country_id)
		VALUES(NEW.org_id, 2, NEW.business_name, NEW.org_id, NEW.country_id);
		
		v_currency_id := nextval('currency_currency_id_seq');
		INSERT INTO currency (org_id, currency_id, currency_name, currency_symbol) VALUES (NEW.org_id, v_currency_id, 'KES', 'USD');
		v_currency_id := nextval('currency_currency_id_seq');
		INSERT INTO currency (org_id, currency_id, currency_name, currency_symbol) VALUES (NEW.org_id, v_currency_id, 'KES', 'ERO');
		UPDATE orgs SET currency_id = v_currency_id WHERE org_id = NEW.org_id;
		
=======
		
		
		INSERT INTO orgs(org_id, currency_id, org_name, org_sufix, default_country_id)
		VALUES(NEW.org_id, 1, NEW.business_name, NEW.org_id, NEW.country_id);
		
		
	
		
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8:projects/sacco/database/08.subcription.sql
		v_bank_id := nextval('banks_bank_id_seq');
		INSERT INTO banks (org_id, bank_id, bank_name) VALUES (NEW.org_id, v_bank_id, 'Cash');
		INSERT INTO bank_branch (org_id, bank_id, bank_branch_name) VALUES (NEW.org_id, v_bank_id, 'Cash');
		
		UPDATE entitys SET org_id = NEW.org_id, function_role='subscription,admin,staff,finance'
		WHERE entity_id = NEW.entity_id;

		INSERT INTO sys_emailed ( org_id, table_id, table_name)
		VALUES ( NEW.org_id, NEW.entity_id, 'subscription');
		
		
		
	END IF;
	
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
   
  
CREATE TRIGGER ins_subscriptions BEFORE INSERT OR UPDATE ON subscriptions
    FOR EACH ROW EXECUTE PROCEDURE ins_subscriptions();
 

<<<<<<< HEAD:projects/sacco/database/08.subcription.sql
=======
 

>>>>>>> e829fb97559b72260b88801b69fa435872e337b8:projects/sacco/database/08.subcription.sql
CREATE OR REPLACE FUNCTION ins_member_limit() RETURNS trigger AS $$
DECLARE
	v_member_count	integer;
	v_member_limit	integer;
BEGIN

	SELECT count(entity_id) INTO v_member_count
	FROM members
	WHERE (org_id = NEW.org_id);
	
	SELECT member_limit INTO v_member_limit
	FROM orgs
	WHERE (org_id = NEW.org_id);
	
	IF(v_member_count > v_member_limit)THEN
		RAISE EXCEPTION 'You have reached the maximum staff limit, request for a quite for more';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_member_limit BEFORE INSERT ON members
    FOR EACH ROW EXECUTE PROCEDURE ins_member_limit();

	
CREATE OR REPLACE FUNCTION ins_transactions_limit() RETURNS trigger AS $$
DECLARE
	v_transaction_count	integer;
	v_transaction_limit	integer;
BEGIN

	SELECT count(transaction_id) INTO v_transaction_count
	FROM transactions
	WHERE (org_id = NEW.org_id);
	
	SELECT transaction_limit INTO v_transaction_limit
	FROM orgs
	WHERE (org_id = NEW.org_id);
	
	IF(v_transaction_count > v_transaction_limit)THEN
		RAISE EXCEPTION 'You have reached the maximum transaction limit, request for a quite for more';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_transactions_limit BEFORE INSERT ON transactions
    FOR EACH ROW EXECUTE PROCEDURE ins_transactions_limit();
