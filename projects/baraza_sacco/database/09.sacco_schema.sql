BEGIN;

SAVEPOINT sample_savepoint;

CREATE TABLE bank(
	bank_id		serial primary key,
	bank_code	char(3) unique,
	bank_abbrev	varchar(10) unique,
	bank_name	varchar(30) unique,
	details		text
	);
INSERT INTO bank(bank_id, bank_code, bank_abbrev, bank_name) VALUES(1,'030','BARC','Barclays Bank of Kenya');
INSERT INTO bank(bank_id, bank_code, bank_abbrev, bank_name) VALUES(2,'999','KCB','Kenya Commercial Bank');
INSERT INTO bank(bank_id, bank_code, bank_abbrev, bank_name) VALUES(3,'999','Equity','Equity Bank');
INSERT INTO bank(bank_id, bank_code, bank_abbrev, bank_name) VALUES(4,'999','CooP','Cooperative Bank of Kenya');
INSERT INTO bank(bank_id, bank_code, bank_abbrev, bank_name) VALUES(5,'999','StanChart','Standard Chattered Bank');
SELECT pg_catalog.setval('bank_bank_id_seq',5,true);


CREATE TABLE bank_branch(
	bank_branch_id			serial primary key,
	bank_id				integer references bank,
	bank_branch_name		varchar(50),
	bank_branch_code		char(3) unique,
	bank_branch_building		varchar(20),
	bank_branch_address		varchar(50),

	details				text
	);
--ALTER TABLE employee ADD bank_branch_id	integer not null references bank_branch;

CREATE TABLE bank_account_type(
	bank_account_type_id		serial primary key,
	bank_account_type_name		varchar(50),
	details					text
	);
INSERT INTO bank_account_type(bank_account_type_name) VALUES('Default Current Account');


CREATE TABLE bank_account(
	bank_account_id		serial primary key,
	bank_account_type_id	integer references bank_account_type,
	bank_branch_id		integer references bank_branch,
	bank_account_name	varchar(50),
	bank_account_number	varchar(20),
	currency_id		integer references currency,
	account_id		integer references accounts,	--gl code.. ie reference to a/c in the COA.. this should link to a current asset account

	is_reconciled			boolean default false not null,
	last_reconciliation_date	date,
	end_reconsile_balance		real default 0 not null,

	last_statement_date		date,

	is_active			boolean default true not null,
	p_login_id			bigint references p_login,

	details				text,
	unique(bank_branch_id,bank_account_number)
	);


--deposits, withdrawals, payments(to biz partner)
CREATE TABLE bank_transaction(
	bank_transaction_id		serial primary key,
	bank_account_id			integer references bank_account,			--its COA entry is defined in the bank_account table

	transaction_date		date,					--date this was actualy done at the bank... ie reflected on the statement
	transaction_narrative		text,
	period_id			integer references periods,		--to be updated by trigger using transaction_date column

	b_partner_id			integer references b_partner,		--typically used for payments
	account_id			integer references accounts,	--the relevant account. typicaly Payables in case of Payments and Receivables in case of deposits

	amount				real,
	bank_charges			real default 0 not null,

	is_deposit			boolean default false not null,
	is_withdrawal			boolean default false not null,
	is_bank_transfer		boolean default false not null,		--this ignores b_partner and accountid.. ie both null.. updated by TRIGGER

	--is_miscellaneous		boolean default false not null,		--for internal use by the organization/institution ie b_partnerid is null .. eg dunno,

	is_line_reconciled		boolean default false not null,		--used later during reconciliation

	details				text		--by person creating
	);


--NOT VERY CLEAR AT THE MOMENT-- inserts at least two entries into bank_transaction table to indicate the same..
CREATE TABLE bank_transfer(
	bank_transfer_id	serial primary key,
	transfer_narrative	text,
	transfer_date		date,

	cr_bank_account_id	integer references bank_account,
	dr_bank_account_id	integer references bank_account check (dr_bank_account_id != cr_bank_account_id),		--ALTER TABLE bank_transfer ADD CONSTRAINT sameAccountCheck CHECK (from_bank_account_id != to_bank_account_id)

	transfer_amount			real not null,			--ALTER TABLE bank_transfer ALTER COLUMN amount SET NOT NULL

	--exchange rate is ignored for now
	action_timestamp	timestamp default now(),

	details			text

	);



CREATE TABLE payment_mode(
	payment_mode_id		serial primary key,
	payment_mode_name	varchar(20),
	processing_fee		real,					--default charge.. eg.. Cheques may be charged 150 on top
	details 			text
	);
INSERT INTO payment_mode (payment_mode_name, processing_fee) VALUES('CASH', 0);
INSERT INTO payment_mode (payment_mode_name, processing_fee) VALUES('DIRECT BANKING', 0);
INSERT INTO payment_mode (payment_mode_name, processing_fee) VALUES('CHEQUE', 150);
INSERT INTO payment_mode (payment_mode_name, processing_fee) VALUES('M-PESA', 0);
INSERT INTO payment_mode (payment_mode_name, processing_fee) VALUES('Airtel Money', 0);
INSERT INTO payment_mode (payment_mode_name, processing_fee) VALUES('Orange Money', 0);



CREATE TABLE uom(
	uom_id		serial primary key,
	edi_code	char(2),
	uom_name	varchar(20),
	uom_descr	varchar(100),
	details		text
	);

INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('UN','Unit','A single Item');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('KG','Kilogram','Kilogram');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('PR','Pair','Pair');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('BN','Bundle','Bundle');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('LT','Litre','Litre');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('MT','Metre','Meter');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('HR','Hours','Hours');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('MJ','Minutes','Minutes');
INSERT INTO uom(edi_code,uom_name,uom_descr) VALUES('03','Seconds','Seconds');


CREATE TABLE employer(
	employer_id		serial primary key,
	employer_name		varchar(50),
	address			varchar(50),
	telno			varchar(20),
	email 			varchar(30),

	zipcode 		varchar(5),
	city 			varchar(20),
	sys_country 		char(3) references sys_countrys,

	details 		text
	);

INSERT INTO employer(employer_id, employer_name,city,country) VALUES(1, 'DewCis Solutions','Nairobi','Kenya');
SELECT pg_catalog.setval('employer_employer_id_seq', 1, true);


CREATE TABLE member_group(
	member_group_id		serial primary key,
	member_group_name	varchar(50),
	details			text
	);
INSERT INTO member_group(member_group_id, member_group_name) VALUES(1, 'UNDEFINED');	--none
INSERT INTO member_group(member_group_id, member_group_name) VALUES(2, 'Women Group');
INSERT INTO member_group(member_group_id, member_group_name) VALUES(3, 'Youth Group');
SELECT pg_catalog.setval('member_group_member_group_seq', 3, true);


CREATE TABLE members(
	member_id			serial primary key,
	employer_id			integer references employer,
	member_group_id			integer references member_group,

	entity_id			integer references entitys,
	account_id 			integer references accounts
	--account_code			integer references chart_of_accounts(account_code),

	member_photo			bytea,
	member_name			varchar(50) not null,
	staff_no			varchar(25),
	id_number			varchar(15) not null,
	gender    			CHAR(1) CHECK (gender IN ('M','F')),

   	address				varchar(50),
	zipcode 			varchar(5) default '254',
	city 				varchar(20),
	country 			varchar(30) default 'kenya',
	telno				varchar(50),
	mobile				varchar(50),
	email				varchar(120),

	entry_date			date not null default current_date,
	date_of_birth			date,
	entry_amount			real not null default 0,	--joining fee			--A/C

	--payroll				real not null default 0,	--amount to be submitted by employer each month
	--contribution		real not null default 0, 	--member agrees to pay this amount each month

	--sharecapital 		REAL NOT NULL DEFAULT 2000,
	--bylaws				REAL NOT NULL DEFAULT 100,

	opening_balance		real,	--wen importing

	member_port_folio		varchar(50) default 'Member',			--title/position in the sacco

	exit_date			date,
	exit_amount			real not null default 0,	--how much he was paid when he left the sacco

	is_active			boolean not null default false,
	has_left_voluntarily	boolean not null default false,
	member_login			varchar(32),	-- not null unique,

	default_pass			varchar(32) default 'enter',
	member_pass			varchar(32) not null default md5('password'),

	nextofkininfo		text,

	details 			text
	);


--FULL TEXT SEARCH UPDATES
-- ALTER TABLE members ADD COLUMN ts_doc tsvector;
-- UPDATE members SET ts_doc = to_tsvector('english', coalesce(title,'') || ' ' || coalesce(body,''));
-- CREATE INDEX ts_idx ON members USING gin(ts_doc);
-- CREATE TRIGGER tr_ts_doc_members BEFORE INSERT OR UPDATE ON members;
-- FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger(ts_doc, 'pg_catalog.english', title, body);


--ADD CREDITORS ACCOUNTS
-- INSERT INTO accounts(account_id, account_type_id, account_name)
-- 	SELECT (40100 + member_id), 400, membername FROM members;
-- UPDATE members SET account_id = (40100 + member_id);



--disciplinary
CREATE TABLE sacco_action(
	sacco_action_id		serial primary key,
	sacco_actio_nname		varchar(20),
	details				text
	);
INSERT INTO sacco_action(sacco_actionname) VALUES('STATUS UPDATE');
INSERT INTO sacco_action(sacco_actionname) VALUES('SUSPENSION');
INSERT INTO sacco_action(sacco_actionname) VALUES('REINSTATEMENT');
INSERT INTO sacco_action(sacco_actionname) VALUES('RULES VIOLATION');		--reported violation of rules
INSERT INTO sacco_action(sacco_actionname) VALUES('EXPULSION');


--WE WANT TO RECORD ANY MISC actions and change of member status
CREATE TABLE member_status(
	member_statusid		serial primary key,
	member_id			integer references members,
	sacco_action_id		integer references sacco_action,

	details			text
	);

/*
CREATE TABLE periods (
	period_id			serial primary key,

	startdate			date, -- not null check(date_part('month',startdate) >= date_part('month',current_date)), --period from now to future and not past months
	enddate				date not null check(enddate > startdate),

	dividendrate		real not null default 0,		--??
	closemonth			boolean not null default false,
	isactive			boolean not null default false,
	isold				boolean not null default false,
	details				text,
	unique(startdate,enddate)
	);
--create a corresponding accounting_period just for compatibility's sake....
*/



CREATE TABLE meeting_type(
	meeting_type_id		serial primary key,
	meeting_type_name	varchar(20),
	details				text
	);
INSERT INTO meeting_type(meeting_type_id, meeting_type_name) VALUES(1, 'REGULAR');
INSERT INTO meeting_type(meeting_type_id, meeting_type_name) VALUES(2, 'ANNUAL');
INSERT INTO meeting_type(meeting_type_id, meeting_type_name) VALUES(3, 'EXTRA ORDINARY');
INSERT INTO meeting_type(meeting_type_id, meeting_type_name) VALUES(4, 'OTHER');


CREATE TABLE meeting(
	meeting_id		serial primary key,
	meeting_type_id		integer references meeting_type,

	called_by		varchar(50),
	none_members_present	varchar(50),
	meeting_agenda		text,

	secretary_id		integer references members,
	minutes			text,

	details			text			--entered by updater

	);
CREATE INDEX meeting_meeting_type_id ON meeting (meeting_type_id);
CREATE INDEX meeting_secretary_id ON meeting (secretary_id);


CREATE TABLE meeting_attendance(
	meeting_attendance_id	serial primary key,
	meeting_id		integer references meeting,
	member_id		integer references members,

	--attendee_name		varchar(50),		--we expect non members to occasionaly represent
	attendee_role		varchar(50) default 'Sacco Member',		--role in the meeting... especialy if acting

	absent_with_apology	boolean default false,

	time_in			varchar(20),		--time this member entered the meeting

	details			text
	);
CREATE INDEX member_attendance_meeting_id ON member_attendance (meeting_id);
CREATE INDEX member_attendance_meeting_id ON member_attendance (member_id);



CREATE TABLE cheque_status(
  cheque_status_id	serial primary key,
  cheque_status_name	varchar(50),
  details		text
  );
INSERT INTO cheque_status(cheque_status_id, cheque_status_name) VALUES(1,'PENDING');	--post dated... or not due..
INSERT INTO cheque_status(cheque_status_id, cheque_status_name) VALUES(2,'CLEARED');
INSERT INTO cheque_status(cheque_status_id, cheque_status_name) VALUES(3,'DISHONOURED');




--employer remittances - one to one relationship
--updated via transactions
CREATE TABLE employer_monthly(
    employer_monthly_id		serial primary key,
    employer_id 		integer references employer,
    period_id			integer references period,
    payment_mode_id		integer references payment_mode,

    expected_remittance 	real not null default 0,		--sum of employees payroll contribution. initialized by trigger
    actual_remittance 		real not null default 0,		--total submitted by employer this month

    payment_date		date not null default current_date,

    account_id			integer references accounts,	--DR account (cash/bank)
    is_back_date 		boolean default false not null,

    cheque_name 		varchar(50),
    cheque_date 		date,				--payment date
    cheque_amount 		real,				--paid amount
    cheque_number		real,

    cheque_status_id		integer references cheque_status,

    is_confirmed 		boolean DEFAULT false,
    is_paid 			boolean DEFAULT false,
    is_dishonoured		boolean default false,

    details			text
    );
CREATE INDEX employer_monthly_employer_id ON employer_monthly (employer_id);
CREATE INDEX employer_monthly_period_id ON employer_monthly (period_id);
CREATE INDEX employer_monthly_payment_mode_id ON employer_monthly (payment_mode_id);



CREATE TABLE relation(
      relation_id	serial primary key,
      relation_name	varchar(50),
      details		text
      );
INSERT INTO relation(relation_id, relation_name, details) VALUES(1,'Parent','Father or mother');
INSERT INTO relation(relation_id, relation_name, details) VALUES(2,'Child', 'Dauther or Son');
INSERT INTO relation(relation_id, relation_name, details) VALUES(3,'Spouse', 'Husband or Wife');
INSERT INTO relation(relation_id, relation_name, details) VALUES(4,'Sibling', 'Brother or Sister');
INSERT INTO relation(relation_id, relation_name, details) VALUES(5,'Relative', 'Cousin, Niece, Uncle, and other relatives');
INSERT INTO relation(relation_id, relation_name, details) VALUES(6,'Other', 'Non Relative');



CREATE TABLE nominee(
      nominee_id	serial primary key,
      member_id		integer references members,
      relation_id	integer references relation,
      nominee_name	varchar(50) not null,
      nominee_photo	bytea,
      share_percentage	real not null default 1.0,

      nomination_date	date,
      date_of_birth	date,
      gender    	char(1) CHECK (gender IN ('M','F')),

      id_number		varchar(20),
      mobile		varchar(30) not null,	--one or more phones
      address		varchar(50),
      city 		varchar(20),
      tel_no		varchar(50),
      email		varchar(120),

      witness1_id	integer references members,	--first witnes
      witness1_date	date,
      witness2_id	integer references members,	--second witnes
      witness2_date	date,

      details		text
      );



--initialized after insert on periods
--members monthly remittances (one to one relationship).. loan repayments will be done on repayment_table
CREATE TABLE member_monthly (
	member_month_id		serial primary key,
	member_id		integer references members,
	period_id		integer references periods,
	employer_monthly_id	integer,	--usefull in case of checkoff payments

	payroll			real not null default 0,			--expected from payroll based on initial agreement
	payroll_received	boolean not null default false,			--actual amount deducted from payroll

	--in case of check-off the following three fields need to indicate the same
	payment_mode_id		integer references payment_mode,
	document_number		varchar(20),	--either phone number, cheque number, etc
	payment_narrative	text,

	contribution		real not null default 0,		--net contribution received (must be <= designated contribution);- updated by trigger after insert on transactions
	--addfunds		real not null default 0,		--total additional funds
	--interestpaid		real not null default 0,		--interest paid so far
	--dividend		real not null default 0,		--any dividend given this month
	penalty			real not null default 0,		--total penalties/charges

	narrative		text			--entered by updator
	);
CREATE INDEX member_monthly_member_id ON member_monthly (member_id);
CREATE INDEX member_monthly_period_id ON member_monthly (period_id);
CREATE INDEX member_monthly_payment_mode_id ON member_monthly (payment_mode_id);



ALTER TABLE loan_types ADD interest_recovery real not null default 0;		--%age of interest to be recovered in advance

ALTER TABLE loans ADD first_repayment_date	date;	--DATE OF first repayment ..(may be computed from grace_period)
ALTER TABLE loans ADD grace_period_months	integer not null default 1;	--period before repayment is expected
ALTER TABLE loans ADD member_id		integer references members;
ALTER TABLE loans ADD repayment_option	varchar(50);	--(EITHER)this will trigger the formular to either calculate the (i) monthly repayment amount or (i)repayment period
ALTER TABLE loans ADD option_data	integer;	--either number of months or amount
ALTER TABLE loans ADD is_old	boolean not null default false; --IMPORTed
ALTER TABLE loans ADD is_active	boolean not null default false;

CREATE INDEX loan_member_id ON loan (member_id);




--loan guaranters
CREATE TABLE guaranter(
	guaranter_id		serial primary key,
	member_id 		integer references members,	--actual gauranter
	loan_id			integer references loan,

	guarantee_amount	real not null default 0,

	is_valid			boolean default true not null,		--this may be used to overide guaranter's concent after evaluating total loans guaranteed, history, credit worthiness, etc
	has_accepted		boolean default false not null,			--has given concent to guarantee this loan

	details					text
	);
CREATE INDEX guaranter_member_id ON guaranter(member_id);
CREATE INDEX guaranter_loan_id ON guaranter(loan_id);


--one(loan) to many(reinbursements) accomodated....
--all payments (wether in full or in installments) given to loan applicant...aka reinbursement
CREATE TABLE loan_disbursement (
	loan_disbursement_id		serial primary key,
	loan_id				integer references loan,
	member_id			integer references members,	--receiver of the loan
	witness_id			integer references members,	--witness member default is the accounts user

	amount_disbursed		real not null check(amount_disbursed > 0),
	disbursement_date 		date,

	is_back_date 			boolean default false not null,
	account_id 			integer references accounts,		--the account FROM WHICH the amount was disbursed

	payment_mode_id			integer references payment_mode,
	document_number			varchar(20),	--either phone number, cheque number, etc
	payment_narrative		text,

	details				text
	);

CREATE INDEX loan_disbursement_loan_id ON loan_disbursement(loan_id);
CREATE INDEX loan_disbursement_member_id ON loan_disbursement(member_id);
CREATE INDEX loan_disbursement_witness_id ON loan_disbursement(witness_id);
CREATE INDEX loan_disbursement_payment_mode_id ON loan_disbursement(payment_mode_id);



--pre-prepared list of loan repayment ... initialized after insert on periods
--update A/C journal
CREATE TABLE repayment_table(
    repayment_table_id 	serial primary key,
    loan_id 			integer references loan,
    employer_monthly_id		integer,		--useful if checkoff payment

    emi 			real NOT NULL DEFAULT 0,	--EMI expected monthly installment based on wether fixed or reducing balance
    loan_period 		integer,		--not a/c period but rather the period of the loan
    loan_period_balance 	real NOT NULL,
    interest_component 		real NOT NULL DEFAULT 0,
    principal_component 	real NOT NULL DEFAULT 0,

    period_id			integer references periods,
    payment_mode_id		integer references payment_mode,
    account_id 			integer references accounts;

    cheque_name 		varchar(50),		--payment mode/means
    cheque_number 		varchar(50),		--document number/telephone number
    cheque_date 		date,				--payment date
    cheque_amount 		real,				--paid amount
    --bank_branch_id 		integer references bank_branch,
    cheque_status_id		integer references cheque_status,

    branch_name 	varchar(50),
    bank_name 		varchar(50),

    penalty 			real NOT NULL DEFAULT 0,

    is_confirmed 		boolean DEFAULT false,
    is_paid 			boolean DEFAULT false,
    is_dishonoured	boolean default false,

    banking_slip		text,

    is_defaulted		boolean default false,		--when true... insert into defaulters' table
    is_back_date 		boolean default false not null, --this will allow manipulation of dates and amounts etc

    details			text
    );





--recognized services for all money related activities
CREATE TABLE service(
	service_id 		serial primary key,
	service_name		varchar(50),
	date_started		date not null default current_date,
	is_charge		boolean not null default false,
	is_deprecated		boolean not null default false,
	details			text,
	unique(service_name)
	);
--the following available at front office
INSERT INTO service(service_id, service_name,is_charge) VALUES(1, 'Share Purchase',false);
INSERT INTO service(service_id, service_name,is_charge) VALUES(2, 'Monthly Deposit',false); 	--both contribution and savings
INSERT INTO service(service_id, service_name,is_charge) VALUES(3, 'Loan Repayment',false);	--individual/direct payment
INSERT INTO service(service_id, service_name,is_charge) VALUES(4, 'Payroll Payment',false);	--cheque brought by employer
INSERT INTO service(service_id, service_name,is_charge) VALUES(5, 'Loan Disbursement',false);
INSERT INTO service(service_id, service_name,is_charge) VALUES(6, 'Sacco Fee',true);		--includes registration, penalties, etc
--share transfer ??? (charges etc...)

--the following two only available at back office
INSERT INTO service(service_id, service_name,is_charge) VALUES(11, 'Bank Deposit', false);
INSERT INTO service(service_id, service_name,is_charge) VALUES(12, 'Bank Withdrawal', false);
SELECT pg_catalog.setval('service_service_id_seq', 12, true);



--for each service we need to know the relevant DR nd CR accounts (such that for any new service we only declare the relevant postings to be done instead of updating the trigger)
CREATE TABLE acc_combination(
    acc_combination_id		serial primary key,
    service_id			integer references service,
    account_id			integer references accounts,

    dr_cr			char(2) CHECK (dr_cr IN ('DR','CR')),	--wether DR or CR
    trx_column			varchar(20) default 'TOTAL' not null,	--xponding column to use in the transactions table, (TOTAL, COL_1, COL_2 or COL_3)

    dynamic_account_source	varchar(20) default 'NONE' not null, --???if the account is not known in advance get the account_id from this table

    details			text
    );
CREATE INDEX acc_combination_service_id ON acc_combination(service_id);
CREATE INDEX acc_combination_account_id ON acc_combination(account_id);



--REGISTRATION FEE (OR OTHER FEES??)
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 6, 33000, 'DR', 'TOTAL', 'NONE', 'We debit CASH account');
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 6, 71050, 'CR', 'TOTAL', 'NONE', 'We debit REGISTRATION FEE account');
--SHARE PURCHASEs
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 1, 33000, 'DR', 'TOTAL', 'NONE', 'We debit CASH account');		--increase in cash
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 1, 60020, 'CR', 'TOTAL', 'NONE', 'We credit SACCO SHARES account');	--increase in share capital
--MEMBER DEPOSITS
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 2, 33000, 'DR', 'TOTAL', 'NONE', 'We debit CASH account');		--total amount is debited to cash
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 2, 40060, 'CR', 'COL_1', 'NONE', 'We credit savings account');		--part of it is savings (cr)
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 2, 40070, 'CR', 'COL_2', 'NONE', 'We credit contribution account');	--the other part is contribution (cr)
--LOAN REPAYMENT
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 3, 33000, 'DR', 'TOTAL', 'NONE', 'We debit CASH account');		--total amount is debited to cash
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 3, 71030, 'CR', 'COL_1', 'NONE', 'We credit Interest Income');		--part is interest (income)
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 3, 71055, 'CR', 'COL_2', 'NONE', 'We credit disbursement account');	--part is principal component
-- INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 3, 40080, 'CR', 'COL_3', 'NONE', 'We credit PREPAYMENT account');	--IF EXCESS
--LOAN DISBURSEMENT
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 5, 71055, 'DR', 'TOTAL', 'NONE', 'We debit the loan disbursement account');
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 5, NULL, 'CR', 'TOTAL', 'TRX', 'We credit the account(_id) provided by the Transaction/Input table'); --bcoz we wont know in advance which acount this amount will come from
--SHARE TRASFER
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 13, 33000, 'DR', 'TOTAL', 'NONE', 'We debit CASH account');	--DR CASH
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 13, 40085, 'CR', 'COL_1', 'NONE', 'We credit Liability account');	--CR WE OWE THE SELLER (this is because the buyer does not transact directly with the seller... its only after this that we can pay the seller)
INSERT INTO acc_combination(service_id, account_id, dr_cr, trx_column, dynamic_account_source, details) VALUES( 13, 71051, 'CR', 'COL_2', 'NONE', 'We credit Share Transfer Fee account');	--CR we cr income




CREATE TABLE fee(
  fee_id			serial primary key,
  fee_type_id		integer references fee_type,
  --account_id		integer references accounts,			--xponding REVENUE The account to DEBIT
  fee_code			varchar(10),
  fee_name			varchar(50),
  fee_value			real not null default 0,

  minimum_charge	real default 0,		--can be used as lower bound
  maximum_charge	real default 0,		--upper bound when defining chattels fee

  details		text
  );
CREATE INDEX fee_fee_type_id ON fee(fee_type_id);


INSERT INTO fee(fee_id,fee_type_id,fee_code,fee_name, fee_value,minimum_charge,maximum_charge) VALUES(1,1, 'RF','REGISTRATION FEE',2000,0,0);

--proxy table for all money/financial related xactions
CREATE TABLE transactions(
	transaction_id 		serial primary key,
	service_id		integer references service,		--either
	period_id		integer references period, --default getPeriodID(current_date), --if not backdating get the current period..
	member_id		integer references members,		 --for loans this will be updated by trigger

	employer_monthly_id	integer references employer_monthly,	--if payroll payment then capture accordingly

	--bank_account_id	integer references bank_account,
	account_id		integer references accounts,		--use this value for any acc_combination without a PREDEFINED account (ie account_id is null)

	loan_id			integer references loan,		--in case of xactions related to loan. in which case we can compute member_id

	transaction_date	date default current_date not null,    --timestamp default now(),

	payment_mode_id		integer references payment_mode,
	document_number		varchar(20),	--either phone number, cheque number, etc
	payment_narrative	text,

	--to make this table varsatile... (for use by acc_combination)
	total_amount		real not null default 0,	--generaly the total of the following three (distinguished at the UI)
	amount_1		real not null default 0,	--sub total 1	--eg savings
	amount_2		real not null default 0,	--sub total 2	--eg contribution
	amount_3		real not null default 0,	--sub total 3

	quantity		integer default 1 not null,


	is_approved		boolean not null default false,		--we only considere approved transaction for further processing...
	is_back_date		boolean default false,			--back dated records will bypass some checks...

	details			text
	);
CREATE INDEX transactions_period_id ON transactions(period_id);
CREATE INDEX transactions_service_id ON transactions(service_id);
CREATE INDEX transactions_member_id ON transactions(member_id);
CREATE INDEX transactions_payment_mode_id ON transactions(payment_mode_id);

--alter baraza core
ALTER TABLE gls ADD transaction_id integer references transactions;
ALTER TABLE gls ALTER COLUMN journal_id DROP NOT NULL;



COMMIT;