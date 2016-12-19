---Project Database File

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
	rental_value			float default 0 not null,
	service_fees			float default 0 not null,
	commision_value			float default 0 not null,
	commision_pct			float default 0 not null,
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
	service_fees			float default 0 not null,
	commision_value			float default 0 not null,
	commision_pct			float default 0 not null,
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
	rental_amount			float default 0 not null,
	service_fees			float default 0 not null,
	repair_amount			float default 0 not null,
	commision				float default 0 not null,
	commision_pct			float default 0 not null,
	narrative				varchar(240)
);
CREATE INDEX period_rentals_rental_id ON period_rentals (rental_id);
CREATE INDEX period_rentals_period_id ON period_rentals (period_id);
CREATE INDEX period_rentals_org_id ON period_rentals (org_id);

CREATE TABLE payments (
	payment_id				serial primary key,
	entity_id				integer references entitys,
	bank_account_id			integer references bank_accounts,
	journal_id				integer references journals,
	currency_id				integer references currency,
	org_id					integer references orgs,
	receipt_number			varchar(50),
	pay_date				date not null,
	cleared					boolean default false not null,
	tx_type					integer default 1 not null,
	amount					float not null,
	exchange_rate			real default 1 not null,
	details					text
);
CREATE INDEX payments_entity_id ON payments (entity_id);
CREATE INDEX payments_bank_account_id ON payments (bank_account_id);
CREATE INDEX payments_journal_id ON payments (journal_id);
CREATE INDEX payments_currency_id ON payments (currency_id);
CREATE INDEX payments_org_id ON payments (org_id);


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
		rentals.commision_pct, rentals.service_fees, rentals.deposit_fee, rentals.deposit_fee_date, 
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
		vw_rentals.service_fees, vw_rentals.deposit_fee, vw_rentals.deposit_fee_date, 
		vw_rentals.deposit_refund, vw_rentals.deposit_refund_date,

		vw_periods.fiscal_year_id, vw_periods.fiscal_year_start, vw_periods.fiscal_year_end,
		vw_periods.year_opened, vw_periods.year_closed,
		vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.opened, vw_periods.closed, 
		vw_periods.month_id, vw_periods.period_year, vw_periods.period_month, vw_periods.quarter, vw_periods.semister,

		period_rentals.org_id, period_rentals.period_rental_id, period_rentals.rental_amount, period_rentals.commision, 
		period_rentals.commision_pct, period_rentals.repair_amount, period_rentals.narrative
	FROM vw_rentals INNER JOIN period_rentals ON vw_rentals.rental_id = period_rentals.rental_id
		INNER JOIN vw_periods ON period_rentals.period_id = vw_periods.period_id;

CREATE VIEW vw_payments AS
		SELECT entitys.entity_id, entitys.entity_name, entitys.account_id as entity_account_id, 
		currency.currency_id, currency.currency_name,
		vw_bank_accounts.bank_id, vw_bank_accounts.bank_name, vw_bank_accounts.bank_branch_name, vw_bank_accounts.account_id as gl_bank_account_id, 
		vw_bank_accounts.bank_account_id, vw_bank_accounts.bank_account_name, vw_bank_accounts.bank_account_number, 
		payments.journal_id, payments.org_id, 	
		payments.payment_id, payments.receipt_number, payments.pay_date, payments.cleared, payments.tx_type, 
		payments.amount, payments.exchange_rate, payments.details,
		(payments.tx_type * payments.amount * payments.exchange_rate) as base_amount
	FROM payments INNER JOIN entitys ON payments.entity_id = entitys.entity_id
		INNER JOIN currency ON payments.currency_id = currency.currency_id
		INNER JOIN vw_bank_accounts ON payments.bank_account_id = vw_bank_accounts.bank_account_id
	