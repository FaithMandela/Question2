
CREATE TABLE leads (
	lead_id					serial primary key,
	industry_id				integer references industry,
	entity_id				integer references entitys,
	org_id					integer references orgs,

	business_id				integer,
	business_name			varchar(50) not null unique,
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
	prospect_level			integer default 1 not null,

	contact_date			date default current_date not null,
	
	details					text
);
CREATE INDEX leads_industry_id ON leads(industry_id);
CREATE INDEX leads_entity_id ON leads(entity_id);
CREATE INDEX leads_country_id ON leads(country_id);
CREATE INDEX leads_org_id ON leads(org_id);


CREATE TABLE lead_items (
	lead_item_id			serial primary key,
	lead_id					integer references leads,
	entity_id				integer references entitys,
	item_id					integer references items,
	org_id					integer references orgs,
	pitch_date				date default current_date not null,
	units					integer default 1 not null,
	price					real default 0 not null,
	lead_level				integer default 1 not null,
	narrative				varchar(320),
	details					text
);
CREATE INDEX lead_items_lead_id ON lead_items (lead_id);
CREATE INDEX lead_items_entity_id ON lead_items (entity_id);
CREATE INDEX lead_items_item_id ON lead_items (item_id);
CREATE INDEX lead_items_org_id ON lead_items (org_id);

CREATE TABLE follow_up (
	follow_up_id			serial primary key,
	lead_item_id			integer references lead_items,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	create_time				timestamp default current_timestamp not null,
	follow_date				date default current_date not null,
	follow_time				time default current_time not null,
	done					boolean default false not null,
	narrative				varchar(240),
	details					text
);
CREATE INDEX follow_up_lead_item_id ON follow_up (lead_item_id);
CREATE INDEX follow_up_entity_id ON follow_up (entity_id);
CREATE INDEX follow_up_org_id ON follow_up (org_id);

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

		lead_items.org_id, lead_items.lead_item_id, lead_items.pitch_date, lead_items.units, lead_items.price, lead_items.lead_level, 
		lead_items.narrative, lead_items.details,
		(lead_items.units * lead_items.price) as lead_value
	FROM lead_items INNER JOIN vw_leads ON lead_items.lead_id = vw_leads.lead_id
		INNER JOIN entitys ON lead_items.entity_id = entitys.entity_id
		INNER JOIN items ON lead_items.item_id = items.item_id;

CREATE VIEW vw_follow_up AS
	SELECT vw_lead_items.item_id, vw_lead_items.item_name, vw_lead_items.industry_id, vw_lead_items.industry_name, 
		vw_lead_items.sys_country_id, vw_lead_items.sys_country_name, 
		vw_lead_items.lead_id, vw_lead_items.business_name, vw_lead_items.business_address, 
		vw_lead_items.city, vw_lead_items.state, vw_lead_items.country_id, vw_lead_items.number_of_employees, 
		vw_lead_items.telephone, vw_lead_items.website, 
		vw_lead_items.primary_contact, vw_lead_items.job_title, vw_lead_items.primary_email, 
		vw_lead_items.prospect_level, vw_lead_items.contact_date,

		vw_lead_items.lead_item_id, vw_lead_items.pitch_date, vw_lead_items.units, vw_lead_items.price, 
		vw_lead_items.lead_value, vw_lead_items.lead_level, 

		entitys.entity_id, entitys.entity_name, 
		follow_up.org_id, follow_up.follow_up_id, follow_up.create_time, follow_up.follow_date, 
		follow_up.follow_time, follow_up.done, follow_up.narrative, follow_up.details
		
	FROM follow_up INNER JOIN vw_lead_items ON follow_up.lead_item_id = vw_lead_items.lead_item_id
		INNER JOIN entitys ON follow_up.entity_id = entitys.entity_id;
	
	
CREATE OR REPLACE FUNCTION add_client(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec					RECORD;
	v_entity_id			integer;
	msg 				varchar(120);
BEGIN

	msg := null;

	SELECT org_id, business_id, business_name, business_address, city,
		state, country_id, number_of_employees, telephone, website,
		primary_contact, job_title, primary_email
	INTO rec
	FROM leads WHERE lead_id = $1::integer;
	
	SELECT entity_id INTO v_entity_id
	FROM entitys WHERE user_name = lower(trim(NEW.primary_email));

	IF($3 = '1')THEN
		IF(rec.business_id is not null)THEN
			msg := 'The business is already added.';
		ELSIF(rec.primary_email is null)THEN
			RAISE EXCEPTION 'You must enter an email address';
		ELSIF(v_entity_id is null)THEN
			RAISE EXCEPTION 'You must have a unique email address';
		ELSE
			v_entity_id := nextval('entitys_entity_id_seq');
			INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, user_name, primary_email,  function_role, use_function)
			VALUES (v_entity_id, 0, 5, rec.primary_contact, lower(trim(rec.primary_email)), lower(trim(rec.primary_email)), 'client', 2);
			
			INSERT INTO address (address_name, sys_country_id, table_name, table_id, premises, town, phone_number, website, is_default) 
			VALUES (rec.business_name, rec.country_id, 'entitys', rec.org_id, rec.business_address, rec.city, rec.telephone, rec.website, true);
			
			msg := 'You have added the client';
		END IF;
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

