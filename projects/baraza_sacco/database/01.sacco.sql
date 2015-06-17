CREATE TABLE members (
	memberid			serial primary key,
	membername			varchar(50) not null,
	staffno				varchar(25) not null,
	idnumber			varchar(25) not null,
   	address				varchar(25),
	zipcode 			varchar(25),
	town 				varchar(50),
	country 			varchar(50),
	telno				varchar(50),
	mobile				varchar(50),
	email				varchar(120),
	entrydate			date not null default current_date,
	entryamount			real not null default 500,
	startdate			date not null default current_date,	
	payroll				real not null default 0,
	exitamount			real not null default 0,
	exitdate			date,	
	isactive			boolean default false not null,
	memberlogin			varchar(32) not null unique,
	memberpass			varchar(32) not null default md5('baraza'),
	details 			text
);

CREATE TABLE periods (
	periodid			serial primary key,
	startdate			date not null,
	enddate				date not null,
	dividedrate			real not null default 0,
	closemonth			boolean default false not null,
	details				text
);

CREATE TABLE membermonthly (
	membermonthid			serial primary key,
	memberid			integer  references members,
	periodid			integer references periods,
	payroll				real not null,
	addfunds			real default 0 not null,
	contribution			real not null,
	divided				real default 0 not null,
	narrative			varchar(240),
	UNIQUE (memberid, periodid)
);

CREATE TABLE loantypes (
	loantypeid			serial primary key,
	loantypename			varchar(50),
	defaultinterest			integer,
	details				text
);

CREATE TABLE loans (
	loanid 				serial primary key,
	loantypeid			integer references loantypes,
	memberid			integer references members,
	loandate			date not null default current_date,
	principle			real not null,
	interest			real not null,
	monthlyrepayment		real not null,
	repaymentperiod			integer not null CHECK (repaymentperiod > 0),
	loanapproved			boolean not null default false,
	details				text
);

CREATE TABLE gurantor (
	gurantorid		serial primary key,
	memberid		integer references members,
	loanid			integer references loans,
	amount			real not null default 0,
	details			text
);

CREATE TABLE loanmonthly (
	loanmonthid 			serial primary key,
	loanid				integer references loans,
	periodid			integer references periods,
	interestamount			real not null,
	repayment			real not null,
	interestpaid			real default 0 not null,
	details				text,
	UNIQUE (loanid, periodid)
);

CREATE OR REPLACE FUNCTION upd_members() RETURNS trigger AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, user_name, function_role, 
			first_password, entity_password)
		VALUES (NEW.memberid, 0, 1, NEW.membername, NEW.memberlogin, 'staff',
			'baraza', md5('baraza'));
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = NEW.membername
		WHERE entity_id = NEW.memberid;
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER upd_members AFTER INSERT OR UPDATE ON members
    FOR EACH ROW EXECUTE PROCEDURE upd_members();

CREATE OR REPLACE FUNCTION getrepayment(real, real, integer) RETURNS real AS $$
DECLARE
	repayment real;
	ri real;
BEGIN
	ri := 1 + ($2/1200);

	repayment := $1 * (ri ^ $3) * (ri - 1) / ((ri ^ $3) - 1);
		
	RETURN repayment;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getloanperiod(real, real, integer, real) RETURNS real AS $$
DECLARE
	loanbalance real;
	ri real;
BEGIN
	ri := 1 + ($2/1200);

	loanbalance := $1 * (ri ^ $3) - ($4 * ((ri ^ $3)  - 1) / (ri - 1));
		
	RETURN loanbalance;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getpaymentperiod(real, real, real) RETURNS real AS $$
DECLARE
	paymentperiod real;
	q real;
BEGIN
	q := $3/1200;

	paymentperiod := (log($2) - log($2 - (q * $1))) / (log(q + 1));
		
	RETURN paymentperiod;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gettotalinterest(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(interestamount) is null THEN 0 ELSE sum(interestamount) END 
	FROM loanmonthly
	WHERE (loanid = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION gettotalinterest(integer, date) RETURNS real AS $$
	SELECT CASE WHEN sum(interestamount) is null THEN 0 ELSE sum(interestamount) END 
	FROM loanmonthly INNER JOIN periods ON loanmonthly.periodid = periods.periodid
	WHERE (loanid = $1) AND (startdate < $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION gettotalrepayment(integer) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment + interestpaid) is null THEN 0 ELSE sum(repayment + interestpaid) END
	FROM loanmonthly
	WHERE (loanid = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getintrestrepayment(integer, date) RETURNS real AS $$
	SELECT CASE WHEN sum(interestpaid) is null THEN 0 ELSE sum(interestpaid) END
	FROM loanmonthly INNER JOIN periods ON loanmonthly.periodid = periods.periodid
	WHERE (loanid = $1) AND (startdate < $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION gettotalrepayment(integer, date) RETURNS real AS $$
	SELECT CASE WHEN sum(repayment + interestpaid) is null THEN 0 ELSE sum(repayment + interestpaid) END
	FROM loanmonthly INNER JOIN periods ON loanmonthly.periodid = periods.periodid
	WHERE (loanid = $1) AND (startdate < $2);
$$ LANGUAGE SQL;

CREATE VIEW loanview AS
	SELECT loantypes.loantypeid, loantypes.loantypename, loantypes.defaultinterest, members.memberid, members.membername, members.staffno, 
		members.idnumber, members.payroll, loans.loanid, loans.loandate, loans.principle, loans.interest, loans.repaymentperiod,
		loans.monthlyrepayment, 
		getrepayment(loans.principle, loans.interest, loans.repaymentperiod) as repaymentamount, 
		gettotalrepayment(loans.loanid) as totalrepayment, gettotalinterest(loans.loanid) as totalinterest,
		(loans.principle + gettotalinterest(loans.loanid) - gettotalrepayment(loans.loanid)) as loanbalance,
		getpaymentperiod(loans.principle, loans.monthlyrepayment, loans.interest) as calcrepaymentperiod, loans.loanapproved
	FROM (loantypes INNER JOIN loans ON loantypes.loantypeid = loans.loantypeid )
	INNER JOIN members ON members.memberid = loans.memberid;

CREATE VIEW loanpaymentview AS
	SELECT loantypeid, loantypename, memberid, membername, loanid, loandate, principle, interest, calcrepaymentperiod, 
		repaymentperiod, monthlyrepayment, repaymentamount, generate_series(1, repaymentperiod) as months,
		getloanperiod(principle, interest, generate_series(1, repaymentperiod), repaymentamount) as loanbalance, 
		(getloanperiod(principle, interest, generate_series(1, repaymentperiod) - 1, repaymentamount) * (interest/1200)) as loanintrest 
	FROM loanview;

CREATE VIEW periodview AS
	SELECT periodid, startdate, enddate, dividedrate, closemonth, details, date_part('month', startdate) as monthid,
		to_char(Periods.startdate, 'YYYY') as periodyear, to_char(Periods.startdate, 'Month') as periodmonth,
		(trunc((date_part('month', startdate)-1)/3)+1) as quarter, (trunc((date_part('month', startdate)-1)/6)+1) as semister
	FROM periods;

CREATE VIEW periodyearview AS
	SELECT periodyear
	FROM periodview	
	GROUP BY periodyear
	ORDER BY periodyear;

CREATE VIEW membermonthlyview AS
	SELECT members.memberid, members.membername, members.staffno, members.idnumber, 
		periodview.periodid, periodview.startdate, periodview.dividedrate, periodview.monthid,
		periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.semister,
		membermonthly.membermonthid, membermonthly.payroll, membermonthly.addfunds, membermonthly.contribution
	FROM (membermonthly INNER JOIN members ON membermonthly.memberid = members.memberid)
	INNER JOIN periodview ON membermonthly.periodid = periodview.periodid;

CREATE VIEW loanmonthlyview AS
	SELECT loanview.loantypeid, loanview.loantypename, loanview.memberid, loanview.membername, loanview.loanid, loanview.loandate, 
		loanview.principle, loanview.interest, loanview.repaymentperiod, loanview.monthlyrepayment, 
		periodview.periodid, periodview.startdate, periodview.dividedrate, periodview.monthid,
		periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.semister,
		loanmonthly.loanmonthid, loanmonthly.interestamount, loanmonthly.repayment, loanmonthly.interestpaid,
		gettotalinterest(loanview.loanid, periodview.startdate) as totalinterest,
		gettotalrepayment(loanview.loanid, periodview.startdate) as totalrepayment,
		(loanview.principle + gettotalinterest(loanview.loanid, periodview.startdate+1) - gettotalrepayment(loanview.loanid, periodview.startdate+1)) as loanbalance
	FROM (loanmonthly INNER JOIN loanview ON loanmonthly.loanid = loanview.loanid)
		INNER JOIN periodview ON loanmonthly.periodid = periodview.periodid;

CREATE OR REPLACE FUNCTION insMonthly() RETURNS TRIGGER AS $$
BEGIN	
	INSERT INTO membermonthly (periodid, memberid, payroll, addfunds, contribution)
	SELECT NEW.PeriodID, memberid, payroll, 0, 0
	FROM members WHERE isactive = true;

	INSERT INTO loanmonthly (periodid, loanid, repayment, interestamount, interestpaid)
	SELECT NEW.PeriodID, loanid, monthlyrepayment, (loanbalance * interest / 1200), 0
	FROM Loanview WHERE (loanbalance > 0) AND (loanapproved = true);
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insMonthly AFTER INSERT ON periods
    FOR EACH ROW EXECUTE PROCEDURE insMonthly();

CREATE OR REPLACE FUNCTION updPeriods(integer) RETURNS void AS $$
DECLARE
	myperiod RECORD;
	myrec RECORD;
	myloan RECORD;
	contrib real;
	amount real;
	loanbal real;
BEGIN
	SELECT INTO myperiod startdate FROM periods WHERE (periodid = $1) AND (closemonth = false);

	FOR myrec IN SELECT * FROM membermonthly WHERE (periodid = $1) LOOP
		contrib := myrec.payroll + myrec.addfunds;

		--- loan interest payment
		FOR myloan IN SELECT loanid, gettotalinterest(loanid, myperiod.startdate+1) as totalloanintrest FROM loans
			WHERE (memberid = myrec.memberid) AND (loanapproved = true) AND (loandate <= myperiod.startdate)
			AND ((principle + gettotalinterest(loanid, myperiod.startdate)) > gettotalrepayment(loanid, myperiod.startdate))
		LOOP
			amount := myloan.totalloanintrest - getintrestrepayment(myloan.loanid, myperiod.startdate + 1);
			IF (amount > contrib)  THEN
				amount := contrib;
				contrib := 0;
			ELSE
				contrib := contrib - amount;
			END IF;

			UPDATE loanmonthly SET interestpaid = amount WHERE (loanid = myloan.loanid) AND (periodid = $1);
		END LOOP;
		
		--- Loan payment amounts
		FOR myloan IN SELECT loanid, monthlyrepayment, (principle + gettotalinterest(loanid, myperiod.startdate) - gettotalrepayment(loanid, myperiod.startdate)) as loanbalance 
			FROM loans
			WHERE (memberid = myrec.memberid) AND (loanapproved = true) AND (loandate <= myperiod.startdate)
			AND ((principle + gettotalinterest(loanid, myperiod.startdate)) > gettotalrepayment(loanid, myperiod.startdate))
		LOOP
			amount := myloan.monthlyrepayment;
			loanbal := myloan.loanbalance;

			IF (amount > loanbal) THEN
				amount := loanbal;
			END IF;

			IF (amount > contrib)  THEN
				amount := contrib;
				contrib := 0;
			ELSE
				contrib := contrib - amount;
			END IF;

			UPDATE loanmonthly SET repayment = amount WHERE (loanid = myloan.loanid) AND (periodid = $1);
		END LOOP;

		--- Contribution allocation 
		UPDATE membermonthly SET contribution = contrib WHERE (membermonthid = myrec.membermonthid);

	END LOOP;

END;
$$ LANGUAGE plpgsql;

CREATE VIEW periodloanview AS
	SELECT loanmonthlyview.periodid, 
		sum(loanmonthlyview.interestamount) as suminterestamount, sum(loanmonthlyview.repayment) as sumrepayment, 
		sum(loanmonthlyview.interestpaid) as suminterestpaid, sum(loanmonthlyview.loanbalance) as sumloanbalance
	FROM loanmonthlyview
	GROUP BY loanmonthlyview.periodid;

CREATE VIEW periodmemberview AS
	SELECT membermonthlyview.periodid, 
		sum(membermonthlyview.payroll) as sumpayroll, sum(membermonthlyview.addfunds) as sumaddfunds, 
		sum(membermonthlyview.contribution) as sumcontribution
	FROM membermonthlyview
	GROUP BY membermonthlyview.periodid;

CREATE OR REPLACE FUNCTION gettotalprinciple(date, date) RETURNS real AS $$
	SELECT CASE WHEN SUM(principle) is null THEN 0 ELSE SUM(principle) END
	FROM loans
	WHERE (loandate >= $1) AND (loandate <= $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION gettotalentry(date, date) RETURNS real AS $$
	SELECT CASE WHEN SUM(entryamount) is null THEN 0 ELSE SUM(entryamount) END
	FROM members
	WHERE (entrydate >= $1) AND (entrydate <= $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION gettotalexit(date, date) RETURNS real AS $$
	SELECT CASE WHEN SUM(exitamount) is null THEN 0 ELSE SUM(exitamount) END
	FROM members
	WHERE (exitdate >= $1) AND (exitdate <= $2);
$$ LANGUAGE SQL;

CREATE VIEW periodsummary AS
	SELECT periodview.periodid, periodview.startdate, periodview.dividedrate, periodview.closemonth, periodview.monthid, periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.semister,
		gettotalprinciple(periodview.startdate, periodview.enddate) as totalprinciple, 
		gettotalentry(periodview.startdate, periodview.enddate) as totalentry,
		gettotalexit(periodview.startdate, periodview.enddate) as totalexit,
		periodmemberview.sumpayroll, periodmemberview.sumaddfunds, periodmemberview.sumcontribution, periodloanview.suminterestamount, 
		periodloanview.sumrepayment, periodloanview.suminterestpaid, periodloanview.sumloanbalance
	FROM (periodview LEFT JOIN periodmemberview ON periodview.periodid = periodmemberview.periodid)
		LEFT JOIN periodloanview ON periodview.periodid = periodloanview.periodid;

CREATE VIEW gurantorview AS
SELECT  gurantor.gurantorid,gurantor.amount,members.memberid, members.membername, members.staffno, 
		members.idnumber, members.payroll, loans.loanid, loans.loandate, loans.principle, loans.interest,
		loans.repaymentperiod,
		loans.monthlyrepayment, getrepayment(loans.principle, loans.interest, loans.repaymentperiod) as repaymentamount, 
		gettotalrepayment(loans.loanid) as totalrepayment, gettotalinterest(loans.loanid) as totalinterest,
		(loans.principle + gettotalinterest(loans.loanid) - gettotalrepayment(loans.loanid)) as loanbalance,
		getpaymentperiod(loans.principle, loans.monthlyrepayment, loans.interest) as calcrepaymentperiod, loans.loanapproved
	FROM (gurantor INNER JOIN members ON gurantor.memberid = members.memberid)	
	LEFT JOIN loans ON loans.loanid = gurantor.loanid;

CREATE VIEW gurantorfundview AS
	SELECT members.memberid, members.membername, members.staffno, members.idnumber, periodmemberview.sumcontribution,
		periodview.periodid, periodview.startdate, periodview.dividedrate, periodview.monthid,
		periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.semister,
		membermonthly.membermonthid, membermonthly.payroll, membermonthly.addfunds, membermonthly.contribution
	FROM ((membermonthly INNER JOIN members ON membermonthly.memberid = members.memberid)
	INNER JOIN periodview ON membermonthly.periodid = periodview.periodid)
	INNER JOIN periodmemberview ON membermonthly.periodid = periodmemberview.periodid;

