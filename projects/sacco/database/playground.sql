
CREATE OR REPLACE FUNCTION get_shares( v_id integer,v_ deposit real, v_deposit real, ) RETURNS real AS $$
DECLARE
    shares real;
BEGIN
    SELECT sum(deposit_amount - contribution_amount) INTO shares
    FROM vw_contributions
    WHERE (contribution_id = v_id::integer);
    
RETURN shares;
END;
$$ LANGUAGE plpgsql;
