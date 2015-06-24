---Project Database File

CREATE TABLE devices(
    device_id               serial primary key,
    org_id                  integer references orgs,
    device_name		        varchar(100);
    device_model            varchar(100),
    device_imei_1           varchar(20),
    device_imei_2           varchar(20),
    is_active               boolean default true
);
CREATE INDEX devices_org_id ON devices(org_id);

CREATE TABLE health_workers(
    health_worker_id        serial primary key,
    org_id                  integer references orgs,
    worker_name             varchar(100),
    worker_national_id      varchar(10),
    worker_mobile_num       varchar(10) NOT NULL,
    worker_pass             varchar(33),
    is_first_login          boolean default true,
    is_active               boolean default true,
    device_id               integer references devices,
    date_enrolled           timestamp default CURRENT_TIMESTAMP
);
CREATE INDEX health_workers_org_id ON health_workers(org_id);
CREATE INDEX health_workers_device_id ON health_workers(device_id);

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

INSERT INTO sub_countys(sub_county_id, county_id, sub_county_name) VALUES(1, 1, 'Makadara'),(2, 1, 'Ruaraka');


CREATE TABLE divisions(
    division_id             serial primary key,
    sub_county_id           integer references sub_countys,
    division_name           varchar(100)
);
CREATE INDEX divisions_sub_county_id ON divisions(sub_county_id);

CREATE TABLE locations(
    location_id             serial primary key,
    division_id             integer references divisions,
    location_name           varchar(100)
);
CREATE INDEX locations_division_id ON locations(division_id);

CREATE TABLE sub_locations(
    sub_location_id         serial primary key,
    location_id             integer references divisions,
    location_name           varchar(100)
);
CREATE INDEX sub_locations_location_id ON sub_locations(location_id);


CREATE TABLE surveys(
    survey_id           serial primary key,
    county_id           
);







CREATE VIEW vw_devices AS
	SELECT orgs.org_id, orgs.org_name, devices.device_id, devices.device_model, devices.device_imei_1, devices.device_imei_2, devices.is_active, devices.device_name
	FROM devices
	INNER JOIN orgs ON devices.org_id = orgs.org_id;

CREATE VIEW vw_health_workers AS
	SELECT orgs.org_id, orgs.org_name,
	health_workers.health_worker_id, health_workers.worker_name, health_workers.worker_national_id, health_workers.worker_mobile_num, health_workers.worker_pass, health_workers.is_first_login, health_workers.is_active, health_workers.date_enrolled,
	devices.device_id, devices.device_name, devices.device_model, devices.device_imei_1, devices.device_imei_2, devices.is_active AS device_active
	FROM health_workers
	INNER JOIN devices ON health_workers.device_id = devices.device_id
	INNER JOIN orgs ON health_workers.org_id = orgs.org_id;



