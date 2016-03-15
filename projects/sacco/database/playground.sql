<<<<<<< HEAD

CREATE VIEW vw_loans AS
	SELECT 	vw_loans.currency_id, vw_loans.currency_name,vw_loans.currency_symbol,
		vw_loans.loan_type_id, vw_loans.loan_type_name, 
		vw_loans.entity_id, vw_loans.entity_name,
		vw_loans.org_id, vw_loans.loan_id, vw_loans.principle, vw_loans.interest, vw_loans.monthly_repayment, vw_loans.reducing_balance, 
		vw_loans.repayment_period,vw_loans.application_date, vw_loans.approve_status, vw_loans.initial_payment, 
		vw_loans.loan_date, vw_loans.action_date,vw_loans.details,
		vw_loans.repayment_amount, vw_loans.total_interest, vw_loans. loan_balance,
		loan_repayment.loan_repayment_id, loan_repayment.period_id,
		loan_repayment.repayment_amount as loan_repayment_amount,
		loan_repayment.repayment_interest,
		loan_repayment.penalty, loan_repayment.penalty_paid,
		loan_repayment.repayment_narrative,
		vw_loans.calc_repayment_period
	FROM vw_loans
	INNER JOIN loan_repayment ON loan_repayment.loan_id = vw_loans.loan_id
=======
  
CREATE OR REPLACE FUNCTION ins_members()
RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
	
BEGIN
	IF (TG_OP = 'INSERT') THEN
	NEW.entity_id := nextval('entitys_entity_id_seq');
	
	INSERT INTO entitys (entity_id,org_id,entity_name,entity_type_id,user_name,primary_email,primary_telephone,function_role,details)
	VALUES (New.entity_id,New.surname,New.org_id::INTEGER,1,NEW.primary_email,NEW.primary_email,NEW.phone,'member',NEW.details) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;

	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE members  SET full_names = 
(NEW.Surname || ' ' 
|| NEW.First_name || ' ' 
|| COALESCE(NEW.Middle_name, ''))
	WHERE entity_id = NEW.entity_id;
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;   


CREATE TRIGGER ins_members BEFORE INSERT OR UPDATE ON members
  FOR EACH ROW  EXECUTE PROCEDURE ins_members();
  

  
  
  
  
  
CREATE OR REPLACE FUNCTION ins_applicants()
RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN

IF (TG_OP = 'INSERT') THEN
update applicants set entity_id := 0;
else
END IF;

	IF (NEW.approve_status = 'Approved') THEN
		

	INSERT INTO members(
            entity_id,org_id, person_title, full_name, 
            surname, first_name, middle_name,primary_email,phone, date_of_birth, gender, marital_status, 
             language, interests, objective,details )
	
	VALUES(NEW.entity_id, NEW.org_id,NEW.person_title,NEW.surname, NEW.surname, NEW.first_name, NEW.middle_name, 
            NEW.applicant_email, NEW.applicant_phone, NEW.date_of_birth, NEW.gender, 
            NEW.marital_status, NEW.language, NEW.interests, NEW.objective, NEW.details) RETURNING entity_id INTO v_entity_id;
            
	NEW.entity_id := v_entity_id;
	ELSE 
	--RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
	END IF;
	
	INSERT INTO sys_emailed (table_id,org_id, table_name)
		VALUES (v_entity_id,NEW.org_id, 'applicant');
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;   


CREATE TRIGGER ins_applicants BEFORE INSERT OR UPDATE ON applicants
  FOR EACH ROW  EXECUTE PROCEDURE ins_applicants();
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8

