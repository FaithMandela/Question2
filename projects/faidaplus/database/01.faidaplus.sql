
CREATE TABLE pccs (
	pcc						varchar(4) primary key,
	agency_name				varchar(120),
	iata_agent				boolean default false not null,
	agency_incentive		boolean default false,
	incentive_son			varchar(12)
);

CREATE TABLE logs (
	log_id					serial primary key,
	pcc						varchar(4),
	log_date				date,
	currency				varchar(4),
	process_date			date
);
CREATE INDEX logs_pcc ON logs (pcc);

CREATE TABLE log_details (
	log_id					integer references logs primary key,
	details					text
);

CREATE TABLE tickets (
	ticket_id				varchar(25) primary key,
	ticket_date				date,
	ticket_pcc				varchar(25),
	book_pcc				varchar(25),
	bpcc					varchar(12),
	son						varchar(4),
	pcc						varchar(12),
	line1					varchar(240),
	line2					varchar(240),
	line3					varchar(240),
	segs					integer default 0,
	TVOID					integer default 0,
	TOPEN					integer default 0,
	TUSED					integer default 0,
	TEXCH					integer default 0,
	TRFND					integer default 0,
	TARPT					integer default 0,
	TCKIN					integer default 0,
	TLFTD					integer default 0,
	TUNVL					integer default 0,
	TPRTD					integer default 0,
	TSUSP					integer default 0,
	
	for_incentive			boolean default false,
	incentive_updated		boolean default false,
	processed				boolean default false
);
CREATE INDEX tickets_pcc ON tickets (pcc);
CREATE INDEX tickets_bpcc ON tickets (bpcc);

CREATE TABLE tes (
	ticket_id				varchar(25) references tickets primary key,
	details					text
);


CREATE VIEW vw_logs AS
	SELECT pccs.pcc, pccs.agency_name, logs.log_id, logs.log_date, logs.currency, logs.process_date
	FROM pccs INNER JOIN logs ON pccs.pcc = logs.pcc;

CREATE VIEW vw_tickets AS
	SELECT ticket_id, ticket_date, ticket_pcc, book_pcc,  pcc, bpcc, son,
		TVOID, TOPEN, TUSED, TEXCH, TRFND, TARPT, TCKIN, TLFTD, TUNVL, TPRTD, TSUSP,
		segs, (TOPEN + TUSED + TARPT + TCKIN + TLFTD + TPRTD + TUNVL) as activesegs,
		to_char(ticket_date, 'MMYYYY') as ticket_period,
		(CAST(date_part('year', ticket_date) - 2000 as varchar) || to_char(ticket_date, 'MM')) as seg_period,
		to_char(ticket_date, 'Month') as ticket_month,
		to_char(ticket_date, 'YYYY') as ticket_year
	FROM tickets;

CREATE VIEW vw_ticket_segs AS
	SELECT pccs.pcc, pccs.agency_name, vw_tickets.ticket_period, vw_tickets.seg_period, 
		sum(vw_tickets.activesegs) as total_segs
	FROM (pccs INNER JOIN vw_tickets ON pccs.pcc = vw_tickets.pcc)
	GROUP BY pccs.pcc, pccs.agency_name, vw_tickets.ticket_period, vw_tickets.seg_period;

CREATE VIEW vw_days_agency_segs AS
	SELECT pccs.pcc, pccs.agency_name, vw_tickets.ticket_period, vw_tickets.seg_period, 
		vw_tickets.ticket_date, sum(vw_tickets.activesegs) as total_segs
	FROM (pccs INNER JOIN vw_tickets ON pccs.pcc = vw_tickets.pcc)
	GROUP BY pccs.pcc, pccs.agency_name, vw_tickets.ticket_period, vw_tickets.seg_period, vw_tickets.ticket_date;

CREATE VIEW vw_days_segs AS
	SELECT vw_tickets.ticket_period, vw_tickets.seg_period,  vw_tickets.ticket_date, sum(vw_tickets.activesegs) as total_segs
	FROM vw_tickets
	GROUP BY vw_tickets.ticket_period, vw_tickets.seg_period, vw_tickets.ticket_date;

CREATE VIEW vw_booked_segs AS
	SELECT pccs.pcc, pccs.agency_name, vw_tickets.ticket_period, vw_tickets.seg_period, 
		sum(vw_tickets.activesegs) as total_segs
	FROM (pccs INNER JOIN vw_tickets ON pccs.pcc = vw_tickets.bpcc)
	GROUP BY pccs.pcc, pccs.agency_name, vw_tickets.ticket_period, vw_tickets.seg_period;

CREATE VIEW vw_son_segs AS
	SELECT pccs.pcc, pccs.agency_name, vw_tickets.son, vw_tickets.ticket_period, vw_tickets.seg_period, 
		sum(vw_tickets.activesegs) as total_segs
	FROM (pccs INNER JOIN vw_tickets ON pccs.pcc = vw_tickets.bpcc)
	GROUP BY pccs.pcc, pccs.agency_name, vw_tickets.son, vw_tickets.ticket_period, vw_tickets.seg_period;

CREATE VIEW vw_periods AS
	SELECT ticket_year, ticket_period, ticket_month, seg_period, sum(vw_tickets.activesegs) as total_segs
	FROM vw_tickets
	GROUP BY ticket_year, ticket_period, ticket_month, seg_period
	ORDER BY ticket_year, ticket_period, seg_period;

CREATE VIEW vw_period_years AS
	SELECT ticket_year 
	FROM vw_tickets
	GROUP BY ticket_year
	ORDER BY ticket_year;

CREATE VIEW vw_unallocated AS
	SELECT vw_tickets.bpcc, vw_tickets.ticket_period, sum(vw_tickets.activesegs) as segements
	FROM (vw_tickets LEFT JOIN pccs ON vw_tickets.bpcc = pccs.pcc)
	WHERE (pccs.pcc is null) AND (vw_tickets.activesegs <> 0)
	GROUP BY vw_tickets.bpcc, vw_tickets.ticket_period
	ORDER BY vw_tickets.ticket_period;


CREATE OR REPLACE FUNCTION ins_tickets() RETURNS trigger AS $$
DECLARE
	v_agency_incentive	boolean;
	v_incentive_son		varchar(12);
	v_pcc_son			varchar(12);
BEGIN

	IF((OLD.processed = false) AND (NEW.processed = true))THEN
	
		SELECT agency_incentive, incentive_son INTO v_agency_incentive, v_incentive_son
		FROM pccs WHERE pcc = NEW.bpcc;
		
		IF((NEW.for_incentive = false) AND (NEW.incentive_updated = false) AND (v_agency_incentive = true))THEN
			v_pcc_son := NEW.bpcc || v_incentive_son;
			
			INSERT INTO tickets(ticket_id, 
				ticket_date, ticket_pcc, book_pcc, bpcc, son, pcc, line1, 
				line2, line3, segs, tvoid, topen, tused, texch, trfnd, tarpt, 
				tckin, tlftd, tunvl, tprtd, tsusp, picked_time, for_incentive, 
				incentive_updated)
			VALUES('000' ||	substring(NEW.ticket_id from 4 for 10), 
				current_date, NEW.bpcc, v_pcc_son, NEW.bpcc, v_incentive_son, NEW.bpcc, NEW.line1, 
				NEW.line2, NEW.line3, NEW.segs, NEW.tvoid, NEW.topen, NEW.tused, NEW.texch, NEW.trfnd, NEW.tarpt, 
				NEW.tckin, NEW.tlftd, NEW.tunvl, NEW.tprtd, NEW.tsusp, NEW.picked_time, true, true);
				
			NEW.incentive_updated = true;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_tickets BEFORE UPDATE ON tickets
    FOR EACH ROW EXECUTE PROCEDURE ins_tickets();


