---Project Database File

CREATE TABLE asset_seasons (
    asset_season_id        serial primary key,
	org_id					integer references orgs,
    asset_id                integer references assets,
    season_id               integer references seasons,
    season_start            date,
    season_end              date,
    description             character varying(200),
    season_code             character varying(30)
);
CREATE INDEX asset_seasons_org_id ON asset_seasons (org_id);
CREATE INDEX asset_seasons_asset_id ON asset_seasons (asset_id);
CREATE INDEX asset_seasons_season_id ON asset_seasons (season_id);

CREATE TABLE rates (
	rate_id					serial primary key,
	asset_id				integer references assets,
	org_id					integer references orgs,
	room_type_id			integer references room_types,
    service_type_id			integer references service_types,
    room_category_id		integer references room_categories,
    asset_season_id			    integer references asset_seasons,
	room_description		varchar(50),
	meal_plan				varchar(50),
	start_date				date not null,
	end_date				date not null,
	description				varchar(120),
	currency_id				varchar(3),
	b_rate					real not null default 0,
    s_rate					real not null default 0,
	tax						real not null default 0,
	commission				real not null default 0,
	discount				real not null default 0,
	final_rate				boolean not null default false,
	non_residents			boolean not null default false,
    is_active               boolean not null default true,
	details					text
);
CREATE INDEX rates_asset_id ON rates (asset_id);
CREATE INDEX rates_org_id ON rates (org_id);
CREATE INDEX rates_room_type_id ON rates (room_type_id);
CREATE INDEX rates_service_type_id ON rates (service_type_id);
CREATE INDEX rates_asset_season_id ON rates (asset_season_id);
CREATE INDEX rates_room_category_id ON rates (room_category_id);



CREATE TABLE vouchers (
  voucher_id        serial primary KEY,
  entity_id         integer references entitys,
  asset_id          integer references assets,
  rate_id            integer references rates,
  org_id            integer references orgs,
  ipaddress         character varying(20),
  vendor_id         integer references entitys,
  instructions      character varying(2000),
  client_id          integer references entitys,
   client1           character varying(50),
  client2           character varying(50),
  client3           character varying(50),
  client4           character varying(50),
  client5           character varying(50),
  client6           character varying(50),
  children          character varying(20),
  m_id              integer references mealplans,
  extra_night       character varying(20),
  no_of_night       integer,
  clientname        character varying(50),
  currency          character varying(3),
  pax_num           integer,
  confirmation      character varying(50),
  tripple          integer,
  atselect          character varying(50),
  infants           integer,
  attention         character varying(100),
  transtype         character varying(20),
  infantsage        integer,
  voucherno         character varying(20),
  extra_bed         integer,
  ababycot          character varying(20),
  single           integer,
  no_adults          character varying(20),
  room_type_id      integer REFERENCES room_types,
  double            integer,
  children_age       integer,
  confirmationref   character varying(50),
  charge_tour        boolean,
  extra_tour         boolean,
  residents         boolean,
  voucher_link      character varying(10),
  datein            date,
  dateout           date,
  bookdate          date,
  mark_up           real,
  rates             real,
  sell_amount       real,
  created_by        integer REFERENCES entitys
);
CREATE INDEX vouchers_entity_id ON vouchers (entity_id);
CREATE INDEX vouchers_org_id ON vouchers (org_id);
CREATE INDEX vouchers_rate_id ON vouchers (rate_id);

CREATE TABLE voucher_rates
(
  id serial NOT NULL,
  voucher_id integer,
  rate integer,
  selling_rate integer,
  CONSTRAINT voucher_rates_pkey PRIMARY KEY (id),
  CONSTRAINT voucher_rates_voucher_id_fkey FOREIGN KEY (voucher_id)
      REFERENCES vouchers (voucher_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

CREATE OR REPLACE VIEW vw_asset_seasons AS
	SELECT asset_seasons.asset_season_id ,	asset_seasons.org_id, asset_seasons.asset_id ,  asset_seasons.season_id,
    asset_seasons.season_start, asset_seasons.season_end, asset_seasons.description, asset_seasons.season_code,
    assets.asset_name,  seasons.s_name
	FROM asset_seasons
    INNER JOIN assets ON asset_seasons.asset_id = assets.asset_id
    INNER JOIN seasons ON asset_seasons.season_id =  seasons.id;

CREATE OR REPLACE VIEW vw_rates AS
	SELECT vw_assets.entity_id, vw_assets.vendor_name, vw_assets.sys_country_id, vw_assets.sys_country_name,
		vw_assets.asset_id, vw_assets.asset_name, vw_assets.contact_person, vw_assets.location,
		vw_assets.telno, vw_assets.website, vw_assets.email, vw_assets.details as asset_details,
		rates.rate_id, rates.room_description, rates.meal_plan, rates.start_date, rates.end_date, rates.room_category_id,
		rates.description, rates.currency_id, rates.b_rate, rates.s_rate, rates.tax, rates.commission, rates.discount, rates.final_rate,
		rates.non_residents, rates.details, service_types.service_type_id, service_types.service_type_name,
        room_types.room_type_id, room_types.room_type_name, vw_asset_seasons.asset_season_id, vw_asset_seasons.s_name,room_categories.cat_name,
        rates.is_active
	FROM rates
    INNER JOIN vw_assets ON rates.asset_id = vw_assets.asset_id
    INNER JOIN room_types ON rates.room_type_id =  room_types.room_type_id
    INNER JOIN vw_asset_seasons ON rates.asset_season_id =  vw_asset_seasons.asset_season_id
    INNER JOIN service_types ON rates.service_type_id =  service_types.service_type_id
    INNER JOIN room_categories ON rates.room_category_id =  room_categories.room_category_id;


    CREATE OR REPLACE VIEW vw_vouchers AS
    SELECT vouchers.voucher_id, vouchers.entity_id, vouchers.asset_id, vouchers.rate_id, vouchers.org_id, vouchers.ipaddress,
    vouchers.vendor_id, vouchers.instructions, vouchers.client_id, vouchers.client2, vouchers.client3, vouchers.client4,
    vouchers.client5, vouchers.client6, vouchers.children, vouchers.m_id, vouchers.extra_night, vouchers.no_of_night,
    vouchers.clientname, vouchers.currency, vouchers.pax_num, vouchers.confirmation, vouchers.tripple, vouchers.atselect,
    vouchers.infants, vouchers.attention, vouchers.transtype, vouchers.infantsage, vouchers.voucherno, vouchers.extra_bed,
    vouchers.ababycot, vouchers.single, vouchers.no_adults, vouchers.room_type_id, vouchers.double as adouble, vouchers.children_age,
    vouchers.confirmationref, vouchers.charge_tour, vouchers.extra_tour, vouchers.residents, vouchers.voucher_link, vouchers.datein,
    vouchers.dateout, vouchers.bookdate, vouchers.mark_up, vouchers.created_by, vouchers.client1, room_types.room_type_name,
    entitys.entity_name,client.entity_name as client_name,vouchers.rates,vouchers.sell_amount, assets.asset_name,vendor.entity_name as vendor_name,
    vw_rates.s_name,orgs.org_name,vouchers.voucher_id as voucherid, vw_rates.service_type_name, vw_rates.service_type_id
    FROM vouchers
    INNER JOIN entitys ON  vouchers.entity_id=entitys.entity_id
    INNER JOIN orgs ON  vouchers.org_id=orgs.org_id
    INNER JOIN entitys as client ON  vouchers.client_id=client.entity_id
    INNER JOIN entitys as vendor ON  vouchers.vendor_id=vendor.entity_id
    INNER JOIN room_types ON room_types.room_type_id = vouchers.room_type_id
    INNER JOIN assets ON assets.asset_id = vouchers.asset_id
    INNER JOIN vw_rates ON vw_rates.rate_id = vouchers.rate_id
