

CREATE TABLE shifts (
	shift_id				serial primary key,
	project_id				integer references projects,
	org_id					integer references orgs,
	shift_name				varchar(50),
	shift_hours				real not null default 9,
	break_hours				real not null default 1,
	
	include_holiday 		boolean default false not null,

	include_mon				boolean default true not null,
	include_tue				boolean default true not null,
	include_wed				boolean default true not null,
	include_thu				boolean default true not null,
	include_fri				boolean default true not null,
	include_sat				boolean default false not null,
	include_sun				boolean default false not null,

	time_in					time not null,
	time_out				time not null,
	weekend_in				time not null,
	weekend_out				time not null,
	
	details					text
);
CREATE INDEX shifts_project_id ON shifts (project_id);
CREATE INDEX shifts_org_id ON shifts (org_id);

ALTER TABLE attendance ADD shift_id				integer references shifts;
CREATE INDEX attendance_shift_id ON attendance (shift_id);

CREATE TABLE shift_schedule (
	shift_schedule_id		serial primary key,
	shift_id				integer references shifts,
	entity_id				integer references entitys,
	org_id					integer references orgs,

	is_active				boolean default true not null,

	details					text,
	UNIQUE(shift_id, entity_id)
);
CREATE INDEX shift_schedule_shift_id ON shift_schedule (shift_id);
CREATE INDEX shift_schedule_entity_id ON shift_schedule (entity_id);
CREATE INDEX shift_schedule_org_id ON shift_schedule (org_id);

CREATE VIEW vw_shifts AS
	SELECT projects.project_id, projects.project_name, 
		shifts.org_id, shifts.shift_id, shifts.shift_name, shifts.shift_hours, shifts.break_hours, shifts.include_holiday, 
		shifts.include_mon, shifts.include_tue, shifts.include_wed, shifts.include_thu, shifts.include_fri, 
		shifts.include_sat, shifts.include_sun, shifts.time_in, shifts.time_out, shifts.weekend_in, shifts.weekend_out,
		shifts.details
		
	FROM shifts LEFT JOIN projects ON shifts.project_id = projects.project_id;

CREATE VIEW vw_shift_schedule AS
	SELECT vw_shifts.project_id, vw_shifts.project_name, 
		vw_shifts.shift_id, vw_shifts.shift_name, vw_shifts.shift_hours, vw_shifts.include_holiday, 
		vw_shifts.include_mon, vw_shifts.include_tue, vw_shifts.include_wed, vw_shifts.include_thu, vw_shifts.include_fri, 
		vw_shifts.include_sat, vw_shifts.include_sun, vw_shifts.time_in, vw_shifts.time_out, 

		entitys.entity_id, entitys.entity_name, 
		
		shift_schedule.org_id, shift_schedule.shift_schedule_id, shift_schedule.is_active, shift_schedule.details
	
	FROM shift_schedule INNER JOIN vw_shifts ON shift_schedule.shift_id = vw_shifts.shift_id
		INNER JOIN entitys ON shift_schedule.entity_id = entitys.entity_id;

CREATE VIEW vw_attendance_shifts AS
	SELECT entitys.entity_id, entitys.entity_name, 
		shifts.shift_id, shifts.shift_name, shifts.shift_hours,
		shifts.time_in as shift_time_in, shifts.time_out as shift_time_out, 
		shifts.weekend_in as shift_weekend_in, shifts.weekend_out as shift_weekend_out,
		
		attendance.org_id, attendance.attendance_id, attendance.attendance_date, attendance.time_in, 
		attendance.time_out, attendance.late, attendance.overtime, attendance.narrative, attendance.details,
		to_char(attendance.attendance_date, 'YYYYMM') as a_month,
		EXTRACT(WEEK FROM attendance.attendance_date) as a_week,
		EXTRACT(DOW FROM attendance.attendance_date) as a_dow
	FROM attendance INNER JOIN entitys ON attendance.entity_id = entitys.entity_id
		LEFT JOIN shifts ON attendance.shift_id = shifts.shift_id;

CREATE VIEW vw_attendance_schedule AS
	SELECT ss.org_id, ss.period_id, ss.period_day, ss.employee_id, ss.entity_id, ss.employee_name, 
		ss.average_daily_rate, ss.normal_work_hours, ss.overtime_rate, ss.special_time_rate, ss.per_day_earning,
		(CASE WHEN ss.normal_work_hours > 0 THEN ss.average_daily_rate * ss.overtime_rate / ss.normal_work_hours ELSE 0 END) as overtime_hr,
		(CASE WHEN ss.normal_work_hours > 0 THEN ss.average_daily_rate * ss.special_time_rate / ss.normal_work_hours ELSE 0 END) as special_time_hr,
		holidays.holiday_id, holidays.holiday_name,
		sa.shift_id, sa.shift_name, sa.shift_hours,
		sa.shift_time_in, sa.shift_time_out, 
		sa.shift_weekend_in, sa.shift_weekend_out,
		
		sa.attendance_id, sa.attendance_date, sa.time_in, 
		sa.time_out, sa.late, sa.overtime, sa.narrative, 
		sa.a_month, sa.a_week, sa.a_dow
			
	FROM (SELECT employees.org_id, employees.entity_id, employees.employee_id,
		(employees.Surname || ' ' || employees.First_name || ' ' || COALESCE(employees.Middle_name, '')) as employee_name,
		employees.average_daily_rate, employees.normal_work_hours, employees.overtime_rate, employees.special_time_rate, employees.per_day_earning,
		periods.period_id, generate_series(periods.start_date, periods.end_date, '1 day')::date as period_day
		FROM periods, employees WHERE periods.org_id = employees.org_id) as ss
		LEFT JOIN holidays ON (ss.period_day = holidays.holiday_date) AND (ss.org_id = holidays.org_id)
		LEFT JOIN vw_attendance_shifts as sa ON (ss.entity_id = sa.entity_id) AND (ss.period_day = sa.attendance_date);
		
CREATE VIEW vw_attendance_summary AS
	SELECT ats.org_id, ats.period_id, ats.employee_id, ats.entity_id, ats.employee_name, 
		ats.average_daily_rate, ats.normal_work_hours, ats.overtime_rate, ats.special_time_rate, ats.per_day_earning,
		ats.overtime_hr, ats.special_time_hr,
		ats.holiday_id, ats.holiday_name,
		ats.shift_id, ats.shift_name, ats.shift_hours, ats.a_month,
		count(ats.attendance_id) as days_worked,
		sum(ats.late) as t_late, sum(ats.overtime) as t_overtime
	FROM vw_attendance_schedule as ats
	GROUP BY  ats.org_id, ats.period_id, ats.employee_id, ats.entity_id, ats.employee_name,
		ats.average_daily_rate, ats.normal_work_hours, ats.overtime_rate, ats.special_time_rate, ats.per_day_earning,
		ats.overtime_hr, ats.special_time_hr,
		ats.holiday_id, ats.holiday_name,
		ats.shift_id, ats.shift_name, ats.shift_hours, ats.a_month;

		
CREATE OR REPLACE FUNCTION add_shift_staff(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg		 				varchar(120);
	v_entity_id				integer;
	v_org_id				integer;
BEGIN

	SELECT entity_id INTO v_entity_id
	FROM shift_schedule WHERE (entity_id = CAST($1 as int)) AND (shift_id = CAST($3 as int));
	
	IF(v_entity_id is null)THEN
		SELECT org_id INTO v_org_id
		FROM shifts WHERE (shift_id = CAST($3 as int));
		
		INSERT INTO  shift_schedule (shift_id, entity_id, org_id)
		VALUES (CAST($3 as int), CAST($1 as int), v_org_id);

		msg := 'Added to shift';
	ELSE
		msg := 'Already added to shift';
	END IF;
	
	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_attendance() RETURNS trigger AS $$
DECLARE
	rec					RECORD;
	v_dow				integer;
	v_holiday_name		varchar(50);
BEGIN

	IF (TG_OP = 'INSERT') THEN
		SELECT max(shift_id) INTO NEW.shift_id
		FROM shift_schedule	
		WHERE (is_active = true);
		
		IF(NEW.shift_id is not null)THEN
			SELECT include_holiday, include_mon, include_tue, include_wed, include_thu, 
				include_fri, include_sat, include_sun, time_in, time_out, weekend_in, weekend_out
			INTO rec
			FROM shifts WHERE (shift_id = NEW.shift_id);
			
			SELECT holiday_name INTO v_holiday_name
			FROM holidays WHERE (org_id = NEW.org_id) AND (holiday_date = NEW.attendance_date);
			
			--- lateness and overtime calculation
			v_dow := EXTRACT(DOW FROM NEW.attendance_date);
			IF(v_dow = 6)THEN --- satuday
				IF(rec.include_sat = true)THEN
					NEW.late := EXTRACT(epoch FROM (NEW.time_in - rec.weekend_in)) / 3600;
					NEW.overtime := EXTRACT(epoch FROM (NEW.time_out - rec.weekend_out)) / 3600;
				ELSE
					NEW.overtime := EXTRACT(epoch FROM (NEW.time_out - NEW.time_in)) / 3600;
				END IF;
			ELSIF(v_dow = 0)THEN --- Sunday
				IF(rec.include_sun = true)THEN
					NEW.late := EXTRACT(epoch FROM (NEW.time_in - rec.weekend_in)) / 3600;
					NEW.overtime := EXTRACT(epoch FROM (NEW.time_out - rec.weekend_out)) / 3600;
				ELSE
					NEW.overtime := EXTRACT(epoch FROM (NEW.time_out - NEW.time_in)) / 3600;
				END IF;
			ELSE --- normal days
				NEW.late := EXTRACT(epoch FROM (NEW.time_in - rec.time_in)) / 3600;
				NEW.overtime := EXTRACT(epoch FROM (NEW.time_out - rec.time_out)) / 3600;
			END IF;
			IF((v_holiday_name is not null) AND (rec.include_holiday = false))THEN
				NEW.late := 0;
				NEW.overtime := EXTRACT(epoch FROM (NEW.time_out - NEW.time_in)) / 3600;
				NEW.narrative := v_holiday_name;
			END IF;
			IF(NEW.late < 0)THEN NEW.late := 0; END IF;
			IF(NEW.overtime < 0)THEN NEW.overtime := 0; END IF;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_attendance BEFORE INSERT OR UPDATE ON attendance
	FOR EACH ROW EXECUTE PROCEDURE ins_attendance();

CREATE OR REPLACE FUNCTION get_attendance_pay(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	reca 					RECORD;
	v_period_id				integer;
	v_org_id				integer;
	v_entity_id				integer;
	v_start_date			date;
	v_end_date				date;
	v_project_cost			float;
	msg 					varchar(120);
BEGIN

	SELECT period_id, org_id, start_date, end_date INTO v_period_id, v_org_id, v_start_date, v_end_date
	FROM periods
	WHERE (period_id = $1::int);
	
	v_entity_id := $2::int;
	
	--- Computer the work hours
	FOR reca IN SELECT b.employee_month_id, (sum(a.days_worked) * a.average_daily_rate) as month_pay
		FROM vw_attendance_summary a INNER JOIN employee_month b ON (a.entity_id = b.entity_id) AND (a.period_id = b.period_id)
		WHERE (a.per_day_earning = true) AND (a.holiday_id is null) AND (a.period_id = v_period_id)
		GROUP BY b.employee_month_id, a.average_daily_rate
	LOOP
		UPDATE employee_month SET basic_pay = reca.month_pay WHERE employee_month_id = reca.employee_month_id;
	END LOOP;
	
	DELETE FROM employee_overtime WHERE (auto_computed = true)
	AND (employee_month_id IN (SELECT employee_month_id FROM employee_month WHERE period_id = v_period_id));
	
	--- Insert normal overtime
	INSERT INTO employee_overtime (employee_month_id, org_id, overtime_date, overtime, overtime_rate, auto_computed, approve_status, entity_id)
	SELECT b.employee_month_id, a.org_id, v_end_date, a.t_overtime, a.overtime_hr, true, 'Completed', v_entity_id
	FROM vw_attendance_summary a INNER JOIN employee_month b ON (a.entity_id = b.entity_id) AND (a.period_id = b.period_id)
	WHERE (a.holiday_id is null) AND (a.period_id = v_period_id) AND (a.t_overtime is not null);

	--- Insert special time overtime
	INSERT INTO employee_overtime (employee_month_id, org_id, overtime_date, overtime, overtime_rate, narrative, auto_computed, approve_status, entity_id)
	SELECT b.employee_month_id, a.org_id, v_end_date, a.t_overtime, a.special_time_hr, a.holiday_name, true, 'Completed', v_entity_id
	FROM vw_attendance_summary a INNER JOIN employee_month b ON (a.entity_id = b.entity_id) AND (a.period_id = b.period_id)
	WHERE (a.holiday_id is not null) AND (a.period_id = v_period_id) AND (a.t_overtime is not null);
	
	msg := 'Done';

	return msg;
END;
$$ LANGUAGE plpgsql;

