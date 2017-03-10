

ALTER TABLE work_rates ADD group_rate boolean default false not null;

CREATE TABLE work_groups (
	work_group_id			serial primary key,
	day_work_id				integer references day_works not null,
	work_rate_id			integer references work_rates not null,
	org_id					integer references orgs,
	
	group_number			integer default 0 not null,
	work_weight				real default 0 not null,
	work_pay				integer default 0 not null,
	overtime				real default 0 not null,
	special_time			real default 0 not null,
	work_amount				real default 0 not null,
	narrative				varchar(320)
);
CREATE INDEX work_groups_day_work_id ON work_groups (day_work_id);
CREATE INDEX work_groups_work_rate_id ON work_groups (work_rate_id);
CREATE INDEX work_groups_org_id ON work_groups (org_id);

CREATE TABLE work_members (
	work_member_id			serial primary key,
	work_group_id			integer references work_groups not null,
	entity_id				integer references entitys not null,
	org_id					integer references orgs,
	narrative				varchar(320)
);
CREATE INDEX work_members_work_group_id ON work_members (work_group_id);
CREATE INDEX work_members_entity_id ON work_members (entity_id);
CREATE INDEX work_members_org_id ON work_members (org_id);

CREATE VIEW vw_work_groups AS
	SELECT vw_day_works.supervisor_id, vw_day_works.supervisor_name, 
		vw_day_works.farm_field_id, vw_day_works.farm_field_name, 
		vw_day_works.period_id, vw_day_works.start_date, vw_day_works.end_date, 
		vw_day_works.activated, vw_day_works.closed, vw_day_works.month_id, vw_day_works.period_year, 
		vw_day_works.period_month, vw_day_works.quarter, vw_day_works.semister,		
		vw_day_works.day_work_id, vw_day_works.batch_ref, vw_day_works.work_date, 
		vw_day_works.work_start, vw_day_works.work_end, vw_day_works.farm_weight, vw_day_works.factory_weight,
		
		work_rates.work_rate_id, work_rates.work_rate_name, work_rates.work_rate_code,
		
		work_groups.org_id, work_groups.work_group_id, work_groups.work_weight, work_groups.work_pay, 
		work_groups.overtime, work_groups.special_time, work_groups.work_amount, 
		work_groups.group_number, work_groups.narrative,
		wm.worker_count, 
		(CASE WHEN wm.worker_count = 0 THEN 0 ELSE (work_groups.work_weight / wm.worker_count) END) as worker_weight,
		(CASE WHEN wm.worker_count = 0 THEN 0 ELSE (work_groups.work_amount / wm.worker_count) END) as worker_amount
	FROM work_groups INNER JOIN vw_day_works ON work_groups.day_work_id = vw_day_works.day_work_id
		INNER JOIN work_rates ON work_groups.work_rate_id = work_rates.work_rate_id
		LEFT JOIN (SELECT work_group_id, count(work_member_id) as worker_count
			FROM work_members GROUP BY work_group_id) wm ON work_groups.work_group_id = wm.work_group_id;
	
CREATE VIEW vw_work_members AS
	SELECT vw_work_groups.supervisor_id, vw_work_groups.supervisor_name, 
		vw_work_groups.farm_field_id, vw_work_groups.farm_field_name, 
		vw_work_groups.period_id, vw_work_groups.start_date, vw_work_groups.end_date, 
		vw_work_groups.activated, vw_work_groups.closed, vw_work_groups.month_id, vw_work_groups.period_year, 
		vw_work_groups.period_month, vw_work_groups.quarter, vw_work_groups.semister,		
		vw_work_groups.day_work_id, vw_work_groups.batch_ref, vw_work_groups.work_date, 
		vw_work_groups.work_start, vw_work_groups.work_end, vw_work_groups.farm_weight, vw_work_groups.factory_weight,
		vw_work_groups.work_rate_id, vw_work_groups.work_rate_name, vw_work_groups.work_rate_code,
		vw_work_groups.work_group_id, vw_work_groups.work_weight, vw_work_groups.work_pay, 
		vw_work_groups.overtime, vw_work_groups.special_time, vw_work_groups.work_amount, 
		vw_work_groups.group_number, vw_work_groups.worker_count, 
		vw_work_groups.worker_weight, vw_work_groups.worker_amount,
		
		entitys.entity_id as worker_id, entitys.entity_name as worker_name, 
		work_members.org_id, work_members.work_member_id, work_members.narrative
	FROM work_members INNER JOIN vw_work_groups ON work_members.work_group_id = vw_work_groups.work_group_id
		INNER JOIN entitys ON work_members.entity_id = entitys.entity_id;

DROP TRIGGER ins_works ON works;

CREATE TRIGGER ins_works BEFORE INSERT OR UPDATE ON works
    FOR EACH ROW EXECUTE PROCEDURE ins_works();
    
CREATE OR REPLACE FUNCTION ins_work_groups() RETURNS trigger AS $$
BEGIN

	IF(NEW.work_weight = 0) AND (NEW.work_pay = 0)THEN
		NEW.work_pay = 1;
	END IF;
	
	SELECT (work_rates.weight_rate * NEW.work_weight + work_rates.work_rate * NEW.work_pay +
		work_rates.overtime_rate * NEW.overtime + work_rates.special_rate * NEW.special_time) INTO NEW.work_amount
	
	FROM work_rates 
	WHERE work_rate_id = NEW.work_rate_id;
	

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_work_groups BEFORE INSERT OR UPDATE ON work_groups
    FOR EACH ROW EXECUTE PROCEDURE ins_work_groups();
    
CREATE OR REPLACE FUNCTION farm_payroll(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec 		RECORD;
	msg 		varchar(120);
BEGIN
	IF ($3 = '1') THEN
		FOR rec IN SELECT works.entity_id, sum(works.work_amount) as sum_amount
			FROM works INNER JOIN day_works ON works.day_work_id = day_works.day_work_id
			WHERE (day_works.period_id = $1::int) 
			GROUP BY works.entity_id
		LOOP
		
			UPDATE employee_month SET basic_pay = rec.sum_amount
			WHERE (entity_id = rec.entity_id) 
				AND (period_id = $1::int);
				
		END LOOP;
		
		FOR rec IN SELECT vw_work_members.entity_id, sum(vw_work_members.work_amount) as sum_amount
			FROM vw_work_members
			WHERE (vw_work_members.period_id = $1::int) 
			GROUP BY vw_work_members.entity_id
		LOOP
		
			UPDATE employee_month SET basic_pay = basic_pay + rec.sum_amount
			WHERE (entity_id = rec.entity_id) 
				AND (period_id = $1::int);
				
		END LOOP;
		
		msg := 'Payroll Processed';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;
