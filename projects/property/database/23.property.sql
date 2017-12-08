---Project Database File

---Property tables
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
	details					text
);
CREATE INDEX property_property_type_id ON property (property_type_id);
CREATE INDEX property_entity_id ON property (entity_id);
CREATE INDEX property_org_id ON property (org_id);

ALTER TABLE transactions
ADD property_id				integer references property;
CREATE INDEX transactions_property_id ON transactions (property_id);

ALTER TABLE helpdesk
ADD property_id				integer references property;
CREATE INDEX helpdesk_property_id ON helpdesk(property_id);

---property rooms/unit types
CREATE TABLE unit_types (
	unit_type_id			serial primary key,
	org_id					integer references orgs,
	unit_type_name			varchar(50),
	details					text
);
CREATE INDEX unit_types_org_id ON unit_types (org_id);

---property rooms/units
CREATE TABLE units (
	unit_id					serial primary key,
	property_id				integer references property,
	unit_type_id			integer references unit_types, 
	org_id					integer references orgs,

	unit_name			 	varchar(50),

	is_vacant				boolean not null default true,

	rental_value			float default 0 not null,
	service_fees			float default 0 not null,
	commision_value			float default 0 not null,
	commision_pct			float default 0 not null,
	details					text
);
CREATE INDEX units_property_id ON units (property_id);
CREATE INDEX units_unit_type_id ON units (unit_type_id);
CREATE INDEX units_org_id ON units (org_id);

---Property rentals table
CREATE TABLE rentals (
	rental_id				serial primary key,
	property_id				integer references property,
	entity_id				integer references entitys,		--- Tenant
	org_id					integer references orgs,
	start_rent				date,

	unit_id					integer references units,    ----house no

	elec_no					varchar(50),
	water_no				varchar(50),
	is_active				boolean not null default true,

	rental_value			float not null,
	service_fees			float not null,
	commision_value			float not null,
	commision_pct			float not null,

	deposit_fee				float,
	deposit_fee_date		date,
	deposit_refund			float,
	deposit_refund_date		date,

	details					text
);
CREATE INDEX rentals_property_id ON rentals (property_id);
CREATE INDEX rentals_entity_id ON rentals (entity_id);
CREATE INDEX rentals_org_id ON rentals (org_id);

---Property period rentals 
CREATE TABLE period_rentals (
	period_rental_id		serial primary key,
	rental_id				integer references rentals,
	period_id				integer references periods,
	property_id				integer references property,
	entity_id				integer references entitys,		--- Tenant
	sys_audit_trail_id		integer references sys_audit_trail,
	org_id					integer references orgs,
	rental_amount			float not null,
	service_fees			float not null,
	repair_amount			float default 0 not null,
	commision				float not null,
	commision_pct			float not null,
	status					varchar(50) default 'Draft' not null,
	narrative				varchar(240)
);
CREATE INDEX period_rentals_rental_id ON period_rentals (rental_id);
CREATE INDEX period_rentals_period_id ON period_rentals (period_id);
CREATE INDEX period_rentals_property_id ON period_rentals (property_id);
CREATE INDEX period_rentals_entity_id ON period_rentals (entity_id);
CREATE INDEX period_rentals_sys_audit_trail_id ON period_rentals (sys_audit_trail_id);
CREATE INDEX period_rentals_org_id ON period_rentals (org_id);

CREATE TABLE log_period_rentals (
	log_period_rental_id	serial primary key,
	sys_audit_trail_id		integer references sys_audit_trail,
	period_rental_id		integer,
	rental_id				integer,
	period_id				integer,
	org_id					integer,
	rental_amount			float,
	service_fees			float,
	repair_amount			float,
	commision				float,
	commision_pct			float,
	status					varchar(50),
	narrative				varchar(240)
);
CREATE INDEX log_period_rentals_period_rental_id ON log_period_rentals (period_rental_id);
CREATE INDEX log_period_rentals_sys_audit_trail_id ON log_period_rentals (sys_audit_trail_id);

---Property,  Rentals and period rentals views 
CREATE OR REPLACE VIEW vw_property AS
	SELECT entitys.entity_id as client_id, entitys.entity_name as client_name, 
		property_types.property_type_id, property_types.property_type_name,
		property.org_id, property.property_id, property.property_name, property.estate, 
		property.plot_no, property.is_active, property.details,get_units(property.property_id) AS units,get_occupied(property.property_id) as accupied,
		(get_units(property.property_id) - get_occupied(property.property_id)) as vacant
	FROM property 
		INNER JOIN entitys ON property.entity_id = entitys.entity_id
		INNER JOIN property_types ON property.property_type_id = property_types.property_type_id;

CREATE OR REPLACE VIEW vw_units AS
	SELECT units.unit_id, units.property_id, units.unit_type_id, units.org_id, 
		units.unit_name, units.is_vacant, units.rental_value, units.service_fees, 
		units.commision_value, units.commision_pct, units.details, 
		unit_types.unit_type_name, property.property_name, property.estate, 
		property.plot_no, property.is_active
	FROM property 
		INNER JOIN units ON property.property_id = units.property_id
		INNER JOIN unit_types ON unit_types.unit_type_id = units.unit_type_id;

CREATE OR REPLACE VIEW vw_rentals AS
	SELECT vw_property.client_id, vw_property.client_name, vw_property.property_type_id, vw_property.property_type_name,
		vw_property.property_id, vw_property.property_name, vw_property.estate, 
		vw_property.plot_no,
		entitys.entity_id as tenant_id, entitys.entity_name as tenant_name,
		rentals.org_id, rentals.rental_id, units.unit_id,(units.unit_name) AS hse_no, rentals.start_rent, rentals.elec_no, 
		rentals.water_no, rentals.is_active, rentals.rental_value, rentals.commision_value, 
		rentals.commision_pct, rentals.service_fees, rentals.deposit_fee, rentals.deposit_fee_date, 
		rentals.deposit_refund, rentals.deposit_refund_date, rentals.details
	FROM vw_property 
		INNER JOIN rentals ON vw_property.property_id = rentals.property_id
		INNER JOIN entitys ON rentals.entity_id = entitys.entity_id
		INNER JOIN units ON rentals.unit_id = units.unit_id;

CREATE OR REPLACE VIEW vw_period_rentals AS
		SELECT vw_rentals.client_id, vw_rentals.client_name, vw_rentals.property_type_id, vw_rentals.property_type_name,
		vw_rentals.property_id, vw_rentals.property_name, vw_rentals.estate, 
		vw_rentals.plot_no, vw_rentals.tenant_id, vw_rentals.tenant_name, 
		vw_rentals.rental_id, vw_rentals.start_rent, vw_rentals.hse_no, vw_rentals.elec_no, 
		vw_rentals.water_no, vw_rentals.is_active, vw_rentals.rental_value, 
		vw_rentals.deposit_fee, vw_rentals.deposit_fee_date, 
		vw_rentals.deposit_refund, vw_rentals.deposit_refund_date,

		vw_periods.fiscal_year_id, vw_periods.fiscal_year_start, vw_periods.fiscal_year_end,
		vw_periods.year_opened, vw_periods.year_closed,
		vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.opened, vw_periods.closed, 
		vw_periods.month_id, vw_periods.period_year, vw_periods.period_month, vw_periods.quarter, vw_periods.semister,

		period_rentals.org_id, period_rentals.period_rental_id, period_rentals.rental_amount, period_rentals.service_fees,
		period_rentals.commision, period_rentals.commision_pct, period_rentals.repair_amount, period_rentals.narrative,period_rentals.status,
		(period_rentals.rental_amount - period_rentals.commision) as rent_to_remit,
		(period_rentals.rental_amount + period_rentals.service_fees + period_rentals.repair_amount) as rent_to_pay
	FROM vw_rentals INNER JOIN period_rentals ON vw_rentals.rental_id = period_rentals.rental_id
		INNER JOIN vw_periods ON period_rentals.period_id = vw_periods.period_id;

CREATE OR REPLACE VIEW vw_tenant_rentals AS
	SELECT entitys.entity_id, entitys.entity_name as tenant_name,
		
		rentals.org_id, rentals.rental_id, rentals.start_rent, units.unit_id,(units.unit_name) AS hse_no, rentals.elec_no, 
		rentals.water_no, rentals.is_active, rentals.rental_value, rentals.commision_value, 
		rentals.commision_pct, rentals.service_fees, rentals.deposit_fee, rentals.deposit_fee_date, 
		rentals.deposit_refund, rentals.deposit_refund_date, rentals.details
	
		FROM rentals
			INNER JOIN entitys ON rentals.entity_id = entitys.entity_id
			INNER JOIN units ON rentals.unit_id = units.unit_id;


CREATE OR REPLACE VIEW vw_client_property AS
	SELECT entitys.entity_id, entitys.entity_name as client_name,	 
		property_types.property_type_id, property_types.property_type_name,
		property.org_id, property.property_id,property.property_name, property.estate,property.plot_no, 
		property.is_active, property.details		
		FROM property 
			INNER JOIN entitys ON property.entity_id = entitys.entity_id
			INNER JOIN property_types ON property.property_type_id = property_types.property_type_id;
