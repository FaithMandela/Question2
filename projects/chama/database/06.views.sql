
CREATE OR REPLACE VIEW vw_members AS
	SELECT 	bank_branch.bank_branch_id, bank_branch.bank_branch_name, 
	banks.bank_id, banks.bank_name, 
	currency.currency_id, currency.currency_name, 
	entitys.entity_id, entitys.entity_name, 
	locations.location_id, locations.location_name,
	sys_countrys.sys_country_id, sys_countrys.sys_country_name, 
	members.org_id, members.member_id, members.person_title, members.surname, members.first_name, members.middle_name, members.full_name, members.id_number, members.email, members.date_of_birth, members.gender, members.phone, members.bank_account_number, members.nationality, members.nation_of_birth, members.marital_status, members.joining_date, members.exit_date, members.picture_file, members.active, members.details, members.merry_go_round_number
	FROM members
	JOIN bank_branch ON members.bank_branch_id = bank_branch.bank_branch_id
	JOIN banks ON members.bank_id = banks.bank_id
	JOIN currency ON members.currency_id = currency.currency_id
	JOIN entitys ON members.entity_id = entitys.entity_id
	JOIN locations ON members.location_id = locations.location_id
	JOIN sys_countrys ON members.nationality = sys_countrys.sys_country_id;

	
CREATE OR REPLACE VIEW vw_expenses AS
	SELECT bank_accounts.bank_account_id, bank_accounts.bank_account_name, currency.currency_id,
	currency.currency_name, entitys.entity_id, entitys.entity_name, expenses.org_id,  expenses.expense_id, expenses.date_accrued, 
	expenses.amount, expenses.details
	FROM expenses
	JOIN bank_accounts ON expenses.bank_account_id = bank_accounts.bank_account_id
	JOIN currency ON expenses.currency_id = currency.currency_id
	JOIN entitys ON expenses.entity_id = entitys.entity_id
	
CREATE OR REPLACE VIEW vw_contribution_defaults AS
	SELECT contribution_types.contribution_type_id, contribution_types.contribution_type_name, entitys.entity_id, entitys.entity_name, contribution_defaults.org_id, contribution_defaults.contribution_default_id, contribution_defaults.investment_amount, contribution_defaults.merry_go_round_amount, contribution_defaults.details
	FROM contribution_defaults
	left JOIN contribution_types ON contribution_defaults.contribution_type_id = contribution_types.contribution_type_id
	JOIN entitys ON contribution_defaults.entity_id = entitys.entity_id;

CREATE OR REPLACE VIEW vw_contribution_types AS
	SELECT contribution_types.org_id, contribution_types.contribution_type_id, contribution_types.contribution_type_name, contribution_types.investment_amount, contribution_types.merry_go_round_amount, contribution_types.frequency, contribution_types.applies_to_all, contribution_types.details
	FROM contribution_types;
	

CREATE OR REPLACE VIEW vw_contributions AS 
 SELECT bank_accounts.bank_account_id,
    bank_accounts.bank_account_name,
    contribution_types.contribution_type_id,
    contribution_types.contribution_type_name,
    entitys.entity_id,
    entitys.entity_name,
    members.member_id,
    members.middle_name,
    contributions.org_id,
    contributions.period_id,
    contributions.meeting_id,
    contributions.contribution_id,
    contributions.contribution_date,
    contributions.investment_amount,
    contributions.merry_go_round_amount,
    contributions.paid,
    contributions.money_in,
    contributions.money_out,
    contributions.details
   FROM contributions
     JOIN contribution_types ON contributions.contribution_type_id = contribution_types.contribution_type_id
     JOIN entitys ON contributions.entity_id = entitys.entity_id
     JOIN members ON contributions.member_id = members.member_id
     LEFT JOIN bank_accounts ON contributions.bank_account_id = bank_accounts.bank_account_id;



CREATE OR REPLACE VIEW vw_member_contrib AS
		SELECT vw_contributions.bank_account_id, vw_contributions.bank_account_name, 
		vw_contributions.contribution_type_id, vw_contributions.contribution_type_name,
		vw_members.entity_id, vw_members.entity_name, vw_members.member_id, vw_members.merry_go_round_number,
		vw_contributions.org_id, vw_contributions.period_id, vw_contributions.meeting_id,
    vw_contributions.contribution_id, vw_contributions.contribution_date, vw_contributions.investment_amount, vw_contributions.merry_go_round_amount, vw_contributions.paid, vw_contributions.money_in, vw_contributions.money_out

		FROM vw_contributions
		 JOIN vw_members  ON  vw_contributions.entity_id = vw_members.entity_id;

     
CREATE VIEW vw_investment_types AS
	SELECT orgs.org_id, orgs.org_name, investment_types.investment_type_id, investment_types.investment_type_name, investment_types.details
	FROM investment_types
	INNER JOIN orgs ON investment_types.org_id = orgs.org_id;


CREATE OR REPLACE VIEW vw_investments AS 
 SELECT currency.currency_id,
    currency.currency_name,
    investment_types.investment_type_id,
    investment_types.investment_type_name,
    bank_accounts.bank_account_id,
    bank_accounts.bank_account_name,
    investments.org_id,
    investments.period_id,
    investments.investment_id,
    investments.investment_name,
    investments.date_of_accrual,
    investments.total_cost,
    investments.status,
     investments.total_repayment_amount,
    investments.repayment_period,
    investments.monthly_returns,
    investments.monthly_payments,
    investments.total_payment,
    investments.default_interest,
    investments.total_returns,
    investments.is_complete,
    investments.is_active,
    investments.details
   FROM investments
     JOIN currency ON investments.currency_id = currency.currency_id
     JOIN investment_types ON investments.investment_type_id = investment_types.investment_type_id
     LEFT JOIN bank_accounts ON investments.bank_account_id = bank_accounts.bank_account_id;
     
CREATE OR REPLACE VIEW vw_meetings AS 
	SELECT meetings.org_id, meetings.meeting_id, meetings.meeting_date, meetings.amount_contributed, 
	meetings.meeting_place, meetings.minutes, meetings.status, meetings.details
	FROM meetings;


CREATE OR REPLACE VIEW vw_penalty AS
	SELECT  entitys.entity_id, 
	entitys.entity_name, penalty.org_id, penalty_type.penalty_type_id, penalty_type.penalty_type_name,
	bank_accounts.bank_account_id, penalty.penalty_id, penalty.date_of_accrual, penalty.amount, penalty.paid, 
	 penalty.action_date, penalty.is_active, penalty.details
	FROM penalty
	JOIN entitys ON penalty.entity_id = entitys.entity_id
	JOIN penalty_type ON penalty.penalty_type_id = penalty_type.penalty_type_id
	LEFT JOIN bank_accounts ON penalty.bank_account_id = bank_accounts.bank_account_id;

CREATE VIEW vw_penalty_type AS
	SELECT orgs.org_id, orgs.org_name, penalty_type.penalty_type_id, penalty_type.penalty_type_name, penalty_type.details
	FROM penalty_type
	JOIN orgs ON penalty_type.org_id = orgs.org_id;
	
CREATE OR REPLACE VIEW vw_member_meeting AS
	SELECT members.member_id, members.surname, members.first_name,
			meetings.meeting_id, meetings.meeting_date,
			member_meeting.org_id ,member_meeting.member_meeting_id, member_meeting.narrative
	FROM member_meeting
		JOIN members ON member_meeting.member_id = members.member_id
		JOIN meetings ON member_meeting.meeting_id = meetings.meeting_id;
