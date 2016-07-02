  CREATE OR REPLACE FUNCTION ins_contributions()

  RETURNS trigger AS
$BODY$
DECLARE
v_contrib_amount	real;
v_id				integer;
v_loan          	real;
v_bal 				real;
rec 				record;
v_total_all     	real;
a_status			varchar(120);
v_total         	real;
msg             	varchar(120);
BEGIN

 IF (TG_OP = 'INSERT') then  
 v_total_all := 0;
FOR rec IN Select * from vw_loans where entity_id = new.entity_id
LOOP 

        IF(rec.loan_id is not null and rec.approve_status = 'Approved' ) THEN
       
       v_id := rec.loan_id;
        
         SELECT Sum(loan_balance) into v_total_all from vw_loans where entity_id = rec.entity_id;
         
		 New.loan_repayment:= true ;
		 
       IF (NEW.deposit_amount > v_total_all) then
	
	v_bal:= NEW.deposit_amount - v_total_all;
	--raise exception ' the balance is%',v_bal;
	NEW.contribution_amount := v_bal; 	
		END IF;
		

--INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment)
	--VALUES (v_id, NEW.period_id, NEW.org_id, v_loan);
		END IF;
		
END LOOP;
	raise exception ' the balance is%',v_id;
INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_id, NEW.period_id, NEW.org_id, NEW.deposit_amount);
	--msg := 'Loan repaid first of Kes%' v_total_all;
	
	if (v_bal is not null) then
	INSERT INTO investments (entity_id,investment_type_id, org_id, invest_amount, period_years)
	VALUES (New.entity_id, 0,New.org_id,v_bal,4);
	else
	new.contribution_amount := 0;
	END IF;
	
END IF;

   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;


  
  
  
  
  
  
  
  
  
