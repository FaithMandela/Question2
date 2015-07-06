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

INSERT INTO sub_countys(sub_county_id, county_id, sub_county_name) VALUES(1, 1, 'Makadara'),
(2, 1, 'Ruaraka');


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


CREATE TABLE mother_info_defs(
    mother_info_def_id       serial primary key,
    question                 text,
    details                  text
);

CREATE TABLE child_info_defs(
    child_info_def_id        serial primary key,
    question                 text,
    details                  text
);

CREATE TABLE referral_info_defs(
    referral_info_def_id     serial primary key,
    question                 text,
    details                  text
);

CREATE TABLE defaulters_info_defs(
    defaulters_info_def_id        serial primary key,
    question                 text,
    details                  text
);

CREATE TABLE death_info_defs(
    death_info_def_id        serial primary key,
    question                 text,
    details                  text
);


CREATE TABLE household_info_defs(
    household_info_def_id        serial primary key,
    question                 text,
    details                  text
);

CREATE TABLE surveys(
    survey_id           serial primary key,
    org_id              integer references orgs,
    sub_county_id       integer references sub_countys,
    health_worker_id    integer references health_workers,
    village_name        varchar(225),
    household_number    varchar(100),
    household_member    varchar(225),
    survey_time         timestamp default CURRENT_TIMESTAMP,
    location_lat        varchar(30),
    location_lng	    varchar(30),
    remarks             text,
);

CREATE TABLE survey_mother(
    survey_mother_id        serial primary key,
    survey_id               integer references surveys,
    mother_info_def_id      integer references mother_info_defs,
    response                integer
);

CREATE TABLE survey_child(
    survey_child_id        serial primary key,
    survey_id              integer references surveys,
    household_info_def_id      integer references child_info_defs,
    response               integer
);

CREATE TABLE survey_referrals(
    survey_referral_id          serial primary key,
    survey_id                   integer references surveys,
    referral_info_defs_id       integer references referral_info_defs,
    response                    varchar(225)
);



CREATE TABLE survey_defaulters(
    survey_defaulter_id         serial primary key,
    survey_id                   integer references surveys,
    defaulters_info_def_id      integer references defaulters_info_defs,
    response                    integer
);

CREATE TABLE survey_death(
    survey_death_id             serial primary key,
    survey_id                   integer references surveys,
    death_info_def_id           integer references death_info_defs,
    response                    varchar(225)
);


CREATE TABLE survey_household(
    survey_household_id    serial primary key,
    survey_id              integer references surveys,
    household_info_def_id  integer references household_info_defs,
    response               integer
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

CREATE VIEW vw_sub_countys AS
	SELECT countys.county_id, countys.county_name, sub_countys.sub_county_id, sub_countys.sub_county_name
	FROM sub_countys
	INNER JOIN countys ON sub_countys.county_id = countys.county_id;




CREATE VIEW vw_surveys AS
	SELECT health_workers.health_worker_id, health_workers.worker_name, 
	orgs.org_id, orgs.org_name, 
	countys.county_id, countys.county_name,
	sub_countys.sub_county_id, sub_countys.sub_county_name, surveys.survey_id, surveys.village_name, surveys.household_number, surveys.household_member, surveys.survey_time, surveys.location_lat, surveys.location_lng, surveys.remarks
	FROM surveys
	INNER JOIN health_workers ON surveys.health_worker_id = health_workers.health_worker_id
	INNER JOIN orgs ON surveys.org_id = orgs.org_id
	INNER JOIN sub_countys ON surveys.sub_county_id = sub_countys.sub_county_id
	INNER JOIN countys ON sub_countys.county_id = countys.county_id;


-- DROP VIEW vw_survey_mother;
CREATE VIEW vw_survey_mother AS
	SELECT mother_info_defs.mother_info_def_id, mother_info_defs.question, mother_info_defs.details ,
	surveys.survey_id,  survey_mother.survey_mother_id, survey_mother.response,
	(CASE survey_mother.response WHEN '1' THEN 'YES'
		WHEN '2' THEN 'NO'
		WHEN '3' THEN 'N/A' ELSE 'N/A' END ) AS response_name
	
	FROM survey_mother
	INNER JOIN mother_info_defs ON survey_mother.mother_info_def_id = mother_info_defs.mother_info_def_id
	INNER JOIN surveys ON survey_mother.survey_id = surveys.survey_id;


-- DROP VIEW vw_survey_child;
CREATE VIEW vw_survey_child AS
	SELECT child_info_defs.child_info_def_id, child_info_defs.question,child_info_defs.details, 
	surveys.survey_id, survey_child.survey_child_id, survey_child.response,
    (CASE survey_child.response WHEN '1' THEN 'YES'
            WHEN '2' THEN 'NO'
            WHEN '3' THEN 'N/A' ELSE 'N/A' END ) AS response_name
	FROM survey_child
	INNER JOIN child_info_defs ON survey_child.child_info_def_id = child_info_defs.child_info_def_id
	INNER JOIN surveys ON survey_child.survey_id = surveys.survey_id;


-- DROP VIEW vw_survey_referrals ;
CREATE VIEW vw_survey_referrals AS
	SELECT referral_info_defs.referral_info_def_id, referral_info_defs.question, referral_info_defs.details , 
	surveys.survey_id,  survey_referrals.survey_referral_id, survey_referrals.referral_info_defs_id, survey_referrals.response,
	(CASE survey_referrals.response WHEN '1' THEN 'YES'
            WHEN '2' THEN 'NO'
            WHEN '3' THEN 'N/A' ELSE survey_referrals.response END ) AS response_name
	FROM survey_referrals
	INNER JOIN referral_info_defs ON survey_referrals.referral_info_defs_id = referral_info_defs.referral_info_def_id
	INNER JOIN surveys ON survey_referrals.survey_id = surveys.survey_id;

-- DROP VIEW vw_survey_defaulters;
CREATE VIEW vw_survey_defaulters AS
	SELECT defaulters_info_defs.defaulters_info_def_id, defaulters_info_defs.question, defaulters_info_defs.details,
	surveys.survey_id, survey_defaulters.survey_defaulter_id, survey_defaulters.response,
	(CASE survey_defaulters.response WHEN '1' THEN 'YES'
		WHEN '2' THEN 'NO'
		WHEN '3' THEN 'N/A' ELSE 'N/A' END ) AS response_name
	FROM survey_defaulters
	INNER JOIN defaulters_info_defs ON survey_defaulters.defaulters_info_def_id = defaulters_info_defs.defaulters_info_def_id
	INNER JOIN surveys ON survey_defaulters.survey_id = surveys.survey_id;

-- DROP VIEW vw_survey_death;
CREATE VIEW vw_survey_death AS
	SELECT death_info_defs.death_info_def_id, death_info_defs.question, death_info_defs.details,
	surveys.survey_id, survey_death.survey_death_id, survey_death.response
	FROM survey_death
	INNER JOIN death_info_defs ON survey_death.death_info_def_id = death_info_defs.death_info_def_id
	INNER JOIN surveys ON survey_death.survey_id = surveys.survey_id;

-- DROP VIEW vw_survey_household ;
CREATE VIEW vw_survey_household AS
	SELECT household_info_defs.household_info_def_id,  household_info_defs.question, household_info_defs.details,
	surveys.survey_id, survey_household.survey_household_id, survey_household.response,
    (CASE survey_household.response WHEN '1' THEN 'YES'
            WHEN '2' THEN 'NO'
            WHEN '3' THEN 'N/A' ELSE 'N/A' END ) AS response_name
	FROM survey_household
	INNER JOIN household_info_defs ON survey_household.household_info_def_id = household_info_defs.household_info_def_id
	INNER JOIN surveys ON survey_household.survey_id = surveys.survey_id;



	

