CREATE FUNCTION get_benefit_section_a(integer) RETURNS text AS $$
    SELECT individual AS result from vw_benefits WHERE rate_type_id = $1 AND benefit_section IN('1A');
$$LANGUAGE SQL;
CREATE FUNCTION get_benefit_section_b(integer) RETURNS text AS $$
    SELECT individual AS result from vw_benefits WHERE rate_type_id = $1 AND benefit_section IN('1B');
$$LANGUAGE SQL;
