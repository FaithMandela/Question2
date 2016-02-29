



UPDATE faidaplus.user SET create_date = '2000-01-01 00:00:00' WHERE create_date <= '2000-01-01 00:00:00';
UPDATE faidaplus.user SET last_login = '2000-01-01 00:00:00' WHERE last_login <= '2000-01-01 00:00:00';

UPDATE faidaplus.staff SET rel_id_salutation = 1 WHERE 	rel_id_salutation = 0;
	
UPDATE faidaplus.agency SET date_added = '2000-01-01 00:00:00' WHERE date_added <= '2000-01-01 00:00:00';
UPDATE faidaplus.agency SET last_production = '2000-01-01' WHERE last_production <= '2000-01-01';

