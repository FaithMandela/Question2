


CREATE VIEW vw_fiscal_years AS
	SELECT orgs.org_id, orgs.currency_id, orgs.default_country_id, orgs.parent_org_id,
		orgs.org_name, orgs.org_full_name, orgs.org_sufix, orgs.is_default, orgs.is_active,
		orgs.logo, orgs.pin,
		fiscal_years.fiscal_year_id, fiscal_years.fiscal_year, fiscal_years.fiscal_year_start,
		fiscal_years.fiscal_year_end, fiscal_years.submission_date
		
	FROM orgs INNER JOIN fiscal_years ON orgs.org_id = fiscal_years.org_id;



CREATE VIEW vw_employee_year AS
	SELECT em.org_id, em.fiscal_year_id,
		em.entity_id, em.entity_name,
		em.employee_id, em.surname, em.first_name, em.middle_name, em.date_of_birth, 
		em.gender, em.nationality, em.marital_status, em.appointment_date, em.exit_date, 
		em.contract, em.contract_period, em.employment_terms, em.identity_card,
		em.employee_name, em.employee_full_name,
		em.currency_id, em.currency_name, em.currency_symbol, 
		
		sum(net_pay) as y_net_pay
	
	FROM vw_employee_month em
	
	GROUP BY em.org_id, em.fiscal_year_id,
		em.entity_id, em.entity_name,
		em.employee_id, em.surname, em.first_name, em.middle_name, em.date_of_birth, 
		em.gender, em.nationality, em.marital_status, em.appointment_date, em.exit_date, 
		em.contract, em.contract_period, em.employment_terms, em.identity_card,
		em.employee_name, em.employee_full_name,
		em.currency_id, em.currency_name, em.currency_symbol;