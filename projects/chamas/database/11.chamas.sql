---Project Database File
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

CREATE TABLE contribution_types (
	contribution_type_id	serial primary key,
	org_id					integer references orgs,
	contribution_type_name	varchar(240),
	merry_go_round			boolean,
	details					text
);
CREATE INDEX contribution_types_org_id ON contribution_types (org_id);

CREATE TABLE contributions (
	contribution_id			serial primary key,
	contribution_type_id	integer references contribution_types,
	entity_id				integer references entitys,
	bank_account_id			integer references bank_accounts,
	period_id				integer references periods,
	org_id					integer references orgs,
	contribution_date		date not null,
	contribution_amount		real not null,
	banking_details			varchar(240),
	confirmation			boolean default false not null,
	member_payment			boolean default false not null,
	share_value				real not null,
	details					text
);



