CREATE OR REPLACE FUNCTION ins_contrib()
  RETURNS trigger AS
$BODY$
DECLARE
	v_investment_amount			real;
	v_period_id					integer;
	v_org_id					integer;
	v_contribution_type_id		integer;
	v_merry_go_round_amount		real;
	 v_mgr_number				integer;
	 v_merry_go_round_number	integer;
	v_money_out					real;
	v_entity_id			integer;

BEGIN
	
	SELECT   org_id, contribution_type_id, SUM(merry_go_round_amount)
	INTO  v_org_id, v_contribution_type_id, v_money_out
	FROM contributions
		WHERE paid = true AND period_id = NEW.period_id 
		GROUP BY contribution_type_id,org_id;
	v_period_id := NEW.period_id;
	
RAISE EXCEPTION '%',v_contribution_type_id;
			IF (v_money_out = 0)THEN
			UPDATE contributions SET money_out  = 0 WHERE paid = true AND period_id =  v_period_id AND contribution_type_id = v_contribution_type_id;
	ELSIF 	(v_money_out != 0)THEN
	
		SELECT mgr_number INTO v_mgr_number FROM periods  WHERE period_id = NEW.period_id AND org_id = v_org_id;
		SELECT entity_id, merry_go_round_number INTO v_entity_id, v_merry_go_round_number 
		FROM vw_member_contrib 
		WHERE merry_go_round_number = v_mgr_number;
		
			UPDATE contributions SET money_out  = v_money_out WHERE paid = true AND period_id =  v_period_id AND contribution_type_id = v_contribution_type_id AND entity_id = v_entity_id;
	
	END IF;

RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;


  
CREATE TRIGGER ins_contrib
AFTER INSERT OR UPDATE of paid
ON contributions
FOR EACH ROW
EXECUTE PROCEDURE ins_contrib();

CREATE OR REPLACE FUNCTION ins_contributions()
  RETURNS trigger AS
$BODY$
DECLARE
reca 				record;
rec 				record;
reco 				record;
v_entity_id		integer;
recp record;
v_bal				real;
v_total_loan			real;
v_investment_amount		real;
BEGIN
SELECT SUM(investment_amount) INTO v_investment_amount FROM contributions WHERE paid = true AND entity_id = NEW.entity_id AND period_id = NEW.period_id;
v_entity_id := NEW.entity_id;
FOR reca IN SELECT loan_id, approve_status FROM vw_loans WHERE entity_id = v_entity_id LOOP
	IF(reca.approve_status = 'Approved' ) THEN

		FOR rec IN  SELECT (interest_amount+repayment+penalty_paid)AS amount FROM vw_loan_monthly
		 WHERE entity_id = v_entity_id AND period_id = NEW.period_id AND loan_id = reca.loan_id LOOP
			v_bal := v_investment_amount - rec.amount;
			IF (v_bal > 0) THEN
				FOR recp IN SELECT SUM(amount - penalty_paid) AS penalty_amount, penalty_type_id, bank_account_id,
				 currency_id, org_id, penalty_paid FROM penalty WHERE entity_id = v_entity_id GROUP BY penalty_type_id, bank_account_id,
				 currency_id, org_id, penalty_paid  LOOP
				 IF((v_bal <= recp.penalty_amount) )THEN
					INSERT INTO penalty ( penalty_type_id, bank_account_id, currency_id, org_id, penalty_paid)
					VALUES(recp.penalty_type_id, recp.bank_account_id, recp.currency_id, recp.org_id, v_bal);
					v_bal := 0;
				 END IF;
				 IF((v_bal - recp.penalty_amount) > 0 )THEN
					v_bal := v_bal - recp.penalty_amount;
				 
					INSERT INTO penalty ( penalty_type_id, bank_account_id, currency_id, org_id, penalty_paid)
					VALUES(recp.penalty_type_id, recp.bank_account_id, recp.currency_id, recp.org_id, recp.penalty_amount);
					
				 END IF;
					
				END LOOP;
				
			END IF;
		END LOOP;
	END IF;
END LOOP;
--NEW.money_in := v_bal;
UPDATE contributions SET money_in = v_bal WHERE contribution_id = New.contribution_id;
--raise exception '%',v_bal;
   RETURN NEW;
END;
$BODY$
 LANGUAGE plpgsql ;

 CREATE TRIGGER ins_contributions
  AFTER INSERT OR UPDATE OF paid
  ON contributions
  FOR EACH ROW
  EXECUTE PROCEDURE ins_contributions();

CREATE OR REPLACE FUNCTION generate_contribs(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	rec						RECORD;
	recu			RECORD;
	v_period_id		integer;
	vi_period_id		integer;
	reca			RECORD;
	v_org_id		integer;
	v_month_name	varchar(50);
	v_member_id		integer;

	msg 			varchar(120);
BEGIN
	SELECT period_id, org_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
	FROM periods
	WHERE (period_id = $1::integer);

	SELECT period_id INTO vi_period_id FROM contributions WHERE period_id in (v_period_id) AND org_id in (v_org_id);

	IF( vi_period_id is null) THEN

	FOR reca IN SELECT member_id, entity_id FROM members WHERE (org_id = v_org_id) LOOP
	
	FOR rec IN SELECT org_id, frequency, contribution_type_id, investment_amount, merry_go_round_amount, applies_to_all
	FROM contribution_types WHERE  (org_id = v_org_id) LOOP
	IF(rec.applies_to_all = true) THEN
		IF (rec.frequency = 'Weekly') THEN
		FOR i in 1..4 LOOP
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount, member_id, entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END LOOP;
		END IF;
		IF (rec.frequency = 'Fortnightly') THEN
		FOR i in 1..2 LOOP
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id, entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END LOOP;
		END IF;
		IF (rec.frequency = 'Monthly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Irregularly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Quarterly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Semi-annually') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Annually') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		END IF;
	IF(rec.applies_to_all = false)THEN
	SELECT contribution_type_id, entity_id INTO recu FROM contribution_defaults WHERE entity_id = reca.entity_id
	AND contribution_type_id = rec.contribution_type_id;
		IF (rec.frequency = 'Weekly') THEN
		FOR i in 1..4 LOOP
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount, member_id, entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, recu.entity_id);
		END LOOP;
		END IF;
		IF (rec.frequency = 'Fortnightly') THEN
		FOR i in 1..2 LOOP
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id, entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, recu.entity_id);
		END LOOP;
		END IF;
		IF (rec.frequency = 'Monthly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, recu.entity_id);
		END IF;
		IF (rec.frequency = 'Irregularly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Quarterly') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Semi-annually') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
		END IF;
		IF (rec.frequency = 'Annually') THEN
			INSERT INTO contributions (period_id, org_id, contribution_type_id, investment_amount, merry_go_round_amount,member_id,entity_id)
			VALUES(v_period_id, rec.org_id, rec.contribution_type_id, rec.investment_amount, rec.merry_go_round_amount,
			reca.member_id, reca.entity_id);
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

 CREATE OR REPLACE FUNCTION generate_paid(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg		 				varchar(120);
	v_paid				boolean;	
BEGIN
	SELECT paid INTO v_paid FROM contributions WHERE contribution_id = $1::int;
	--RAISE EXCEPTION '%', v_paid;
	IF(v_paid = false) THEN
	UPDATE contributions SET paid = true WHERE contribution_id = $1::int ;
	msg = 'Paid';
	ELSE
	msg = 'Already paid';
	
	END IF;

	return msg;
END;
$BODY$
  LANGUAGE plpgsql;

 CREATE OR REPLACE FUNCTION upd_email()
  RETURNS trigger AS
$BODY$
BEGIN
IF (TG_OP = 'INSERT') THEN
	INSERT INTO sys_emailed ( table_id, table_name, email_type)
	VALUES (10, TG_TABLE_NAME, 6);
END IF;

RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

 CREATE TRIGGER upd_email AFTER INSERT ON contributions
    FOR EACH ROW EXECUTE PROCEDURE upd_email();


  CREATE OR REPLACE FUNCTION ins_members()
  RETURNS trigger AS
$BODY$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN
	IF (TG_OP = 'INSERT') THEN
	
	IF (New.email is null)THEN
		RAISE EXCEPTION 'You have to enter an Email';
	ELSIF(NEW.first_name is null) AND (NEW.surname is null)THEN
		RAISE EXCEPTION 'You have need to enter Surname and First Name';
	
	ELSE
	Raise NOTICE 'Thank you';
	END IF;
	NEW.entity_id := nextval('entitys_entity_id_seq');

	INSERT INTO entitys (entity_id,entity_name,org_id,entity_type_id,user_name,primary_email,primary_telephone,function_role,details)
	VALUES (New.entity_id,New.surname,New.org_id::INTEGER,1,NEW.email,NEW.email,NEW.phone,'member',NEW.details) RETURNING entity_id INTO v_entity_id;

	NEW.entity_id := v_entity_id;

	update members set full_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')) where member_id = New.member_id;
END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
 
CREATE TRIGGER ins_members
  BEFORE INSERT
  ON members
  FOR EACH ROW
  EXECUTE PROCEDURE ins_members();

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

 
 CREATE OR REPLACE FUNCTION ins_investment()
  RETURNS trigger AS
$BODY$
DECLARE
	v_interests			real;
	
BEGIN
	SELECT interest_amount INTO v_interests FROM  investment_types WHERE investment_type_id = NEW. investment_type_id;
		
	IF (NEW.monthly_payments is null and NEW.principal is not null and  NEW.repayment_period is not null) THEN
		NEW.monthly_payments := NEW.principal/ NEW.repayment_period;
	ELSEIF (NEW.repayment_period is null and NEW.principal is not null and NEW.monthly_payments is not null ) THEN
		NEW.repayment_period := NEW.principal/NEW.monthly_payments;
	ELSEIF (NEW.repayment_period is null AND NEW.monthly_payments is null) THEN
		RAISE EXCEPTION 'Please enter the repayment period or the monthly payments';
	END IF;
	
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
	msg 		varchar(120);
BEGIN
	msg := 'Investment applied';
	
	UPDATE investments SET approve_status = 'Completed', investment_status = 'Committed'
	WHERE (investment_id = CAST($1 as int)) AND (approve_status = 'Draft') AND investment_status = 'Prospective';

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_total_expenditure (integer) RETURNS real AS $$
DECLARE
	v_transaction_amount real;

BEGIN
	SELECT SUM(transaction_amount) INTO v_transaction_amount FROM transactions WHERE tx_type = -1 and investment_id  = $1;
	RETURN v_transaction_amount;

END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_total_income (integer) RETURNS real AS $$
DECLARE
	v_transaction_amount real;

BEGIN
	SELECT SUM(transaction_amount) INTO v_transaction_amount FROM transactions WHERE tx_type = 1 and investment_id  = $1;
	RETURN v_transaction_amount;

END;
$$ LANGUAGE plpgsql;
  
CREATE OR REPLACE FUNCTION add_member_meeting(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg		 				varchar(120);
	v_member_id				integer;
	v_org_id				integer;
BEGIN

	SELECT member_id INTO v_member_id
	FROM member_meeting WHERE (member_id = $1::int) AND (meeting_id = $3::int);
	
	IF(v_member_id is null)THEN
		SELECT org_id INTO v_org_id
		FROM meetings WHERE (meeting_id = $3::int);
		
		INSERT INTO  member_meeting (meeting_id, member_id, org_id)
		VALUES ($3::int, $1::int, v_org_id);

		msg := 'Added to meeting';
	ELSE
		msg := 'Already Added to meeting';
	END IF;
	
	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION remove_member_meeting(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg		 				varchar(120);
	v_member_id				integer;
	v_org_id				integer;
BEGIN

	SELECT member_id INTO v_member_id
	FROM member_meeting WHERE (member_id = $1::int) AND (meeting_id = $3::int);
	
	IF(v_member_id is not null)THEN
		SELECT org_id INTO v_org_id
		FROM meetings WHERE (meeting_id = $3::int);
		
		DELETE FROM  member_meeting WHERE member_id = v_member_id AND (meeting_id = $3::int);
		

		msg := 'Removed from meeting';
		END IF;
	
	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_email AFTER INSERT ON investments
    FOR EACH ROW EXECUTE PROCEDURE upd_email();

 CREATE TRIGGER upd_email AFTER INSERT ON borrowing
    FOR EACH ROW EXECUTE PROCEDURE upd_email();
    
 CREATE TRIGGER upd_email AFTER INSERT ON meetings
    FOR EACH ROW EXECUTE PROCEDURE upd_email();
    
 CREATE TRIGGER upd_email AFTER INSERT ON drawings
    FOR EACH ROW EXECUTE PROCEDURE upd_email();


CREATE TRIGGER upd_email AFTER INSERT ON penalty
    FOR EACH ROW EXECUTE PROCEDURE upd_email();


CREATE OR REPLACE FUNCTION email_before(
    integer,
    integer,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg		 				varchar(120);
BEGIN
	INSERT INTO sys_emailed ( table_id, org_id, table_name, email_type)
	VALUES ($1, $2, 'meetings', 7);
msg := 'Email Sent';
return msg;
END;
$BODY$
  LANGUAGE plpgsql;
  
CREATE OR REPLACE FUNCTION email_after(
    integer,
    integer,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	msg		 				varchar(120);
BEGIN
	INSERT INTO sys_emailed ( table_id, org_id, table_name, email_type)
	VALUES ($1, $2, 'meetings', 8);
msg := 'Email Sent';
return msg;
END;
$BODY$
  LANGUAGE plpgsql;
  
<<<<<<< HEAD:projects/chama/database/09.functions.sql
=======
  
>>>>>>> 1ec33c13976de73dbe7769559295288e445f9ae8:projects/chama/database/07.functions.sql
  CREATE OR REPLACE FUNCTION generate_repayment(
    character varying,
    character varying,
    character varying)
  RETURNS character varying AS
$BODY$
DECLARE
<<<<<<< HEAD:projects/chama/database/09.functions.sql
    rec            RECORD;
    recu            RECORD;
    reca            RECORD;
    v_penalty        real;
    v_org_id        integer;
    v_period_id        integer;
    v_month_name        varchar(20);
    vi_period_id        integer;
    v_loan_type_id        integer;
    v_loan_intrest        real;
    v_loan_id        integer;
    msg            varchar(120);
BEGIN
SELECT   period_id, org_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
    FROM periods
    WHERE (period_id = $1::integer);
SELECT loan_month_id, loan_id, period_id, org_id, interest_amount, repayment, interest_paid, penalty_paid INTO recu
FROM loan_monthly WHERE period_id in (v_period_id) AND org_id in (v_org_id);

    IF( recu.period_id is null) THEN
    
        FOR rec IN SELECT org_id, loan_id, loan_type_id, monthly_repayment FROM loans WHERE (org_id = v_org_id) LOOP
        raise exception '%',rec.loan_id;    
        SELECT loan_intrest, loan_id INTO v_loan_intrest, v_loan_id FROM vw_loan_payments WHERE v_loan_id = rec.loan_id;
        recu.repayment = rec.monthly_repayment - v_loan_intrest;
            
    
        INSERT INTO loan_monthly (loan_id, period_id, org_id, interest_amount, repayment, interest_paid)
        VALUES(rec.loan_id, v_period_id, rec.org_id, v_loan_intrest, recu.repayment,  v_loan_intrest);
    END LOOP;
    

msg := 'Repayment Generated';
    END IF;

    return msg;
=======
	rec			RECORD;
	recu			RECORD;
	reca			RECORD;
	v_penalty		real;
	v_org_id		integer;
	v_period_id		integer;
	v_month_name		varchar(20);
	vi_period_id		integer;
	v_loan_type_id		integer;
	v_loan_intrest		real;
	v_loan_id		integer;
	msg			varchar(120);
BEGIN
SELECT  org_id, period_id, to_char(start_date, 'Month YYYY') INTO v_period_id, v_org_id, v_month_name
	FROM periods
	WHERE (period_id = $1::integer);

SELECT loan_month_id, loan_id, period_id, org_id, interest_amount, repayment, interest_paid, penalty_paid INTO recu 
FROM loan_monthly WHERE period_id in (v_period_id) AND org_id in (v_org_id);

	IF( recu.period_id is null) THEN
	FOR reca IN SELECT member_id, entity_id FROM members WHERE (org_id = v_org_id) LOOP
	
	FOR rec IN SELECT org_id, loan_id, loan_type_id, monthly_repayment FROM loans WHERE  (org_id = v_org_id) LOOP
	SELECT penalty, loan_type_id INTO v_penalty, v_loan_type_id FROM loan_types WHERE  org_id = v_org_id AND V_loan_type_id = rec.loan_type_id;
	SELECT loan_intrest, loan_id INTO v_loan_intrest, v_loan_id FROM vw_loan_payments WHERE v_loan_id = rec.loan_id;
	recu.repayment = rec.monthly_repayment - interest_amount;
	
		INSERT INTO loan_monthly (loan_id, period_id, org_id, interest_amount, repayment, interest_paid, penalty_paid)
		VALUES(rec.loan_id, v_period_id, rec.org_id, v_loan_intrest, NEW.repayment,  v_loan_intrest, v_penalty);
	END LOOP;
	

msg = 'Repayment Generated';
	END IF;

	return msg;
>>>>>>> 1ec33c13976de73dbe7769559295288e445f9ae8:projects/chama/database/07.functions.sql
END;
$BODY$
  LANGUAGE plpgsql;
