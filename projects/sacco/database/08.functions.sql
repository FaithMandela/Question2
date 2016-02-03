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
    
DROP TRIGGER ins_subscriptions IF EXISTS;
-- Function: ins_subscriptions()

-- DROP FUNCTION ins_subscriptions();

CREATE OR REPLACE FUNCTION ins_subscriptions()
  RETURNS trigger AS
$BODY$
DECLARE
	v_entity_id		integer;
	v_org_id		integer;
	v_currency_id	integer;
	v_department_id	integer;
	v_bank_id		integer;
	v_org_suffix    char(2);
	rec 			RECORD;
BEGIN

	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys WHERE lower(trim(user_name)) = lower(trim(NEW.primary_email));
		IF(v_entity_id is null)THEN
			NEW.entity_id := nextval('entitys_entity_id_seq');
			INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, primary_email,  function_role, first_password)
			VALUES (NEW.entity_id, 0, 5, NEW.primary_contact, lower(trim(NEW.primary_email)), lower(trim(NEW.primary_email)), 'subscription', null);
		
			INSERT INTO sys_emailed ( org_id, table_id, table_name)
			VALUES ( 0, 1, 'subscription');
		
		NEW.approve_status := 'Completed';
		NEW.workflow_table_id := '11';
		ELSE
			RAISE EXCEPTION 'You already have an account, login and request for services';
		END IF ;
		
	ELSIF(NEW.approve_status = 'Approved')THEN

		NEW.org_id := nextval('orgs_org_id_seq');
		INSERT INTO orgs(org_id, currency_id, org_name, org_sufix, default_country_id)
		VALUES(NEW.org_id, 2, NEW.business_name, NEW.org_id, NEW.country_id);
		
		
		INSERT INTO currency (org_id, currency_id, currency_name, currency_symbol) VALUES (NEW.org_id, 'Kenya Shillings', 'KES', 'KES');
		
		INSERT INTO currency (org_id, currency_id, currency_name, currency_symbol) VALUES (NEW.org_id,'Kenya Shillings' , 'KES','KES');
		UPDATE orgs SET currency_id = 1 WHERE org_id = NEW.org_id;
	
		
		v_bank_id := nextval('banks_bank_id_seq');
		INSERT INTO banks (org_id, bank_id, bank_name) VALUES (NEW.org_id, v_bank_id, 'Cash');
		INSERT INTO bank_branch (org_id, bank_id, bank_branch_name) VALUES (NEW.org_id, v_bank_id, 'Cash');
		
		UPDATE entitys SET org_id = NEW.org_id, function_role='subscription,admin,staff,finance'
		WHERE entity_id = NEW.entity_id;

		INSERT INTO sys_emailed (sys_email_id, org_id, table_id, table_name)
		VALUES (5, NEW.org_id, NEW.entity_id, 'subscription');
		
		
		
	END IF;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_subscriptions BEFORE INSERT OR UPDATE ON subscriptions
  FOR EACH ROW EXECUTE PROCEDURE ins_subscriptions();