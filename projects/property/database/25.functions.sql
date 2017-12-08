---FUNCTION to generate_rentals
CREATE OR REPLACE FUNCTION generate_rentals(varchar(12), varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_org_id			integer;
	v_period_id			integer;
	v_total_rent		float;
	myrec				RECORD;
	msg					varchar(120);
BEGIN
	IF ($3 = '1') THEN
	SELECT period_id INTO v_period_id FROM period_rentals WHERE period_id = $1::int AND rental_id = rental_id;
		IF(v_period_id is NULL) THEN
			INSERT INTO period_rentals (period_id, org_id, entity_id, property_id, rental_id, rental_amount, service_fees, commision, commision_pct, sys_audit_trail_id)
			SELECT $1::int, org_id, entity_id, property_id,rental_id, rental_value, service_fees, commision_value, commision_pct, $5::int
				FROM rentals 
				WHERE is_active = true;
			msg := 'Rentals generated';
		ELSE 
			msg := 'Rentals exists';
		END IF;		
	END IF;
	return msg;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ins_units() RETURNS trigger AS $$
BEGIN

	IF((NEW.commision_value = 0) AND (NEW.commision_pct > 0))THEN
		NEW.commision_value := NEW.rental_value * NEW.commision_pct / 100;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_units BEFORE INSERT OR UPDATE ON units
    FOR EACH ROW EXECUTE PROCEDURE ins_units();


CREATE OR REPLACE FUNCTION ins_rentals() RETURNS trigger AS $$
DECLARE
	rec					RECORD;
BEGIN
	SELECT rental_value, service_fees, commision_value, commision_pct INTO rec
	FROM units
	WHERE unit_id = NEW.unit_id;

	IF(NEW.rental_value is null)THEN
		NEW.rental_value := rec.rental_value;
	END IF;
	IF(NEW.service_fees is null)THEN
		NEW.service_fees := rec.service_fees;
	END IF;
	IF((NEW.commision_value is null) AND (NEW.commision_pct is null))THEN
		NEW.commision_value := rec.commision_value;
		NEW.commision_pct := rec.commision_pct;
	END IF;
	
	IF(NEW.commision_value is null)THEN NEW.commision_value := 0; END IF;
	IF(NEW.commision_pct is null)THEN NEW.commision_pct := 0; END IF;
	
	IF((NEW.commision_value = 0) AND (NEW.commision_pct > 0))THEN
		NEW.commision_value := NEW.rental_value * NEW.commision_pct / 100;
	END IF;

	UPDATE units SET is_vacant = false WHERE unit_id = NEW.unit_id;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_rentals BEFORE INSERT OR UPDATE ON rentals
    FOR EACH ROW EXECUTE PROCEDURE ins_rentals();


CREATE OR REPLACE FUNCTION ins_period_rentals() RETURNS trigger AS $$
DECLARE
	rec					RECORD;
BEGIN
	SELECT rental_value, service_fees, commision_value, commision_pct INTO rec
	FROM rentals
	WHERE rental_id = NEW.rental_id;

	IF(NEW.rental_amount is null)THEN
		NEW.rental_amount := rec.rental_value;
	END IF;
	IF(NEW.service_fees is null)THEN
		NEW.service_fees := rec.service_fees;
	END IF;
	IF((NEW.commision is null) AND (NEW.commision_pct is null))THEN
		NEW.commision := rec.commision_value;
		NEW.commision_pct := rec.commision_pct;
	END IF;
	
	IF(NEW.commision is null)THEN NEW.commision := 0; END IF;
	IF(NEW.commision_pct is null)THEN NEW.commision_pct := 0; END IF;
	
	IF((NEW.commision = 0) AND (NEW.commision_pct > 0))THEN
		NEW.commision := NEW.rental_amount * NEW.commision_pct / 100;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_period_rentals BEFORE INSERT OR UPDATE ON period_rentals
    FOR EACH ROW EXECUTE PROCEDURE ins_period_rentals();
    
CREATE OR REPLACE FUNCTION aud_period_rentals() RETURNS trigger AS $$
BEGIN

	INSERT INTO log_period_rentals (period_rental_id, rental_id, period_id, 
		sys_audit_trail_id, org_id, rental_amount, service_fees,
		repair_amount, status, commision, commision_pct, narrative)
	VALUES (OLD.period_rental_id, OLD.rental_id, OLD.period_id, 
		OLD.sys_audit_trail_id, OLD.org_id, OLD.rental_amount, OLD.service_fees,
		OLD.repair_amount, OLD.status, OLD.commision, OLD.commision_pct, OLD.narrative);

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aud_period_rentals AFTER UPDATE OR DELETE ON period_rentals
    FOR EACH ROW EXECUTE PROCEDURE aud_period_rentals();
	

CREATE OR REPLACE FUNCTION get_total_remit(float) RETURNS float AS $$
    SELECT COALESCE(SUM(rent_to_remit), 0)::float 
	FROM vw_period_rentals
	WHERE (is_active = true) AND (period_id = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_periodic_remmit(float) RETURNS float AS $$
  SELECT sum(period_rentals.rental_amount + period_rentals.commision)::float
	FROM vw_property 
		INNER JOIN period_rentals ON period_rentals.property_id = vw_property.property_id
			GROUP BY vw_property.property_id,period_rentals.period_id
$$ LANGUAGE SQL;

---DROP FUNCTION post_period_rentals(character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION post_period_rentals(varchar(12), varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
	DECLARE
		v_org_id			integer;
		v_use_key_id		integer;
		v_currency_id		integer;
		v_client_id			integer;
		v_status			varchar(50);
		v_total_rent		float;
		v_total_remmit		float;
		myrec				RECORD;
		msg					varchar(120);
	BEGIN
		IF ($3::int = 2) THEN
			SELECT status INTO v_status FROM period_rentals WHERE period_rental_id = $1::int;
			IF (v_status = 'Draft') THEN
				SELECT currency_id INTO v_currency_id FROM orgs WHERE is_active = true;

				FOR myrec IN SELECT org_id,entity_id,property_id,rental_id,period_id,rental_amount,service_fees,
				repair_amount,commision,commision_pct,status,narrative,sys_audit_trail_id FROM period_rentals
				WHERE status = 'Draft' AND period_rental_id = $1::int

				LOOP

					SELECT use_key_id INTO v_use_key_id FROM entitys WHERE is_active = true AND entity_id = myrec.entity_id;
					
					--SELECT client_id INTO v_client_id FROM vw_period_rentals  WHERE vw_period_rentals.rental_id = myrec.rental_id;
					
					v_total_rent = myrec.rental_amount+myrec.service_fees+myrec.repair_amount;
					v_total_remmit= myrec.rental_amount-myrec.commision;

					---Debit all tenants rental accounts
						INSERT INTO payments (payment_type_id,org_id,entity_id,property_id,rental_id,period_id,currency_id,tx_type,account_credit,account_debit,activity_name)
						VALUES(5,myrec.org_id,myrec.entity_id,myrec.property_id,myrec.rental_id,myrec.period_id,v_currency_id,1,0,v_total_rent::float,'Rental Billing');

					---Credit all Clients Property accounts
						INSERT INTO payments (payment_type_id,org_id,property_id,period_id,currency_id,tx_type,account_credit,account_debit,activity_name)
						VALUES(5,myrec.org_id,myrec.property_id,myrec.period_id,v_currency_id,-1,v_total_remmit::float,0,'Property Billing');				
						
					UPDATE period_rentals SET status = 'Posted' WHERE period_rental_id = $1::int;
				END LOOP;
					msg := 'Period Rental Posted';
			ELSE
				msg := 'Period Rental Already Posted';
			END IF;
		END IF;
		return msg;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION un_archive (varchar(12), varchar(12), varchar(12),varchar(12)) RETURNS varchar(120) AS $$
	DECLARE
		msg				varchar(120);
	BEGIN
		IF($3::integer = 1)THEN
			UPDATE entitys SET is_active = true WHERE entity_id = $1::int;
		msg := 'Activated';
		END IF;

		IF($3::integer = 2)THEN
			UPDATE property SET is_active = true WHERE property_id = $1::int;
		msg := 'Activated';
		END IF;
		
RETURN msg;
END;
$$ LANGUAGE plpgsql;


---associative functions
CREATE OR REPLACE FUNCTION payment_number() 
  RETURNS trigger AS $$
DECLARE
	rnd 			integer;
	receipt_no  	varchar(12);
BEGIN
	receipt_no := trunc(random()*1000);
	rnd := trunc(65+random()*25);
	receipt_no := receipt_no || chr(rnd);
	receipt_no := receipt_no || trunc(random()*1000);
	rnd := trunc(65+random()*25);
	receipt_no := receipt_no || chr(rnd);
	rnd := trunc(65+random()*25);
	receipt_no := receipt_no || chr(rnd);

	NEW.payment_number:=receipt_no;
	---RAISE EXCEPTION '%',receipt_no;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

 CREATE TRIGGER payment_number BEFORE INSERT ON payments
 FOR EACH ROW
 EXECUTE PROCEDURE payment_number();

CREATE OR REPLACE FUNCTION ins_payments() RETURNS trigger AS $$
DECLARE
	rec					RECORD;
BEGIN
	
	IF(NEW.payment_id is not null AND NEW.tx_type = 1)THEN
		SELECT sum(account_credit - account_debit) INTO NEW.balance
		FROM payments
		WHERE (payment_id < NEW.payment_id) AND (rental_id = NEW.rental_id);
	ELSIF(NEW.payment_id is not null AND NEW.tx_type = -1)THEN
		SELECT sum(account_debit - account_credit) INTO NEW.balance
		FROM payments
		WHERE (payment_id < NEW.payment_id) AND (entity_id = NEW.entity_id);
	END IF;

	IF(NEW.balance is null)THEN
		NEW.balance := 0;
	END IF;

	IF(NEW.payment_id is not null AND NEW.tx_type = 1)THEN
		NEW.balance := NEW.balance + (NEW.account_credit - NEW.account_debit);
	ELSIF (NEW.payment_id is not null AND NEW.tx_type = -1)THEN
		NEW.balance := NEW.balance + (NEW.account_debit - NEW.account_credit);
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_payments BEFORE INSERT OR UPDATE ON payments
    FOR EACH ROW EXECUTE PROCEDURE ins_payments();


-- CREATE OR REPLACE FUNCTION get_total_remit(integer) RETURNS integer AS $$
--     SELECT COALESCE(sum(rental_amount), 0)::integer
-- 	FROM period_rentals
-- 	WHERE (status='Draft') AND (property_id = $1);
-- $$ LANGUAGE SQL;




