CREATE OR REPLACE FUNCTION getbalance(integer) RETURNS real AS $$
DECLARE
	v_org_id 			integer;
	v_function_role		text;
	v_balance			real;
BEGIN
	v_balance = 0::real;
	SELECT org_id,function_role INTO v_org_id, v_function_role FROM vw_entitys WHERE entity_id = $1;
	IF(v_function_role = 'manager')THEN
		SELECT COALESCE(sum(dr - cr), 0) INTO v_balance
		FROM vw_pcc_statement
		WHERE org_id = v_org_id;
	END IF;
	IF(v_function_role = 'consultant')THEN
		SELECT COALESCE(sum(dr - cr), 0) INTO v_balance
		FROM vw_son_statement
		WHERE entity_id = $1;
	END IF;

	IF(v_function_role = 'admin')THEN
		SELECT COALESCE(sum(dr - cr), 0) INTO v_balance
		FROM vw_pcc_statement
		WHERE org_id = 0;
	END IF;
	RETURN v_balance;
END;
$$ LANGUAGE plpgsql;
