
CREATE TABLE sys_menu_msg (
	sys_menu_msg_id			serial primary key,
	menu_id					varchar(16) not null,
	menu_name				varchar(50) not null,
	xml_file				varchar(50) not null,
	msg						text
);

DROP VIEW vwcrnotesummary;
DROP VIEW vwinvoicesummary;
DROP VIEW vwcrnotelist;
DROP VIEW vwinvoicelist;
DROP VIEW clientstatement;
DROP VIEW vwinvoice;
DROP VIEW vwsales;


CREATE VIEW vwsales AS
	SELECT vwmanagement.clientid, vwmanagement.clientname, vwmanagement.clientbranchid, vwmanagement.branchname, vwmanagement.address, vwmanagement.postalcode,
		vwmanagement.managementid, vwmanagement.town, vwmanagement.country_id, vwmanagement.countryname, vwmanagement.telno, vwmanagement.email,  
		vwmanagement.creationdate, vwmanagement.departuredate, vwmanagement.leadname, vwmanagement.wholesalevalue, vwmanagement.grossvalue, 
		vwmanagement.currency, vwmanagement.subagent,
		sales.saleid, sales.bookingID, sales.agentReference, sales.item,sales.city,sales.name,sales.serviceDate,sales.nights, sales.totalPrice, sales.commission, 
		sales.netremits, sales.creditnote, sales.status, sales.alternate, sales.completed, sales.requestedDate,sales.requestedTime,sales.nationality,sales.rmks, sales.periodid,
		sales.gkref, (sales.totalprice - sales.commission) as amount, 
		(sales.totalprice - sales.netremits - sales.commission) as grossearning,
		gtarevenue.serviceid, gtarevenue.servicename, gtarevenue.basis, gtarevenue.gkpercentage, 
		gtarevenue.tacommissionout, gtarevenue.sharedndccommission, gtarevenue.otherndccommission, gtarevenue.gk,
		
		(CASE WHEN gtarevenue.commisionable = false THEN (sales.netremits * gtarevenue.gkpercentage / 100)
		ELSE (sales.totalprice * gtarevenue.gkpercentage / 100) END) as gkpercent, 
		
		(CASE WHEN gtarevenue.commisionable = false THEN (sales.netremits * gtarevenue.tacommissionout / 100) 
		ELSE (sales.totalprice * gtarevenue.tacommissionout / 100) END) as tacommission, 
		
		(CASE WHEN gtarevenue.commisionable = false THEN (sales.netremits * gtarevenue.sharedndccommission / 100) 
		ELSE (sales.totalprice * gtarevenue.sharedndccommission / 100) END) as sharedcommission, 
		
		(CASE WHEN gtarevenue.commisionable = false THEN (sales.netremits * gtarevenue.otherndccommission / 100) 
		ELSE (sales.totalprice * gtarevenue.otherndccommission / 100) END) as otherndc, 
		
		(CASE WHEN gtarevenue.commisionable = false THEN (sales.netremits * gtarevenue.gk / 100)
		ELSE (sales.totalprice * gtarevenue.gk / 100) END) as galileoearning,
		
		sales.vat_rate, 	
		((CASE WHEN gtarevenue.commisionable = false THEN (sales.netremits * (gtarevenue.sharedndccommission + gtarevenue.tacommissionout) / 100) 
		ELSE (sales.totalprice * (gtarevenue.sharedndccommission + gtarevenue.tacommissionout) / 100) END) * sales.vat_rate / 100) as galileo_vat,

		
		('GT/INVC' || CAST(vwmanagement.clientid as varchar) || Period.AccountPeriod ) as clinvnumber,
		Period.Startdate, Period.enddate, Period.AccountPeriod, Period.InvoiceDate, (Period.InvoiceDate + 30) as duedate,
		invoicelist.invoiceid, invoicelist.issued, ('TP/GTA/INV/' || invoicelist.invoiceid) as invoicenumber,
		invoicelist.ispicked
	FROM (((sales INNER JOIN gtarevenue ON sales.item = gtarevenue.serviceid)
		INNER JOIN Period ON sales.periodid = Period.PeriodID)
		LEFT JOIN vwmanagement ON sales.bookingID = vwmanagement.bookingID)
		LEFT JOIN invoicelist ON (vwmanagement.clientid = invoicelist.clientid) AND (sales.periodid = invoicelist.periodid);
		
CREATE VIEW vwinvoice AS
	SELECT 	vwsales.clientid, vwsales.clientname,  vwsales.clientbranchid, vwsales.branchname, vwsales.address,
		vwsales.periodid, vwsales.Startdate, vwsales.postalcode, vwsales.town, vwsales.country_id, vwsales.countryname,
		vwsales.bookingid, vwsales.agentreference, vwsales.item, vwsales.servicedate, vwsales.city, vwsales.name, 
		vwsales.nights, vwsales.commission, vwsales.netremits, vwsales.totalprice, vwsales.amount, vwsales.creditnote, 
		vwsales.grossearning, vwsales.InvoiceDate, vwsales.duedate, vwsales.invoicenumber, vwsales.invoiceid, vwsales.issued,
		vwsales.gkref, vwsales.ispicked, vwsales.vat_rate, vwsales.galileo_vat
	FROM vwsales
	WHERE (lower(trim(vwsales.status)) = 'confirmed');
		
CREATE VIEW clientstatement AS
	SELECT vwinvoice.clientid, vwinvoice.clientname, vwinvoice.periodid, vwinvoice.invoicenumber, vwinvoice.invoicedate, 
		vwinvoice.netremits, vwinvoice.grossearning, vwinvoice.vat_rate, vwinvoice.galileo_vat
	FROM vwinvoice;

CREATE VIEW vwinvoicelist AS
	SELECT clientid, clientname, town, country_id, countryname, 
		periodid, invoiceid, issued
	FROM vwsales
	WHERE (clientid is not null) AND (totalprice > 0)
	GROUP BY clientid, clientname, town, country_id, countryname, 
		periodid, invoiceid, issued
	ORDER BY clientid;

CREATE VIEW vwcrnotelist AS
	SELECT vwsales.clientid, vwsales.periodid,crnotelist.crnoteid
	FROM vwsales LEFT JOIN crnotelist ON
		(vwsales.PeriodID = crnotelist.PeriodID) AND (vwsales.clientid = crnotelist.clientid)
	WHERE (vwsales.clientid is not null) AND (vwsales.totalprice < 0) AND (to_char(StartDate, 'MMYYYY') <> to_char(servicedate, 'MMYYYY'))
	GROUP BY vwsales.clientid, vwsales.periodid, crnotelist.crnoteid
	ORDER BY vwsales.clientid;

CREATE VIEW vwinvoicesummary AS 
	SELECT 	vwsales.clientid, vwsales.clientname, vwsales.InvoiceDate, vwsales.invoiceid, vwsales.invoicenumber,
		vwsales.Startdate, vwsales.periodid, vwsales.ispicked, sum(vwsales.amount) as invoiceamount,
		sum(vwsales.netremits) as gtatotals
	FROM vwsales
	WHERE ((lower(trim(vwsales.status)) = 'confirmed') AND ((totalprice > 0) OR (to_char(StartDate, 'MMYYYY') = to_char(servicedate, 'MMYYYY'))))
	GROUP BY vwsales.clientid, vwsales.clientname, vwsales.InvoiceDate, vwsales.invoiceid, vwsales.invoicenumber, 
		vwsales.Startdate, vwsales.periodid, vwsales.ispicked;

CREATE VIEW vwcrnotesummary AS 
	SELECT 	vwsales.clientid, vwsales.clientname, vwsales.InvoiceDate, vwsales.periodid,
		crnotelist.crnoteid, ('TP/GTA/CR/' || crnotelist.crnoteid) as creditnotenumber, crnotelist.ispicked, 
		vwsales.Startdate, sum(vwsales.amount) as invoiceamount,
		sum(vwsales.netremits) as gtatotals
	FROM vwsales LEFT JOIN crnotelist ON
		(vwsales.PeriodID = crnotelist.PeriodID) AND (vwsales.clientid = crnotelist.clientid)
	WHERE (lower(trim(vwsales.status)) = 'confirmed') 
		AND (vwsales.totalprice < 0) AND (to_char(vwsales.StartDate, 'MMYYYY') <> to_char(vwsales.servicedate, 'MMYYYY'))
	GROUP BY vwsales.clientid, vwsales.clientname, vwsales.InvoiceDate, vwsales.periodid,
		crnotelist.crnoteid, ('TP/GTA/CR/' || crnotelist.crnoteid), crnotelist.ispicked, vwsales.Startdate;


CREATE OR REPLACE FUNCTION insSales(varchar(50), varchar(50)) RETURNS varchar(50) AS $$
DECLARE
	myrec RECORD;
BEGIN

	DELETE FROM tmpsales WHERE bookingid = 'Booking ID';

	SELECT INTO myrec max(PeriodID) as defperiodid 
	FROM Period WHERE (IsActive = true) AND (Approved = false);

	INSERT INTO sales (bookingid, AgentReference, item, city, name, ServiceDate, nights, status, alternate, rmks,
			completed, RequestedDate, RequestedTime, nationality, totalprice, netremits, gkref, periodid, commission, vat_rate) 
	SELECT cast(cast(bookingid as real) as int), AgentReference, trim(upper(replace(tmpsales.item, ' ', ''))), city, name, 
			CAST('1899-12-30' as date) + cast(CAST(ServiceDate as real) as int),
			cast(Cast(nights as real) as int), status, alternate, rmks, completed, 
			CAST('1899-12-30' as date) + cast(CAST(RequestedDate as real) as int),
			Cast(RequestedTime as real) * interval '1 day', nationality, 
			to_number(replace(TotalPrice, ' USD', ''), 'FM999G999G999.99'), 
			(CASE WHEN gtarevenue.commisionable = false THEN
				to_number(replace(TotalPrice, ' USD', ''), 'FM999G999G999.99') / (1 + gtarevenue.gkpercentage/100)
				ELSE to_number(replace(TotalPrice, ' USD', ''), 'FM999G999G999.99') * (1 - gtarevenue.gkpercentage/100) END),
			gkref, myrec.defperiodid,
			(CASE WHEN gtarevenue.commisionable = false THEN 
				(TAcommissionout /100) * to_number(replace(TotalPrice, ' USD', ''), 'FM999G999G999.99') / (1 + gkpercentage/100)
				ELSE (TAcommissionout /100) * to_number(replace(TotalPrice, ' USD', ''), 'FM999G999G999.99') END), 16
	FROM tmpsales INNER JOIN gtarevenue ON trim(upper(replace(tmpsales.item, ' ', ''))) = trim(upper(gtarevenue.serviceid));
	
	DELETE FROM tmpsales;

	RETURN 'Done';
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION email_invoice(
    integer,
    integer,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg		 				varchar(120);
BEGIN
	INSERT INTO sys_emailed (sys_email_id, table_id, org_id, table_name)
	VALUES (1, $1, 0, 'clients');
msg := 'Email Sent';
return msg;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;



-- UPDATE clients SET contact_person=ut.substr FROM 
-- (SELECT clientid, substr(email, 1 , position('@' in email) - 1) from clients WHERE position('@' in email) > 0) as ut
-- WHERE ut.clientid= clients.clientid;
-- 
-- UPDATE clients SET contact_person=ut.cname FROM 
-- (SELECT clients.email, tmpmanes.email, clients.clientname, tmpmanes.aname, tmpmanes.cname
--  FROM tmpmanes 
-- LEFT JOIN clients on clients.clientname= tmpmanes.aname) as ut
-- WHERE ut.aname= clients.clientname; 

ALTER TABLE clients ADD COLUMN mst_cus_id varchar(10);

CREATE TABLE clientpayments (
	clientpaymentsid		serial primary key,
	clientid 				integer references clients,
	PeriodID				integer references period,
	currency				varchar(50),
	amount					real,
	payment_reference		varchar(250)
);

CREATE TABLE tmpclientpayments (
	clientpaymentsid		serial primary key,
	mst_cus_id 				varchar(10),
	clientname				varchar(250),
	accountdate				varchar(16),
	currency				varchar(50),
	amount					varchar(16),
	payment_reference		varchar(250)
);

CREATE INDEX clientpayments_clientid ON clientpayments (clientid);
CREATE INDEX clientpayments_PeriodID ON clientpayments (PeriodID);

CREATE OR REPLACE VIEW vw_clientpayments AS 
 SELECT clients.clientid,
    clients.clientname,
    period.periodid,
    period.startdate,
    period.enddate,
    clientpayments.clientpaymentsid,
    clientpayments.currency,
    clientpayments.amount,
    'TP/GTA/PAY/'::text || clientpayments.clientpaymentsid AS clientpaymentsnumber,
    clientpayments.payment_reference
   FROM clientpayments
     JOIN clients ON clientpayments.clientid = clients.clientid
     JOIN period ON clientpayments.periodid = period.periodid;
	
-- CREATE OR REPLACE FUNCTION get_total_credit(integer) RETURNS real AS $$
-- SELECT SUM(amount) as Credit
--  FROM vwinvoice
--  WHERE (clientid = $1) AND  (vwinvoice.totalprice < 0) AND
--  (to_char(StartDate, 'MMYYYY') <> to_char(servicedate, 'MMYYYY'));
--   $$ LANGUAGE SQL;
-- 
-- CREATE OR REPLACE FUNCTION get_total_invoice(integer) RETURNS real AS $$
-- SELECT SUM(amount) as Invoice
--  FROM vwinvoice
--  WHERE (clientid = $1) AND ((totalprice > 0) OR (to_char(StartDate, 'MMYYYY') = to_char(servicedate, 'MMYYYY')));
--   $$ LANGUAGE SQL;
-- 
-- CREATE OR REPLACE FUNCTION get_total_Payments(integer) RETURNS real AS $$
-- SELECT SUM(amount) as Payments
--  FROM vw_clientpayments
--  WHERE  (clientid = $1);
--   $$ LANGUAGE SQL;
-- 
-- CREATE OR REPLACE VIEW vw_total_statements AS 
--  SELECT vwinvoice.clientid, vwinvoice.clientname,
-- 		get_total_credit(vwinvoice.clientid) AS Credit,
-- 		get_total_invoice(vwinvoice.clientid) AS Invoice,
-- 		get_total_Payments(vwinvoice.clientid) AS Payments
-- FROM vwinvoice;

DROP VIEW vwinvoicelist CASCADE;

CREATE OR REPLACE VIEW vwinvoicelist AS 
 SELECT vwsales.clientid,
    vwsales.clientname,
    vwsales.town,
    vwsales.countryid,
    vwsales.countryname,
    vwsales.periodid,
    vwsales.invoiceid,
    vwsales.invoicenumber,
    vwsales.issued,
    period.salesperiod,
    period.invoicedate,
    sum(vwsales.amount) AS invoice_amount,
    sum(vwsales.netremits) AS gta_totals
   FROM vwsales
     JOIN period ON period.periodid = vwsales.periodid
  WHERE vwsales.clientid IS NOT NULL AND vwsales.totalprice > 0::double precision
  GROUP BY vwsales.clientid, vwsales.clientname, vwsales.town, vwsales.countryid, vwsales.countryname, vwsales.periodid, period.invoicedate, period.salesperiod, vwsales.invoiceid, vwsales.invoicenumber, vwsales.issued
  ORDER BY vwsales.clientid;

DROP VIEW vwcrnotelist;

CREATE OR REPLACE VIEW vwcrnotelist AS 
 SELECT vwsales.clientid,
    vwsales.clientname,
    vwsales.periodid,
    crnotelist.crnoteid,
    vwcrnotesummary.creditnotenumber,
    period.salesperiod,
    period.invoicedate,
    sum(vwsales.amount) AS invoice_amount,
    sum(vwsales.netremits) AS gta_totals
   FROM vwsales
     LEFT JOIN crnotelist ON vwsales.periodid = crnotelist.periodid AND vwsales.clientid = crnotelist.clientid
     JOIN period ON period.periodid = vwsales.periodid
     JOIN vwcrnotesummary ON crnotelist.crnoteid = vwcrnotesummary.crnoteid
  WHERE vwsales.clientid IS NOT NULL AND vwsales.totalprice < 0::double precision AND to_char(vwsales.startdate::timestamp with time zone, 'MMYYYY'::text) <> to_char(vwsales.servicedate::timestamp with time zone, 'MMYYYY'::text)
  GROUP BY vwsales.clientid, vwsales.clientname, vwsales.periodid, crnotelist.crnoteid, vwcrnotesummary.creditnotenumber, period.salesperiod, period.invoicedate
  ORDER BY vwsales.clientid;

CREATE OR REPLACE VIEW vw_statement AS
SELECT item_name, clientid, clientname, periodid, invoicedate, invoice_amount, credit_amount, payments 
FROM 
((SELECT 'Invoice'::varchar(32) as item_name, clientid, clientname, periodid, invoicedate, invoice_amount, '0'::real as credit_amount, '0'::real as payments
FROM vwinvoicelist)
  UNION ALL 
 (SELECT 'Credit Note'::varchar(32) as item_name, clientid, clientname, periodid, invoicedate, '0'::real, invoice_amount, '0'::real
FROM vwcrnotelist)
  UNION ALL 
 (SELECT 'Payments'::varchar(32) as item_name, clientid, clientname, periodid, enddate, '0'::real, '0'::real, amount 
	FROM vw_clientpayments)) as a 
ORDER BY invoicedate DESC;


CREATE OR REPLACE FUNCTION inspayments(character varying, character varying, character varying) 
RETURNS varchar(50) AS $$
DECLARE
	myrec RECORD;
BEGIN 
	INSERT INTO clientpayments(clientid, periodid, currency, amount, payment_reference)
	SELECT clients.clientid, periodid, currency, amount::real, payment_reference
	FROM tmpclientpayments 
	INNER JOIN clients ON tmpclientpayments.mst_cus_id = clients.mst_cus_id
	INNER JOIN period ON period.enddate = '1899-12-30'::date + accountdate::int;

	DELETE FROM tmpclientpayments; 
	RETURN 'Done';
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW vw_receipt AS
	SELECT vw_clientpayments.clientid, vwclients.clientname, periodid, enddate, clientpaymentsid, 
       currency, amount, clientpaymentsnumber, payment_reference, countryname, address, postalcode, town
	FROM vw_clientpayments 
	JOIN vwclients ON vw_clientpayments.clientid = vwclients.clientid;

-- CREATE OR REPLACE VIEW vw_statement AS
-- SELECT clientid, clientname, periodid, startdate, amount FROM 
-- ((SELECT clientid, clientname, periodid, startdate, amount FROM vwinvoice
-- 	WHERE creditnote = false AND (vwinvoice.totalprice < 0) AND
--         (to_char(StartDate, 'MMYYYY') <> to_char(servicedate, 'MMYYYY')))
--   UNION ALL 
--  (SELECT clientid, clientname, periodid, startdate, amount FROM vwinvoice
-- 	WHERE ((totalprice > 0) OR (to_char(StartDate, 'MMYYYY') = to_char(servicedate, 'MMYYYY'))))
--   UNION ALL 
--  (SELECT clientid, clientname, periodid, enddate, amount FROM vw_clientpayments)) as a ORDER BY startdate DESC;
