
CREATE OR REPLACE FUNCTION insMembership(varchar(89)) RETURNS varchar(120) AS $$
DECLARE
	v_amount	real;
	v_tax		real;
	reca 		RECORD;
	recb		RECORD;
BEGIN
	SELECT value INTO reca 
	FROM configuration WHERE name = 'memberfee';
	SELECT billingdate, billingdate + CAST('1 year' as interval) as exdate INTO recb
	FROM client WHERE roid = $1;

	INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');
	
	v_amount := CAST(reca.value as real);
	v_tax := v_amount * 0.16;

	INSERT INTO ledger (client_roid, description, currency, tax, tax_label, tax_content, tax_inclusive, amount, total, trans_type, tld, processor_account_history_id, refund_expiry, refund_grace, refund_amount, exdate, previous_expiry_date)
	VALUES ($1, 'Membership Fee', 'KES', 16, 'VAT', v_tax, true, v_amount, v_amount, 'Application', 'ke', '2', now(), now(), 0, recb.exdate, recb.billingdate);

	UPDATE client SET billingdate = billingdate + CAST('1 year' as interval), emailed[1] = false WHERE roid = $1;

	RETURN 'Update membership fee';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION upd_domain_refund() RETURNS trigger AS $$
DECLARE
	reca 		RECORD;
	recb		RECORD;
	docno 		int;
	cr_amount	numeric(8,2);
	cr_tax		numeric(8,2);
BEGIN
	IF(TG_OP = 'INSERT') THEN		
		IF((NEW.trans_type = 'Renewal') OR (NEW.trans_type = 'Registration') OR (NEW.trans_type = 'Application') OR (NEW.trans_type = 'Training')) THEN
			NEW.documentnumber := nextval('invoiceno_seq');
		ELSIF (NEW.trans_type = 'Refund') THEN
			NEW.documentnumber := nextval('creditnoteno_seq');
		END IF;

		SELECT exdate, crid INTO recb FROM domain
		WHERE name  = NEW.domain_name;

		IF((NEW.trans_type = 'Renewal') OR (NEW.trans_type = 'Registration')) THEN
			NEW.exdate := recb.exdate;
		ELSIF (NEW.trans_type = 'Transfer') THEN
			NEW.transf_roid := recb.crid;
		END IF;
	END IF;

	IF(TG_OP = 'UPDATE') THEN
		IF ((OLD.renewal_refund = false) AND (NEW.renewal_refund = true)) THEN
			INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');
			
			cr_amount := ((-1)*NEW.total);
			cr_tax := cr_amount * 0.16;
			INSERT INTO ledger (client_roid, description, currency, amount, total, tax_content, tax_inclusive, trans_type, tld, processor_account_history_id, domain_roid, domain_name, refund_for_id, tax, tax_label)
			VALUES (NEW.client_roid, 'Refund on domain renewal', 'KES', cr_amount, cr_amount, cr_tax, true, 'Refund', 'ke', '2', NEW.domain_roid, NEW.domain_name, NEW.id, '16.0', 'VAT');

			UPDATE domain SET exdate = NEW.previous_expiry_date WHERE name = NEW.domain_name;
		END IF;
		IF((OLD.renewal_refund = true) AND (NEW.renewal_refund = false)) THEN
			NEW.renewal_refund := true;
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


