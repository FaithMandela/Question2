
CREATE TABLE donor_groups (
	donor_group_id				serial primary key,
	donor_group_name			varchar(50) not null,
	details                		text
);

CREATE TABLE donors (
	donor_id					varchar(12) primary key,
	donor_group_id				integer references donor_groups,
	donor_name					varchar(50) not null,
	project_id					integer references projects,
	legal_status				varchar (120),
	address						varchar(120),
	telephone					varchar(120),
	fax							varchar(120),
	email						varchar(120),
	skype						varchar(120),
	contact_person				varchar(120),
	contact_person_title		varchar(120),
	visiting_address			varchar(120),
	website						VARCHAR(120),
	nationality					varchar(2)references sys_countrys,
	details						text
);
CREATE TABLE social_media_links(
   link_id   				 serial primary key,
   donor_id   				 integer references donors,
   link       				 varchar(255),
   description text

);

CREATE TABLE projects (
	project_id				serial primary key,
 	project_title			varchar(50) not null,
	project_location		varchar(50),
	donor_id				references donors,	
	donor_reference_number	varchar(50),
	activity_id             references activity,
	implementing_partners	text
);
CREATE TABLE project_documents(
	project_document_id		serial primary key,
	project_grant_agreement
	project_document
	project_budget
	project_M_E
);
CREATE TABLE project_goals (
	project_goals_id 			serial primary key,
	project_goals_name			varchar(50),
	target_groups				varchar(120),
	expected_results			varchar(120),
	main_activity				varchar(120),
	project_goals_details		text
);
create table benefeciaries(
	benefeciaries_id			serial primary key,
	project_goals_id			integer references project_goals,
	benefeciaries_name			varchar(120),
	details						text
);

CREATE TABLE proposals (
	proposal_id				serial primary key,
	project_id				references projects,
	start_date				date,
	description				varchar(240),
	location				varchar(240),
	budget					real,
	proposal				text,
	details					text
);

CREATE TABLE proposal_status (
	proposal_status_id			serial primary key,
	proposal_status				boolean default false,
	details						text
);
CREATE TABLE proposal_submissions (
	proposal_submission_id			serial primary key,
	proposal_id          			integer references proposals,
	proposal_status_id				integer references proposal_status,
	donor_id						integer references donors,
	proposal_submit_date			date,
	email							varchar(120),
	approved						boolean,
	dropped							boolean,
	details							text
);

CREATE TABLE follow_up (
	followup_id				serial primary key,
	submission_id			integer references submissions,
	submit_date_date		date,
	details					text
);




CREATE TABLE project_targets(
	project_targets_id				serial primary key,
	project_goal_id					integer references project_goals,
	project_targets_name			varchar(50),
	detscription					text
);



CREATE TABLE activities (
	activityid       	    	serial primary key,
	project_id          		integer references projects,
	activity               		varchar(50) not null,
	activity_start_date			date,
	activity_close_date			date,
	details                		text
);

CREATE TABLE contracts (
	contractid					varchar(12) primary key,
	project_id					varchar(50) references projects,
	donor_id                	varchar(50) references donors,
	application_ref				varchar(50),
	currency					varchar(12),
	core_fund					boolean,
	percentage_levy				real,
	contract_ref				varchar(50),
	decision_date				date,
	contract_date				date,
	startofgrant				date,
	end_of_grant				date,
	conditions					text,
	notes						text,
	subject						text,
	financing					text,
	reporting					text,
	operation					text,
	general_conditions			text,
	special_conditions			text,
	details						text
);
CREATE TABLE grants (
	grant_id           serial primary key,
	contract_id			integer references contracts,
	grant_amount        real,
	grant_pr_date		date,
	details            	text
);
CREATE TABLE budget_type(
	budget_type_id					serial primary key,
	budget_type_name				varchar(60),
	narrative						text
);
CREATE TABLE budget (
	budget_id            			serial primary key,
	project_id           			varchar(50) references projects,
	budget_type          			integer references budget_type,
	global_amount         			real,
	field_amount					real,
	get_by_date            			date,
	spend_by_date          			date,
	details              			text
);

CREATE TABLE expenditure (
	expenditure_id     	    serial primary key,
   	project_id    		   	varchar(50) references projects,
	budget_id   			integer references budgets,
   	amount             		real,
	prdate					date,
   	details            		text
);
create table requirements(
	requirements_id		serial primary key,
	donor_id  			integer references references donor
	legal_registration_document,
	evaluation,	
				
);

