---Project Database File
CREATE TABLE loans (
	loan_id					serial primary key,
	customer_id				integer references customers,
	product_id	 			integer references products,
	org_id					integer references orgs,

	account_number			varchar(32) not null,
	principal_amount		real not null,
	interest_rate			real not null,
	interest_frequency		integer not null,

	disbursed_date			date,
	expected_matured_date	date,
	matured_date			date,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX loans_customer_id ON loans(customer_id);
CREATE INDEX loans_product_id ON loans(product_id);
CREATE INDEX loans_org_id ON loans(org_id);

CREATE TABLE guarantees (
	guarantee_id			serial primary key,
	loan_id					integer references loans,
	customer_id				integer references customers,
	org_id					integer references orgs,
	
	guarantee_amount		real not null,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX guarantees_loan_id ON guarantees(loan_id);
CREATE INDEX guarantees_customer_id ON guarantees(customer_id);
CREATE INDEX guarantees_org_id ON guarantees(org_id);

CREATE TABLE collateral_types (
	collateral_type_id		serial primary key,
	org_id					integer references orgs,
	collateral_type_name	varchar(50) not null,
	details					text,
	UNIQUE(org_id, collateral_type_name)
);
CREATE INDEX collateral_types_org_id ON collateral_types(org_id);

CREATE TABLE collaterals (
	collateral_id			serial primary key,
	loan_id					integer references loans,
	collateral_type_id		integer references collateral_types,
	org_id					integer references orgs,
	
	collateral_amount		real not null,
	collateral_received		boolean default false not null,
	collateral_released		boolean default false not null,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX collaterals_loan_id ON collaterals(loan_id);
CREATE INDEX collaterals_collateral_type_id ON collaterals(collateral_type_id);
CREATE INDEX collaterals_org_id ON collaterals(org_id);

CREATE TABLE loan_notes (
	loan_note_id			serial primary key,
	loan_id					integer references loans,
	org_id					integer references orgs,
	comment_date			timestamp default now() not null,
	narrative				varchar(320) not null,
	note					text not null
);
CREATE INDEX loan_notes_loan_id ON loan_notes(loan_id);
CREATE INDEX loan_notes_org_id ON loan_notes(org_id);

CREATE TABLE loan_activity (
	loan_activity_id		serial primary key,
	loan_id					integer references loans,
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
CREATE INDEX loan_activity_loan_id ON loan_activity(loan_id);
CREATE INDEX loan_activity_activity_type_id ON loan_activity(activity_type_id);
CREATE INDEX loan_activity_currency_id ON loan_activity(currency_id);
CREATE INDEX loan_activity_org_id ON loan_activity(org_id);


CREATE VIEW vw_loans AS
	SELECT customers.customer_id, customers.customer_name, products.product_id, products.product_name, 
		loans.org_id, loans.loan_id, loans.account_number, loans.principal_amount, loans.interest_rate, 
		loans.interest_frequency, loans.disbursed_date, loans.expected_matured_date, loans.matured_date, 
		loans.application_date, loans.approve_status, loans.workflow_table_id, loans.action_date, loans.details
	FROM loans INNER JOIN customers ON loans.customer_id = customers.customer_id
		INNER JOIN products ON loans.product_id = products.product_id;
		
CREATE VIEW vw_guarantees AS
	SELECT vw_loans.customer_id, vw_loans.customer_name, vw_loans.product_id, vw_loans.product_name, 
		vw_loans.loan_id, vw_loans.principal_amount, vw_loans.interest_rate, 
		vw_loans.interest_frequency, vw_loans.disbursed_date, vw_loans.expected_matured_date, vw_loans.matured_date, 
		customers.customer_id as guarantor_id, customers.customer_name as guarantor_name, 
		guarantees.org_id, guarantees.guarantee_id, guarantees.guarantee_amount, guarantees.application_date, 
		guarantees.approve_status, guarantees.workflow_table_id, guarantees.action_date, guarantees.details
	FROM guarantees INNER JOIN vw_loans ON guarantees.loan_id = vw_loans.loan_id
		INNER JOIN customers ON guarantees.customer_id = customers.customer_id;
		
CREATE VIEW vw_collaterals AS
	SELECT vw_loans.customer_id, vw_loans.customer_name, vw_loans.product_id, vw_loans.product_name, 
		vw_loans.loan_id, vw_loans.principal_amount, vw_loans.interest_rate, 
		vw_loans.interest_frequency, vw_loans.disbursed_date, vw_loans.expected_matured_date, vw_loans.matured_date, 
		collateral_types.collateral_type_id, collateral_types.collateral_type_name,
		collaterals.org_id, collaterals.collateral_id, collaterals.collateral_amount, collaterals.collateral_received, 
		collaterals.collateral_released, collaterals.application_date, collaterals.approve_status, 
		collaterals.workflow_table_id, collaterals.action_date, collaterals.details
	FROM collaterals INNER JOIN vw_loans ON collaterals.loan_id = vw_loans.loan_id
		INNER JOIN collateral_types ON collaterals.collateral_type_id = collateral_types.collateral_type_id;
		
CREATE VIEW vw_loan_notes AS
	SELECT vw_loans.customer_id, vw_loans.customer_name, vw_loans.product_id, vw_loans.product_name, 
		vw_loans.loan_id, vw_loans.principal_amount, vw_loans.interest_rate, 
		vw_loans.interest_frequency, vw_loans.disbursed_date, vw_loans.expected_matured_date, vw_loans.matured_date, 
		loan_notes.org_id, loan_notes.loan_note_id, loan_notes.comment_date, loan_notes.narrative, loan_notes.note
	FROM loan_notes INNER JOIN vw_loans ON loan_notes.loan_id = vw_loans.loan_id;
	
CREATE VIEW vw_loan_activity AS
	SELECT vw_loans.customer_id, vw_loans.customer_name, vw_loans.product_id, vw_loans.product_name, 
		vw_loans.loan_id, vw_loans.principal_amount, vw_loans.interest_rate, 
		vw_loans.interest_frequency, vw_loans.disbursed_date, vw_loans.expected_matured_date, vw_loans.matured_date, 
		activity_types.activity_type_id, activity_types.activity_type_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		loan_activity.org_id, loan_activity.loan_activity_id, loan_activity.activity_date, 
		loan_activity.account_credit, loan_activity.account_debit, loan_activity.balance, 
		loan_activity.exchange_rate, loan_activity.application_date, loan_activity.approve_status, 
		loan_activity.workflow_table_id, loan_activity.action_date, loan_activity.details,
		
		(loan_activity.account_credit * loan_activity.exchange_rate) as base_credit,
		(loan_activity.account_debit * loan_activity.exchange_rate) as base_debit
	FROM loan_activity INNER JOIN vw_loans ON loan_activity.loan_id = vw_loans.loan_id
		INNER JOIN activity_types ON loan_activity.activity_type_id = activity_types.activity_type_id
		INNER JOIN currency ON loan_activity.currency_id = currency.currency_id;
		
CREATE OR REPLACE FUNCTION ins_loans() RETURNS trigger AS $$
DECLARE
	myrec			RECORD;
BEGIN

	IF(TG_OP = 'INSERT')THEN
		SELECT interest_rate, interest_frequency, repay_every, min_opening_balance, lockin_period_frequency,
			minimum_balance, maximum_balance INTO myrec
		FROM products WHERE product_id = NEW.product_id;
	
		NEW.account_number := '5' || lpad(NEW.org_id::varchar, 4, '0')  || lpad(NEW.customer_id::varchar, 4, '0') || lpad(NEW.loan_id::varchar, 4, '0');
			
		NEW.interest_rate = myrec.interest_rate;
		NEW.interest_frequency = myrec.interest_frequency;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_loans BEFORE INSERT OR UPDATE ON loans
    FOR EACH ROW EXECUTE PROCEDURE ins_loans();
    
    