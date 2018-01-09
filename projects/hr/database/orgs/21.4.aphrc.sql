
CREATE TABLE et_fields (
	et_field_id				serial primary key,
	org_id					integer references orgs,
	et_field_name			varchar(120) not null,
	table_name				varchar(64) not null,
	table_code				integer not null,
	table_link				integer
);
CREATE INDEX et_fields_org_id ON et_fields(org_id);
CREATE INDEX et_fields_table_code ON et_fields(table_code);
CREATE INDEX et_fields_table_link ON et_fields(table_link);

CREATE TABLE e_fields (
	e_field_id				serial primary key,
	et_field_id				integer references et_fields,
	org_id					integer references orgs,
	table_code				integer not null,
	table_id				integer,
	e_field_value			varchar(320)
);
CREATE INDEX e_fields_et_field_id ON e_fields(et_field_id);
CREATE INDEX e_fields_table_id ON e_fields(table_id);
CREATE INDEX e_fields_table_code ON e_fields(table_code);
CREATE INDEX e_fields_org_id ON e_fields(org_id);

CREATE VIEW vw_e_fields AS
	SELECT orgs.org_id, orgs.org_name,
		et_fields.et_field_id, et_fields.et_field_name, et_fields.table_name, et_fields.table_link, 
		e_fields.e_field_id, e_fields.table_code, e_fields.table_id, e_fields.e_field_value
	FROM e_fields INNER JOIN orgs ON e_fields.org_id = orgs.org_id
		INNER JOIN et_fields ON e_fields.et_field_id = et_fields.et_field_id;
		
CREATE TABLE travel_types (
	travel_type_id			serial primary key,
	org_id					integer references orgs,
	travel_type_name		varchar(50) not null,
	details					text,
	UNIQUE(org_id, travel_type_name)
);
CREATE INDEX travel_types_org_id ON travel_types(org_id);

CREATE TABLE travel_agencys (
	travel_agency_id		serial primary key,
	org_id					integer references orgs,
	travel_agency_name		varchar(120) not null,
	travel_agency_phone		varchar(120),
	travel_agency_contact	varchar(120),
	travel_agency_email		varchar(120),
	is_active				boolean default true not null,
	details					text,
	UNIQUE(org_id, travel_agency_name)
);
CREATE INDEX travel_agencys_org_id ON travel_agencys(org_id);

CREATE TABLE travel_funding (
	travel_funding_id		serial primary key,
	org_id					integer references orgs,
	travel_funding_name		varchar(50) not null,
	require_details			boolean default false not null,
	travel_funded			boolean default false not null,
	details					text,
	UNIQUE(org_id, travel_funding_name)
);
CREATE INDEX travel_funding_org_id ON travel_funding(org_id);

CREATE TABLE claim_types (
	claim_type_id			serial primary key,
	adjustment_id			integer references adjustments,
	org_id					integer references orgs,
	claim_type_name			varchar(50),
	details					text,
	UNIQUE(org_id, claim_type_name)
);
CREATE INDEX claim_types_adjustment_id ON claim_types(adjustment_id);
CREATE INDEX claim_types_org_id ON claim_types(org_id);

CREATE TABLE employee_travels (
	employee_travel_id		serial primary key,
	travel_type_id			integer references travel_types,
	entity_id				integer references entitys,
	project_id				integer references projects,
	travel_funding_id		integer references travel_funding,
	travel_agency_id		integer references travel_agencys,
	department_role_id		integer references department_roles,
	org_id					integer references orgs,
	
	funding_details			varchar(320),
	purpose_of_trip			varchar(320) not null,

	other_travel_agency		varchar(120),
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
CREATE INDEX employee_travels_travel_travel_agency_id ON employee_travels(travel_agency_id);
CREATE INDEX employee_travels_department_role_id ON employee_travels(department_role_id);
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
	department_role_id		integer references department_roles,
	org_id					integer references orgs,
	
	claim_date				date not null,
	in_payroll				boolean default false not null,
	narrative				varchar(250),
	
	advance_given			real,
	process_claim			boolean default false not null,
	process_date			date,
	reconciled				boolean default false not null,
	reconciled_date			date,
	validated				boolean default false not null,
	validated_date			date,
	
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
CREATE INDEX claims_department_role_id ON claims(department_role_id);
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
	exchange_rate			real default 1 not null check (exchange_rate > 0),
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
		travel_agencys.travel_agency_id, travel_agencys.travel_agency_name,
		employee_travels.org_id, employee_travels.employee_travel_id, employee_travels.funding_details, 
		employee_travels.purpose_of_trip, employee_travels.other_travel_agency, 
		employee_travels.ticket_cost, employee_travels.application_date, employee_travels.approve_status, 
		employee_travels.workflow_table_id, employee_travels.action_date, employee_travels.details,
		
		vw_claim_travel.t_requested_amount, vw_claim_travel.t_amount,
		vw_department_roles.department_id, vw_department_roles.department_name, 
		vw_department_roles.department_role_id, vw_department_roles.department_role_name,
		COALESCE(unrec.unreconciled, 0) as un_reconciled,
		get_itinerary_start(employee_travels.employee_travel_id) as departure_date,
		get_itinerary_return(employee_travels.employee_travel_id) as arrival_date
	FROM employee_travels INNER JOIN travel_types ON employee_travels.travel_type_id = travel_types.travel_type_id
		INNER JOIN entitys ON employee_travels.entity_id = entitys.entity_id
		INNER JOIN vw_projects ON employee_travels.project_id = vw_projects.project_id
		INNER JOIN travel_funding ON employee_travels.travel_funding_id = travel_funding.travel_funding_id
		INNER JOIN travel_agencys ON employee_travels.travel_agency_id = travel_agencys.travel_agency_id
		LEFT JOIN vw_claim_travel ON employee_travels.employee_travel_id = vw_claim_travel.employee_travel_id
		LEFT JOIN vw_department_roles ON employee_travels.department_role_id = vw_department_roles.department_role_id
		LEFT JOIN (SELECT employee_travel_id, count(claim_id) as unreconciled FROM claims
			WHERE (reconciled = false) GROUP BY employee_travel_id) as unrec
		ON employee_travels.employee_travel_id = unrec.employee_travel_id;
		
CREATE VIEW vw_travel_summary AS
	SELECT vw_employee_travels.department_id, vw_employee_travels.department_name, 
		vw_employee_travels.department_role_id, vw_employee_travels.department_role_name,
		vw_employee_travels.entity_id, vw_employee_travels.entity_name,
		vw_employee_travels.org_id,
		to_char(departure_date, 'yyyy') as travel_year,
		sum(arrival_date - departure_date) as travel_days
	FROM vw_employee_travels
	GROUP BY vw_employee_travels.department_id, vw_employee_travels.department_name, 
		vw_employee_travels.department_role_id, vw_employee_travels.department_role_name,
		vw_employee_travels.entity_id, vw_employee_travels.entity_name,
		vw_employee_travels.org_id,
		to_char(departure_date, 'yyyy');

CREATE VIEW vw_employee_itinerary AS
	SELECT vw_employee_travels.travel_type_id, vw_employee_travels.travel_type_name,
		vw_employee_travels.entity_id, vw_employee_travels.entity_name,
		vw_employee_travels.project_id, vw_employee_travels.project_name, vw_employee_travels.client_name,
		vw_employee_travels.travel_funding_id, vw_employee_travels.travel_funding_name, 
		vw_employee_travels.employee_travel_id, vw_employee_travels.funding_details,
		vw_employee_travels.travel_agency_id, vw_employee_travels.travel_agency_name,
		vw_employee_travels.purpose_of_trip, vw_employee_travels.other_travel_agency, 
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
		vw_department_roles.department_id, vw_department_roles.department_name, 
		vw_department_roles.department_role_id, vw_department_roles.department_role_name,

		claims.org_id, claims.claim_id, claims.employee_adjustment_id, claims.employee_travel_id, 
		claims.claim_date, claims.in_payroll, claims.narrative, claims.advance_given,
		claims.process_claim, claims.process_date, claims.reconciled, claims.reconciled_date, 
		claims.validated, claims.validated_date, claims.application_date, 
		claims.approve_status, claims.workflow_table_id, claims.action_date, claims.details,
		vw_claim_funds.t_requested_amount, vw_claim_funds.t_amount
	FROM claims INNER JOIN claim_types ON claims.claim_type_id = claim_types.claim_type_id
		INNER JOIN entitys ON claims.entity_id = entitys.entity_id
		LEFT JOIN vw_claim_funds ON claims.claim_id = vw_claim_funds.claim_id
		LEFT JOIN vw_department_roles ON claims.department_role_id = vw_department_roles.department_role_id;
		
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
    
CREATE OR REPLACE FUNCTION ins_employee_travels() RETURNS trigger AS $$
BEGIN
	
	SELECT department_role_id INTO NEW.department_role_id
	FROM employees
	WHERE (entity_id = NEW.entity_id);
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_employee_travels BEFORE INSERT OR UPDATE ON employee_travels
	FOR EACH ROW EXECUTE PROCEDURE ins_employee_travels();
	
CREATE OR REPLACE FUNCTION aft_employee_travels() RETURNS trigger AS $$
BEGIN

	IF(TG_OP = 'INSERT')THEN
		INSERT INTO e_fields (et_field_id, org_id, table_code, table_id)
		SELECT et_fields.et_field_id, et_fields.org_id, et_fields.table_code, NEW.employee_travel_id
		FROM et_fields
		WHERE (et_fields.org_id = NEW.org_id) AND (et_fields.table_link = NEW.travel_type_id)
			AND (et_fields.table_code = 111);
	ELSE
		IF((OLD.approve_status = 'Completed') AND (NEW.approve_status = 'Approved'))THEN
			UPDATE claims SET approve_status = 'Approved' WHERE (employee_travel_id = NEW.employee_travel_id);
		END IF;

		IF((NEW.approve_status = 'Draft') AND (OLD.travel_type_id <> NEW.travel_type_id))THEN
			DELETE FROM e_fields WHERE table_id = NEW.employee_travel_id AND et_field_id IN
			(SELECT et_field_id FROM et_fields WHERE (et_fields.org_id = NEW.org_id) AND (et_fields.table_code = 111));
			
			INSERT INTO e_fields (et_field_id, org_id, table_code, table_id)
			SELECT et_fields.et_field_id, et_fields.org_id, et_fields.table_code, NEW.employee_travel_id
			FROM et_fields
			WHERE (et_fields.org_id = NEW.org_id) AND (et_fields.table_link = NEW.travel_type_id)
				AND (et_fields.table_code = 111);
		END IF;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aft_employee_travels AFTER INSERT OR UPDATE ON employee_travels
	FOR EACH ROW EXECUTE PROCEDURE aft_employee_travels();

CREATE OR REPLACE FUNCTION ins_claims() RETURNS trigger AS $$
BEGIN
	
	IF(NEW.employee_travel_id is not null)THEN
		SELECT entity_id INTO NEW.entity_id
		FROM employee_travels WHERE (employee_travel_id = NEW.employee_travel_id);
	END IF;
	
	IF(TG_OP = 'INSERT')THEN
		IF(NEW.process_claim = true)THEN
			NEW.process_date := current_date;
		END IF;
		IF(NEW.reconciled = true)THEN
			NEW.reconciled_date := current_date;
		END IF;
	END IF;
	IF(TG_OP = 'UPDATE')THEN
		IF((OLD.process_claim = false) AND (NEW.process_claim = true))THEN
			NEW.process_date := current_date;
		END IF;
		IF((NEW.reconciled = false) AND (NEW.reconciled = true))THEN
			NEW.reconciled_date := current_date;
		END IF;
	END IF;
	
	SELECT department_role_id INTO NEW.department_role_id
	FROM employees
	WHERE (entity_id = NEW.entity_id);
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_claims BEFORE INSERT OR UPDATE ON claims
	FOR EACH ROW EXECUTE PROCEDURE ins_claims();

CREATE OR REPLACE FUNCTION travel_aplication(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_amount			real;
	msg 				varchar(120);
BEGIN
	msg := 'Travel applied';
	
	UPDATE employee_travels SET approve_status = 'Completed'
	WHERE (employee_travel_id = $1::int) AND (approve_status = 'Draft');

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION claims_aplication(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_amount			real;
	msg 				varchar(120);
BEGIN
	msg := 'Claim applied';
	
	SELECT sum(amount) INTO v_amount
	FROM vw_claim_details
	WHERE (claim_id = $1::int);
	
	IF(v_amount is null)THEN
		RAISE EXCEPTION 'You need to add claim details';
	END IF;
	
	UPDATE claims SET approve_status = 'Completed'
	WHERE (claim_id = $1::int) AND (approve_status = 'Draft');

	RETURN msg;
END;
$$ LANGUAGE plpgsql;


DELETE FROM travel_types;
---SELECT pg_catalog.setval('travel_types_travel_type_id_seq', 1, true);
INSERT INTO travel_types (org_id, travel_type_name) VALUES
(0, 'Conference'),
(0, 'Site Conference'),
(0, 'Site Visit'),
(0, 'Seminar'),
(0, 'Workshop'),
(0, 'Training'),
(0, 'Official duty'),
(0, 'Fieldwork'),
(0, 'Home Leave'),
(0, 'PhD Study');

DELETE FROM travel_funding;
---SELECT pg_catalog.setval('travel_funding_travel_funding_id_seq', 1, true);
INSERT INTO travel_funding (org_id, travel_funding_name, require_details) VALUES
(0, 'APHRC Core', false),
(0, 'APHRC Project (Specify)', true),
(0, 'Other Institution (specify)', true),
(0, 'Partly personal (specify)', true);


INSERT INTO claim_types (adjustment_id, org_id, claim_type_name) VALUES
(21, 0, 'Travel Claim');

INSERT INTO et_fields (org_id, et_field_name, table_name, table_code, table_link) VALUES
(0, 'Role in Conference', 'travel_types', 111, 1),
(0, 'Participant', 'travel_types', 111, 1),
(0, 'Poster Presentation', 'travel_types', 111, 1),
(0, 'Oral Presentation', 'travel_types', 111, 1),
(0, 'Session Chair', 'travel_types', 111, 1),
(0, 'Key note speaker', 'travel_types', 111, 1),
(0, 'Conference website', 'travel_types', 111, 1),
(0, 'Training area', 'travel_types', 111, 6),
(0, 'Role in Training', 'travel_types', 111, 6),
(0, 'Training website', 'travel_types', 111, 6);
