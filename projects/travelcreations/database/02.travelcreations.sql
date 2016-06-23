---Project Database File
ALTER TABLE entitys ADD client_code varchar(20);
ALTER TABLE entitys ADD client_dob date;
ALTER TABLE orders ADD client_code varchar(20);

ALTER TABLE loyalty_points ADD COLUMN sector_1 character varying(10);
ALTER TABLE loyalty_points ADD COLUMN sector_2 character varying(10);
ALTER TABLE loyalty_points ADD COLUMN sector_3 character varying(10);
ALTER TABLE loyalty_points ADD COLUMN sector_4 character varying(10);
ALTER TABLE loyalty_points ADD COLUMN sector_5 character varying(10);
ALTER TABLE loyalty_points ADD COLUMN ticket_number character varying(30);
ALTER TABLE loyalty_points ADD COLUMN local_inter character varying(2);
ALTER TABLE loyalty_points ADD COLUMN client_code character varying(50);
ALTER TABLE loyalty_points ADD COLUMN loyalty_curr character varying(10);

CREATE TABLE clients (
	client_id			    serial primary key,
	org_id 					integer references orgs,
	client_email			varchar(50) not null,
	user_name  				varchar(120) not null,
	phone_no    			character varying(50),
	client_code			    varchar(50),
	client_name 			varchar(50),
	client_dob			    date not null,
	ar_status				varchar(20) default 'Pending',
    ar_type                 varchar(20),
    created_by              integer,
	approve_status			varchar(16) default 'Completed' not null,
	workflow_table_id		integer,
	created_on        		timestamp default now(),
	action_date				timestamp,
	details					text
);
CREATE INDEX clients_org_id ON clients (org_id);

CREATE TABLE loyalty_points (
	loyalty_loyalty_points_id		serial  primary key,
	org_id 					integer references orgs,
	entity_id				integer references entitys,
	period_id				integer references periods,
	point_date				date,
	segments                real default 0 not null,
	amount                  real default 0 not null,
	points					real default 0 not null,
	points_amount           real default 0 not null,
	bonus                   real default 0 not null,
	approve_status 			character varying(16) DEFAULT 'Completed',
	workflow_table_id 		integer
);
CREATE INDEX loyalty_points_org_id ON loyalty_points (org_id);
CREATE INDEX loyalty_points_entity_id ON loyalty_points (entity_id);
CREATE INDEX loyalty_points_period_id ON loyalty_points (period_id);

CREATE TABLE orders (
	order_id 				serial primary key,
	org_id 					integer references orgs,
	entity_id 				integer not null references entitys,
	points 					real default 0 not null,
	order_amount			real default 0 not null,
	shipping_cost			real default 0 not null,
	order_date				timestamp not null default current_timestamp,
	order_status			varchar(50) default 'Processing order',
	town_name				varchar(50),
	phone_no 				character varying(20),
	physical_address 		text,
	batch_no				integer,
	batch_date				date,
	details 				text
);
CREATE INDEX order_entity_id  ON orders(entity_id);
CREATE INDEX orders_org_id ON orders (org_id);

CREATE TABLE sambaza (
	sambaza_id 				serial primary key,
	org_id 					integer references orgs,
	entity_id 				integer not null references entitys,
	client_code				varchar(20) not null,
	sambaza_in				real default 0 not null,
	sambaza_out				real default 0 not null,
	sambaza_status			varchar(50) default 'Completed',
	sambaza_date			timestamp not null default current_timestamp,
	details 				text
);
CREATE INDEX sambaza_entity_id  ON sambaza(entity_id);
CREATE INDEX sambaza_org_id  ON sambaza(org_id);

CREATE OR REPLACE FUNCTION ins_sambaza() RETURNS trigger AS $$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (trim(lower(client_code)) = trim(lower(NEW.client_code)));
		IF(v_entity_id is null)THEN
			RAISE EXCEPTION 'The Client does not exists';
		END IF;
		INSERT INTO sambaza (org_id, entity_id, client_code, sambaza_in)
		VALUES (0, v_entity_id, NEW.client_code, NEW.sambaza_out);
	END IF;
	RETURN NEW;
END;
$$
  LANGUAGE plpgsql ;
CREATE TRIGGER ins_sambaza  AFTER INSERT  ON sambaza
  FOR EACH ROW
  EXECUTE PROCEDURE ins_sambaza();


CREATE OR REPLACE VIEW vw_entitys AS
	SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default,
		vw_orgs.is_active as org_is_active, vw_orgs.logo as org_logo,

		vw_orgs.org_sys_country_id, vw_orgs.org_sys_country_name,
		vw_orgs.org_address_id, vw_orgs.org_table_name,
		vw_orgs.org_post_office_box, vw_orgs.org_postal_code,
		vw_orgs.org_premises, vw_orgs.org_street, vw_orgs.org_town,
		vw_orgs.org_phone_number, vw_orgs.org_extension,
		vw_orgs.org_mobile, vw_orgs.org_fax, vw_orgs.org_email, vw_orgs.org_website,

		vw_entity_address.address_id, vw_entity_address.address_name,
		vw_entity_address.sys_country_id, vw_entity_address.sys_country_name, vw_entity_address.table_name,
		vw_entity_address.is_default, vw_entity_address.post_office_box, vw_entity_address.postal_code,
		vw_entity_address.premises, vw_entity_address.street, vw_entity_address.town,
		vw_entity_address.phone_number, vw_entity_address.extension, vw_entity_address.mobile,
		vw_entity_address.fax, vw_entity_address.email, vw_entity_address.website,

		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader,
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password,
		entitys.function_role, entitys.primary_email, entitys.primary_telephone,
		entity_types.entity_type_id, entity_types.entity_type_name,
		entity_types.entity_role, entity_types.use_key, entitys.client_code
	FROM (entitys LEFT JOIN vw_entity_address ON entitys.entity_id = vw_entity_address.table_id)
		INNER JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id;

CREATE OR REPLACE VIEW vw_orders AS
    SELECT orders.order_id, orders.order_date, orders.order_status, orders.points, orders.order_amount, orders.batch_no,
        orders.shipping_cost, orders.details, (orders.order_amount + orders.shipping_cost) as grand_total,
        orders.town_name, vw_entitys.org_premises, vw_entitys.org_street, vw_entitys.entity_name, vw_entitys.client_code,
        vw_entitys.entity_id, vw_entitys.org_name, vw_entitys.primary_email, vw_entitys.primary_telephone,
		vw_entitys.function_role, vw_entitys.entity_role, vw_entitys.org_id, orders.physical_address, orders.phone_no
    FROM orders JOIN vw_entitys ON orders.entity_id = vw_entitys.entity_id;

CREATE OR REPLACE VIEW vw_loyalty_points AS
	SELECT loyalty_points.loyalty_points_id, periods.period_id, periods.start_date as period, to_char(periods.start_date, 'mmyyyy'::text) AS ticket_period,
		vw_entitys.client_code, loyalty_points.segments, loyalty_points.amount, loyalty_points.points,	loyalty_points.points_amount,
		loyalty_points.bonus, vw_entitys.org_name, vw_entitys.entity_name, vw_entitys.entity_id,vw_entitys.user_name
	FROM loyalty_points JOIN vw_entitys ON loyalty_points.entity_id = vw_entitys.entity_id,loyalty_points.point_date
	INNER JOIN periods ON loyalty_points.period_id = periods.period_id
	WHERE periods.approve_status = 'Approved';

CREATE OR REPLACE VIEW vw_sambaza AS
 SELECT sambaza.sambaza_id, sambaza.sambaza_in, sambaza.sambaza_out, sambaza.details,
    sambaza.sambaza_date, sambaza.sambaza_status, vw_entitys.entity_name, vw_entitys.client_code, vw_entitys.entity_id,
    vw_entitys.org_name, vw_entitys.primary_email, vw_entitys.primary_telephone, vw_entitys.function_role,
    vw_entitys.entity_role, vw_entitys.org_id
   FROM sambaza
     JOIN vw_entitys ON sambaza.entity_id = vw_entitys.entity_id;

CREATE OR REPLACE VIEW vw_client_statement AS
SELECT a.dr, a.cr, a.order_date::date, a.client_code, a.org_name, a.entity_id,
	(a.dr+a.sambaza_in - a.cr-a.sambaza_out) AS balance, a.sambaza_in, a.sambaza_out, a.details
	FROM ((SELECT COALESCE(vw_loyalty_points.points, 0::real) + COALESCE(vw_loyalty_points.bonus, 0::real) AS dr,
		0::real AS cr, vw_loyalty_points.period AS order_date, vw_loyalty_points.client_code,
		vw_loyalty_points.org_name, vw_loyalty_points.entity_id,
		0::real as sambaza_in, 0::real as sambaza_out, ''::text as details
	FROM vw_loyalty_points)
	UNION ALL
	(SELECT 0::real AS dr, vw_orders.points::real AS cr, vw_orders.order_date,
	vw_orders.client_code, vw_orders.org_name, vw_orders.entity_id,
	0::real as sambaza_in, 0::real as sambaza_out, ''::text as details
	FROM vw_orders)
	UNION ALL
	(SELECT 0::real as dr, 0::real as cr, vw_sambaza.sambaza_date,
	vw_sambaza.client_code, vw_sambaza.org_name, vw_sambaza.entity_id, COALESCE(vw_sambaza.sambaza_in,0::real) as sambaza_in,
	COALESCE(vw_sambaza.sambaza_out,0::real) as sambaza_out, vw_sambaza.details
	 FROM vw_sambaza)) a
	ORDER BY a.order_date;
