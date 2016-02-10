-- View: vw_vw_entitys_types_types

-- DROP VIEW vw_vw_entitys_types_types;

CREATE OR REPLACE VIEW vw_vw_entitys_types_types AS 
 SELECT vw_entitys_types.entity_id,
    vw_entitys_types.entity_name,
    vw_entitys_types.user_name,
    vw_entitys_types.super_user,
    vw_entitys_types.entity_leader,
    vw_entitys_types.date_enroled,
    vw_entitys_types.is_active,
    vw_entitys_types.entity_password,
    vw_entitys_types.first_password,
    vw_entitys_types.function_role,
    vw_entitys_types.attention,
    vw_entitys_types.primary_email,
    vw_entitys_types.org_id,
    vw_entitys_types.primary_telephone,
    entity_types.entity_type_id,
    entity_types.entity_type_name,
    entity_types.entity_role,
    entity_types.use_key
   FROM vw_entitys_types
     JOIN entity_types ON vw_entitys_types.entity_type_id = entity_types.entity_type_id;


