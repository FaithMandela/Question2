---Project Database File
UPDATE entity_types SET entity_type_name = 'Tenants' WHERE entity_type_id = 3;

ALTER TABLE entitys ADD	account_id		integer references accounts;
ALTER TABLE entitys ADD	attention		varchar(50);
CREATE INDEX entitys_account_id ON entitys (account_id);

ALTER TABLE orgs ADD 	cert_number				varchar(50);
ALTER TABLE orgs ADD	vat_number				varchar(50);
ALTER TABLE orgs ADD	fixed_budget			boolean default true;
ALTER TABLE orgs ADD	invoice_footer			text;

CREATE TABLE bank_accounts (
	bank_account_id			serial primary key,
	bank_branch_id			integer references bank_branch,
	account_id				integer references accounts,
	currency_id				integer references currency,
	org_id					integer references orgs,
	bank_account_name		varchar(120),
	bank_account_number		varchar(50),
    narrative				varchar(240),
	is_default				boolean default false not null,
	is_active				boolean default true not null,
    details					text
);
CREATE INDEX bank_accounts_bank_branch_id ON bank_accounts (bank_branch_id);
CREATE INDEX bank_accounts_account_id ON bank_accounts (account_id);
CREATE INDEX bank_accounts_currency_id ON bank_accounts (currency_id);
CREATE INDEX bank_accounts_org_id ON bank_accounts (org_id);

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
	narrative				varchar(240)
);
CREATE INDEX period_rentals_rental_id ON period_rentals (rental_id);
CREATE INDEX period_rentals_period_id ON period_rentals (period_id);
CREATE INDEX period_rentals_org_id ON period_rentals (org_id);

CREATE TABLE receipts (
	receipt_id				serial primary key,
	entity_id				integer references entitys,				--- tenants
	bank_account_id			integer references bank_accounts,
	org_id					integer references orgs,
	receipt_number			varchar(50),
	pay_date				date not null,
	pay_completed			boolean,
	amount					float,
	details					text
);
CREATE INDEX receipts_entity_id ON receipts (entity_id);
CREATE INDEX receipts_bank_account_id ON receipts (bank_account_id);
CREATE INDEX receipts_org_id ON receipts (org_id);

CREATE TABLE payments (
	payment_id				serial primary key,
	entity_id				integer references entitys,				--- Client
	bank_account_id			integer references bank_accounts,
	org_id					integer references orgs,
	receipt_number			varchar(50),
	pay_date				date,
	amount					float,
	details					text
);
CREATE INDEX payments_entity_id ON payments (entity_id);
CREATE INDEX payments_bank_account_id ON payments (bank_account_id);
CREATE INDEX payments_org_id ON payments (org_id);

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

DROP VIEW vw_entitys;
DROP VIEW vw_orgs;

CREATE VIEW vw_orgs AS
	SELECT orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo, orgs.details,
		orgs.cert_number, orgs.pin, orgs.vat_number, orgs.invoice_footer,
		vw_address.sys_country_id, vw_address.sys_country_name, vw_address.address_id, vw_address.table_name,
		vw_address.post_office_box, vw_address.postal_code, vw_address.premises, vw_address.street, vw_address.town, 
		vw_address.phone_number, vw_address.extension, vw_address.mobile, vw_address.fax, vw_address.email, vw_address.website
	FROM orgs INNER JOIN vw_address ON orgs.org_id = vw_address.table_id
	WHERE (vw_address.table_name = 'orgs') AND (orgs.is_default = true) AND (orgs.is_active = true);

CREATE VIEW vw_entitys AS
	SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default, vw_orgs.is_active as org_is_active, 
		vw_orgs.logo as org_logo, vw_orgs.cert_number as org_cert_number, vw_orgs.pin as org_pin, 
		vw_orgs.vat_number as org_vat_number, vw_orgs.invoice_footer as org_invoice_footer,
		vw_orgs.sys_country_id as org_sys_country_id, vw_orgs.sys_country_name as org_sys_country_name, 
		vw_orgs.address_id as org_address_id, vw_orgs.table_name as org_table_name,
		vw_orgs.post_office_box as org_post_office_box, vw_orgs.postal_code as org_postal_code, 
		vw_orgs.premises as org_premises, vw_orgs.street as org_street, vw_orgs.town as org_town, 
		vw_orgs.phone_number as org_phone_number, vw_orgs.extension as org_extension, 
		vw_orgs.mobile as org_mobile, vw_orgs.fax as org_fax, vw_orgs.email as org_email, vw_orgs.website as org_website,
		vw_address.address_id, vw_address.address_name,
		vw_address.sys_country_id, vw_address.sys_country_name, vw_address.table_name, vw_address.is_default,
		vw_address.post_office_box, vw_address.postal_code, vw_address.premises, vw_address.street, vw_address.town, 
		vw_address.phone_number, vw_address.extension, vw_address.mobile, vw_address.fax, vw_address.email, vw_address.website,
		entitys.entity_id, entitys.entity_name, entitys.User_name, entitys.Super_User, entitys.Entity_Leader, 
		entitys.Date_Enroled, entitys.Is_Active, entitys.Entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention,
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role, entity_types.use_key
	FROM (entitys LEFT JOIN vw_address ON entitys.entity_id = vw_address.table_id)
		INNER JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id 
	WHERE ((vw_address.table_name = 'entitys') OR (vw_address.table_name is null));

CREATE VIEW vw_bank_accounts AS
	SELECT vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, vw_bank_branch.bank_branch_name, 
		vw_accounts.account_type_id, vw_accounts.account_type_name, vw_accounts.account_id, vw_accounts.account_name,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		bank_accounts.bank_account_id, bank_accounts.org_id, bank_accounts.bank_account_name, bank_accounts.bank_account_number, 
		bank_accounts.narrative, bank_accounts.is_active, bank_accounts.details
	FROM bank_accounts INNER JOIN vw_bank_branch ON bank_accounts.bank_branch_id = vw_bank_branch.bank_branch_id
		INNER JOIN vw_accounts ON bank_accounts.account_id = vw_accounts.account_id
		INNER JOIN currency ON bank_accounts.currency_id = currency.currency_id;

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

CREATE VIEW vw_receipts AS
	SELECT entitys.entity_id as tenant_id, entitys.entity_name as tenant_name, 
		vw_bank_accounts.bank_id, vw_bank_accounts.bank_name, vw_bank_accounts.bank_branch_name, 
		vw_bank_accounts.account_id as gl_bank_account_id, vw_bank_accounts.bank_account_id, 
		vw_bank_accounts.bank_account_name, vw_bank_accounts.bank_account_number, 

		receipts.org_id, receipts.receipt_id, receipts.receipt_number, receipts.pay_date, 
		receipts.pay_completed, receipts.amount, receipts.details
	FROM receipts INNER JOIN entitys ON receipts.entity_id = entitys.entity_id
		INNER JOIN vw_bank_accounts ON receipts.bank_account_id = vw_bank_accounts.bank_account_id;

CREATE VIEW vw_payments AS
	SELECT entitys.entity_id as client_id, entitys.entity_name as client_name, 
		vw_bank_accounts.bank_id, vw_bank_accounts.bank_name, vw_bank_accounts.bank_branch_name, 
		vw_bank_accounts.account_id as gl_bank_account_id, vw_bank_accounts.bank_account_id, 
		vw_bank_accounts.bank_account_name, vw_bank_accounts.bank_account_number, 

		payments.org_id, payments.payment_id, payments.receipt_number, payments.pay_date, 
		payments.amount, payments.details
	FROM payments INNER JOIN entitys ON payments.entity_id = entitys.entity_id
		INNER JOIN vw_bank_accounts ON payments.bank_account_id = vw_bank_accounts.bank_account_id;

CREATE VIEW vw_utilities AS
	SELECT vw_property.client_id, vw_property.client_name, vw_property.property_type_id, vw_property.property_type_name,
		vw_property.property_id, vw_property.property_name, vw_property.estate, 
		vw_property.plot_no, vw_property.units,
		utility_types.utility_type_id, utility_types.utility_type_name, 
		utilities.org_id, utilities.utility_id, utilities.payment_date, 
		utilities.payment_done, utilities.amount, utilities.details
	FROM utilities INNER JOIN vw_property ON utilities.property_id = vw_property.property_id
		INNER JOIN utility_types ON utilities.utility_type_id = utility_types.utility_type_id;


