
<<<<<<< HEAD
=======

CREATE OR REPLACE FUNCTION change_password(varchar(12), varchar(32), varchar(32), varchar(32)) RETURNS varchar(120) AS $$
DECLARE
	passchange 		varchar(120);
	entityID		integer;
BEGIN
	passchange := 'Password Error';
	entityID := CAST($1 AS INT);

	IF ($3 = '0') THEN
		passchange := first_password();
		UPDATE entitys SET first_password = passchange, Entity_password = md5(passchange) WHERE (entity_id = entityID);
		passchange := 'Password Changed';
	ELSE
		passchange := 'an error occured' ;
	END IF;

	return passchange;
END;
$$ LANGUAGE plpgsql;


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



>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
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
<<<<<<< HEAD
			END IF;
		END IF;
=======
				END IF;
			END IF;
	IF (TG_OP = 'UPDATE') THEN
	  UPDATE loans
    SET approve_status = 'Completed';
	RAISE NOTICE ' Loan Completed';
	 END IF;
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_gurrantors AFTER INSERT OR UPDATE ON gurrantors
	FOR EACH ROW EXECUTE PROCEDURE ins_gurrantors();
  
<<<<<<< HEAD
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
=======

DROP FUNCTION IF EXISTS ins_contributions();
CREATE OR REPLACE FUNCTION ins_contributions() RETURNS trigger AS $$
DECLARE
v_contrib_amount	real;
v_loan vw_loans%rowtype;
BEGIN
v_contrib_amount := 0;
FOR v_loan IN
SELECT *
FROM vw_loans WHERE approve_status = 'Completed' AND is_closed = false AND entity_id = 0
LOOP
       -- for all loans insert loan repayment
RAISE NOTICE 'Loan Id : %' , v_loan.loan_id;
-- here you can check for balance to chose whether or not to close loan
INSERT INTO loan_monthly(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
	
	v_contrib_amount := v_contrib_amount - v_loan.monthly_repayment;

INSERT INTO loan_repayment(loan_id, period_id, org_id, repayment_amount)
	VALUES (v_loan.loan_id, NEW.period_id, NEW.org_id, v_loan.monthly_repayment);
	
END LOOP;
NEW.contribution_amount = v_contrib_amount;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER ins_contributions BEFORE INSERT OR UPDATE On contributions
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
   FOR EACH ROW EXECUTE PROCEDURE ins_contributions();

  
CREATE OR REPLACE FUNCTION ins_investment() RETURNS TRIGGER AS
$BODY$
DECLARE
	v_interests			real;
	v_invest			real;
	v_totals			real;
BEGIN
	SELECT interest_type INTO v_interests FROM  investment_types WHERE investment_type_id = NEW. investment_type_id;
<<<<<<< HEAD
=======
		
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
		NEW.default_interest := v_interests;
		v_invest := NEW.invest_amount + (NEW.invest_amount * NEW.default_interest/100 );
		NEW.return_on_investment := v_invest - NEW.invest_amount;
		NEW.yearly_dividend :=(v_invest/ NEW.period_years);
		NEW.withdrwal_amount := v_invest;
<<<<<<< HEAD
	RETURN NEW;
END;
=======
		NEW.approve_status := 'Completed';
	RETURN NEW;
END;

>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
$BODY$
LANGUAGE plpgsql;
   
CREATE TRIGGER ins_investment BEFORE INSERT OR UPDATE ON investments
	FOR EACH ROW EXECUTE PROCEDURE ins_investment();

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON investments
    FOR EACH ROW EXECUTE PROCEDURE upd_action();

CREATE OR REPLACE FUNCTION ins_applicants()
<<<<<<< HEAD
  RETURNS trigger AS
=======
RETURNS trigger AS
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
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
<<<<<<< HEAD
				SELECT org_id INTO rec
				FROM orgs WHERE (is_default = true);
=======
				
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8

				NEW.entity_id := nextval('entitys_entity_id_seq');

				INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, 
					primary_email, primary_telephone, function_role)
<<<<<<< HEAD
				VALUES (NEW.entity_id, rec.org_id, 4, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant');
			ELSE
=======
				VALUES (NEW.entity_id, New.org_id, 0, 
					(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
					lower(NEW.applicant_email), lower(NEW.applicant_email), NEW.applicant_phone, 'applicant,member');
					ELSE
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
				RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
			END IF;
		END IF;

<<<<<<< HEAD
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name)
		VALUES (1, NEW.entity_id, 'applicant');
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;
=======
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

  
  
  
  
 


  
CREATE TRIGGER upd_applicants AFTER INSERT OR UPDATE ON applicants
    FOR EACH ROW EXECUTE PROCEDURE upd_applicants();
  
  
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

	IF (TG_OP = 'INSERT') THENss
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
		
		
		
>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
	END IF;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;
<<<<<<< HEAD
  
CREATE TRIGGER ins_applicants
  BEFORE INSERT OR UPDATE
  ON applicants
  FOR EACH ROW
  EXECUTE PROCEDURE ins_applicants();
=======

CREATE TRIGGER ins_subscriptions BEFORE INSERT OR UPDATE ON subscriptions
  FOR EACH ROW EXECUTE PROCEDURE ins_subscriptions();
  
  
  
  
  
  
  
  
CREATE OR REPLACE FUNCTION upd_transaction_details() RETURNS trigger AS $$
DECLARE
	statusID 	INTEGER;
	journalID 	INTEGER;
	v_for_sale	BOOLEAN;
	accountid 	INTEGER;
	taxrate 	REAL;
BEGIN
	SELECT transactions.transaction_status_id, transactions.journal_id, transaction_types.for_sales
		INTO statusID, journalID, v_for_sale
	FROM transaction_types INNER JOIN transactions ON transaction_types.transaction_type_id = transactions.transaction_type_id
	WHERE (transaction_id = NEW.transaction_id);

	IF ((statusID > 1) OR (journalID is not null)) THEN
		RAISE EXCEPTION 'Transaction is already posted no changes are allowed.';
	END IF;

	IF(v_for_sale = true)THEN
		SELECT items.sales_account_id, tax_types.tax_rate INTO accountid, taxrate
		FROM tax_types INNER JOIN items ON tax_types.tax_type_id = items.tax_type_id
		WHERE (items.item_id = NEW.item_id);
	ELSE
		SELECT items.purchase_account_id, tax_types.tax_rate INTO accountid, taxrate
		FROM tax_types INNER JOIN items ON tax_types.tax_type_id = items.tax_type_id
		WHERE (items.item_id = NEW.item_id);
	END IF;

	NEW.tax_amount := NEW.amount * taxrate / 100;
	IF(accountid is not null)THEN
		NEW.account_id := accountid;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_transaction_details BEFORE INSERT OR UPDATE ON transaction_details
    FOR EACH ROW EXECUTE PROCEDURE upd_transaction_details();

CREATE OR REPLACE FUNCTION af_upd_transaction_details() RETURNS trigger AS $$
DECLARE
	tamount REAL;
BEGIN

	IF(TG_OP = 'DELETE')THEN
		SELECT SUM(quantity * (amount + tax_amount)) INTO tamount
		FROM transaction_details WHERE (transaction_id = OLD.transaction_id);
		UPDATE transactions SET transaction_amount = tamount WHERE (transaction_id = OLD.transaction_id);	
	ELSE
		SELECT SUM(quantity * (amount + tax_amount)) INTO tamount
		FROM transaction_details WHERE (transaction_id = NEW.transaction_id);
		UPDATE transactions SET transaction_amount = tamount WHERE (transaction_id = NEW.transaction_id);	
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER af_upd_transaction_details AFTER INSERT OR UPDATE OR DELETE ON transaction_details
    FOR EACH ROW EXECUTE PROCEDURE af_upd_transaction_details();

CREATE OR REPLACE FUNCTION upd_transactions() RETURNS trigger AS $$
DECLARE
	transid 	INTEGER;
	currid		INTEGER;
BEGIN

	IF(TG_OP = 'INSERT') THEN
		SELECT document_number INTO transid
		FROM transaction_types WHERE (transaction_type_id = NEW.transaction_type_id);
		UPDATE transaction_types SET document_number = transid + 1 WHERE (transaction_type_id = NEW.transaction_type_id);

		NEW.document_number := transid;
		IF(NEW.currency_id is null)THEN
			SELECT currency_id INTO NEW.currency_id
			FROM orgs
			WHERE (org_id = NEW.org_id);
		END IF;
	ELSE
		IF (OLD.journal_id is null) AND (NEW.journal_id is not null) THEN
		ELSIF ((OLD.approve_status = 'Completed') AND (NEW.approve_status != 'Completed')) THEN
		ELSIF ((OLD.journal_id is not null) AND (OLD.transaction_status_id = NEW.transaction_status_id)) THEN
			RAISE EXCEPTION 'Transaction % is already posted no changes are allowed.', NEW.transaction_id;
		ELSIF ((OLD.transaction_status_id > 1) AND (OLD.transaction_status_id = NEW.transaction_status_id)) THEN
			RAISE EXCEPTION 'Transaction % is already completed no changes are allowed.', NEW.transaction_id;
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_transactions BEFORE INSERT OR UPDATE ON transactions
    FOR EACH ROW EXECUTE PROCEDURE upd_transactions();

CREATE OR REPLACE FUNCTION get_period(date) RETURNS INTEGER AS $$
	SELECT period_id FROM periods WHERE (start_date <= $1) AND (end_date >= $1); 
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_open_period(date) RETURNS INTEGER AS $$
	SELECT period_id FROM periods WHERE (start_date <= $1) AND (end_date >= $1)
		AND (opened = true) AND (closed = false); 
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION complete_transaction(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec RECORD;
	bankacc INTEGER;
	msg varchar(120);
BEGIN
	SELECT transaction_id, transaction_type_id, transaction_status_id INTO rec
	FROM transactions
	WHERE (transaction_id = CAST($1 as integer));

	IF($3 = '2') THEN
		UPDATE transactions SET transaction_status_id = 4 
		WHERE transaction_id = rec.transaction_id;
		msg := 'Transaction Archived';
	ELSIF(rec.transaction_status_id = 1) THEN
		IF($3 = '1') THEN
			UPDATE transactions SET transaction_status_id = 2, approve_status = 'Completed'
			WHERE transaction_id = rec.transaction_id;
		END IF;
		msg := 'Transaction completed.';
	ELSE
		msg := 'Transaction alerady completed.';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION copy_transaction(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg varchar(120);
BEGIN

	INSERT INTO transactions (org_id, department_id, entity_id, currency_id, transaction_type_id, transaction_date, order_number, payment_terms, job, narrative, details)
	SELECT org_id, department_id, entity_id, currency_id, transaction_type_id, CURRENT_DATE, order_number, payment_terms, job, narrative, details
	FROM transactions
	WHERE (transaction_id = CAST($1 as integer));

	INSERT INTO transaction_details (org_id, transaction_id, account_id, item_id, quantity, amount, tax_amount, narrative, details)
	SELECT org_id, currval('transactions_transaction_id_seq'), account_id, item_id, quantity, amount, tax_amount, narrative, details
	FROM transaction_details
	WHERE (transaction_id = CAST($1 as integer));

	msg := 'Transaction Copied';

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_transaction(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec RECORD;
	bankacc INTEGER;
	msg varchar(120);
BEGIN
	SELECT org_id, transaction_id, transaction_type_id, transaction_status_id, transaction_amount INTO rec
	FROM transactions
	WHERE (transaction_id = CAST($1 as integer));

	IF(rec.transaction_status_id = 1) THEN
		msg := 'Transaction needs to be completed first.';
	ELSIF(rec.transaction_status_id = 2) THEN
		IF (($3 = '7') AND ($3 = '8')) THEN
			SELECT max(bank_account_id) INTO bankacc
			FROM bank_accounts WHERE (is_default = true);

			INSERT INTO transactions (org_id, department_id, entity_id, currency_id, transaction_type_id, transaction_date, bank_account_id, transaction_amount)
			SELECT transactions.org_id, transactions.department_id, transactions.entity_id, transactions.currency_id, 1, CURRENT_DATE, bankacc, 
				SUM(transaction_details.quantity * (transaction_details.amount + transaction_details.tax_amount))
			FROM transactions INNER JOIN transaction_details ON transactions.transaction_id = transaction_details.transaction_id
			WHERE (transactions.transaction_id = rec.transaction_id)
			GROUP BY transactions.transaction_id, transactions.entity_id;

			INSERT INTO transaction_links (org_id, transaction_id, transaction_to, amount)
			VALUES (rec.org_id, currval('transactions_transaction_id_seq'), rec.transaction_id, rec.transaction_amount);
		
			UPDATE transactions SET transaction_status_id = 3 WHERE transaction_id = rec.transaction_id;
		ELSE
			INSERT INTO transactions (org_id, department_id, entity_id, currency_id, transaction_type_id, transaction_date, order_number, payment_terms, job, narrative, details)
			SELECT org_id, department_id, entity_id, currency_id, CAST($3 as integer), CURRENT_DATE, order_number, payment_terms, job, narrative, details
			FROM transactions
			WHERE (transaction_id = rec.transaction_id);

			INSERT INTO transaction_details (org_id, transaction_id, account_id, item_id, quantity, amount, tax_amount, narrative, details)
			SELECT org_id, currval('transactions_transaction_id_seq'), account_id, item_id, quantity, amount, tax_amount, narrative, details
			FROM transaction_details
			WHERE (transaction_id = rec.transaction_id);

			INSERT INTO transaction_links (org_id, transaction_id, transaction_to, amount)
			VALUES (REC.org_id, currval('transactions_transaction_id_seq'), rec.transaction_id, rec.transaction_amount);

			UPDATE transactions SET transaction_status_id = 3 WHERE transaction_id = rec.transaction_id;
		END IF;
		msg := 'Transaction proccesed';
	ELSE
		msg := 'Transaction previously Processed.';
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION post_transaction(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	rec RECORD;
	periodid INTEGER;
	journalid INTEGER;
	msg varchar(120);
BEGIN
	SELECT org_id, department_id, transaction_id, transaction_type_id, transaction_type_name as tx_name, 
		transaction_status_id, journal_id, gl_bank_account_id, currency_id, exchange_rate,
		transaction_date, transaction_amount, document_number, credit_amount, debit_amount,
		entity_account_id, entity_name, approve_status INTO rec
	FROM vw_transactions
	WHERE (transaction_id = CAST($1 as integer));

	periodid := get_open_period(rec.transaction_date);
	IF(periodid is null) THEN
		msg := 'No active period to post.';
	ELSIF(rec.journal_id is not null) THEN
		msg := 'Transaction previously Posted.';
	ELSIF(rec.transaction_status_id = 1) THEN
		msg := 'Transaction needs to be completed first.';
	ELSIF(rec.approve_status != 'Approved') THEN
		msg := 'Transaction is not yet approved.';
	ELSE
		INSERT INTO journals (org_id, department_id, currency_id, period_id, exchange_rate, journal_date, narrative)
		VALUES (rec.org_id, rec.department_id, rec.currency_id, periodid, rec.exchange_rate, rec.transaction_date, rec.tx_name || ' - posting for ' || rec.document_number);
		journalid := currval('journals_journal_id_seq');

		INSERT INTO gls (org_id, journal_id, account_id, debit, credit, gl_narrative)
		VALUES (rec.org_id, journalid, rec.entity_account_id, rec.debit_amount, rec.credit_amount, rec.tx_name || ' - ' || rec.entity_name);

		IF((rec.transaction_type_id = 7) or (rec.transaction_type_id = 8)) THEN
			INSERT INTO gls (org_id, journal_id, account_id, debit, credit, gl_narrative)
			VALUES (rec.org_id, journalid, rec.gl_bank_account_id, rec.credit_amount, rec.debit_amount, rec.tx_name || ' - ' || rec.entity_name);
		ELSE
			INSERT INTO gls (org_id, journal_id, account_id, debit, credit, gl_narrative)
			SELECT org_id, journalid, trans_account_id, full_debit_amount, full_credit_amount, rec.tx_name || ' - ' || item_name
			FROM vw_transaction_details
			WHERE (transaction_id = rec.transaction_id) AND (full_amount > 0);

			INSERT INTO gls (org_id, journal_id, account_id, debit, credit, gl_narrative)
			SELECT org_id, journalid, tax_account_id, tax_debit_amount, tax_credit_amount, rec.tx_name || ' - ' || item_name
			FROM vw_transaction_details
			WHERE (transaction_id = rec.transaction_id) AND (full_tax_amount > 0);
		END IF;

		UPDATE transactions SET journal_id = journalid WHERE (transaction_id = rec.transaction_id);
		msg := process_journal(CAST(journalid as varchar),'0','0');
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_tx_link(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
BEGIN
	
	INSERT INTO transaction_details (transaction_id, org_id, item_id, quantity, amount, tax_amount, narrative, details)
	SELECT CAST($3 as integer), org_id, item_id, quantity, amount, tax_amount, narrative, details
	FROM transaction_details
	WHERE (transaction_detail_id = CAST($1 as integer));

	INSERT INTO transaction_links (org_id, transaction_detail_id, transaction_detail_to, quantity, amount)
	SELECT org_id, transaction_detail_id, currval('transaction_details_transaction_detail_id_seq'), quantity, amount
	FROM transaction_details
	WHERE (transaction_detail_id = CAST($1 as integer));

	return 'DONE';
END;
$$ LANGUAGE plpgsql;


------------Hooks to approval trigger
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON transactions
    FOR EACH ROW EXECUTE PROCEDURE upd_action();


CREATE OR REPLACE FUNCTION get_budgeted(integer, date, integer) RETURNS real AS $$
DECLARE
	reca		RECORD;
	app_id		Integer;
	v_bill		real;
	v_variance	real;
BEGIN

	FOR reca IN SELECT transaction_detail_id, account_id, amount 
		FROM transaction_details WHERE (transaction_id = $1) LOOP

		SELECT sum(amount) INTO v_bill
		FROM transactions INNER JOIN transaction_details ON transactions.transaction_id = transaction_details.transaction_id
		WHERE (transactions.department_id = $3) AND (transaction_details.account_id = reca.account_id)
			AND (transactions.journal_id is null) AND (transaction_details.transaction_detail_id <> reca.transaction_detail_id);
		IF(v_bill is null)THEN
			v_bill := 0;
		END IF;

		SELECT sum(budget_lines.amount) INTO v_variance
		FROM fiscal_years INNER JOIN budgets ON fiscal_years.fiscal_year_id = budgets.fiscal_year_id
			INNER JOIN budget_lines ON budgets.budget_id = budget_lines.budget_id
		WHERE (budgets.department_id = $3) AND (budget_lines.account_id = reca.account_id)
			AND (budgets.approve_status = 'Approved')
			AND (fiscal_years.fiscal_year_start <= $2) AND (fiscal_years.fiscal_year_end >= $2);
		IF(v_variance is null)THEN
			v_variance := 0;
		END IF;

		v_variance := v_variance - (reca.amount + v_bill);

		IF(v_variance < 0)THEN
			RETURN v_variance;
		END IF;
	END LOOP;

	RETURN v_variance;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION upd_approvals(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	app_id		Integer;
	reca 		RECORD;
	recb		RECORD;
	recc		RECORD;
	recd		RECORD;

	min_level	Integer;
	mysql		varchar(240);
	msg 		varchar(120);
BEGIN
	app_id := CAST($1 as int);
	SELECT approvals.approval_id, approvals.org_id, approvals.table_name, approvals.table_id, approvals.review_advice,
		workflow_phases.workflow_phase_id, workflow_phases.workflow_id, workflow_phases.return_level INTO reca
	FROM approvals INNER JOIN workflow_phases ON approvals.workflow_phase_id = workflow_phases.workflow_phase_id
	WHERE (approvals.approval_id = app_id);

	SELECT count(approval_checklist_id) as cl_count INTO recc
	FROM approval_checklists
	WHERE (approval_id = app_id) AND (manditory = true) AND (done = false);

	SELECT transaction_type_id, get_budgeted(transaction_id, transaction_date, department_id) as budget_var INTO recd
	FROM transactions
	WHERE (workflow_table_id = reca.table_id);

	IF ($3 = '1') THEN
		UPDATE approvals SET approve_status = 'Completed', completion_date = now()
		WHERE approval_id = app_id;
		msg := 'Completed';
	ELSIF ($3 = '2') AND (recc.cl_count <> 0) THEN
		msg := 'There are manditory checklist that must be checked first.';
	ELSIF (recd.transaction_type_id = 5) AND (recd.budget_var < 0) THEN
		msg := 'You need a budget to approve the expenditure.';
	ELSIF ($3 = '2') AND (recc.cl_count = 0) THEN
		UPDATE approvals SET approve_status = 'Approved', action_date = now(), app_entity_id = CAST($2 as int)
		WHERE approval_id = app_id;

		SELECT min(approvals.approval_level) INTO min_level
		FROM approvals INNER JOIN workflow_phases ON approvals.workflow_phase_id = workflow_phases.workflow_phase_id
		WHERE (approvals.table_id = reca.table_id) AND (approvals.approve_status = 'Draft')
			AND (workflow_phases.advice = false) AND (workflow_phases.notice = false);
		
		IF(min_level is null)THEN
			mysql := 'UPDATE ' || reca.table_name || ' SET approve_status = ' || quote_literal('Approved') 
			|| ', action_date = now()'
			|| ' WHERE workflow_table_id = ' || reca.table_id;
			EXECUTE mysql;

			INSERT INTO sys_emailed (table_id, table_name, email_type)
			VALUES (reca.table_id, 'vw_workflow_approvals', 1);
		ELSE
			FOR recb IN SELECT workflow_phase_id, advice
			FROM workflow_phases
			WHERE (workflow_id = reca.workflow_id) AND (approval_level = min_level) LOOP
				IF (recb.advice = true) THEN
					UPDATE approvals SET approve_status = 'Approved', action_date = now(), completion_date = now()
					WHERE (workflow_phase_id = recb.workflow_phase_id) AND (table_id = reca.table_id);
				ELSE
					UPDATE approvals SET approve_status = 'Completed', completion_date = now()
					WHERE (workflow_phase_id = recb.workflow_phase_id) AND (table_id = reca.table_id);
				END IF;
			END LOOP;
		END IF;
		msg := 'Approved';
	ELSIF ($3 = '3') THEN
		UPDATE approvals SET approve_status = 'Rejected',  action_date = now(), app_entity_id = CAST($2 as int)
		WHERE approval_id = app_id;

		mysql := 'UPDATE ' || reca.table_name || ' SET approve_status = ' || quote_literal('Rejected') 
		|| ', action_date = now()'
		|| ' WHERE workflow_table_id = ' || reca.table_id;
		EXECUTE mysql;

		INSERT INTO sys_emailed (table_id, table_name, email_type, org_id)
		VALUES (reca.table_id, 'vw_workflow_approvals', 2, reca.org_id);
		msg := 'Rejected';
	ELSIF ($3 = '4') AND (reca.return_level = 0) THEN
		UPDATE approvals SET approve_status = 'Review',  action_date = now(), app_entity_id = CAST($2 as int)
		WHERE approval_id = app_id;
		
		mysql := 'UPDATE ' || reca.table_name || ' SET approve_status = ' || quote_literal('Draft') 
		|| ', action_date = now()'
		|| ' WHERE workflow_table_id = ' || reca.table_id;
		EXECUTE mysql;
		
		msg := 'Forwarded for review';
	ELSIF ($3 = '4') AND (reca.return_level <> 0) THEN
		INSERT INTO approvals (org_id, workflow_phase_id, table_name, table_id, org_entity_id, escalation_days, escalation_hours, approval_level, approval_narrative, to_be_done, approve_status)
		SELECT org_id, workflow_phase_id, reca.table_name, reca.table_id, CAST($2 as int), escalation_days, escalation_hours, approval_level, phase_narrative, reca.review_advice, 'Completed'
		FROM vw_workflow_entitys
		WHERE (workflow_id = reca.workflow_id) AND (approval_level = reca.return_level)
		ORDER BY workflow_phase_id;
		msg := 'Forwarded to owner for review';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;

  
  
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




>>>>>>> e829fb97559b72260b88801b69fa435872e337b8
