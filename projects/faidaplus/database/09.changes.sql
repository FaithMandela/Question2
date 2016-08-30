CREATE OR REPLACE VIEW vw_balance AS
 SELECT a.dr, a.cr, a.order_date::date, a.org_id,a.son, a.pcc, a.entity_id, a.dr + a.bonus - a.cr AS balance, a.bonus
   FROM ( SELECT COALESCE(vw_son_points.points, 0::real) AS dr,   0::real AS cr, vw_son_points.period AS order_date,
            vw_son_points.org_id,vw_son_points.son, vw_son_points.pcc, vw_son_points.entity_id, COALESCE(vw_son_points.bonus, 0::real) AS bonus
           FROM vw_son_points
        UNION ALL
         SELECT 0::real AS float4, vw_orders.grand_total AS order_total_amount, vw_orders.order_date, vw_orders.org_id, vw_orders.son,
            vw_orders.pcc, vw_orders.entity_id,  0::real AS bonus
               FROM vw_orders ) a
  ORDER BY a.order_date DESC;

 CREATE OR REPLACE FUNCTION getUnclaimbalance(integer)  RETURNS real AS $$
DECLARE
    v_org_id 			integer;
    v_function_role		text;
    v_balance			real;
	v_lbalance			real;
BEGIN
    v_balance = 0::real;
    SELECT org_id,function_role INTO v_org_id, v_function_role FROM vw_entitys WHERE entity_id = $1;

    IF(v_function_role = 'admin')THEN
        SELECT COALESCE(sum(balance), 0) INTO v_balance
        FROM vw_balance  WHERE  org_id = 0 AND order_date < '2016-01-01'::date;
		SELECT COALESCE(sum(balance), 0) INTO v_lbalance
        FROM vw_balance  WHERE  org_id = 0 AND pcc is not null AND son is not null  AND order_date >= '2016-01-01'::date;
		v_balance := v_balance + v_lbalance;

    END IF;
    RETURN v_balance;
END;
$$ LANGUAGE plpgsql;
