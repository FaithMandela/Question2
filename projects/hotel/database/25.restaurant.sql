---- Restaurant tables

CREATE TABLE menu_category (
	menu_category_id		serial primary key,
	org_id					integer references orgs,
	menu_category_name		varchar(50),
	details					text  
);
CREATE INDEX menu_category_org_id ON menu_category (org_id);

CREATE TABLE menu (
	menu_id					serial primary key,
	menu_category_id		integer references menu_category,
	currency_id				integer references currency,
	org_id					integer references orgs,
	menu_name				varchar(120) not null unique,
	menu_price				real not null,		
	menu_cost				real not null,
	tax1					real not null default 16,
	tax2					real not null default 2,
	tax3					real not null default 0,	
	exchange_rate			real default 1 not null,
	details					text
);
CREATE INDEX menu_menu_category_id ON menu (menu_category_id);
CREATE INDEX menu_currency_id ON menu (currency_id);
CREATE INDEX menu_org_id ON menu (org_id);

CREATE TABLE menu_ratio (
	menu_ratio_id			serial primary key,
	menu_id					integer references menu,
	item_id					integer references items,
	org_id					integer references orgs,
	ratio					real,
	estimate_cost			real,
	details					text
);
CREATE INDEX menu_ratio_menu_id ON menu_ratio (menu_id);
CREATE INDEX menu_ratio_item_id ON menu_ratio (item_id);
CREATE INDEX menu_ratio_org_id ON menu_ratio (org_id);

CREATE TABLE menu_orders (
	menu_order_id			serial primary key,
	entity_id				integer references entitys,
	resident_id				integer references residents,
	org_id					integer references orgs,
	order_date				timestamp not null default current_timestamp,
	table_number			varchar(25),
	approved				boolean not null default false,
	closed					boolean not null default false,
	details					text
);
CREATE INDEX menu_orders_entity_id ON menu_orders (entity_id);
CREATE INDEX menu_orders_resident_id ON menu_orders (resident_id);
CREATE INDEX menu_orders_org_id ON menu_orders (org_id);

CREATE TABLE menu_kitchen (
	menu_kitchen_id			serial primary key,
	menu_order_id			integer references menu_orders,
	menu_id					integer references menu,
	currency_id				integer references currency,
	org_id					integer references orgs,
	quantity				integer not null default 1,
	item_price				real not null,
	item_cost				real not null,
	tax1					real not null,
	tax2					real not null,
	tax3					real not null,	
	exchange_rate			real default 1 not null,
	approved				boolean not null default false,
	closed					boolean not null default false,
	details					text
);
CREATE INDEX menu_kitchen_menu_order_id ON menu_kitchen (menu_order_id);
CREATE INDEX menu_kitchen_menu_id ON menu_kitchen (menu_id);
CREATE INDEX menu_kitchen_currency_id ON menu_kitchen (currency_id);
CREATE INDEX menu_kitchen_org_id ON menu_kitchen (org_id);

CREATE VIEW vw_menu AS
	SELECT menu_category.menu_category_id, menu_category.menu_category_name, 
		currency.currency_id, currency.currency_name,
		menu.org_id, menu.menu_id, menu.menu_name, menu.menu_price, menu.menu_cost, 
		menu.tax1, menu.tax2, menu.tax3, menu.exchange_rate, menu.details
	FROM menu INNER JOIN menu_category ON menu.menu_category_id = menu_category.menu_category_id
		INNER JOIN currency ON menu.currency_id = currency.currency_id;
	
	
CREATE OR REPLACE FUNCTION ins_menu_kitchen() RETURNS TRIGGER AS $$
DECLARE
	myrec RECORD;
BEGIN
	SELECT menu_price, menu_cost, tax1, tax2, tax3 INTO myrec
	FROM menu WHERE menuid = NEW.menu_id;

	NEW.item_price = myrec.menu_price;
	NEW.item_cost = myrec.menu_cost;
	NEW.tax1 = myrec.tax1;
	NEW.tax2 = myrec.tax2;
	NEW.tax3 = myrec.tax3;
	NEW.exchange_rate = get_currency_rate(NEW.org_id, NEW.currencyid);

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_menu_kitchen BEFORE INSERT ON menu_kitchen
    FOR EACH ROW EXECUTE PROCEDURE ins_menu_kitchen();