-- UPDATE entitys  SET user_name='smutua2001@yahoo.com' WHERE primary_email = 'smutua2001@yahoo.com';
-- UPDATE entitys  SET user_name='winfred.mwaki@feedthechildren.org' WHERE primary_email = 'winfred.mwaki@feedthechildren.org';
-- UPDATE entitys  SET user_name='gorettiakinyi@hotmail.com' WHERE primary_email = 'gorettiakinyi@hotmail.com';
-- UPDATE entitys  SET user_name='roys@maxwellsda.org' WHERE primary_email = 'roys@maxwellsda.org';
-- UPDATE entitys  SET user_name='junek@brainwavekenya.com' WHERE primary_email = 'junek@brainwavekenya.com';
-- UPDATE entitys  SET user_name='hakariuki@chasebank.co.ke' WHERE primary_email = 'hakariuki@chasebank.co.ke';
-- UPDATE entitys  SET user_name='Dmphande@worldbank.org' WHERE primary_email = 'Dmphande@worldbank.org';
-- UPDATE entitys  SET user_name='Jackson.kinyanjui@workingsmart.biz' WHERE primary_email = 'Jackson.kinyanjui@workingsmart.biz';
--
-- UPDATE sys_emailed SET emailed = false WHERE table_id IN(23,24,30,38,32,41,22,20) AND sys_email_id = 2;
--
-- Feed the Children -   edith.mwando@feedthechildren.org  winfred.mwaki@feedthechildren.org
-- Workingsmart Skills Ltd  - accounts@workingsmart.biz
-- Halima Kariuki -halimaka2005@gmail.com
-- mercy.nyakio@karenhospital.org


CREATE OR REPLACE FUNCTION ins_client()  RETURNS trigger AS $$
DECLARE
	rec 			RECORD;
	v_entity_id		integer;
BEGIN

	IF (TG_OP = 'INSERT') THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (trim(lower(user_name)) = trim(lower(NEW.user_name)));
		IF(v_entity_id is null)THEN
		SELECT entity_id INTO v_entity_id
		FROM entitys
		WHERE (trim(lower(client_code)) = trim(lower(NEW.client_code)));
		END IF;

		IF(v_entity_id is not null)THEN
			RAISE EXCEPTION 'The username exists use a different one or reset password for the current one';
		END IF;
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (1, NEW.entity_id, 'entitys', 3);
		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_type)
		VALUES (12, 4, 'entitys', 3);

	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
