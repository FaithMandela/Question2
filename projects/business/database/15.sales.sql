
CREATE TABLE leads (
	lead_id					serial primary key,
	industry_id				integer references industry,
	entity_id				integer references entitys,
	sale_person_id			integer references entitys,
	org_id					integer references orgs,

	business_name			varchar(50),
	business_address		varchar(100),
	city					varchar(30),
	state					varchar(50),
	country_id				char(2) references sys_countrys,
	number_of_employees		integer,
	telephone				varchar(50),
	website					varchar(120),
	
	primary_contact			varchar(120),
	job_title				varchar(120),
	primary_email			varchar(120),

	contact_date			date default current_date,
	
	details					text
);
CREATE INDEX leads_industry_id ON leads(industry_id);
CREATE INDEX leads_entity_id ON leads(entity_id);
CREATE INDEX leads_sale_person_id ON leads(sale_person_id);
CREATE INDEX leads_country_id ON leads(country_id);
CREATE INDEX leads_org_id ON leads(org_id);


CREATE TABLE lead_items (
	lead_item				serial primary key,
	entity_id				integer references entitys,
	item_id					integer references items,
	org_id					integer references orgs,
	pitch_date				date,
	units					integer,
	price					real,
	narrative				varchar(320),
	details					text
);
CREATE INDEX lead_items_entity_id ON lead_items (entity_id);
CREATE INDEX lead_items_item_id ON lead_items (item_id);
CREATE INDEX lead_items_org_id ON lead_items (org_id);


