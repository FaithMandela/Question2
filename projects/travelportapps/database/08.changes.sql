alter table passengers add column reminder_email date default current_date ;
alter table passengers add column status character(20) ;
alter table sys_emails add column use_type integer NOT NULL DEFAULT 1;
INSERT INTO sys_emails( sys_email_id, org_id, sys_email_name,  title,  use_type) VALUES (5, 0, 'Reminder', 'Reminder',  2);
INSERT INTO sys_emails( sys_email_id, org_id, sys_email_name,  title,  use_type) VALUES (6, 0, 'Expired', 'Expired',  3);

CREATE OR REPLACE FUNCTION payment_reminder(integer, character varying)
  RETURNS character varying AS
$BODY$
DECLARE
  v_org_id                integer;
  v_entity_name           varchar(120);
BEGIN

  UPDATE  passengers SET reminder_email = current_date WHERE (passenger_id = $2::int);

  RETURN 'Done';
END;
$BODY$
  LANGUAGE plpgsql;

  CREATE OR REPLACE FUNCTION expired_invoice(integer, character varying)
    RETURNS character varying AS
  $BODY$
  DECLARE
    v_org_id                integer;
    v_entity_name           varchar(120);
  BEGIN

    UPDATE  passengers SET status = 'Expired', is_valid = false, reminder_email = current_date WHERE (passenger_id = $2::int);

    RETURN 'Done';
  END;
  $BODY$
    LANGUAGE plpgsql;
