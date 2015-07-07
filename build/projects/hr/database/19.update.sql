

ALTER TABLE workflow_phases ADD reporting_level			integer default 1 not null;

ALTER TABLE reporting ADD 	reporting_level			integer default 1 not null;


DROP VIEW vw_periods CASCADE;
CREATE VIEW vw_periods AS
	SELECT fiscal_years.fiscal_year_id, fiscal_years.fiscal_year_start, fiscal_years.fiscal_year_end,
		fiscal_years.year_opened, fiscal_years.year_closed,

		periods.period_id, periods.org_id, 
		periods.start_date, periods.end_date, periods.opened, periods.activated, periods.closed, 
		periods.overtime_rate, periods.per_diem_tax_limit, periods.is_posted, periods.bank_header, 
		periods.gl_payroll_account, periods.gl_bank_account, periods.bank_address, periods.details,

		date_part('month', periods.start_date) as month_id, to_char(periods.start_date, 'YYYY') as period_year, 
		to_char(periods.start_date, 'Month') as period_month, (trunc((date_part('month', periods.start_date)-1)/3)+1) as quarter, 
		(trunc((date_part('month', periods.start_date)-1)/6)+1) as semister,
		to_char(periods.start_date, 'YYYYMM') as period_code
	FROM periods LEFT JOIN fiscal_years ON periods.fiscal_year_id = fiscal_years.fiscal_year_id
	ORDER BY periods.start_date;

CREATE VIEW vw_period_year AS
	SELECT org_id, period_year
	FROM vw_periods
	GROUP BY org_id, period_year
	ORDER BY period_year;

CREATE VIEW vw_period_quarter AS
	SELECT org_id, quarter
	FROM vw_periods
	GROUP BY org_id, quarter
	ORDER BY quarter;

CREATE VIEW vw_period_semister AS
	SELECT org_id, semister
	FROM vw_periods
	GROUP BY org_id, semister
	ORDER BY semister;

CREATE VIEW vw_period_month AS
	SELECT org_id, month_id, period_year, period_month
	FROM vw_periods
	GROUP BY org_id, month_id, period_year, period_month
	ORDER BY month_id, period_year, period_month;

DROP VIEW vw_workflow_phases CASCADE;
CREATE VIEW vw_workflow_phases AS
	SELECT vw_workflows.source_entity_id, vw_workflows.source_entity_name, vw_workflows.workflow_id, 
		vw_workflows.workflow_name, vw_workflows.table_name, vw_workflows.table_link_field, vw_workflows.table_link_id, 
		vw_workflows.approve_email, vw_workflows.reject_email, vw_workflows.approve_file, vw_workflows.reject_file,
		entity_types.entity_type_id as approval_entity_id, entity_types.entity_type_name as approval_entity_name, 
		workflow_phases.workflow_phase_id, workflow_phases.org_id, workflow_phases.approval_level, 
		workflow_phases.return_level, workflow_phases.escalation_days, workflow_phases.escalation_hours, 
		workflow_phases.notice, workflow_phases.notice_email, workflow_phases.notice_file,
		workflow_phases.advice, workflow_phases.advice_email, workflow_phases.advice_file,
		workflow_phases.required_approvals, workflow_phases.use_reporting, workflow_phases.reporting_level,
		workflow_phases.phase_narrative, workflow_phases.details
	FROM (workflow_phases INNER JOIN vw_workflows ON workflow_phases.workflow_id = vw_workflows.workflow_id)
		INNER JOIN entity_types ON workflow_phases.approval_entity_id = entity_types.entity_type_id;

CREATE VIEW vw_workflow_entitys AS
	SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.org_id, vw_workflow_phases.workflow_name, vw_workflow_phases.table_name,
		vw_workflow_phases.table_link_id, vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name, 
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level, 
		vw_workflow_phases.return_level, vw_workflow_phases.escalation_days, vw_workflow_phases.escalation_hours, 
		vw_workflow_phases.notice, vw_workflow_phases.notice_email, vw_workflow_phases.notice_file,
		vw_workflow_phases.advice, vw_workflow_phases.advice_email, vw_workflow_phases.advice_file,
		vw_workflow_phases.required_approvals, vw_workflow_phases.use_reporting, vw_workflow_phases.phase_narrative, 
		entity_subscriptions.entity_subscription_id, entity_subscriptions.entity_id, entity_subscriptions.subscription_level_id
	FROM vw_workflow_phases INNER JOIN entity_subscriptions ON vw_workflow_phases.source_entity_id = entity_subscriptions.entity_type_id;

CREATE VIEW vw_approvals AS
	SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.workflow_name, 
		vw_workflow_phases.approve_email, vw_workflow_phases.reject_email,
		vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name,
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level, vw_workflow_phases.phase_narrative,
		vw_workflow_phases.return_level, vw_workflow_phases.required_approvals, 
		vw_workflow_phases.notice, vw_workflow_phases.notice_email, vw_workflow_phases.notice_file,
		vw_workflow_phases.advice, vw_workflow_phases.advice_email, vw_workflow_phases.advice_file,
		approvals.approval_id, approvals.org_id, approvals.forward_id, approvals.table_name, approvals.table_id,
		approvals.completion_date, approvals.escalation_days, approvals.escalation_hours,
		approvals.escalation_time, approvals.application_date, approvals.approve_status, approvals.action_date,
		approvals.approval_narrative, approvals.to_be_done, approvals.what_is_done, approvals.review_advice, approvals.details,
		oe.entity_id as org_entity_id, oe.entity_name as org_entity_name, oe.user_name as org_user_name, oe.primary_email as org_primary_email,
		ae.entity_id as app_entity_id, ae.entity_name as app_entity_name, ae.user_name as app_user_name, ae.primary_email as app_primary_email
	FROM (vw_workflow_phases INNER JOIN approvals ON vw_workflow_phases.workflow_phase_id = approvals.workflow_phase_id)
		INNER JOIN entitys as oe ON approvals.org_entity_id = oe.entity_id
		LEFT JOIN entitys as ae ON approvals.app_entity_id = ae.entity_id;

CREATE VIEW vw_workflow_approvals AS
	SELECT vw_approvals.workflow_id, vw_approvals.org_id, vw_approvals.workflow_name, vw_approvals.approve_email, 
		vw_approvals.reject_email, vw_approvals.source_entity_id, vw_approvals.source_entity_name, vw_approvals.table_name, 
		vw_approvals.table_id, vw_approvals.org_entity_id, vw_approvals.org_entity_name, vw_approvals.org_user_name, 
		vw_approvals.org_primary_email, rt.rejected_count,
		(CASE WHEN rt.rejected_count is null THEN vw_approvals.workflow_name || ' Approved'
			ELSE vw_approvals.workflow_name || ' declined' END) as workflow_narrative
	FROM vw_approvals LEFT JOIN 
		(SELECT table_id, count(approval_id) as rejected_count FROM approvals WHERE (approve_status = 'Rejected') AND (approvals.forward_id is null)
		GROUP BY table_id) as rt ON vw_approvals.table_id = rt.table_id
	GROUP BY vw_approvals.workflow_id, vw_approvals.org_id, vw_approvals.workflow_name, vw_approvals.approve_email, 
		vw_approvals.reject_email, vw_approvals.source_entity_id, vw_approvals.source_entity_name, vw_approvals.table_name, 
		vw_approvals.table_id, vw_approvals.org_entity_id, vw_approvals.org_entity_name, vw_approvals.org_user_name, 
		vw_approvals.org_primary_email, rt.rejected_count;

CREATE VIEW vw_approvals_entitys AS
	(SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.workflow_name, 
		vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name,
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level,
		vw_workflow_phases.notice, vw_workflow_phases.notice_email, vw_workflow_phases.notice_file,
		vw_workflow_phases.advice, vw_workflow_phases.advice_email, vw_workflow_phases.advice_file,
		vw_workflow_phases.return_level, vw_workflow_phases.required_approvals, vw_workflow_phases.phase_narrative,
		approvals.approval_id, approvals.org_id, approvals.forward_id, approvals.table_name, approvals.table_id,
		approvals.completion_date, approvals.escalation_days, approvals.escalation_hours,
		approvals.escalation_time, approvals.application_date, approvals.approve_status, approvals.action_date,
		approvals.approval_narrative, approvals.to_be_done, approvals.what_is_done, approvals.review_advice, approvals.details,
		oe.entity_id as org_entity_id, oe.entity_name as org_entity_name, oe.user_name as org_user_name, oe.primary_email as org_primary_email,
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.primary_email
	FROM ((vw_workflow_phases INNER JOIN approvals ON vw_workflow_phases.workflow_phase_id = approvals.workflow_phase_id)
		INNER JOIN entitys as oe  ON approvals.org_entity_id = oe.entity_id)
		INNER JOIN entity_subscriptions ON vw_workflow_phases.approval_entity_id = entity_subscriptions.entity_type_id
		INNER JOIN entitys ON entity_subscriptions.entity_id = entitys.entity_id
	WHERE (approvals.forward_id is null) AND (vw_workflow_phases.use_reporting = false))
	UNION
	(SELECT vw_workflow_phases.workflow_id, vw_workflow_phases.workflow_name, 
		vw_workflow_phases.source_entity_id, vw_workflow_phases.source_entity_name, 
		vw_workflow_phases.approval_entity_id, vw_workflow_phases.approval_entity_name,
		vw_workflow_phases.workflow_phase_id, vw_workflow_phases.approval_level,
		vw_workflow_phases.notice, vw_workflow_phases.notice_email, vw_workflow_phases.notice_file,
		vw_workflow_phases.advice, vw_workflow_phases.advice_email, vw_workflow_phases.advice_file,
		vw_workflow_phases.return_level, vw_workflow_phases.required_approvals, vw_workflow_phases.phase_narrative,
		approvals.approval_id, approvals.org_id, approvals.forward_id, approvals.table_name, approvals.table_id,
		approvals.completion_date, approvals.escalation_days, approvals.escalation_hours,
		approvals.escalation_time, approvals.application_date, approvals.approve_status, approvals.action_date,
		approvals.approval_narrative, approvals.to_be_done, approvals.what_is_done, approvals.review_advice, approvals.details,
		oe.entity_id as org_entity_id, oe.entity_name as org_entity_name, oe.user_name as org_user_name, oe.primary_email as org_primary_email,
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.primary_email
	FROM ((vw_workflow_phases INNER JOIN approvals ON vw_workflow_phases.workflow_phase_id = approvals.workflow_phase_id)
		INNER JOIN entitys as oe  ON approvals.org_entity_id = oe.entity_id)
		INNER JOIN reporting ON ((approvals.org_entity_id = reporting.entity_id)
			AND (vw_workflow_phases.reporting_level = reporting.reporting_level))
		INNER JOIN entitys ON reporting.report_to_id = entitys.entity_id
	WHERE (approvals.forward_id is null) AND (reporting.primary_report = true) AND (reporting.is_active = true)
		AND (vw_workflow_phases.use_reporting = true));

CREATE TABLE contract_status (
	contract_status_id		serial primary key,
	org_id					integer references orgs,
	contract_status_name	varchar(50) not null,
	details					text
);
CREATE INDEX contract_status_org_id ON contract_status(org_id);

ALTER TABLE applications ADD contract_status_id		integer references contract_status;
CREATE INDEX applications_contract_status_id ON applications (contract_status_id);

INSERT INTO contract_status (contract_status_id, org_id, contract_status_name) VALUES (0, 0, 'Active');
UPDATE applications SET contract_status_id = 0;
		
DROP VIEW vw_contracting;

CREATE VIEW vw_contracting AS
	SELECT vw_intake.department_id, vw_intake.department_name, vw_intake.department_description, vw_intake.department_duties,
		vw_intake.department_role_id, vw_intake.department_role_name, vw_intake.job_description, 
		vw_intake.job_requirements, vw_intake.duties, vw_intake.performance_measures, 
		vw_intake.intake_id, vw_intake.opening_date, vw_intake.closing_date, vw_intake.positions, 
		entitys.entity_id, entitys.entity_name, 
		
		contract_types.contract_type_id, contract_types.contract_type_name,
		contract_status.contract_status_id, contract_status.contract_status_name,
		
		applications.application_id, applications.employee_id, applications.contract_date, applications.contract_close, 
		applications.contract_start, applications.contract_period, applications.contract_terms, applications.initial_salary, 
		applications.application_date, applications.approve_status, applications.workflow_table_id, applications.action_date, 
		applications.applicant_comments, applications.review, applications.org_id,

		vw_education_max.education_class_name, vw_education_max.date_from, vw_education_max.date_to, 
		vw_education_max.name_of_school, vw_education_max.examination_taken, 
		vw_education_max.grades_obtained, vw_education_max.certificate_number,

		vw_employment_max.employment_id, vw_employment_max.employers_name, vw_employment_max.position_held,
		vw_employment_max.date_from as emp_date_from, vw_employment_max.date_to as emp_date_to, 
		
		vw_employment_max.employment_duration, vw_employment_max.employment_experince,
		round((date_part('year', vw_employment_max.employment_duration) + date_part('month', vw_employment_max.employment_duration)/12)::numeric, 1) as emp_duration,
		round((date_part('year', vw_employment_max.employment_experince) + date_part('month', vw_employment_max.employment_experince)/12)::numeric, 1) as emp_experince

	FROM applications INNER JOIN entitys ON applications.employee_id = entitys.entity_id
		LEFT JOIN vw_intake ON applications.intake_id = vw_intake.intake_id
		LEFT JOIN contract_types ON applications.contract_type_id = contract_types.contract_type_id
		LEFT JOIN contract_status ON applications.contract_status_id = contract_status.contract_status_id
		LEFT JOIN vw_education_max ON entitys.entity_id = vw_education_max.entity_id
		LEFT JOIN vw_employment_max ON entitys.entity_id = vw_employment_max.entity_id;
