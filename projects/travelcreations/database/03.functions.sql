
CREATE OR REPLACE FUNCTION ins_client()  RETURNS trigger AS $$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (trim(lower(user_name)) = trim(lower(NEW.user_name)));
		IF(v_entity_id is null)THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (trim(lower(client_code)) = trim(lower(NEW.client_code)));
		END IF;

		IF(v_entity_id is not null)THEN
			RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
		END IF;
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (1, NEW.client_id, 'clients', 3);
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_client BEFORE INSERT OR UPDATE ON clients
FOR EACH ROW  EXECUTE PROCEDURE ins_client();

CREATE OR REPLACE FUNCTION upd_clients(varchar(12), varchar(12), varchar(12),varchar(12)) RETURNS varchar(120) AS $$
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
		SELECT * INTO app FROM clients WHERE client_id = $1::integer;
		SELECT entity_id INTO rec FROM entitys WHERE (trim(lower(client_code)) = trim(lower(app.client_code)));

		IF(rec IS NOT NULL)THEN
			RAISE EXCEPTION 'Client Code already exist use a different client code provided by Travelcreations';
		END IF;

		UPDATE clients SET ar_status = ps , approve_status = ps WHERE client_id = $1::integer ;
		INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, primary_email, primary_telephone, function_role, is_active, client_code, client_dob)
		VALUES (app.org_id, 0, app.client_name, trim(lower(app.user_name)), trim(lower(app.client_email)), app.phone_no, 'client', true, app.client_code, app.client_dob) returning entity_id INTO myid;
		msg := 'Client account has been activated';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (2, myid, 'entitys', 3);
	END IF;

	IF ($3::integer = 2) THEN
		ps := 'Rejected';
		UPDATE clients SET ar_status = ps , approve_status = ps WHERE client_id = $1::integer ;
		msg := 'Clients Rejected';
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (3, $1::integer , 'clients', 3);
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE entitys SET is_active = true WHERE entity_id = $1::integer ;
		msg := 'Clients Activated';
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_orders()
  RETURNS trigger AS
$BODY$
DECLARE
	v_order integer;
BEGIN

	INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type, narrative)
	VALUES (4, NEW.order_id , 'vw_orders', 3, '<p>Your order has been received and is being processed. Once ready an email notification will be sent to you.</p><p>Order details :-</p>'||get_order_details(NEW.order_id)||'<p>Total amount</p>');
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

  CREATE TRIGGER ins_orders
   AFTER INSERT
   ON orders
   FOR EACH ROW
   EXECUTE PROCEDURE ins_orders();

CREATE OR REPLACE FUNCTION upd_orders_status(varchar(12), varchar(12), varchar(12),varchar(12))	RETURNS varchar(120) AS $$
DECLARE
	msg 		varchar(20);
	details 	text;
BEGIN

	IF ($3::integer = 1) THEN
		UPDATE orders SET order_status = 'Awaiting Collection' WHERE order_id = $1::integer;
		details :='This has been processed and is ready for collection';

	END IF;

	IF ($3::integer = 2) THEN
		UPDATE orders SET order_status = 'Collected' WHERE order_id = $1::integer;
		details := 'Your Order has been collected';
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE orders SET order_status = 'Closed' WHERE order_id = $1::integer;
	END IF;

	INSERT INTO sys_emailed (table_id, sys_email_id, table_name, email_type, org_id,narrative)
	VALUES ($1::integer,4 ,'orders', 3, 0,details);
	RETURN 'Successfully Updated';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_bonus(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec						RECORD;
	v_period				varchar(7);
	period					date;
	v_start_date			date;
	v_period_id				integer;
	v_period_bonus_ps		real;
	v_period_bonus_amount	real;
	v_pcc_bonus_ps			real;
	v_pcc_bonus_amount		real;
	v_son_bonus_ps			real;
	v_son_bonus_amount		real;
	v_bonus					real;
	msg 					varchar(120);
BEGIN

	v_period_id = $1::integer;
	SELECT start_date, end_date, to_char(start_date, 'mmyyyy') INTO v_start_date, period, v_period
	FROM periods WHERE period_id = v_period_id AND closed = false;
	IF(v_period IS NULL)THEN RAISE EXCEPTION 'Period is closed'; END IF;

	SELECT percentage, amount INTO v_period_bonus_ps, v_period_bonus_amount
	FROM bonus
	WHERE (period_id = $1::integer) AND (is_active = true) AND (approve_status = 'Approved');
	IF(v_period_bonus_ps is null)THEN v_period_bonus_ps := 0; END IF;
	IF(v_period_bonus_amount is null)THEN v_period_bonus_amount := 0; END IF;

	FOR rec IN SELECT loyalty_points_id, entity_id, period_id, segments, amount, points, bonus
	FROM loyalty_points WHERE (period_id = $1::integer) LOOP


		SELECT percentage, amount INTO v_son_bonus_ps, v_son_bonus_amount
		FROM bonus
		WHERE (entity_id = rec.entity_id) AND (is_active = true) AND (approve_status = 'Approved')
			AND (start_date <= v_start_date) AND ((end_date is null) OR (end_date >= v_start_date));
		IF(v_son_bonus_ps is null)THEN v_son_bonus_ps := 0; END IF;
		IF(v_son_bonus_amount is null)THEN v_son_bonus_amount := 0; END IF;

		v_bonus := (rec.points * v_period_bonus_ps / 100) + (v_period_bonus_amount);
		v_bonus := v_bonus + (rec.points * v_son_bonus_ps / 100) + (v_son_bonus_amount);

		UPDATE loyalty_points SET bonus = v_bonus WHERE loyalty_points_id = rec.loyalty_points_id;

	END LOOP;

	msg := 'Bonus computed';
	RETURN msg;
END;
$$ LANGUAGE plpgsql;


CREATE SEQUENCE batch_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1;

CREATE OR REPLACE FUNCTION upd_orders_batch(varchar(20),varchar(20),varchar(20),varchar(20)) RETURNS varchar(120) AS $BODY$
DECLARE
	v_batch  	integer;
	msg 		varchar(50);
BEGIN
	IF ($3::integer = 1) THEN
		v_batch := (SELECT last_value FROM batch_id_seq) ;
		UPDATE orders SET batch_no = v_batch,batch_date = now() WHERE order_id = $1::integer;
		msg := 'Orders Batched Successfully';
	END IF;

	IF($3::integer = 2)THEN
		v_batch :=nextval('batch_id_seq');
		msg := 'Batch Closed';
	END IF;

	RETURN msg;
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION close_batch_seq()  RETURNS integer AS $BODY$
DECLARE
	v_batch  integer;
BEGIN
	v_batch := nextval('batch_id_seq');
	RETURN v_batch;
END;

$BODY$ LANGUAGE plpgsql ;


CREATE OR REPLACE FUNCTION getPointsBalance(integer) RETURNS real AS $$
DECLARE
	v_org_id 			integer;
	v_function_role		text;
	v_balance			real;
BEGIN
	v_balance = 0::real;
	SELECT COALESCE(sum(balance), 0) INTO v_balance	FROM vw_client_statement WHERE entity_id = $1;
	RETURN v_balance;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getValueBalance( integer)  RETURNS real AS
$$
DECLARE
	v_org_id 			integer;
	v_function_role		text;
	v_balance			real;
	v_value				real;
BEGIN
	v_balance = 0::real;
	SELECT function_role INTO  v_function_role FROM vw_entitys WHERE entity_id = $1;
	SELECT point_value INTO  v_value FROM points_value;

	SELECT COALESCE(sum(balance), 0) INTO v_balance
	FROM vw_client_statement
	WHERE entity_id = $1 ;
	v_balance := v_balance*v_value;
	RETURN v_balance;
END;
$$
  LANGUAGE plpgsql;

  CREATE OR REPLACE FUNCTION getValue()  RETURNS real AS
  $$
  DECLARE
  	v_value				real;
  BEGIN
  	v_value = 0::real;
  	SELECT COALESCE(point_value, 0) INTO  v_value FROM points_value;

  	RETURN v_value;
  END;
  $$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_order_details(integer)
  RETURNS text AS
$BODY$
DECLARE
    rec                        RECORD;
    order_detail            	text;
BEGIN

    order_detail := '';
    FOR rec IN SELECT (vw_order_details.product_quantity || ' @ ' || vw_order_details.product_name ) as details
    FROM vw_order_details WHERE order_id = $1 LOOP
        order_detail := order_detail || ' ' || rec.details;
    END LOOP;

    order_detail := order_detail || ' added to shopping cart';
    order_detail := trim(order_detail);

    return order_detail;
END;
$BODY$
  LANGUAGE plpgsql;


  CREATE OR REPLACE FUNCTION ins_sys_reset()
    RETURNS trigger AS
  $BODY$
  DECLARE
  	v_entity_id			integer;
  	v_org_id			integer;
  	v_password			varchar(32);
  BEGIN
  	SELECT entity_id, org_id INTO v_entity_id, v_org_id
  	FROM entitys
  	WHERE (lower(trim(primary_email)) = lower(trim(NEW.request_email)));

  	IF(v_entity_id is not null) THEN
  		v_password := upper(substring(md5(random()::text) from 3 for 9));

  		UPDATE entitys SET first_password = v_password, entity_password = md5(v_password)
  		WHERE entity_id = v_entity_id;

  		INSERT INTO sys_emailed (org_id, sys_email_id, table_id, table_name, email_type)
  		VALUES(v_org_id, 6, v_entity_id, 'entitys', 2);
  	END IF;

  	RETURN NULL;
  END;
  $BODY$
    LANGUAGE plpgsql;
