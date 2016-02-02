--DROP TABLE etravel;
CREATE TABLE etravel(
    etravel_id                      serial primary key,
    transfer_assignment_id          integer,
    ticket_airline                  varchar(10) NOT NULL,
    ticket_number                   varchar(20) NOT NULL,
    ticket_location                 varchar(10) NOT NULL,
    ticket_date                     date NOT NULL,
    ticket_currency                 varchar(10) NOT NULL,
    ticket_agent                    varchar(10) NOT NULL,
    ticket_pax_name                 varchar(75) NOT NULL,
    car_reference                   real NOT NULL,
    car_type                        varchar(10) NOT NULL,
    car_renting_location            varchar(75) NOT NULL,
    car_voucher_issued              date NOT NULL,
    car_rate                        real DEFAULT 0 NOT NULL,
    car_from_date                   date NOT NULL,
    car_to_date                     date,
    ticket_booking_clerk            varchar(10),
    ticket_destination_tax          real DEFAULT 0 NOT NULL,
    ticket_commission_amount_1      real DEFAULT 0 NOT NULL,
    ticket_discount_amount_1        real DEFAULT 0 NOT NULL,
    ts_service_1                    varchar(10) NOT NULL,
    ts_amount_1                     real DEFAULT 0 NOT NULL,
    ts_service_2                    varchar(10) NOT NULL,
    ts_amount_2                     real DEFAULT 0 NOT NULL,
    ticket_customer_1               varchar(10),
    ticket_lpo                      varchar(25),
    ticket_lpo_date                 date,
    ticket_status                   varchar(1) DEFAULT 'S' NOT NULL,
    car_remarks                     varchar(200),
    car_renting_station             varchar(50) NOT NULL,
    car_drop_station                varchar(50) NOT NULL,
    ticket_retention_charges_air    real DEFAULT 0 NOT NULL,
    ticket_retention_charges_agent  real DEFAULT 0 NOT NULL,
    ready			                boolean default false,
    picked                          boolean default false
);



-- Function: ins_transfer_assignments()

-- DROP FUNCTION ins_transfer_assignments();
CREATE OR REPLACE FUNCTION ins_transfer_assignments()
  RETURNS trigger AS
$BODY$
    DECLARE
        v_send_res         text;
        v_message          text;
        v_client_sms       text;
        v_staff_sms		text;
        v_rec              record;
        v_rec_flight       record;
        v_flight_text      text;
        v_flight_count     integer;
        v_pccson           varchar(20);
        v_staff_numbers    text;
        a_staff_numbers    text[];
    BEGIN
        v_flight_text := '';
        v_message := '';

        SELECT COUNT(transfer_flights.transfer_flight_id) INTO v_flight_count
    	FROM transfer_assignments
    	INNER JOIN passangers ON passangers.passanger_id = transfer_assignments.passanger_id
    	INNER JOIN transfer_flights ON transfer_flights.transfer_id = passangers.transfer_id
    	WHERE transfer_assignments.transfer_assignment_id = NEW.transfer_assignment_id;


        IF(v_flight_count = 0) THEN
            SELECT * INTO v_rec FROM vw_transfer_assignments  WHERE transfer_assignment_id = NEW.transfer_assignment_id;

        ELSE
            SELECT transfer_assignment_id, booking_location, driver_name, is_backup,  mobile_number, passanger_name, passanger_mobile, pickup, dropoff, pickup_date, pickup_time, customer_code, customer_name,
            start_time,end_time, flight_date, start_airport,car_type_code , end_airport, airline,flight_num, tab
            INTO v_rec FROM vw_transfer_assignments WHERE transfer_assignment_id = NEW.transfer_assignment_id;

            /*v_flight_text := E'\nFlight Date : ' || v_rec.flight_date
                        || E'\nDep Time : ' || v_rec.start_time
                        || E'\nAirport : ' || v_rec.start_airport
                        || E'\nFlight No.: ' || v_rec.airline || ' '::text || v_rec.flight_num;*/

            v_flight_text := E'\n' || v_rec.airline || ' '::text || v_rec.flight_num || ' ' || v_rec.start_airport || ' - ' || v_rec.end_airport;

        END IF;

        -- Depature driver sms

        v_message := v_rec.passanger_name || ' : ' || v_rec.passanger_mobile || ' (' || COALESCE(v_rec.customer_name, v_rec.customer_code, '') || ')'
                    || E'\nAt: ' || v_rec.pickup_time || 'HRS'
                    || E'.\nFrom: ' || v_rec.pickup
                    || E'\nTo: ' || COALESCE(v_rec.dropoff,'')
                    || E'\nDate: ' || to_char(v_rec.pickup_date, 'DD Mon YYYY')
                    || COALESCE(v_flight_text, '')
                    || E'\nCWT Transport Department'::text
                    || E'\nhttp://d.dc.co.ke/bunson/?mobile=' || v_rec.mobile_number || '&reference=' || v_rec.transfer_assignment_id;
        -- RAISE EXCEPTION 'Driver SMS :  %', v_message;
        v_send_res := sendMessage(v_rec.mobile_number, v_message);

        /* check if driver is a backup driver*/
        IF(v_rec.is_backup = true) THEN
            v_client_sms := (E'Hello '::text || v_rec.passanger_name
                        || E'\nOur Driver '::text
                        || E'\nWill Pick You ' || E'.\nFrom: ' 
                        || v_rec.pickup 
                        || E'\nTo: ' || v_rec.dropoff 
                        || E'\nAt: ' || v_rec.pickup_time || 'HRS'
                        || E'\nDate: ' || to_char(v_rec.pickup_date, 'DD Mon YYYY')
                        || E'\nCWT Transport Department'::text
                        || E'\nTel: 0701772272 / 0738772272'::text);
        ELSE
            v_client_sms := (E'Hello '::text || v_rec.passanger_name
                        || E'\nDriver '::text || v_rec.driver_name || ':'::text || v_rec.mobile_number
                        || E'\nWill Pick You '
                        || E'.\nFrom: ' || COALESCE(v_rec.pickup,'')
                        || E'\nTo: ' || COALESCE(v_rec.dropoff,'')
                        || E'\nAt: ' || COALESCE(v_rec.pickup_time,'')  || 'HRS'
                        || E'\nDate: ' || to_char(v_rec.pickup_date, 'DD Mon YYYY')
                        || E'\nCWT Transport Department'::text
                        || E'\nTel: 0701772272 / 0738772272'::text);
        END IF;


        v_send_res := sendMessage(v_rec.passanger_mobile, v_client_sms);


        /* if its arrival send message to  */
        IF(v_rec.tab = 2) THEN

            v_staff_sms := (E''::text || v_rec.passanger_name || ' '
                    || v_rec.passanger_mobile
                    || '('::text || COALESCE(v_rec.customer_name, v_rec.customer_code,'') || ')'::text
                    || E'\nArrival At ' || COALESCE(v_rec.pickup_time,'')  || 'HRS'
                    || ' On ' ::text || to_char(v_rec.pickup_date, 'DD Mon YYYY')
                    || E'\nJKIA to : ' || COALESCE(v_rec.dropoff,'')
                    || v_flight_text::text);
                    -- || E'\n'::text || v_rec.driver_name || '('::text || v_rec.mobile_number || ')'::text
                    -- || E'\nCWT Transport Department'::text
                    -- || E'\nTel: 0701772272 / 0738772272'::text);

            SELECT staff_numbers INTO v_staff_numbers FROM orgs WHERE org_id = 0;
            a_staff_numbers := regexp_split_to_array (v_staff_numbers,',');

            FOR i IN 1..array_length(a_staff_numbers,1) LOOP
        		v_send_res := sendMessage(a_staff_numbers[i], v_staff_sms);
        	END LOOP;
        END IF;

        UPDATE passangers SET processed = true WHERE passanger_id = NEW.passanger_id;


        SELECT entitys.user_name INTO v_pccson
            FROM vw_passangers
            INNER JOIN entitys ON entitys.entity_id = vw_passangers.entity_id
            WHERE vw_passangers.passanger_id = NEW.passanger_id;

        INSERT INTO etravel(transfer_assignment_id, ticket_airline, ticket_number, 
                    ticket_location, ticket_date, ticket_currency, ticket_agent, 
                    ticket_pax_name, car_reference, car_type, car_renting_location, 
                    car_voucher_issued, car_rate, car_from_date, car_to_date, ticket_booking_clerk, 
                    ticket_destination_tax, ticket_commission_amount_1, ticket_discount_amount_1, 
                    ts_service_1, ts_amount_1, ts_service_2, ts_amount_2, ticket_customer_1, 
                    ticket_status, car_remarks, car_renting_station, 
                    car_drop_station,
                    ready, picked)
            VALUES (v_rec.transfer_assignment_id, COALESCE(v_rec.airline, 'N/A'), '00', 
                    v_rec.booking_location, v_rec.pickup_date, '00', '00', 
                    v_rec.passanger_name, 0, v_rec.car_type_code, v_rec.booking_location, 
                    CURRENT_TIMESTAMP::date, 0, v_rec.pickup_date, v_rec.pickup_date, v_pccson, 
                    0, 0, 0, 
                    0, 0, 0, 0, v_rec.customer_code, 
                    'S', '00', v_rec.pickup, 
                    v_rec.dropoff,
                    true, false);

    	RETURN NULL;
    END;
    $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ins_transfer_assignments()
  OWNER TO postgres;