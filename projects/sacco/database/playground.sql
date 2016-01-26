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