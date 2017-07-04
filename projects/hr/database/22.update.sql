

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

INSERT INTO workflow_sql (workflow_sql_id, workflow_phase_id, org_id, workflow_sql_name, is_condition, is_action, message, sql) VALUES (2, 13, 0, 'Check supervisor rating', true, false, 'Ensure you check ratings', 'SELECT (CASE WHEN job_reviews.supervisor_rating is null THEN false ELSE true END) as ans
FROM job_reviews INNER JOIN approvals ON job_reviews.workflow_table_id = approvals.table_id
WHERE approvals.approval_id = ''');
INSERT INTO workflow_sql (workflow_sql_id, workflow_phase_id, org_id, workflow_sql_name, is_condition, is_action, message, sql) VALUES (3, 13, 0, 'Check reviewer comments', true, false, 'The reviewer comments need to be added', 'SELECT (CASE WHEN job_reviews.recomendation is null THEN false ELSE true END) as ans
FROM job_reviews INNER JOIN approvals ON job_reviews.workflow_table_id = approvals.table_id
WHERE approvals.approval_id = ''');

SELECT pg_catalog.setval('workflow_sql_workflow_sql_id_seq', 3, true);



