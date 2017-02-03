---Project Database File

CREATE TABLE loans (
	loan_id					serial primary key,
	client_id				integer references clients,
	product_id	 			integer references products,
	org_id					integer references orgs,
	account_no				varchar(20) not null,

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
CREATE INDEX loans_client_id ON loans(client_id);
CREATE INDEX loans_product_id ON loans(product_id);
CREATE INDEX loans_org_id ON loans(org_id);

CREATE TABLE guarantors (
	guarantor_id			serial primary key,
	loan_id					integer references loans,
	client_id				integer references clients,
	org_id					integer references orgs,
	
	guarantee_amount		real not null,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX guarantors_loan_id ON guarantors(loan_id);
CREATE INDEX guarantors_client_id ON guarantors(client_id);
CREATE INDEX guarantors_org_id ON guarantors(org_id);


CREATE TABLE loan_activity (
	loan_activity_id		serial primary key,
	loan_id					integer references loans,
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
CREATE INDEX loan_activity_loan_id ON loan_activity(loan_id);
CREATE INDEX loan_activity_activity_type_id ON loan_activity(activity_type_id);
CREATE INDEX loan_activity_currency_id ON loan_activity(currency_id);
CREATE INDEX loan_activity_org_id ON loan_activity(org_id);

CREATE TABLE loan_notes (
	account_note_id			serial primary key,
	loan_id					integer references loans,
	org_id					integer references orgs,
	comment_date			timestamp default now() not null,
	note					text not null
);
CREATE INDEX loan_notes_loan_id ON loan_notes(loan_id);
CREATE INDEX loan_notes_org_id ON loan_notes(org_id);



