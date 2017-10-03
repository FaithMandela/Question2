
CREATE OR REPLACE FUNCTION approve_so(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(240) AS $$
DECLARE
	mystr VARCHAR(120);
BEGIN
	IF($3 = '3')THEN
		UPDATE qstudents SET so_approval = true, approved = true
		WHERE (qstudentid = $1::integer);
		mystr := 'School officers approval';
	ELSIF($3 = '4')THEN
		UPDATE qstudents SET majorapproval = false WHERE (qstudentid = $1::integer);
		mystr := 'Returned to major advisor';
	END IF;
	
	RETURN mystr;
END;
$$ LANGUAGE plpgsql;


UPDATE qstudents SET approved = true WHERE so_approval = true;
