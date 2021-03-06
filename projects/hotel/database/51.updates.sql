ALTER TABLE orgs ADD city_code varchar(5) references city_codes;
ALTER TABLE orgs ADD star integer default 1;
ALTER TABLE orgs ADD location text;
ALTER TABLE room_types ADD image character varying(50);
ALTER TABLE orgs ADD image character varying(50);
ALTER TABLE orgs ADD latitude character varying(20);
ALTER TABLE orgs ADD longitude character varying(20);
ALTER TABLE room_rates ADD COLUMN max_occupancy integer;
ALTER TABLE residents ADD COLUMN phone_number character varying(20);

ALTER TABLE bookings ADD COLUMN check_in boolean;
ALTER TABLE bookings ADD COLUMN check_out boolean;

ALTER TABLE bookings ADD COLUMN unit_rate real;

ALTER TABLE orgs ADD COLUMN facebook_link  varchar(50);
ALTER TABLE orgs ADD COLUMN twitter_link  varchar(50);
ALTER TABLE orgs ADD COLUMN google_link  varchar(50);
ALTER TABLE stay ADD COLUMN room_link varchar(20);;
ALTER TABLE stay ADD COLUMN created_by integer  REFERENCES entitys;
CREATE INDEX stay_entity_id ON entitys(entity_id);

ALTER TABLE residents ADD COLUMN booking_id integer REFERENCES bookings;
CREATE INDEX residents_bookin_id ON bookings(booking_id);

CREATE TABLE room_images (
	room_image_id 	serial PRIMARY KEY,
	org_id 			integer REFERENCES orgs,
	room_type_id 	integer REFERENCES room_types,
	images			character varying(50),
	details 		text
);
CREATE INDEX room_images_org_id ON room_images (org_id);
CREATE INDEX room_images_room_type_id ON room_images (room_type_id);



CREATE OR REPLACE VIEW vw_orgs AS
	SELECT orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo,
		orgs.org_full_name, orgs.pin, orgs.pcc, orgs.details,
		orgs.cert_number, orgs.vat_number, orgs.invoice_footer,

		currency.currency_id, currency.currency_name, currency.currency_symbol,

		vw_org_address.org_sys_country_id, vw_org_address.org_sys_country_name,
		vw_org_address.org_address_id, vw_org_address.org_table_name,
		vw_org_address.org_post_office_box, vw_org_address.org_postal_code,
		vw_org_address.org_premises, vw_org_address.org_street, vw_org_address.org_town,
		vw_org_address.org_phone_number, vw_org_address.org_extension,
		vw_org_address.org_mobile, vw_org_address.org_fax, vw_org_address.org_email, vw_org_address.org_website,
		orgs.star,orgs.city_code,city_codes.city_name,orgs.location,orgs.image, orgs.latitude, orgs.longitude,
		orgs.facebook_link, orgs.twitter_link, orgs.google_link
	FROM orgs INNER JOIN currency ON orgs.currency_id = currency.currency_id
	LEFT JOIN city_codes ON orgs.city_code = city_codes.city_code
		LEFT JOIN vw_org_address ON orgs.org_id = vw_org_address.org_table_id;

		CREATE OR REPLACE VIEW vw_room_rates AS
			SELECT room_types.room_type_id, room_types.room_type_name,
				service_types.service_type_id, service_types.service_type_name,
				service_types.tax_rate1, service_types.tax_rate2, service_types.tax_rate3,
				currency.currency_id, currency.currency_name, currency.currency_symbol,
				room_rates.org_id, room_rates.room_rate_id, room_rates.current_rate, room_rates.date_start,
				room_rates.date_end, room_rates.is_active, room_rates.exchange_rate, room_rates.details,
				(room_types.room_type_name || ', ' || service_types.service_type_name || ', ' || room_rates.date_start) as disp,
				room_types.image,vw_orgs.city_code,vw_orgs.star,vw_orgs.location,room_types.units,room_types.max_occupancy,vw_orgs.city_name
			FROM room_rates INNER JOIN room_types ON room_rates.room_type_id = room_types.room_type_id
				INNER JOIN service_types ON room_rates.service_type_id = service_types.service_type_id
				INNER JOIN vw_orgs ON room_rates.org_id = vw_orgs.org_id
				INNER JOIN currency ON room_rates.currency_id = currency.currency_id;



CREATE OR REPLACE VIEW vw_room_images AS
	SELECT room_types.room_type_id, room_types.room_type_name, room_images.details as disp, room_images.room_image_id,
		room_images.images,orgs.org_id,orgs.org_name
	FROM room_images
	INNER JOIN room_types ON room_images.room_type_id = room_types.room_type_id
	INNER JOIN orgs ON room_images.org_id = orgs.org_id;

	CREATE OR REPLACE VIEW vw_sys_users AS
    SELECT vw_entitys.entity_id, vw_entitys.entity_name, vw_entitys.primary_email,vw_entitys.user_name,
	vw_entitys.entity_password, vw_entitys.is_active,vw_entitys.org_id,vw_entitys.use_key_id, vw_entitys.entity_role,vw_entitys.function_role
    FROM vw_entitys
    WHERE vw_entitys.is_active = true;


	CREATE TABLE subscriptions (
		subscription_id			serial primary key,
		industry_id				integer references industry,
		entity_id				integer references entitys,
		account_manager_id		integer references entitys,
		org_id					integer references orgs,

		hotel_name			varchar(50),
		hotel_address		varchar(100),
		city					varchar(30),
		state					varchar(50),
		country_id				char(2) references sys_countrys,
		telephone				varchar(50),
		website					varchar(120),

		primary_contact			varchar(120),
		job_title				varchar(120),
		primary_email			varchar(120),
		confirm_email			varchar(120),

		system_key				varchar(64),
		subscribed				boolean,
		subscribed_date			timestamp,

		approve_status			varchar(16) default 'Draft' not null,
		workflow_table_id		integer,
		application_date		timestamp default now(),
		action_date				timestamp,

		details					text
	);
	CREATE INDEX subscriptions_entity_id ON subscriptions(entity_id);
	CREATE INDEX subscriptions_account_manager_id ON subscriptions(account_manager_id);
	CREATE INDEX subscriptions_country_id ON subscriptions(country_id);
	CREATE INDEX subscriptions_org_id ON subscriptions(org_id);

	CREATE TABLE jobs_category (
		jobs_category_id		serial primary key,
		org_id					integer references orgs,
		jobs_category			varchar(50),
		details					text
	);
	CREATE INDEX jobs_category_org_id ON jobs_category(org_id);

	CREATE TABLE department_roles (
		department_role_id		serial primary key,
		department_id			integer references departments,
		ln_department_role_id	integer references department_roles,
		jobs_category_id		integer references jobs_category,
		org_id					integer references orgs,
		department_role_name	varchar(240) not null,
		active					boolean default true not null,
		job_description			text,
		job_requirements		text,
		duties					text,
		performance_measures	text,
		details					text
	);
	CREATE INDEX department_roles_department_id ON department_roles (department_id);
	CREATE INDEX department_roles_ln_department_role_id ON department_roles (ln_department_role_id);
	CREATE INDEX department_roles_jobs_category_id ON department_roles (jobs_category_id);
	CREATE INDEX department_roles_org_id ON department_roles(org_id);
	INSERT INTO department_roles (org_id, department_role_id, ln_department_role_id, department_id, department_role_name) VALUES (0, 0, 0, 0, 'Chair Person');



	CREATE VIEW vw_subscriptions AS
		SELECT  sys_countrys.sys_country_id, sys_countrys.sys_country_name,
			entitys.entity_id, entitys.entity_name,
			account_manager.entity_id as account_manager_id, account_manager.entity_name as account_manager_name,
			orgs.org_id, orgs.org_name,

			subscriptions.subscription_id, subscriptions.business_name,
			subscriptions.business_address, subscriptions.city, subscriptions.state, subscriptions.country_id,
			subscriptions.number_of_employees, subscriptions.telephone, subscriptions.website,
			subscriptions.primary_contact, subscriptions.job_title, subscriptions.primary_email,
			subscriptions.approve_status, subscriptions.workflow_table_id, subscriptions.application_date, subscriptions.action_date,
			subscriptions.system_key, subscriptions.subscribed, subscriptions.subscribed_date,
			subscriptions.details
		FROM subscriptions
			INNER JOIN sys_countrys ON subscriptions.country_id = sys_countrys.sys_country_id
			LEFT JOIN entitys ON subscriptions.entity_id = entitys.entity_id
			LEFT JOIN entitys as account_manager ON subscriptions.account_manager_id = account_manager.entity_id
			LEFT JOIN orgs ON subscriptions.org_id = orgs.org_id;



CREATE OR REPLACE FUNCTION ins_bookingEmailed() RETURNS TRIGGER AS $$
DECLARE
	myrec RECORD;
BEGIN
	INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name)
		VALUES (2,NEW.org_id, NEW.booking_id, 'bookigs');

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_bookingEmailed AFTER INSERT ON bookings
    FOR EACH ROW EXECUTE PROCEDURE ins_bookingEmailed();


	CREATE TABLE payments (
		payment_id			serial primary key,
		booking_id			integer references bookings,
		paid_by				integer references entitys,
		paymentType			varchar(50),
		amount_paid			real,
		payment_date		timestamp default now(),
		transaction_id		varchar(100),
		status				varchar(50),
		details				text
	);
	CREATE INDEX payments_paid_by ON payments(paid_by);
	CREATE INDEX payments_booking_id ON payments(booking_id);

CREATE OR REPLACE VIEW vw_payments AS
	SELECT payments.payment_id, payments.booking_id, payments.paid_by,payments.amount_paid, payments.paymentType, payments.payment_date::date as payment_date, payments.details,
	payments.transaction_id, payments.status
	FROM payments;
