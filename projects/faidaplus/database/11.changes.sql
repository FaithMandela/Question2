CREATE OR REPLACE FUNCTION upd_orders_status(varchar(12), varchar(12), varchar(12),varchar(12))	RETURNS varchar(120) AS $BODY$
DECLARE
	msg 		varchar(20);
	details 	text;
BEGIN

	IF ($3::integer = 1) THEN
		UPDATE orders SET order_status = 'Awaiting Collection' WHERE order_id = $1::integer;
		details :='Your Order is ready for collection';
	END IF;

	IF ($3::integer = 2) THEN
		UPDATE orders SET order_status = 'Collected' WHERE order_id = $1::integer;
		details := 'Your Order has been collected';
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE orders SET order_status = 'Closed' WHERE order_id = $1::integer;
	END IF;

	INSERT INTO sys_emailed (table_id, sys_email_id, table_name, email_type, org_id, narrative)
	VALUES ($1::integer,4 ,'orders', 3, 0, details);
	RETURN 'Successfully Updated';
END;
$BODY$ LANGUAGE plpgsql;

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
		SELECT org_id INTO rec FROM orgs WHERE (pcc = app.pseudo_code);

		IF(rec IS NULL)THEN
			RAISE EXCEPTION 'Pseudo Code Does not Exist';
		END IF;

		UPDATE applicants SET status = ps , org_id = rec.org_id,approve_status = ps WHERE applicant_id = $1::integer ;
		INSERT INTO entitys (org_id, entity_type_id,entity_name, user_name,primary_email, son,function_role,is_active,birth_date)
		VALUES (rec.org_id, 0, app.son,lower(app.applicant_email),lower(app.applicant_email),app.son, 'consultant',true,app.consultant_dob) returning entity_id INTO myid;
		msg := 'Consultant account has been activated';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (2, myid, 'entitys', 3);
	END IF;

	IF ($3::integer = 2) THEN
		ps := 'Rejected';
		UPDATE applicants SET status = ps , approved = false WHERE applicant_id = $1::integer ;
		msg := 'Applicant Rejected';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (3, $1::integer , 'applicants', 3);
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE entitys SET is_active = 'true' WHERE entity_id = $1::integer ;
		msg := 'Consultant Activated';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (2, $1::integer , 'entitys', 3);
	END IF;

	RETURN msg;
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ins_orders() RETURNS trigger AS $BODY$
DECLARE
	v_order integer;
BEGIN
	INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type, narrative)
	VALUES (4, NEW.order_id , 'orders', 4, 'We have received your order and its under process');
	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_entitys() RETURNS trigger AS $$
DECLARE
	v_pcc				varchar(7);
BEGIN

	IF((OLD.change_pcc <> NEW.change_pcc) or (OLD.change_son <> NEW.change_son))THEN
		SELECT pcc INTO v_pcc
		FROM orgs WHERE org_id = NEW.org_id;

		INSERT INTO change_pccs (entity_id, son, pcc, change_son, change_pcc)
		VALUES (NEW.entity_id, trim(upper(NEW.son)) , v_pcc, trim(upper(NEW.change_son)), trim(upper(NEW.change_pcc)));
 	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
