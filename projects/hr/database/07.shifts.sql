

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
		
DROP VIEW vw_attendance;
CREATE VIEW vw_attendance AS
	SELECT entitys.entity_id, entitys.entity_name, 
			shifts.shift_id, shifts.shift_name, shifts.shift_hours,
			shifts.time_in, shifts.time_out, shifts.weekend_in, shifts.weekend_out,
			
			attendance.org_id, attendance.attendance_id, attendance.attendance_date, attendance.time_in, 
			attendance.time_out, attendance.late, attendance.overtime, attendance.details
			to_char(attendance.attendance_date, 'YYYYMM') as a_month,
			EXTRACT(WEEK FROM attendance.attendance_date) as a_week,
			EXTRACT(DOW FROM attendance.attendance_date) as a_dow
	FROM attendance INNER JOIN entitys ON attendance.entity_id = entitys.entity_id
		LEFT JOIN shifts ON attendance.shift_id = shifts.shift_id;
	
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
BEGIN

	IF (TG_OP = 'INSERT') THEN
		SELECT max(shift_id) INTO NEW.shift_id
		FROM shift_schedule	
		WHERE (is_active = true);
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_attendance BEFORE INSERT OR UPDATE ON attendance
	FOR EACH ROW EXECUTE PROCEDURE ins_attendance();

