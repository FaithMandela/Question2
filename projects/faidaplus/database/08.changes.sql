
CREATE OR REPLACE VIEW vw_org_points AS
 SELECT periods.period_id,
    periods.start_date AS period,
    to_char(periods.start_date::timestamp with time zone, 'mmyyyy'::text) AS ticket_period,
    vw_orgs.pcc,
    COALESCE(sum(points.segments), 0.0::real) AS segments,
    COALESCE(sum(points.points), 0.0::real) AS points,
    COALESCE(sum(points.bonus), 0.0::real) AS bonus,
    vw_orgs.org_id,
    vw_orgs.org_name,
    COALESCE(count(points.son), 0::bigint) AS son,points.amount
   FROM points
     JOIN vw_orgs ON points.org_id = vw_orgs.org_id
     JOIN periods ON points.period_id = periods.period_id
  WHERE periods.approve_status::text = 'Approved'::text
  GROUP BY periods.period_id, periods.start_date, vw_orgs.pcc, vw_orgs.org_id, vw_orgs.org_name,points.amount
  ORDER BY periods.start_date DESC;

CREATE OR REPLACE VIEW vw_pcc_statement AS
SELECT a.dr, a.cr, a.org_id, a.order_date::date, a.pcc,
		a.org_name, a.dr - a.cr AS balance, a.details, a.batch_no
	FROM ((SELECT COALESCE(vw_org_points.points, 0::real) + COALESCE(vw_org_points.bonus, 0::real) AS dr,
		0::real AS cr, vw_org_points.period AS order_date, ''::text,
		vw_org_points.pcc, vw_org_points.org_name, 0::integer,vw_org_points.org_id,
		( 'Earnings @ Ksh '||amount||' per segment for '|| segments||' segments sold in '|| ticket_period)as details,NULL::integer AS batch_no
	FROM vw_org_points)
	UNION
	(SELECT 0::real AS float4, vw_orders.grand_total::real AS order_total_amount,
		vw_orders.order_date, vw_orders.son, vw_orders.pcc, vw_orders.org_name,
		vw_orders.entity_id,vw_orders.org_id,
		get_order_details(vw_orders.order_id) AS details,batch_no
	FROM vw_orders)) a
	ORDER BY a.order_date;
