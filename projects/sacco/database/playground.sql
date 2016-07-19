CREATE OR REPLACE FUNCTION generate_contribs(
     character varying (20),
	 character varying (20),
    character varying (20),)
    
    
  RETURNS character varying AS
$BODY$
DECLARE
    rec                        RECORD;
    recu            RECORD;
    v_period_id        integer;
    vi_period_id        integer;
    reca            RECORD;
    v_org_id        integer;
    v_month_name    varchar(50);
    v_member_id        integer;

    msg             varchar(120);
BEGIN
    SELECT period_id, org_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
    FROM periods
    WHERE (period_id = $1::integer);

    SELECT period_id INTO vi_period_id FROM contributions WHERE period_id in (v_period_id) AND org_id in (v_org_id);

    IF( vi_period_id is null) THEN

    FOR reca IN SELECT member_id, surname,entity_id FROM members WHERE (org_id = v_org_id) LOOP
    
    FOR rec IN SELECT contribution_type_id, org_id, contribution_type_name, interval_days, amount
    FROM contribution_types WHERE  (org_id = v_org_id) LOOP
    
    IF(rec.loan_repayment = false) THEN
        IF (rec.interval_days = 7 ) THEN
        FOR i in 1..4 LOOP
            INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount, member_id, entity_id)
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
            reca.member_id, reca.entity_id);
        END LOOP;
        END IF;
        IF (rec.interval_days = 14) THEN
        FOR i in 1..2 LOOP
             INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END LOOP;
        END IF;
        IF (rec.interval_days = 30) THEN
            INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
            IF (rec.interval_days = 90) THEN
              INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
        IF (rec.interval_days = 180) THEN
              INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
           IF (rec.interval_days = 365) THEN
             INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
        END IF;
  
  END LOOP;
  END LOOP;
    msg := 'Contributions Generated';
    ELSE
    msg := 'Contributions already exist';
    END IF;
    

RETURN msg;    
END;
$BODY$
  LANGUAGE plpgsql;CREATE OR REPLACE FUNCTION generate_contribs(
     character varying (20),
    character varying (20),
    character varying(20),)
    
    
  RETURNS character varying AS
$BODY$
DECLARE
    rec                        RECORD;
    recu            RECORD;
    v_period_id        integer;
    vi_period_id        integer;
    reca            RECORD;
    v_org_id        integer;
    v_month_name    varchar(50);
    v_member_id        integer;

    msg             varchar(120);
BEGIN
    SELECT period_id, org_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
    FROM periods
    WHERE (period_id = $1::integer);

    SELECT period_id INTO vi_period_id FROM contributions WHERE period_id in (v_period_id) AND org_id in (v_org_id);

    IF( vi_period_id is null) THEN

    FOR reca IN SELECT member_id, surname,entity_id FROM members WHERE (org_id = v_org_id) LOOP
    
    FOR rec IN SELECT contribution_type_id, org_id, contribution_type_name, interval_days, amount
    FROM contribution_types WHERE  (org_id = v_org_id) LOOP
    
    IF(rec.loan_repayment = false) THEN
        IF (rec.interval_days = 7 ) THEN
        FOR i in 1..4 LOOP
            INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount, member_id, entity_id)
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
            reca.member_id, reca.entity_id);
        END LOOP;
        END IF;
        IF (rec.interval_days = 14) THEN
        FOR i in 1..2 LOOP
             INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END LOOP;
        END IF;
        IF (rec.interval_days = 30) THEN
            INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
            IF (rec.interval_days = 90) THEN
              INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
        IF (rec.interval_days = 180) THEN
              INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
           IF (rec.interval_days = 365) THEN
             INSERT INTO contributions (period_id,entity_id, org_id, contribution_type_id, entity_name, contribution_amount, entry_date, entity_id, transaction_ref)
            VALUES(v_period_id, rec.org_id, rec.contribution_type_id, reca.entity_name, rec.amount, reca.member_id, reca.entity_id, 'Auto generated');
        END IF;
        END IF;
  
  END LOOP;
  END LOOP;
    msg := 'Contributions Generated';
    ELSE
    msg := 'Contributions already exist';
    END IF;
    

RETURN msg;    
END;
$BODY$
  LANGUAGE plpgsql;
