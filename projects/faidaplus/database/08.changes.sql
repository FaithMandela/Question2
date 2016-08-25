
CREATE OR REPLACE VIEW vw_son_points AS
SELECT points.points_id, periods.period_id, periods.start_date as period,
	to_char(periods.start_date, 'mmyyyy'::text) AS ticket_period,
	points.pcc, points.son, points.segments, points.amount,
	points.points, points.bonus, vw_entitys.org_name,
	vw_entitys.entity_name, vw_entitys.entity_id,vw_entitys.user_name,  vw_entitys.pcc AS org_pcc,
vw_entitys.son AS org_son,  vw_entitys.is_active, vw_entitys.account_manager_id, vw_entitys.org_id
FROM points JOIN vw_entitys ON points.entity_id = vw_entitys.entity_id
	INNER JOIN periods ON points.period_id = periods.period_id
	WHERE periods.approve_status = 'Approved';

CREATE OR REPLACE VIEW vw_balance AS 
 SELECT a.dr, a.cr, a.order_date::date, a.org_id,a.son, a.pcc, a.entity_id, a.dr + a.bonus - a.cr AS balance, a.bonus
   FROM ( SELECT COALESCE(vw_son_points.points, 0::real) AS dr,   0::real AS cr, vw_son_points.period AS order_date,
            vw_son_points.org_id,vw_son_points.son, vw_son_points.pcc, vw_son_points.entity_id, COALESCE(vw_son_points.bonus, 0::real) AS bonus
           FROM vw_son_points
        UNION ALL
         SELECT 0::real AS float4, vw_orders.grand_total AS order_total_amount, vw_orders.order_date, vw_orders.org_id, vw_orders.son,
            vw_orders.pcc, vw_orders.entity_id,  0::real AS bonus
               FROM vw_orders ) a
  ORDER BY a.order_date DESC;

CREATE OR REPLACE VIEW vw_pcc_statement AS
SELECT a.dr, a.cr, a.org_id, a.order_date::date AS order_date, a.pcc, a.org_name, a.dr + a.bonus - a.cr AS balance,
   a.details, a.batch_no, a.bonus, a.segments
  FROM ( SELECT COALESCE(vw_org_points.points, 0::real) AS dr,
		   0::real AS cr,   vw_org_points.period AS order_date,   ''::text AS text,
		   vw_org_points.pcc,   vw_org_points.org_name,   0 AS int4,   vw_org_points.org_id,
		   (((('Earnings @ Ksh '::text || vw_org_points.amount) || ' per segment for '::text) || vw_org_points.segments) || ' segments sold in '::text) || vw_org_points.ticket_period AS details,
		   NULL::integer AS batch_no,  COALESCE(vw_org_points.bonus, 0::real) AS bonus,vw_org_points.segments
		  FROM vw_org_points
	   UNION ALL
		SELECT 0::real AS float4,  vw_orders.grand_total AS order_total_amount,   vw_orders.order_date,
		   vw_orders.son,   vw_orders.pcc,   vw_orders.org_name,   vw_orders.entity_id,   vw_orders.org_id,
		   get_order_details(vw_orders.order_id) AS details,   vw_orders.batch_no,   0::real AS bonus, 0::real AS segments
		  FROM vw_orders) a
 ORDER BY a.order_date;



 CREATE OR REPLACE VIEW vw_son_statement AS
 SELECT a.dr, a.cr, a.order_date, a.son, a.pcc,
 		a.org_name, a.entity_id, a.dr+ a.bonus - a.cr AS balance, a.details, a.batch_no,a.bonus
 	FROM ((SELECT (COALESCE(vw_son_points.points, 0::real) ) AS dr,0::real AS cr, vw_son_points.period AS order_date, vw_son_points.son,
 		vw_son_points.pcc, vw_son_points.org_name, vw_son_points.entity_id,
 		('Earnings @ Ksh '||amount||' per segment for '|| segments||' segments sold in '|| ticket_period)as details,
 		NULL::integer AS batch_no, (COALESCE(vw_son_points.bonus, 0::real)) as bonus
 	FROM vw_son_points)
 	UNION ALL
 	(SELECT 0::real AS float4, vw_orders.grand_total::real AS order_total_amount,
 		vw_orders.order_date, vw_orders.son, vw_orders.pcc, vw_orders.org_name,
 		vw_orders.entity_id,
 		get_order_details(vw_orders.order_id) AS details,
 		batch_no, 0::real as bonus
 	FROM vw_orders)) a
 	ORDER BY a.order_date;
    CREATE OR REPLACE FUNCTION generate_points(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
    DECLARE
    	rec						RECORD;
    	v_period				varchar(7);
    	period					date;
    	v_start_date			date;
    	v_increment				integer;
    	v_period_id				integer;
    	v_org_id				integer;
    	v_entity_id				integer;
    	v_points				real;
    	v_points_id				integer;
    	v_root_points			integer;
    	v_amount				real;
    	msg 					varchar(120);
    BEGIN

    	v_period_id = $1::integer;
    	SELECT start_date, end_date, to_char(start_date, 'mmyyyy') INTO v_start_date, period, v_period
    	FROM periods WHERE period_id = v_period_id AND closed = false;
    	IF(v_period IS NULL)THEN RAISE EXCEPTION 'Period is closed'; END IF;

    	IF(v_start_date < '2016-06-01'::date)THEN
    		v_increment := 0;
    	ELSE
    		v_increment := 2;
    	END IF;

    	v_root_points := 0;

    	FOR rec IN SELECT pcc, son, ticketperiod, totalsegs
    	FROM t_sonsegs WHERE (ticketperiod = v_period) LOOP

    		IF(1<= rec.totalsegs::integer AND rec.totalsegs::integer <=250 ) THEN
    			v_amount := 12 + v_increment;
    			v_points := rec.totalsegs * v_amount;
    		END IF;

    		IF(251<= rec.totalsegs::integer AND rec.totalsegs::integer <=500) THEN
    			v_amount := 16 + v_increment;
    			v_points := rec.totalsegs * v_amount;
    		END IF;

    		IF(rec.totalsegs::integer >=501 ) THEN
    			v_amount := 20 + v_increment;
    			v_points := rec.totalsegs * v_amount;
    		END IF;

    		SELECT orgs.org_id, entitys.entity_id INTO v_org_id, v_entity_id
    		FROM orgs INNER JOIN entitys ON orgs.org_id = entitys.org_id
    		WHERE (entitys.is_active = true) AND (orgs.pcc = rec.pcc) AND (entitys.son = rec.son);

    		IF(v_entity_id is null)THEN
    			SELECT entity_id INTO v_entity_id
    			FROM change_pccs
    			WHERE (approve_status = 'Approved') AND (pcc = rec.pcc) AND (son = rec.son);
    			SELECT org_id INTO v_org_id
    			FROM entitys
    			WHERE (entitys.is_active = true) AND (entity_id = v_entity_id);
    			IF(v_org_id is null)THEN v_entity_id := 0; v_org_id := 0; END IF;
    		END IF;
    		IF(v_entity_id is null)THEN v_entity_id := 0; v_org_id := 0; END IF;

    		--- Compute rooot points
    		IF(v_entity_id <> 0)THEN
    			v_root_points := v_root_points + rec.totalsegs;
    		END IF;

    		SELECT points_id INTO v_points_id
    		FROM points WHERE (period_id = v_period_id) AND (entity_id = v_entity_id)
    			AND (pcc = rec.pcc) AND (son = rec.son);

    		IF(v_points_id is null)THEN
    			INSERT INTO points (point_date, period_id, org_id, entity_id, pcc, son, segments, amount, points)
    			VALUES (period, v_period_id, v_org_id, v_entity_id, rec.pcc, rec.son, rec.totalsegs, v_amount, v_points);
    		ELSE
    			UPDATE points SET segments = rec.totalsegs, amount = v_amount, points = v_points
    			WHERE points_id = v_points_id;
    		END IF;
    	END LOOP;

    	IF(v_start_date >= '2016-06-01'::date)THEN
    		SELECT points_id INTO v_points_id
    		FROM points WHERE (period_id = v_period_id) AND (entity_id = 0) AND (pcc is null) AND (son is null);

    		IF(v_points_id is null )THEN
    			INSERT INTO points (point_date, period_id, org_id, entity_id, amount, points)
    			VALUES (period, v_period_id, 0, 0, 2, v_root_points * 2);
    		ELSE
    			UPDATE points SET amount = 2, points = v_root_points * 2
    			WHERE points_id = v_points_id;
    		END IF;
    	END IF;

    	IF(rec IS NULL)THEN
    		RAISE EXCEPTION 'There are no segments for this month';
    	ELSE
    		msg := 'Points computed';
    	END IF;
    	RETURN msg;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getbalance(integer)  RETURNS real AS $$
DECLARE
    v_org_id 			integer;
    v_function_role		text;
    v_balance			real;
BEGIN
    v_balance = 0::real;
    SELECT org_id,function_role INTO v_org_id, v_function_role FROM vw_entitys WHERE entity_id = $1;

    IF(v_function_role = 'manager')THEN
        SELECT COALESCE(sum(dr+bonus - cr), 0) INTO v_balance
        FROM vw_balance
        WHERE org_id = v_org_id;
    END IF;

    IF(v_function_role = 'consultant')THEN
        SELECT COALESCE(sum(dr+bonus - cr), 0) INTO v_balance
        FROM vw_son_statement
        WHERE entity_id = $1;
    END IF;

    IF(v_function_role = 'admin')THEN
        SELECT COALESCE(sum(a.dr+a.bonus - a.cr), 0) INTO v_balance
        FROM ( SELECT COALESCE(vw_son_points.points, 0::real) AS dr,   0::real AS cr, vw_son_points.period AS order_date,
            vw_son_points.org_id,vw_son_points.son, vw_son_points.pcc, vw_son_points.entity_id, COALESCE(vw_son_points.bonus, 0::real) AS bonus
        FROM vw_son_points WHERE entity_id = 0 AND org_id = 0 AND pcc is null AND son is null AND vw_son_points.period::date >= '2016-01-01'::date
        UNION ALL
        SELECT 0::real AS float4, vw_orders.grand_total AS order_total_amount, vw_orders.order_date, vw_orders.org_id, vw_orders.son,
            vw_orders.pcc, vw_orders.entity_id,  0::real AS bonus
        FROM vw_orders WHERE entity_id = $1) a;
    END IF;
    RETURN v_balance;
END;
$$ LANGUAGE plpgsql;


  CREATE OR REPLACE VIEW vw_org_points AS
	SELECT periods.period_id, periods.start_date AS period, to_char(periods.start_date::timestamp with time zone, 'mmyyyy'::text) AS ticket_period,
		vw_orgs.pcc, COALESCE(SUM(points.segments),0.0) AS segments, COALESCE(SUM(points.points),0.0) AS points,
		COALESCE(SUM(points.bonus),0.0) AS bonus, vw_orgs.org_id,vw_orgs.org_name, COALESCE(count(points.son), 0::int) AS son,points.amount,
		vw_orgs.account_manager_id,vw_orgs.account_manager_name
	FROM points
	 JOIN vw_orgs ON points.org_id = vw_orgs.org_id
	 JOIN periods ON points.period_id = periods.period_id WHERE periods.approve_status = 'Approved'
	 GROUP BY periods.period_id,periods.start_date,vw_orgs.pcc,vw_orgs.account_manager_id,vw_orgs.account_manager_name,vw_orgs.org_id,vw_orgs.org_name,periods.approve_status,points.amount
	ORDER BY period desc;
