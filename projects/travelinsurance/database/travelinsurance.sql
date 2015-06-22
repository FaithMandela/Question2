---Project Database File

ALTER TABLE orgs ADD credit_limit real not null default 0;
ALTER TABLE orgs ADD pcc varchar(4);
ALTER TABLE address ADD CONSTRAINT address_org_id_mobile_key UNIQUE (org_id, mobile);
ALTER TABLE entitys ADD son varchar(6);

CREATE TABLE rate_types(
    rate_type_id        serial primary key,
    rate_type_name      varchar(100),
    details             text
);


CREATE TABLE rates(
    rate_id             serial primary key,
    rate_type_id        integer references rate_types,
    days_from           integer,
    days_to             integer,
    standard_rate       real,
    north_america_rate  real,
);

CREATE TABLE passengers(
    passenger_id        serial primary key,
    rate_id             integer references  rates,
    passenger_name      varchar(100),
    passenger_mobile    varchar(15),
    passenger_email     varchar(100),
    passenger_age       integer default 0,
    days_covered        integer,
    nok_name            varchar(100),
    nok_mobile          varchar(15),
    nok_national_id     varchar(20)
);
CREATE INDEX passengers_rate_id ON passengers(rate_id);

CREATE TABLE payments(
    payment_id              serial primary key,
    org_id                  integer references orgs,
    payment_amount          real,
    transaction_reference   varchar(100),
    payment_date            date,
    approved                boolean default false,
    details                 text
); 
CREATE INDEX payments_org_id ON payments(org_id);









