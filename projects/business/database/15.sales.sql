
CREATE TABLE leads (
	lead_id					serial primary key,
	industry_id				integer references industry,
	entity_id				integer references entitys,
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
	primary_email			varchar(120) not null,
	prospect_level			integer default 1 not null,

	contact_date			date default current_date,
	
	details					text
);
CREATE INDEX leads_industry_id ON leads(industry_id);
CREATE INDEX leads_entity_id ON leads(entity_id);
CREATE INDEX leads_country_id ON leads(country_id);
CREATE INDEX leads_org_id ON leads(org_id);


CREATE TABLE lead_items (
	lead_item				serial primary key,
	lead_id					integer references leads,
	entity_id				integer references entitys,
	item_id					integer references items,
	org_id					integer references orgs,
	pitch_date				date  not null,
	units					integer not null,
	price					real not null,
	lead_level				integer default 1 not null,
	narrative				varchar(320),
	details					text
);
CREATE INDEX lead_items_lead_id ON lead_items (lead_id);
CREATE INDEX lead_items_entity_id ON lead_items (entity_id);
CREATE INDEX lead_items_item_id ON lead_items (item_id);
CREATE INDEX lead_items_org_id ON lead_items (org_id);


CREATE VIEW vw_leads AS
	SELECT entitys.entity_id, entitys.entity_name, industry.industry_id, industry.industry_name, 
		sys_countrys.sys_country_id, sys_countrys.sys_country_name, 
		leads.org_id, leads.lead_id, leads.business_name, leads.business_address, 
		leads.city, leads.state, leads.country_id, leads.number_of_employees, leads.telephone, leads.website, 
		leads.primary_contact, leads.job_title, leads.primary_email, leads.prospect_level, leads.contact_date, leads.details
	FROM leads INNER JOIN entitys ON leads.entity_id = entitys.entity_id
		INNER JOIN industry ON leads.industry_id = industry.industry_id
		INNER JOIN sys_countrys ON leads.country_id = sys_countrys.sys_country_id;

CREATE VIEW vw_lead_items AS
	SELECT entitys.entity_id, entitys.entity_name, items.item_id, items.item_name,
		vw_leads.industry_id, vw_leads.industry_name, vw_leads.sys_country_id, vw_leads.sys_country_name, 
		vw_leads.lead_id, vw_leads.business_name, vw_leads.business_address, 
		vw_leads.city, vw_leads.state, vw_leads.country_id, vw_leads.number_of_employees, vw_leads.telephone, vw_leads.website, 
		vw_leads.primary_contact, vw_leads.job_title, vw_leads.primary_email, vw_leads.prospect_level, vw_leads.contact_date,

		lead_items.org_id, lead_items.lead_item, lead_items.pitch_date, lead_items.units, lead_items.price, lead_items.lead_level, 
		lead_items.narrative, lead_items.details
	FROM lead_items INNER JOIN vw_leads ON lead_items.lead_id = vw_leads.lead_id
		INNER JOIN entitys ON lead_items.entity_id = entitys.entity_id
		INNER JOIN items ON lead_items.item_id = items.item_id;


