
CREATE TABLE travel_types (
	travel_type_id			serial primary key,
	org_id					integer references orgs,
	travel_type_name		varchar(50),
	details					text
);
CREATE INDEX travel_types_org_id ON travel_types(org_id);

CREATE TABLE claim_types (
	claim_type_id			serial primary key,
	adjustment_id			integer references adjustments,
	org_id					integer references orgs,
	claim_type_name			varchar(50),
	details					text
);
CREATE INDEX claim_types_adjustment_id ON claim_types(adjustment_id);
CREATE INDEX claim_types_org_id ON claim_types(org_id);


CREATE TABLE employee_travels (
	employee_travel_id		serial primary key,
	travel_type_id			integer references travel_types,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	
	travel_date				date not null,
	return_date				date not null,
	
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
	
	details					text
);
CREATE INDEX employee_travels_travel_type_id ON employee_travels(travel_type_id);
CREATE INDEX employee_travels_entity_id ON employee_travels(entity_id);
CREATE INDEX employee_travels_org_id ON employee_travels(org_id);

CREATE TABLE claims (
	claim_id				serial primary key,
	claim_type_id			integer references claim_types,
	entity_id				integer references entitys,
	employee_adjustment_id	integer references employee_adjustments,
	employee_travel_id		integer references employee_travels,
	org_id					integer references orgs,
	
	claim_date				date not null,
	in_payroll				boolean not null default false,
	narrative				varchar(250),
	
	process_claim			boolean not null default false,
	process_date			date,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
	
	details					text
);
CREATE INDEX claims_claim_type_id ON claims(claim_type_id);
CREATE INDEX claims_entity_id ON claims(entity_id);
CREATE INDEX claims_employee_adjustment_id ON claims(employee_adjustment_id);
CREATE INDEX claims_employee_travel_id ON claims(employee_travel_id);
CREATE INDEX claims_org_id ON claims(org_id);

CREATE TABLE claim_details (
	claim_detail_id			serial primary key,
	claim_id				integer references claims,
	currency_id				integer references currency,
	org_id					integer references orgs,
	
	nature_of_expence		varchar(50),
	receipt_number			varchar(50),
	amount					real not null,
	exchange_rate			real default 1 not null,
	expense_code			varchar(50),

	details					text
);
CREATE INDEX claim_details_claim_id ON claim_details(claim_id);
CREATE INDEX claim_details_currency_id ON claim_details(currency_id);
CREATE INDEX claim_details_org_id ON claim_details(org_id);


CREATE VIEW vw_claim_types AS
	SELECT adjustments.adjustment_id, adjustments.adjustment_name, 
		claim_types.org_id, claim_types.claim_type_id, claim_types.claim_type_name, claim_types.details
	FROM claim_types INNER JOIN adjustments ON claim_types.adjustment_id = adjustments.adjustment_id;
	
CREATE VIEW vw_claims AS
	SELECT claim_types.claim_type_id, claim_types.claim_type_name, 
		entitys.entity_id, entitys.entity_name, 
		claims.org_id, claims.claim_id, claims.claim_date, claims.narrative, claims.in_payroll,
		claims.process_claim, claims.process_date,
		claims.application_date, claims.approve_status, claims.workflow_table_id, claims.action_date, 
		claims.details
	FROM claims INNER JOIN claim_types ON claims.claim_type_id = claim_types.claim_type_id
		INNER JOIN entitys ON claims.entity_id = entitys.entity_id;
		
CREATE VIEW vw_claim_details AS
	SELECT vw_claims.claim_type_id, vw_claims.claim_type_name, vw_claims.entity_id, vw_claims.entity_name, 
		vw_claims.claim_id, vw_claims.claim_date, vw_claims.narrative, vw_claims.application_date, 
		vw_claims.approve_status, vw_claims.workflow_table_id, vw_claims.action_date,

		currency.currency_id, currency.currency_name, currency.currency_symbol,
		claim_details.org_id, claim_details.claim_detail_id, claim_details.nature_of_expence, 
		claim_details.receipt_number, claim_details.amount, claim_details.exchange_rate, claim_details.expense_code, 
		claim_details.details
	FROM claim_details INNER JOIN vw_claims ON claim_details.claim_id = vw_claims.claim_id
		INNER JOIN currency ON claim_details.currency_id = currency.currency_id;

		
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON employee_travels
    FOR EACH ROW EXECUTE PROCEDURE upd_action();

    
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON claims
    FOR EACH ROW EXECUTE PROCEDURE upd_action();
