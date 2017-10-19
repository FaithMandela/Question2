---Project Database Functions File

CREATE OR REPLACE FUNCTION ins_customers() RETURNS trigger AS $$
DECLARE
	v_entity_type_id		integer;
	v_entity_id				integer;
	v_user_name				varchar(32);
BEGIN

	IF(TG_OP = 'INSERT')THEN
		SELECT entity_type_id INTO v_entity_type_id
		FROM entity_types 
		WHERE (org_id = NEW.org_id) AND (use_key_id = 100);
		IF(NEW.entity_id is null)THEN
			NEW.entity_id := nextval('entitys_entity_id_seq');
		END IF;
		v_user_name := 'OR' || NEW.org_id || 'EN' || NEW.entity_id;
		
		INSERT INTO entitys (entity_id, org_id, use_key_id, entity_type_id, entity_name, user_name, primary_email, primary_telephone, function_role)
		VALUES (NEW.entity_id, NEW.org_id, 100, v_entity_type_id, NEW.customer_name, v_user_name, lower(trim(NEW.customer_email)), NEW.telephone_number, 'customer');
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_customers BEFORE INSERT OR UPDATE ON customers
	FOR EACH ROW EXECUTE PROCEDURE ins_customers();

CREATE OR REPLACE FUNCTION ins_deposit_accounts() RETURNS trigger AS $$
DECLARE
	v_fee_amount		real;
	v_fee_ps			real;
	myrec				RECORD;
BEGIN

	IF(TG_OP = 'INSERT')THEN
		SELECT interest_rate, min_opening_balance, minimum_balance, maximum_balance INTO myrec
		FROM products WHERE product_id = NEW.product_id;
	
		IF(NEW.account_number is null)THEN
			NEW.account_number := '4' || lpad(NEW.org_id::varchar, 2, '0')  || lpad(NEW.entity_id::varchar, 4, '0') || lpad(NEW.deposit_account_id::varchar, 2, '0');
		END IF;
		NEW.interest_rate := myrec.interest_rate;
	ELSE
		IF(NEW.approve_status = 'Approved')THEN
			INSERT INTO account_activity (deposit_account_id, activity_type_id, activity_frequency_id,
				activity_status_id, currency_id, entity_id, org_id, transfer_account_no,
				activity_date, value_date, account_debit)
			SELECT NEW.deposit_account_id, account_definations.activity_type_id, account_definations.activity_frequency_id,
				1, products.currency_id, NEW.entity_id, NEW.org_id, account_definations.account_number,
				NEW.opening_date, NEW.opening_date, account_definations.fee_amount
			FROM account_definations INNER JOIN activity_types ON account_definations.activity_type_id = activity_types.activity_type_id
				INNER JOIN products ON account_definations.product_id = products.product_id
			WHERE (account_definations.product_id = NEW.product_id) AND (account_definations.org_id = NEW.org_id)
				AND (account_definations.activity_frequency_id = 1) AND (activity_types.use_key_id = 201) 
				AND (account_definations.is_active = true)
				AND (account_definations.start_date < NEW.opening_date);
		END IF;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_deposit_accounts BEFORE INSERT OR UPDATE ON deposit_accounts
	FOR EACH ROW EXECUTE PROCEDURE ins_deposit_accounts();


CREATE OR REPLACE FUNCTION ins_account_activity() RETURNS trigger AS $$
DECLARE
	v_deposit_account_id		integer;
	v_period_id					integer;
	v_loan_id					integer;
	v_activity_type_id			integer;
	v_use_key_id				integer;
	v_minimum_balance			real;
	v_account_transfer			varchar(32);
BEGIN

	IF((NEW.account_credit = 0) AND (NEW.account_debit = 0))THEN
		RAISE EXCEPTION 'You must enter a debit or credit amount';
	ELSIF((NEW.account_credit < 0) OR (NEW.account_debit < 0))THEN
		RAISE EXCEPTION 'The amounts must be positive';
	ELSIF((NEW.account_credit > 0) AND (NEW.account_debit > 0))THEN
		RAISE EXCEPTION 'Both debit and credit cannot not have an amount at the same time';
	END IF;
	
	SELECT periods.period_id INTO NEW.period_id
	FROM periods
	WHERE (opened = true) AND (activated = true) AND (closed = false)
		AND (start_date <= NEW.activity_date) AND (end_date >= NEW.activity_date);
	IF(NEW.period_id is null)THEN
		RAISE EXCEPTION 'The transaction needs to be in an open and actiive period';
	END IF;
	
	IF(NEW.link_activity_id is null)THEN
		NEW.link_activity_id := nextval('link_activity_id_seq');
	END IF;
	
	IF(TG_OP = 'INSERT')THEN
		IF(NEW.deposit_account_id is not null)THEN
			SELECT sum(account_credit - account_debit) INTO NEW.balance
			FROM account_activity
			WHERE (account_activity_id < NEW.account_activity_id)
				AND (deposit_account_id = NEW.deposit_account_id);
		END IF;
		IF(NEW.balance is null)THEN
			NEW.balance := 0;
		END IF;
		NEW.balance := NEW.balance + (NEW.account_credit - NEW.account_debit);
		
		SELECT use_key_id INTO v_use_key_id
		FROM activity_types WHERE (activity_type_id = NEW.activity_type_id);
		
		IF(v_use_key_id = 102)THEN
			SELECT COALESCE(minimum_balance, 0) INTO v_minimum_balance
			FROM deposit_accounts WHERE deposit_account_id = NEW.deposit_account_id;
			
			IF(NEW.balance < v_minimum_balance)THEN
				RAISE EXCEPTION 'You cannot withdraw below allowed minimum balance';
			END IF;
		END IF;
	END IF;
	
	IF(NEW.transfer_account_no is null)THEN
		SELECT vw_account_definations.account_number INTO NEW.transfer_account_no
		FROM vw_account_definations INNER JOIN deposit_accounts ON vw_account_definations.product_id = deposit_accounts.product_id
		WHERE (deposit_accounts.deposit_account_id = NEW.deposit_account_id) 
			AND (vw_account_definations.activity_type_id = NEW.activity_type_id) 
			AND (vw_account_definations.use_key_id IN (101, 102));
	END IF;
	
	IF(NEW.transfer_account_no is not null)THEN
		SELECT deposit_account_id INTO v_deposit_account_id
		FROM deposit_accounts
		WHERE (account_number = NEW.transfer_account_no);
				
		IF(v_deposit_account_id is null)THEN
			RAISE EXCEPTION 'Enter a valid account to do transfer';
		ELSIF(v_deposit_account_id is not null)THEN
			NEW.transfer_account_id := v_deposit_account_id;
		END IF;
	END IF;
			
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_account_activity BEFORE INSERT OR UPDATE ON account_activity
	FOR EACH ROW EXECUTE PROCEDURE ins_account_activity();

CREATE OR REPLACE FUNCTION aft_account_activity() RETURNS trigger AS $$
DECLARE
	reca 						RECORD;
	v_account_activity_id		integer;
	v_product_id				integer;
	v_use_key_id				integer;
	v_actual_balance			real;
	v_total_debits				real;
BEGIN

	IF(NEW.deposit_account_id is not null) THEN
		SELECT product_id INTO v_product_id
		FROM deposit_accounts WHERE deposit_account_id = NEW.deposit_account_id;
	END IF;
	
	--- Generate the countra entry for a transfer
	IF(NEW.transfer_account_id is not null)THEN
		SELECT account_activity_id INTO v_account_activity_id
		FROM account_activity
		WHERE (deposit_account_id = NEW.transfer_account_id)
			AND (link_activity_id = NEW.link_activity_id);
			
		IF(v_account_activity_id is null)THEN
			INSERT INTO account_activity (deposit_account_id, transfer_account_id, transfer_loan_id, activity_type_id,
				currency_id, org_id, link_activity_id, activity_date, value_date,
				activity_status_id, account_credit, account_debit, activity_frequency_id)
			VALUES (NEW.transfer_account_id, NEW.deposit_account_id, NEW.loan_id, NEW.activity_type_id,
				NEW.currency_id, NEW.org_id, NEW.link_activity_id, NEW.activity_date, NEW.value_date,
				NEW.activity_status_id, NEW.account_debit, NEW.account_credit, 1);
		END IF;
	END IF;

	--- Posting the charge on the transfer transaction
	SELECT use_key_id INTO v_use_key_id
	FROM activity_types
	WHERE (activity_type_id = NEW.activity_type_id);
	IF((v_use_key_id < 200) AND (NEW.account_debit > 0))THEN
		INSERT INTO account_activity (deposit_account_id, activity_type_id, activity_frequency_id,
			activity_status_id, currency_id, entity_id, org_id, transfer_account_no,
			link_activity_id, activity_date, value_date, account_debit)
		SELECT NEW.deposit_account_id, account_definations.charge_activity_id, account_definations.activity_frequency_id,
			1, products.currency_id, NEW.entity_id, NEW.org_id, account_definations.account_number,
			NEW.link_activity_id, current_date, current_date, 
			(account_definations.fee_amount + account_definations.fee_ps * NEW.account_debit / 100)
			
		FROM account_definations INNER JOIN products ON account_definations.product_id = products.product_id
		WHERE (account_definations.product_id = v_product_id)
			AND (account_definations.activity_frequency_id = 1) 
			AND (account_definations.activity_type_id = NEW.activity_type_id) 
			AND (account_definations.is_active = true) AND (account_definations.has_charge = true)
			AND (account_definations.start_date < current_date);
	END IF;
	
	--- compute for Commited amounts taking the date into consideration
	IF((NEW.account_credit > 0) AND (NEW.activity_status_id = 1))THEN
		SELECT sum((account_credit - account_debit) * exchange_rate) INTO v_actual_balance
		FROM account_activity 
		WHERE (deposit_account_id = NEW.deposit_account_id) AND (activity_status_id < 3) AND (value_date <= NEW.value_date);
		IF(v_actual_balance is null)THEN v_actual_balance := 0; END IF;
		SELECT sum(account_debit * exchange_rate) INTO v_total_debits
		FROM account_activity 
		WHERE (deposit_account_id = NEW.deposit_account_id) AND (activity_status_id = 3) AND (value_date <= NEW.value_date);
		IF(v_total_debits is null)THEN v_total_debits := 0; END IF;
		v_actual_balance := v_actual_balance - v_total_debits;
			
		FOR reca IN SELECT account_activity_id, activity_status_id, link_activity_id, 
				(account_debit * exchange_rate) as debit_amount
			FROM account_activity 
			WHERE (deposit_account_id = NEW.deposit_account_id) AND (activity_status_id = 4) AND (activity_date <= NEW.value_date)
				AND (account_credit = 0) AND (account_debit > 0)
			ORDER BY activity_date, account_activity_id
		LOOP
			IF(v_actual_balance > reca.debit_amount)THEN
				UPDATE account_activity SET activity_status_id = 1 WHERE link_activity_id = reca.link_activity_id;
				v_actual_balance := v_actual_balance - reca.debit_amount;
			END IF;
		END LOOP;
	END IF;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aft_account_activity AFTER INSERT OR UPDATE ON account_activity
	FOR EACH ROW EXECUTE PROCEDURE aft_account_activity();
	
CREATE OR REPLACE FUNCTION log_account_activity() RETURNS trigger AS $$
BEGIN

	INSERT INTO account_activity_log(account_activity_id, deposit_account_id, 
		transfer_account_id, activity_type_id, activity_frequency_id, 
		activity_status_id, currency_id, period_id, entity_id,
		loan_id, transfer_loan_id, org_id, link_activity_id, deposit_account_no, 
		transfer_account_no, activity_date, value_date, account_credit, 
		account_debit, balance, exchange_rate, application_date, approve_status, 
		workflow_table_id, action_date, details)
    VALUES (NEW.account_activity_id, NEW.deposit_account_id, 
		NEW.transfer_account_id, NEW.activity_type_id, NEW.activity_frequency_id, 
		NEW.activity_status_id, NEW.currency_id, NEW.period_id, NEW.entity_id,
		NEW.loan_id, NEW.transfer_loan_id, NEW.org_id, NEW.link_activity_id, NEW.deposit_account_no, 
		NEW.transfer_account_no, NEW.activity_date, NEW.value_date, NEW.account_credit, 
		NEW.account_debit, NEW.balance, NEW.exchange_rate, NEW.application_date, NEW.approve_status, 
		NEW.workflow_table_id, NEW.action_date, NEW.details);

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_account_activity AFTER INSERT OR UPDATE ON account_activity
	FOR EACH ROW EXECUTE PROCEDURE log_account_activity();
	
CREATE OR REPLACE FUNCTION apply_approval(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg							varchar(120);
	v_deposit_account_id		integer;
	v_principal_amount			real;
	v_repayment_amount			real;
	v_maximum_repayments		integer;
	v_repayment_period			integer;
BEGIN

	IF($3 = '1')THEN
		UPDATE customers SET approve_status = 'Completed' 
		WHERE (entity_id = $1::integer) AND (approve_status = 'Draft');

		msg := 'Applied for client approval';
	ELSIF($3 = '2')THEN
		UPDATE deposit_accounts SET approve_status = 'Completed' 
		WHERE (deposit_account_id = $1::integer) AND (approve_status = 'Draft');
		
		msg := 'Applied for account approval';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_intrest(integer, integer, integer) RETURNS real AS $$
DECLARE
	v_principal_amount 			real;
	v_interest_rate				real;
	v_actual_balance			real;
	v_total_debits				real;
	v_start_date				date;
	v_end_date					date;
	ans							real;
BEGIN

	SELECT start_date, end_date INTO v_start_date, v_end_date
	FROM periods WHERE (period_id = $3::integer);

	IF($1 = 1)THEN
		SELECT interest_rate INTO v_interest_rate
		FROM loans  WHERE (loan_id = $2);

		SELECT sum((account_debit - account_credit) * exchange_rate) INTO v_actual_balance
		FROM account_activity 
		WHERE (loan_id = $2) AND (activity_status_id < 2) AND (value_date <= v_end_date);

		ans := v_actual_balance * v_interest_rate / 1200;
	ELSIF($1 = 2)THEN
		SELECT principal_amount, interest_rate INTO v_principal_amount, v_interest_rate
		FROM vw_loans 
		WHERE (loan_id = $2);
		
		ans := v_principal_amount * v_interest_rate / 1200;
	ELSIF($1 = 3)THEN
		SELECT interest_rate INTO v_interest_rate
		FROM deposit_accounts  WHERE (deposit_account_id = $2);
		
		SELECT sum((account_credit - account_debit) * exchange_rate) INTO v_actual_balance
		FROM account_activity 
		WHERE (deposit_account_id = $2) AND (activity_status_id < 2) AND (value_date < v_start_date);
		IF(v_actual_balance is null)THEN v_actual_balance := 0; END IF;
		SELECT sum(account_debit * exchange_rate) INTO v_total_debits
		FROM account_activity 
		WHERE (deposit_account_id = $2) AND (activity_status_id < 2) AND (value_date BETWEEN v_start_date AND v_end_date);
		IF(v_total_debits is null)THEN v_total_debits := 0; END IF;
	
		ans := (v_actual_balance - v_total_debits) * v_interest_rate / 1200;
	END IF;

	RETURN ans;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_penalty(integer, integer, integer, real) RETURNS real AS $$
DECLARE
	v_actual_default			real;
	v_start_date				date;
	v_end_date					date;
	ans							real;
BEGIN

	SELECT start_date, end_date INTO v_start_date, v_end_date
	FROM periods WHERE (period_id = $3::integer);

	IF($1 = 1)THEN
		SELECT sum(account_credit * exchange_rate) INTO v_actual_default
		FROM account_activity 
		WHERE (loan_id = $2) AND (activity_status_id = 4) AND (value_date < v_start_date);
		
		ans := v_actual_default * $3 / 1200;
	END IF;

	RETURN ans;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION post_banking(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	reca 						RECORD;
	v_journal_id				integer;
	v_org_id					integer;
	v_currency_id				integer;
	v_period_id					integer;
	v_start_date				date;
	v_end_date					date;

	msg							varchar(120);
BEGIN

	SELECT orgs.org_id, orgs.currency_id, periods.period_id, periods.start_date, periods.end_date
		INTO v_org_id, v_currency_id, v_period_id, v_start_date, v_end_date
	FROM periods INNER JOIN orgs ON periods.org_id = orgs.org_id
	WHERE (period_id = $1::integer) AND (opened = true) AND (activated = false) AND (closed = false);
	
	IF(v_period_id is null)THEN
		msg := 'Banking not posted period need to be open but not active';
	ELSE
		UPDATE account_activity SET period_id = v_period_id 
		WHERE (period_id is null) AND (activity_date BETWEEN v_start_date AND v_end_date);
		
		v_journal_id := nextval('journals_journal_id_seq');
		INSERT INTO journals (journal_id, org_id, currency_id, period_id, exchange_rate, journal_date, narrative)
		VALUES (v_journal_id, v_org_id, v_currency_id, v_period_id, 1, v_end_date, 'Banking - ' || to_char(v_start_date, 'MMYYY'));
		
		INSERT INTO gls(org_id, journal_id, account_activity_id, account_id, 
			debit, credit, gl_narrative)
		SELECT v_org_id, v_journal_id, account_activity.account_activity_id, activity_types.account_id,
			(account_activity.account_debit * account_activity.exchange_rate),
			(account_activity.account_credit * account_activity.exchange_rate),
			COALESCE(deposit_accounts.account_number, loans.account_number)
		FROM account_activity INNER JOIN activity_types ON account_activity.activity_type_id = activity_types.activity_type_id
			LEFT JOIN deposit_accounts ON account_activity.deposit_account_id = deposit_accounts.deposit_account_id
			LEFT JOIN loans ON account_activity.loan_id = loans.loan_id
		WHERE (account_activity.period_id = v_period_id);
	
		msg := 'Banking posted';
	END IF;

	RETURN msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION aft_mpesa_trxs() RETURNS trigger AS $$
DECLARE
	v_entity_type_id			integer;
	v_entity_id					integer;
	v_deposit_account_id		integer;
	v_car_plate					varchar(12);
BEGIN

	SELECT entity_id INTO v_entity_id
	FROM customers WHERE identification_number = NEW.mpesa_msisdn;
	
	IF(v_entity_id is null)THEN
		v_entity_id := nextval('entitys_entity_id_seq');
		INSERT INTO customers (org_id, entity_id, customer_name, identification_number, telephone_number)
		VALUES (0, v_entity_id, NEW.mpesa_sender, NEW.mpesa_msisdn, NEW.mpesa_msisdn);
		
		INSERT INTO deposit_accounts (entity_id, updated_by, product_id, org_id)
		VALUES (v_entity_id, v_entity_id, 1, 0);
	END IF;
	
	v_car_plate := trim(upper(replace(NEW.mpesa_acc, ' ', '')));
	SELECT deposit_account_id INTO v_deposit_account_id
	FROM deposit_accounts WHERE account_number = v_car_plate;
	IF(v_deposit_account_id is null)THEN
		INSERT INTO deposit_accounts (entity_id, updated_by, product_id, org_id, account_number)
		VALUES (11, v_entity_id, 1, 0, v_car_plate);
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aft_mpesa_trxs AFTER INSERT ON mpesa_trxs
	FOR EACH ROW EXECUTE PROCEDURE aft_mpesa_trxs();
