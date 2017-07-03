---Project Database File
CREATE TABLE cylinder_types (
	cylinder_type_id		serial primary key,
	cylinder_type_name		varchar(50),
	weight					real default 12 not null,
	commercial				boolean default false not null,
	details					text
);

CREATE TABLE cylinder_batch (
	cylinder_batch_id		serial primary key,
	cylinder_type_id		integer references cylinder_types,
	entity_id				integer references entitys,
	org_id					integer references orgs,

	quantity				integer,

	approve_status			varchar(16) default 'draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	
	details					text
);

CREATE TABLE cylinders (
	cylinder_id				serial primary key,
	cylinder_batch_id		integer references cylinder_batch,
	org_id					integer references orgs,

	cylinder_number			varchar(32),
	certification_date		date,
	review_date				date,

	checked					boolean default false not null,
	details					text
);

CREATE TABLE check_logs (
	check_log_id			serial primary key,
	org_id					integer references orgs,
	check_log_date			timestamp default current_timestamp not null,
	cylinder_number			varchar(32),
	verified				boolean default false not null
);


CREATE VIEW vw_cylinder_batch AS
	SELECT cylinder_types.cylinder_type_id, cylinder_types.cylinder_type_name, 
		entitys.entity_id, entitys.entity_name, orgs.org_id, orgs.org_name, 
		cylinder_batch.cylinder_batch_id, cylinder_batch.quantity, cylinder_batch.approve_status, 
		cylinder_batch.workflow_table_id, cylinder_batch.application_date, cylinder_batch.action_date, cylinder_batch.details
	FROM cylinder_batch INNER JOIN cylinder_types ON cylinder_batch.cylinder_type_id = cylinder_types.cylinder_type_id
	INNER JOIN entitys ON cylinder_batch.entity_id = entitys.entity_id
	INNER JOIN orgs ON cylinder_batch.org_id = orgs.org_id;

CREATE VIEW vw_cylinders AS
	SELECT vw_cylinder_batch.cylinder_type_id, vw_cylinder_batch.cylinder_type_name, 
		vw_cylinder_batch.entity_id, vw_cylinder_batch.entity_name,  
		vw_cylinder_batch.cylinder_batch_id, vw_cylinder_batch.quantity, vw_cylinder_batch.approve_status, 
		vw_cylinder_batch.workflow_table_id, vw_cylinder_batch.application_date, vw_cylinder_batch.action_date,
		orgs.org_id, orgs.org_name, 

		cylinders.cylinder_id, cylinders.cylinder_number, cylinders.certification_date, cylinders.review_date, cylinders.checked, cylinders.details
	FROM cylinders INNER JOIN vw_cylinder_batch ON cylinders.cylinder_batch_id = vw_cylinder_batch.cylinder_batch_id
	INNER JOIN orgs ON cylinders.org_id = orgs.org_id;


