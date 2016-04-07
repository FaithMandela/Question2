CREATE OR REPLACE FUNCTION ins_contribs AS 
$$
DECLARE
	v_investment_amount			real;
	v_period_id					integer;
	v_merry_go_round_amount		real;
	v_money_in					real;
	v_money_out					real;

BEGIN

	SELECT  period_id, investment_amount, merry_go_round_amount, money_in, money_out INTO v_period_id, v_investment_amount, v_merry_go_round_amount, v_money_in, v_money_out
		FROM contributions
		WHERE paid = true AND period_id = NEW.period_id;
	
 sum(v_investment_amount) INTO v_money_in WHERE paid = true and period_id =  v_period_id; 

RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE TRIGGER ins_contribs BEFORE INSERT OR UPDATE ON contributions
   FOR EACH ROW EXECUTE PROCEDURE ins_contribs();





