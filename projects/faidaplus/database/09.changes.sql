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
