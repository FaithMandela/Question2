

CREATE TABLE travel_types (
	travel_type_id			serial primary key,
	org_id					integer references orgs,
	travel_type_name		varchar(50),
	details					text
);
CREATE INDEX travel_types_org_id ON travel_types(org_id);

DELETE FROM travel_types;
SELECT pg_catalog.setval('travel_types_travel_type_id_seq', 0, true);
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

DELETE FROM travel_funding;
SELECT pg_catalog.setval('travel_funding_travel_funding_id_seq', 0, true);
INSERT INTO travel_funding (org_id, travel_funding_name, require_details) VALUES
(0, 'APHRC Core', false),
(0, 'APHRC Project (Specify)', true),
(0, 'Other Institution (specify)', true),
(0, 'Partly personal (specify)', true);


INSERT INTO claim_types (adjustment_id, org_id, claim_type_name) VALUES
(21, 0, 'Travel Claim');

INSERT INTO et_fields (org_id, et_field_name, table_name, table_code, table_link) VALUES
(0, 'Role in Conference', 'travel_types', 111, 1),
(0, 'Participant', 'travel_types', 111, 1),
(0, 'Poster Presentation', 'travel_types', 111, 1),
(0, 'Oral Presentation', 'travel_types', 111, 1),
(0, 'Session Chair', 'travel_types', 111, 1),
(0, 'Key note speaker', 'travel_types', 111, 1),
(0, 'Conference website', 'travel_types', 111, 1),
(0, 'Training area', 'travel_types', 111, 6),
(0, 'Role in Training', 'travel_types', 111, 6),
(0, 'Training website', 'travel_types', 111, 6);