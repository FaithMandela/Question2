CREATE TABLE stores (
	store_id				serial primary key,
	org_id					integer references orgs,
	store_name				varchar(120),
	details					text
);
CREATE INDEX stores_org_id ON stores (org_id);

CREATE TABLE item_category (
	item_category_id		serial primary key,
	org_id					integer references orgs,
	item_category_name		varchar(120) not null unique,
	details					text  
);
CREATE INDEX item_category_org_id ON item_category (org_id);
INSERT INTO item_category (org_id, item_category_name) VALUES (0, 'Services');
INSERT INTO item_category (org_id, item_category_name) VALUES (0, 'Goods');
INSERT INTO item_category (org_id, item_category_name) VALUES (0, 'Utilities');

CREATE TABLE item_units (
	item_unit_id			serial primary key,
	org_id					integer references orgs,
	item_unit_name			varchar(50) not null unique,
	details					text
);
CREATE INDEX item_units_org_id ON item_units (org_id);
INSERT INTO item_units (org_id, item_unit_name) VALUES (0, 'Each');
INSERT INTO item_units (org_id, item_unit_name) VALUES (0, 'Man Hours');
INSERT INTO item_units (org_id, item_unit_name) VALUES (0, '100KG');

CREATE TABLE items (
	item_id					serial primary key,
	org_id					integer references orgs,
	item_category_id		integer references item_category,
	tax_type_id				integer references tax_types,
	item_unit_id			integer references item_units,
	sales_account_id		integer references accounts,
	purchase_account_id		integer references accounts,
	item_name				varchar(120),
	bar_code				varchar(32),
	inventory				boolean default false not null,
	for_sale				boolean default true not null,
	for_purchase			boolean default true not null,
	sales_price				real,
	purchase_price			real,
	reorder_level			integer,
	lead_time				integer,
	is_active				boolean default true not null,
	details					text
);
CREATE INDEX items_org_id ON items (org_id);
CREATE INDEX items_item_category_id ON items (item_category_id);
CREATE INDEX items_tax_type_id ON items (tax_type_id);
CREATE INDEX items_item_unit_id ON items (item_unit_id);
CREATE INDEX items_sales_account_id ON items (sales_account_id);
CREATE INDEX items_purchase_account_id ON items (purchase_account_id);

CREATE TABLE quotations (
	quotation_id 			serial primary key,
	org_id					integer references orgs,
	item_id					integer references items,
	entity_id				integer references entitys,
	active					boolean default false not null,
	amount 					real,
	valid_from				date,
	valid_to				date,
	lead_time				integer,
	details					text
);
CREATE INDEX quotations_org_id ON quotations (org_id);
CREATE INDEX quotations_item_id ON quotations (item_id);
CREATE INDEX quotations_entity_id ON quotations (entity_id);

CREATE TABLE transaction_types (
	transaction_type_id		integer primary key,
	transaction_type_name	varchar(50) not null,
	document_prefix			varchar(16) default 'D' not null,
	document_number			integer default 1 not null,
	for_sales				boolean default true not null,
	for_posting				boolean default true not null
);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (16, 'Requisitions', false, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (14, 'Sales Quotation', true, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (15, 'Purchase Quotation', false, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (1, 'Sales Order', true, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (2, 'Sales Invoice', true, true);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (3, 'Sales Template', true, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (4, 'Purchase Order', false, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (5, 'Purchase Invoice', false, true);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (6, 'Purchase Template', false, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (7, 'Receipts', true, true);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (8, 'Payments', false, true);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (9, 'Credit Note', true, true);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (10, 'Debit Note', false, true);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (11, 'Delivery Note', true, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (12, 'Receipt Note', false, false);
INSERT INTO transaction_types (transaction_type_id, transaction_type_name, for_sales, for_posting) VALUES (17, 'Work Use', true, false);

CREATE TABLE transaction_status (
	transaction_status_id	integer primary key,
	transaction_status_name	varchar(50) not null
);
INSERT INTO transaction_status (transaction_status_id, transaction_status_name) VALUES (1, 'Draft');
INSERT INTO transaction_status (transaction_status_id, transaction_status_name) VALUES (2, 'Completed');
INSERT INTO transaction_status (transaction_status_id, transaction_status_name) VALUES (3, 'Processed');
INSERT INTO transaction_status (transaction_status_id, transaction_status_name) VALUES (4, 'Archive');

CREATE TABLE transactions (
    transaction_id 			serial primary key,
    entity_id 				integer references entitys,
	transaction_type_id		integer references transaction_types,
	bank_account_id			integer references bank_accounts,
	journal_id				integer references journals,
	transaction_status_id	integer references transaction_status default 1,
	currency_id				integer references currency,
	department_id			integer references departments,
	org_id					integer references orgs,
	exchange_rate			real default 1 not null,
	transaction_date		date not null,
	transaction_amount		real default 0 not null,
	document_number			integer default 1 not null,
	payment_number			varchar(50),
	order_number			varchar(50),
	payment_terms			varchar(50),
	job						varchar(240),
	point_of_use			varchar(240),
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
    narrative				varchar(120),
    details					text
);
CREATE INDEX transactions_entity_id ON transactions (entity_id);
CREATE INDEX transactions_transaction_type_id ON transactions (transaction_type_id);
CREATE INDEX transactions_bank_account_id ON transactions (bank_account_id);
CREATE INDEX transactions_journal_id ON transactions (journal_id);
CREATE INDEX transactions_transaction_status_id ON transactions (transaction_status_id);
CREATE INDEX transactions_currency_id ON transactions (currency_id);
CREATE INDEX transactions_department_id ON transactions (department_id);
CREATE INDEX transactions_workflow_table_id ON transactions (workflow_table_id);
CREATE INDEX transactions_org_id ON transactions (org_id);

CREATE TABLE transaction_details (
	transaction_detail_id 	serial primary key,
	transaction_id 			integer references transactions,
	account_id				integer references accounts,
	item_id					integer references items,
	store_id				integer references stores,
	org_id					integer references orgs,
	quantity				integer not null,
    amount 					real default 0 not null,
	tax_amount				real default 0 not null,
	narrative				varchar(240),
	purpose					varchar(320),
	details					text
);
CREATE INDEX transaction_details_transaction_id ON transaction_details (transaction_id);
CREATE INDEX transaction_details_account_id ON transaction_details (account_id);
CREATE INDEX transaction_details_item_id ON transaction_details (item_id);
CREATE INDEX transaction_details_org_id ON transaction_details (org_id);

CREATE TABLE transaction_links (
	transaction_link_id		serial primary key,
	org_id					integer references orgs,
	transaction_id			integer references transactions,
	transaction_to			integer references transactions,
	transaction_detail_id	integer references transaction_details,
	transaction_detail_to	integer references transaction_details,
	amount					real default 0 not null,
	quantity				integer default 0  not null,
	narrative				varchar(240)
);
CREATE INDEX transaction_links_org_id ON transaction_links (org_id);
CREATE INDEX transaction_links_transaction_id ON transaction_links (transaction_id);
CREATE INDEX transaction_links_transaction_to ON transaction_links (transaction_to);
CREATE INDEX transaction_links_transaction_detail_id ON transaction_links (transaction_detail_id);
CREATE INDEX transaction_links_transaction_detail_to ON transaction_links (transaction_detail_to);


CREATE TABLE day_ledgers (
    day_ledger_id 			serial primary key,
    entity_id 				integer references entitys,
	transaction_type_id		integer references transaction_types,
	bank_account_id			integer references bank_accounts,
	journal_id				integer references journals,
	transaction_status_id	integer references transaction_status default 1,
	currency_id				integer references currency,
	department_id			integer references departments,
	item_id					integer references items,
	store_id				integer references stores,
	org_id					integer references orgs,

	exchange_rate			real default 1 not null,
	day_ledger_date			date not null,
	day_ledger_quantity		integer not null,
    day_ledger_amount 		real default 0 not null,
	day_ledger_tax_amount	real default 0 not null,
	
	document_number			integer default 1 not null,
	payment_number			varchar(50),
	order_number			varchar(50),
	payment_terms			varchar(50),
	job						varchar(240),
	
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,
    narrative				varchar(120),
    details					text
);
CREATE INDEX day_ledgers_entity_id ON day_ledgers (entity_id);
CREATE INDEX day_ledgers_transaction_type_id ON day_ledgers (transaction_type_id);
CREATE INDEX day_ledgers_bank_account_id ON day_ledgers (bank_account_id);
CREATE INDEX day_ledgers_journal_id ON day_ledgers (journal_id);
CREATE INDEX day_ledgers_transaction_status_id ON day_ledgers (transaction_status_id);
CREATE INDEX day_ledgers_currency_id ON day_ledgers (currency_id);
CREATE INDEX day_ledgers_department_id ON day_ledgers (department_id);
CREATE INDEX day_ledgers_item_id ON day_ledgers (item_id);
CREATE INDEX day_ledgers_store_id ON day_ledgers (store_id);
CREATE INDEX day_ledgers_workflow_table_id ON day_ledgers (workflow_table_id);
CREATE INDEX day_ledgers_org_id ON day_ledgers (org_id);


CREATE VIEW vw_items AS
	SELECT sales_account.account_id as sales_account_id, sales_account.account_name as sales_account_name, 
		purchase_account.account_id as purchase_account_id, purchase_account.account_name as purchase_account_name, 
		item_category.item_category_id, item_category.item_category_name, item_units.item_unit_id, item_units.item_unit_name, 
		tax_types.tax_type_id, tax_types.tax_type_name,
		tax_types.account_id as tax_account_id, tax_types.tax_rate, tax_types.tax_inclusive,
		items.item_id, items.org_id, items.item_name, items.inventory, items.bar_code,
		items.for_sale, items.for_purchase, items.sales_price, items.purchase_price, items.reorder_level, items.lead_time, 
		items.is_active, items.details
	FROM items INNER JOIN accounts as sales_account ON items.sales_account_id = sales_account.account_id
		INNER JOIN accounts as purchase_account ON items.purchase_account_id = purchase_account.account_id
		INNER JOIN item_category ON items.item_category_id = item_category.item_category_id
		INNER JOIN item_units ON items.item_unit_id = item_units.item_unit_id
		INNER JOIN tax_types ON items.tax_type_id = tax_types.tax_type_id;

CREATE VIEW vw_quotations AS
	SELECT entitys.entity_id, entitys.entity_name, items.item_id, items.item_name, 
		quotations.quotation_id, quotations.org_id, quotations.active, quotations.amount, quotations.valid_from, 
		quotations.valid_to, quotations.lead_time, quotations.details
	FROM quotations	INNER JOIN entitys ON quotations.entity_id = entitys.entity_id
		INNER JOIN items ON quotations.item_id = items.item_id;

