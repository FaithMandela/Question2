
CREATE TABLE group_rates   (
	group_rate_id 		        	serial PRIMARY KEY,
	org_id							integer references orgs,
	rate_plan_id 		    		integer references rate_plan,
	days 		      				integer,
	rate 	    					real,
	is_adult 						boolean default true,
	description						text
	);
CREATE INDEX group_rates_rate_plan_id ON group_rates(rate_plan_id);
CREATE INDEX orgs_org_id ON group_rates(org_id);

CREATE OR REPLACE VIEW vw_group_rates AS
SELECT group_rates.group_rate_id, group_rates.org_id, group_rates.rate_plan_id, group_rates.days, group_rates.rate,
 group_rates.description,  rate_plan.rate_plan_name, group_rates.is_adult
FROM group_rates INNER JOIN rate_plan ON group_rates.rate_plan_id = rate_plan.rate_plan_id ;

ALTER table passengers add column group_rate_id integer references group_rates;
ALTER table passengers add column group_name  character varying(100);

CREATE TABLE group_benefits (
  benefit_id 		    		serial PRIMARY KEY,
  group_rate_id 				integer references group_rates,
  benefit_type_id 			integer references benefit_types,
  individual 		    		text,
  others 		        	text
);
CREATE INDEX group_benefits_benefit_type_id ON group_benefits(benefit_type_id);
CREATE INDEX group_benefits_group_rate_id ON group_benefits(group_rate_id);


CREATE OR REPLACE VIEW vw_group_benefits AS
SELECT group_benefits.benefit_type_id,  benefit_types.benefit_type_name,
  group_benefits.group_rate_id,  vw_group_rates.rate_plan_name,  group_benefits.benefit_id,
  group_benefits.individual,  group_benefits.others, benefit_types.benefit_section
 FROM group_benefits
   JOIN benefit_types ON group_benefits.benefit_type_id = benefit_types.benefit_type_id
   JOIN vw_group_rates ON group_benefits.group_rate_id = vw_group_rates.group_rate_id;



   CREATE OR REPLACE VIEW vw_group_passengers AS
   SELECT vw_entitys.org_id,  vw_entitys.org_name, vw_group_rates.rate_plan_id,  vw_group_rates.group_rate_id,
   vw_group_rates.rate_plan_name, passengers.days_from, passengers.days_to, passengers.approved,
   passengers.entity_id, passengers.countries, passengers.passenger_id, passengers.passenger_name, passengers.passenger_mobile, passengers.passenger_email,
   passengers.passenger_age, passengers.days_covered, passengers.nok_name, passengers.nok_mobile, passengers.passenger_id_no, passengers.passport_num,
   passengers.cover_amount, passengers.totalamount_covered, passengers.is_north_america, passengers.details, passengers.passenger_dob,
   passengers.policy_number, vw_entitys.entity_name, passengers.destown, sys_countrys.sys_country_name, passengers.approved_date, passengers.pin_no,
   passengers.reason_for_travel, passengers.departure_country, vw_entitys.function_role, vw_entitys.is_active,passengers.customer_code,passengers.customer_name,
   passengers.incountry,passengers.kesamount, passengers.policy_holder_fund ,passengers.stamp_duty,passengers.training_levy,passengers.pnrno,passengers.group_name
   FROM passengers
    JOIN vw_group_rates ON passengers.group_rate_id = vw_group_rates.group_rate_id
    JOIN vw_entitys ON passengers.entity_id = vw_entitys.entity_id
    JOIN sys_countrys ON passengers.sys_country_id = sys_countrys.sys_country_id;


 CREATE OR REPLACE FUNCTION get_group_benefit_section_a(integer) RETURNS text AS $$
    SELECT individual AS result from vw_group_benefits WHERE group_rate_id = $1 AND benefit_section IN('1A');
$$LANGUAGE SQL;
CREATE OR REPLACE FUNCTION get_group_benefit_section_b(integer) RETURNS text AS $$
    SELECT individual AS result from vw_group_benefits WHERE group_rate_id =  $1 AND benefit_section IN('1C');
$$LANGUAGE SQL;
