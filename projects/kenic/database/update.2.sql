CREATE OR REPLACE FUNCTION upd_domain_refund() RETURNS trigger AS $$
DECLARE
	reca 			RECORD;
	recb			RECORD;
	docno 			int;
	new_ledger_id	int;
	cr_amount		numeric(8,2);
	cr_tax			numeric(8,2);
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
			SELECT id INTO new_ledger_id
			FROM ledger
			WHERE (domain_name = NEW.domain_name) AND (id > NEW.id) AND (renewal_refund = false);
			
				INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');
				
				cr_amount := ((-1)*NEW.total);
				cr_tax := cr_amount * 0.16;
				INSERT INTO ledger (client_roid, description, currency, amount, total, tax_content, tax_inclusive, trans_type, tld, processor_account_history_id, domain_roid, domain_name, refund_for_id, tax, tax_label)
				VALUES (NEW.client_roid, 'Refund on domain renewal', 'KES', cr_amount, cr_amount, cr_tax, true, 'Refund', 'ke', '2', NEW.domain_roid, NEW.domain_name, NEW.id, '16.0', 'VAT');

				UPDATE domain SET exdate = NEW.previous_expiry_date WHERE name = NEW.domain_name;
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');
UPDATE ledger SET renewal_refund = false WHERE id = 471735;
UPDATE ledger SET renewal_refund = true WHERE id = 471735;


CREATE OR REPLACE FUNCTION upd_domain_refund() RETURNS trigger AS $$
DECLARE
	reca 			RECORD;
	recb			RECORD;
	docno 			int;
	new_ledger_id	int;
	cr_amount		numeric(8,2);
	cr_tax			numeric(8,2);
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
			SELECT id INTO new_ledger_id
			FROM ledger
			WHERE (domain_name = NEW.domain_name) AND (id > NEW.id) AND (renewal_refund = false);
			
			IF(new_ledger_id is null)THEN
				INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');
				
				cr_amount := ((-1)*NEW.total);
				cr_tax := cr_amount * 0.16;
				INSERT INTO ledger (client_roid, description, currency, amount, total, tax_content, tax_inclusive, trans_type, tld, processor_account_history_id, domain_roid, domain_name, refund_for_id, tax, tax_label)
				VALUES (NEW.client_roid, 'Refund on domain renewal', 'KES', cr_amount, cr_amount, cr_tax, true, 'Refund', 'ke', '2', NEW.domain_roid, NEW.domain_name, NEW.id, '16.0', 'VAT');

				UPDATE domain SET exdate = NEW.previous_expiry_date WHERE name = NEW.domain_name;
			END IF;
		END IF;
		IF((OLD.renewal_refund = true) AND (NEW.renewal_refund = false)) THEN
			NEW.renewal_refund := true;
		END IF;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


