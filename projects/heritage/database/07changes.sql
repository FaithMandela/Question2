ALTER TABLE passengers ADD COLUMN pnrno	varchar(20);


CREATE OR REPLACE VIEW vw_passengers AS
SELECT vw_entitys.org_id,  vw_entitys.org_name, vw_rates.rate_type_id, vw_rates.rate_plan_id, vw_rates.rate_category_name, vw_rates.rate_id,
  vw_rates.rate_plan_name, vw_rates.standard_rate, vw_rates.north_america_rate, passengers.days_from, passengers.days_to, passengers.approved,
  passengers.entity_id, passengers.countries, passengers.passenger_id, passengers.passenger_name, passengers.passenger_mobile, passengers.passenger_email,
  passengers.passenger_age, passengers.days_covered, passengers.nok_name, passengers.nok_mobile, passengers.passenger_id_no, passengers.passport_num,
  passengers.cover_amount, passengers.totalamount_covered, passengers.is_north_america, passengers.details, passengers.passenger_dob,
  passengers.policy_number, vw_entitys.entity_name, passengers.destown, sys_countrys.sys_country_name, passengers.approved_date, passengers.pin_no,
  passengers.reason_for_travel, passengers.departure_country, vw_entitys.function_role, vw_entitys.is_active,passengers.customer_code,passengers.customer_name,
  passengers.incountry,passengers.pnrno
 FROM passengers
   JOIN vw_rates ON passengers.rate_id = vw_rates.rate_id
   JOIN vw_entitys ON passengers.entity_id = vw_entitys.entity_id
   JOIN sys_countrys ON passengers.sys_country_id = sys_countrys.sys_country_id;

   CREATE OR REPLACE VIEW vw_corporate_passengers AS
   SELECT vw_entitys.org_id,  vw_entitys.org_name, vw_corporate_rates.rate_type_id, vw_corporate_rates.rate_plan_id, vw_corporate_rates.corporate_rate_category_name, vw_corporate_rates.corporate_rate_id,
    vw_corporate_rates.rate_plan_name, vw_corporate_rates.standard_rate, vw_corporate_rates.north_america_rate, passengers.days_from, passengers.days_to, passengers.approved,
    passengers.entity_id, passengers.countries, passengers.passenger_id, passengers.passenger_name, passengers.passenger_mobile, passengers.passenger_email,
    passengers.passenger_age, passengers.days_covered, passengers.nok_name, passengers.nok_mobile, passengers.passenger_id_no, passengers.passport_num,
    passengers.cover_amount, passengers.totalamount_covered, passengers.is_north_america, passengers.details, passengers.passenger_dob,
    passengers.policy_number, vw_entitys.entity_name, passengers.destown, sys_countrys.sys_country_name, passengers.approved_date, passengers.pin_no,
    passengers.reason_for_travel, passengers.departure_country, vw_entitys.function_role, vw_entitys.is_active,passengers.customer_code,passengers.customer_name,
    passengers.incountry,passengers.pnrno
   FROM passengers
     JOIN vw_corporate_rates ON passengers.corporate_rate_id = vw_corporate_rates.corporate_rate_id
     JOIN vw_entitys ON passengers.entity_id = vw_entitys.entity_id
     JOIN sys_countrys ON passengers.sys_country_id = sys_countrys.sys_country_id;


CREATE OR REPLACE VIEW vw_allpassengers AS
SELECT a.org_id,  a.org_name, a.rate_type_id,a.rate_plan_id, a.rate_category_name,
	a.rate_id,a.rate_plan_name, a.standard_rate, a.north_america_rate,a.days_from,  a.days_to,
	a.approved, a.entity_id, a.countries, a.passenger_id,  a.passenger_name,  a.passenger_mobile,
	a.passenger_email,  a.passenger_age,  a.days_covered,  a.nok_name, a.nok_mobile,  a.passenger_id_no,
	a.passport_num,  round(a.cover_amount::DECIMAL,2)::real as cover_amount,  round(a.totalAmount_covered::DECIMAL,2)::real as totalAmount_covered,  a.is_north_america,  a.details,  a.passenger_dob,
	a.policy_number,  a.entity_name,  a.destown,  a.sys_country_name, a.approved_date,
	a.pin_no, a.reason_for_travel,  a.departure_country, a.function_role, a.is_active,a.pnrno
FROM ((
	SELECT org_id, org_name, rate_type_id, rate_plan_id, rate_category_name, rate_id,
  rate_plan_name, standard_rate, north_america_rate, days_from, days_to, approved,
  entity_id, countries, passenger_id, passenger_name, passenger_mobile, passenger_email,
  passenger_age, days_covered, nok_name, nok_mobile, passenger_id_no, passport_num,
  cover_amount, totalamount_covered, is_north_america,details, passenger_dob,
  policy_number, entity_name, destown, sys_country_name, approved_date, pin_no,
  reason_for_travel, departure_country, function_role, is_active,customer_code,customer_name,
  incountry,pnrno
	FROM vw_passengers  )
	UNION ALL
	(SELECT org_id,  org_name, rate_type_id, rate_plan_id, corporate_rate_category_name as rate_category_name, corporate_rate_id as rate_id,
 rate_plan_name, standard_rate, north_america_rate, days_from, days_to, approved,
 entity_id, countries, passenger_id, passenger_name, passenger_mobile, passenger_email,
 passenger_age, days_covered, nok_name, nok_mobile, passenger_id_no, passport_num,
 cover_amount, totalamount_covered, is_north_america, details, passenger_dob,
 policy_number, entity_name, destown, sys_country_name, approved_date, pin_no,
 reason_for_travel, departure_country, function_role, is_active,customer_code,customer_name,
 incountry,pnrno
	FROM  vw_corporate_passengers )
)a order by passenger_id DESC;



CREATE OR REPLACE FUNCTION ins_passengers()
  RETURNS trigger AS
$BODY$
DECLARE
v_credit_limit real;
v_credit real;
BEGIN
	v_credit := 0;
	v_credit_limit := 0;
    SELECT credit_limit INTO v_credit FROM orgs WHERE org_id = NEW.org_id;
    IF(NEW.incountry IS TRUE AND NEW.customer_code IS null) THEN
        v_credit_limit := v_credit - (NEW.kesamount::real/NEW.exchange_rate::real);
    ELSE
        v_credit_limit := v_credit - NEW.totalamount_covered;
    END IF;
    --raise exception '%',v_credit_limit;
    UPDATE orgs SET credit_limit = v_credit_limit WHERE org_id = NEW.org_id;

    IF(NEW.customer_code IS null) THEN
    	INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, narrative)
    	VALUES(2, NEW.org_id, NEW.passenger_id, 'passengers','Policy Number:'||NEW.policy_number||'\n\nPassanger Name:'||NEW.passenger_name);
    ELSE
        INSERT INTO sys_emailed(sys_email_id, org_id, table_id, table_name, narrative)
    	VALUES(3, NEW.org_id, NEW.passenger_id, 'passengers','Policy Number:'||NEW.policy_number||'\n\nPassanger Name:'||NEW.passenger_name);
    END IF;

RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
