
CREATE OR REPLACE FUNCTION ins_inv() RETURNS trigger AS 
$BODY$
DECLARE

v_monthly_returns		real;
v_total_returns 		real;

BEGIN
 SELECT monthly_returns, total_returns INTO v_monthly_returns, v_total_returns FROM investments 
 WHERE is_complete = false or is_complete = true;
  
  
IF (monthly_returns is not null) THEN
v_total_returns = v_monthly_returns + monthly_returns;
UPDATE investments SET total_returns = v_total_returns;

 END IF;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_inv AFTER INSERT OR UPDATE ON investments
   FOR EACH ROW EXECUTE PROCEDURE ins_inv();
