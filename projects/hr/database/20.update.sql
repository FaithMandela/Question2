CREATE OR REPLACE FUNCTION get_formula_adjustment(int, int, real) RETURNS float AS $$
DECLARE
	v_employee_month_id		integer;
	v_basic_pay				float;
	v_adjustment			float;
	v_prof_allowance		float;
BEGIN

	SELECT employee_month.employee_month_id, employee_month.basic_pay INTO v_employee_month_id, v_basic_pay
	FROM employee_month
	WHERE (employee_month.employee_month_id = $1);

	IF ($2 = 1) THEN
		v_adjustment := v_basic_pay * $3;
	ELSIF ($2 = 2) THEN
		SELECT amount INTO v_prof_allowance
		FROM employee_adjustments
		WHERE (employee_month_id = v_employee_month_id) AND (adjustment_id = 5);
		IF(v_prof_allowance is null) THEN v_prof_allowance := 0; END IF;
		
		v_adjustment := (v_basic_pay + v_prof_allowance) * $3;
	ELSE
		v_adjustment := 0;
	END IF;

	IF(v_adjustment is null) THEN
		v_adjustment := 0;
	END IF;

	RETURN v_adjustment;
END;
$$ LANGUAGE plpgsql;
