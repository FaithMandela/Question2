
CREATE OR REPLACE FUNCTION compute_contributions(
    v_period_id character varying,
    v_org_id character varying,
    v_approval character varying)
  RETURNS character varying AS
$BODY$
DECLARE
    msg                 varchar(120);
BEGIN
    DELETE FROM loan_monthly WHERE period_id = v_period_id::integer AND org_id = v_org_id::integer;
    
    
    DELETE FROM contributions WHERE period_id = v_period_id::integer;

    
    INSERT INTO contributions(period_id, org_id, entity_id,  payment_type_id, contribution_type_id, 
            entity_name, deposit_amount, loan_repayment, entry_date,
             transaction_ref, additional_payments,is_paid)
		
             
    SELECT v_period_id::integer, org_id::integer,entity_id, 0,0, first_name, contribution, 'False', 
            now()::date, 'Auto generated', 0, 'False'
        FROM members;
msg = ' Its done';
    
    RETURN msg;
END;
$BODY$
  LANGUAGE plpgsql;
