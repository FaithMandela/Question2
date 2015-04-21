


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
