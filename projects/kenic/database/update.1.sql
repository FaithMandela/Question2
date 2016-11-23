

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



--- get list of fully iddle clients
SELECT client.clid, client.name
FROM client LEFT JOIN domain ON client.clid = domain.clid
LEFT JOIN contact ON client.clid = contact.clid
LEFT JOIN (SELECT id, client_roid FROM ledger WHERE description <> 'Membership Fee') lt ON client.clid = lt.client_roid
WHERE (domain.clid is null) AND (contact.clid is null) AND (lt.client_roid is null);


--- Delete idle contacts, hosts and clients
INSERT INTO audit.master (audit_user, audit_login) VALUES ('automation', 'automation');

DELETE FROM contact WHERE id IN
(SELECT contact.id
FROM contact LEFT JOIN domain_contact ON contact.id = domain_contact.contact_id
LEFT JOIN domain ON contact.id = domain.registrant
LEFT JOIN application ON contact.id = application.registrant
WHERE (domain_contact.contact_id is null) AND (domain.registrant is null) AND (application.registrant is null));

DELETE FROM host_address WHERE host_name IN
(SELECT host.name
FROM host LEFT JOIN domain_host ON host.name = domain_host.host_name
WHERE domain_host.host_name is null);

DELETE FROM host WHERE name IN
(SELECT host.name
FROM host LEFT JOIN domain_host ON host.name = domain_host.host_name
WHERE domain_host.host_name is null);


DELETE FROM login_role WHERE username IN
(SELECT login.username
FROM client LEFT JOIN domain ON client.clid = domain.clid
LEFT JOIN (SELECT id, client_roid FROM ledger WHERE description <> 'Membership Fee') lt ON client.clid = lt.client_roid
LEFT JOIN login ON client.clid = login.clid
WHERE (domain.clid is null) AND (lt.client_roid is null));

DELETE FROM login WHERE clid IN
(SELECT client.clid
FROM client LEFT JOIN domain ON client.clid = domain.clid
LEFT JOIN (SELECT id, client_roid FROM ledger WHERE description <> 'Membership Fee') lt ON client.clid = lt.client_roid
WHERE (domain.clid is null) AND (lt.client_roid is null));

DELETE FROM client WHERE clid IN
(SELECT client.clid
FROM client LEFT JOIN domain ON client.clid = domain.clid
LEFT JOIN (SELECT id, client_roid FROM ledger WHERE description <> 'Membership Fee') lt ON client.clid = lt.client_roid
WHERE (domain.clid is null) AND (lt.client_roid is null))

DELETE FROM client WHERE clid IN
(SELECT client.clid
FROM client LEFT JOIN domain ON client.clid = domain.clid
LEFT JOIN contact ON client.clid = contact.clid
LEFT JOIN (SELECT id, client_roid FROM ledger WHERE description <> 'Membership Fee') lt ON client.clid = lt.client_roid
WHERE (domain.clid is null) AND (contact.clid is null) AND (lt.client_roid is null))




