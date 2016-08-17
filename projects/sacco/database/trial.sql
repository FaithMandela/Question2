-- Function: ins_contributions()

-- DROP FUNCTION ins_contributions();

CREATE OR REPLACE FUNCTION ins_contributions()
  RETURNS trigger AS
$BODY$
DECLARE
v_contrib_amount    real;
v_id                integer;
v_loan              real;
v_bal               real;
rec                 record;
v_total_all         real;
a_status            varchar(120);
v_total             real;
msg                 varchar(120);
BEGIN

IF (TG_OP = 'INSERT') then  
	v_total_all := 0;
 
	FOR rec IN Select * from vw_loans where entity_id = new.entity_id
		LOOP 

        IF(rec.loan_id is not null and rec.approve_status = 'Approved' ) THEN
			v_id := rec.loan_id;
        
			SELECT Sum(loan_balance) into v_total_all from vw_loans where entity_id = rec.entity_id;
         
			New.loan_repayment:= 'True' ;
         
				IF (NEW.deposit_amount > v_total_all) then
    
					v_bal:= NEW.deposit_amount - v_total_all;
    
					NEW.contribution_amount := v_bal;   
        
				END IF;
        END IF;
            
			INSERT INTO loan_monthly(loan_id, period_id, org_id,repayment)
						VALUES (v_id, NEW.period_id, NEW.org_id,v_bal);
    
		END LOOP;
    --raise exception ' the balance is%',v_id;
    NEW.period_id := nextval('periods_period_id_seq');

    IF (v_bal is not null) then
		INSERT INTO investments (entity_id,investment_type_id, org_id, invest_amount, period_years)
		VALUES (New.entity_id, 0,New.org_id,v_bal,4);
    ELSE
		new.contribution_amount := 0;
    END IF;
		IF NEW.additional_payments > 0 THEN
			INSERT INTO loan_monthly(loan_id, period_id, org_id, additional_payments,repayment)
			VALUES (v_id, NEW.period_id, NEW.org_id, NEW.additional_payments,0);
	END IF;
END IF;


   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
