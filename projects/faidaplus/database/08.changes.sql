CREATE OR REPLACE VIEW vw_pcc_statement AS
SELECT a.dr,
   a.cr,
   a.org_id,
   a.order_date::date AS order_date,
   a.pcc,
   a.org_name,
   a.dr + a.bonus - a.cr AS balance,
   a.details,
   a.batch_no,
   a.bonus,a.segments
  FROM ( SELECT COALESCE(vw_org_points.points, 0::real) AS dr,
		   0::real AS cr,
		   vw_org_points.period AS order_date,
		   ''::text AS text,
		   vw_org_points.pcc,
		   vw_org_points.org_name,
		   0 AS int4,
		   vw_org_points.org_id,
		   (((('Earnings @ Ksh '::text || vw_org_points.amount) || ' per segment for '::text) || vw_org_points.segments) || ' segments sold in '::text) || vw_org_points.ticket_period AS details,
		   NULL::integer AS batch_no,
		   COALESCE(vw_org_points.bonus, 0::real) AS bonus,vw_org_points.segments
		  FROM vw_org_points
	   UNION ALL
		SELECT 0::real AS float4,
		   vw_orders.grand_total AS order_total_amount,
		   vw_orders.order_date,
		   vw_orders.son,
		   vw_orders.pcc,
		   vw_orders.org_name,
		   vw_orders.entity_id,
		   vw_orders.org_id,
		   get_order_details(vw_orders.order_id) AS details,
		   vw_orders.batch_no,
		   0::real AS bonus, 0::real AS segments
		  FROM vw_orders) a
 ORDER BY a.order_date;



 CREATE OR REPLACE VIEW vw_son_statement AS
 SELECT a.dr, a.cr, a.order_date, a.son, a.pcc,
 		a.org_name, a.entity_id, a.dr+ a.bonus - a.cr AS balance, a.details, a.batch_no,a.bonus
 	FROM ((SELECT (COALESCE(vw_son_points.points, 0::real) ) AS dr,0::real AS cr, vw_son_points.period AS order_date, vw_son_points.son,
 		vw_son_points.pcc, vw_son_points.org_name, vw_son_points.entity_id,
 		('Earnings @ Ksh '||amount||' per segment for '|| segments||' segments sold in '|| ticket_period)as details,
 		NULL::integer AS batch_no, (COALESCE(vw_son_points.bonus, 0::real)) as bonus
 	FROM vw_son_points)
 	UNION ALL
 	(SELECT 0::real AS float4, vw_orders.grand_total::real AS order_total_amount,
 		vw_orders.order_date, vw_orders.son, vw_orders.pcc, vw_orders.org_name,
 		vw_orders.entity_id,
 		get_order_details(vw_orders.order_id) AS details,
 		batch_no, 0::real as bonus
 	FROM vw_orders)) a
 	ORDER BY a.order_date;

 CREATE OR REPLACE FUNCTION getbalance(integer)  RETURNS real AS $$
DECLARE
	v_org_id 			integer;
	v_function_role		text;
	v_balance			real;
BEGIN
	v_balance = 0::real;
	SELECT org_id,function_role INTO v_org_id, v_function_role FROM vw_entitys WHERE entity_id = $1;
	IF(v_function_role = 'manager')THEN
		SELECT COALESCE(sum(dr+bonus - cr), 0) INTO v_balance
		FROM vw_pcc_statement
		WHERE org_id = v_org_id;
	END IF;
	IF(v_function_role = 'consultant')THEN
		SELECT COALESCE(sum(dr+bonus - cr), 0) INTO v_balance
		FROM vw_son_statement
		WHERE entity_id = $1;
	END IF;

	IF(v_function_role = 'admin')THEN
		SELECT COALESCE(sum(dr+bonus - cr), 0) INTO v_balance
		FROM vw_pcc_statement
		WHERE org_id = 0 AND segments = 0;
	END IF;
	RETURN v_balance;
END;
$$
  LANGUAGE plpgsql;


  CREATE OR REPLACE VIEW vw_org_points AS
	SELECT periods.period_id, periods.start_date AS period, to_char(periods.start_date::timestamp with time zone, 'mmyyyy'::text) AS ticket_period,
		vw_orgs.pcc, COALESCE(SUM(points.segments),0.0) AS segments, COALESCE(SUM(points.points),0.0) AS points,
		COALESCE(SUM(points.bonus),0.0) AS bonus, vw_orgs.org_id,vw_orgs.org_name, COALESCE(count(points.son), 0::int) AS son,points.amount,
		vw_orgs.account_manager_id,vw_orgs.account_manager_name
	FROM points
	 JOIN vw_orgs ON points.org_id = vw_orgs.org_id
	 JOIN periods ON points.period_id = periods.period_id WHERE periods.approve_status = 'Approved'
	 GROUP BY periods.period_id,periods.start_date,vw_orgs.pcc,vw_orgs.account_manager_id,vw_orgs.account_manager_name,vw_orgs.org_id,vw_orgs.org_name,periods.approve_status,points.amount
	ORDER BY period desc;
