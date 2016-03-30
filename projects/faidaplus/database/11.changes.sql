
ALTER TABLE applicants ADD COLUMN phone_no character varying(50);

CREATE OR REPLACE FUNCTION upd_applicants(varchar(12), varchar(12), varchar(12),varchar(12)) RETURNS varchar(120) AS $BODY$
DECLARE
	ps				varchar(16);
	v_pcc 			varchar(4);
	rec 			RECORD;
	app				RECORD;
	msg				varchar(120);
	myid 			integer;
BEGIN

	IF ($3::integer = 1) THEN
		ps := 'Approved';
		SELECT * INTO app FROM applicants WHERE applicant_id = $1::integer;
		SELECT org_id INTO rec FROM orgs WHERE (trim(upper(pcc)) = trim(upper(app.pseudo_code)));

		IF(rec IS NULL)THEN
			RAISE EXCEPTION 'Pseudo Code Does not Exist';
		END IF;

		UPDATE applicants SET status = ps , org_id = rec.org_id, approve_status = ps WHERE applicant_id = $1::integer ;
		INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, primary_email, son, function_role, is_active, birth_date)
		VALUES (rec.org_id, 0, trim(upper(app.son)), trim(app.user_name), trim(lower(app.applicant_email)), trim(upper(app.son)), 'consultant', true, app.consultant_dob) returning entity_id INTO myid;
		msg := 'Consultant account has been activated';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (2, myid, 'entitys', 3);
	END IF;

	IF ($3::integer = 2) THEN
		ps := 'Rejected';
		UPDATE applicants SET status = ps , approve_status = ps WHERE applicant_id = $1::integer ;
		msg := 'Applicant Rejected';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (3, $1::integer , 'applicants', 3);
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE entitys SET is_active = true WHERE entity_id = $1::integer ;
		msg := 'Consultant Activated';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (2, $1::integer , 'entitys', 3);
	END IF;

	IF ($3::integer = 4) THEN
		UPDATE entitys SET is_active = false WHERE entity_id = $1::integer ;
		msg := 'Account Deactivated';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (2, $1::integer , 'entitys', 3);
	END IF;

	RETURN msg;
END;
$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW vw_pcc_statement AS
SELECT a.dr, a.cr, a.org_id, a.order_date::date, a.pcc,
		a.org_name, a.dr - a.cr AS balance, a.details
	FROM ((SELECT COALESCE(vw_org_points.points, 0::real) + COALESCE(vw_org_points.bonus, 0::real) AS dr,
		0::real AS cr, vw_org_points.period AS order_date, ''::text,
		vw_org_points.pcc, vw_org_points.org_name, 0::integer,vw_org_points.org_id,
		( segments||' segments sold in '|| ticket_period)as details
	FROM vw_org_points)
	UNION
	(SELECT 0::real AS float4, vw_orders.grand_total::real AS order_total_amount,
		vw_orders.order_date, vw_orders.son, vw_orders.pcc, vw_orders.org_name,
		vw_orders.entity_id,vw_orders.org_id,
		get_order_details(vw_orders.order_id) AS details
	FROM vw_orders)) a
	ORDER BY a.order_date;


	CREATE OR REPLACE FUNCTION getbalance(integer) RETURNS real AS $$
	DECLARE
		v_org_id 			integer;
		v_function_role		text;
		v_balance			real;
	BEGIN
		v_balance = 0::real;
		SELECT org_id,function_role INTO v_org_id, v_function_role FROM vw_entitys WHERE entity_id = $1;
		IF(v_function_role = 'manager')THEN
			SELECT COALESCE(sum(dr - cr), 0) INTO v_balance
			FROM vw_pcc_statement
			WHERE org_id = v_org_id;
		END IF;
		IF(v_function_role = 'consultant')THEN
			SELECT COALESCE(sum(dr - cr), 0) INTO v_balance
			FROM vw_son_statement
			WHERE entity_id = $1;
		END IF;

		IF(v_function_role = 'admin' OR v_function_role = 'staff' OR v_function_role is null )THEN
			SELECT COALESCE(sum(dr - cr), 0) INTO v_balance
			FROM vw_pcc_statement
			WHERE org_id = 0;
		END IF;
		RETURN v_balance;
	END;
$$ LANGUAGE plpgsql;
