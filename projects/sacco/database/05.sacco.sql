
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
	entity_id 			integer NOT NUll references from,
	bank_branch_id 		integer NOT NULL,
	location_id			integer,
  	currency_id 		integer references currency,
 	org_id 			integer references orgs,
	person_title		character varying(7),
	surname 			character varying(50) NOT NULL,
	first_name 			character varying(50) NOT NULL,
  	middle_name 		character varying(50),
  	date_of_birth 		date,
  	gender 			character varying(1),
 	phone				character varying(120),
  	nationality 		character(2) NOT NULL,
  	nation_of_birth 		character(2),
  	place_of_birth		character varying(50),
  	marital_status 		character varying(2),
  	appointment_date 		date,
 	current_appointment 	date,
  	exit_date 			date,
  	bank_account 		character varying(32),
  	picture_file 		character varying(32),
  	active 			boolean NOT NULL DEFAULT true,
  	language 			character varying(320),
  	desg_code 			character varying(16),
  	inc_mth 			character varying(16),
  	interests 			text,
  	objective 			text,
  	details 			text,
  	salary 			real,
 
 
 
 
 
 
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON applicants
    FOR EACH ROW EXECUTE PROCEDURE upd_action();

CREATE OR REPLACE FUNCTION ins_applicants()
RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		
		IF(NEW.entity_id IS NULL) THEN
			SELECT entity_id INTO v_entity_id
			FROM entitys
			WHERE (trim(lower(user_name)) = trim(lower(NEW.applicant_email)));
				
			IF(v_entity_id is null)THEN
				SELECT org_id INTO rec
				FROM orgs WHERE (is_default = true);

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, 
					primary_email, primary_telephone, function_role)
				VALUES (NEW.entity_id, rec.org_id, 0, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant');
			ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

		INSERT INTO sys_emailed (table_id, table_name)
		VALUES (NEW.entity_id, 'applicant');
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;

			
	END IF;
	
	IF (NEW.approve_status = 'Approved') THEN 
	INSERT INTO members(
            entity_id,org_id, surname, first_name, middle_name,phone, 
            gender,marital_status,salary,nationality,objective, details)
    VALUES (New.entity_id,New.org_id,New.Surname,NEW.First_name,NEW.Middle_name,
    New.applicant_phone,New.gender,New.marital_status,NEW.salary,NEW.nationality,NEW.objective, new.details);
	ELSE
	END IF;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_applicants
  BEFORE INSERT OR UPDATE
  ON applicants
  FOR EACH ROW
  EXECUTE PROCEDURE ins_applicants();


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
	
INSERT INTO loan_types(loan_type_id, org_id, loan_type_name, default_interest) VALUES 
	(0, 0, 'Emergency', 15),
	(1, 0, 'Education', 9),
	(2, 0, 'Development', 10);

INSERT INTO fiscal_years(fiscal_year_id, org_id, fiscal_year_start, fiscal_year_end, year_opened,year_closed, details) VALUES
	(1, 0, '2016-01-01', '2016-05-31', 'true', 'false', 'jajajaja');

INSERT INTO collateral_types(collateral_type_id, org_id, collateral_type_name, details) VALUES 
	(0, 0, 'plot', 'my plot number LR/70/L'),
    (1, 0, 'Car', 'Chasis NO'),
	(2, 0, 'Mortage', 'my plot No and HSE'),
    (3, 0, 'Motor Cycle', 'Chasis No');

INSERT INTO investment_types(investment_type_id, org_id, investment_type_name, details) VALUES 
	(0,15,'Land','buy land'),
	(1,12,'Real Estate','bu'),
	(2,5,'Buy Equity','buy land');


	
