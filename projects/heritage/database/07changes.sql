CREATE OR REPLACE VIEW vw_allpassengers AS
SELECT a.org_id,  a.org_name, a.rate_type_id,a.rate_plan_id, a.rate_category_name,
	a.rate_id,a.rate_plan_name, a.standard_rate, a.north_america_rate,a.days_from,  a.days_to,
	a.approved, a.entity_id, a.countries, a.passenger_id,  a.passenger_name,  a.passenger_mobile,
	a.passenger_email,  a.passenger_age,  a.days_covered,  a.nok_name, a.nok_mobile,  a.passenger_id_no,
	a.passport_num,  round(a.cover_amount::DECIMAL,2)::real as cover_amount,  round(a.totalAmount_covered::DECIMAL,2)::real as totalAmount_covered,  a.is_north_america,  a.details,  a.passenger_dob,
	a.policy_number,  a.entity_name,  a.destown,  a.sys_country_name, a.approved_date,
	a.pin_no, a.reason_for_travel,  a.departure_country, a.function_role, a.is_active
FROM ((
	SELECT org_id, org_name, rate_type_id, rate_plan_id, rate_category_name, rate_id,
  rate_plan_name, standard_rate, north_america_rate, days_from, days_to, approved,
  entity_id, countries, passenger_id, passenger_name, passenger_mobile, passenger_email,
  passenger_age, days_covered, nok_name, nok_mobile, passenger_id_no, passport_num,
  cover_amount, totalamount_covered, is_north_america,details, passenger_dob,
  policy_number, entity_name, destown, sys_country_name, approved_date, pin_no,
  reason_for_travel, departure_country, function_role, is_active,customer_code,customer_name,
  incountry
	FROM vw_passengers  )
	UNION ALL
	(SELECT org_id,  org_name, rate_type_id, rate_plan_id, corporate_rate_category_name as rate_category_name, corporate_rate_id as rate_id,
 rate_plan_name, standard_rate, north_america_rate, days_from, days_to, approved,
 entity_id, countries, passenger_id, passenger_name, passenger_mobile, passenger_email,
 passenger_age, days_covered, nok_name, nok_mobile, passenger_id_no, passport_num,
 cover_amount, totalamount_covered, is_north_america, details, passenger_dob,
 policy_number, entity_name, destown, sys_country_name, approved_date, pin_no,
 reason_for_travel, departure_country, function_role, is_active,customer_code,customer_name,
 incountry
	FROM  vw_corporate_passengers )
)a order by passenger_id DESC;
