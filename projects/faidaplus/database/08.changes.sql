CREATE OR REPLACE VIEW vw_bonus AS
 SELECT bonus.bonus_id,  bonus.consultant_id, bonus.period_id, bonus.entity_id, bonus.org_id, bonus.son,
    bonus.pcc, bonus.start_date, bonus.end_date, bonus.percentage, bonus.amount, bonus.is_active, bonus.approve_status,
    bonus.workflow_table_id, bonus.application_date, bonus.action_date, bonus.details,  orgs.org_name, orgs.account_manager_id
   FROM bonus
     JOIN orgs ON orgs.org_id = bonus.org_id;
