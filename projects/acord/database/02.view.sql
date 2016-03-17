
CREATE VIEW vw_donors AS
	SELECT donor_groups.donor_group_id, donor_groups.donor_group_name, 
		sys_countrys.sys_country_id, sys_countrys.sys_country_name, 
		donors.org_id, donors.donor_id, donors.donor_name, donors.legal_status, 
		donors.address, donors.telephone, donors.fax, donors.email, donors.skype, 
		donors.contact_person, donors.contact_person_title, donors.physical_address, 
		donors.website, donors.social_media_links, donors.details
	FROM donors INNER JOIN donor_groups ON donors.donor_group_id = donor_groups.donor_group_id
		INNER JOIN sys_countrys ON donors.nationality_id = sys_countrys.sys_country_id;

CREATE VIEW vw_targets AS
	SELECT goals.goal_id, goals.goal_name, 
		targets.org_id, targets.target_id, targets.target_name, targets.details
	FROM targets INNER JOIN goals ON targets.goal_id = goals.goal_id;
	
CREATE VIEW vw_project_locations AS
	SELECT projects.project_id, projects.project_title, 
		sys_countrys.sys_country_id, sys_countrys.sys_country_name, 
		project_locations.org_id, project_locations.project_location_id, project_locations.region_covered, 
		project_locations.details
	FROM project_locations INNER JOIN projects ON project_locations.project_id = projects.project_id
		INNER JOIN sys_countrys ON project_locations.sys_country_id = sys_countrys.sys_country_id;
		
CREATE VIEW vw_project_goals AS
	SELECT goals.goal_id, goals.goal_name, 
		projects.project_id, projects.project_title, 
		project_goals.org_id, project_goals.project_goal_id, project_goals.goal_ps, project_goals.details
	FROM project_goals INNER JOIN goals ON project_goals.goal_id = goals.goal_id
		INNER JOIN projects ON project_goals.project_id = projects.project_id;

CREATE VIEW vw_goal_targets AS
	SELECT vw_targets.goal_id, vw_targets.goal_name, 
		vw_targets.target_id, vw_targets.target_name, 
		project_goals.org_id, project_goals.project_goal_id, project_goals.goal_ps,
		project_goals.project_id
	FROM project_goals INNER JOIN vw_targets ON project_goals.goal_id = vw_targets.goal_id;
		
CREATE VIEW vw_project_targets AS
	SELECT vw_project_goals.goal_id, vw_project_goals.goal_name, 
		vw_project_goals.project_id, vw_project_goals.project_title,
		vw_project_goals.project_goal_id, vw_project_goals.goal_ps,
		targets.target_id, targets.target_name, 
		
		project_targets.org_id, project_targets.project_targets_id, project_targets.project_targets_name, 
		project_targets.detscription
	FROM project_targets INNER JOIN vw_project_goals ON project_targets.project_goal_id = vw_project_goals.project_goal_id
		INNER JOIN targets ON project_targets.target_id = targets.target_id;
		
CREATE VIEW vw_contracts AS
	SELECT projects.project_id, projects.project_title,
		donors.donor_id, donors.donor_name,
		currency.currency_id, currency.currency_name, 
		contracts.org_id, contracts.contract_id, contracts.application_ref, contracts.core_fund, 
		contracts.percentage_levy, contracts.contract_ref, contracts.decision_date, contracts.contract_date, 
		contracts.start_of_grant, contracts.end_of_grant, contracts.conditions, contracts.notes, contracts.subject, 
		contracts.financing, contracts.reporting, contracts.operation, contracts.general_conditions, 
		contracts.special_conditions, contracts.details
	FROM contracts INNER JOIN projects ON contracts.project_id = projects.project_id
		INNER JOIN donors ON contracts.donor_id = donors.donor_id
		INNER JOIN currency ON contracts.currency_id = currency.currency_id;
		
CREATE VIEW vw_proposals AS
	SELECT projects.project_id, projects.project_title,
		donors.donor_id, donors.donor_name,
		proposal_status.proposal_status_id, proposal_status.proposal_status_name, 
		proposals.org_id, proposals.proposal_id, proposals.start_date, proposals.description, 
		proposals.location, proposals.proposal_submit_date, proposals.email, proposals.approved, 
		proposals.dropped, proposals.budget, proposals.proposal, proposals.details
	FROM proposals INNER JOIN projects ON proposals.project_id = projects.project_id
		INNER JOIN donors ON proposals.donor_id = donors.donor_id
		INNER JOIN proposal_status ON proposals.proposal_status_id = proposal_status.proposal_status_id;

CREATE VIEW vw_activities AS
	SELECT projects.project_id, projects.project_title, 
		activities.org_id, activities.activity_id, activities.activity, activities.activity_start_date, 
		activities.activity_close_date, activities.details
	FROM activities INNER JOIN projects ON activities.project_id = projects.project_id;
	
CREATE VIEW vw_grants AS
	SELECT vw_contracts.project_id, vw_contracts.project_title,
		vw_contracts.donor_id, vw_contracts.donor_name,
		vw_contracts.currency_id, vw_contracts.currency_name, 
		vw_contracts.contract_id, vw_contracts.application_ref, vw_contracts.core_fund, 
		vw_contracts.percentage_levy, vw_contracts.contract_ref, vw_contracts.decision_date, vw_contracts.contract_date, 
		vw_contracts.start_of_grant, vw_contracts.end_of_grant, vw_contracts.conditions, vw_contracts.notes, vw_contracts.subject, 
		vw_contracts.financing, vw_contracts.reporting, vw_contracts.operation, vw_contracts.general_conditions, 
		vw_contracts.special_conditions, 
		grants.org_id, grants.grant_id, grants.grant_amount, grants.grant_pr_date, grants.details
	FROM grants INNER JOIN vw_contracts ON grants.contract_id = vw_contracts.contract_id;

CREATE VIEW vw_budget AS
	SELECT projects.project_id, projects.project_title,
		budget_type.budget_type_id, budget_type.budget_type_name, 
		currency.currency_id, currency.currency_name, 
		budget.org_id, budget.budget_id, budget.global_amount, budget.field_amount, budget.exchange_rate,
		budget.get_by_date, budget.spend_by_date, budget.details,
		(budget.global_amount * budget.exchange_rate) as base_global_amount,
		(budget.field_amount * budget.exchange_rate) as base_field_amount
	FROM budget INNER JOIN projects ON budget.project_id = projects.project_id
		INNER JOIN budget_type ON budget.budget_type_id = budget_type.budget_type_id
		INNER JOIN currency ON budget.currency_id = currency.currency_id;
		
CREATE VIEW vw_expenditure AS
	SELECT projects.project_id, projects.project_title,
		currency.currency_id, currency.currency_name, 
		expenditure.org_id, expenditure.expenditure_id, 
		expenditure.amount, expenditure.exchange_rate, expenditure.pr_date, expenditure.details,
		(expenditure.amount * expenditure.exchange_rate) as base_amount
	FROM expenditure INNER JOIN projects ON expenditure.project_id = projects.project_id
		INNER JOIN currency ON expenditure.currency_id = currency.currency_id;
		
---TOC
CREATE VIEW vw_problems AS
	SELECT projects.project_id, projects.project_title, 
		problems.org_id, problems.problem_id, problems.narrative, problems.details
	FROM problems INNER JOIN projects ON problems.project_id = projects.project_id;



CREATE VIEW vw_interventions AS
	SELECT vw_problems .project_id, vw_problems.project_title,
		vw_problems.problem_id, vw_problems.narrative as problem_narrative, vw_problems.details as problem_details, 
		interventions.org_id, interventions.intervention_id, interventions.narrative, interventions.details
	FROM interventions INNER JOIN vw_problems ON interventions.problem_id = vw_problems.problem_id;



CREATE VIEW vw_outputs AS
	SELECT vw_interventions .project_id, vw_interventions.project_title,
		vw_interventions.problem_id, vw_interventions.problem_narrative, vw_interventions.problem_details, 
		vw_interventions.org_id, vw_interventions.intervention_id, vw_interventions.narrative as interventions_narrative, vw_interventions.details as interventions_details,
		outputs.output_id, outputs.narrative, outputs.details
	FROM outputs INNER JOIN vw_interventions ON outputs.intervention_id = vw_interventions.intervention_id;



CREATE VIEW vw_final_outcomes AS
	SELECT goals.goal_id, goals.goal_name, 
	final_outcomes.org_id,final_outcomes.final_outcome_id, final_outcomes.narrative, final_outcomes.details
	FROM final_outcomes
	INNER JOIN goals ON final_outcomes.goal_id = goals.goal_id;



CREATE VIEW vw_intermediate_outcome AS
		SELECT vw_final_outcomes.goal_id, vw_final_outcomes.goal_name,vw_final_outcomes.org_id, vw_final_outcomes.final_outcome_id,
		vw_final_outcomes.narrative as final_outcome_narrative, vw_final_outcomes.details as final_outcome_details
		
		,intermediate_outcome.intermediate_outcome, intermediate_outcome.narrative, intermediate_outcome.details,

		vw_outputs.project_id, vw_outputs.project_title,
		vw_outputs.problem_id, vw_outputs.problem_narrative, vw_outputs.problem_details, 
		vw_outputs.intervention_id, vw_outputs.interventions_narrative, vw_outputs.interventions_details,
		vw_outputs.output_id, vw_outputs.narrative as ouput_narrative, vw_outputs.details as output_details
	
	FROM intermediate_outcome
	INNER JOIN vw_final_outcomes ON intermediate_outcome.final_outcome_id = vw_final_outcomes.final_outcome_id
	INNER JOIN vw_outputs ON vw_final_outcomes.org_id= vw_outputs.org_id;
	
	

CREATE VIEW vw_indicators AS
	SELECT projects.project_id, projects.project_title, 
		indicators.org_id, indicators.indicator_id, indicators.key_indictors, indicators.baseline_values, 
		indicators.date_source, indicators.data_collection_method, indicators.frequency_of_collection, 
		indicators.impact, indicators.leassons_learnt, indicators.action_acquired, indicators.quality_of_action, 
		indicators.details
	FROM indicators	INNER JOIN projects ON indicators.project_id = projects.project_id;
