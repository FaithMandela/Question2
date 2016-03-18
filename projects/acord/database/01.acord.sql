

CREATE TABLE donor_groups (
	donor_group_id			serial primary key,
	org_id					integer references orgs,
	donor_group_name		varchar(50) not null,
	details					text
);
CREATE INDEX donor_groups_org_id ON donor_groups (org_id);

CREATE TABLE donors (
	donor_id				varchar(12) primary key,
	donor_group_id			integer references donor_groups,
	nationality_id			varchar(2)references sys_countrys,
	org_id					integer references orgs,
	donor_name				varchar(50) not null,
	legal_status			varchar (120),
	address					varchar(120),
	telephone				varchar(120),
	fax						varchar(120),
	email					varchar(120),
	skype					varchar(120),
	contact_person			varchar(120),
	contact_person_title	varchar(120),
	physical_address		varchar(120),
	website					varchar(120),
	social_media_links		text,
	details					text
);
CREATE INDEX donors_donor_group_id ON donors (donor_group_id);
CREATE INDEX donors_nationality_id ON donors (nationality_id);
CREATE INDEX donors_org_id ON donors (org_id);

CREATE TABLE goals (
	goal_id 				serial primary key,
	org_id					integer references orgs,
	goal_name				varchar(50),
	details					text
);
CREATE INDEX goals_org_id ON goals (org_id);

CREATE TABLE targets (
	target_id				serial primary key,
	goal_id 				integer references goals,
	org_id					integer references orgs,
	target_name				varchar(50),
	details					text
);
CREATE INDEX targets_goal_id ON targets (goal_id);
CREATE INDEX targets_org_id ON targets (org_id);

CREATE TABLE projects (
	project_id				varchar(12) primary key,
	org_id					integer references orgs,
	project_title			varchar(50) not null,
	project_start_date		date,
	project_duration		integer,
	project_reference		varchar(50),
	total_budget			real,
	objectives				text,
	target_groups			text,
	final_beneficiaries		text,
	estimated_results		text,
	main_activities			text,
	notes					text
);
CREATE INDEX projects_org_id ON projects (org_id);

CREATE TABLE project_locations (
	project_location_id		serial primary key,
	project_id 				varchar(12) references projects,
	sys_country_id			varchar(2)references sys_countrys,
	org_id					integer references orgs,
	region_covered			text,
	details					text
);
CREATE INDEX project_locations_project_id ON project_locations (project_id);
CREATE INDEX project_locations_sys_country_id ON project_locations (sys_country_id);
CREATE INDEX project_locations_org_id ON project_locations (org_id);

CREATE TABLE project_goals (
	project_goal_id 		serial primary key,
	project_id 				varchar(12) references projects,
	goal_id					integer references goals,
	org_id					integer references orgs,
	goal_ps					real,
	details					text
);
CREATE INDEX project_goals_goal_id ON project_goals (goal_id);
CREATE INDEX project_goals_project_id ON project_goals (project_id);
CREATE INDEX project_goals_org_id ON project_goals (org_id);

CREATE TABLE project_targets (
	project_targets_id		serial primary key,
	project_goal_id			integer references project_goals,
	target_id				integer references targets,
	org_id					integer references orgs,
	project_targets_name	varchar(50),
	detscription			text
);
CREATE INDEX project_targets_project_goal_id ON project_targets (project_goal_id);
CREATE INDEX project_targets_target_id ON project_targets (target_id);
CREATE INDEX project_targets_org_id ON project_targets (org_id);

CREATE TABLE contracts (
	contract_id				varchar(12) primary key,
	project_id				varchar(12) references projects,
	donor_id               	varchar(12) references donors,
	currency_id				integer references currency,
	org_id					integer references orgs,
	application_ref			varchar(50),
	core_fund				boolean,
	percentage_levy			real,
	contract_ref			varchar(50),
	decision_date			date,
	contract_date			date,
	start_of_grant			date,
	end_of_grant			date,
	conditions				text,
	notes					text,
	subject					text,
	financing				text,
	reporting				text,
	operation				text,
	general_conditions		text,
	special_conditions		text,
	details					text
);
CREATE INDEX contracts_project_id ON contracts (project_id);
CREATE INDEX contracts_donor_id ON contracts (donor_id);
CREATE INDEX contracts_currency_id ON contracts (currency_id);
CREATE INDEX contracts_org_id ON contracts (org_id);

CREATE TABLE proposal_status (
	proposal_status_id		serial primary key,
	org_id					integer references orgs,
	proposal_status_name	varchar(50) not null,
	details					text
);
CREATE INDEX proposal_status_org_id ON proposal_status (org_id);

CREATE TABLE proposals (
	proposal_id				serial primary key,
	project_id				varchar(12) references projects,
	donor_id				varchar(12) references donors,
	proposal_status_id		integer references proposal_status,
	org_id					integer references orgs,
	start_date				date,
	description				varchar(240),
	location				varchar(240),
	proposal_submit_date	date,
	email					varchar(120),
	approved				boolean,
	dropped					boolean,
	budget					real,
	proposal				text,
	details					text
);
CREATE INDEX proposals_project_id ON proposals (project_id);
CREATE INDEX proposals_donor_id ON proposals (donor_id);
CREATE INDEX proposals_proposal_status_id ON proposals (proposal_status_id);
CREATE INDEX proposals_org_id ON proposals (org_id);

CREATE TABLE activities (
	activity_id				serial primary key,
	project_id				varchar(12) references projects,
	org_id					integer references orgs,
	activity				varchar(50) not null,
	activity_start_date		date,
	activity_close_date		date,
	details                	text
);
CREATE INDEX activities_project_id ON activities (project_id);
CREATE INDEX activities_org_id ON activities (org_id);

CREATE TABLE grants (
	grant_id				serial primary key,
	contract_id				varchar(12) references contracts,
	org_id					integer references orgs,
	grant_amount			real,
	grant_pr_date			date,
	details					text
);
CREATE INDEX grants_contract_id ON grants (contract_id);
CREATE INDEX grants_org_id ON grants (org_id);

CREATE TABLE budget_type (
	budget_type_id			serial primary key,
	org_id					integer references orgs,
	budget_type_name		varchar(60),
	narrative				text
);
CREATE INDEX budget_type_org_id ON budget_type (org_id);

CREATE TABLE budget (
	budget_id				serial primary key,
	project_id				varchar(12) references projects,
	budget_type_id			integer references budget_type,
	currency_id				integer references currency,
	org_id					integer references orgs,
	global_amount         	real,
	field_amount			real not null,
	get_by_date				date,
	spend_by_date			date not null,
   	exchange_rate			real default 1 not null,
	details					text
);
CREATE INDEX budget_project_id ON budget (project_id);
CREATE INDEX budget_budget_type_id ON budget (budget_type_id);
CREATE INDEX budget_currency_id ON budget (currency_id);
CREATE INDEX budget_org_id ON budget (org_id);

CREATE TABLE expenditure (
	expenditure_id     	    serial primary key,
   	project_id    		   	varchar(12) references projects,
   	currency_id				integer references currency,
	org_id					integer references orgs,
   	amount             		real not null,
   	exchange_rate			real default 1 not null,
	pr_date					date,
   	details            		text
);
CREATE INDEX expenditure_project_id ON expenditure (project_id);
CREATE INDEX expenditure_currency_id ON expenditure (currency_id);
CREATE INDEX expenditure_org_id ON expenditure (org_id);


----- Theory of change

CREATE TABLE problems (
    problem_id              serial primary key,    
   	project_id    		   	varchar(12) references projects,
	org_id					integer references orgs,
    narrative               varchar(320),
	
	details            		text
);
CREATE INDEX problems_project_id ON problems (project_id);
CREATE INDEX problems_org_id ON problems (org_id);

CREATE TABLE interventions (
    intervention_id         serial primary key,
    problem_id    		   	integer references problems,
    org_id					integer references orgs,
    narrative               varchar(320),

    details            		text
    
);
CREATE INDEX interventions_problem_id ON interventions (problem_id);
CREATE INDEX interventions_org_id ON interventions (org_id);


CREATE TABLE outputs (
    output_id               serial primary key,
    intervention_id         integer references interventions,
    org_id					integer references orgs,
    narrative               varchar(320),
    details            		text
);
CREATE INDEX outputs_intervention_id ON outputs (intervention_id);
CREATE INDEX outputs_org_id ON outputs (org_id);

CREATE TABLE final_outcomes(
    final_outcome_id        serial primary key,
    goal_id                 integer references goals,
    org_id					integer references orgs,
    narrative               varchar(320),
    details            		text
);
CREATE INDEX final_outcomes_goal_id ON final_outcomes (goal_id);
CREATE INDEX final_outcomes_org_id ON final_outcomes (org_id);


CREATE TABLE intermediate_outcome(
    intermediate_outcome    serial primary key,
    final_outcome_id        integer references final_outcomes,
    output_id               integer references outputs,
    org_id					integer references orgs,
    narrative               varchar(320),
    details            		text
    );
CREATE INDEX intermediate_outcome_final_outcome_id ON intermediate_outcome (final_outcome_id);
CREATE INDEX intermediate_outcome_org_id ON intermediate_outcome (org_id);
CREATE INDEX intermediate_outcome_output_id ON intermediate_outcome (output_id);

 CREATE TABLE indicators(
    indicator_id                serial primary key,
    project_id                  varchar references projects,
    org_id                      integer references orgs,
    
    key_indictors               varchar(120),
    baseline_values             varchar(320),
    date_source                 date,
    data_collection_method      varchar(320),
    frequency_of_collection    varchar(320),
    impact                      varchar(320),
    leassons_learnt             varchar(320),
    action_acquired             varchar(320),
    quality_of_action           varchar(320),
    details                     text
 );
CREATE INDEX indicators_project_id ON indicators (project_id);
CREATE INDEX indicators_org_id ON indicators (org_id);


