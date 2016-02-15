---Project Database File

/*CREATE EXTENSION postgres_fdw;
CREATE SERVER dot2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '192.168.0.2', dbname 'sms', port '5432');
CREATE USER MAPPING FOR root SERVER dot2 OPTIONS(user 'sms_user', password 'Invent2k');
CREATE USER MAPPING FOR postgres SERVER dot2 OPTIONS(user 'sms_user', password 'Invent2k');

CREATE FOREIGN TABLE sms_i(
   -- sms_id					integer,
	folder_id				integer,
	address_group_id		integer,
	entity_id				integer,
	org_id					integer,
	sms_origin				varchar(25),
	sms_number				varchar(25),
	sms_numbers				text,
	sms_time				timestamp,
	number_error			boolean ,
	message_ready			boolean ,
	sent					boolean ,
	retries					integer ,
	last_retry				timestamp,
	senderAddress			varchar(64),
	serviceId				varchar(64),
	spRevpassword			varchar(64),
	dateTime				timestamp,
	correlator				varchar(64),
	traceUniqueID			varchar(64),
	linkid					varchar(64),
	spRevId					varchar(64),
	spId					varchar(64),
	smsServiceActivationNumber	varchar(64),
	link_id					integer,
	message					text,
	details					text
) SERVER dot2 OPTIONS(table_name 'sms')
*/



CREATE TABLE payment_types(
    payment_type_id     serial primary key,
    payment_type_name   varchar(40)
);

INSERT INTO payment_types(payment_type_id, payment_type_name)
        VALUES  (1, 'Cash'),
                (2, 'Credit');



CREATE TABLE car_types(
    car_type_id         serial primary key,
    car_type_code       varchar(10) NOT NULL UNIQUE,
    car_type_name       varchar(75) NOT NULL
);

INSERT INTO car_types( car_type_id, car_type_code, car_type_name)
        VALUES  (1, '4 WHEEL', '4 WHEEL DRIVE'),
                (2, 'MINIBUS -B', 'MINIBUS 9 seater'),
                (3, 'MINIBUS -C', 'MINIBUS 25 seater'),
                (4, 'SALOON', 'SALOON CAR');



CREATE TABLE supplier_codes(
    AIR_AGENT_CODE      varchar(10),
    AIR_AGENT_NAME      varchar(75)
);

CREATE TABLE drivers(
    driver_id           serial primary key,
    org_id		        integer references orgs,
    driver_name         varchar(100),
    AIR_AGENT_CODE      varchar(10),
    mobile_number       varchar(15),
    active              boolean default true,
    driver_pin          varchar(35),
    is_backup           boolean default false,
    details             text
);
CREATE INDEX drivers_org_id ON drivers(org_id);




CREATE TABLE cars(
    car_id              serial primary key,
    org_id				integer references orgs,
    car_type_id         integer references car_types,
    registration_number varchar(100),
    active              boolean default true,
    details             text
);
CREATE INDEX cars_org_id ON cars(org_id);
CREATE INDEX cars_car_type_id ON cars(car_type_id);

CREATE TABLE transfers(
    transfer_id         serial primary key,
    entity_id           integer references entitys,
    record_locator      varchar(10),
    customer_code       varchar(20),
    customer_name       varchar(255),
    payment_type_id     integer references payment_types,
    currency_id         varchar(4),
    agreed_amount       real not null default 0,
    booking_location    varchar(2),
    booking_date        timestamp default CURRENT_TIMESTAMP,
    payment_details     text,
    reference_data      text,
    tc_email            varchar(100),
    pax_no              integer default 1,
    transfer_cancelled  boolean default false,
    is_group            boolean default false,
    create_source       integer default 1
);


CREATE INDEX transfers_entity_id ON transfers(entity_id);
CREATE INDEX transfers_payment_type_id ON transfers(payment_type_id);



-- INSERT INTO transfers(entity_id, record_locator, customer_code, payment_type_id,         currency_id, agreed_amount, booking_location, booking_date, payment_details, reference_data) VALUES (3, null, '000000A018', 1, 'AFA', '30000', '07', to_date('20-04-2015', 'dd-MM-yyyy'), 'payement details', 'ref data')

CREATE TABLE transfer_flights(
    transfer_flight_id      serial primary key,
    transfer_id             integer references transfers,
    start_time              time,
    end_time                time,
    flight_date             date,
    start_airport           varchar(100),
    end_airport             varchar(100),
    airline                 varchar(10),
    flight_num              varchar(10),
    tab                     integer,
    create_key              integer default 1
);
CREATE INDEX transfer_flights_transfer_id ON transfer_flights(transfer_id);

-- DROP TABLE passangers;
CREATE TABLE passangers(
    passanger_id        serial primary key,
    transfer_id         integer references transfers,
    passanger_name      varchar(100),
    passanger_mobile    varchar(15),
    passanger_email     varchar(100),
    car_type_code       varchar(10) references car_types(car_type_code),
    pickup_date         date,
    pickup_time         varchar(10),
    pickup              varchar(255),
    dropoff             varchar(255),
    amount              real not null default 0,
    processed           boolean default false,
    pax_cancelled       boolean default false,
    other_preference   text,
    tab                integer not null,
    group_contact      boolean default false,
    group_member       boolean default false
);
CREATE INDEX passangers_transfer_id ON passangers(transfer_id);



CREATE TABLE transfer_assignments(
    transfer_assignment_id      serial primary key,
    passanger_id                integer references passangers,
    driver_id                   integer references drivers,
    car_id                      integer references cars,
    confirmation_code           varchar(25),
    kms_out                     varchar(100),
    time_out                    time,
    kms_in                      varchar(100),
    time_in                     time,
    cancelled                   boolean default false,
    no_show                     boolean default false,
    no_show_reason              text,
    closed                      boolean default false,
    cancelled                   boolean default false,
    cancel_reason               text,
    last_update                 timestamp default CURRENT_TIMESTAMP
);
CREATE INDEX transfer_assignments_passanger_id ON transfer_assignments(passanger_id);
CREATE INDEX transfer_assignments_driver_id ON transfer_assignments(driver_id);
CREATE INDEX transfer_assignments_car_id ON transfer_assignments(car_id);






-- VIEWS

CREATE VIEW vw_cars AS
	SELECT car_types.car_type_id, car_types.car_type_name, orgs.org_id, orgs.org_name, cars.car_id, cars.registration_number, cars.active, cars.details
	FROM cars
	INNER JOIN car_types ON cars.car_type_id = car_types.car_type_id
	INNER JOIN orgs ON cars.org_id = orgs.org_id;

CREATE VIEW vw_transfers AS
	SELECT entitys.entity_id, entitys.entity_name,
            payment_types.payment_type_id, payment_types.payment_type_name,
            transfers.transfer_id, transfers.record_locator, transfers.customer_code, transfers.currency_id, transfers.agreed_amount,
            transfers.booking_location, transfers.booking_date, transfers.payment_details, transfers.reference_data
	FROM transfers
	INNER JOIN entitys ON transfers.entity_id = entitys.entity_id
	INNER JOIN payment_types ON transfers.payment_type_id = payment_types.payment_type_id;


-- DROP VIEW vw_passangers;
CREATE OR REPLACE VIEW vw_passangers AS 
 SELECT car_types.car_type_code, entitys.entity_id, entitys.entity_name, 
    payment_types.payment_type_id, payment_types.payment_type_name, 
    transfers.transfer_id, transfers.record_locator, transfers.customer_code, 
    transfers.customer_name, transfers.currency_id, transfers.agreed_amount, 
    transfers.pax_no, transfers.transfer_cancelled, transfers.booking_location, transfers.booking_date, 
    transfers.payment_details, transfers.reference_data, 
    transfer_flights.transfer_flight_id, transfer_flights.start_time, 
    transfer_flights.end_time, transfer_flights.flight_date, 
    transfer_flights.start_airport, transfer_flights.end_airport, 
    transfer_flights.airline, transfer_flights.flight_num, 
    passangers.passanger_id, passangers.passanger_name, 
    passangers.passanger_mobile, passangers.passanger_email, 
    passangers.pickup_time, passangers.pickup, passangers.dropoff, 
    passangers.other_preference, passangers.tab, passangers.amount, 
    passangers.processed, pax_cancelled, passangers.pickup_date
   FROM passangers
   JOIN car_types ON passangers.car_type_code::text = car_types.car_type_code::text
   JOIN transfers ON passangers.transfer_id = transfers.transfer_id
   JOIN entitys ON transfers.entity_id = entitys.entity_id
   JOIN payment_types ON transfers.payment_type_id = payment_types.payment_type_id
   LEFT JOIN transfer_flights ON transfer_flights.transfer_id = transfers.transfer_id
  WHERE transfer_flights.tab IS NULL OR transfer_flights.tab = passangers.tab;


CREATE VIEW vw_passangers_noflights AS
	SELECT car_types.car_type_code,
	entitys.entity_id, entitys.entity_name,
	payment_types.payment_type_id, payment_types.payment_type_name,
	transfers.transfer_id, transfers.record_locator, transfers.customer_code, transfers.currency_id, transfers.agreed_amount, transfers.booking_location, transfers.booking_date, transfers.payment_details, transfers.reference_data,

    transfer_flights.transfer_flight_id, transfer_flights.start_time,  transfer_flights.end_time, transfer_flights.flight_date, transfer_flights.start_airport,
    transfer_flights.end_airport, transfer_flights.airline, transfer_flights.flight_num,

	passangers.passanger_id, passangers.passanger_name, passangers.passanger_mobile, passangers.passanger_email, passangers.pickup_time, passangers.pickup, passangers.dropoff, passangers.other_preference, passangers.tab,
	passangers.amount, passangers.processed, passangers.pickup_date
    FROM passangers
	INNER JOIN car_types ON passangers.car_type_code = car_types.car_type_code
	INNER JOIN transfers ON passangers.transfer_id = transfers.transfer_id
	INNER JOIN entitys ON transfers.entity_id = entitys.entity_id
	INNER JOIN payment_types ON transfers.payment_type_id = payment_types.payment_type_id
    INNER JOIN transfer_flights ON transfer_flights.transfer_id = transfers.transfer_id;




-- DROP VIEW vw_transfer_assignments;

-- DROP VIEW vw_transfer_assignments;
CREATE OR REPLACE VIEW vw_transfer_assignments AS 
 SELECT drivers.driver_id, drivers.driver_name, drivers.mobile_number, 
    drivers.is_backup, drivers.air_agent_code, cars.car_type_id, cars.registration_number, 
    car_types.car_type_name, car_types.car_type_code, transfers.transfer_id, 
    transfers.record_locator, transfers.customer_code, transfers.customer_name, 
    transfers.currency_id, transfers.agreed_amount, transfers.booking_location, 
    transfers.booking_date, transfers.payment_details, transfers.reference_data, 
    transfers.pax_no, transfers.transfer_cancelled, transfers.is_group, 
    transfers.create_source, passangers.group_contact, passangers.group_member, 
    passangers.passanger_id, passangers.passanger_name, 
    passangers.passanger_mobile, passangers.passanger_email, 
    passangers.pickup_time, passangers.pickup, passangers.dropoff, 
    passangers.other_preference, passangers.amount, passangers.processed, 
    passangers.pax_cancelled, passangers.pickup_date, passangers.tab, 
    transfer_assignments.transfer_assignment_id, transfer_assignments.car_id, 
    transfer_assignments.confirmation_code, transfer_assignments.kms_out, 
    transfer_assignments.kms_in, transfer_assignments.time_out, 
    transfer_assignments.time_in, transfer_assignments.no_show, 
    transfer_assignments.no_show_reason, transfer_assignments.closed, 
    transfer_assignments.last_update, transfer_assignments.cancelled, 
    transfer_assignments.cancel_reason, transfer_flights.transfer_flight_id, 
    transfer_flights.start_time, transfer_flights.end_time, 
    transfer_flights.flight_date, transfer_flights.start_airport, 
    transfer_flights.end_airport, transfer_flights.airline, 
    transfer_flights.flight_num, transfer_flights.create_key
   FROM transfer_assignments
   JOIN drivers ON transfer_assignments.driver_id = drivers.driver_id
   JOIN cars ON cars.car_id = transfer_assignments.car_id
   JOIN car_types ON car_types.car_type_id = cars.car_type_id
   JOIN passangers ON transfer_assignments.passanger_id = passangers.passanger_id
   JOIN transfers ON passangers.transfer_id = transfers.transfer_id
   LEFT JOIN transfer_flights ON transfer_flights.transfer_id = passangers.transfer_id
  WHERE transfer_flights.tab IS NULL OR transfer_flights.tab = passangers.tab;



-- DROP VIEW vw_transfer_assignments_create;
CREATE OR REPLACE VIEW vw_transfer_assignments_create AS 
 SELECT drivers.driver_id, drivers.driver_name, drivers.mobile_number, drivers.is_backup,
    cars.car_type_id, cars.registration_number, car_types.car_type_name, 
    car_types.car_type_code, passangers.passanger_id, passangers.passanger_name, 
    passangers.transfer_id, passangers.passanger_mobile, 
    passangers.passanger_email, passangers.pickup_time, passangers.pickup, 
    passangers.dropoff, passangers.other_preference, passangers.amount, 
    passangers.processed, passangers.pickup_date, passangers.tab, 
    transfer_assignments.transfer_assignment_id, transfer_assignments.car_id, 
    transfer_assignments.kms_out, transfer_assignments.kms_in, 
    transfer_assignments.time_out, transfer_assignments.time_in, 
    transfer_assignments.no_show, transfer_assignments.no_show_reason, 
    transfer_assignments.closed, transfer_assignments.last_update, 
    transfer_assignments.cancelled, transfer_assignments.cancel_reason
   FROM transfer_assignments
   JOIN drivers ON transfer_assignments.driver_id = drivers.driver_id
   JOIN cars ON cars.car_id = transfer_assignments.car_id
   JOIN car_types ON car_types.car_type_id = cars.car_type_id
   JOIN passangers ON transfer_assignments.passanger_id = passangers.passanger_id;


DROP VIEW vw_transfer_assignments_etravel;
CREATE OR REPLACE VIEW vw_transfer_assignments_etravel AS 
 SELECT 
transfers.transfer_id::text || '/' || passangers.passanger_id || '/' || transfer_assignments.transfer_assignment_id AS voucher_ref, 

 drivers.driver_id, drivers.driver_name,
    drivers.is_backup, drivers.air_agent_code,
    car_types.car_type_code, 
    transfers.transfer_id, transfers.record_locator, transfers.customer_code, 
    transfers.customer_name, transfers.currency_id, transfers.agreed_amount, 
    transfers.booking_location, transfers.booking_date, 
    transfers.payment_details, transfers.reference_data, transfers.pax_no, 
    transfers.transfer_cancelled, transfers.is_group, transfers.create_source, 
    passangers.group_contact, passangers.group_member, passangers.passanger_id, 
    passangers.passanger_name, passangers.passanger_mobile, 
    passangers.passanger_email, passangers.pickup_time, passangers.pickup, 
    passangers.dropoff, passangers.other_preference, passangers.amount, 
    passangers.processed, passangers.pax_cancelled, passangers.pickup_date, 
    passangers.tab, transfer_assignments.transfer_assignment_id, 
    transfer_assignments.car_id, transfer_assignments.confirmation_code, 
    transfer_assignments.kms_out, transfer_assignments.kms_in, 
    transfer_assignments.time_out, transfer_assignments.time_in, 
    transfer_assignments.no_show, transfer_assignments.no_show_reason, 
    transfer_assignments.closed, transfer_assignments.last_update, 
    transfer_assignments.cancelled, transfer_assignments.cancel_reason, 
    transfer_flights.transfer_flight_id, transfer_flights.start_time, 
    transfer_flights.end_time, transfer_flights.flight_date, 
    transfer_flights.start_airport, transfer_flights.end_airport, 
    transfer_flights.airline, transfer_flights.flight_num, 
    transfer_flights.create_key
   FROM transfer_assignments
   JOIN drivers ON transfer_assignments.driver_id = drivers.driver_id
   JOIN cars ON cars.car_id = transfer_assignments.car_id
   JOIN car_types ON car_types.car_type_id = cars.car_type_id
   JOIN passangers ON transfer_assignments.passanger_id = passangers.passanger_id
   JOIN transfers ON passangers.transfer_id = transfers.transfer_id
   LEFT JOIN transfer_flights ON transfer_flights.transfer_id = passangers.transfer_id
  WHERE transfer_flights.tab IS NULL OR transfer_flights.tab = passangers.tab;










CREATE OR REPLACE FUNCTION sendMessage( v_sms_number varchar(20), v_message varchar(225)) RETURNS varchar(120) AS $$
DECLARE

BEGIN
    -- INSERT INTO sms_i(org_id,folder_id,  sms_origin,sms_number,number_error,message_ready, retries, serviceid, sprevpassword,correlator, sprevid, spid,sent, message)
       --  VALUES (1,0,'Dewcis',v_sms_number,false, true, 0, '6015202000075606','Abcd1234', '3540809','Etiqet','601520',false,v_message);

    INSERT INTO sms( org_id,folder_id,  sms_origin,sms_number,number_error,message_ready, retries, serviceid, sprevpassword,correlator, sprevid, spid,sent, message)
        VALUES (0,0,'Dewcis',v_sms_number,false, true, 0, '6015202000075606','Abcd1234', '3540809','Etiqet','601520',false,v_message);

    return 'Message Sent'::text;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION ins_transfers() RETURNS trigger AS $$
DECLARE
BEGIN

    IF(NEW.booking_date = '' OR NEW.booking_date is null) THEN
        NEW.booking_date :=  CURRENT_TIMESTAMP;
    END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_transfers BEFORE INSERT ON transfers
    FOR EACH ROW EXECUTE PROCEDURE ins_transfers();


CREATE OR REPLACE FUNCTION upd_transfers() RETURNS trigger AS $$
DECLARE
BEGIN
    UPDATE passangers SET pax_cancelled = NEW.transfer_cancelled WHERE transfer_id =  NEW.transfer_id;
	RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_transfers AFTER UPDATE ON transfers
    FOR EACH ROW EXECUTE PROCEDURE upd_transfers();



CREATE OR REPLACE FUNCTION upd_passangers() RETURNS trigger AS $$
DECLARE
BEGIN

    UPDATE transfer_assignments SET cancelled = NEW.pax_cancelled WHERE passanger_id =  NEW.passanger_id;
	RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_passangers AFTER UPDATE ON passangers
    FOR EACH ROW EXECUTE PROCEDURE upd_passangers();





/* check null date */

CREATE OR REPLACE FUNCTION ins_drivers() RETURNS trigger AS $$
DECLARE
	v_pin              varchar(4);
    v_send_res         text;
    v_message          text;
BEGIN

    SELECT substring(random()::text from 3 for 4) INTO v_pin;

    NEW.driver_pin := md5(v_pin);

    v_message := (E'Hello '::text || NEW.driver_name || E'.\nYour Pin is '::text || v_pin || E'.\nBunson Transport Department'::text)::text;
    v_send_res := sendMessage(NEW.mobile_number, v_message);

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_drivers BEFORE INSERT ON drivers
    FOR EACH ROW EXECUTE PROCEDURE ins_drivers();


/*check for past 4pm*/

CREATE OR REPLACE FUNCTION ins_passangers() RETURNS trigger AS $$
DECLARE
    v_today             timestamp;
    v_message           text;
    v_send_res         text;
BEGIN
    v_today := CURRENT_TIMESTAMP;
    
    IF((NEW.pickup_date = v_today::date) AND (v_today::time > '1600'::time )) THEN
        v_message := 'An Emergency Transfer Has Been Issued. '|| E'\nPick ' 
        || NEW.passanger_name || E'.\nFrom: ' || NEW.pickup || E'\nTo: ' 
        || NEW.dropoff || E'\nAt: ' || NEW.pickup_time  || 'HRS'
                  || E'\nTel: ' || NEW.passanger_mobile;
                  
        --v_send_res := sendMessage('254725987342', v_message);
        v_send_res := sendMessage('254701772272', v_message);
        v_send_res := sendMessage('254738772272', v_message);

    END IF;
    -- CREATE EMAIL
    INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, 
            emailed, narrative)
    VALUES (1, 0, NEW.passanger_id, 'passangers', 
            false, 'Email Created For ' || NEW.passanger_name::text);

    RETURN NULL;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER ins_passangers AFTER INSERT ON passangers
    FOR EACH ROW EXECUTE PROCEDURE ins_passangers();



CREATE OR REPLACE FUNCTION aft_ins_transfers() RETURNS trigger AS $$
DECLARE
    
BEGIN
    -- CREATE EMAIL
    INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, 
            emailed, narrative)
    VALUES (1, 0, NEW.transfer_id, 'transfers', 
            false, 'Email Created For ' || NEW.customer_name || 'Transfer Id : '::text || NEW.transfer_id || 'Record Locator : '::text || NEW.record_locator::text);

    RETURN NULL;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER aft_ins_transfers AFTER INSERT ON transfers
    FOR EACH ROW EXECUTE PROCEDURE aft_ins_transfers();




/* Send message to driver and client when assignment is done*/
CREATE OR REPLACE FUNCTION ins_transfer_assignments() RETURNS trigger AS $$
DECLARE
    v_send_res         text;
    v_message          text;
    v_client_sms       text;
    v_rec              record;
    v_rec_flight       record;
    v_flight_text      text;
    v_flight_count     integer;
BEGIN
    v_flight_text := '';

    SELECT COUNT(transfer_flights.transfer_flight_id) INTO v_flight_count
	FROM transfer_assignments
	INNER JOIN passangers ON passangers.passanger_id = transfer_assignments.passanger_id
	INNER JOIN transfer_flights ON transfer_flights.transfer_id = passangers.transfer_id
	WHERE transfer_assignments.transfer_assignment_id = NEW.transfer_assignment_id;


    IF(v_flight_count = 0) THEN
        SELECT * INTO v_rec FROM vw_transfer_assignments_create  WHERE transfer_assignment_id = NEW.transfer_assignment_id;

    ELSE
        SELECT transfer_assignment_id, driver_name, mobile_number, passanger_name, passanger_mobile, pickup, dropoff, pickup_time,
        start_time,end_time, flight_date, start_airport, end_airport, airline,flight_num
        INTO v_rec FROM vw_transfer_assignments WHERE transfer_assignment_id = NEW.transfer_assignment_id;

        v_flight_text := E'\nFlight Date : ' || v_rec.flight_date
                    || E'\nDep Time : ' || v_rec.start_time   || 'HRS'
                    || E'\nAirport : ' || v_rec.start_airport
                    || E'\nFlight No.: ' || v_rec.airline || ' '::text || v_rec.flight_num;

    END IF;

    v_message := (E'Hello '::text || v_rec.driver_name || E'\nYou Have a new Transfer Ref : '
                  || v_rec.transfer_assignment_id
                  || E'\nPick ' || v_rec.passanger_name 
                  || E'.\nFrom: ' || v_rec.pickup 
                  || E'\nTo: ' || v_rec.dropoff 
                  || E'\nAt: ' || v_rec.pickup_time  || 'HRS'
                  || E'\nTel: ' || v_rec.passanger_mobile || v_flight_text
                  || E'\nBunson Transport Department'::text
                  || E'\nhttp://d.dc.co.ke/bunson/?mobile=' || v_rec.mobile_number || '&reference=' || v_rec.transfer_assignment_id)::text;

    v_client_sms := (E'Hello '::text || v_rec.passanger_name
                    || E'\nOur Driver '::text || v_rec.driver_name || '('::text || v_rec.mobile_number || ')'::text
                    || E'\nWill Pick You ' || E'.\nFrom: ' 
                    || v_rec.pickup 
                    || E'\nTo: ' || v_rec.dropoff 
                    || E'\nAt: ' || v_rec.pickup_time  || 'HRS'
                    || v_flight_text
                    || E'\nBunson Transport Department'::text);

    v_send_res := sendMessage(v_rec.mobile_number, v_message);
    v_send_res := sendMessage(v_rec.passanger_mobile, v_client_sms);

    UPDATE passangers SET processed = true WHERE passanger_id = NEW.passanger_id;
    
    

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_transfer_assignments AFTER INSERT ON transfer_assignments
    FOR EACH ROW EXECUTE PROCEDURE ins_transfer_assignments();


CREATE OR REPLACE FUNCTION ins_transfer_flights() RETURNS trigger AS $$
DECLARE
    v_transfer_id   integer;
    v_tab           integer;
BEGIN

    IF(NEW.create_key = 2) THEN
        SELECT transfer_id,tab INTO v_transfer_id,  v_tab FROM passangers WHERE passanger_id = NEW.transfer_id;
        NEW.transfer_id := v_transfer_id;
        NEW.tab := v_tab;
        --RAISE EXCEPTION 'v_transfer_id : % , v_tab : %', v_transfer_id,v_tab;
    END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- DROP TRIGGER ins_transfer_flights ON transfer_flights;
CREATE TRIGGER ins_transfer_flights BEFORE INSERT ON transfer_flights
    FOR EACH ROW EXECUTE PROCEDURE ins_transfer_flights();

/*delete from transfer_flights ;
delete from transfer_assignments ;
delete from passangers ;
delete from sms;
delete from transfers;
*/
