
drop function change_password ( character varying, character varying,character varying);



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

alter table loan_monthly add additional_payments real not null default 0;



CREATE OR REPLACE FUNCTION get_total_repayment(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment + interest_paid + penalty_paid - additional_payments) is null THEN 0 
		ELSE sum(repayment + interest_paid + penalty_paid - additional_payments) END
	FROM loan_monthly
	WHERE (loan_id = $1);
$$ LANGUAGE SQL;


--- here done
CREATE OR REPLACE FUNCTION compute_contributions(
    v_period_id character varying,
    v_org_id character varying,
    v_approval character varying)
  RETURNS character varying AS
$BODY$
DECLARE
    msg                 varchar(120);
BEGIN
	msg := 'Contributions generated';
    DELETE FROM loan_monthly WHERE period_id = v_period_id::integer AND org_id =  v_org_id::integer AND is_paid = false ;
    DELETE FROM contributions WHERE period_id = v_period_id::integer;
    
    INSERT INTO contributions(period_id, org_id, entity_id,  payment_type_id, contribution_type_id, 
             contribution_amount,  entry_date,
             transaction_ref, is_paid)
             
    SELECT v_period_id::integer, org_id::integer ,entity_id, 1,1,  contribution,
            now()::date, 'Auto generated','False'
        FROM members;

    RETURN msg;
END;
$BODY$
  LANGUAGE plpgsql;


  
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



--views

CREATE OR REPLACE VIEW vw_gurrantors AS 
 SELECT vw_loans.principle,
 vw_loans.currency_symbol,
    vw_loans.entity_id,
    vw_loans.interest,
    vw_loans.monthly_repayment,
    vw_loans.loan_date,
    vw_loans.initial_payment,
    vw_loans.loan_id,
    vw_loans.repayment_amount,
    vw_loans.total_interest,
    vw_loans.loan_balance,
    vw_loans.calc_repayment_period,
    vw_loans.reducing_balance,
    vw_loans.repayment_period,
    vw_loans.application_date,
    vw_loans.approve_status,
    vw_loans.org_id,
    vw_loans.action_date,
    vw_loans.details,
    vw_loans.total_repayment,
    entitys.entity_name,
    loan_types.loan_type_id,
    loan_types.loan_type_name,
    gurrantors.gurrantor_id,
    gurrantors.is_accepted,
    gurrantors.amount,
    gurrantors_entity.entity_name AS gurrantor_entity_name,
    gurrantors_entity.entity_id AS gurrantor_entity_id
   FROM gurrantors
     JOIN vw_loans ON vw_loans.loan_id = gurrantors.loan_id
     JOIN entitys ON vw_loans.entity_id = entitys.entity_id
     JOIN loan_types ON vw_loans.loan_type_id = loan_types.loan_type_id
     JOIN entitys gurrantors_entity ON gurrantors_entity.entity_id = gurrantors.entity_id;




DROP VIEW vw_entitys;

CREATE OR REPLACE VIEW vw_entitys AS 
SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default, vw_orgs.is_active as org_is_active, 
		vw_orgs.logo as org_logo, vw_orgs.cert_number as org_cert_number, vw_orgs.pin as org_pin, 
		vw_orgs.vat_number as org_vat_number, vw_orgs.invoice_footer as org_invoice_footer,
		--vw_orgs.sys_country_id as org_sys_country_id, vw_orgs.sys_country_name as org_sys_country_name, 
		--vw_orgs.address_id as org_address_id, vw_orgs.table_name as org_table_name,
		--vw_orgs.post_office_box as org_post_office_box, vw_orgs.postal_code as org_postal_code, 
		--vw_orgs.premises as org_premises, vw_orgs.street as org_street, vw_orgs.town as org_town, 
		--vw_orgs.phone_number as org_phone_number, vw_orgs.extension as org_extension, 
		--vw_orgs.mobile as org_mobile, vw_orgs.fax as org_fax, vw_orgs.email as org_email, vw_orgs.website as org_website,
		
		addr.address_id, addr.address_name,
		addr.sys_country_id, addr.sys_country_name, addr.table_name, addr.is_default,
		addr.post_office_box, addr.postal_code, addr.premises, addr.street, addr.town, 
		addr.phone_number, addr.extension, addr.mobile, addr.fax, addr.email, addr.website,
		
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, 
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention, entitys.primary_email,
		
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role
	FROM (entitys LEFT JOIN vw_address_entitys as addr ON entitys.entity_id = addr.table_id)
		JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id ;
--here
DROP VIEW vw_orgs  CASCADE;
CREATE VIEW vw_orgs AS
	SELECT orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo, orgs.details,

		vw_org_address.org_sys_country_id, vw_org_address.org_sys_country_name,
		vw_org_address.org_address_id, vw_org_address.org_table_name,
		vw_org_address.org_post_office_box, vw_org_address.org_postal_code,
		vw_org_address.org_premises, vw_org_address.org_street, vw_org_address.org_town,
		vw_org_address.org_phone_number, vw_org_address.org_extension,
		vw_org_address.org_mobile, vw_org_address.org_fax, vw_org_address.org_email, vw_org_address.org_website
	FROM orgs LEFT JOIN vw_org_address ON orgs.org_id = vw_org_address.org_table_id;

DROP VIEW vw_entity_address cascade;
CREATE VIEW vw_entity_address AS
	SELECT vw_address.address_id, vw_address.address_name,
		vw_address.sys_country_id, vw_address.sys_country_name, vw_address.table_id, vw_address.table_name,
		vw_address.is_default, vw_address.post_office_box, vw_address.postal_code, vw_address.premises,
		vw_address.street, vw_address.town, vw_address.phone_number, vw_address.extension, vw_address.mobile,
		vw_address.fax, vw_address.email, vw_address.website
	FROM vw_address
	WHERE (vw_address.table_name = 'entitys') AND (vw_address.is_default = true);

CREATE VIEW vw_entitys AS
	SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default,
		vw_orgs.is_active as org_is_active, vw_orgs.logo as org_logo,

		vw_orgs.org_sys_country_id, vw_orgs.org_sys_country_name,
		vw_orgs.org_address_id, vw_orgs.org_table_name,
		vw_orgs.org_post_office_box, vw_orgs.org_postal_code,
		vw_orgs.org_premises, vw_orgs.org_street, vw_orgs.org_town,
		vw_orgs.org_phone_number, vw_orgs.org_extension,
		vw_orgs.org_mobile, vw_orgs.org_fax, vw_orgs.org_email, vw_orgs.org_website,

		vw_entity_address.address_id, vw_entity_address.address_name,
		vw_entity_address.sys_country_id, vw_entity_address.sys_country_name, vw_entity_address.table_name,
		vw_entity_address.is_default, vw_entity_address.post_office_box, vw_entity_address.postal_code,
		vw_entity_address.premises, vw_entity_address.street, vw_entity_address.town,
		vw_entity_address.phone_number, vw_entity_address.extension, vw_entity_address.mobile,
		vw_entity_address.fax, vw_entity_address.email, vw_entity_address.website,

		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader,
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password,
		entitys.function_role, entitys.primary_email, entitys.primary_telephone,
		entity_types.entity_type_id, entity_types.entity_type_name,
		entity_types.entity_role
	FROM (entitys LEFT JOIN vw_entity_address ON entitys.entity_id = vw_entity_address.table_id)
		INNER JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id;
	
CREATE OR REPLACE VIEW vw_entitys_types AS 
	SELECT	entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, 
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention, entitys.primary_email, entitys.org_id,entitys.primary_telephone,
		  entitys.new_password,entitys.exit_amount,
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role
	FROM entitys
		JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id ;
		
		
ALTER TABLE bank_accounts add currency_id integer REFERENCES currency;
ALTER TABLE bank_accounts add account_id integer references accounts;

CREATE OR REPLACE VIEW vw_bank_accounts AS 
	SELECT vw_bank_branch.bank_id, vw_bank_branch.bank_name,vw_bank_branch.bank_branch_id,
		vw_bank_branch.bank_branch_name,vw_accounts.account_type_id, vw_accounts.account_type_name,vw_accounts.account_id,vw_accounts.account_name,
		currency.currency_id,currency.currency_name,currency.currency_symbol,
		bank_accounts.bank_account_id,bank_accounts.org_id, bank_accounts.bank_account_name,bank_accounts.bank_account_number,
		bank_accounts.narrative,bank_accounts.is_active,bank_accounts.details
   FROM bank_accounts
		FULL JOIN vw_bank_branch ON bank_accounts.bank_branch_id = vw_bank_branch.bank_branch_id
		FULL JOIN vw_accounts ON bank_accounts.bank_account_id = vw_accounts.account_id
		FULL JOIN currency ON bank_accounts.currency_id = currency.currency_id;


CREATE OR REPLACE VIEW vw_recruiting_entity AS
		SELECT members.entity_id,members.surname,recruiting_agent_entity.entity_name AS recruiting_agent_entity_name,
			recruiting_agent.entity_id AS recruiting_agent_entity_id, recruiting_agent.recruiting_agent_id, 
			recruiting_agent.org_id
	FROM  members
	JOIN recruiting_agent on members.recruiting_agent_id = recruiting_agent.recruiting_agent_id
	left JOIN entitys recruiting_agent_entity ON recruiting_agent_entity.entity_id = recruiting_agent.entity_id;
		


 CREATE OR REPLACE VIEW vw_investments AS 
 SELECT entitys.entity_id,
    entitys.entity_name,
    entitys.org_id,
    investments.investment_id,
    investments.investment_type_id,
    investments.maturity_date,
    investments.invest_amount,
    investments.yearly_dividend,
    investments.withdrawal_date,
    investments.withdrwal_amount,
    investments.period_years,
    investments.default_interest,
    investments.return_on_investment,
    investments.application_date,
    investments.approve_status,
    investments.workflow_table_id,
    investments.action_date,
    investments.details,
    investment_types.investment_type_name
   FROM investments
     JOIN entitys ON entitys.entity_id = investments.entity_id
     JOIN investment_types ON investments.investment_type_id = investment_types.investment_type_id;  

     
 
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
         
             INSERT INTO members(entity_id,org_id,full_name, surname, first_name, middle_name,phone, 
            gender,marital_status,primary_email,objective, details)  
         
    VALUES (New.entity_id,New.org_id,(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')), New.Surname,NEW.First_name,NEW.Middle_name,
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

	INSERT INTO entitys (entity_id, entity_name,org_id,entity_type_id,user_name,primary_email,primary_telephone,function_role,details,exit_amount,use_key_id)
	VALUES (New.entity_id, (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),New.org_id::INTEGER,0,NEW.primary_email,NEW.primary_email,NEW.phone,'member',NEW.details,new.contribution, 0) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;
	
	
	
	END IF;
		IF (TG_OP = 'UPDATE') THEN
			IF (NEW.full_name is null) then
			NEW.full_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''));
			END IF;
			
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
    
    SELECT COALESCE(SUM(contribution_paid + additional_payments), 0) INTO v_shares FROM contributions where entity_id = rec_loan.entity_id; -- LOANEE SHARES
    SELECT COALESCE(SUM(contribution_paid + additional_payments), 0) INTO v_grnt_shares FROM contributions where entity_id = NEW.entity_id; -- GRNT SHARES

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


 
 











