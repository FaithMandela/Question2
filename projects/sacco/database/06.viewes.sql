
--VIEWS

CREATE VIEW vw_gurrantors AS  
	SELECT vw_loans.principle,vw_loans.entity_id, vw_loans.interest,
		vw_loans.monthly_repayment,vw_loans.loan_date,vw_loans.initial_payment,	vw_loans.loan_id,vw_loan.repayment_amount,vw_loans.total_interest,
		vw_loans.loan_balance,vw_loans.calc_repayment_period,vw_loans.reducing_balance, vw_loans.repayment_period,vw_loans.application_date,vw_loans.approve_status,vw_loans.org_id,
		,vw_loans.action_date,vw_loans.details,
	
		entitys.entity_name,entitys.is_picked,
		loan_types.loan_type_id,loan_types.loan_type_name,loan_types.default_interest,gurrantors.gurrantor_id,
		gurrantors.is_accepted,gurrantors.amount,gurrantors_entity.entity_name as gurrantor_entity_name,
		gurrantors_entity.entity_id AS gurrantor_entity_id
	FROM vw_loans
		JOIN entitys ON loans.entity_id = entitys.entity_id
		JOIN loan_types ON loans.loan_type_id = loan_types.loan_type_id
		JOIN gurrantors ON gurrantors.loan_id = loans.loan_id
		JOIN entitys gurrantors_entity ON entitys.entity_id = gurrantors.entity_id;

    
CREATE VIEW vw_contributions AS
	SELECT contributions.contribution_id,contributions.org_id,contributions.entity_id,contributions.period_id,
		contributions.payment_type_id,contributions.deposit_date,contributions.deposit_amount,contributions.entry_date,
		contributions.transaction_ref,contributions.contribution_amount,
		entitys.entity_name,entitys.is_active,
		contribution_types.contribution_type_id,contribution_types.contribution_type_name,
		payment_types.payment_type_name,payment_types.payment_narrative
	FROM contributions
		JOIN entitys ON contributions.entity_id = entitys.entity_id
		JOIN contribution_types on contributions.contribution_type_id = contribution_types.contribution_type_id
		JOIN payment_types ON payment_types.payment_type_id = contributions.payment_type_id;  
	
DROP VIEW vw_entitys;

CREATE OR REPLACE VIEW vw_entitys AS 
SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default, vw_orgs.is_active as org_is_active, 
		vw_orgs.logo as org_logo, vw_orgs.cert_number as org_cert_number, vw_orgs.pin as org_pin, 
		vw_orgs.vat_number as org_vat_number, vw_orgs.invoice_footer as org_invoice_footer,
		vw_orgs.sys_country_id as org_sys_country_id, vw_orgs.sys_country_name as org_sys_country_name, 
		vw_orgs.address_id as org_address_id, vw_orgs.table_name as org_table_name,
		vw_orgs.post_office_box as org_post_office_box, vw_orgs.postal_code as org_postal_code, 
		vw_orgs.premises as org_premises, vw_orgs.street as org_street, vw_orgs.town as org_town, 
		vw_orgs.phone_number as org_phone_number, vw_orgs.extension as org_extension, 
		vw_orgs.mobile as org_mobile, vw_orgs.fax as org_fax, vw_orgs.email as org_email, vw_orgs.website as org_website,
		
		addr.address_id, addr.address_name,
		addr.sys_country_id, addr.sys_country_name, addr.table_name, addr.is_default,
		addr.post_office_box, addr.postal_code, addr.premises, addr.street, addr.town, 
		addr.phone_number, addr.extension, addr.mobile, addr.fax, addr.email, addr.website,
		
		entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, 
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention, entitys.primary_email,
		
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role, entity_types.use_key
	FROM (entitys LEFT JOIN vw_address_entitys as addr ON entitys.entity_id = addr.table_id)
		JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id ;
		
CREATE OR REPLACE VIEW vw_entitys_types AS 
	SELECT	entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, 
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention, entitys.primary_email, entitys.org_id,entitys.primary_telephone,
		
		entity_types.entity_type_id, entity_types.entity_type_name, 
		entity_types.entity_role, entity_types.use_key
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
		
CREATE OR REPLACE VIEW vw_applicants AS 
 SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name, applicants.entity_id, applicants.surname,applicants.org_id,
	applicants.first_name,applicants.middle_name,applicants.date_of_birth,applicants.nationality,applicants.identity_card,
	applicants.language,applicants.objective, applicants.interests,applicants.picture_file,applicants.details,  applicants.person_title,applicants.applicant_email,applicants.applicant_phone,applicants.workflow_table_id,applicants.approve_status,applicants.action_date,
	(((applicants.surname::text || ' '::text) || applicants.first_name::text) || ' '::text) || COALESCE(applicants.middle_name, ''::character varying)::text AS applicant_name,
	to_char(age(applicants.date_of_birth::timestamp with time zone), 'YY'::text) AS applicant_age,
        CASE
            WHEN applicants.gender::text = 'M'::text THEN 'Male'::text
            ELSE 'Female'::text
        END AS gender_name,
        CASE
            WHEN applicants.marital_status::text = 'M'::text THEN 'Married'::text
            ELSE 'Single'::text
        END AS marital_status_name
   FROM applicants
     JOIN sys_countrys ON applicants.nationality = sys_countrys.sys_country_id;
     

CREATE VIEW vw_loan_repayments AS
	SELECT 	vw_loans.currency_id, vw_loans.currency_name,vw_loans.currency_symbol,
		vw_loans.loan_type_id, vw_loans.loan_type_name, 
		vw_loans.entity_id, vw_loans.entity_name,
		vw_loans.org_id, vw_loans.loan_id, vw_loans.principle, vw_loans.interest, vw_loans.monthly_repayment, vw_loans.reducing_balance, 
		vw_loans.repayment_period,vw_loans.application_date, vw_loans.approve_status, vw_loans.initial_payment, 
		vw_loans.loan_date, vw_loans.action_date,vw_loans.details,
		vw_loans.repayment_amount, vw_loans.total_interest, vw_loans. loan_balance,
		loan_repayment.loan_repayment_id, loan_repayment.period_id,
		loan_repayment.repayment_amount as loan_repayment_amount,
		loan_repayment.repayment_interest,
		loan_repayment.penalty, loan_repayment.penalty_paid,
		loan_repayment.repayment_narrative,
		vw_loans.calc_repayment_period
	FROM vw_loans
	INNER JOIN loan_repayment ON loan_repayment.loan_id = vw_loans.loan_id

CREATE VIEW vw_transactions AS
	SELECT transaction_types.transaction_type_id, transaction_types.transaction_type_name, 
		transaction_types.document_prefix, transaction_types.for_posting, transaction_types.for_sales, 
		entitys.entity_id, entitys.entity_name, entitys.account_id as entity_account_id, 
		currency.currency_id, currency.currency_name,
		vw_bank_accounts.bank_id, vw_bank_accounts.bank_name, vw_bank_accounts.bank_branch_name, vw_bank_accounts.account_id as gl_bank_account_id, 
		vw_bank_accounts.bank_account_id, vw_bank_accounts.bank_account_name, vw_bank_accounts.bank_account_number, 
		departments.department_id, departments.department_name,
		transaction_status.transaction_status_id, transaction_status.transaction_status_name, transactions.journal_id, 
		transactions.transaction_id, transactions.org_id, transactions.transaction_date, transactions.transaction_amount,
		transactions.application_date, transactions.approve_status, transactions.workflow_table_id, transactions.action_date, 
		transactions.narrative, transactions.document_number, transactions.payment_number, transactions.order_number,
		transactions.exchange_rate, transactions.payment_terms, transactions.job, transactions.details,
		(CASE WHEN transactions.journal_id is null THEN 'Not Posted' ELSE 'Posted' END) as posted,
		(CASE WHEN (transactions.transaction_type_id = 2) or (transactions.transaction_type_id = 8) or (transactions.transaction_type_id = 10) 
			THEN transactions.transaction_amount ELSE 0 END) as debit_amount,
		(CASE WHEN (transactions.transaction_type_id = 5) or (transactions.transaction_type_id = 7) or (transactions.transaction_type_id = 9) 
			THEN transactions.transaction_amount ELSE 0 END) as credit_amount
	FROM transactions INNER JOIN transaction_types ON transactions.transaction_type_id = transaction_types.transaction_type_id
		INNER JOIN transaction_status ON transactions.transaction_status_id = transaction_status.transaction_status_id
		INNER JOIN currency ON transactions.currency_id = currency.currency_id
		LEFT JOIN entitys ON transactions.entity_id = entitys.entity_id
		LEFT JOIN vw_bank_accounts ON vw_bank_accounts.bank_account_id = transactions.bank_account_id
		LEFT JOIN departments ON transactions.department_id = departments.department_id;




CREATE VIEW vw_trx AS
	SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default, vw_orgs.is_active as org_is_active, 
		vw_orgs.logo as org_logo, vw_orgs.cert_number as org_cert_number, vw_orgs.pin as org_pin, 
		vw_orgs.vat_number as org_vat_number, vw_orgs.invoice_footer as org_invoice_footer,
		vw_orgs.sys_country_id as org_sys_country_id, vw_orgs.sys_country_name as org_sys_country_name, 
		vw_orgs.address_id as org_address_id, vw_orgs.table_name as org_table_name,
		vw_orgs.post_office_box as org_post_office_box, vw_orgs.postal_code as org_postal_code, 
		vw_orgs.premises as org_premises, vw_orgs.street as org_street, vw_orgs.town as org_town, 
		vw_orgs.phone_number as org_phone_number, vw_orgs.extension as org_extension, 
		vw_orgs.mobile as org_mobile, vw_orgs.fax as org_fax, vw_orgs.email as org_email, vw_orgs.website as org_website,
		vw_entitys.address_id, vw_entitys.address_name,
		vw_entitys.sys_country_id, vw_entitys.sys_country_name, vw_entitys.table_name, vw_entitys.is_default,
		vw_entitys.post_office_box, vw_entitys.postal_code, vw_entitys.premises, vw_entitys.street, vw_entitys.town, 
		vw_entitys.phone_number, vw_entitys.extension, vw_entitys.mobile, vw_entitys.fax, vw_entitys.email, vw_entitys.website,
		vw_entitys.entity_id, vw_entitys.entity_name, vw_entitys.User_name, vw_entitys.Super_User, vw_entitys.attention, 
		vw_entitys.Date_Enroled, vw_entitys.Is_Active, vw_entitys.entity_type_id, vw_entitys.entity_type_name,
		vw_entitys.entity_role, vw_entitys.use_key,
		transaction_types.transaction_type_id, transaction_types.transaction_type_name, 
		transaction_types.document_prefix, transaction_types.for_sales, transaction_types.for_posting,
		transaction_status.transaction_status_id, transaction_status.transaction_status_name, 
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		departments.department_id, departments.department_name,
		transactions.journal_id, transactions.bank_account_id,
		transactions.transaction_id, transactions.transaction_date, transactions.transaction_amount,
		transactions.application_date, transactions.approve_status, transactions.workflow_table_id, transactions.action_date, 
		transactions.narrative, transactions.document_number, transactions.payment_number, transactions.order_number,
		transactions.exchange_rate, transactions.payment_terms, transactions.job, transactions.details,
		(CASE WHEN transactions.journal_id is null THEN 'Not Posted' ELSE 'Posted' END) as posted,
		(CASE WHEN (transactions.transaction_type_id = 2) or (transactions.transaction_type_id = 8) or (transactions.transaction_type_id = 10) 
			THEN transactions.transaction_amount ELSE 0 END) as debit_amount,
		(CASE WHEN (transactions.transaction_type_id = 5) or (transactions.transaction_type_id = 7) or (transactions.transaction_type_id = 9) 
			THEN transactions.transaction_amount ELSE 0 END) as credit_amount
	FROM transactions INNER JOIN transaction_types ON transactions.transaction_type_id = transaction_types.transaction_type_id
		INNER JOIN vw_orgs ON transactions.org_id = vw_orgs.org_id
		INNER JOIN transaction_status ON transactions.transaction_status_id = transaction_status.transaction_status_id
		INNER JOIN currency ON transactions.currency_id = currency.currency_id
		LEFT JOIN vw_entitys ON transactions.entity_id = vw_entitys.entity_id
		LEFT JOIN departments ON transactions.department_id = departments.department_id;





CREATE VIEW vw_trx_sum AS
	SELECT transaction_details.transaction_id, 
		SUM(transaction_details.quantity * transaction_details.amount) as total_amount,
		SUM(transaction_details.quantity * transaction_details.tax_amount) as total_tax_amount,
		SUM(transaction_details.quantity * (transaction_details.amount + transaction_details.tax_amount)) as total_sale_amount
	FROM transaction_details
	GROUP BY transaction_details.transaction_id;

CREATE VIEW vw_transaction_details AS
	SELECT vw_transactions.department_id, vw_transactions.department_name, vw_transactions.transaction_type_id, 
		vw_transactions.transaction_type_name, vw_transactions.document_prefix, vw_transactions.transaction_id, 
		vw_transactions.transaction_date, vw_transactions.entity_id, vw_transactions.entity_name,
		vw_transactions.approve_status, vw_transactions.workflow_table_id,
		vw_transactions.currency_name, vw_transactions.exchange_rate,
		accounts.account_id, accounts.account_name, vw_items.item_id, vw_items.item_name,
		vw_items.tax_type_id, vw_items.tax_account_id, vw_items.tax_type_name, vw_items.tax_rate, vw_items.tax_inclusive,
		vw_items.sales_account_id, vw_items.purchase_account_id,
		stores.store_id, stores.store_name, 
		transaction_details.transaction_detail_id, transaction_details.org_id, transaction_details.quantity, 
		transaction_details.amount, transaction_details.tax_amount, transaction_details.narrative, transaction_details.details,
		COALESCE(transaction_details.narrative, vw_items.item_name) as item_description,
		(transaction_details.quantity * transaction_details.amount) as full_amount,
		(transaction_details.quantity * transaction_details.tax_amount) as full_tax_amount,
		(transaction_details.quantity * (transaction_details.amount + transaction_details.tax_amount)) as full_total_amount,
		(CASE WHEN (vw_transactions.transaction_type_id = 5) or (vw_transactions.transaction_type_id = 9) 
			THEN (transaction_details.quantity * transaction_details.tax_amount) ELSE 0 END) as tax_debit_amount,
		(CASE WHEN (vw_transactions.transaction_type_id = 2) or (vw_transactions.transaction_type_id = 10) 
			THEN (transaction_details.quantity * transaction_details.tax_amount) ELSE 0 END) as tax_credit_amount,
		(CASE WHEN (vw_transactions.transaction_type_id = 5) or (vw_transactions.transaction_type_id = 9) 
			THEN (transaction_details.quantity * transaction_details.amount) ELSE 0 END) as full_debit_amount,
		(CASE WHEN (vw_transactions.transaction_type_id = 2) or (vw_transactions.transaction_type_id = 10) 
			THEN (transaction_details.quantity * transaction_details.amount)  ELSE 0 END) as full_credit_amount,
		(CASE WHEN (vw_transactions.transaction_type_id = 2) or (vw_transactions.transaction_type_id = 9) 
			THEN vw_items.sales_account_id ELSE vw_items.purchase_account_id END) as trans_account_id
	FROM transaction_details INNER JOIN vw_transactions ON transaction_details.transaction_id = vw_transactions.transaction_id
		LEFT JOIN vw_items ON transaction_details.item_id = vw_items.item_id
		LEFT JOIN accounts ON transaction_details.account_id = accounts.account_id
		LEFT JOIN stores ON transaction_details.store_id = stores.store_id;

CREATE VIEW vw_day_ledgers AS
	SELECT currency.currency_id, currency.currency_name, departments.department_id, departments.department_name, 
		entitys.entity_id, entitys.entity_name, items.item_id, items.item_name,  orgs.org_id, orgs.org_name, 
		transaction_status.transaction_status_id, transaction_status.transaction_status_name, 
		transaction_types.transaction_type_id, transaction_types.transaction_type_name, 
		vw_bank_accounts.bank_id, vw_bank_accounts.bank_name, vw_bank_accounts.bank_branch_name, vw_bank_accounts.account_id as gl_bank_account_id, 
		vw_bank_accounts.bank_account_id, vw_bank_accounts.bank_account_name, vw_bank_accounts.bank_account_number, 
		stores.store_id, stores.store_name,

		day_ledgers.journal_id, day_ledgers.day_ledger_id, day_ledgers.exchange_rate, day_ledgers.day_ledger_date, 
		day_ledgers.day_ledger_quantity, day_ledgers.day_ledger_amount, day_ledgers.day_ledger_tax_amount, 
		day_ledgers.document_number, day_ledgers.payment_number, day_ledgers.order_number, 
		day_ledgers.payment_terms, day_ledgers.job, day_ledgers.application_date, day_ledgers.approve_status, 
		day_ledgers.workflow_table_id, day_ledgers.action_date, day_ledgers.narrative, day_ledgers.details

	FROM day_ledgers INNER JOIN currency ON day_ledgers.currency_id = currency.currency_id
		INNER JOIN departments ON day_ledgers.department_id = departments.department_id
		INNER JOIN entitys ON day_ledgers.entity_id = entitys.entity_id
		INNER JOIN items ON day_ledgers.item_id = items.item_id
		INNER JOIN orgs ON day_ledgers.org_id = orgs.org_id
		INNER JOIN transaction_status ON day_ledgers.transaction_status_id = transaction_status.transaction_status_id
		INNER JOIN transaction_types ON day_ledgers.transaction_type_id = transaction_types.transaction_type_id
		INNER JOIN vw_bank_accounts ON day_ledgers.bank_account_id = vw_bank_accounts.bank_account_id
		LEFT JOIN stores ON day_ledgers.store_id = stores.store_id;

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





