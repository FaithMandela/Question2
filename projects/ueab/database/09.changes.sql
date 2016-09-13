

UPDATE sublevels SET max_credits = 18;

CREATE OR REPLACE FUNCTION getoverload(real, float, float, float, boolean, float) RETURNS boolean AS $$
DECLARE
	myoverload boolean;
BEGIN
	myoverload := false;

	IF ($1=18) THEN
		IF (($3<1.99) AND ($2<>9)) THEN
			myoverload := true;
		ELSIF ($3 is null) AND ($2 > 18) THEN
			myoverload := true;
		ELSIF (($4>=110) AND ($3>=2.70) AND ($2<=21)) THEN
			myoverload := false;
		ELSE
			IF (($3<3) AND ($2>18)) THEN
				myoverload := true;
			ELSIF (($3<3.5) AND ($2>19)) THEN
				myoverload := true;
			ELSIF ($2>20) THEN
				myoverload := true;
			END IF;
		END IF;
	ELSE
		IF($2 > $1)THEN
			myoverload := true;
		END IF;
	END IF;

	IF (myoverload = true) THEN
		IF ($5 = true) AND ($2 <= $6) THEN
			myoverload := false;
		END IF;
	END IF;

    RETURN myoverload;
END;
$$ LANGUAGE plpgsql;

