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

	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	application_date		timestamp default now(),
	action_date				timestamp,
	
	details					text
);

CREATE TABLE cylinders (
	cylinder_id				serial primary key,
	cylinder_batch_id		integer references cylinder_batch,
	org_id					integer references orgs,

	cylinder_number			ineteger,
	cylinder_code			varchar(32),
	certification_date		timestamp default current_timestamp not null,
	review_date				date,

	checked					boolean default false not null,
	details					text
);

CREATE TABLE check_logs (
	check_log_id			serial primary key,
	org_id					integer references orgs,
	check_log_date			timestamp default current_timestamp not null,
	cylinder_code			varchar(32),
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

		cylinders.cylinder_id, cylinders.cylinder_number, cylinders.cylinder_code,
		cylinders.certification_date, cylinders.review_date, cylinders.checked, cylinders.details
	FROM cylinders INNER JOIN vw_cylinder_batch ON cylinders.cylinder_batch_id = vw_cylinder_batch.cylinder_batch_id
	INNER JOIN orgs ON cylinders.org_id = orgs.org_id;

CREATE OR REPLACE FUNCTION apply_approval(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg							varchar(120);
BEGIN

	IF($3 = '1')THEN
		UPDATE cylinder_batch SET approve_status = 'Completed' 
		WHERE (cylinder_batch_id = $1::integer) AND (approve_status = 'Draft');

		msg := 'Applied for batch approval';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upd_cylinder_batch() RETURNS trigger AS $$
BEGIN

	IF(OLD.approve_status = 'Completed') AND (NEW.approve_status = 'Approved')THEN
		INSERT INTO cylinders (cylinder_batch_id, org_id, cylinder_number)
		SELECT NEW.cylinder_batch_id, NEW.org_id, ab
		FROM generate_series(2, 4) ab;
	END IF;

	RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_cylinder_batch AFTER UPDATE ON cylinder_batch
    FOR EACH ROW EXECUTE PROCEDURE upd_cylinder_batch();
    
    