CREATE OR REPLACE VIEW vw_son_points AS
SELECT points.points_id, periods.period_id, periods.start_date as period,
	to_char(periods.start_date, 'mmyyyy'::text) AS ticket_period,
	points.pcc, points.son, points.segments, points.amount,
	points.points, points.bonus, vw_entitys.org_name,
	vw_entitys.entity_name, vw_entitys.entity_id,vw_entitys.user_name,  vw_entitys.pcc AS org_pcc,
vw_entitys.son AS org_son,  vw_entitys.is_active, vw_entitys.account_manager_id
FROM points JOIN vw_entitys ON points.entity_id = vw_entitys.entity_id
	INNER JOIN periods ON points.period_id = periods.period_id
	WHERE periods.approve_status = 'Approved';
