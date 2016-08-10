CREATE OR REPLACE FUNCTION generate_charges(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_year				integer;
	v_quarter			varchar(2);
	v_old_qid			varchar(12);

	msg 				varchar(120);
BEGIN

	msg := 'No Function selected';
	
	SELECT substring(quarters.quarterid from 1 for 4)::integer, 
		trim(substring(quarters.quarterid from 11 for 2)) INTO v_year, v_quarter
	FROM quarters
	WHERE quarterid = $1;
	
	v_old_qid := (v_year-1)::varchar(4) || '/' || v_year::varchar(4) || '.' || v_quarter;

	IF ($3 = '1') THEN
		INSERT INTO qresidences (quarterid, residenceid, org_id, residenceoption, charges, full_charges, active, details)
		SELECT $1, a.residenceid, a.org_id, a.residenceoption, a.charges, a.full_charges, a.active, a.details
		FROM qresidences a LEFT JOIN 
			(SELECT qresidenceid, residenceid FROM qresidences WHERE quarterid = $1) as b ON a.residenceid = b.residenceid
		WHERE (a.quarterid = v_old_qid) AND (b.qresidenceid is null);
		
		INSERT INTO qcharges(quarterid, degreelevelid, org_id, studylevel, fullfees, 
			fullmeal2fees, fullmeal3fees, fees, meal2fees, meal3fees, premiumhall, 
			minimalfees, firstinstalment, firstdate, secondinstalment, seconddate, narrative, sublevelid)
		SELECT $1, a.degreelevelid, a.org_id, a.studylevel, a.fullfees, 
			a.fullmeal2fees, a.fullmeal3fees, a.fees, a.meal2fees, a.meal3fees, a.premiumhall, 
			a.minimalfees, a.firstinstalment, a.firstdate, a.secondinstalment, a.seconddate, a.narrative, a.sublevelid
		FROM qcharges a LEFT JOIN 
			(SELECT qchargeid, degreelevelid, studylevel FROM qcharges WHERE quarterid = $1) b
		ON (a.degreelevelid = b.degreelevelid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qchargeid is null);
		
		INSERT INTO qmcharges(quarterid, majorid, org_id, studylevel, charge, fullcharge, 
			meal2charge, meal3charge, phallcharge, narrative, sublevelid)
		SELECT $1, a.majorid, a.org_id, a.studylevel, a.charge, a.fullcharge, 
			a.meal2charge, a.meal3charge, a.phallcharge, a.narrative, a.sublevelid
		FROM qmcharges a LEFT JOIN 
			(SELECT qmchargeid, majorid, studylevel FROM qmcharges WHERE quarterid = $1) b
		ON (a.majorid = b.majorid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qmchargeid is null);
		
		msg := 'Charges Generated';
	END IF;

	IF ($3 = '2') THEN
		INSERT INTO qchargedefinations(quarterid, chargetypeid, studylevel, amount, narrative, sublevelid, org_id)
		SELECT $1, a.chargetypeid, a.studylevel, a.amount, a.narrative, a.sublevelid, a.org_id
		FROM qchargedefinations a LEFT JOIN
			(SELECT qchargedefinationid, chargetypeid, studylevel FROM qchargedefinations WHERE quarterid = $1) b
		ON (a.chargetypeid = b.chargetypeid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qchargedefinationid is null);
		
		INSERT INTO qmchargedefinations(quarterid, chargetypeid, majorid, org_id, studylevel, amount, narrative, sublevelid)
		SELECT $1, a.chargetypeid, a.majorid, a.org_id, a.studylevel, a.amount, a.narrative, a.sublevelid
		FROM qmchargedefinations a LEFT JOIN
			(SELECT qmchargedefinationid, chargetypeid, majorid, studylevel FROM qmchargedefinations WHERE quarterid = $1) b
		ON (a.chargetypeid = b.chargetypeid) AND (a.majorid = b.majorid) AND (a.studylevel = b.studylevel)
		WHERE (a.quarterid = v_old_qid) AND (b.qmchargedefinationid is null);
	
		msg := 'Charges Defination Generated';
	END IF;	

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

