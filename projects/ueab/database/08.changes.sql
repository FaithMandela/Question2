

CREATE OR REPLACE FUNCTION ins_qgrades() RETURNS trigger AS $$
DECLARE
	v_approved			boolean;
BEGIN
	
	SELECT org_id, approved INTO NEW.org_id, v_approved
	FROM qstudents
	WHERE (qstudentid = NEW.qstudentid);
	

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

