
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
		

		END IF;
		
END LOOP;
	raise exception ' the balance is%',v_id;
INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_id, NEW.period_id, NEW.org_id, NEW.deposit_amount);
	--msg := 'Loan repaid first of Kes%' v_total_all;
	
	
--INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment)
	--VALUES (v_id, NEW.period_id, NEW.org_id, v_loan);
	
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
		
	RETURN NEW;
END;

$BODY$
  LANGUAGE plpgsql;
   
CREATE TRIGGER ins_investment BEFORE INSERT OR UPDATE ON investments
	FOR EACH ROW EXECUTE PROCEDURE ins_investment();

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON investments
    FOR EACH ROW EXECUTE PROCEDURE upd_action();

    

CREATE OR REPLACE FUNCTION investment_aplication(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'investment applied';
	
	UPDATE investments SET approve_status = 'Approved'
	WHERE (investment_id = CAST($1 as int)) AND (approve_status = 'Draft');

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_applicants()
  RETURNS trigger AS
$BODY$
DECLARE
    rec             RECORD;
    v_entity_id     integer;
    v_exist         integer;
BEGIN

  IF (TG_OP = 'INSERT') then 
        Select count(applicant_email) INTO v_exist from applicants where applicant_email = NEW.applicant_email;
        IF(v_exist != 0) THEN
            Raise exception 'email exists';
        END IF;
  END IF;
  
  IF (TG_OP = 'UPDATE' AND NEW.approve_status = 'Approved') THEN
         
             INSERT INTO members(entity_id,org_id, surname, first_name, middle_name,phone, 
            gender,marital_status,primary_email,objective, details)  
         
    VALUES (New.entity_id,New.org_id,New.Surname,NEW.First_name,NEW.Middle_name,
    New.applicant_phone,New.gender,New.marital_status,New.applicant_email,NEW.objective, NEW.details)
    RETURNING entity_id INTO v_entity_id;
    NEW.entity_id := v_entity_id;
    
        INSERT INTO sys_emailed (sys_email_id, table_id,org_id, table_name)
        VALUES (1,NEW.entity_id,NEW.org_id, 'applicant');
        
  END IF;  
  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_applicants BEFORE INSERT OR UPDATE ON applicants
  FOR EACH ROW  EXECUTE PROCEDURE ins_applicants();
 
 CREATE OR REPLACE FUNCTION ins_members()
  RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
	
	IF (New.primary_email is null)THEN
		RAISE EXCEPTION 'You have to enter an Email';
	ELSIF(NEW.first_name is null) AND (NEW.surname is null)THEN
		RAISE EXCEPTION 'You have need to enter Sur name and full Name';
	
	ELSE
	Raise NOTICE 'Thank you';
	END IF;
	NEW.entity_id := nextval('entitys_entity_id_seq');
	NEW.member_id := nextval('members_member_id_seq');

	INSERT INTO entitys (entity_id,entity_name,org_id,entity_type_id,user_name,primary_email,primary_telephone,function_role,details)
	VALUES (New.entity_id,New.surname,New.org_id::INTEGER,0,NEW.primary_email,NEW.primary_email,NEW.phone,'member',NEW.details) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;

 IF count(v_entity_id > 5) THEN
	INSERT INTO billing(entity_id, org_id, currency_id, end_date, bill_amount)
     VALUES (v_entity_id, New.org_id::INTEGER, 1, current_date::date + integer '365',200);     
	END IF;	
	update members set full_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''));
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
 
 

CREATE TRIGGER ins_members BEFORE INSERT OR UPDATE ON members
  FOR EACH ROW  EXECUTE PROCEDURE ins_members(); 
 

CREATE OR REPLACE FUNCTION gurrantor_accept(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Guranteeing Accepted';
	
	UPDATE gurrantors SET is_accepted = 'True'
	WHERE (gurrantor_id = CAST($1 as int)) AND (amount > 0);

	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION applicant_accept(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Applicant Added';
	
	UPDATE applicants SET approve_status = 'Approved'
	WHERE (entity_id = CAST($1 as int)) AND (applicant_email is not null);

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION subscription_accepted(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Accepted';
	
	UPDATE subscriptions SET approve_status = 'Approved'
	WHERE (subscription_id = CAST($1 as int)) ;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION subscription_rejected(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Accepted';
	
	UPDATE subscriptions SET approve_status = 'Reject'
	WHERE (subscription_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION investment_approved(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Accepted';
	
	UPDATE investments SET approve_status = 'Approved'
	WHERE (investment_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION investment_rejected(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Rejected';
	
	UPDATE investments SET approve_status = 'Rejected'
	WHERE (investment_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION investment_processed(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Processed';
	
	UPDATE investments SET approve_status = 'Approved'
	WHERE (investment_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION generate_contribs(
     character varying (20),
	 character varying (20),
    character varying (20))
    
    
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
    character varying(20))
    
    
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
  
  CREATE OR REPLACE FUNCTION bill_processed(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Processed';
	
	UPDATE billing SET processed = 'True'
	WHERE (bill_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bill_paid(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'PAYMENTS RECEIVED';
	
	UPDATE billing SET paid = 'True'
	WHERE (bill_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION applicant_approve(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Applicant Approved';
	
	UPDATE applicants SET approve_status = 'Approved'
	WHERE (applicant_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION applicant_rejected(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Applicant Rejected';
	
	UPDATE applicants SET approve_status = 'Rejected'
	WHERE (applicant_id = CAST($1 as int));

	return msg;
END;
$$ LANGUAGE plpgsql;


     
CREATE OR REPLACE FUNCTION get_total_repayment(real, real, real) RETURNS real AS $$
DECLARE
	repayment real;
	ri real;
BEGIN
	ri := (($1* $2 * $3)/1200);
	repayment := $1 + (($1* $2 * $3)/1200);
	RETURN repayment;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_interest_amount(real,real,real) RETURNS real AS $$
DECLARE
	ri real;
BEGIN
	ri :=(($1* $2 * $3)/1200);
RETURN ri;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE VIEW vw_sacco_investments AS 
 SELECT currency.currency_id, currency.currency_name,
    investment_types.investment_type_id, investment_types.investment_type_name,
    bank_accounts.bank_account_id, bank_accounts.bank_account_name,
    sacco_investments.org_id, sacco_investments.sacco_investment_id, sacco_investments.investment_name, sacco_investments.date_of_accrual,
    sacco_investments.principal, sacco_investments.interest, sacco_investments.repayment_period, sacco_investments.initial_payment, sacco_investments.monthly_payments, sacco_investments.investment_status, 
    sacco_investments.approve_status, sacco_investments.workflow_table_id, sacco_investments.action_date, sacco_investments.is_active, sacco_investments.details,
	get_total_repayment(sacco_investments.principal, sacco_investments.interest, sacco_investments.repayment_period) as total_repayment,
	get_interest_amount(sacco_investments.principal, sacco_investments.interest, sacco_investments.repayment_period) as interest_amount
FROM sacco_investments
	JOIN currency ON sacco_investments.currency_id = currency.currency_id
    JOIN investment_types ON sacco_investments.investment_type_id = investment_types.investment_type_id
    LEFT JOIN bank_accounts ON sacco_investments.bank_account_id = bank_accounts.bank_account_id;

    
drop funcion change_password ( character varying, character varying,character varying);

CREATE OR REPLACE FUNCTION change_password(v_entityID integer, v_old_pass varchar(32), v_pass varchar(32)) RETURNS varchar(120) AS $$
DECLARE
    old_password    varchar(64);
    passchange      varchar(120);
    entityID        integer;
BEGIN
    passchange := 'Password Error';
    entityID := CAST($1 AS INT);
    SELECT Entity_password INTO old_password FROM entitys WHERE (entity_id = entityID);

    IF ($2 = '0') THEN
        passchange := first_password();
        UPDATE entitys SET first_password = passchange, Entity_password = md5(passchange) WHERE (entity_id = entityID);
        passchange := 'Password Changed';
    ELSIF (old_password = md5($2)) THEN
        UPDATE entitys SET Entity_password = md5($3) WHERE (entity_id = entityID);
        passchange := 'Password Changed';
    ELSE
        passchange := null;
    END IF;

    return passchange;
END;
$$ LANGUAGE plpgsql;




