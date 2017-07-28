DROP TABLE payments CASCADE;
DROP TABLE payment_types CASCADE;

CREATE TABLE payment_types (
	payment_type_id			serial primary key,
	account_id				integer not null references accounts,
	use_key_id				integer not null references use_keys,
	org_id					integer references orgs,
	payment_type_name		varchar(120) not null,
	is_active				boolean default true not null,
	details					text,
	UNIQUE(org_id, payment_type_name)
);
CREATE INDEX payment_types_account_id ON payment_types(account_id);
CREATE INDEX payment_types_use_key_id ON payment_types(use_key_id);
CREATE INDEX payment_types_org_id ON payment_types(org_id);

CREATE TABLE payments (
	payment_id				serial primary key,

	payment_type_id			integer references payment_types,
	currency_id				integer references currency,

	period_id				integer references periods,
	entity_id 				integer references entitys,
	property_id				integer references property,
	rental_id				integer references rentals,

	org_id					integer references orgs,
	journal_id				integer references journals,
	sys_audit_trail_id		integer references sys_audit_trail,

	payment_number			varchar(50),
	payment_date			date default current_date not null,
	tx_type					integer default 1 not null,

	account_credit			real default 0 not null,
	account_debit			real default 0 not null,
	balance					real not null,

	exchange_rate			real default 1 not null,
	activity_name 			varchar(50),
	action_date				timestamp,	
	
	details					text
);
CREATE INDEX payments_payment_type_id ON payments(payment_type_id);
CREATE INDEX payments_currency_id ON payments(currency_id);
CREATE INDEX payments_period_id ON payments(period_id);
CREATE INDEX payments_entity_id ON payments(entity_id);
CREATE INDEX payments_property_id ON payments(property_id);
CREATE INDEX payments_rental_id ON payments(rental_id);
CREATE INDEX payments_journal_id ON payments(journal_id);
CREATE INDEX payments_sys_audit_trail_id ON payments(sys_audit_trail_id);
CREATE INDEX payments_org_id ON payments(org_id);

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


CREATE VIEW vw_tenant_payments AS
SELECT payment_types.account_id, payment_types.use_key_id, payment_types.payment_type_name, payment_types.is_active,
	
	payments.payment_id,payments.payment_type_id, payments.currency_id, payments.period_id, payments.entity_id, 
	payments.property_id,payments.rental_id, payments.org_id, payments.journal_id, payments.payment_number, 
	payments.payment_date, payments.tx_type,payments.account_credit, payments.account_debit, payments.balance, 
	payments.exchange_rate, payments.activity_name, payments.action_date,

	currency.currency_name, currency.currency_symbol,

	vw_rentals.property_type_name, vw_rentals.property_name, 
	vw_rentals.estate,vw_rentals.tenant_name,vw_rentals.hse_no,vw_rentals.rental_value,
	
	vw_periods.period_disp, vw_periods.period_month
	
		FROM payments
		INNER JOIN currency ON currency.currency_id = payments.currency_id
		INNER JOIN payment_types ON payment_types.payment_type_id = payments.payment_type_id
		INNER JOIN vw_rentals ON vw_rentals.rental_id = payments.rental_id
		INNER JOIN vw_periods ON vw_periods.period_id = payments.period_id
		WHERE tx_type=1; 


CREATE VIEW vw_client_bill AS
		SELECT payment_types.account_id, payment_types.use_key_id, payment_types.payment_type_name, payment_types.is_active,
		
		payments.payment_id,payments.payment_type_id, payments.currency_id, payments.period_id, payments.entity_id, 
		payments.rental_id, payments.org_id, payments.journal_id, payments.payment_number, 
		payments.payment_date, payments.tx_type,payments.account_credit, payments.account_debit, payments.balance, 
		payments.exchange_rate, payments.activity_name, payments.action_date,

		currency.currency_name, currency.currency_symbol,

		vw_property.client_id, vw_property.client_name,vw_property.property_type_id,vw_property.property_type_name,vw_property.property_id,
		vw_property.property_name,vw_property.estate,vw_property.plot_no,vw_property.units,

		vw_periods.period_disp, vw_periods.period_month
		
			FROM payments
			INNER JOIN currency ON currency.currency_id = payments.currency_id
			INNER JOIN vw_periods ON vw_periods.period_id = payments.period_id
			INNER JOIN payment_types ON payment_types.payment_type_id = payments.payment_type_id
			INNER JOIN vw_property ON vw_property.client_id = payments.entity_id
			WHERE tx_type=-1;

CREATE OR REPLACE FUNCTION amount_in_words(n BIGINT) RETURNS TEXT AS
	$$
	DECLARE
 		 e TEXT;
	BEGIN

 	 WITH Below20(Word, Id) AS
 	 (
  	  VALUES
     	 ('Zero', 0), ('One', 1),( 'Two', 2 ), ( 'Three', 3), ( 'Four', 4 ), ( 'Five', 5 ), ( 'Six', 6 ), ( 'Seven', 7 ),
    	  ( 'Eight', 8), ( 'Nine', 9), ( 'Ten', 10), ( 'Eleven', 11 ),( 'Twelve', 12 ), ( 'Thirteen', 13 ), ( 'Fourteen', 14),
    	  ( 'Fifteen', 15 ), ('Sixteen', 16 ), ( 'Seventeen', 17),
    	  ('Eighteen', 18 ), ( 'Nineteen', 19 )
  	 ),
  		 Below100(Word, Id) AS
  	 (
     	 VALUES
      	 ('Twenty', 2), ('Thirty', 3),('Forty', 4), ('Fifty', 5),
      	 ('Sixty', 6), ('Seventy', 7), ('Eighty', 8), ('Ninety', 9)
  	 )
  		 SELECT
     		CASE
    		  WHEN n = 0 THEN  ''
     		 WHEN n BETWEEN 1 AND 19
       			 THEN (SELECT Word FROM Below20 WHERE ID=n)
    		 WHEN n BETWEEN 20 AND 99
     			  THEN  (SELECT Word FROM Below100 WHERE ID=n/10) ||  '-'  ||
           		  amount_in_words( n % 10)
    		 WHEN n BETWEEN 100 AND 999
      			 THEN  (amount_in_words( n / 100)) || ' Hundred ' ||
          		 amount_in_words( n % 100)
    		 WHEN n BETWEEN 1000 AND 999999
    			   THEN  (amount_in_words( n / 1000)) || ' Thousand ' ||
         			  amount_in_words( n % 1000)
    		 WHEN n BETWEEN 1000000 AND 999999999
     			  THEN  (amount_in_words( n / 1000000)) || ' Million ' ||
         		  amount_in_words( n % 1000000)
   			 WHEN n BETWEEN 1000000000 AND 999999999999
     			  THEN  (amount_in_words( n / 1000000000)) || ' Billion ' ||
           			amount_in_words( n % 1000000000)
    		 WHEN n BETWEEN 1000000000000 AND 999999999999999
      			 THEN  (amount_in_words( n / 1000000000000)) || ' Trillion ' ||
           			amount_in_words( n % 1000000000000)
   			 WHEN n BETWEEN 1000000000000000 AND 999999999999999999
      			 THEN  (amount_in_words( n / 1000000000000000)) || ' Quadrillion ' ||
          			 amount_in_words( n % 1000000000000000)
   			 WHEN n BETWEEN 1000000000000000000 AND 999999999999999999999
       			THEN  (amount_in_words( n / 1000000000000000000)) || ' Quintillion ' ||
          			 amount_in_words( n % 1000000000000000000)
         	 ELSE ' INVALID INPUT' END INTO e;
 			 e := RTRIM(e);
 			 IF RIGHT(e,1)='-' THEN
   			 e := RTRIM(LEFT(e,length(e)-1));
 		 END IF;

 		 RETURN e;
		END;
	$$ LANGUAGE PLPGSQL;

CREATE VIEW vw_receipt AS
	SELECT payment_types.account_id, payment_types.use_key_id, payment_types.payment_type_name, payment_types.is_active,
		
		payments.payment_id,payments.payment_type_id, payments.currency_id, payments.period_id, 
		payments.property_id,payments.rental_id, payments.org_id, payments.journal_id, payments.payment_number, 
		payments.payment_date, payments.tx_type,payments.account_credit, payments.account_debit, payments.balance, 
		payments.exchange_rate, payments.activity_name, payments.action_date,Amount_in_words(payments.account_credit::int) as amount_paid,

		currency.currency_name, currency.currency_symbol,

		vw_rentals.property_type_name, vw_rentals.property_name, 
		vw_rentals.estate,vw_rentals.tenant_name,vw_rentals.hse_no,vw_rentals.rental_value,(vw_rentals.tenant_id) AS entity_id,
		
		vw_periods.period_disp, vw_periods.period_month,vw_periods.start_date,vw_periods.end_date
		
			FROM payments
			INNER JOIN currency ON currency.currency_id = payments.currency_id
			INNER JOIN payment_types ON payment_types.payment_type_id = payments.payment_type_id
			INNER JOIN vw_rentals ON vw_rentals.rental_id = payments.rental_id
			INNER JOIN vw_periods ON vw_periods.period_id = payments.period_id
			WHERE tx_type=1; 

CREATE VIEW vw_tenant_statement AS
	SELECT rental_id, tenant_name,(property_name||','||property_type_name||','||estate)AS property_info ,hse_no,

		payment_date,payment_number,(activity_name||','||hse_no||','||period_disp)AS details,
		account_debit as Rent_To_Pay,account_credit as Rent_paid,balance 

			FROM vw_tenant_payments 
					ORDER BY payment_id ASC;


CREATE VIEW vw_tenant_invoice AS
	SELECT (vw_period_rentals.period_year||'-'||vw_period_rentals.period_month)AS period_disp, 
		(vw_period_rentals.property_name||' '|| vw_period_rentals.property_type_name||' '|| vw_period_rentals.estate)AS property_details, vw_period_rentals.tenant_name, 
		vw_period_rentals.hse_no, vw_period_rentals.rental_amount, vw_period_rentals.service_fees, vw_period_rentals.commision, 
		vw_period_rentals.repair_amount, vw_period_rentals.status, 

		payments.payment_id, payments.payment_type_id,payments.period_id, payments.entity_id, payments.property_id, 
		payments.rental_id, payments.org_id, payments.payment_number, payments.payment_date, payments.account_debit, payments.exchange_rate, 
		payments.activity_name, 

		currency.currency_name, currency.currency_symbol,
		
		vw_orgs.org_name, vw_orgs.org_full_name
		
		FROM payments 
		INNER JOIN vw_period_rentals ON vw_period_rentals.rental_id = payments.rental_id
		INNER JOIN currency ON currency.currency_id = payments.currency_id
		INNER JOIN vw_orgs ON vw_orgs.org_id = payments.org_id
		where tx_type = 1 and payment_type_id = 5 ;