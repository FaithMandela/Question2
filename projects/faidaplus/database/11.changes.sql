

CREATE TABLE points (
	points_id				serial  primary key,
	org_id 					integer references orgs,
	entity_id				integer references entitys,
	period_id				integer references periods,
	pcc                     varchar(4),
	son                     varchar(7),
	segments                real,
	amount                  real,
	points                  real,
	bonus                   real
);
CREATE INDEX points_org_id ON points (org_id);
CREATE INDEX points_entity_id ON points (entity_id);
CREATE INDEX points_period_id ON points (period_id);
CREATE INDEX points_pcc ON points (pcc);



