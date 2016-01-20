
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
	FOR v_loan IN SELECT * FROM vw_loans WHERE approve_status = 'Completed' AND is_closed = false AND entity_id = 0
		LOOP
		-- for all loans insert loan repayment
		RAISE NOTICE 'Loan Id : %' , v_loan.loan_id;
		-- here you can check for balance to chose whether or not to close loan
		INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
		VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
		v_contrib_amount := v_contrib_amount - v_loan.monthly_repayment;

		END LOOP;
	NEW.contribution_amount = v_contrib_amount;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_contributions BEFORE INSERT ON contributions
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
				VALUES (NEW.entity_id, rec.org_id, 4, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant');
			ELSE
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

		INSERT INTO sys_emailed (sys_email_id, table_id, table_name)
		VALUES (1, NEW.entity_id, 'applicant');
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;
	END IF;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
  
CREATE TRIGGER ins_applicants
  BEFORE INSERT OR UPDATE
  ON applicants
  FOR EACH ROW
  EXECUTE PROCEDURE ins_applicants();