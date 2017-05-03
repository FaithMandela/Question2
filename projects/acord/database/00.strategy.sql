CREATE TABLE strategic_goal_types (
	strategic_goal_type_id		serial primary key,
	org_id						integer references orgs,
	strategic_goal_type_name	varchar(20) not null unique,
	description					text
);

CREATE TABLE strategic_goal_categorys (
	strategic_goal_category_id	 	serial primary key,
	strategic_goal_type_id			integer references strategic_goal_types,
	org_id						 	integer references orgs,
	strategic_goal_category_name	varchar(120) not null unique,
	description						text
);

CREATE TABLE objectives (
	objectives_id					serial primary key,
	strategic_goal_category_id		integer references strategic_goal_categorys,
	org_id							integer references orgs,
	objective_name					varchar(150) not null unique,
	description						text,
	details 						text
);

INSERT INTO strategic_goal_types (strategic_goal_type_id, org_id, strategic_goal_type_name) VALUES (1, 0, 'Customers');
INSERT INTO strategic_goal_types (strategic_goal_type_id, org_id, strategic_goal_type_name) VALUES (2, 0, 'Finance');
INSERT INTO strategic_goal_types (strategic_goal_type_id, org_id, strategic_goal_type_name) VALUES (3, 0, 'Operational');
INSERT INTO strategic_goal_types (strategic_goal_type_id, org_id, strategic_goal_type_name) VALUES (4, 0, 'Learning');

