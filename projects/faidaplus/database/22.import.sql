
-- load extension first time after install
CREATE EXTENSION mysql_fdw;

-- create server object
CREATE SERVER mysql_server
	FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host '127.0.0.1', port '3306');

-- create user mapping
CREATE USER MAPPING FOR postgres SERVER mysql_server
OPTIONS (username 'root');

CREATE FOREIGN TABLE i_salutation (
	id_salutation			integer, 
	salutation			varchar(7), 
	"order"			integer
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'salutation');

CREATE FOREIGN TABLE i_staff (
	id_staff			integer, 
	"group"			char(7), 
	comp_position			varchar(37), 
	rel_id_salutation			integer, 
	first_name			varchar(22), 
	last_name			varchar(22), 
	other_name			varchar(37), 
	email			varchar(150), 
	cellphone			varchar(22), 
	landline			varchar(22), 
	shipping			VARCHAR, 
	rel_id_staff			integer
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'staff');

CREATE FOREIGN TABLE i_consultant (
	id_consultant			integer, 
	rel_id_salutation			integer, 
	newsletter			char(0), 
	first_name			varchar(22), 
	last_name			varchar(22), 
	other_name			varchar(37), 
	email			varchar(150), 
	birthdate			DATE, 
	cellphone			varchar(22), 
	landline			varchar(22), 
	shipping			VARCHAR, 
	rel_pcc			varchar(3), 
	pcc			varchar(3), 
	son			varchar(2), 
	create_date			timestamp
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'consultant');

CREATE FOREIGN TABLE i_user (
	id_user			integer, 
	rel_id			integer, 
	newsletter			char(1), 
	email			varchar(191), 
	new_email			varchar(191), 
	email_token			varchar(15), 
	username			varchar(23), 
	"password"			varchar(15), 
	salt			varchar(192), 
	hash			varchar(192), 
	sign_up_token			varchar(15), 
	password_token			varchar(15), 
	create_date			timestamp, 
	last_login			timestamp, 
	active			char(1), 
	rel_id_user_status			integer, 
	permanent			char(1), 
	"group"			char(7), 
	archive			integer, 
	cellphone			varchar(15), 
	profile_photo			varchar(75), 
	sms_alert			char(1), 
	email_alert			char(1)
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'user');

CREATE FOREIGN TABLE i_town (
	id_town			integer, 
	town			varchar(50), 
	aramex			char(1)
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'town');

CREATE FOREIGN TABLE i_agency (
	id_agency			integer, 
	rel_id_agency			integer, 
	agency_name			varchar(191), 
	pcc			varchar(3), 
	rel_pcc			varchar(3), 
	rel_id_staff			integer, 
	status			char(1), 
	date_added			timestamp, 
	last_production			DATE, 
	rel_id_town			integer, 
	iata			char(1), 
	galileo			char(1), 
	amadeus			char(1), 
	sabre			char(1)
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'agency');

CREATE FOREIGN TABLE i_supplier (
	id_supplier			integer, 
	name			varchar(200), 
	brief			varchar(300), 
	logo			varchar(200), 
	website			varchar(200), 
	create_date			timestamp
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'supplier');

CREATE FOREIGN TABLE i_shop_category (
	id_shop_category			integer, 
	category			varchar(75)
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'shop_category');

CREATE FOREIGN TABLE i_shop_item (
	id_shop_item			integer, 
	rel_id_shop_category			integer, 
	rel_id_supplier			integer, 
	active			char(1), 
	title			varchar(75), 
	brief			VARCHAR, 
	terms			VARCHAR, 
	rel_id_shop_item_batch			integer, 
	pix			varchar(150), 
	thumb_nail			varchar(150), 
	fb_pix			varchar(150), 
	views			integer, 
	likes			integer, 
	popularity			DECIMAL, 
	qty			char(1), 
	rel_id_shop_item_qty			integer, 
	expiry			char(1), 
	rel_id_shop_item_expiry			integer, 
	redeem_limit			char(1),
	rel_id_shop_item_redeem_limit			integer, 
	weight			DECIMAL
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'shop_item');

CREATE FOREIGN TABLE i_shop_item_batch (
	id_shop_item_batch			integer, 
	rel_id_shop_item			integer, 
	cost			DECIMAL, 
	undiscounted_cost			DECIMAL, 
	purchase_cost			DECIMAL, 
	limit_per_user			integer, 
	stock			integer
)
SERVER mysql_server OPTIONS(dbname 'faidaplus', table_name 'shop_item_batch');



------- Import script
INSERT INTO suppliers (supplier_id, supplier_name) VALUES(0, 'Travelport');
INSERT INTO suppliers (supplier_id, supplier_name, website, create_date)
SELECT id_supplier, name, website, create_date
FROM i_supplier;

INSERT INTO product_category (product_category_id, product_category_name) VALUES(0, 'No category');
INSERT INTO product_category (product_category_id, product_category_name)
SELECT id_shop_category, category
FROM i_shop_category
ORDER BY id_shop_category;

INSERT INTO products (product_id, product_category_id, supplier_id, is_active,
	product_name, product_details, terms, weight, image,
	product_uprice, product_ucost)
SELECT a.id_shop_item, a.rel_id_shop_category, a.rel_id_supplier, a.active::boolean, 
	a.title, a.brief, a.terms, a.weight, a.pix,
	b.cost, b.purchase_cost
FROM i_shop_item a INNER JOIN i_shop_item_batch b ON a.rel_id_shop_item_batch = b.id_shop_item_batch;

INSERT INTO entitys(entity_type_id, org_id, function_role, salutation, entity_name,
	entity_id, primary_email, user_name, first_password, date_enroled, last_login,
	user_status, primary_telephone, sms_alert, email_alert, newsletter, is_active)
SELECT 1, 0, 'staff', a.salutation, (b.first_name || ' ' || b.last_name),
	c.id_user, c.email, c.username, c.password, c.create_date, c.last_login, 
	c.rel_id_user_status, c.cellphone, c.sms_alert::boolean, c.email_alert::boolean, c.newsletter::boolean,
	CASE WHEN c.active = '1' THEN true ELSE false END
FROM i_salutation a INNER JOIN i_staff b ON a.id_salutation = b.rel_id_salutation
	INNER JOIN i_user c ON b.id_staff = c.rel_id
WHERE c.group = 'staff'
ORDER BY c.id_user;


INSERT INTO entitys(entity_type_id, org_id, function_role, salutation, entity_name,
	birth_date, shipping,  pcc_son, son, 
	entity_id, primary_email, user_name, first_password, date_enroled, last_login,
	user_status, primary_telephone, sms_alert, email_alert, newsletter, is_active)
SELECT 0, 0, 'consultant', a.salutation, (COALESCE(b.first_name, '') || ' ' || COALESCE(b.last_name, '')),
	b.birthdate, b.shipping, b.pcc, b.son, 
	c.id_user, c.email, c.username, c.password, c.create_date, c.last_login, 
	c.rel_id_user_status, c.cellphone, c.sms_alert::boolean, c.email_alert::boolean, c.newsletter::boolean,
	CASE WHEN c.active = '1' THEN true ELSE false END
FROM i_salutation a INNER JOIN i_consultant b ON a.id_salutation = b.rel_id_salutation
	INNER JOIN i_user c ON b.id_consultant = c.rel_id
WHERE c.group = 'consultant'
ORDER BY c.id_user;


UPDATE entitys SET entity_name = initcap(trim(entity_name)),  pcc_son = upper(trim(pcc_son)), son = upper(trim(son)), primary_email = lower(trim(primary_email)), user_name = lower(trim(user_name));

INSERT INTO towns(town_id, town_name, aramex)
SELECT id_town, town, aramex::boolean
FROM i_town
ORDER BY id_town;

INSERT INTO orgs(org_id, parent_org_id, org_name, org_sufix, pcc,
	account_manager_id, date_enroled, is_iata, town_id)
SELECT c.id_agency, c.rel_id_agency, c.agency_name, c.pcc, c.pcc, 
	b.id_user, c.date_added, c.iata::boolean, c.rel_id_town
FROM i_agency c INNER JOIN 
(SELECT a.id_user, a.rel_id FROM i_user a WHERE a.group = 'staff') b
ON c.rel_id_staff = b.rel_id
ORDER BY c.id_agency;


UPDATE orgs SET pcc = upper(trim(pcc)), org_name = initcap(trim(org_name));

UPDATE entitys SET org_id = orgs.org_id
FROM orgs WHERE (entitys.pcc_son is not null) and (entitys.pcc_son = orgs.pcc);






