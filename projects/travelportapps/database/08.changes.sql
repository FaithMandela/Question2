

CREATE TABLE jamboverify (
	jv_id					serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	jv_tranid				varchar(320),
	jv_merchant_orderid			integer references passengers,
	jv_amount				real,
	jv_currency				varchar(10),
	jv_timestamp				timestamp default now(),
	jv_password				varchar(240),
	jv_verifed				boolean default false,
	details					text
);
CREATE INDEX jamboverify_entity_id ON jp_pay (entity_id);
CREATE INDEX jamboverify_org_id ON jp_pay (org_id);

    INSERT INTO sys_emails( sys_email_id, org_id, sys_email_name,  title,  use_type)
    VALUES (7, 0, 'Email Verification', 'Email Verification',  5);

    ALTER TABLE entitys ADD COLUMN verifykey varchar(100);

	INSERT INTO sys_emails( sys_email_id, org_id, sys_email_name,  title,  use_type)	VALUES (8, 0, 'Password Reset', 'Password Reset',  4);
