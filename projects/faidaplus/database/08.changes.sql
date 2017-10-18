CREATE OR REPLACE VIEW vw_opening_balance AS
SELECT a.dr, a.cr, a.order_date::date AS order_date, a.son, a.pcc, a.org_name, a.entity_id, a.entity_name,
a.dr - a.cr AS balance, a.points, a.segments, a.amount, a.period,a.is_active
FROM ((SELECT COALESCE(vw_son_points.points, 0::real) + COALESCE(vw_son_points.bonus, 0::real) AS dr,
		   0::real AS cr, vw_son_points.period AS order_date, vw_son_points.org_son as son, vw_son_points.org_pcc as pcc,
		   vw_son_points.org_name, vw_son_points.entity_id, vw_son_points.entity_name, vw_son_points.segments,
		   vw_son_points.amount, vw_son_points.points, vw_son_points.period,vw_son_points.is_active
		  FROM vw_son_points)
	   UNION ALL
		(SELECT 0::real AS float4,
		   vw_orders.grand_total AS order_total_amount, vw_orders.order_date, vw_orders.son, vw_orders.pcc,
		   vw_orders.org_name, vw_orders.entity_id, vw_orders.entity_name, 0::real as segments, 0::real as amount,
		   0::real as points,  null::date as period,vw_orders.is_active
		  FROM vw_orders)) a
ORDER BY a.order_date;
