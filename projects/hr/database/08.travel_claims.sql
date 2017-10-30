CREATE TABLE travel_types (
	travel_type_id			serial primary key,
	org_id					integer references orgs,
	travel_type_name		varchar(50),
	details					text
);
CREATE INDEX travel_types_org_id ON travel_types(org_id);

CREATE TABLE travel_funding (
	travel_funding_id		serial primary key,
	org_id					integer references orgs,
	travel_funding_name		varchar(50),
	require_details			boolean default false not null,
	travel_funded			boolean default false not null,
	details					text
);
CREATE INDEX travel_funding_org_id ON travel_funding(org_id);

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
	project_id				integer references projects,
	travel_funding_id		integer references travel_funding,
	org_id					integer references orgs,
	
	funding_details			varchar(320),
	purpose_of_trip			varchar(320) not null,

	travel_agent			varchar(120),
	ticket_from				varchar(120),
	ticket_cost				real,
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
	
	details					text
);
CREATE INDEX employee_travels_travel_type_id ON employee_travels(travel_type_id);
CREATE INDEX employee_travels_entity_id ON employee_travels(entity_id);
CREATE INDEX employee_travels_project_id ON employee_travels(project_id);
CREATE INDEX employee_travels_travel_funding_id ON employee_travels(travel_funding_id);
CREATE INDEX employee_travels_org_id ON employee_travels(org_id);

CREATE TABLE employee_itinerary (
	employee_itinerary_id	serial primary key,
	employee_travel_id		integer references employee_travels,
	org_id					integer references orgs,
	
	travel_date				date not null,
	departure_time			time not null,
	arrival_time			time not null,
	departure				varchar(120) not null,
	arrival					varchar(120) not null,
	carrier					varchar(120),
	flight_number			varchar(50)
);
CREATE INDEX employee_itinerary_employee_travel_id ON employee_itinerary(employee_travel_id);
CREATE INDEX employee_itinerary_org_id ON employee_itinerary(org_id);

CREATE TABLE claims (
	claim_id				serial primary key,
	claim_type_id			integer references claim_types,
	entity_id				integer references entitys,
	employee_adjustment_id	integer references employee_adjustments,
	employee_travel_id		integer references employee_travels,
	org_id					integer references orgs,
	
	claim_date				date not null,
	in_payroll				boolean default false not null,
	narrative				varchar(250),
		
	process_claim			boolean default false not null,
	process_date			date,
	
	advance_given			real,
	reconciled				boolean default false not null,
	reconciled_date			date,
	
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
	
	nature_of_expence		varchar(320),
	receipt_number			varchar(50),
	requested_amount		real not null,
	amount					real default 0 not null,
	exchange_rate			real default 1 not null,
	expense_code			varchar(50),
	
	create_date				timestamp default now()
);
CREATE INDEX claim_details_claim_id ON claim_details(claim_id);
CREATE INDEX claim_details_currency_id ON claim_details(currency_id);
CREATE INDEX claim_details_org_id ON claim_details(org_id);

CREATE OR REPLACE FUNCTION get_itinerary_start(integer) RETURNS date AS $$
	SELECT min(travel_date)
	FROM employee_itinerary WHERE (employee_travel_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_itinerary_return(integer) RETURNS date AS $$
	SELECT max(travel_date)
	FROM employee_itinerary WHERE (employee_travel_id = $1);
$$ LANGUAGE SQL;

CREATE VIEW vw_claim_travel AS
	SELECT claims.employee_travel_id,
		sum(claim_details.requested_amount * claim_details.exchange_rate) as t_requested_amount,
		sum(claim_details.amount * claim_details.exchange_rate) as t_amount
	FROM claim_details INNER JOIN claims ON claim_details.claim_id = claims.claim_id
	GROUP BY claims.employee_travel_id;

CREATE VIEW vw_employee_travels AS
	SELECT travel_types.travel_type_id, travel_types.travel_type_name,
		entitys.entity_id, entitys.entity_name,
		vw_projects.project_id, vw_projects.project_name, vw_projects.client_name,
		travel_funding.travel_funding_id, travel_funding.travel_funding_name, 
		employee_travels.org_id, employee_travels.employee_travel_id, employee_travels.funding_details, 
		employee_travels.purpose_of_trip, employee_travels.travel_agent, employee_travels.ticket_from, 
		employee_travels.ticket_cost, employee_travels.application_date, employee_travels.approve_status, 
		employee_travels.workflow_table_id, employee_travels.action_date, employee_travels.details,
		
		vw_claim_travel.t_requested_amount, vw_claim_travel.t_amount,
		get_itinerary_start(employee_travels.employee_travel_id) as departure_date,
		get_itinerary_return(employee_travels.employee_travel_id) as arrival_date
	FROM employee_travels INNER JOIN travel_types ON employee_travels.travel_type_id = travel_types.travel_type_id
		INNER JOIN entitys ON employee_travels.entity_id = entitys.entity_id
		INNER JOIN vw_projects ON employee_travels.project_id = vw_projects.project_id
		INNER JOIN travel_funding ON employee_travels.travel_funding_id = travel_funding.travel_funding_id
		LEFT JOIN vw_claim_travel ON employee_travels.employee_travel_id = vw_claim_travel.employee_travel_id;

CREATE VIEW vw_employee_itinerary AS
	SELECT vw_employee_travels.travel_type_id, vw_employee_travels.travel_type_name,
		vw_employee_travels.entity_id, vw_employee_travels.entity_name,
		vw_employee_travels.project_id, vw_employee_travels.project_name, vw_employee_travels.client_name,
		vw_employee_travels.travel_funding_id, vw_employee_travels.travel_funding_name, 
		vw_employee_travels.employee_travel_id, vw_employee_travels.funding_details, 
		vw_employee_travels.purpose_of_trip, vw_employee_travels.travel_agent, vw_employee_travels.ticket_from, 
		vw_employee_travels.ticket_cost, vw_employee_travels.application_date, vw_employee_travels.approve_status, 
		vw_employee_travels.workflow_table_id, vw_employee_travels.action_date, vw_employee_travels.details,
		vw_employee_travels.departure_date, vw_employee_travels.arrival_date,

		orgs.org_id, orgs.org_name, orgs.logo,
		employee_itinerary.employee_itinerary_id, employee_itinerary.travel_date, 
		employee_itinerary.departure_time, employee_itinerary.arrival_time,
		employee_itinerary.departure, employee_itinerary.arrival, employee_itinerary.carrier, employee_itinerary.flight_number
		
	FROM employee_itinerary INNER JOIN vw_employee_travels ON employee_itinerary.employee_travel_id = vw_employee_travels.employee_travel_id
	INNER JOIN orgs ON employee_itinerary.org_id = orgs.org_id;
	
CREATE VIEW vw_claim_types AS
	SELECT adjustments.adjustment_id, adjustments.adjustment_name, 
		claim_types.org_id, claim_types.claim_type_id, claim_types.claim_type_name, claim_types.details
	FROM claim_types INNER JOIN adjustments ON claim_types.adjustment_id = adjustments.adjustment_id;
	
CREATE VIEW vw_claim_funds AS
	SELECT claim_details.claim_id,
		sum(claim_details.requested_amount * claim_details.exchange_rate) as t_requested_amount,
		sum(claim_details.amount * claim_details.exchange_rate) as t_amount
	FROM claim_details
	GROUP BY claim_details.claim_id;
	
CREATE VIEW vw_claims AS
	SELECT claim_types.claim_type_id, claim_types.claim_type_name, 
		entitys.entity_id, entitys.entity_name, 
		claims.org_id, claims.claim_id, claims.employee_adjustment_id, claims.employee_travel_id, 
		claims.claim_date, claims.in_payroll, claims.narrative, claims.process_claim, claims.process_date, 
		claims.advance_given, claims.reconciled, claims.reconciled_date, claims.application_date, 
		claims.approve_status, claims.workflow_table_id, claims.action_date, claims.details,
		vw_claim_funds.t_requested_amount, vw_claim_funds.t_amount
	FROM claims INNER JOIN claim_types ON claims.claim_type_id = claim_types.claim_type_id
		INNER JOIN entitys ON claims.entity_id = entitys.entity_id
		LEFT JOIN vw_claim_funds ON claims.claim_id = vw_claim_funds.claim_id;
		
CREATE VIEW vw_claim_details AS
	SELECT vw_claims.claim_type_id, vw_claims.claim_type_name, vw_claims.entity_id, vw_claims.entity_name, 
		vw_claims.claim_id, vw_claims.claim_date, vw_claims.narrative, vw_claims.application_date, 
		vw_claims.approve_status, vw_claims.workflow_table_id, vw_claims.action_date,

		currency.currency_id, currency.currency_name, currency.currency_symbol,
		claim_details.org_id, claim_details.claim_detail_id, claim_details.nature_of_expence, 
		claim_details.receipt_number, claim_details.requested_amount, claim_details.amount, 
		claim_details.exchange_rate, claim_details.expense_code,
		(claim_details.requested_amount * claim_details.exchange_rate) as b_requested_amount,
		(claim_details.amount * claim_details.exchange_rate) as b_amount
	FROM claim_details INNER JOIN vw_claims ON claim_details.claim_id = vw_claims.claim_id
		INNER JOIN currency ON claim_details.currency_id = currency.currency_id;

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON employee_travels
    FOR EACH ROW EXECUTE PROCEDURE upd_action();

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON claims
    FOR EACH ROW EXECUTE PROCEDURE upd_action();

CREATE OR REPLACE FUNCTION ins_claims() RETURNS trigger AS $$
BEGIN
	
	IF(NEW.employee_travel_id is not null)THEN
		SELECT entity_id INTO NEW.entity_id
		FROM employee_travels WHERE (employee_travel_id = NEW.employee_travel_id);
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_claims BEFORE INSERT OR UPDATE ON claims
	FOR EACH ROW EXECUTE PROCEDURE ins_claims();
    
