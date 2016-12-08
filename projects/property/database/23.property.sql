---Project Database File
INSERT INTO use_keys (use_key_id, use_key_name, use_function) VALUES (6, 'Tenants', 0);
INSERT INTO entity_types (org_id, entity_type_id, entity_type_name, entity_role, use_key_id) VALUES (0, 6, 'Tenants', 'tenants', 6);


CREATE TABLE property_types (
	property_type_id		serial primary key,
	org_id					integer references orgs,
	property_type_name		varchar(50),
	commercial_property		boolean not null default false,
	details					text
);
CREATE INDEX property_types_org_id ON property_types (org_id);

CREATE TABLE property (
	property_id				serial primary key,
	property_type_id		integer references property_types,
	entity_id				integer references entitys, --- property owner
	org_id					integer references orgs,
	property_name			varchar(50),
	estate					varchar(50),
	plot_no					varchar(50),
	is_active				boolean not null default true,
	units					integer,
	rental_value			float,
	commision_value			float,
	commision_pct			float,
	details					text
);
CREATE INDEX property_property_type_id ON property (property_type_id);
CREATE INDEX property_entity_id ON property (entity_id);
CREATE INDEX property_org_id ON property (org_id);

CREATE TABLE rentals (
	rental_id				serial primary key,
	property_id				integer references property,
	entity_id				integer references entitys,		--- Tenant
	org_id					integer references orgs,
	start_rent				date,
	hse_no					varchar(10),
	elec_no					varchar(50),
	water_no				varchar(50),
	is_active				boolean not null default true,
	rental_value			float not null,
	commision_value			float not null default 0,
	commision_pct			float not null,
	letting_fee				float,
	service_fees			float,
	deposit_fee				float,
	deposit_fee_date		date,
	deposit_refund			float,
	deposit_refund_date		date,
	details					text
);
CREATE INDEX rentals_property_id ON rentals (property_id);
CREATE INDEX rentals_entity_id ON rentals (entity_id);
CREATE INDEX rentals_org_id ON rentals (org_id);

CREATE TABLE period_rentals (
	period_rental_id		serial primary key,
	rental_id				integer references rentals,
	period_id				integer references periods,
	org_id					integer references orgs,
	amount					float not null,
	commision				float not null default 0,
	commision_pct			float not null,
	repairs					float,
	water					float,
	electricity				float,
	service_fees			float,
	narrative				varchar(240)
);
CREATE INDEX period_rentals_rental_id ON period_rentals (rental_id);
CREATE INDEX period_rentals_period_id ON period_rentals (period_id);
CREATE INDEX period_rentals_org_id ON period_rentals (org_id);


CREATE TABLE utility_types (
	utility_type_id			serial primary key,
	org_id					integer references orgs,
	utility_type_name		varchar(120),
	details					text
);
CREATE INDEX utility_types_org_id ON utility_types (org_id);

CREATE TABLE utilities (
	utility_id				serial primary key,
	property_id				integer references property,
	utility_type_id			integer references utility_types,
	org_id					integer references orgs,
	payment_date			date not null,
	payment_done			boolean not null default false,
	amount					real,
	details					text
);
CREATE INDEX utilities_utility_type_id ON utilities (utility_type_id);
CREATE INDEX utilities_property_id ON utilities (property_id);
CREATE INDEX utilities_org_id ON utilities (org_id);


CREATE VIEW vw_property AS
	SELECT entitys.entity_id as client_id, entitys.entity_name as client_name, 
		property_types.property_type_id, property_types.property_type_name,
		property.org_id, property.property_id, property.property_name, property.estate, 
		property.plot_no, property.is_active, property.units, property.rental_value, 
		property.commision_value, property.commision_pct, property.details
	FROM property INNER JOIN entitys ON property.entity_id = entitys.entity_id
		INNER JOIN property_types ON property.property_type_id = property_types.property_type_id;

CREATE VIEW vw_rentals AS
	SELECT vw_property.client_id, vw_property.client_name, vw_property.property_type_id, vw_property.property_type_name,
		vw_property.property_id, vw_property.property_name, vw_property.estate, 
		vw_property.plot_no, vw_property.units,
		entitys.entity_id as tenant_id, entitys.entity_name as tenant_name,
		rentals.org_id, rentals.rental_id, rentals.start_rent, rentals.hse_no, rentals.elec_no, 
		rentals.water_no, rentals.is_active, rentals.rental_value, rentals.commision_value, 
		rentals.commision_pct, rentals.letting_fee, rentals.deposit_fee, rentals.deposit_fee_date, 
		rentals.deposit_refund, rentals.deposit_refund_date, rentals.details
	FROM vw_property INNER JOIN rentals ON vw_property.property_id = rentals.property_id
		INNER JOIN entitys ON rentals.entity_id = entitys.entity_id;

CREATE VIEW vw_period_rentals AS
	SELECT vw_rentals.client_id, vw_rentals.client_name, vw_rentals.property_type_id, vw_rentals.property_type_name,
		vw_rentals.property_id, vw_rentals.property_name, vw_rentals.estate, 
		vw_rentals.plot_no, vw_rentals.units,
		vw_rentals.tenant_id, vw_rentals.tenant_name, 
		vw_rentals.rental_id, vw_rentals.start_rent, vw_rentals.hse_no, vw_rentals.elec_no, 
		vw_rentals.water_no, vw_rentals.is_active, vw_rentals.rental_value, 
		vw_rentals.letting_fee, vw_rentals.deposit_fee, vw_rentals.deposit_fee_date, 
		vw_rentals.deposit_refund, vw_rentals.deposit_refund_date,

		vw_periods.fiscal_year_id, vw_periods.fiscal_year_start, vw_periods.fiscal_year_end,
		vw_periods.year_opened, vw_periods.year_closed,
		vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.opened, vw_periods.closed, 
		vw_periods.month_id, vw_periods.period_year, vw_periods.period_month, vw_periods.quarter, vw_periods.semister,

		period_rentals.org_id, period_rentals.period_rental_id, period_rentals.amount, period_rentals.commision, 
		period_rentals.commision_pct, period_rentals.repairs, period_rentals.water, period_rentals.electricity, 
		period_rentals.narrative
	FROM vw_rentals INNER JOIN period_rentals ON vw_rentals.rental_id = period_rentals.rental_id
		INNER JOIN vw_periods ON period_rentals.period_id = vw_periods.period_id;


CREATE VIEW vw_utilities AS
	SELECT vw_property.client_id, vw_property.client_name, vw_property.property_type_id, vw_property.property_type_name,
		vw_property.property_id, vw_property.property_name, vw_property.estate, 
		vw_property.plot_no, vw_property.units,
		utility_types.utility_type_id, utility_types.utility_type_name, 
		utilities.org_id, utilities.utility_id, utilities.payment_date, 
		utilities.payment_done, utilities.amount, utilities.details
	FROM utilities INNER JOIN vw_property ON utilities.property_id = vw_property.property_id
		INNER JOIN utility_types ON utilities.utility_type_id = utility_types.utility_type_id;


