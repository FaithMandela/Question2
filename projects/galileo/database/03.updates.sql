CREATE TABLE tmpnbosegment(
	tmpnbosegment_id		serial primary key,
	smo_cd 				varchar(50), 
	mst_cus_id 			varchar(50),
	sub_id_name 			varchar(240), 
	boi_cntry_cd 			varchar(50),
	booking_type			varchar(50),
	boi_booking_date 		varchar(50),
	pcc 				varchar(50),
	c_count 			varchar(50),
	acs_crs_number 			varchar(50)
);

ALTER TABLE transactions ADD COLUMN ticketedsegs varchar(50);
ALTER TABLE transactions ADD COLUMN bookedsegs varchar(50);
ALTER TABLE transactions ADD COLUMN carsegs varchar(50);
ALTER TABLE transactions ADD COLUMN hotelsegs varchar(50);

ALTER TABLE midttransactions ADD COLUMN ticketedsegs varchar(50);
ALTER TABLE midttransactions ADD COLUMN bookedsegs varchar(50);
ALTER TABLE midttransactions ADD COLUMN carsegs varchar(50);
ALTER TABLE midttransactions ADD COLUMN hotelsegs varchar(50); 


CREATE OR REPLACE FUNCTION inssegs(varchar(50), varchar(50)) RETURNS varchar(50) AS $$
DECLARE
	myrec RECORD;
BEGIN 

INSERT INTO clientgroups(mst_cus_id, clientaffiliateid, clientgroupname, detail)
SELECT mst_cus_id, 0, max(substring(sub_id_name::text, 20)), count(sub_id_name) AS count
FROM tmpnbosegment
GROUP BY mst_cus_id
having count(sub_id_name) > 1;

-- -----Inserting ticketed  transactions
INSERT INTO Transactions (clientid, pcc, periodid, ticketedsegs)
SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is null) AND booking_type = 'ATS';-- 

-- //Inserting booked transactions
INSERT INTO Transactions (clientid, pcc, periodid, bookedsegs)
(SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is not null) AND booking_type = 'A');
-- 
-- //Inserting car transactions, zero found
INSERT INTO Transactions (clientid, pcc, periodid, carsegs)
SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is null) AND booking_type = 'C';
-- 
-- //Inserting Hotel  transactions
INSERT INTO Transactions (clientid, pcc, periodid, hotelsegs)
SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is null) AND booking_type = 'H';

--upate transactions booked
UPDATE transactions SET bookedsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'A') ut 
WHERE transactions.clientid = ut.clientid AND transactions.periodid = ut.periodid;

--upate transactions ticketedsegs
UPDATE transactions SET ticketedsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'ATS') ut 
WHERE transactions.clientid = ut.clientid AND transactions.periodid = ut.periodid;

--upate transactions carsegs
UPDATE transactions SET carsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'C') ut 
WHERE transactions.clientid = ut.clientid AND transactions.periodid = ut.periodid;

--upate transactions hotelsegs
UPDATE transactions SET hotelsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'H') ut 
WHERE transactions.clientid = ut.clientid AND transactions.periodid = ut.periodid;

-- -----Inserting ticketed  midttransactions
INSERT INTO midttransactions (clientid, pcc, periodid, ticketedsegs)
SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is null) AND booking_type = 'ATS';-- 

-- //Inserting booked midttransactions
INSERT INTO midttransactions (clientid, pcc, periodid, bookedsegs)
(SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is not null) AND booking_type = 'A');
-- 
-- //Inserting car midttransactions, zero found
INSERT INTO Transactions (clientid, pcc, periodid, carsegs)
SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is null) AND booking_type = 'C';
-- 
-- //Inserting Hotel  midttransactions
INSERT INTO midttransactions (clientid, pcc, periodid, hotelsegs)
SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM (tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int)
LEFT JOIN transactions ON (pccs.clientid = transactions.clientid) AND (periods.periodid = transactions.periodid)
WHERE smo_cd <> 'SMO_CD' AND (transactions.transactionid is null) AND booking_type = 'H';

--upate midttransactions booked
UPDATE midttransactions SET bookedsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'A') ut 
WHERE midttransactions.clientid = ut.clientid AND midttransactions.periodid = ut.periodid;

--upate midttransactions ticketedsegs
UPDATE midttransactions SET ticketedsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'ATS') ut 
WHERE midttransactions.clientid = ut.clientid AND midttransactions.periodid = ut.periodid;

--upate midttransactions carsegs
UPDATE midttransactions SET carsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'C') ut 
WHERE midttransactions.clientid = ut.clientid AND midttransactions.periodid = ut.periodid;

--upate midttransactions hotelsegs
UPDATE midttransactions SET hotelsegs = ut.c_count
FROM (SELECT pccs.clientid, tmpnbosegment.pcc, periods.periodid, c_count
FROM tmpnbosegment INNER JOIN pccs ON pccs.pcc = tmpnbosegment.pcc
INNER JOIN periods ON periods.startdate = '1899-12-30'::date + boi_booking_date::int
WHERE smo_cd <> 'SMO_CD' AND booking_type = 'H') ut 
WHERE midttransactions.clientid = ut.clientid AND midttransactions.periodid = ut.periodid;

DELETE FROM tmpnbosegment WHERE pcc  IN
(SELECT DISTINCT pcc FROM transactions);

	RETURN 'Done';
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE VIEW vw_missing_pccs AS 
 SELECT a.pcc,
    a.mst_cus_id,
    a.sub_id_name
   FROM tmpnbosegment a
     LEFT JOIN pccs c ON a.pcc::text = c.pcc::text
     LEFT JOIN clients ON clients.clientid = c.clientid
  WHERE c.pcc IS NULL AND a.pcc::text <> 'PCC'::text
  GROUP BY a.pcc, a.mst_cus_id, a.sub_id_name, clients.clientname;

ALTER TABLE clientgroups ADD COLUMN mst_cus_id	varchar(50);

CREATE VIEW vw_custid_groups AS
SELECT max(tmpnbosegment.sub_id_name) AS agency_name, tmpnbosegment.mst_cus_id,  tmpnbosegment.pcc, count(tmpnbosegment.sub_id_name) AS number
FROM tmpnbosegment
INNER JOIN vw_missing_pccs ON vw_missing_pccs.pcc = tmpnbosegment.pcc
GROUP BY tmpnbosegment.mst_cus_id, tmpnbosegment.pcc
having count(tmpnbosegment.sub_id_name) > 1;

CREATE OR REPLACE VIEW vw_unused_data AS 
 SELECT tmpnbosegment.mst_cus_id,
    tmpnbosegment.sub_id_name,
    tmpnbosegment.pcc
   FROM tmpnbosegment
     JOIN periods ON periods.startdate = ('1899-12-30'::date + tmpnbosegment.boi_booking_date::integer)
     LEFT JOIN transactions ON tmpnbosegment.pcc::text = transactions.pcc::text AND periods.periodid = transactions.periodid
  WHERE tmpnbosegment.booking_type::text = 'A'::text AND transactions.bookedsegs IS NULL;
