CREATE OR REPLACE FUNCTION upd_orders_status(varchar(12), varchar(12), varchar(12),varchar(12))	RETURNS varchar(120) AS $$
DECLARE
	msg 		varchar(20);
	details 	text;
	or_details 	text;
	v_org_id                integer;
	v_entity_id            integer;
	v_sms_number		varchar(25);
	v_order_no			integer;
	v_batch_no			integer;
BEGIN
SELECT entity_id, phone_no,batch_no,order_id INTO v_entity_id, v_sms_number,v_batch_no,v_order_no
FROM orders WHERE (order_id = $1::integer);
	IF ($3::integer = 1) THEN

		IF(v_sms_number = '') THEN
			SELECT org_id, entity_id, primary_telephone INTO v_org_id, v_entity_id, v_sms_number
			FROM entitys WHERE (entity_id = v_entity_id);
		ELSE
			SELECT org_id INTO v_org_id
			FROM entitys WHERE (entity_id = v_entity_id);
		END IF;
		UPDATE orders SET order_status = 'Awaiting Collection' WHERE order_id = $1::integer;
		or_details :='Order '||v_batch_no||'-'||v_order_no||' is ready for collection';
		INSERT INTO sms (folder_id, entity_id, org_id, sms_number, message)
	    VALUES (0,v_entity_id, v_org_id, v_sms_number, or_details);
		INSERT INTO sys_emailed (table_id, sys_email_id, table_name, email_type, org_id,narrative,mail_body)
		VALUES ($1::integer,4 ,'vw_orders', 3, 0,or_details,get_order_details(v_order_no));
	END IF;

	IF ($3::integer = 2) THEN
		UPDATE orders SET order_status = 'Collected' WHERE order_id = $1::integer;
		or_details :=  'Order '||v_batch_no||'-'||v_order_no||' has been collected';
		INSERT INTO sys_emailed (table_id, sys_email_id, table_name, email_type, org_id,narrative,mail_body)
		VALUES ($1::integer,9 ,'vw_orders', 3, 0,or_details,get_order_details(v_order_no));
	END IF;

	IF ($3::integer = 3) THEN
		UPDATE orders SET order_status = 'Closed' WHERE order_id = $1::integer;
	END IF;

	RETURN 'Successfully Updated';
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER ins_orders ON orders ;

CREATE TRIGGER ins_orders AFTER INSERT ON order_details
FOR EACH ROW EXECUTE PROCEDURE ins_orders();

CREATE OR REPLACE FUNCTION ins_orders() RETURNS trigger AS $BODY$
DECLARE
	v_order integer;
BEGIN

	INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type, mail_body, narrative)
	VALUES (5, NEW.order_id , 'vw_orders', 3, get_order_details(NEW.order_id), 'Order '||NEW.order_id||' has been submitted');
	RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upd_orders_batch(varchar(20),varchar(20),varchar(20),varchar(20)) RETURNS varchar(120) AS $BODY$
DECLARE
	v_batch  	integer;
	msg 		varchar(50);
BEGIN
	IF ($3::integer = 1) THEN
		v_batch := (SELECT last_value FROM batch_id_seq) ;
		UPDATE orders SET batch_no = v_batch,batch_date = now() WHERE order_id = $1::integer;
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type, mail_body, narrative)
		VALUES (8, $1::integer , 'vw_orders', 3, get_order_details($1::integer), 'Order '||v_batch||'-'||$1::integer||' is being processed');
		msg := 'Orders Batched Successfully';
	END IF;

	IF($3::integer = 2)THEN
		v_batch :=nextval('batch_id_seq');
		msg := 'Batch Closed';
	END IF;

	RETURN msg;
END;
$BODY$ LANGUAGE plpgsql;
