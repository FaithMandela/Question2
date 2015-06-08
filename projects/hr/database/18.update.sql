DROP VIEW vw_reporting;
CREATE VIEW vw_reporting AS
	SELECT entitys.entity_id, entitys.entity_name, rpt.entity_id as rpt_id, rpt.entity_name as rpt_name, 
		reporting.org_id, reporting.reporting_id, reporting.date_from, 
		reporting.date_to, reporting.primary_report, reporting.is_active, reporting.ps_reporting, 
		reporting.reporting_level, reporting.details
	FROM reporting INNER JOIN entitys ON reporting.entity_id = entitys.entity_id
		INNER JOIN entitys as rpt ON reporting.report_to_id = rpt.entity_id;
		
CREATE VIEW vw_review_reporting AS
	SELECT entitys.entity_id, entitys.entity_name, rpt.entity_id as rpt_id, rpt.entity_name as rpt_name, 
		reporting.reporting_id, reporting.date_from, 
		reporting.date_to, reporting.primary_report, reporting.is_active, reporting.ps_reporting, 
		reporting.reporting_level, 
		job_reviews.job_review_id, job_reviews.total_points, 
		job_reviews.org_id, job_reviews.review_date, job_reviews.review_done, 
		job_reviews.approve_status, job_reviews.workflow_table_id, job_reviews.application_date, job_reviews.action_date,
		job_reviews.recomendation, job_reviews.reviewer_comments, job_reviews.pl_comments,
		EXTRACT(YEAR FROM job_reviews.review_date) as review_year
	FROM reporting INNER JOIN entitys ON reporting.entity_id = entitys.entity_id
		INNER JOIN entitys as rpt ON reporting.report_to_id = rpt.entity_id
		INNER JOIN job_reviews ON reporting.entity_id = job_reviews.entity_id;
		
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


ALTER TABLE job_reviews ADD		self_rating				integer;
ALTER TABLE job_reviews ADD		supervisor_rating		integer;

CREATE OR REPLACE FUNCTION increment_payroll(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_entity_id		integer;
	v_pay_step_id	integer;
	v_pay_step		integer;
	v_next_step_id	integer;
	v_pay_scale_id	integer;
	v_currency_id	integer;
	v_pay_amount	real;
	msg 			varchar(120);
BEGIN

	v_entity_id := CAST($1 as int);
	
	IF ($3 = '1') THEN
		SELECT pay_scale_steps.pay_scale_step_id, pay_scale_steps.pay_amount, pay_scales.currency_id
			INTO v_pay_step_id, v_pay_amount, v_currency_id
		FROM employees INNER JOIN pay_scale_steps ON employees.pay_scale_step_id = pay_scale_steps.pay_scale_step_id
			INNER JOIN pay_scales ON pay_scale_steps.pay_scale_id = pay_scales.pay_scale_id
		WHERE employees.entity_id = v_entity_id;
		
		IF((v_pay_amount is not null) AND (v_currency_id is not null))THEN
			UPDATE employees SET basic_salary = v_pay_amount, currency_id = v_currency_id
			WHERE entity_id = v_entity_id;
		END IF;

		msg := 'Updated the pay';
	ELSIF ($3 = '2') THEN
		SELECT pay_scale_steps.pay_scale_step_id, pay_scale_steps.pay_scale_id, pay_scale_steps.pay_step
			INTO v_pay_step_id, v_pay_scale_id, v_pay_step
		FROM employees INNER JOIN pay_scale_steps ON employees.pay_scale_step_id = pay_scale_steps.pay_scale_step_id
		WHERE employees.entity_id = v_entity_id;
		
		SELECT pay_scale_steps.pay_scale_step_id INTO v_next_step_id
		FROM pay_scale_steps
		WHERE (pay_scale_steps.pay_scale_id = v_pay_scale_id) AND (pay_scale_steps.pay_step = v_pay_step + 1);
		
		IF(v_next_step_id is not null)THEN
			UPDATE employees SET pay_scale_step_id = v_next_step_id
			WHERE entity_id = v_entity_id;
		END IF;

		msg := 'Pay step incremented';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;


ALTER TABLE objectives ADD objective_maditory		boolean default false not null;


CREATE OR REPLACE FUNCTION insa_employee_objectives() RETURNS trigger AS $$
BEGIN

	INSERT INTO objectives (employee_objective_id, org_id, objective_type_id,
		date_set, objective_ps, objective_name, objective_maditory)
	VALUES (NEW.employee_objective_id, NEW.org_id, 1,
		current_date, 0, 'Community service', true);

	RETURN null;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insa_employee_objectives AFTER INSERT ON employee_objectives
    FOR EACH ROW EXECUTE PROCEDURE insa_employee_objectives();
    
    
    