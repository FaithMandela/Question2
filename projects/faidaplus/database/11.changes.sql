DROP VIEW vw_opening_balance;

CREATE OR REPLACE VIEW vw_opening_balance AS
SELECT a.dr,
   a.cr,
   a.order_date::date AS order_date,
   a.son,
   a.pcc,
   a.org_name,
   a.entity_id,
   a.dr - a.cr AS balance,
   a.points,
   a.segments,
   a.amount,
   a.period
  FROM ( SELECT COALESCE(vw_son_points.points, 0::real) + COALESCE(vw_son_points.bonus, 0::real) AS dr,
		   0::real AS cr,
		   vw_son_points.period AS order_date,
		   vw_son_points.son,
		   vw_son_points.pcc,
		   vw_son_points.org_name,
		   vw_son_points.entity_id,
		   vw_son_points.segments,
	       vw_son_points.amount,
		   vw_son_points.points,
		   vw_son_points.period
		  FROM vw_son_points
	   UNION
		SELECT 0::real AS float4,
		   vw_orders.grand_total AS order_total_amount,
		   vw_orders.order_date,
		   vw_orders.son,
		   vw_orders.pcc,
		   vw_orders.org_name,
		   vw_orders.entity_id,
		   0::real as segments,
		   0::real as amount,
		   0::real as points,
		   null::date as period
		  FROM vw_orders) a
 ORDER BY a.order_date;



 CREATE OR REPLACE VIEW vw_bonus AS
  SELECT bonus.bonus_id, bonus.consultant_id,  bonus.period_id,  bonus.entity_id, bonus.org_id,
  bonus.son, bonus.pcc, bonus.start_date,
  bonus.end_date, bonus.percentage, bonus.amount, bonus.is_active, bonus.approve_status ,
  bonus.workflow_table_id, bonus.application_date ,
  bonus.action_date, bonus.details, orgs.org_name
  FROM bonus
  INNER JOIN orgs ON orgs.org_id = bonus.org_id;



CREATE OR REPLACE FUNCTION ins_applicants()  RETURNS trigger AS $BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (trim(lower(user_name)) = trim(lower(NEW.user_name)));

		IF(v_entity_id is not null)THEN
			RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
		END IF;
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (1, NEW.applicant_id, 'applicants', 3);
	END IF;
	RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;
