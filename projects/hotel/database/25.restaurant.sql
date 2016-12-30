

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

CREATE TABLE item_ratio (
	item_ratio_id			serial primary key,
	menu_id					integer references menu,
	item_id					integer references items,
	org_id					integer references orgs,
	ratio					real,
	estimate_cost			real,
	details					text
);
CREATE INDEX item_ratio_menu_id ON item_ratio (menu_id);
CREATE INDEX item_ratio_item_id ON item_ratio (item_id);
CREATE INDEX item_ratio_org_id ON item_ratio (org_id);

CREATE TABLE korders (
	korder_id				serial primary key,
	entity_id				integer references entitys,
	stay_id					integer references stay,
	org_id					integer references orgs,
	order_date				timestamp not null default current_timestamp,
	table_number			varchar(25),
	approved				boolean not null default false,
	closed					boolean not null default false,
	details					text
);

CREATE TABLE korder_details (
	korder_detail_id		serial primary key,
	korder_id				integer references korders,
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


CREATE OR REPLACE FUNCTION ins_korder_details() RETURNS TRIGGER AS $$
DECLARE
	myrec RECORD;
BEGIN
	SELECT INTO myrec menuprice, menucost, 	tax1, tax2, tax3
	FROM menu WHERE menuid = NEW.menuid;

	NEW.itemprice = myrec.menuprice;
	NEW.itemcost = myrec.menucost;
	NEW.tax1 = myrec.tax1;
	NEW.tax2 = myrec.tax2;
	NEW.tax3 = myrec.tax3;
	NEW.exchangerate = getcurrencyrate(NEW.currencyid);

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_korder_details BEFORE INSERT ON korder_details
    FOR EACH ROW EXECUTE PROCEDURE ins_korder_details();