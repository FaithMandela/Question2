---Project Database File

CREATE TABLE cars (
	car_id					varchar(7) primary key,
	org_id					integer references orgs,
	owner_id				varchar(8),
	owner_name				varchar(64),
	owner_mobile			varchar(16),
	created					timestamp default current_timestamp not null,
	details					text
);
CREATE INDEX cars_org_id ON cars(org_id);

CREATE TABLE mpesa_trxs (
	mpesa_trx_id			serial primary key,
	org_id					integer references orgs,
	mpesa_id				integer,
	mpesa_orig				varchar(50),
	mpesa_dest				varchar(50),
	mpesa_tstamp			timestamp,
	mpesa_text				varchar(320),
	mpesa_code				varchar(50),
	mpesa_acc				varchar(50),
	mpesa_msisdn			varchar(50),
	mpesa_trx_date			date,
	mpesa_trx_time			time,
	mpesa_amt				real,
	mpesa_sender			varchar(50),
	mpesa_pick_time			timestamp default now()
);
CREATE INDEX mpesa_trxs_org_id ON mpesa_trxs (org_id);

CREATE TABLE mpesa_soap (
	mpesa_soap_id			serial primary key,
	org_id					integer references orgs,
	request_id				varchar(32),
	TransID					varchar(32),
	TransAmount				real,
	BillRefNumber			varchar(32),
	TransTime				varchar(32),
	BusinessShortCode		varchar(32),
	TransType				varchar(32),
	FirstName				varchar(32),
	LastName				varchar(32),
	MSISDN					varchar(32),
	OrgAccountBalance		real,
	InvoiceNumber			varchar(32),
	ThirdPartyTransID		varchar(32),
	created					timestamp default current_timestamp not null
);
CREATE INDEX mpesa_soap_org_id ON mpesa_soap (org_id);
