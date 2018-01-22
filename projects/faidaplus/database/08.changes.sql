drop view vw_pcc_statement;
CREATE OR REPLACE VIEW vw_pcc_statement AS
	SELECT a.dr, a.cr, a.org_id, a.order_date::date, a.pcc,
			a.org_name, a.dr+a.bonus - a.cr AS balance, a.details, a.batch_no,a.bonus
		FROM ((SELECT COALESCE(vw_son_points.points, 0::real) AS dr,
			0::real AS cr, vw_son_points.period AS order_date, ''::text,
			vw_son_points.pcc, vw_son_points.org_name, 0::integer,vw_son_points.org_id,
			( 'Earnings @ Ksh '||amount||' per segment for '|| segments||' segments sold in '|| ticket_period)as details,
	        NULL::integer AS batch_no,COALESCE(vw_son_points.bonus, 0::real) as bonus
		FROM vw_son_points)
		UNION
		(SELECT 0::real AS float4, vw_orders.grand_total::real AS order_total_amount,
			vw_orders.order_date, vw_orders.son, vw_orders.pcc, vw_orders.org_name,
			vw_orders.entity_id,vw_orders.org_id,
			get_order_details(vw_orders.order_id) AS details,batch_no,0::real as bonus
		FROM vw_orders)) a
		ORDER BY a.order_date;
