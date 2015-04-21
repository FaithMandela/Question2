ALTER TABLE pay_scales ADD 	currency_id				integer references currency;
CREATE INDEX pay_scales_currency_id ON pay_scales(currency_id);
UPDATE pay_scales SET currency_id = 1;

CREATE TABLE vw_pay_scales AS
	SELECT currency.currency_id, currency.currency_name, currency.currency_symbol,
		pay_scales.org_id, pay_scales.pay_scale_id, pay_scales.pay_scale_name,
		pay_scales.min_pay, pay_scales.max_pay, pay_scales.details
	FROM pay_scales INNER JOIN currency ON pay_scales.currency_id = currency.currency_id;



CREATE TABLE pay_scale_steps (
	pay_scale_step_id		serial primary key,
	pay_scale_id			integer references pay_scales,
	org_id					integer references orgs,
	pay_step				integer not null,
	pay_amount				real not null
);
CREATE INDEX pay_scale_steps_pay_scale_id ON pay_scale_steps(pay_scale_id);
CREATE INDEX pay_scale_steps_org_id ON pay_scale_steps(org_id);


CREATE VIEW vw_pay_scale_steps AS
	SELECT currency.currency_id, currency.currency_name, currency.currency_symbol,
		pay_scales.pay_scale_id, pay_scales.pay_scale_name, 
		pay_scale_steps.org_id, pay_scale_steps.pay_scale_step_id, pay_scale_steps.pay_step, 
		pay_scale_steps.pay_amount,
		(pay_scales.pay_scale_name || '-' || currency.currency_symbol || '-' || pay_scale_steps.pay_step) as pay_step_name
	FROM pay_scale_steps INNER JOIN pay_scales ON pay_scale_steps.pay_scale_id = pay_scales.pay_scale_id
		INNER JOIN currency ON pay_scales.currency_id = currency.currency_id;
		
ALTER TABLE employees ADD pay_scale_step_id		integer references pay_scale_steps;
CREATE INDEX employees_pay_scale_step_id ON employees (pay_scale_step_id);


INSERT INTO pay_scale_steps (pay_scale_id, org_id, pay_step, pay_amount)
SELECT pay_scale_id, org_id, pay_year, pay_amount
FROM pay_scale_years
ORDER BY pay_scale_id, pay_year;

