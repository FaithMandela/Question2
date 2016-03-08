


CREATE VIEW vw_employee_periods AS
	SELECT aa.period_id, aa.start_date, aa.period_year, aa.period_month, aa.period_code, 
		aa.week_start, EXTRACT(WEEK FROM aa.week_start) as p_week,
		b.org_id, b.entity_id, b.employee_id, 
		(b.Surname || ' ' || b.First_name || ' ' || COALESCE(b.Middle_name, '')) as employee_name 
	FROM (SELECT a.org_id, a.period_id, a.start_date, a.end_date, 
		to_char(a.start_date, 'YYYY') as period_year, to_char(a.start_date, 'Month') as period_month,
		to_char(a.start_date, 'YYYYMM') as period_code,
		generate_series(a.start_date, a.end_date, interval '1 week') as week_start
		FROM periods a) aa
	INNER JOIN employees b ON aa.org_id = b.org_id;
	
DROP VIEW vw_attendance;
CREATE VIEW vw_attendance AS
	SELECT entitys.entity_id, entitys.entity_name, attendance.attendance_id, attendance.attendance_date, 
		attendance.org_id, attendance.time_in, attendance.time_out, attendance.details,
		to_char(attendance.attendance_date, 'YYYYMM') as a_month,
        EXTRACT(WEEK FROM attendance.attendance_date) as a_week,
        EXTRACT(DOW FROM attendance.attendance_date) as a_dow
	FROM attendance INNER JOIN entitys ON attendance.entity_id = entitys.entity_id;
	
	
CREATE VIEW vw_week_attendance AS
	SELECT a.period_id, a.start_date, a.period_year, a.period_month, a.period_code, 
		a.week_start, a.p_week, a.org_id, a.entity_id, a.employee_id, a.employee_name,
		pp1.time_in as mon_time_in, pp1.time_out as mon_time_out, (pp1.time_out - pp1.time_in) as mon_time_diff,
		pp2.time_in as tue_time_in, pp2.time_out as tue_time_out, (pp2.time_out - pp2.time_in) as tue_time_diff,
		pp3.time_in as wed_time_in, pp3.time_out as wed_time_out, (pp3.time_out - pp3.time_in) as wed_time_diff,
		pp4.time_in as thu_time_in, pp4.time_out as thu_time_out, (pp4.time_out - pp4.time_in) as thu_time_diff,
		pp5.time_in as fri_time_in, pp5.time_out as fri_time_out, (pp5.time_out - pp5.time_in) as fri_time_diff
	FROM vw_employee_periods a
		LEFT JOIN (SELECT p1.time_in, p1.time_out, p1.entity_id, p1.a_month, p1.a_week
			FROM vw_attendance p1 WHERE p1.a_dow = 1) pp1 ON
			(a.entity_id = pp1.entity_id) AND (a.period_code = pp1.a_month) AND (a.p_week = pp1.a_week)
		LEFT JOIN (SELECT p2.time_in, p2.time_out, p2.entity_id, p2.a_month, p2.a_week
			FROM vw_attendance p2 WHERE p2.a_dow = 2) pp2 ON
			(a.entity_id = pp2.entity_id) AND (a.period_code = pp2.a_month) AND (a.p_week = pp2.a_week)
		LEFT JOIN (SELECT p3.time_in, p3.time_out, p3.entity_id, p3.a_month, p3.a_week
			FROM vw_attendance p3 WHERE p3.a_dow = 1) pp3 ON
			(a.entity_id = pp3.entity_id) AND (a.period_code = pp3.a_month) AND (a.p_week = pp3.a_week)
		LEFT JOIN (SELECT p4.time_in, p4.time_out, p4.entity_id, p4.a_month, p4.a_week
			FROM vw_attendance p4 WHERE p4.a_dow = 4) pp4 ON
			(a.entity_id = pp4.entity_id) AND (a.period_code = pp4.a_month) AND (a.p_week = pp4.a_week)
		LEFT JOIN (SELECT p5.time_in, p5.time_out, p5.entity_id, p5.a_month, p5.a_week
			FROM vw_attendance p5 WHERE p5.a_dow = 1) pp5 ON
			(a.entity_id = pp5.entity_id) AND (a.period_code = pp5.a_month) AND (a.p_week = pp5.a_week);
