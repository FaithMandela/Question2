
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
