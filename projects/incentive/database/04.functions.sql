CREATE OR REPLACE FUNCTION generate_points(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec						RECORD;
	v_period				varchar(7);
    v_entity_id             integer;
    v_client_code			varchar(7);
	v_loyalty_date			varchar(7);
	v_period_id				integer;
    v_rates                 real;
	v_isreturn		        boolean;
    v_points                real;
	v_refunds               real;
    v_points_amount         real;
	msg 					varchar(120);
	v_notAfrica				integer;
	v_eastAfrica			integer;
	v_restOfAfrica			integer;
	v_int_code			varchar(2);
	v_isRefund			boolean;
	v_refund_str			varchar(10);
	v_invoice_number	varchar(20);

BEGIN

    v_period_id = $1::integer;
    v_isreturn := true;
    SELECT to_char(start_date, 'mmyyyy') INTO v_loyalty_date
    FROM periods WHERE period_id = v_period_id AND closed = false;
    IF(v_loyalty_date IS NULL)THEN RAISE EXCEPTION 'Period is closed'; END IF;

    SELECT point_value INTO v_rates FROM points_value;

    FOR rec IN SELECT *,(SELECT sum(case b when (string_to_array(loy_routing,'-'))[1] then 1 else 0 end) FROM unnest(string_to_array(loy_routing,'-')) as dt(b)) as trues	FROM ora_loyalty WHERE (to_char(loy_date, 'mmyyyy') = v_loyalty_date) LOOP
        v_isreturn := false;
		v_isRefund := false;
		v_invoice_number := null;
		IF(rec.trues > 1)THEN
            v_isreturn := true;
        END IF;
		v_refund_str :=regexp_replace(rec.loy_doc_number, '[^a-zA-Z]+', '');
		IF(v_refund_str = 'RTIN')THEN
			v_isRefund := TRUE;
		END IF;

        SELECT entity_id, client_code INTO v_entity_id,v_client_code FROM entitys WHERE client_code = rec.loy_cust_code;
        IF(v_entity_id is not null) THEN

            IF(rec.loy_loc_int = 'L')THEN
                SELECT case when rec.trues > 1 then isreturn else one_way end as points INTO v_points FROM points_scaling WHERE code = 'L';
                v_points_amount := v_rates * v_points;
				v_refunds := 0;
				IF(v_isRefund)THEN
					v_points_amount := -(v_rates * v_points);
					v_points := -v_points;

				END IF;
				SELECT invoice_number INTO v_invoice_number FROM loyalty_points WHERE invoice_number = rec.loy_doc_number;
				IF(v_invoice_number is null)THEN
	                INSERT INTO loyalty_points(org_id, entity_id, period_id, point_date,amount, points, points_amount, refunds,
	                bonus, sectors, ticket_number, local_inter, client_code, loyalty_curr,invoice_number, is_return)
	                VALUES (0, v_entity_id, v_period_id, rec.loy_date, v_rates, v_points, v_points_amount, v_refunds,
	                0, rec.loy_routing, rec.loy_serv_number, rec.loy_loc_int, rec.loy_cust_code, rec.loy_currency,
	                rec.loy_doc_number, v_isreturn);
				END IF;
            END IF;

            IF(rec.loy_loc_int = 'I')THEN


				SELECT count(vw_city_codes.city_code)AS isNotEastAfrica INTO v_restOfAfrica FROM vw_city_codes
				WHERE vw_city_codes.city_code = ANY(string_to_array(rec.loy_routing,'-'))
				AND sys_country_id NOT IN('KE','UG','TZ','RW','BI') AND sys_continent_id ='AF';
				SELECT count(vw_city_codes.city_code)AS isEastAfrica INTO v_eastAfrica FROM vw_city_codes
				WHERE vw_city_codes.city_code = ANY(string_to_array(rec.loy_routing,'-'))
				AND sys_country_id IN('KE','UG','TZ','RW','BI') AND sys_continent_id ='AF';

				SELECT count(vw_city_codes.city_code)AS isEastAfrica INTO v_notAfrica FROM vw_city_codes
				WHERE vw_city_codes.city_code = ANY(string_to_array(rec.loy_routing,'-'))
				AND sys_continent_id !='AF';

				IF(v_restOfAfrica > 0)THEN
					v_int_code := 'RR';
				END IF;
				IF(v_eastAfrica > 0)THEN
					v_int_code := 'RE';
				END IF;
				IF(v_notAfrica > 0)THEN
					v_int_code := 'IB';
					IF(rec.loy_class_desc = 'ECONOMY')THEN
						v_int_code := 'IE';
					END IF;

				END IF;



                SELECT case when rec.trues > 1 then isreturn else one_way end as points INTO v_points FROM points_scaling WHERE code = v_int_code;
				v_points_amount := v_rates * v_points;
				v_refunds := 0;
				IF(v_isRefund)THEN
					v_points_amount := -(v_rates * v_points);
					v_points := -v_points;

				END IF;
				SELECT invoice_number INTO v_invoice_number FROM loyalty_points WHERE invoice_number = rec.loy_doc_number;
				IF(v_invoice_number is null)THEN
					INSERT INTO loyalty_points(org_id, entity_id, period_id, point_date,amount, points, points_amount, refunds,
					bonus, sectors, ticket_number, local_inter, client_code, loyalty_curr,invoice_number, is_return)
					VALUES (0, v_entity_id, v_period_id, rec.loy_date, v_rates, v_points, v_points_amount, v_refunds,
					0, rec.loy_routing, rec.loy_serv_number, rec.loy_loc_int, rec.loy_cust_code, rec.loy_currency,
					rec.loy_doc_number, v_isreturn);
				END IF;

            END IF;
        END IF;


		--UPDATE loyalty_points SET bonus = v_bonus WHERE loyalty_points_id = rec.loyalty_points_id;

	END LOOP;

    msg := 'Points computed';
    RETURN msg;

END;
$$ LANGUAGE plpgsql;
