---Project Database File

CREATE TABLE zones
(
  zone_id serial PRIMARY KEY,
  zone_name character varying(120) NOT NULL,
  zone_key integer NOT NULL DEFAULT 1,
  annual_cost real NOT NULL DEFAULT 0,
  tax_rate real NOT NULL DEFAULT 0,
  details text,
  CONSTRAINT zones_zone_name_key UNIQUE (zone_name)
);
