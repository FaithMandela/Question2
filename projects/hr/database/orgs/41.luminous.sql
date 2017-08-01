


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
		
		
		
		
---- Initialization data
DELETE FROM loan_types;
DELETE FROM default_adjustments;
DELETE FROM adjustments;

INSERT INTO adjustment_effects (adjustment_effect_id, adjustment_effect_name, adjustment_effect_code, adjustment_effect_type) 
VALUES 
(11, 'Leave Pay', 'LeavePay', 1),
(12, 'Director Fee', 'DirectorFee', 1),
(13, 'Commission Fee', 'CommFee', 1),
(14, 'Bonus', 'Bonus', 1),
(15, 'BpEtc', 'BpEtc', 1),
(16, 'Pay Retire', 'PayRetire', 1),
(17, 'SalTaxPaid', 'SalTaxPaid', 1),
(18, 'EduBen', 'EduBen', 1),
(19, 'GainShareOption', 'GainShareOption', 1),
(20, 'OtherRAP1', 'OtherRAP1', 1),
(21, 'OtherRAP2', 'OtherRAP2', 1),
(22, 'OtherRAP3', 'OtherRAP3', 1),
(23, 'Pension', 'Pension', 1);

INSERT INTO adjustments (org_id, adjustment_effect_id, adjustment_type, adjustment_Name, Visible, In_Tax, account_number) 
VALUES 
(0, 11, 1, 'Leave Pay', true, true, '90005'),
(0, 12, 1, 'Director Fee', true, true, '90005'),
(0, 12, 1, 'Commission Fee', true, true, '90005'),
(0, 13, 1, 'Bonus', true, true, '90005');




