
CREATE OR REPLACE FUNCTION pairkey(x int, y int) RETURNS int AS $$
	SELECT CASE WHEN x < y THEN x * (y - 1) + ((y - x - 2)^2)::int / 4
	ELSE (x - 1) * y + ((x - y - 2)^2)::int / 4 END
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION get_year_allowance(int, int, int) RETURNS real AS $$
	SELECT COALESCE(sum(base_amount), 0)::real as s_base_amount
	FROM vw_employee_adjustments
	WHERE (entity_id = $1) AND (fiscal_year_id = $2) AND (adjustment_effect_id = $3);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_work_part_time(int, int) RETURNS boolean AS $$
	SELECT part_time
	FROM employee_month
	WHERE (employee_month_id IN 
		(SELECT max(employee_month_id) FROM vw_employee_month
		WHERE (entity_id = $1) AND (fiscal_year_id = $2)));
$$ LANGUAGE SQL;

ALTER TABLE orgs ADD designation varchar(50) default 'PARTNER';


CREATE VIEW vw_employee_year AS
	SELECT orgs.org_id, orgs.org_name, orgs.org_full_name, orgs.pin,
		em.fiscal_year_id, em.fiscal_year_start, em.fiscal_year_end, em.submission_date,
		em.entity_id, em.entity_name,
		em.employee_id, em.surname, em.first_name, em.middle_name, em.date_of_birth, 
		em.gender, em.nationality, em.marital_status, em.appointment_date, em.exit_date, 
		em.contract, em.contract_period, em.employment_terms, em.identity_card,
		em.employee_name, em.employee_full_name,
		em.currency_id, em.currency_name, em.currency_symbol, 
		get_work_part_time(em.entity_id, em.fiscal_year_id) as work_part_time,
		
		pairkey(em.fiscal_year_id, em.entity_id) as employee_year_id,
		(CASE WHEN em.marital_status = 'M' THEN '2' ELSE '1' END) as ms_code,
		get_spouse_name(em.entity_id) as spouse_name, get_spouse_id(em.entity_id) as spouse_id,
		(CASE WHEN em.identity_card is null THEN get_passport(em.entity_id) ELSE null END) as passport_num,
		ea.postal_code, (ea.premises || ', ' || ea.street) as residential_address,
		(CASE WHEN ea.premises is null THEN ea.post_office_box ELSE null END) as postal_address,
		max(em.department_role_name) as capacity,
		get_alternate_employment(em.entity_id) as alternate_employment,
		to_char(em.appointment_date, 'YYYYMMDD') as start_date_emp, to_char(em.exit_date, 'YYYYMMDD') as end_date_emp,
		(to_char(em.fiscal_year_start, 'YYYYMMDD') || ' - ' || to_char(em.fiscal_year_end, 'YYYYMMDD')) as period_of_salary,
		sum(em.basic_salary) as y_basic_salary, sum(em.gross_salary) as y_gross_salary, sum(em.net_pay) as y_net_pay
	
	FROM vw_employee_month em INNER JOIN orgs ON em.org_id = orgs.org_id
		LEFT JOIN vw_employee_address ea ON em.entity_id = ea.table_id
	
	GROUP BY orgs.org_id, orgs.org_name, orgs.org_full_name, orgs.pin,
		em.fiscal_year_id, em.fiscal_year_start, em.fiscal_year_end, em.submission_date,
		em.entity_id, em.entity_name,
		em.employee_id, em.surname, em.first_name, em.middle_name, em.date_of_birth, 
		em.gender, em.nationality, em.marital_status, em.appointment_date, em.exit_date, 
		em.contract, em.contract_period, em.employment_terms, em.identity_card,
		em.employee_name, em.employee_full_name,
		em.currency_id, em.currency_name, em.currency_symbol,
		ea.postal_code, ea.premises, ea.street, ea.post_office_box;

CREATE VIEW vw_fiscal_years AS
	SELECT orgs.org_id, orgs.currency_id, orgs.default_country_id, orgs.parent_org_id,
		orgs.org_name, orgs.org_full_name, orgs.org_sufix, orgs.is_default, orgs.is_active,
		orgs.logo, orgs.pin, orgs.designation,
		fiscal_years.fiscal_year_id, fiscal_years.fiscal_year, fiscal_years.fiscal_year_start,
		fiscal_years.fiscal_year_end, fiscal_years.submission_date,
		substr(orgs.pin, 1, 3) as section, substr(orgs.pin, 4, 8) as ern,
		to_char(fiscal_years.submission_date, 'YYYYMMDD') as sub_date,
		eyc.no_of_records, eyc.total_income
		
	FROM orgs INNER JOIN fiscal_years ON orgs.org_id = fiscal_years.org_id
		INNER JOIN (SELECT fiscal_year_id, org_id, count(entity_id) as no_of_records, sum(y_gross_salary) as total_income
		FROM vw_employee_year GROUP BY fiscal_year_id, org_id) eyc 
			ON (fiscal_years.fiscal_year_id = eyc.fiscal_year_id) AND (fiscal_years.org_id = eyc.org_id);

CREATE VIEW vw_employee_effects AS
	SELECT adjustment_effects.adjustment_effect_id, adjustment_effects.adjustment_effect_name, 
		adjustment_effects.adjustment_effect_code, adjustment_effects.adjustment_effect_type,
		employees.org_id, employees.entity_id,
		fiscal_years.fiscal_year_id, fiscal_years.fiscal_year,
		(to_char(fiscal_years.fiscal_year_start, 'YYYYMMDD') || ' - ' || to_char(fiscal_years.fiscal_year_end, 'YYYYMMDD')) as year_name,
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
DELETE FROM items;
DELETE FROM default_tax_types;
DELETE FROM tax_rates;
DELETE FROM tax_types WHERE use_key_id <> 15;
DELETE FROM loan_types;
DELETE FROM default_adjustments;
DELETE FROM adjustments;
DELETE FROM adjustment_effects WHERE adjustment_effect_id = 1;

INSERT INTO tax_types (org_id, currency_id, tax_type_id, use_key_id, tax_type_name, formural, tax_relief, tax_type_order, in_tax, linear, percentage, employer, employer_ps, active, account_number, employer_account) 
VALUES (0, 1, 1, 11, 'MPF', 'Get_Employee_Tax(employee_tax_type_id, 2)', 0, 1, false, true, true, 0, 100, true, '40045', '40045');

INSERT INTO tax_rates (org_id, tax_type_id, tax_range, tax_rate) VALUES (0, 1, 30000, 5);
INSERT INTO tax_rates (org_id, tax_type_id, tax_range, tax_rate) VALUES (0, 1, 10000000, 0);

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
(23, 'Pension', 'Pension', 1),
(24, 'Rent1', '1', 2),
(25, 'Rent2', '2', 2),
(26, 'Overseas', 'Oversea', 2);

INSERT INTO adjustments (org_id, currency_id, adjustment_effect_id, adjustment_type, adjustment_Name, Visible, In_Tax, account_number) 
VALUES 
(0, 1, 11, 1, 'Leave Pay', true, true, '90005'),
(0, 1, 12, 1, 'Director Fee', true, true, '90005'),
(0, 1, 12, 1, 'Commission Fee', true, true, '90005'),
(0, 1, 13, 1, 'Bonus', true, true, '90005');

DELETE FROM currency WHERE currency_id > 1;


----------------- Work

SELECT vw_employee_year.org_id, vw_employee_year.org_name, vw_employee_year.org_full_name, vw_employee_year.pin,
	vw_employee_year.fiscal_year_id, vw_employee_year.fiscal_year_start,
	vw_employee_year.fiscal_year_end, vw_employee_year.submission_date, vw_employee_year.entity_id,
	vw_employee_year.entity_name, vw_employee_year.employee_id, vw_employee_year.surname,
	vw_employee_year.first_name, vw_employee_year.middle_name, vw_employee_year.date_of_birth,
	vw_employee_year.gender, vw_employee_year.nationality, vw_employee_year.marital_status,
	vw_employee_year.appointment_date, vw_employee_year.exit_date, vw_employee_year.contract,
	vw_employee_year.contract_period, vw_employee_year.employment_terms, vw_employee_year.identity_card,
	vw_employee_year.employee_name, vw_employee_year.employee_full_name, vw_employee_year.currency_id,
	vw_employee_year.currency_name, vw_employee_year.currency_symbol, vw_employee_year.employee_year_id,
	vw_employee_year.ms_code, vw_employee_year.spouse_name, vw_employee_year.spouse_id,
	vw_employee_year.passport_num, vw_employee_year.postal_code, vw_employee_year.residential_address,
	vw_employee_year.postal_address, vw_employee_year.capacity, vw_employee_year.start_date_emp,
	vw_employee_year.end_date_emp, vw_employee_year.period_of_salary, vw_employee_year.y_basic_salary,
	vw_employee_year.y_gross_salary, vw_employee_year.y_net_pay,
	
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 11) as LeavePay,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 12) as DirectorFee,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 13) as CommFee,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 14) as Bonus,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 15) as BpEtc,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 16) as PayRetire,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 17) as SalTaxPaid,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 18) as EduBen,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 19) as GainShareOption,
	(get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 20) +
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 21) +
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 22)) as OtherRAP,
	get_year_allowance(vw_employee_year.entity_id, vw_employee_year.fiscal_year_id, 23) as Pension,
    
    
    vw_employee_year.alternate_employment,
    (CASE WHEN vw_employee_year.alternate_employment is null THEN '0' ELSE '1' END) as full_time,
    employment.employers_name, employment.position_held, employment.alternative_address, employment.alternative_salary
    

FROM vw_employee_year LEFT JOIN employment ON vw_employee_year.alternate_employment = employment.employment_id

	




