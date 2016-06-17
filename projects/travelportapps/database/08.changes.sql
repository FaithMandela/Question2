
DROP VIEW vw_policy_members;
DROP VIEW vw_passengers;
CREATE OR REPLACE VIEW vw_passengers AS
SELECT vw_entitys.org_id,  vw_entitys.org_name, vw_rates.rate_type_id, vw_rates.rate_plan_id, vw_rates.rate_category_name,
  vw_rates.rate_id, vw_rates.rate_plan_name, vw_rates.standard_rate, vw_rates.north_america_rate,
   passengers.days_from,  passengers.days_to,  passengers.corporate_rate_id,
   passengers.approved,  passengers.entity_id,
  passengers.countries,  passengers.passenger_id,  passengers.passenger_name,  passengers.passenger_mobile,
  passengers.passenger_email,  passengers.passenger_age,  passengers.days_covered,  passengers.nok_name,
  passengers.nok_mobile,  passengers.passenger_id_no,  passengers.nok_national_id,  passengers.cover_amount,
  passengers.totalAmount_covered,  passengers.is_north_america,  passengers.details,  passengers.passenger_dob,
  passengers.policy_number,  vw_entitys.entity_name,  passengers.destown,  sys_countrys.sys_country_name,
  passengers.approved_date,  passengers.corporate_id,  passengers.pin_no, passengers.reason_for_travel,
  passengers.departure_country, vw_entitys.entity_role, vw_entitys.function_role, vw_entitys.is_active
 FROM passengers
   JOIN vw_rates ON passengers.rate_id = vw_rates.rate_id
   JOIN vw_entitys ON passengers.entity_id = vw_entitys.entity_id
   JOIN sys_countrys ON passengers.sys_country_id = sys_countrys.sys_country_id;

   CREATE OR REPLACE VIEW vw_policy_members AS
SELECT
    p.policy_member_id, p.passenger_id, p.org_id, p.entity_id, p.member_name, p.passport_number, p.pin_number,
    p.phone_number,  p.primary_email, p.rate_id, p.amount_covered, p.totalamount_covered, p.age,
    p.passenger_dob, a.countries,a.policy_number, a.destown, a.sys_country_name, a.reason_for_travel,
    a.departure_country, a.entity_name, a.days_from, a.days_to, a.rate_type_id, a.approved_date
    FROM  policy_members p
    JOIN vw_passengers a ON p.passenger_id = a.passenger_id ;

    CREATE OR REPLACE VIEW vw_app_subscriptions AS
 SELECT vw_orgs.org_id,
    apps_subscriptions.app_subscriptions_id,
    vw_orgs.org_name,
    apps_list.descriptions,
    apps_list.app_name,
    apps_list.apps_list_id
   FROM apps_subscriptions
     JOIN apps_list ON apps_subscriptions.apps_list_id = apps_list.apps_list_id
     JOIN vw_orgs ON apps_subscriptions.org_id = vw_orgs.org_id;
