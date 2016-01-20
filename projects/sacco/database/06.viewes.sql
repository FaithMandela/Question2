
--VIEWS
CREATE VIEW vw_gurrantors AS  
	SELECT loans.principle,loans.entity_id, loans.interest, loans.monthly_repayment,loans.loan_date,loans.initial_payment,
		loans.loan_id,get_repayment(loans.principle, loans.interest, loans.repayment_period) as repayment_amount, 
		loans.initial_payment + get_total_repayment(loans.loan_id) as total_repayment, get_total_interest(loans.loan_id) as total_interest,
		(loans.principle + get_total_interest(loans.loan_id) - loans.initial_payment - get_total_repayment(loans.loan_id)) as loan_balance,
		get_payment_period(loans.principle, loans.monthly_repayment, loans.interest) as calc_repayment_period,loans.reducing_balance, loans.repayment_period,loans.application_date,loans.approve_status,  loans.org_id,
		loans.workflow_table_id,loans.action_date,loans.details,
	
		entitys.entity_name,entitys.is_picked,
		loan_types.loan_type_id,loan_types.loan_type_name,loan_types.default_interest,gurrantors.gurrantor_id,
		gurrantors.is_accepted,gurrantors.amount,gurrantors_entity.entity_name as gurrantor_entity_name,
		gurrantors_entity.entity_id AS gurrantor_entity_id
	FROM loans
		JOIN entitys ON loans.entity_id = entitys.entity_id
		JOIN loan_types ON loans.loan_type_id = loan_types.loan_type_id
		JOIN orgs ON orgs.org_id = loans.org_id
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
	applicants.language,applicants.objective, applicants.interests,applicants.picture_file,applicants.details,  applicants.person_title,applicants.applicant_email,applicants.applicant_phone,
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

