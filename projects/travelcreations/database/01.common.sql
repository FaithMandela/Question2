

ALTER TABLE entitys ADD	attention		varchar(50);

ALTER TABLE orgs ADD 	cert_number				varchar(50);
ALTER TABLE orgs ADD	vat_number				varchar(50);
ALTER TABLE orgs ADD	fixed_budget			boolean default true;
ALTER TABLE orgs ADD	invoice_footer			text;

CREATE TABLE holidays (
	holiday_id				serial primary key,
	org_id					integer references orgs,
	holiday_name			varchar(50) not null,
	holiday_date			date,
	details					text
);
CREATE INDEX holidays_org_id ON holidays (org_id);

CREATE TABLE banks (
	bank_id					serial primary key,
	sys_country_id			char(2) references sys_countrys,
	org_id					integer references orgs,
	bank_name				varchar(50) not null,
	bank_code				varchar(25),
	swift_code				varchar(25),
	sort_code				varchar(25),
	narrative				varchar(240)
);
CREATE INDEX banks_org_id ON banks (org_id);
INSERT INTO banks (org_id, bank_id, bank_name) VALUES (0, 0, 'Cash');

CREATE TABLE bank_branch (
	bank_branch_id			serial primary key,
	bank_id					integer references banks,
	org_id					integer references orgs,
	bank_branch_name		varchar(50) not null,
	bank_branch_code		varchar(50),
	narrative				varchar(240),
	UNIQUE(bank_id, bank_branch_name)
);
CREATE INDEX branch_bankid ON bank_branch (bank_id);
CREATE INDEX bank_branch_org_id ON bank_branch (org_id);
INSERT INTO bank_branch (org_id, bank_branch_id, bank_id, bank_branch_name) VALUES (0, 0, 0, 'Cash');

CREATE TABLE departments (
	department_id			serial primary key,
	ln_department_id		integer references departments,
	org_id					integer references orgs,
	department_name			varchar(120),
	department_account		varchar(50),
	function_code			varchar(50),
	active					boolean default true not null,
	petty_cash				boolean default false not null,
	description				text,
	duties					text,
	reports					text,
	details					text
);
CREATE INDEX departments_ln_department_id ON departments (ln_department_id);
CREATE INDEX departments_org_id ON departments (org_id);
INSERT INTO departments (org_id, department_id, ln_department_id, department_name) VALUES (0, 0, 0, 'Board of Directors');

CREATE TABLE fiscal_years (
	fiscal_year_id			varchar(9) primary key,
	org_id					integer references orgs,
	fiscal_year_start		date not null,
	fiscal_year_end			date not null,
	year_opened				boolean default true not null,
	year_closed				boolean default false not null,
	details					text
);
CREATE INDEX fiscal_years_org_id ON fiscal_years (org_id);

CREATE TABLE periods (
	period_id				serial primary key,
	fiscal_year_id			varchar(9) references fiscal_years,
	org_id					integer references orgs,
	start_date				date not null,
	end_date				date not null,
	opened					boolean default false not null,
	activated				boolean default false not null,
	closed					boolean default false not null,

	--- payroll details
	overtime_rate			float default 1 not null,
	per_diem_tax_limit		float default 2000 not null,
	is_posted				boolean default false not null,
	loan_approval			boolean default false not null,
	gl_payroll_account		varchar(32),
	gl_bank_account			varchar(32),
	gl_advance_account		varchar(32),

	bank_header				text,
	bank_address			text,

    entity_id 				integer references entitys,
	application_date		timestamp default now(),
	approve_status			varchar(16) default 'Draft' not null,
	workflow_table_id		integer,
	action_date				timestamp,

	details					text,
	UNIQUE(org_id, start_date)
);
CREATE INDEX periods_fiscal_year_id ON periods (fiscal_year_id);
CREATE INDEX periods_org_id ON periods (org_id);

--- Views
CREATE VIEW vw_curr_orgs AS
	SELECT currency.currency_id as base_currency_id, currency.currency_name as base_currency_name,
		currency.currency_symbol as base_currency_symbol,
		orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo,
		orgs.cert_number, orgs.pin, orgs.vat_number, orgs.invoice_footer,
		orgs.details
	FROM orgs INNER JOIN currency ON orgs.currency_id = currency.currency_id;




CREATE VIEW vw_bank_branch AS
	SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_code, sys_countrys.sys_country_name,
		banks.bank_id, banks.bank_name, banks.bank_code, banks.swift_code,  banks.sort_code,
		bank_branch.bank_branch_id, bank_branch.org_id, bank_branch.bank_branch_name,
		bank_branch.bank_branch_code, bank_branch.narrative
	FROM bank_branch INNER JOIN banks ON bank_branch.bank_id = banks.bank_id
		LEFT JOIN sys_countrys ON banks.sys_country_id = sys_countrys.sys_country_id;

CREATE VIEW vw_departments AS
	SELECT departments.ln_department_id, p_departments.department_name as ln_department_name,
		departments.department_id, departments.org_id, departments.department_name, departments.active, departments.description,
		departments.duties, departments.reports, departments.details
	FROM departments LEFT JOIN departments as p_departments ON departments.ln_department_id = p_departments.department_id;

CREATE VIEW vw_periods AS
	SELECT fiscal_years.fiscal_year_id, fiscal_years.fiscal_year_start, fiscal_years.fiscal_year_end,
		fiscal_years.year_opened, fiscal_years.year_closed,

		periods.period_id, periods.org_id,
		periods.start_date, periods.end_date, periods.opened, periods.activated, periods.closed,
		periods.overtime_rate, periods.per_diem_tax_limit, periods.is_posted,
		periods.gl_payroll_account, periods.gl_bank_account, periods.gl_advance_account,
		periods.bank_header, periods.bank_address, periods.details,

		date_part('month', periods.start_date) as month_id, to_char(periods.start_date, 'YYYY') as period_year,
		to_char(periods.start_date, 'Month') as period_month, (trunc((date_part('month', periods.start_date)-1)/3)+1) as quarter,
		(trunc((date_part('month', periods.start_date)-1)/6)+1) as semister,
		to_char(periods.start_date, 'YYYYMM') as period_code
	FROM periods LEFT JOIN fiscal_years ON periods.fiscal_year_id = fiscal_years.fiscal_year_id
	ORDER BY periods.start_date;

CREATE VIEW vw_period_year AS
	SELECT org_id, period_year
	FROM vw_periods
	GROUP BY org_id, period_year
	ORDER BY period_year;

CREATE VIEW vw_period_quarter AS
	SELECT org_id, quarter
	FROM vw_periods
	GROUP BY org_id, quarter
	ORDER BY quarter;

CREATE VIEW vw_period_semister AS
	SELECT org_id, semister
	FROM vw_periods
	GROUP BY org_id, semister
	ORDER BY semister;

CREATE VIEW vw_period_month AS
	SELECT org_id, month_id, period_year, period_month
	FROM vw_periods
	GROUP BY org_id, month_id, period_year, period_month
	ORDER BY month_id, period_year, period_month;

CREATE OR REPLACE FUNCTION ins_fiscal_years() RETURNS trigger AS $$
BEGIN
	INSERT INTO periods (fiscal_year_id, org_id, start_date, end_date)
	SELECT NEW.fiscal_year_id, NEW.org_id, period_start, CAST(period_start + CAST('1 month' as interval) as date) - 1
	FROM (SELECT CAST(generate_series(fiscal_year_start, fiscal_year_end, '1 month') as date) as period_start
		FROM fiscal_years WHERE fiscal_year_id = NEW.fiscal_year_id) as a;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_fiscal_years AFTER INSERT ON fiscal_years
    FOR EACH ROW EXECUTE PROCEDURE ins_fiscal_years();

CREATE OR REPLACE FUNCTION ins_periods() RETURNS trigger AS $$
DECLARE
	year_close 		BOOLEAN;
BEGIN
	SELECT year_closed INTO year_close
	FROM fiscal_years
	WHERE (fiscal_year_id = NEW.fiscal_year_id);

	IF(TG_OP = 'UPDATE')THEN
		IF (OLD.closed = true) AND (NEW.closed = false) THEN
			NEW.approve_status := 'Draft';
		END IF;
	END IF;

	IF (NEW.approve_status = 'Approved') THEN
		NEW.opened = false;
		NEW.activated = false;
		NEW.closed = true;
	END IF;

	IF(year_close = true)THEN
		RAISE EXCEPTION 'The year is closed not transactions are allowed.';
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_periods BEFORE INSERT OR UPDATE ON periods
    FOR EACH ROW EXECUTE PROCEDURE ins_periods();

------------Hooks to approval trigger
CREATE TRIGGER upd_action BEFORE INSERT OR UPDATE ON periods
    FOR EACH ROW EXECUTE PROCEDURE upd_action();
