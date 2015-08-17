---Project Database File

CREATE TABLE years (
    year_id         serial primary key,
    year_name       varchar(5)
);

INSERT INTO years(year_id, year_name) VALUES
(1, '2013'),
(2, '2014'),
(3, '2015');

CREATE TABLE months(
    month_id        serial primary key,
    month_name      varchar(15)
);

INSERT INTO months(month_id, month_name) VALUES
(1, 'January'),
(2, 'February'),
(3, 'March'),
(4, 'April'),
(5, 'May'),
(6, 'June'),
(7, 'July'),
(8, 'August'),
(9, 'September'),
(10, 'October'),
(11, 'November'),
(12, 'December');

CREATE TABLE countys(
    county_id           serial primary key,
    county_name         varchar(100)
);

INSERT INTO countys(county_id, county_name) VALUES(1, 'Nairobi');

CREATE TABLE sub_countys(
    sub_county_id           serial primary key,
    county_id               integer references countys,
    sub_county_name         varchar(100)
);
CREATE INDEX sub_countys_county_id ON sub_countys(county_id);

INSERT INTO sub_countys(sub_county_id, county_id, sub_county_name) VALUES
(1, 1, 'Kasarani'),
(2, 1, 'Makadara'),
(3, 1, 'Ruaraka');

CREATE TABLE divisions(
    division_id             serial primary key,
    sub_county_id           integer references sub_countys,
    division_name           varchar(200)
);
CREATE INDEX divisions_sub_county_id ON divisions(sub_county_id);

CREATE TABLE locations(
    location_id             serial primary key,
    division_id             integer references divisions,
    location_name           varchar(200)
);
CREATE INDEX locations_division_id ON locations(division_id);

CREATE TABLE sub_locations(
    sub_location_id         serial primary key,
    location_id             integer references divisions,
    sub_location_name       varchar(200)
);
CREATE INDEX sub_locations_location_id ON sub_locations(location_id);


CREATE TABLE villages(
    village_id              serial primary key,
    sub_location_id         integer references sub_locations,
    village_name            varchar(200)
);
CREATE INDEX villages_sub_location_id ON villages(sub_location_id);

ALTER TABLE orgs ADD village_id              integer references villages;



CREATE TABLE facility_data(
    health_facility_data_id serial primary key,
    entity_id               integer references entitys,
    org_id                  integer references orgs,
    year_id                 integer references years,
    month_id                integer references months,
    indicator_1a			integer NOT NULL default 0,
    indicator_1b			integer NOT NULL default 0,
    indicator_1c			integer NOT NULL default 0,
    indicator_1d			integer NOT NULL default 0,
    indicator_1e			integer NOT NULL default 0,
    indicator_1f			integer NOT NULL default 0,
    indicator_2			    integer NOT NULL default 0,
    indicator_3			    integer NOT NULL default 0,
    indicator_4			    integer NOT NULL default 0,
    indicator_5			    integer NOT NULL default 0,
    indicator_6			    integer NOT NULL default 0,
    indicator_7			    integer NOT NULL default 0,
    indicator_8			    integer NOT NULL default 0,
    indicator_9			    integer NOT NULL default 0,
    indicator_10			integer NOT NULL default 0,
    indicator_11			integer NOT NULL default 0,
    indicator_12			integer NOT NULL default 0,
    indicator_13			integer NOT NULL default 0,
    indicator_14			integer NOT NULL default 0,
    indicator_15			integer NOT NULL default 0,
    indicator_16			integer NOT NULL default 0,
    indicator_17			integer NOT NULL default 0,
    indicator_18			integer NOT NULL default 0,
    indicator_19			integer NOT NULL default 0,
    indicator_20			integer NOT NULL default 0,
    indicator_21			integer NOT NULL default 0,
    indicator_22			integer NOT NULL default 0,
    indicator_23			integer NOT NULL default 0,
    indicator_24			integer NOT NULL default 0,
    indicator_25			integer NOT NULL default 0,
    indicator_26			integer NOT NULL default 0,
    indicator_27			integer NOT NULL default 0,
    indicator_28			integer NOT NULL default 0,
    indicator_29			integer NOT NULL default 0,
    indicator_30			integer NOT NULL default 0,
    indicator_31			integer NOT NULL default 0,
    indicator_32			integer NOT NULL default 0,
    indicator_33			integer NOT NULL default 0,
    indicator_34			integer NOT NULL default 0,
    indicator_35			integer NOT NULL default 0,
    indicator_36			integer NOT NULL default 0,
    indicator_37			integer NOT NULL default 0,
    indicator_38			integer NOT NULL default 0,
    indicator_39			integer NOT NULL default 0,
    indicator_40			integer NOT NULL default 0,
    indicator_41			integer NOT NULL default 0,
    indicator_42			integer NOT NULL default 0,
    remarks                 text,
    creation_date           timestamp default CURRENT_TIMESTAMP
);


CREATE VIEW vw_villages AS
	SELECT
		countys.county_id, countys.county_name,
		sub_countys.sub_county_id, sub_countys.sub_county_name,
		divisions.division_id, divisions.division_name,
		locations.location_id , locations.location_name,
		sub_locations.sub_location_id, sub_locations.sub_location_name,
		villages.village_id, villages.village_name
	FROM villages
	INNER JOIN sub_locations ON sub_locations.sub_location_id = villages.sub_location_id
	INNER JOIN locations ON locations.location_id = sub_locations.location_id
	INNER JOIN divisions ON divisions.division_id = locations.division_id
	INNER JOIN sub_countys ON sub_countys.sub_county_id = divisions.sub_county_id
	INNER JOIN countys ON countys.county_id = sub_countys.county_id;


CREATE VIEW vw_healthfacilities AS
    SELECT orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo, orgs.details,
            vw_villages.county_id, vw_villages.county_name, vw_villages.sub_county_id, vw_villages.sub_county_name, vw_villages.division_id,
            vw_villages.division_name, vw_villages.location_id, vw_villages.location_name, vw_villages.sub_location_id,
            vw_villages.sub_location_name, vw_villages.village_id, vw_villages.village_name,
            vw_org_address.org_sys_country_id, vw_org_address.org_sys_country_name,
            vw_org_address.org_address_id, vw_org_address.org_table_name,
            vw_org_address.org_post_office_box, vw_org_address.org_postal_code,
            vw_org_address.org_premises, vw_org_address.org_street, vw_org_address.org_town,
            vw_org_address.org_phone_number, vw_org_address.org_extension,
            vw_org_address.org_mobile, vw_org_address.org_fax, vw_org_address.org_email, vw_org_address.org_website
    	FROM orgs
    	LEFT JOIN vw_org_address ON orgs.org_id = vw_org_address.org_table_id
    	INNER JOIN vw_villages ON vw_villages.village_id = orgs.village_id;
