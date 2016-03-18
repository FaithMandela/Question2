


----------- Do an anlysis for the Travelport ticket report
SELECT a.runtyp, a.pcc, a.s_segs, b.total_segs

FROM (SELECT runtyp, pcc, sum(acttxnet) as s_segs
FROM imp_segs
GROUP BY runtyp, pcc) a LEFT JOIN
(SELECT ('M' || vwtickets.segperiod) as seg_period, vwtickets.ticketpcc, 
	sum(vwtickets.activesegs) as total_segs
FROM vwtickets
GROUP BY vwtickets.segperiod, vwtickets.ticketpcc) b
ON (a.runtyp = b.seg_period) AND (a.pcc = b.ticketpcc);


--------- run balances
SELECT a.pcc, a.org_name, a.entity_id, b.entity_name, to_char(sum(balance), '999,999,999,999')
FROM vw_son_statement a INNER JOIN entitys b ON a.entity_id = b.entity_id
GROUP BY a.pcc, a.org_name, a.entity_id, b.entity_name
ORDER BY sum(balance) desc;


