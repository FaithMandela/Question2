CREATE TABLE sys_continents (
	sys_continent_id		char(2) primary key,
	sys_continent_name		varchar(120) unique
);

CREATE TABLE sys_countrys (
	sys_country_id			char(2) primary key,
	sys_continent_id		char(2) references sys_continents,
	sys_country_code		varchar(3),
	sys_country_number		varchar(3),
	sys_phone_code			varchar(3),
	sys_country_name		varchar(120) unique,
	sys_currency_name		varchar(50),
	sys_currency_cents		varchar(50),
	sys_currency_code		varchar(3),
	sys_currency_exchange	real
);
CREATE INDEX sys_countrys_sys_continent_id ON sys_countrys (sys_continent_id);

CREATE TABLE sys_audit_trail (
	sys_audit_trail_id		serial primary key,
	user_id					varchar(50) not null,
	user_ip					varchar(50),
	change_date				timestamp default now() not null,
	table_name				varchar(50) not null,
	record_id				varchar(50) not null,
	change_type				varchar(50) not null,
	narrative				varchar(240)
);

CREATE TABLE sys_audit_details (
	sys_audit_detail_id		serial primary key,
	sys_audit_trail_id		integer references sys_audit_trail,
	new_value				text
);
CREATE INDEX sys_audit_details_sys_audit_trail_id ON sys_audit_details (sys_audit_trail_id);

CREATE TABLE sys_queries (
	sys_query_Name			varchar(50) primary key,
	query_date				timestamp not null default now(),
	query_text				text,
	query_params			text
);

CREATE TABLE sys_errors (
	sys_error_id			serial primary key,
	sys_error				varchar(240) not null,
	error_message			text not null
);

CREATE TABLE sys_news (
	sys_news_id				serial primary key,
	sys_news_group			integer,
	sys_news_title			varchar(240) not null,
	publish					boolean default false not null,
	details					text
);

CREATE TABLE sys_passwords (
	sys_password_id			serial primary key,
	sys_user_name			varchar(240) not null,
	password_sent			boolean not null
);

CREATE TABLE sys_files (
	sys_file_id				serial primary key,
	table_id				integer,
	table_name				varchar(50),
	file_name				varchar(240),
	file_type				varchar(50),
	file_size				integer,
	details					text
);
CREATE INDEX sys_files_table_id ON sys_files (table_id);

CREATE TABLE address_types (
	address_type_id			serial primary key,
	address_type_name		varchar(50)
);
	
CREATE TABLE address (
	address_id				serial primary key,
	address_name			varchar(120),
	address_type_id			integer references address_types,
	sys_country_id			char(2) references sys_countrys,
	table_name				varchar(32),
	table_id				integer,
	post_office_box			varchar(50),
	postal_code				varchar(12),
	premises				varchar(120),
	street					varchar(120),
	town					varchar(50),
	phone_number			varchar(150),
	extension				varchar(15),
	mobile					varchar(150),
	fax						varchar(150),
	email					varchar(120),
	website					varchar(120),
	is_default				boolean,
	first_password			varchar(32),
	details					text
);
CREATE INDEX address_sys_country_id ON address (sys_country_id);
CREATE INDEX address_table_name ON address (table_name);
CREATE INDEX address_table_id ON address (table_id);

CREATE TABLE orgs (
	org_id					serial primary key,
	org_name				varchar(50),
	is_default				boolean not null default true,
	is_active				boolean not null default true,
	logo					varchar(50),
	pin 					varchar(50),
	details					text
);
INSERT INTO orgs (org_id, org_name, logo) 
VALUES (0, 'default', 'logo.png');

CREATE TABLE entity_types (
	entity_type_id			serial primary key,
	entity_type_name		varchar(50) unique,
	entity_role				varchar(240),
	use_key					integer default 0 not null,
	group_email				varchar(120),
	Description				text,
	Details					text
);
INSERT INTO entity_types (entity_type_id, entity_type_name, entity_role) VALUES (0, 'Users', 'user');
INSERT INTO entity_types (entity_type_id, entity_type_name, entity_role) VALUES (1, 'Staff', 'staff');
INSERT INTO entity_types (entity_type_id, entity_type_name, entity_role) VALUES (2, 'Client', 'client');
INSERT INTO entity_types (entity_type_id, entity_type_name, entity_role) VALUES (3, 'Supplier', 'supplier');

CREATE TABLE entitys (
	entity_id				serial primary key,
	org_id					integer not null references orgs,
	entity_type_id			integer not null references entity_types,
	entity_name				varchar(120) not null,
	user_name				varchar(120),
	primary_email			varchar(120),
	super_user				boolean default false not null,
	entity_leader			boolean default false,
	function_role			varchar(240),
	date_enroled			timestamp default now(),
	is_active				boolean default true,
	entity_password			varchar(64) not null default md5('enter'),
	first_password			varchar(64) not null default 'enter',
	new_password			varchar(64),
	is_picked				boolean default false not null,
	details					text,
	UNIQUE(org_id, User_name)
);
CREATE INDEX entitys_org_id ON entitys (org_id);
INSERT INTO entitys (entity_id, org_id, entity_type_id, user_name, entity_name, primary_email, Entity_Leader, Super_User)  
VALUES (0, 0, 0, 'root', 'root', 'root@localhost', true, true);

CREATE TABLE subscription_levels (
	subscription_level_id	serial primary key,
	subscription_level_name	varchar(50),
	details					text
);
INSERT INTO subscription_levels (subscription_level_id, subscription_level_name) VALUES (0, 'Basic');
INSERT INTO subscription_levels (subscription_level_id, subscription_level_name) VALUES (1, 'Manager');
INSERT INTO subscription_levels (subscription_level_id, subscription_level_name) VALUES (2, 'Consumer');

CREATE TABLE entity_subscriptions (
	entity_subscription_id	serial primary key,
	entity_type_id			integer not null references entity_types,
	entity_id				integer not null references entitys,
	subscription_level_id	integer not null references subscription_levels,
	details					text,
	UNIQUE(entity_id, entity_type_id)
);
CREATE INDEX entity_subscriptions_entity_type_id ON entity_subscriptions (entity_type_id);
CREATE INDEX entity_subscriptions_entity_id ON entity_subscriptions (entity_id);
CREATE INDEX entity_subscriptions_subscription_level_id ON entity_subscriptions (subscription_level_id);

INSERT INTO entity_subscriptions (Entity_subscription_id, entity_type_id, entity_id, subscription_level_id)  
VALUES (0, 0, 0, 0);

CREATE TABLE sys_logins (
	sys_login_id			serial primary key,
	entity_id				integer references entitys,
	login_time				timestamp default now(),
	login_ip				varchar(64),
	narrative				varchar(240)
);
CREATE INDEX sys_logins_entity_id ON sys_logins (entity_id);

CREATE TABLE sys_dashboard (
	sys_dashboard_id		serial primary key,
	entity_id				integer references entitys,
	narrative				varchar(240),
	details					text
);
CREATE INDEX sys_dashboard_entity_id ON sys_dashboard (entity_id);

CREATE TABLE sys_emails (
	sys_email_id			serial primary key,
	sys_email_name			varchar(50),
	title					varchar(240) not null,
	details					text
);

CREATE TABLE sys_emailed (
	sys_emailed_id			serial primary key,
	sys_email_id			integer references sys_emails,
	table_id				integer,
	table_name				varchar(50),
	email_type				integer default 1 not null,
	emailed					boolean default false not null,
	narrative				varchar(240)
);
CREATE INDEX sys_emailed_sys_email_id ON sys_emailed (sys_email_id);
CREATE INDEX sys_emailed_table_id ON sys_emailed (table_id);

CREATE TABLE workflows (
	workflow_id				serial primary key,
	source_entity_id		integer not null references entity_types,
	workflow_name			varchar(240) not null,
	table_name				varchar(64),
	table_link_field		varchar(64),
	table_link_id			integer,
	approve_email			text,
	reject_email			text,
	details					text
);
CREATE INDEX workflows_source_entity_id ON workflows (source_entity_id);

CREATE TABLE workflow_phases (
	workflow_phase_id		serial primary key,
	workflow_id				integer not null references workflows,
	approval_entity_id		integer not null references entity_types,
	approval_level			integer default 1 not null,
	return_level			integer default 1 not null,
	escalation_days			integer default 0 not null,
	escalation_hours		integer default 3 not null,
	required_approvals		integer default 1 not null,
	advice					boolean default false not null,
	notice					boolean default false not null,
	phase_narrative			varchar(240),
	advice_email			text,
	notice_email			text,
	details					text
);
CREATE INDEX workflow_phases_workflow_id ON workflow_phases (workflow_id);
CREATE INDEX workflow_phases_approval_entity_id ON workflow_phases (approval_entity_id);

CREATE TABLE checklists (
	checklist_id			serial primary key,
	workflow_phase_id		integer not null references workflow_phases,
	checklist_number		integer,
	manditory				boolean default false not null,
	requirement				text,
	details					text
);
CREATE INDEX checklists_workflow_phase_id ON checklists (workflow_phase_id);

CREATE TABLE approvals (
	approval_id				serial primary key,
	workflow_phase_id		integer not null references workflow_phases,
	org_entity_id			integer not null references entitys,
	app_entity_id			integer references entitys,
	approval_level			integer default 1 not null,
	escalation_days			integer default 0 not null,
	escalation_hours		integer default 3 not null,
	escalation_time			timestamp default now() not null,
	forward_id				integer,
	table_name				varchar(64),
	table_id				integer,
	application_date		timestamp default now() not null,
	completion_date			timestamp,
	action_date				timestamp,
	approve_status			varchar(16) default 'Draft' not null,
	approval_narrative		varchar(240),
	to_be_done				text,
	what_is_done			text,
	review_advice			text,
	details					text
);
CREATE INDEX approvals_workflow_phase_id ON approvals (workflow_phase_id);
CREATE INDEX approvals_org_entity_id ON approvals (org_entity_id);
CREATE INDEX approvals_app_entity_id ON approvals (app_entity_id);
CREATE INDEX approvals_forward_id ON approvals (forward_id);
CREATE INDEX approvals_table_id ON approvals (table_id);
CREATE INDEX approvals_approve_status ON approvals (approve_status);

CREATE TABLE approval_checklists (
	approval_checklist_id	serial primary key,
	approval_id				integer not null references approvals,
	checklist_id			integer not null references checklists,
	requirement				text,
	manditory				boolean default false not null,
	done					boolean default false not null,
	narrative				varchar(320)
);
CREATE INDEX approval_checklists_approval_id ON approval_checklists (approval_id);
CREATE INDEX approval_checklists_checklist_id ON approval_checklists (checklist_id);

CREATE SEQUENCE workflow_table_id_seq;

CREATE SEQUENCE picture_id_seq;

CREATE VIEW vw_sys_emailed AS
	SELECT sys_emails.sys_email_id, sys_emails.sys_email_name, sys_emails.title, sys_emails.details,
		sys_emailed.sys_emailed_id, sys_emailed.table_id, sys_emailed.table_name, sys_emailed.email_type,
		sys_emailed.emailed, sys_emailed.narrative
	FROM sys_emails RIGHT JOIN sys_emailed ON sys_emails.sys_email_id = sys_emailed.sys_email_id;

CREATE VIEW vw_sys_countrys AS
	SELECT sys_continents.sys_continent_id, sys_continents.sys_continent_name,
		sys_countrys.sys_country_id, sys_countrys.sys_country_code, sys_countrys.sys_country_number, 
		sys_countrys.sys_phone_code, sys_countrys.sys_country_name
	FROM sys_continents INNER JOIN sys_countrys ON sys_continents.sys_continent_id = sys_countrys.sys_continent_id;

CREATE VIEW vw_address AS
	SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name, address.address_id, address.address_name, address.table_name,
		address.table_id, address.post_office_box, address.postal_code, address.premises, address.street, address.town, 
		address.phone_number, address.extension, address.mobile, address.fax, address.email, address.is_default, address.website, address.details
	FROM address INNER JOIN sys_countrys ON address.sys_country_id = sys_countrys.sys_country_id;

CREATE VIEW vw_orgs AS
	SELECT orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo, orgs.details,
		vw_address.sys_country_id, vw_address.sys_country_name, vw_address.address_id, vw_address.table_name,
		vw_address.post_office_box, vw_address.postal_code, vw_address.premises, vw_address.street, vw_address.town, 
		vw_address.phone_number, vw_address.extension, vw_address.mobile, vw_address.fax, vw_address.email, vw_address.website
	FROM orgs LEFT JOIN vw_address ON (orgs.org_id = vw_address.table_id)
	WHERE (vw_address.table_name = 'orgs') OR (vw_address.table_name is null);

CREATE VIEW vw_entitys AS
	SELECT orgs.org_id, orgs.org_name, 
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role, entity_types.group_email, entity_types.use_key,
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.Super_User, entitys.Entity_Leader, 
		entitys.Date_Enroled, entitys.Is_Active, entitys.entity_password, entitys.first_password, 
		entitys.primary_email, entitys.function_role, entitys.Details
	FROM entitys INNER JOIN orgs ON entitys.org_id = orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id;

CREATE VIEW vw_entity_address AS
	SELECT orgs.org_id, orgs.org_name, vw_address.address_id, vw_address.address_name,
		vw_address.sys_country_id, vw_address.sys_country_name, vw_address.table_name, vw_address.is_default,
		vw_address.post_office_box, vw_address.postal_code, vw_address.premises, vw_address.street, vw_address.town, 
		vw_address.phone_number, vw_address.extension, vw_address.mobile, vw_address.fax, vw_address.email, vw_address.website,
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role, entity_types.group_email, entity_types.use_key,
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.Super_User, entitys.Entity_Leader, 
		entitys.Date_Enroled, entitys.Is_Active, entitys.entity_password, entitys.first_password, 
		entitys.primary_email, entitys.function_role, entitys.Details
	FROM (entitys LEFT JOIN vw_address ON entitys.entity_id = vw_address.table_id)
		INNER JOIN orgs ON entitys.org_id = orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id 
	WHERE ((vw_address.table_name = 'entitys') OR (vw_address.table_name is null));

CREATE VIEW vw_entity_subscriptions AS
	SELECT entity_types.entity_type_id, entity_types.entity_type_name, entitys.entity_id, entitys.entity_name, 
		subscription_levels.subscription_level_id, subscription_levels.subscription_level_name,
		entity_subscriptions.entity_subscription_id, entity_subscriptions.details
	FROM entity_subscriptions INNER JOIN entity_types ON entity_subscriptions.entity_type_id = entity_types.entity_type_id
		INNER JOIN entitys ON entity_subscriptions.entity_id = entitys.entity_id
		INNER JOIN subscription_levels ON entity_subscriptions.subscription_level_id = subscription_levels.subscription_level_id;

CREATE VIEW vw_workflows AS
	SELECT entity_types.entity_type_id as source_entity_id, entity_types.entity_type_name as source_entity_name, 
		workflows.workflow_id, workflows.workflow_name, workflows.table_name, workflows.table_link_field, 
		workflows.table_link_id, workflows.approve_email, workflows.reject_email, workflows.details
	FROM workflows INNER JOIN entity_types ON workflows.source_entity_id = entity_types.entity_type_id;

CREATE VIEW vw_workflow_phases AS
	SELECT vw_workflows.source_entity_id, vw_workflows.source_entity_name, vw_workflows.workflow_id, 
		vw_workflows.workflow_name, vw_workflows.table_name, vw_workflows.table_link_field, vw_workflows.table_link_id, 
		vw_workflows.approve_email, vw_workflows.reject_email,
		entity_types.entity_type_id as approval_entity_id, entity_types.entity_type_name as approval_entity_name, 
		workflow_phases.workflow_phase_id, workflow_phases.approval_level, 
		workflow_phases.return_level, workflow_phases.escalation_days, workflow_phases.escalation_hours, 
		workflow_phases.notice, workflow_phases.notice_email,
		workflow_phases.advice, workflow_phases.advice_email,
		workflow_phases.required_approvals, workflow_phases.phase_narrative, workflow_phases.details
	FROM (workflow_phases INNER JOIN vw_workflows ON workflow_phases.workflow_id = vw_workflows.workflow_id)
		INNER JOIN entity_types ON workflow_phases.approval_entity_id = entity_types.entity_type_id;

CREATE VIEW vw_workflow_entitys AS
	SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.workflow_name, vw_workflow_phases.table_name,
		vw_workflow_phases.table_link_id, vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name, 
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level, vw_workflow_phases.notice_email,
		vw_workflow_phases.return_level, vw_workflow_phases.escalation_days, vw_workflow_phases.escalation_hours, 
		vw_workflow_phases.required_approvals, vw_workflow_phases.phase_narrative, vw_workflow_phases.notice,
		entity_subscriptions.entity_subscription_id, entity_subscriptions.entity_id, entity_subscriptions.subscription_level_id
	FROM vw_workflow_phases INNER JOIN entity_subscriptions ON vw_workflow_phases.source_entity_id = entity_subscriptions.entity_type_id;

CREATE VIEW vw_approvals AS
	SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.workflow_name, 
		vw_workflow_phases.approve_email, vw_workflow_phases.reject_email,
		vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name,
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level, vw_workflow_phases.phase_narrative,
		vw_workflow_phases.return_level, vw_workflow_phases.required_approvals, 
		vw_workflow_phases.notice, vw_workflow_phases.notice_email,
		vw_workflow_phases.advice, vw_workflow_phases.advice_email,
		approvals.approval_id, approvals.forward_id, approvals.table_name, approvals.table_id,
		approvals.completion_date, approvals.escalation_days, approvals.escalation_hours,
		approvals.escalation_time, approvals.application_date, approvals.approve_status, approvals.action_date,
		approvals.approval_narrative, approvals.to_be_done, approvals.what_is_done, approvals.review_advice, approvals.details,
		oe.entity_id as org_entity_id, oe.entity_name as org_entity_name, oe.user_name as org_user_name, oe.primary_email as org_primary_email,
		ae.entity_id as app_entity_id, ae.entity_name as app_entity_name, ae.user_name as app_user_name, ae.primary_email as app_primary_email
	FROM (vw_workflow_phases INNER JOIN approvals ON vw_workflow_phases.workflow_phase_id = approvals.workflow_phase_id)
		INNER JOIN entitys as oe ON approvals.org_entity_id = oe.entity_id
		LEFT JOIN entitys as ae ON approvals.app_entity_id = ae.entity_id;

CREATE VIEW vw_workflow_approvals AS
	SELECT vw_approvals.workflow_id, vw_approvals.workflow_name, vw_approvals.approve_email, vw_approvals.reject_email,
		vw_approvals.source_entity_id, vw_approvals.source_entity_name, vw_approvals.table_name, vw_approvals.table_id,
		vw_approvals.org_entity_id, vw_approvals.org_entity_name, vw_approvals.org_user_name, 
		vw_approvals.org_primary_email, rt.rejected_count,
		(CASE WHEN rt.rejected_count is null THEN vw_approvals.workflow_name || ' Approved'
			ELSE vw_approvals.workflow_name || ' Rejected' END) as workflow_narrative
	FROM vw_approvals LEFT JOIN 
		(SELECT table_id, count(approval_id) as rejected_count FROM approvals WHERE (approve_status = 'Rejected') AND (approvals.forward_id is null)
		GROUP BY table_id) as rt ON vw_approvals.table_id = rt.table_id
	GROUP BY vw_approvals.workflow_id, vw_approvals.workflow_name, vw_approvals.approve_email, vw_approvals.reject_email,
		vw_approvals.source_entity_id, vw_approvals.source_entity_name, vw_approvals.table_name, vw_approvals.table_id,
		vw_approvals.org_entity_id, vw_approvals.org_entity_name, vw_approvals.org_user_name, 
		vw_approvals.org_primary_email, rt.rejected_count;

CREATE VIEW vw_approvals_entitys AS
	SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.workflow_name, 
		vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name,
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level, vw_workflow_phases.notice_email,
		vw_workflow_phases.return_level, vw_workflow_phases.required_approvals,
		vw_workflow_phases.notice, vw_workflow_phases.phase_narrative,
		approvals.approval_id, approvals.forward_id, approvals.table_name, approvals.table_id,
		approvals.completion_date, approvals.escalation_days, approvals.escalation_hours,
		approvals.escalation_time, approvals.application_date, approvals.approve_status, approvals.action_date,
		approvals.approval_narrative, approvals.to_be_done, approvals.what_is_done, approvals.review_advice, approvals.details,
		oe.entity_id as org_entity_id, oe.entity_name as org_entity_name, oe.user_name as org_user_name, oe.primary_email as org_primary_email,
		entity_subscriptions.entity_subscription_id, entity_subscriptions.subscription_level_id,
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.primary_email
	FROM ((vw_workflow_phases INNER JOIN approvals ON vw_workflow_phases.workflow_phase_id = approvals.workflow_phase_id)
		INNER JOIN entitys as oe  ON approvals.org_entity_id = oe.entity_id)
		INNER JOIN entity_subscriptions ON vw_workflow_phases.approval_entity_id = entity_subscriptions.entity_type_id
		INNER JOIN entitys ON entity_subscriptions.entity_id = entitys.entity_id
	WHERE (approvals.forward_id is null);

CREATE VIEW tomcat_users AS 
	SELECT entitys.user_name, entitys.Entity_password, entity_types.entity_role
	FROM (Entity_subscriptions 
		INNER JOIN entitys ON Entity_subscriptions.entity_id = entitys.entity_id)
		INNER JOIN entity_types ON Entity_subscriptions.entity_type_id = entity_types.entity_type_id
	WHERE entitys.Is_Active = true;

CREATE OR REPLACE FUNCTION first_password() RETURNS varchar(12) AS $$
DECLARE
	rnd integer;
	passchange varchar(12);
BEGIN
	passchange := trunc(random()*1000);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);
	passchange := passchange || trunc(random()*1000);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);

	return passchange;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION change_password(varchar(12), varchar(32), varchar(32)) RETURNS varchar(120) AS $$
DECLARE
	old_password 	varchar(64);
	passchange 		varchar(120);
	entityID		integer;
BEGIN
	passchange := 'Password Error';
	entityID := CAST($1 AS INT);
	SELECT Entity_password INTO old_password
	FROM entitys WHERE (entity_id = entityID);

	IF ($2 = '0') THEN
		passchange := first_password();
		UPDATE entitys SET first_password = passchange, Entity_password = md5(passchange) WHERE (entity_id = entityID);
		passchange := 'Password Changed';
	ELSIF (old_password = md5($2)) THEN
		UPDATE entitys SET Entity_password = md5($3) WHERE (entity_id = entityID);
		passchange := 'Password Changed';
	ELSE
		passchange := 'Password Changing Error Ensure you have correct details';
	END IF;

	return passchange;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_password() RETURNS trigger AS $$
BEGIN
	IF(NEW.first_password is null) AND (TG_OP = 'INSERT') THEN
		NEW.first_password := first_password();
	END IF;
	IF(TG_OP = 'INSERT') THEN
		IF (NEW.Entity_password is null) THEN
			NEW.Entity_password := md5(NEW.first_password);
		END IF;
	ELSIF(OLD.first_password <> NEW.first_password) THEN
		NEW.Entity_password := md5(NEW.first_password);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_password BEFORE INSERT OR UPDATE ON entitys
    FOR EACH ROW EXECUTE PROCEDURE ins_password();

CREATE OR REPLACE FUNCTION ins_entitys() RETURNS trigger AS $$
BEGIN	
	IF(NEW.entity_type_id is not null) THEN
		INSERT INTO Entity_subscriptions (entity_type_id, entity_id, subscription_level_id)
		VALUES (NEW.entity_type_id, NEW.entity_id, 0);
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_entitys AFTER INSERT ON entitys
    FOR EACH ROW EXECUTE PROCEDURE ins_entitys();

CREATE FUNCTION Emailed(integer, varchar(64)) RETURNS void AS $$
    UPDATE sys_emailed SET emailed = true WHERE (sys_emailed_id = CAST($2 as int));
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION ins_approvals() RETURNS trigger AS $$
DECLARE
	reca	RECORD;
BEGIN

	IF (NEW.forward_id is not null) THEN
		SELECT workflow_phase_id, org_entity_id, app_entity_id, approval_level, table_name, table_id INTO reca
		FROM approvals 
		WHERE (approval_id = NEW.forward_id);

		NEW.workflow_phase_id := reca.workflow_phase_id;
		NEW.approval_level := reca.approval_level;
		NEW.table_name := reca.table_name;
		NEW.table_id := reca.table_id;
		NEW.approve_status := 'Completed';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_approvals BEFORE INSERT ON approvals
    FOR EACH ROW EXECUTE PROCEDURE ins_approvals();

CREATE OR REPLACE FUNCTION upd_approvals() RETURNS trigger AS $$
DECLARE
	reca	RECORD;
	wfid	integer;
	vnotice	boolean;
	vadvice	boolean;
BEGIN

	SELECT notice, advice INTO vnotice, vadvice
	FROM workflow_phases
	WHERE (workflow_phase_id = NEW.workflow_phase_id);

	IF (NEW.approve_status = 'Completed') THEN
		INSERT INTO sys_emailed (table_id, table_name, email_type)
		VALUES (NEW.approval_id, TG_TABLE_NAME, 1);
	END IF;
	IF (NEW.approve_status = 'Approved') AND (vadvice = true) AND (NEW.forward_id is null) THEN
		INSERT INTO sys_emailed (table_id, table_name, email_type)
		VALUES (NEW.approval_id, TG_TABLE_NAME, 1);
	END IF;
	IF (NEW.approve_status = 'Approved') AND (vnotice = true) AND (NEW.forward_id is null) THEN
		INSERT INTO sys_emailed (table_id, table_name, email_type)
		VALUES (NEW.approval_id, TG_TABLE_NAME, 2);
	END IF;

	IF(TG_OP = 'INSERT') AND (NEW.forward_id is null) THEN
		INSERT INTO approval_checklists (approval_id, checklist_id, requirement, manditory)
		SELECT NEW.approval_id, checklist_id, requirement, manditory
		FROM checklists 
		WHERE (workflow_phase_id = NEW.workflow_phase_id)
		ORDER BY checklist_number;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_approvals AFTER INSERT OR UPDATE ON approvals
    FOR EACH ROW EXECUTE PROCEDURE upd_approvals();

CREATE OR REPLACE FUNCTION upd_action() RETURNS trigger AS $$
DECLARE
	wfid	INTEGER;
	reca	RECORD;
	tbid	INTEGER;
	iswf	BOOLEAN;
BEGIN

	IF(NEW.approve_status = 'Completed')THEN
		wfid := nextval('workflow_table_id_seq');
		NEW.workflow_table_id := wfid;

		FOR reca IN SELECT workflows.workflow_id, workflows.table_name, workflows.table_link_field, workflows.table_link_id
		FROM workflows INNER JOIN entity_subscriptions ON workflows.source_entity_id = entity_subscriptions.entity_type_id
		WHERE (workflows.table_name = TG_TABLE_NAME) AND (entity_subscriptions.entity_id= NEW.entity_id) LOOP
			iswf := false;
			IF(reca.table_link_field is null)THEN
				iswf := true;
			ELSE
				IF(TG_TABLE_NAME = 'entry_forms')THEN
					tbid := NEW.form_id;
				END IF;
				IF(tbid = reca.table_link_id)THEN
					iswf := true;
				END IF;
			END IF;

			IF(iswf = true)THEN
				INSERT INTO approvals (workflow_phase_id, table_name, table_id, org_entity_id, escalation_days, escalation_hours, approval_level, approval_narrative, to_be_done)
				SELECT workflow_phase_id, TG_TABLE_NAME, wfid, NEW.entity_id, escalation_days, escalation_hours, approval_level, phase_narrative, 'Approve - ' || phase_narrative
				FROM vw_workflow_entitys
				WHERE (table_name = TG_TABLE_NAME) AND (entity_id = NEW.entity_id) AND (workflow_id = reca.workflow_id)
				ORDER BY approval_level, workflow_phase_id;

				UPDATE approvals SET approve_status = 'Completed' 
				WHERE (table_id = wfid) AND (approval_level = 1);
			END IF;
		END LOOP;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upd_approvals(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	app_id		Integer;
	reca 		RECORD;
	recb		RECORD;
	recc		RECORD;
	min_level	Integer;
	mysql		varchar(240);
	msg 		varchar(120);
BEGIN
	app_id := CAST($1 as int);
	SELECT approvals.approval_id, approvals.table_name, approvals.table_id, approvals.review_advice,
		workflow_phases.workflow_phase_id, workflow_phases.workflow_id, workflow_phases.return_level INTO reca
	FROM approvals INNER JOIN workflow_phases ON approvals.workflow_phase_id = workflow_phases.workflow_phase_id
	WHERE (approvals.approval_id = app_id);

	SELECT count(approval_checklist_id) as cl_count INTO recc
	FROM approval_checklists
	WHERE (approval_id = app_id) AND (manditory = true) AND (done = false);

	IF ($3 = '1') THEN
		UPDATE approvals SET approve_status = 'Completed', completion_date = now()
		WHERE approval_id = app_id;
		msg := 'Completed';
	ELSIF ($3 = '2') AND (recc.cl_count <> 0) THEN
		msg := 'There are manditory checklist that must be checked first.';
	ELSIF ($3 = '2') AND (recc.cl_count = 0) THEN
		UPDATE approvals SET approve_status = 'Approved', action_date = now(), app_entity_id = CAST($2 as int)
		WHERE approval_id = app_id;

		SELECT min(approval_level) INTO min_level
		FROM approvals
		WHERE (table_id = reca.table_id) AND (approve_status = 'Draft');
		
		IF(min_level is null)THEN
			mysql := 'UPDATE ' || reca.table_name || ' SET approve_status = ' || quote_literal('Approved') 
			|| ', action_date = now()'
			|| ' WHERE workflow_table_id = ' || reca.table_id;
			EXECUTE mysql;

			INSERT INTO sys_emailed (table_id, table_name, email_type)
			VALUES (reca.table_id, 'vw_workflow_approvals', 1);
		ELSE
			FOR recb IN SELECT workflow_phase_id, advice
			FROM workflow_phases
			WHERE (workflow_id = reca.workflow_id) AND (approval_level = min_level) LOOP
				IF (recb.advice = true) THEN
					UPDATE approvals SET approve_status = 'Approved', action_date = now(), completion_date = now()
					WHERE (workflow_phase_id = recb.workflow_phase_id) AND (table_id = reca.table_id);
				ELSE
					UPDATE approvals SET approve_status = 'Completed', completion_date = now()
					WHERE (workflow_phase_id = recb.workflow_phase_id) AND (table_id = reca.table_id);
				END IF;
			END LOOP;
		END IF;
		msg := 'Approved';
	ELSIF ($3 = '3') THEN
		UPDATE approvals SET approve_status = 'Rejected',  action_date = now(), app_entity_id = CAST($2 as int)
		WHERE approval_id = app_id;

		mysql := 'UPDATE ' || reca.table_name || ' SET approve_status = ' || quote_literal('Rejected') 
		|| ', action_date = now()'
		|| ' WHERE workflow_table_id = ' || reca.table_id;
		EXECUTE mysql;

		INSERT INTO sys_emailed (table_id, table_name, email_type)
		VALUES (reca.table_id, 'vw_workflow_approvals', 2);
		msg := 'Rejected';
	ELSIF ($3 = '4') AND (reca.return_level = 0) THEN
		INSERT INTO approvals (forward_id, workflow_phase_id, table_name, table_id, org_entity_id, app_entity_id, escalation_days, escalation_hours, approval_level, approval_narrative, to_be_done, approve_status)
		SELECT approval_id, workflow_phase_id, table_name, table_id, CAST($2 as int), org_entity_id, escalation_days, escalation_hours, 0, approval_narrative, reca.review_advice, 'Completed'
		FROM vw_approvals
		WHERE (approval_id = reca.approval_id);
		msg := 'Forwarded for review';
	ELSIF ($3 = '4') AND (reca.return_level <> 0) THEN
		INSERT INTO approvals (workflow_phase_id, table_name, table_id, org_entity_id, escalation_days, escalation_hours, approval_level, approval_narrative, to_be_done, approve_status)
		SELECT workflow_phase_id, reca.table_name, reca.table_id, CAST($2 as int), escalation_days, escalation_hours, approval_level, phase_narrative, reca.review_advice, 'Completed'
		FROM vw_workflow_entitys
		WHERE (workflow_id = reca.workflow_id) AND (approval_level = reca.return_level)
		ORDER BY workflow_phase_id;
		msg := 'Forwarded to owner for review';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upd_checklist(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	cl_id		Integer;
	reca 		RECORD;
	recc 		RECORD;
	msg 		varchar(120);
BEGIN
	cl_id := CAST($1 as int);
	
	SELECT approval_checklist_id, approval_id, checklist_id, requirement, manditory, done INTO reca
	FROM approval_checklists
	WHERE (approval_checklist_id = cl_id);

	IF ($3 = '1') THEN
		UPDATE approval_checklists SET done = true WHERE (approval_checklist_id = cl_id);

		SELECT count(approval_checklist_id) as cl_count INTO recc
		FROM approval_checklists
		WHERE (approval_id = reca.approval_id) AND (manditory = true) AND (done = false);
		msg := 'Checklist done.';

		IF(recc.cl_count = 0) THEN
			msg := upd_approvals(CAST(reca.approval_id as varchar(12)), $2, '2');
		END IF;
	ELSIF ($3 = '2') THEN
		UPDATE approval_checklists SET done = false WHERE (approval_checklist_id = cl_id);
		msg := 'Checklist not done.';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_phase_status(boolean, boolean) RETURNS varchar(16) AS $$
DECLARE
	ps		varchar(16);
BEGIN
	ps := 'Draft';
	IF ($1 = true) THEN
		ps := 'Approved';
	END IF;
	IF ($2 = true) THEN
		ps := 'Rejected';
	END IF;

	RETURN ps;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_phase_email(integer) RETURNS varchar(320) AS $$
DECLARE
    myrec	RECORD;
	myemail	varchar(320);
BEGIN
	myemail := null;
	FOR myrec IN SELECT entitys.primary_email
		FROM entitys INNER JOIN entity_subscriptions ON entitys.entity_id = entity_subscriptions.entity_id
		WHERE (entity_subscriptions.entity_type_id = $1) LOOP

		IF (myemail is null) THEN
			IF (myrec.primary_email is not null) THEN
				myemail := myrec.primary_email;
			END IF;
		ELSE
			IF (myrec.primary_email is not null) THEN
				myemail := myemail || ', ' || myrec.primary_email;
			END IF;
		END IF;

	END LOOP;

	RETURN myemail;
END;
$$ LANGUAGE plpgsql;

