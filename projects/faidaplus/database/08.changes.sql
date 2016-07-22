CREATE OR REPLACE FUNCTION upd_orders_status(varchar(12), varchar(12), varchar(12),varchar(12))	RETURNS varchar(120) AS $$
DECLARE
	msg 		varchar(20);
	details 	text;
	v_org_id                integer;
	v_entity_id            integer;
	v_sms_number		varchar(25);
BEGIN

	IF ($3::integer = 1) THEN
		SELECT entity_id, phone_no INTO v_entity_id, v_sms_number
		FROM orders WHERE (order_id = $1::integer);
		IF(v_sms_number = '') THEN
			SELECT org_id, entity_id, primary_telephone INTO v_org_id, v_entity_id, v_sms_number
			FROM entitys WHERE (entity_id = v_entity_id);
		ELSE
			SELECT org_id INTO v_org_id
			FROM entitys WHERE (entity_id = v_entity_id);
		END IF;
		UPDATE orders SET order_status = 'Awaiting Collection' WHERE order_id = $1::integer;
		details :='Your Order is ready for collection';
		INSERT INTO sms (folder_id, entity_id, org_id, sms_number, message)
	    VALUES (0,v_entity_id, v_org_id, v_sms_number, 'Your Order is ready for collection');
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
