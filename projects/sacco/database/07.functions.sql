
drop view vw_periods cascade;

CREATE VIEW vw_periods AS
	SELECT fiscal_years.fiscal_year_id, fiscal_years.fiscal_year_start, fiscal_years.fiscal_year_end,
		fiscal_years.year_opened, fiscal_years.year_closed,

		periods.period_id, periods.org_id, 
		periods.start_date, periods.end_date, periods.opened, periods.activated, periods.closed, 
		periods.overtime_rate, periods.per_diem_tax_limit, periods.is_posted, 
		periods.gl_payroll_account, periods.gl_bank_account, periods.gl_advance_account,
		periods.bank_header, periods.bank_address, periods.details,

		date_part('month', periods.start_date) as month_id, to_char(periods.start_date, 'YYYY') as period_year, 
		to_char(periods.start_date, 'Month') as period_month, (trunc((date_part('month', periods.start_date)-1)/3)+1) as quarter, 
		(trunc((date_part('month', periods.start_date)-1)/6)+1) as semister,
		to_char(periods.start_date, 'YYYYMM') as period_code
	FROM periods LEFT JOIN fiscal_years ON periods.fiscal_year_id = fiscal_years.fiscal_year_id
	ORDER BY periods.start_date;

CREATE VIEW vw_period_year AS
	SELECT org_id, period_year
	FROM vw_periods
	GROUP BY org_id, period_year
	ORDER BY period_year;

CREATE VIEW vw_period_quarter AS
	SELECT org_id, quarter
	FROM vw_periods
	GROUP BY org_id, quarter
	ORDER BY quarter;

CREATE VIEW vw_period_semister AS
	SELECT org_id, semister
	FROM vw_periods
	GROUP BY org_id, semister
	ORDER BY semister;

CREATE VIEW vw_period_month AS
	SELECT org_id, month_id, period_year, period_month
	FROM vw_periods
	GROUP BY org_id, month_id, period_year, period_month
	ORDER BY month_id, period_year, period_month;



CREATE OR REPLACE FUNCTION ins_fiscal_years() RETURNS trigger AS $$
BEGIN
	INSERT INTO periods (fiscal_year_id, org_id, start_date, end_date)
	SELECT NEW.fiscal_year_id, NEW.org_id, period_start, CAST(period_start + CAST('1 month' as interval) as date) - 1
	FROM (SELECT CAST(generate_series(fiscal_year_start, fiscal_year_end, '1 month') as date) as period_start
		FROM fiscal_years WHERE fiscal_year_id = NEW.fiscal_year_id) as a;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION ins_periods() RETURNS trigger AS $$
DECLARE
	year_close 		BOOLEAN;
BEGIN
	SELECT year_closed INTO year_close
	FROM fiscal_years
	WHERE (fiscal_year_id = NEW.fiscal_year_id);
	
	IF(TG_OP = 'UPDATE')THEN    
		IF (OLD.closed = true) AND (NEW.closed = false) THEN
			NEW.approve_status := 'Draft';
		END IF;
	END IF;

	IF (NEW.approve_status = 'Approved') THEN
		NEW.opened = false;
		NEW.activated = false;
		NEW.closed = true;
	END IF;

	IF(year_close = true)THEN
		RAISE EXCEPTION 'The year is closed not transactions are allowed.';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


------------Hooks to approval trigger




CREATE OR REPLACE FUNCTION ins_contributions()
  RETURNS trigger AS
$BODY$
DECLARE
v_period        integer;
v_loan          record;
v_count         integer;
v_contrib_amount    real;
v_deposit_amount    real;
msg                 varchar(120);

BEGIN
   IF (TG_OP = 'UPDATE' and New.is_paid = 'True') THEN  
    v_contrib_amount := NEW.deposit_amount;
   
    v_count := 0;
  SELECT period_id, start_date, end_date INTO v_period from periods where opened = true and activated = true;
     v_period := NEW.period_id ; 
    
  
        FOR v_loan IN Select * from vw_loans where  approve_status = 'Approved' AND loan_balance > 0 AND  entity_id = NEW.entity_id
        LOOP 
            SELECT count(loan_month_id) INTO v_count FROM loan_monthly WHERE loan_id = v_loan.loan_id AND period_id = v_period;
            IF( v_count = 0) THEN
                IF(v_contrib_amount >= v_loan.monthly_repayment) THEN
                    
                    INSERT INTO loan_monthly(loan_id, period_id, org_id,repayment, interest_amount, interest_paid, penalty,                                     penalty_paid, details, additional_payments,is_paid)
                    VALUES (v_loan.loan_id, v_period, NEW.org_id, v_loan.monthly_repayment, 
                        (v_loan.loan_balance * v_loan.interest / 1200), 
                        (v_loan.loan_balance * v_loan.interest / 1200), 0, 0, 'Loan Repayment', 0,'True');

                    NEW.loan_repayment = True;
                    v_contrib_amount := (v_contrib_amount - v_loan.monthly_repayment);
                END IF;
            END IF;

        END LOOP;
    END IF;
    NEW.contribution_amount := v_contrib_amount;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

  
  CREATE TRIGGER ins_contributions  BEFORE INSERT OR UPDATE  ON contributions
  FOR EACH ROW
  EXECUTE PROCEDURE ins_contributions();
  
  
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
	ELSEIF(new.contribution is null) then
	RAISE EXCEPTION 'You have need to enter contribution amount';
	ELSE
	Raise NOTICE 'Thank you';
	END IF;
	NEW.entity_id := nextval('entitys_entity_id_seq');
	NEW.member_id := nextval('members_member_id_seq');

	INSERT INTO entitys (entity_id,entity_name,org_id,entity_type_id,user_name,primary_email,primary_telephone,function_role,details,exit_amount)
	VALUES (New.entity_id,New.surname,New.org_id::INTEGER,0,NEW.primary_email,NEW.primary_email,NEW.phone,'member',NEW.details,new.contribution) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;


	update members set full_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')) where entity_id = v_entity_id ;
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
 
 

CREATE TRIGGER ins_members BEFORE INSERT OR UPDATE ON members
  FOR EACH ROW  EXECUTE PROCEDURE ins_members(); 
  
  
  CREATE OR REPLACE FUNCTION ins_gurrantors() RETURNS trigger AS $$
DECLARE
    rec_loan            record;
    v_shares            real;
    v_grnt_shares           real;
    v_active_loans          integer;
    v_active_loans_grnt     integer;
    v_tot_loan_balance      real;
    v_tot_loan_balance_grnt     real;
    v_amount_already_grntd      real;
    can_gurrantee           boolean;
    msg                         varchar(120);
BEGIN
    msg := 'Loan gurranteed';
    can_gurrantee  := true;
    v_active_loans := 0;
    v_tot_loan_balance_grnt := 0;
    v_amount_already_grntd := 0;
    
    SELECT * INTO rec_loan FROM vw_loans WHERE loan_id = NEW.loan_id; --LOAN TO BE GURRANTEED
    
    SELECT COALESCE(SUM(contribution_amount + additional_payments), 0) INTO v_shares FROM contributions where entity_id = rec_loan.entity_id; -- LOANEE SHARES
    SELECT COALESCE(SUM(contribution_amount + additional_payments), 0) INTO v_grnt_shares FROM contributions where entity_id = NEW.entity_id; -- GRNT SHARES

    SELECT COALESCE(SUM(loan_balance), 0) INTO v_tot_loan_balance FROM vw_loans WHERE entity_id = rec_loan.entity_id AND approve_status = 'Approved' AND loan_balance > 0; --LOANEE ACTIVE LOAN SUM
    SELECT COALESCE(SUM(loan_balance), 0) INTO v_tot_loan_balance_grnt FROM vw_loans WHERE entity_id = NEW.entity_id AND approve_status = 'Approved' AND loan_balance > 0; --GRNT ACTIVE LOAN SUM
    
    SELECT COALESCE(COUNT(loan_id), 0) INTO v_active_loans FROM vw_loans WHERE entity_id = rec_loan.entity_id AND approve_status = 'Approved' AND loan_balance > 0; --LOANEE COUNT
    SELECT COALESCE(COUNT(loan_id), 0) INTO v_active_loans_grnt FROM vw_loans WHERE entity_id = NEW.entity_id AND approve_status = 'Approved' AND loan_balance > 0; --GRNT COUNT

    SELECT COALESCE(SUM(amount), 0) INTO v_tot_loan_balance_grnt FROM gurrantors WHERE loan_id = NEW.loan_id; --CHECK ALREADY GURRANTEED AMOUNT;
    --RAISE EXCEPTION 'rec_loan.principle % | v_tot_loan_balance_grnt: %', rec_loan.principle, v_tot_loan_balance_grnt;
    --SELECT coalesce(SUM(amount),0) FROM gurrantors WHERE loan_id = 342

    -- GET AMOUNT GUARANTOR HAS ALREADY GURtd OTHER PEOPLE
    SELECT COALESCE(SUM(amount), 0) INTO v_amount_already_grntd FROM vw_gurrantors WHERE gurrantor_entity_id = NEW.entity_id AND is_accepted = true AND loan_balance > 0;

    
    IF(NEW.amount > (rec_loan.principle - v_tot_loan_balance_grnt)) THEN
        RAISE EXCEPTION '% is greater than the amount remaining to be gurranteed %', NEW.amount,  (rec_loan.principle - v_tot_loan_balance_grnt);
    ELSE
        IF(v_active_loans_grnt = 0) THEN --GRNT HAS NO LOAN
            IF((v_grnt_shares - v_amount_already_grntd)  >= NEW.amount) THEN
                can_gurrantee := true;
            ELSE
                can_gurrantee := false;
                RAISE EXCEPTION 'This person does not qualify to gurrantee you';
            END IF;
        ELSE-- HAS LOAN
		IF (v_active_loans_grnt > 0) THEN
			IF (v_grnt_shares > v_tot_loan_balance_grnt) THEN
			can_gurrantee := true;
			ELSE 
			can_gurrantee := false;
			--RAISE EXCEPTION ' This persons balance is %,COALESCE (v_grnt_shares,0) - COALESCE(v_tot_loan_balance_grnt,0)';
			END IF;

		end if;
           -- RAISE EXCEPTION 'This person has a loan %', v_active_loans_grnt;
        END IF;
    END IF;
    
   IF(can_gurrantee = false) THEN
        RAISE EXCEPTION 'Cannot Gurantee  Loan' ;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;
  
CREATE TRIGGER ins_gurrantors BEFORE INSERT OR UPDATE ON gurrantors
  FOR EACH ROW  EXECUTE PROCEDURE ins_gurrantors(); 
  
  
    
  
 

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












alter table contributions add additional_payments real not null default 0;
alter table loan_monthly add additional_payments real not null default 0;


CREATE OR REPLACE FUNCTION get_total_repayment(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment + interest_paid + penalty_paid - additional_payments) is null THEN 0 
		ELSE sum(repayment + interest_paid + penalty_paid - additional_payments) END
	FROM loan_monthly
	WHERE (loan_id = $1);
$$ LANGUAGE SQL;



CREATE OR REPLACE FUNCTION compute_contributions(v_period_id varchar(12), v_org_id varchar(12), v_approval varchar(12)) RETURNS varchar(120) AS $$
DECLARE
    msg                 varchar(120);
BEGIN
	msg := 'Contributions generated';
    DELETE FROM loan_monthly WHERE period_id = v_period_id::integer AND org_id =  v_org_id::integer ;
    DELETE FROM contributions WHERE period_id = v_period_id::integer;
    
    INSERT INTO contributions(period_id, org_id, entity_id,  payment_type_id, contribution_type_id, 
            entity_name, deposit_amount,  entry_date,
             transaction_ref, additional_payments,is_paid)
             
    SELECT v_period_id::integer, org_id::integer ,entity_id, 0,0, first_name, contribution,
            now()::date, 'Auto generated', 0, 'False'
        FROM members;

    RETURN msg;
END;
$$ LANGUAGE plpgsql; 


CREATE OR REPLACE FUNCTION loan_approved(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Approved';
	
	UPDATE loans SET approve_status = 'Approved'
	WHERE (loan_id = CAST($1 as int));

	return msg;
END;
$BODY$
  LANGUAGE plpgsql;

  CREATE OR REPLACE FUNCTION loan_rejected(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Rejected';
	
	UPDATE loans SET approve_status = 'Rejected'
	WHERE (loan_id = CAST($1 as int));

	return msg;
END;
$BODY$
  LANGUAGE plpgsql;



  CREATE OR REPLACE FUNCTION loan_paid(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Paid';
	
	UPDATE loan_monthly  SET is_paid = 'True'
	WHERE (loan_month_id = CAST($1 as int));

	return msg;
END;
$BODY$
  LANGUAGE plpgsql;

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


  
  CREATE OR REPLACE FUNCTION contribution_paid (varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);

BEGIN
	msg := 'Contribution paid';
	
	UPDATE contributions  SET is_paid = 'True'
	WHERE (contribution_id = CAST($1 as int));


	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_kins() RETURNS trigger AS $$
DECLARE
	beneficiary_ps_total   	real;
	v_entity_id    integer;
	
BEGIN

	IF (NEW.beneficiary_ps > 100 and New.beneficiary = 'True')THEN
		raise exception 'Percentage total has to be 100';
end if;
	
	select  beneficiary_ps, entity_id from kins into beneficiary_ps_total, v_entity_id where kin_id = NEW.kin_id and  New.beneficiary = 'True';
	
	
	if (beneficiary_ps_total > 100 ) then
	
	New. beneficiary_ps := 0;
	end if;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;
