
CREATE OR REPLACE FUNCTION pairkey(x int, y int) RETURNS int AS $$
	SELECT CASE WHEN x < y THEN x * (y - 1) + ((y - x - 2)^2)::int / 4
	ELSE (x - 1) * y + ((x - y - 2)^2)::int / 4 END
$$ LANGUAGE sql IMMUTABLE;


CREATE VIEW vw_fiscal_years AS
	SELECT orgs.org_id, orgs.currency_id, orgs.default_country_id, orgs.parent_org_id,
		orgs.org_name, orgs.org_full_name, orgs.org_sufix, orgs.is_default, orgs.is_active,
		orgs.logo, orgs.pin,
		fiscal_years.fiscal_year_id, fiscal_years.fiscal_year, fiscal_years.fiscal_year_start,
		fiscal_years.fiscal_year_end, fiscal_years.submission_date
		
	FROM orgs INNER JOIN fiscal_years ON orgs.org_id = fiscal_years.org_id;


CREATE VIEW vw_employee_year AS
	SELECT em.org_id, em.fiscal_year_id, em.entity_id, em.entity_name,
		em.employee_id, em.surname, em.first_name, em.middle_name, em.date_of_birth, 
		em.gender, em.nationality, em.marital_status, em.appointment_date, em.exit_date, 
		em.contract, em.contract_period, em.employment_terms, em.identity_card,
		em.employee_name, em.employee_full_name,
		em.currency_id, em.currency_name, em.currency_symbol, 
		
		pairkey(em.fiscal_year_id, em.entity_id) as employee_year_id,
		sum(net_pay) as y_net_pay
	
	FROM vw_employee_month em
	
	GROUP BY em.org_id, em.fiscal_year_id,
		em.entity_id, em.entity_name,
		em.employee_id, em.surname, em.first_name, em.middle_name, em.date_of_birth, 
		em.gender, em.nationality, em.marital_status, em.appointment_date, em.exit_date, 
		em.contract, em.contract_period, em.employment_terms, em.identity_card,
		em.employee_name, em.employee_full_name,
		em.currency_id, em.currency_name, em.currency_symbol;

CREATE VIEW vw_employee_effects AS
	SELECT adjustment_effects.adjustment_effect_id, adjustment_effects.adjustment_effect_name, 
		adjustment_effects.adjustment_effect_code, adjustment_effects.adjustment_effect_type,
		employees.org_id, employees.entity_id,
		fiscal_years.fiscal_year_id, fiscal_years.fiscal_year,
		(to_char(fiscal_years.fiscal_year_start, 'YYYYMMDD') || ' - ' || to_char(fiscal_year_end, 'YYYYMMDD')) as year_name,
		pairkey(fiscal_years.fiscal_year_id, employees.entity_id) as employee_year_id
	FROM (adjustment_effects CROSS JOIN employees)
		INNER JOIN fiscal_years ON employees.org_id = fiscal_years.org_id;


CREATE VIEW vw_adjustment_year AS
	SELECT ef.adjustment_effect_id, ef.adjustment_effect_name, 
		ef.adjustment_effect_code, ef.adjustment_effect_type,
		ef.org_id, ef.entity_id,
		ef.fiscal_year_id, ef.fiscal_year,
		ef.employee_year_id,
		COALESCE(eay.s_amount, 0) as s_amount, 
		COALESCE(eay.s_base_amount, 0) as t_base_amount,
		(CASE WHEN eay.s_amount is null THEN null ELSE ef.year_name END) as period_name
	FROM vw_employee_effects ef LEFT JOIN 
	(SELECT ea.adjustment_effect_id, ea.entity_id, ea.fiscal_year_id,
		pairkey(ea.fiscal_year_id, ea.entity_id) as employee_year_id,
		sum(ea.amount) as s_amount,
		sum(ea.base_amount) as s_base_amount
	FROM vw_employee_adjustments ea
		GROUP BY ea.adjustment_effect_id, ea.entity_id, ea.fiscal_year_id) eay
		
	ON (ef.adjustment_effect_id = eay.adjustment_effect_id) AND (ef.employee_year_id = eay.employee_year_id);


---- Initialization data
DELETE FROM loan_types;
DELETE FROM default_adjustments;
DELETE FROM adjustments;
DELETE FROM adjustment_effects WHERE adjustment_effect_id = 1;

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




