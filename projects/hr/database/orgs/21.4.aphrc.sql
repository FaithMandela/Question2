

CREATE TABLE travel_types (
	travel_type_id			serial primary key,
	org_id					integer references orgs,
	travel_type_name		varchar(50),
	details					text
);
CREATE INDEX travel_types_org_id ON travel_types(org_id);


INSERT INTO travel_types (org_id, travel_type_name) VALUES
(0, 'Conference'),
(0, 'Site Conference'),
(0, 'Site Visit'),
(0, 'Seminar'),
(0, 'Workshop'),
(0, 'Training'),
(0, 'Official duty'),
(0, 'Fieldwork'),
(0, 'Home Leave'),
(0, 'PhD Study');

INSERT INTO travel_funding (org_id, travel_funding_name, require_details) VALUES
(0, 'APHRC Core', false),
(0, 'APHRC Project (Specify)', true),
(0, 'Other Institution (specify)', true),
(0, 'Partly personal (specify)', true);

