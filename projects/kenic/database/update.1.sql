

DROP TRIGGER updprice ON ledger;

INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');
UPDATE ledger SET tax = 0 WHERE tax is null;


UPDATE configuration SET value = '198.32.67.10' WHERE value = '198.32.67.25';
UPDATE configuration SET value = '/opt/coca/keys/epp.keystore' WHERE value = '/usr/local/resin/conf/keys/epp.keystore';

UPDATE configuration SET value = '/opt/cocca/keys/registry.kenic.or.ke.registry' WHERE value = '/opt/coca/keys/epp.keystore';


------ post

CREATE TRIGGER updprice
  BEFORE INSERT OR UPDATE
  ON ledger
  FOR EACH ROW
  EXECUTE PROCEDURE updprice();

  
CREATE TRIGGER upd_domain_refund BEFORE INSERT OR UPDATE ON ledger
FOR EACH ROW EXECUTE PROCEDURE upd_domain_refund();
  
CREATE TRIGGER tg_insert_ledger BEFORE INSERT ON ledger
FOR EACH ROW EXECUTE PROCEDURE tg_insert_ledger();

CREATE TRIGGER tg_audit_ledger AFTER INSERT OR UPDATE OR DELETE ON ledger
FOR EACH ROW EXECUTE PROCEDURE tg_audit_ledger();