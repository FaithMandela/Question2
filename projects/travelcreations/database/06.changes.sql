UPDATE entitys  SET user_name='smutua2001@yahoo.com' WHERE primary_email = 'smutua2001@yahoo.com';
UPDATE entitys  SET user_name='winfred.mwaki@feedthechildren.org' WHERE primary_email = 'winfred.mwaki@feedthechildren.org';
UPDATE entitys  SET user_name='gorettiakinyi@hotmail.com' WHERE primary_email = 'gorettiakinyi@hotmail.com';
UPDATE entitys  SET user_name='roys@maxwellsda.org' WHERE primary_email = 'roys@maxwellsda.org';
UPDATE entitys  SET user_name='junek@brainwavekenya.com' WHERE primary_email = 'junek@brainwavekenya.com';
UPDATE entitys  SET user_name='hakariuki@chasebank.co.ke' WHERE primary_email = 'hakariuki@chasebank.co.ke';
UPDATE entitys  SET user_name='Dmphande@worldbank.org' WHERE primary_email = 'Dmphande@worldbank.org';
UPDATE entitys  SET user_name='Jackson.kinyanjui@workingsmart.biz' WHERE primary_email = 'Jackson.kinyanjui@workingsmart.biz';

UPDATE sys_emailed SET emailed = false WHERE table_id IN(23,24,30,38,32,41,22,20) AND sys_email_id = 2;
