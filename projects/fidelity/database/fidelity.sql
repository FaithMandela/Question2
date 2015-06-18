---Project Database File
CREATE TABLE clients (
	entity_id				integer references entitys primary key,
	org_id					integer references orgs,

	person_title			varchar(7),
	surname					varchar(50) not null,
	first_name				varchar(50) not null,
	middle_name				varchar(50),
	date_of_birth			date,
	
	gender					varchar(1),
	phone					varchar(120),
	nationality				char(2) not null references sys_countrys,
	
	nation_of_birth			char(2) references sys_countrys,
	place_of_birth			varchar(50),
	
	approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	
	details					text
);
CREATE INDEX clients_entity_id ON clients (entity_id);
CREATE INDEX clients_org_id ON clients(org_id);



CREATE TABLE loan_types (
	loan_type_id			serial primary key,
	org_id					integer references orgs,
	loan_type_name			varchar(50),
	default_interest		integer,
	details					text
);
CREATE INDEX loan_types_org_id ON loan_types(org_id);

CREATE TABLE loans (
	loan_id 				serial primary key,
	loan_type_id			integer references loan_types,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	loan_date				date not null default current_date,
	principle				real not null,
	interest				real not null,
	monthly_repayment		real not null,
	repayment_period		integer not null CHECK (repayment_period > 0),

	approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,

	
	details				text
);
CREATE INDEX loans_loan_type_id ON loans(loan_type_id);
CREATE INDEX loans_entity_id ON loans(entity_id);
CREATE INDEX loans_org_id ON loans(org_id);

CREATE VIEW vw_loans AS
	SELECT entitys.entity_id, entitys.entity_name, loan_types.loan_type_id, loan_types.loan_type_name, 
		loans.org_id, loans.loan_id, loans.loan_date, loans.principle, loans.interest, loans.monthly_repayment, 
		loans.repayment_period, loans.approve_status, loans.workflow_table_id, loans.application_date, 
		loans.action_date, loans.details
	FROM loans INNER JOIN entitys ON loans.entity_id = entitys.entity_id
		INNER JOIN loan_types ON loans.loan_type_id = loan_types.loan_type_id;
		
		
		
		