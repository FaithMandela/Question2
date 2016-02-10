
CREATE OR REPLACE FUNCTION job_review_check(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_self_rating		integer;
	v_objective_ps		real;
	sum_ods_ps			real;
	v_point_check		integer;
	rec					RECORD;
	msg 				varchar(120);
BEGIN
	
	SELECT sum(objectives.objective_ps) INTO v_objective_ps
	FROM objectives INNER JOIN evaluation_points ON evaluation_points.objective_id = objectives.objective_id
	WHERE (evaluation_points.job_review_id = CAST($1 as int));
	SELECT sum(ods_ps) INTO sum_ods_ps
	FROM objective_details INNER JOIN evaluation_points ON evaluation_points.objective_id = objective_details.objective_id
	WHERE (evaluation_points.job_review_id = CAST($1 as int));
	
	SELECT evaluation_points.evaluation_point_id INTO v_point_check
	FROM objectives INNER JOIN evaluation_points ON evaluation_points.objective_id = objectives.objective_id
	WHERE (evaluation_points.job_review_id = CAST($1 as int))
		AND (objectives.objective_ps > 0) AND (evaluation_points.points = 0);
		
	SELECT self_rating INTO v_self_rating
	FROM job_reviews
	WHERE (job_review_id = $1::int);
	IF(v_self_rating is null) THEN v_self_rating := 0; END IF;
	
	IF(sum_ods_ps is null)THEN
		sum_ods_ps := 100;
	END IF;
	IF(sum_ods_ps = 0)THEN
		sum_ods_ps := 100;
	END IF;

	IF(v_objective_ps = 100) AND (sum_ods_ps = 100)THEN
		UPDATE job_reviews SET approve_status = 'Completed'
		WHERE (job_review_id = CAST($1 as int));

		msg := 'Review Applied';
	ELSIF(sum_ods_ps <> 100)THEN
		msg := 'Objective details % must add up to 100';
		RAISE EXCEPTION '%', msg;
	ELSIF(v_self_rating = 0)THEN
		msg := 'Indicate your self rating';
		RAISE EXCEPTION '%', msg;
	ELSIF(v_point_check is not null)THEN
		msg := 'All objective evaluations points must be between 1 to 4';
		RAISE EXCEPTION '%', msg;
	ELSE
		msg := 'Objective % must add up to 100';
		RAISE EXCEPTION '%', msg;
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ins_loans() RETURNS trigger AS $$
DECLARE
	v_default_interest	real;
	v_reducing_balance	boolean;
BEGIN

	SELECT default_interest, reducing_balance INTO v_default_interest, v_reducing_balance
	FROM loan_types 
	WHERE (loan_type_id = NEW.loan_type_id);
	
	IF(NEW.interest is null)THEN
		NEW.interest := v_default_interest;
	END IF;
	IF (NEW.reducing_balance is null)THEN
		NEW.reducing_balance := v_reducing_balance;
	END IF;
	IF(NEW.monthly_repayment is null) THEN
		NEW.monthly_repayment := 0;
	END IF;
	IF (NEW.repayment_period is null)THEN
		NEW.repayment_period := 0;
	END IF;
	

	IF(NEW.principle is null)THEN
		RAISE EXCEPTION 'You have to enter a principle amount';
	ELSIF((NEW.monthly_repayment = 0) AND (NEW.repayment_period = 0))THEN
		RAISE EXCEPTION 'You have need to enter either monthly repayment amount or repayment period';
	ELSIF((NEW.monthly_repayment = 0) AND (NEW.repayment_period < 1))THEN
		RAISE EXCEPTION 'The repayment period should be greater than 0';
	ELSIF((NEW.repayment_period = 0) AND (NEW.monthly_repayment < 1))THEN
		RAISE EXCEPTION 'The monthly repayment should be greater than 0';
	ELSIF((NEW.monthly_repayment = 0) AND (NEW.repayment_period > 0))THEN
		NEW.monthly_repayment := NEW.principle / NEW.repayment_period;
	ELSIF((NEW.repayment_period = 0) AND (NEW.monthly_repayment > 0))THEN
		NEW.repayment_period := NEW.principle / NEW.monthly_repayment;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_loans BEFORE INSERT OR UPDATE ON loans
    FOR EACH ROW EXECUTE PROCEDURE ins_loans();


CREATE OR REPLACE FUNCTION loan_aplication(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	msg 				varchar(120);
BEGIN
	msg := 'Loan applied';
	
	UPDATE loans SET approve_status = 'Completed'
	WHERE (loan_id = CAST($1 as int)) AND (approve_status = 'Draft');

	return msg;
END;
$$ LANGUAGE plpgsql;
    

CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON loans
    FOR EACH ROW EXECUTE PROCEDURE upd_action();
    

    