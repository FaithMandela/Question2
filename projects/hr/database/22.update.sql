

DROP  TABLE workflow_sql;

CREATE TABLE workflow_sql (
	workflow_sql_id			serial primary key,
	workflow_phase_id		integer not null references workflow_phases,
	org_id					integer references orgs,
	workflow_sql_name		varchar(50),
	is_condition			boolean default false,
	is_action				boolean default false,
	message					text not null,
	sql						text not null
);
CREATE INDEX workflow_sql_workflow_phase_id ON workflow_sql (workflow_phase_id);
CREATE INDEX workflow_sql_org_id ON workflow_sql (org_id);



CREATE VIEW vw_workflow_sql AS
	SELECT workflow_sql.org_id, workflow_sql.workflow_sql_id, workflow_sql.workflow_phase_id, workflow_sql.workflow_sql_name, 
		workflow_sql.is_condition, workflow_sql.is_action, workflow_sql.message, workflow_sql.sql,
		approvals.approval_id, approvals.org_entity_id, approvals.app_entity_id, 
		approvals.approval_level, approvals.escalation_days, approvals.escalation_hours, approvals.escalation_time, 
		approvals.forward_id, approvals.table_name, approvals.table_id, approvals.application_date, approvals.completion_date, 
		approvals.action_date, approvals.approve_status, approvals.approval_narrative
	FROM workflow_sql INNER JOIN approvals ON workflow_sql.workflow_phase_id = approvals.workflow_phase_id;

CREATE OR REPLACE FUNCTION upd_checklist(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	cl_id		Integer;
	reca 		RECORD;
	recc 		RECORD;
	msg 		varchar(120);
BEGIN
	cl_id := CAST($1 as int);

	SELECT approval_checklist_id, approval_id, checklist_id, requirement, manditory, done INTO reca
	FROM approval_checklists
	WHERE (approval_checklist_id = cl_id);

	IF ($3 = '1') THEN
		UPDATE approval_checklists SET done = true WHERE (approval_checklist_id = cl_id);

		SELECT count(approval_checklist_id) as cl_count INTO recc
		FROM approval_checklists
		WHERE (approval_id = reca.approval_id) AND (manditory = true) AND (done = false);
		msg := 'Checklist done.';
	ELSIF ($3 = '2') THEN
		UPDATE approval_checklists SET done = false WHERE (approval_checklist_id = cl_id);
		msg := 'Checklist not done.';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

INSERT INTO workflow_sql (workflow_sql_id, workflow_phase_id, org_id, workflow_sql_name, is_condition, is_action, message, sql) VALUES (2, 6, 0, 'Check supervisor rating', true, false, 'Ensure you check ratings', 'SELECT (CASE WHEN job_reviews.supervisor_rating is null THEN false ELSE true END) as ans
FROM job_reviews INNER JOIN approvals ON job_reviews.workflow_table_id = approvals.table_id
WHERE approvals.approval_id = ''');
INSERT INTO workflow_sql (workflow_sql_id, workflow_phase_id, org_id, workflow_sql_name, is_condition, is_action, message, sql) VALUES (3, 6, 0, 'Check reviewer comments', true, false, 'The reviewer comments need to be added', 'SELECT (CASE WHEN job_reviews.recomendation is null THEN false ELSE true END) as ans
FROM job_reviews INNER JOIN approvals ON job_reviews.workflow_table_id = approvals.table_id
WHERE approvals.approval_id = ''');

SELECT pg_catalog.setval('workflow_sql_workflow_sql_id_seq', 3, true);



ALTER TABLE employees ADD employee_email			varchar(120);

CREATE OR REPLACE FUNCTION ins_employees() RETURNS trigger AS $$
DECLARE
	v_entity_type_id		integer;
	v_use_type				integer;
	v_org_sufix 			varchar(4);
	v_first_password		varchar(12);
	v_user_count			integer;
	v_user_name				varchar(120);
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF(NEW.entity_id IS NULL) THEN
			SELECT org_sufix INTO v_org_sufix
			FROM orgs WHERE (org_id = NEW.org_id);
			
			IF(v_org_sufix is null)THEN v_org_sufix := ''; END IF;

			NEW.entity_id := nextval('entitys_entity_id_seq');

			IF(NEW.employee_id is null) THEN
				NEW.employee_id := NEW.entity_id;
			END IF;
			
			SELECT entity_type_id INTO v_entity_type_id
			FROM entity_types 
			WHERE (org_id = NEW.org_id) AND (use_key_id = 1);

			v_first_password := first_password();
			v_user_name := lower(v_org_sufix || '.' || NEW.First_name || '.' || NEW.Surname);

			SELECT count(entity_id) INTO v_user_count
			FROM entitys
			WHERE (org_id = NEW.org_id) AND (user_name = v_user_name);
			IF(v_user_count > 0) THEN v_user_name := v_user_name || v_user_count::varchar; END IF;

			INSERT INTO entitys (entity_id, org_id, entity_type_id, use_key_id,
				entity_name, user_name, primary_email, function_role, 
				first_password, entity_password)
			VALUES (NEW.entity_id, NEW.org_id, v_entity_type_id, 1, 
				(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
				v_user_name, NEW.employee_email, 'staff',
				v_first_password, md5(v_first_password));
				
			INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name, email_type)
			SELECT org_id, sys_email_id, NEW.entity_id, 'entitys', 1
			FROM sys_emails
			WHERE (use_type = 3) AND (org_id = NEW.org_id);
		END IF;

		v_use_type := 2;
		IF(NEW.gender = 'M')THEN v_use_type := 3; END IF;

		--- Add default leave types
		INSERT INTO employee_leave_types (entity_id, org_id, leave_type_id, leave_balance)
		SELECT NEW.entity_id, NEW.org_id, leave_type_id, 0
		FROM leave_types
		WHERE (org_id = NEW.org_id) AND ((use_type = 1) OR (use_type = v_use_type));
		
		--- Add default task rate definations
		INSERT INTO task_entitys (entity_id, org_id, task_type_id, task_entity_cost, task_entity_price)
		SELECT NEW.entity_id, NEW.org_id, task_type_id, default_cost, default_price
		FROM task_types
		WHERE (org_id = NEW.org_id);
	
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
			primary_email = NEW.employee_email
		WHERE entity_id = NEW.entity_id;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

