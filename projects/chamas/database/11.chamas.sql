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

CREATE TABLE category (
	category_id				serial primary key,
	org_id					integer references orgs,
	category_name			varchar(50) not null unique,
	details					text
);
CREATE INDEX category_org_id ON category (org_id);

CREATE TABLE items (
	item_id					serial primary key,
	category_id				integer references category,	
	org_id					integer references orgs,
	pc_item_name			varchar(50) not null unique,
	default_price			float not null,
	default_units			integer not null,
	details					text
);
CREATE INDEX items_category_id ON items (category_id);
CREATE INDEX items_org_id ON items (org_id);

CREATE TABLE budget (
	budget_id				serial primary key,
	period_id				integer references periods,
	item_id					integer	references items,
	org_id					integer references orgs,
	budget_units			integer not null,
	budget_price			float not null,
	details					text
);
CREATE INDEX budget_period_id ON budget (period_id);
CREATE INDEX budget_item_id ON budget (item_id);
CREATE INDEX budget_org_id ON budget (org_id);

CREATE TABLE expenditure (
	expenditure_id			serial primary key,
	period_id				integer references periods,
	item_id					integer	references items,
	bank_account_id			integer references bank_accounts,
	org_id					integer references orgs,
	units					integer not null,
	unit_price				float not null,
	receipt_number			varchar(50),
	exp_date				date default current_date not null,
	details					text
);
CREATE INDEX expenditure_period_id ON expenditure (period_id);
CREATE INDEX expenditure_item_id ON expenditure (item_id);
CREATE INDEX expenditure_org_id ON expenditure (org_id);

CREATE TABLE payments (
	payment_id				serial primary key,
	expenditure_id			integer	references expenditure,
	bank_account_id			integer references bank_accounts,
	period_id				integer references periods,
	org_id					integer references orgs,
	payment_amount			float not null,
	receipt_number			varchar(50),
	payment_date			date default current_date not null,
	details					text
);
CREATE INDEX payments_org_id ON payments (org_id);


CREATE VIEW vw_contributions AS  
SELECT contribution_types.contribution_type_id,
 	contribution_types.contribution_type_name,
 	contributions.contribution_id,
 	contributions.entity_id,
 	entitys.entity_name,
 	contributions.bank_account_id,
 	bank_accounts.bank_account_name,
 	bank_accounts.bank_account_number,
 	bank_accounts.bank_branch_id,
 	bank_branch.bank_branch_name,
 	contributions.period_id,
 	periods.fiscal_year_id,
 	periods.opened,
	periods.closed,
 	contributions.org_id,
	contributions.contribution_date,
 	contributions.contribution_amount,
 	contributions.confirmation,
 	contributions.share_value
   FROM contributions
      INNER JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
      INNER JOIN entitys ON contributions.entity_id = entitys.entity_id
      INNER JOIN bank_accounts ON  contributions.bank_account_id = bank_accounts.bank_account_id
      INNER JOIN bank_branch ON bank_accounts.bank_branch_id = bank_branch.bank_branch_id
      INNER JOIN periods ON contributions.period_id = periods.period_id;

CREATE  VIEW vw_expenditure AS
	SELECT expenditure.expenditure_id, 
		expenditure.period_id, 
		expenditure.item_id, 
		expenditure.bank_account_id, 
		expenditure.units, 
		expenditure.unit_price, 
		expenditure.receipt_number, 
		expenditure.exp_date, 
		items.pc_item_name, 
		items.default_units, 
		items.default_price, 
		bank_accounts.bank_account_name
	FROM bank_accounts 
	INNER JOIN expenditure ON bank_accounts.bank_account_id = expenditure.bank_account_id
  	INNER JOIN items ON items.item_id = expenditure.item_id;

CREATE VIEW vw_budgets AS
  SELECT budget.budget_id,
 	budget.item_id,
 	items.pc_item_name,
 	budget.org_id,
 	budget.budget_units,
	(items.default_units * items.default_price) AS default_cost,
	(budget.budget_price * budget.budget_units) AS budget_cost, 
	((items.default_units * items.default_price) - (budget.budget_price * budget.budget_units) ) AS difference,
	budget.period_id,
	vw_periods.period_month,
	vw_periods.period_year
   FROM budget
	INNER JOIN items ON budget.item_id = items.item_id 
  	INNER JOIN vw_periods ON budget.period_id = vw_periods.period_id ;

CREATE VIEW vw_bank_accounts AS
  SELECT bank_accounts.bank_account_id,
 	bank_accounts.bank_account_name,
 	bank_accounts.bank_account_number,
	bank_accounts.bank_branch_id,
 	bank_branch.bank_branch_name,
 	bank_accounts.currency_id,
 	currency.currency_name,
 	bank_accounts.account_id,
 	accounts.account_name,
 	bank_accounts.is_active,
 	bank_accounts.is_default,
 	bank_accounts.org_id,
 	orgs.org_name
  FROM bank_accounts
      INNER JOIN orgs ON bank_accounts.org_id = orgs.org_id
      INNER JOIN accounts ON bank_accounts.account_id = accounts.account_id
      INNER JOIN bank_branch ON bank_accounts.bank_branch_id = bank_branch.bank_branch_id
      INNER JOIN currency ON bank_accounts.currency_id = currency.currency_id ;


CREATE VIEW vw_payments AS  
 SELECT payments.payment_id,
 	payments.expenditure_id,
 	vw_expenditure.pc_item_name,
 	payments.bank_account_id,
 	vw_expenditure.bank_account_name,
 	payments.period_id,
 	vw_expenditure.fiscal_year_id,
 	payments.payment_amount,
 	payments.receipt_number,
 	payments.payment_date,
 	payments.org_id,
 	orgs.org_name
    FROM payments
      INNER JOIN vw_expenditure ON payments.expenditure_id = vw_expenditure.expenditure_id
      INNER JOIN orgs ON  payments.org_id = orgs.org_id ;

CREATE VIEW vw_items AS
   SELECT items.item_id,
 	items.pc_item_name,
	items.category_id,
 	category.category_name,
 	items.default_price,
 	items.default_units,
 	orgs.org_name
      FROM items 
      INNER JOIN category ON items.category_id = category.category_id
      INNER JOIN orgs ON items.org_id = orgs.org_id;
