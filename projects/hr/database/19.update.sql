

DROP VIEW vw_employee_banking;
CREATE VIEW vw_employee_banking AS
	SELECT eml.employee_month_id, eml.period_id, eml.start_date, 
		eml.month_id, eml.period_year, eml.period_month,
		eml.entity_id, eml.entity_name, eml.employee_id,
		eml.pay_group_id, eml.bank_Header, eml.bank_address,
		vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, 
		vw_bank_branch.bank_branch_name, vw_bank_branch.bank_branch_code,
		currency.currency_id, currency.currency_name, currency.currency_symbol,
		
		employee_banking.org_id, employee_banking.employee_banking_id, employee_banking.amount, 
		employee_banking.exchange_rate, employee_banking.active, employee_banking.bank_account,
		employee_banking.narrative,
		(employee_banking.exchange_rate * employee_banking.amount) as base_amount
	FROM employee_banking INNER JOIN vw_employee_month as eml ON employee_banking.employee_month_id = eml.employee_month_id
		INNER JOIN vw_bank_branch ON employee_banking.bank_branch_id = vw_bank_branch.bank_branch_id
		INNER JOIN currency ON employee_banking.currency_id = currency.currency_id;

