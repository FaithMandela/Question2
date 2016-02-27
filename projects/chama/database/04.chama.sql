CREATE TABLE contribution_types (
	contribution_type_id		serial primary key,
	org_id				integer references orgs,
	contribution_type_name		varchar(240),
	merry_go_round			boolean,
	details				text
);


ALTER TABLE contribution_types DROP merry_go_round CASCADE;


CREATE INDEX contribution_types_org_id ON contribution_types (org_id);

 
CREATE TABLE members (
	entity_id 			integer references entitys,
	bank_account_id			integer references bank_accounts,
	bank_branch_id 			integer references bank_branch,
	currency_id 			integer references currency,
 	org_id 				integer references orgs,
	location_id			integer references locations,

 	
	person_title			varchar(50) not null,
	surname 			varchar(50) not null,
	first_name 			varchar(50) not null,
  	middle_name 			varchar(50) not null,
  	id_number			varchar(50) not null,
  	date_of_birth 			date,
  	
	gender 				varchar(1),
 	phone				varchar(50) not null,
  	nationality 			char(2) not null references sys_countrys,
  	nation_of_birth 		char(2) not null references sys_countrys,
  	marital_status 			varchar(2),
	joining_date			date,
	exit_date			date,

 	picture_file 			character varying(32),
  	active 				boolean NOT NULL DEFAULT true,
  	details 			text,
  	);
ALTER TABLE members DROP bank_account_id CASCADE;
ALTER TABLE members ADD bank_account_number varchar(50);
ALTER TABLE members ADD bank_id integer references banks;

CREATE INDEX members_bank_id ON members (bank_id);
CREATE INDEX members_entity_id ON members (entity_id);
CREATE INDEX members_bank_branch_id ON members (bank_branch_id);
CREATE INDEX members_bank_account_id ON members (bank_account_id);
CREATE INDEX members_currency_id ON members (currency_id);
CREATE INDEX members_org_id ON members (org_id);
CREATE INDEX members_location_id ON members (location_id);
CREATE INDEX members_nationality ON members (nationality);
CREATE INDEX members_nation_of_birth ON members (nation_of_birth);

CREATE TABLE contributions (
	contribution_id			serial primary key,
	contribution_type_id		integer references contribution_types,
	entity_id			integer references entitys,
	account_id			integer references accounts,
	period_id			integer references periods,
	org_id				integer references orgs,
	contribution_date		date not null,
	contribution_amount		real not null,
	banking_details			varchar(240),
	confirmation			boolean default false not null,
	member_payment			boolean default false not null,
	share_value			real not null,
	details				text
);

ALTER TABLE contributions ADD meeting_id integer references meetings;
ALTER TABLE contributions ADD merry_go_round_percentage real;
ALTER TABLE contributions ADD actual_amount real;
ALTER TABLE contributions DROP contribution_date CASCADE;
ALTER TABLE contributions ADD merry_go_round boolean default true;
ALTER TABLE contributions DROP confirmation CASCADE;
ALTER TABLE contributions DROP member_payment CASCADE;
ALTER TABLE contributions DROP share_value CASCADE;
ALTER TABLE contributions ADD bank_account_id integer references bank_accounts;


CREATE INDEX contributions_bank_account_id ON contributions (bank_account_id);
CREATE INDEX contributions_contributions_type_id ON contributions (contribution_type_id);
CREATE INDEX contributions_entity_id ON contributions (entity_id);
CREATE INDEX contributions_account_id ON contributions (account_id);
CREATE INDEX contributions_period_id ON contributions (period_id);
CREATE INDEX contributions_org_id ON contributions (org_id);
CREATE INDEX contributions_meeting_id ON contributions (meeting_id);


CREATE TABLE borrowing_types (
	borrowing_type_id		serial primary key,
	org_id           	        integer references orgs,
	borrowing_type_name             varchar (120) ,
	details				text
);

CREATE INDEX borrowing_types_org_id ON borrowing_types (org_id);


CREATE TABLE borrowing (
    	borrowing_id                    serial primary key,
        borrowing_type_id		integer references borrowing_types, 
    	account_id                      integer references  accounts,  
    	currency_id                     integer references currency,
    	org_id                          integer references orgs,

        date_of_borrowing               date,
    	amount                          real not null,
	interest                        varchar(120),
	application_date		timestamp default now() not null,

	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date			timestamp,
	is_active                       boolean default true not null,
    	details                         text
);

ALTER TABLE borrowing ADD bank_account_id integer references bank_accounts;

CREATE INDEX borrowing_bank_account_id ON borrowing (bank_account_id);
CREATE INDEX borrowing_borrowing_type_id ON borrowing (borrowing_type_id);
CREATE INDEX borrowing_account_id ON borrowing (account_id);
CREATE INDEX borrowing_currency_id ON borrowing (currency_id);
CREATE INDEX borrowing_org_id ON borrowing (org_id);

CREATE TABLE penalty_type (
	penalty_type_id			serial primary key,
	org_id                          integer references orgs,
	penalty_type_name               varchar (120) ,
	details				text
);

CREATE INDEX penalty_type_org_id ON penalty_type (org_id);

CREATE TABLE penalty (
    	penalty_id                   	serial primary key,
	penalty_type_id			integer references penalty_type, 
    	account_id                      integer references  accounts,  
    	currency_id                     integer references currency,
    	org_id                          integer references orgs,
	entity_id 			integer references entitys,
	date_of_accrual             	date,
	amount                          real not null,
	status				varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date			timestamp,
	is_active                       boolean default true not null,
    	details                         text
);
ALTER TABLE penalty ADD bank_account_id integer references bank_accounts;

CREATE INDEX penalty_bank_account_id ON penalty (bank_account_id);
CREATE INDEX penalty_penalty_type_id ON penalty (penalty_type_id);
CREATE INDEX penalty_account_id ON penalty (account_id);
CREATE INDEX penalty_currency_id ON penalty (currency_id);
CREATE INDEX penalty_org_id ON penalty (org_id);
CREATE INDEX penalty_entity_id ON penalty (entity_id);

CREATE TABLE borrowing_repayment (
	borrowing_repayment_id		serial primary key,
	org_id                          integer references orgs,
	borrowing_id                    integer references borrowing,
	period_id			integer references periods,
	amount				real not null default 0,
	action_date			timestamp,
	penalty_id			integer references penalty,
	details                         text
);

CREATE INDEX borrowing_repayment_org_id ON borrowing_repayment(org_id);
CREATE INDEX borrowing_repayment_borrowing_id ON borrowing_repayment (borrowing_id);
CREATE INDEX borrowing_repayment_period_id ON borrowing_repayment (period_id);
CREATE INDEX borrowing_repayment_penalty_id ON borrowing_repayment (penalty_id);

CREATE TABLE investment_types (
	investment_type_id		serial primary key,
	org_id                        	integer references orgs,
	investment_type_name            varchar (120) ,
	details				text
);

CREATE INDEX investment_types_org_id ON investment_types (org_id);
ALTER TABLE investment_types ADD interest_amount real;


CREATE TABLE investments (
   	investment_id                   serial primary key,
	investment_type_id		integer references investment_types, 
    	account_id                      integer references  accounts,  
    	currency_id                     integer references currency,
    	org_id                          integer references orgs,
	date_of_accrual                 date,
	amount			        real not null,
	status				varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date			timestamp,
	is_active                       boolean default true not null,
	details                         text
);


ALTER TABLE investments DROP COLUMN amount CASCADE;
ALTER TABLE investments ADD COLUMN principal real;
ALTER TABLE investments ADD COLUMN period real;
ALTER TABLE investments ADD COLUMN monthly_returns real;
ALTER TABLE investments ADD COLUMN total_payment real;
ALTER TABLE investments ADD COLUMN investment_name varchar(120);
ALTER TABLE investments DROP status;
ALTER TABLE investments ADD approve_status varchar (16) ;
ALTER TABLE investments ADD bank_account_id integer references bank_accounts;

CREATE INDEX investments_bank_account_id ON investments (bank_account_id);
CREATE INDEX investments_investment_type_id ON investments (investment_type_id);
CREATE INDEX investments_account_id ON investments (account_id);
CREATE INDEX investments_currency_id ON investments (currency_id);
CREATE INDEX investments_org_id ON investments (org_id);


CREATE TABLE meetings (
	meeting_id			serial primary key,
	org_id                          integer references orgs,

	meeting_date			date,
	amount_contributed		real, 
	meeting_place			varchar (120) not null,
	minutes				varchar (120),
	status				varchar (16) default 'Draft' not null,
	details				text
);

ALTER TABLE meetings ADD entity_id integer references entitys;


CREATE INDEX meetings_org_id ON meetings (org_id);

---trigs
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON investments
   FOR EACH ROW EXECUTE PROCEDURE upd_action();


CREATE OR REPLACE FUNCTION ins_investment() RETURNS TRIGGER AS
$BODY$
DECLARE
    v_principal			        real;
    v_amount				real;
    v_total_payment			real;
    v_period                            real;
    v_interests		                 real;
BEGIN
SELECT interest_amount INTO v_interests FROM  investment_types WHERE investment_type_id = NEW. investment_type_id;
		NEW.default_interest := v_interests;
 		v_amount = New.principal * (v_interests/100) ;
		NEW.total_payment := v_amount + New.principal;
	 	NEW.monthly_returns = NEW.total_payment / NEW.period;  
   	
	
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER ins_investment BEFORE INSERT OR UPDATE ON investments
FOR EACH ROW EXECUTE PROCEDURE ins_investment();




