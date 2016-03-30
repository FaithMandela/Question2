
CREATE OR REPLACE FUNCTION ins_gurrantors()
  RETURNS trigger AS
$BODY$
DECLARE
	v_total_guranteed 	real;
	v_monthly_repayment	real;
	v_period		real;
	v_amount  		real;
BEGIN
	SELECT SUM(amount) INTO v_total_guranteed FROM gurrantors WHERE loan_id = NEW.loan_id ;
	SELECT (repayment_period * monthly_repayment) INTO v_amount FROM loans WHERE loan_id = NEW.loan_id;
			
			IF((NEW.amount) > v_amount ) THEN
			RAISE EXCEPTION 'The Max amount for this entry is %', (v_amount - v_total_guranteed );
			ELSE IF (v_total_guranteed > v_amount) THEN
			RAISE EXCEPTION 'The amount gurranteed has been exceeded by %' ,(v_amount-v_total_guranteed);
			New.amount:= 0;
				END IF;
			END IF;
	IF (TG_OP = 'UPDATE') THEN
	  UPDATE loans
    SET approve_status = 'Completed';
	RAISE NOTICE ' Loan Completed';
	 END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_gurrantors AFTER INSERT OR UPDATE ON gurrantors
	FOR EACH ROW EXECUTE PROCEDURE ins_gurrantors();


CREATE OR REPLACE FUNCTION ins_contributions()
  RETURNS trigger AS
$BODY$
DECLARE
v_contrib_amount	real;
v_loan vw_loans%rowtype;
BEGIN
FOR v_loan IN SELECT * FROM vw_loans WHERE approve_status = 'Completed' AND is_closed = false
LOOP
INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
	
INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
END LOOP;

NEW.contribution_amount = NEW.deposit_amount - v_loan.monthly_repayment; 
   RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

  
CREATE TRIGGER ins_contributions BEFORE INSERT OR UPDATE On contributions
   FOR EACH ROW EXECUTE PROCEDURE ins_contributions();

  


CREATE OR REPLACE FUNCTION ins_investment()
  RETURNS trigger AS
$BODY$
DECLARE
	v_interests			real;
	v_invest			real;
	v_totals			real;
BEGIN
	SELECT interest_type INTO v_interests FROM  investment_types WHERE investment_type_id = NEW. investment_type_id;
		
		NEW.default_interest := v_interests;
		v_invest := NEW.invest_amount + (NEW.invest_amount * NEW.default_interest/100 );
		NEW.return_on_investment := v_invest - NEW.invest_amount;
		NEW.yearly_dividend :=(v_invest/ NEW.period_years);
		NEW.withdrwal_amount := v_invest;
		NEW.approve_status := 'Completed';
	RETURN NEW;
END;

$BODY$
  LANGUAGE plpgsql;
   
CREATE TRIGGER ins_investment BEFORE INSERT OR UPDATE ON investments
	FOR EACH ROW EXECUTE PROCEDURE ins_investment();

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON investments
    FOR EACH ROW EXECUTE PROCEDURE upd_action();


CREATE OR REPLACE FUNCTION ins_applicants()
  RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		
		IF(NEW.entity_id IS NULL) THEN
			SELECT entity_id INTO v_entity_id
			FROM entitys
			WHERE (trim(lower(user_name)) = trim(lower(NEW.applicant_email)));
				
			IF(v_entity_id is null)THEN
				

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, 
					primary_email, primary_telephone, function_role)
				VALUES (NEW.entity_id, New.org_id, 0, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant,member');
					ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

		INSERT INTO sys_emailed (table_id,org_id, table_name)
		VALUES (NEW.entity_id,NEW.org_id, 'applicant');
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_applicants BEFORE INSERT OR UPDATE ON applicants
  FOR EACH ROW  EXECUTE PROCEDURE ins_applicants();

CREATE OR REPLACE FUNCTION upd_applicants()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (NEW.approve_status = 'Approved') THEN 
	INSERT INTO members(entity_id,org_id, surname, first_name, middle_name,phone, 
            gender,marital_status,objective, details)
	VALUES (New.entity_id,New.org_id,New.Surname,NEW.First_name,NEW.Middle_name,
	New.applicant_phone,New.gender,New.marital_status,NEW.objective, NEW.details);
		ELSE
			END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;  
  
  
CREATE TRIGGER upd_applicants AFTER INSERT OR UPDATE ON applicants
    FOR EACH ROW EXECUTE PROCEDURE upd_applicants();
  
  
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON applicants
    FOR EACH ROW EXECUTE PROCEDURE upd_action();
    

---here

  
 CREATE OR REPLACE FUNCTION ins_members()
  RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
	
BEGIN
	IF (TG_OP = 'INSERT') THEN
	NEW.entity_id := nextval('entitys_entity_id_seq');
	
	INSERT INTO entitys (entity_id,entity_name,org_id,entity_type_id,user_name,primary_email,primary_telephone,function_role,details)
	VALUES (New.entity_id,New.surname,New.org_id::INTEGER,1,NEW.primary_email,NEW.primary_email,NEW.phone,'member',NEW.details) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;

	update members set full_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''));
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_members BEFORE INSERT OR UPDATE ON members
  FOR EACH ROW  EXECUTE PROCEDURE ins_members(); 




