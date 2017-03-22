CREATE OR REPLACE FUNCTION getPccbalance(integer,character(20))
  RETURNS real AS
$$
DECLARE
  v_org_id 			integer;
  v_function_role		text;
  v_balance			real;
BEGIN
  v_balance = 0::real;

  SELECT COALESCE(sum(dr+bonus - cr), 0) INTO v_balance
  FROM vw_pcc_statement
  WHERE org_id = $1 AND order_date < $2::date;
  RETURN v_balance;
END;
$$
  LANGUAGE plpgsql;
