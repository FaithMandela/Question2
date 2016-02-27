
--VIEWS
CREATE OR REPLACE VIEW vw_gurrantors AS 
 SELECT vw_loans.principle,
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
     INNER JOIN vw_loans ON vw_loans.loan_id = gurrantors.loan_id
     INNER JOIN entitys ON vw_loans.entity_id = entitys.entity_id
     INNER JOIN loan_types ON vw_loans.loan_type_id = loan_types.loan_type_id
     INNER JOIN entitys gurrantors_entity ON gurrantors_entity.entity_id = gurrantors.entity_id;
DROP VIEW vw_entitys;





--DROP VIEW vw_orgs  CASCADE;
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
		entity_types.entity_role, entity_types.use_key
	FROM (entitys LEFT JOIN vw_entity_address ON entitys.entity_id = vw_entity_address.table_id)
		INNER JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id;

		
CREATE OR REPLACE VIEW vw_entitys_types AS 
	SELECT	entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, 
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention, entitys.primary_email, entitys.org_id,entitys.primary_telephone,
		  entitys.new_password,entitys.exit_amount
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


CREATE OR REPLACE VIEW vw_investments AS 
 SELECT
	entitys.entity_id, entitys.entity_name,entitys.org_id,
    
	investments.investment_id,investments.investment_type_id , investments.maturity_date,investments.invest_amount ,investments.yearly_dividend,investments.withdrawal_date,investments.withdrwal_amount ,
	investments.period_years,investments.default_interest,investments.return_on_investment,investments.application_date,investments.approve_status, investments.workflow_table_id,
	investments.action_date,investments.details, investment_types.investment_type_name
   FROM  investments
     JOIN entitys ON entitys.entity_id = investments.entity_id
     JOIN investment_types on investments.investment_type_id = investment_types.investment_type_id;
     
CREATE OR REPLACE VIEW vw_trx AS
	SELECT vw_orgs.org_id, vw_orgs.org_name, vw_orgs.is_default as org_is_default, vw_orgs.is_active as org_is_active, 
		vw_orgs.logo as org_logo,vw_orgs.org_sys_country_id, vw_orgs.org_sys_country_name, 
		vw_orgs.org_address_id, vw_orgs.org_table_name,
		vw_orgs.org_post_office_box , vw_orgs.org_postal_code, 
		vw_orgs.org_street, vw_orgs.org_town, 
		vw_orgs.org_phone_number, vw_orgs.org_extension, 
		vw_orgs.org_mobile, vw_orgs.org_fax, vw_orgs. org_email, vw_orgs.org_website,
		vw_entitys.address_id, vw_entitys.address_name,
		vw_entitys.sys_country_id, vw_entitys.sys_country_name, vw_entitys.table_name, vw_entitys.is_default,
		vw_entitys.post_office_box, vw_entitys.postal_code, vw_entitys.premises, vw_entitys.street, vw_entitys.town, 
		vw_entitys.phone_number, vw_entitys.extension, vw_entitys.mobile, vw_entitys.fax, vw_entitys.email, vw_entitys.website,
		vw_entitys.entity_id, vw_entitys.entity_name, vw_entitys.User_name, vw_entitys.Super_User, 
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

		
		
		
	