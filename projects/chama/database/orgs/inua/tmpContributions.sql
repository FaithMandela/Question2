CREATE TABLE tmpContributions (
	tmpContribution_id	serial primary key,
	CMonth	 varchar(32),
	CNAME	 varchar(240),
	CRegFee	 real,
	C1	 real,
	C2	 real,
	C3	 real,
	C4	 real,
	C5	 real,
	C6	 real,
	C7	 real,
	C8	 real,
	C9	 real,
	C10	 real,
	C11	 real,
	C12	 real,
	C13	 real,
	C14	 real,
	C15	 real,
	C16	 real,
	C17	 real,
	C18	 real,
	C19	 real,
	C20	 real,
	C21	 real,
	C22	 real,
	C23	 real,
	C24	 real,
	C25	 real,
	C26	 real,
	C27	 real,
	C28	 real,
	C29	 real,
	C30	 real,
	C31	real
);

COPY tmpContributions(CMonth,CNAME,CRegFee,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C30,C31) 
FROM '/root/tmpContributions.csv' DELIMITER ',' CSV HEADER;


INSERT INTO account_activity (deposit_account_id, activity_type_id, activity_frequency_id,
	activity_status_id, currency_id, entity_id, org_id, activity_date, value_date, account_credit)
SELECT deposit_account_id, 4, 1, 1, 1, 0, 0, '2017-07-01', '2017-07-01', c1
FROM tmpcontributions INNER JOIN members ON tmpcontributions.cname = members.member_name
INNER JOIN deposit_accounts ON members.entity_id = deposit_accounts.entity_id
WHERE tmpcontributions.cmonth = 'JULY';



