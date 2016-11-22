CREATE TABLE org_events
(  org_event_id serial NOT NULL,
  org_id integer,
  org_event_name character varying(50) NOT NULL,
  start_date date,
  end_date date,
  details text
);

CREATE TABLE event(
event_id	serial primary key,
org_id		integer references orgs,
event_name	varchar(256),
event_date	date,
finish_date		date,
details			text
);

CREATE VIEW vw_event AS
	SELECT orgs.org_id, orgs.org_name, event.event_id, event.event_name, event.event_date, event.finish_date, event.details,
	date_part('month'::text, event.event_date) AS event_month,
	to_char(event.event_date::timestamp with time zone, 'YYYY'::text) AS event_year
	FROM event
	INNER JOIN orgs ON event.org_id = orgs.org_id;


CREATE VIEW vw_org_events AS
	SELECT org_events.org_event_id, org_events.org_id, org_events.org_event_name, org_events.start_date, org_events.end_date, org_events.details
	FROM org_events;


