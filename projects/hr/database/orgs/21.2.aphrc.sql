

CREATE OR REPLACE FUNCTION ins_evaluation_points() RETURNS trigger AS $$
DECLARE
	v_rate_objectives			boolean;
BEGIN

	SELECT review_category.rate_objectives INTO v_rate_objectives
	FROM review_category INNER JOIN job_reviews ON review_category.review_category_id = job_reviews.review_category_id
	WHERE (job_reviews.job_review_id = NEW.job_review_id);

	IF(v_rate_objectives = false)THEN
		NEW.points := 0;
		NEW.reviewer_points := 0;
	END IF;

	IF(NEW.grade is not null)THEN
		IF(NEW.grade <> 'A') AND (NEW.grade <> 'S') AND (NEW.grade <> 'W') AND (NEW.grade <> 'NA') THEN
			RAISE EXCEPTION 'The grade must be A, S, W, NA';
		END IF;
	END IF;
	IF(NEW.reviewer_grade is not null)THEN
		IF(NEW.reviewer_grade <> 'A') AND (NEW.reviewer_grade <> 'S') AND (NEW.reviewer_grade <> 'W') AND (NEW.reviewer_grade <> 'NA') THEN
			RAISE EXCEPTION 'The grade must be A, S, W, NA';
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER ins_evaluation_points ON evaluation_points;

CREATE TRIGGER ins_evaluation_points BEFORE INSERT OR UPDATE ON evaluation_points
	FOR EACH ROW EXECUTE PROCEDURE ins_evaluation_points();


