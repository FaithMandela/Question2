
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

		IF(rec IS NULL)THEN
			RAISE EXCEPTION 'Client Code Does not Exist use an existing client code provided by Travelcreations';
		END IF;

		UPDATE clients SET ar_status = ps , approve_status = ps WHERE client_id = $1::integer ;
		INSERT INTO entitys (org_id, entity_type_id, entity_name, user_name, primary_email, primary_telephone, function_role, is_active, client_dob)
		VALUES (app.org_id, 0, app.client_name, trim(lower(app.user_name)), trim(lower(app.client_email)), app.phone_no, 'client', true, app.client_dob) returning entity_id INTO myid;
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


CREATE OR REPLACE FUNCTION getbalance(integer) RETURNS real AS $$
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

CREATE OR REPLACE FUNCTION upd_orders_status(varchar(12), varchar(12), varchar(12),varchar(12))	RETURNS varchar(120) AS $$
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
