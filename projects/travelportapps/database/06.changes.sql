ALTER TABLE passengers ADD COLUMN relationship character varying(120);
ALTER TABLE passengers ADD COLUMN id_no character varying(120);
ALTER TABLE passengers ADD COLUMN address text;

ALTER TABLE passengers ADD COLUMN policy_number character varying(50);
DROP view vw_passengers;
CREATE OR REPLACE VIEW vw_passengers AS
SELECT orgs.org_id,
  orgs.org_name,
  vw_rates.rate_type_id,
  vw_rates.rate_type_name,
  vw_rate_types.rate_category_name,
  vw_rates.rate_id,
  passengers.days_from,
  passengers.days_to,
  passengers.corporate_rate_id,
  vw_rates.standard_rate,
  vw_rates.north_america_rate,
  passengers.approved,
  passengers.entity_id,
  passengers.countries,
  passengers.passenger_id,
  passengers.passenger_name,
  passengers.passenger_mobile,
  passengers.passenger_email,
  passengers.passenger_age,
  passengers.days_covered,
  passengers.nok_name,
  passengers.nok_mobile,
  passengers.passenger_id_no,
  passengers.nok_national_id,
  passengers.cover_amount,
  passengers.totalAmount_covered,
  passengers.is_north_america,
  passengers.details,
  passengers.passenger_dob,
  passengers.policy_number,
  entitys.entity_name,
  passengers.destown,
  sys_countrys.sys_country_name,
  passengers.approved_date,
  passengers.corporate_id,
  passengers.pin_no
 FROM passengers
   JOIN orgs ON passengers.org_id = orgs.org_id
   JOIN vw_rates ON passengers.rate_id = vw_rates.rate_id
   JOIN vw_rate_types ON vw_rates.rate_type_id = vw_rate_types.rate_type_id
   JOIN entitys ON passengers.entity_id = entitys.entity_id
   JOIN sys_countrys ON passengers.sys_country_id = sys_countrys.sys_country_id;
