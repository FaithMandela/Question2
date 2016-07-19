
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
     JOIN vw_loans ON vw_loans.loan_id = gurrantors.loan_id
     JOIN entitys ON vw_loans.entity_id = entitys.entity_id
     JOIN loan_types ON vw_loans.loan_type_id = loan_types.loan_type_id
     JOIN entitys gurrantors_entity ON gurrantors_entity.entity_id = gurrantors.entity_id;


CREATE OR REPLACE VIEW vw_contributions AS 
 SELECT contributions.contribution_id,
    contributions.org_id,
    contributions.entity_id,
    contributions.period_id,
    contributions.payment_type_id,
    contributions.deposit_amount,
    contributions.entry_date,
    contributions.transaction_ref,
    contributions.contribution_amount,
    entitys.entity_name,
    entitys.is_active,
    contribution_types.contribution_type_id,
    contribution_types.contribution_type_name,
    payment_types.payment_type_name,
    payment_types.payment_narrative,
    to_char(periods.start_date::timestamp with time zone, 'YYYY'::text) AS deposit_year,
    to_char(periods.start_date::timestamp with time zone, 'Month'::text) AS deposit_date
   FROM contributions
     JOIN entitys ON contributions.entity_id = entitys.entity_id
     JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
     JOIN payment_types ON payment_types.payment_type_id = contributions.payment_type_id
     JOIN periods ON contributions.period_id = periods.period_id;

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
		entity_types.entity_role, entity_types.use_key
	FROM (entitys LEFT JOIN vw_entity_address ON entitys.entity_id = vw_entity_address.table_id)
		INNER JOIN vw_orgs ON entitys.org_id = vw_orgs.org_id
		INNER JOIN entity_types ON entitys.entity_type_id = entity_types.entity_type_id;
	
CREATE OR REPLACE VIEW vw_entitys_types AS 
	SELECT	entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, 
		entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, 
		entitys.function_role, entitys.attention, entitys.primary_email, entitys.org_id,entitys.primary_telephone,
		  entitys.new_password,entitys.exit_amount,
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
	INNER JOIN loan_repayment ON loan_repayment.loan_id = vw_loans.loan_id;

--here	


CREATE OR REPLACE VIEW vw_recruiting_entity AS
		SELECT members.entity_id,members.surname,recruiting_agent_entity.entity_name AS recruiting_agent_entity_name,
			recruiting_agent.entity_id AS recruiting_agent_entity_id, recruiting_agent.recruiting_agent_id, 
			recruiting_agent.org_id
	FROM  members
	JOIN recruiting_agent on members.recruiting_agent_id = recruiting_agent.recruiting_agent_id
	left JOIN entitys recruiting_agent_entity ON recruiting_agent_entity.entity_id = recruiting_agent.entity_id;
		

	
CREATE OR REPLACE VIEW vw_contributions_month AS 
 SELECT vw_periods.period_id,
    vw_periods.start_date,
    vw_periods.end_date,
    vw_periods.overtime_rate,
    vw_periods.activated,
    vw_periods.closed,
    vw_periods.month_id,
    vw_periods.period_year,
    vw_periods.period_month,
    vw_periods.quarter,
    vw_periods.semister,
    vw_periods.bank_header,
    vw_periods.bank_address,
    vw_periods.is_posted,
     contributions.contribution_id,
    contributions.org_id,
    contributions.entity_id,
     contributions.payment_type_id,
    contributions.deposit_amount,
    contributions.entry_date,
    contributions.transaction_ref,
    contributions.contribution_amount,
    entitys.entity_name,
    entitys.is_active,
    contribution_types.contribution_type_id,
    contribution_types.contribution_type_name,
    payment_types.payment_type_name,
    payment_types.payment_narrative,
    to_char(vw_periods.start_date::timestamp with time zone, 'YYYY'::text) AS year,
    to_char(vw_periods.start_date::timestamp with time zone, 'Month'::text) AS deposit_date
   FROM contributions
     JOIN entitys ON contributions.entity_id = entitys.entity_id
     JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
     JOIN payment_types ON payment_types.payment_type_id = contributions.payment_type_id
     JOIN vw_periods ON contributions.period_id = vw_periods.period_id;

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
 --- here
     
CREATE OR REPLACE VIEW vw_billing AS
SELECT billing.bill_id,  billing.org_id, billing.currency_id, 
	billing.start_date, billing.end_date, billing.bill_amount, billing.processed, billing.paid,entitys.entity_id,
	entitys.entity_name, entitys.entity_leader, entitys.function_role,
	currency.currency_name, currency.currency_symbol
FROM currency 
	INNER JOIN billing ON currency.currency_id = billing.currency_id
	INNER JOIN entitys ON entitys.entity_id = billing.entity_id;

	
