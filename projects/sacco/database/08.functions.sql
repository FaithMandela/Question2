DROP ins_sys_reset IS EXISTS;
CREATE OR REPLACE FUNCTION ins_sys_reset()
  RETURNS trigger AS
$BODY$
DECLARE
	v_entity_id			integer;
	v_org_id			integer;
	v_password			varchar(32);
BEGIN
	SELECT entity_id, org_id INTO v_entity_id, v_org_id
	FROM entitys
	WHERE (lower(trim(primary_email)) = lower(trim(NEW.request_email)));

	IF(v_entity_id is not null) THEN
		v_password := upper(substring(md5(random()::text) from 3 for 9));

		UPDATE entitys SET first_password = v_password, entity_password = md5(v_password)
		WHERE entity_id = v_entity_id;

		INSERT INTO sys_emailed (org_id, table_id, table_name)
		VALUES(v_org_id, v_entity_id, 'entitys');
	END IF;

	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql;
  
  CREATE TRIGGER ins_sys_reset AFTER INSERT ON sys_reset FOR EACH ROW
  EXECUTE PROCEDURE ins_sys_reset();



CREATE OR REPLACE FUNCTION ins_gurrantors() RETURNS TRIGGER AS $$
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
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_gurrantors AFTER INSERT OR UPDATE ON gurrantors
	FOR EACH ROW EXECUTE PROCEDURE ins_gurrantors();
  
CREATE OR REPLACE FUNCTION ins_contributions() RETURNS trigger AS $$
DECLARE
	v_contrib_amount	real;
	v_loan vw_loans%rowtype;
BEGIN
	v_contrib_amount := 0;
	FOR v_loan IN SELECT * FROM vw_loans WHERE approve_status = 'Approved' AND is_closed = false 
		LOOP
		-- for all loans insert loan repayment
		RAISE NOTICE 'Loan Id : %' , v_loan.loan_id;
		-- here you can check for balance to chose whether or not to close loan
		
		/*INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment) 
		VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);*/
            
		INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
		VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
		v_contrib_amount := v_contrib_amount - v_loan.monthly_repayment;
		
		END LOOP;
	NEW.contribution_amount = v_contrib_amount;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_contributions BEFORE INSERT OR UPDATE On contributions
   FOR EACH ROW EXECUTE PROCEDURE ins_contributions();

  
CREATE OR REPLACE FUNCTION ins_investment() RETURNS TRIGGER AS
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
				SELECT org_id INTO rec
				FROM orgs WHERE (is_default = true);

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, 
					primary_email, primary_telephone, function_role)
				VALUES (NEW.entity_id, rec.org_id, 0, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant');
			ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

		INSERT INTO sys_emailed (table_id, table_name)
		VALUES (NEW.entity_id, 'applicant');
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;

			
	END IF;
	
	IF (NEW.approve_status = 'Approved') THEN 
	INSERT INTO members(
            entity_id,org_id, surname, first_name, middle_name,phone, 
            gender,marital_status,salary,nationality,objective, details)
    VALUES (New.entity_id,New.org_id,New.Surname,NEW.First_name,NEW.Middle_name,
    New.applicant_phone,New.gender,New.marital_status,NEW.salary,NEW.nationality,NEW.objective, NEW.details);
	ELSE
	END IF;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;   


  
CREATE TRIGGER ins_applicants BEFORE INSERT OR UPDATE ON applicants
  FOR EACH ROW  EXECUTE PROCEDURE ins_applicants();
  
  
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON applicants
    FOR EACH ROW EXECUTE PROCEDURE upd_action();
    