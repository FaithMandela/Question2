
CREATE VIEW vw_borrowing AS
	SELECT accounts.account_id, accounts.account_name, borrowing_types.borrowing_type_id, borrowing_types.borrowing_type_name, currency.currency_id, currency.currency_name, orgs.org_id, orgs.org_name, borrowing.borrowing_id, borrowing.date_of_borrowing, borrowing.amount, borrowing.interest, borrowing.application_date, borrowing.approve_status, borrowing.workflow_table_id, borrowing.action_date, borrowing.is_active, borrowing.details
	FROM borrowing
	INNER JOIN accounts ON borrowing.account_id = accounts.account_id
	INNER JOIN borrowing_types ON borrowing.borrowing_type_id = borrowing_types.borrowing_type_id
	INNER JOIN currency ON borrowing.currency_id = currency.currency_id
	INNER JOIN orgs ON borrowing.org_id = orgs.org_id;


CREATE VIEW vw_borrowing_repayment AS
	SELECT borrowing.borrowing_id, orgs.org_id, orgs.org_name, penalty.penalty_id, periods.period_id, borrowing_repayment.borrowing_repayment_id, borrowing_repayment.amount, borrowing_repayment.action_date, borrowing_repayment.details
	FROM borrowing_repayment
	INNER JOIN borrowing ON borrowing_repayment.borrowing_id = borrowing.borrowing_id
	INNER JOIN orgs ON borrowing_repayment.org_id = orgs.org_id
	INNER JOIN penalty ON borrowing_repayment.penalty_id = penalty.penalty_id
	INNER JOIN periods ON borrowing_repayment.period_id = periods.period_id;
	
CREATE VIEW vw_borrowing_types AS
	SELECT orgs.org_id, orgs.org_name, borrowing_types.borrowing_type_id, borrowing_types.borrowing_type_name, borrowing_types.details
	FROM borrowing_types
	INNER JOIN orgs ON borrowing_types.org_id = orgs.org_id;

CREATE VIEW vw_contribution_types AS
	SELECT orgs.org_id, orgs.org_name, contribution_types.contribution_type_id, contribution_types.contribution_type_name, contribution_types.merry_go_round, contribution_types.details
	FROM contribution_types
	INNER JOIN orgs ON contribution_types.org_id = orgs.org_id;


CREATE OR REPLACE VIEW vw_contributions AS 
 SELECT 
    contribution_types.contribution_type_id,
    contribution_types.contribution_type_name,
    entitys.entity_id,
    entitys.entity_name,
    contributions.org_id,
     contributions.period_id,
    contributions.meeting_id,
    contributions.contribution_id,
    contributions.contribution_amount,
    contributions.banking_details,
    contributions.details,
    contributions.actual_amount,contributions.merry_go_round_percentage
   FROM contributions
        JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
     JOIN entitys ON contributions.entity_id = entitys.entity_id





CREATE VIEW vw_investment_types AS
	SELECT orgs.org_id, orgs.org_name, investment_types.investment_type_id, investment_types.investment_type_name, investment_types.details
	FROM investment_types
	INNER JOIN orgs ON investment_types.org_id = orgs.org_id;

CREATE VIEW vw_investments AS
	SELECT accounts.account_id, accounts.account_name, currency.currency_id, currency.currency_name, investment_types.investment_type_id, investment_types.investment_type_name, orgs.org_id, orgs.org_name, investments.investment_id, investments.date_of_accrual, investments.amount, investments.status, investments.workflow_table_id, investments.action_date, investments.is_active, investments.details
	FROM investments
	INNER JOIN accounts ON investments.account_id = accounts.account_id
	INNER JOIN currency ON investments.currency_id = currency.currency_id
	INNER JOIN investment_types ON investments.investment_type_id = investment_types.investment_type_id
	INNER JOIN orgs ON investments.org_id = orgs.org_id;

CREATE VIEW vw_meetings AS
	SELECT orgs.org_id, orgs.org_name, meetings.meeting_id, meetings.meeting_date, meetings.amount_contributed, meetings.meeting_place, meetings.minutes, meetings.status, meetings.details
	FROM meetings
	INNER JOIN orgs ON meetings.org_id = orgs.org_id;
	
CREATE VIEW vw_penalty AS
	SELECT accounts.account_id, accounts.account_name, currency.currency_id, currency.currency_name, entitys.entity_id, entitys.entity_name, orgs.org_id, orgs.org_name, penalty_type.penalty_type_id, penalty_type.penalty_type_name, penalty.penalty_id, penalty.date_of_accrual, penalty.amount, penalty.status, penalty.workflow_table_id, penalty.action_date, penalty.is_active, penalty.details
	FROM penalty
	INNER JOIN accounts ON penalty.account_id = accounts.account_id
	INNER JOIN currency ON penalty.currency_id = currency.currency_id
	INNER JOIN entitys ON penalty.entity_id = entitys.entity_id
	INNER JOIN orgs ON penalty.org_id = orgs.org_id
	INNER JOIN penalty_type ON penalty.penalty_type_id = penalty_type.penalty_type_id;

CREATE VIEW vw_penalty_type AS
	SELECT orgs.org_id, orgs.org_name, penalty_type.penalty_type_id, penalty_type.penalty_type_name, penalty_type.details
	FROM penalty_type
	INNER JOIN orgs ON penalty_type.org_id = orgs.org_id;
