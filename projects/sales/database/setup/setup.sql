--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: root
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO root;

SET search_path = public, pg_catalog;

--
-- Name: change_password(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION change_password(integer, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	old_password varchar(64);
	passchange varchar(120);
BEGIN
	passchange := 'Password Error';
	SELECT Entity_password INTO old_password
	FROM entitys WHERE (entity_ID = $1);

	IF ($2 is null) THEN
		passchange := first_password();
		UPDATE entitys SET first_password = passchange, Entity_password = md5(passchange) WHERE (entity_ID = $1);
		passchange := 'Password Changed';
	ELSIF (old_password = md5($2)) THEN
		UPDATE entitys SET Entity_password = md5($3) WHERE (entity_ID = $1);
		passchange := 'Password Changed';
	ELSE
		passchange := 'Password Changing Error Ensure you have correct details';
	END IF;

	return passchange;
END;
$_$;


ALTER FUNCTION public.change_password(integer, character varying, character varying) OWNER TO root;

--
-- Name: emailed(integer, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION emailed(integer, character varying) RETURNS void
    LANGUAGE sql
    AS $_$
    UPDATE sys_emailed SET emailed = true WHERE (sys_emailed_id = CAST($2 as int));
$_$;


ALTER FUNCTION public.emailed(integer, character varying) OWNER TO root;

--
-- Name: first_password(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION first_password() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	rnd integer;
	passchange varchar(12);
BEGIN
	passchange := trunc(random()*1000);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);
	passchange := passchange || trunc(random()*1000);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);
	rnd := trunc(65+random()*25);
	passchange := passchange || chr(rnd);

	return passchange;
END;
$$;


ALTER FUNCTION public.first_password() OWNER TO root;

--
-- Name: getadjustment(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION getadjustment(integer, integer, integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
	adjustment float;
BEGIN

	IF ($3 = 1) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2);
	ELSIF ($3 = 2) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (In_payroll = true) AND (Visible = true);
	ELSIF ($3 = 3) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (In_Tax = true);
	ELSIF ($3 = 4) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (In_payroll = true);
	ELSIF ($3 = 5) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (adjustment_type = $2) AND (Visible = true);
	ELSIF ($3 = 11) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Tax_Types
		WHERE (Employee_Month_ID = $1);
	ELSIF ($3 = 12) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Tax_Types
		WHERE (Employee_Month_ID = $1) AND (In_Tax = true);
	ELSIF ($3 = 14) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Tax_Types
		WHERE (Employee_Month_ID = $1) AND (Tax_Type_ID = $2);
	ELSIF ($3 = 21) THEN
		SELECT SUM(Amount * adjustment_factor) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (In_Tax = true);
	ELSIF ($3 = 22) THEN
		SELECT SUM(Amount * adjustment_factor) INTO adjustment
		FROM Employee_Adjustments
		WHERE (Employee_Month_ID = $1) AND (In_payroll = true) AND (Visible = true);
	ELSIF ($3 = 31) THEN
		SELECT SUM(OverTime * OverTime_Rate) INTO adjustment
		FROM Employee_Overtime
		WHERE (Employee_Month_ID = $1) AND (Approved = true);
	ELSIF ($3 = 32) THEN
		SELECT SUM(tax_amount) INTO adjustment
		FROM Employee_Per_Diem
		WHERE (Employee_Month_ID = $1) AND (Approved = true);
	ELSIF ($3 = 33) THEN
		SELECT SUM(Per_Diem -  Cash_paid) INTO adjustment
		FROM Employee_Per_Diem
		WHERE (Employee_Month_ID = $1) AND (Approved = true);
	ELSIF ($3 = 34) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Employee_Advances
		WHERE (Employee_Month_ID = $1) AND (in_payroll = true);
	ELSIF ($3 = 35) THEN
		SELECT SUM(Amount) INTO adjustment
		FROM Advance_Deductions
		WHERE (Employee_Month_ID = $1) AND (In_payroll = true);
	ELSE
		adjustment := 0;
	END IF;

	IF(adjustment is null) THEN
		adjustment := 0;
	END IF;

	RETURN adjustment;
END;
$_$;


ALTER FUNCTION public.getadjustment(integer, integer, integer) OWNER TO root;

--
-- Name: getadjustment(integer, integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION getadjustment(integer, integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
	adjustment float;
BEGIN

	IF ($2 = 1) THEN
		SELECT (Basic_Pay + getAdjustment(Employee_Month_ID, 4, 31) + getAdjustment(Employee_Month_ID, 4, 21) 
			+ getAdjustment(Employee_Month_ID, 4, 32)) INTO adjustment
		FROM Employee_Month
		WHERE (Employee_Month_ID = $1);
	ELSIF ($2 = 2) THEN
		SELECT (Basic_Pay + getAdjustment(Employee_Month_ID, 4, 31) + getAdjustment(Employee_Month_ID, 4, 21) 
			+ getAdjustment(Employee_Month_ID, 4, 32) - getAdjustment(Employee_Month_ID, 4, 12)) INTO adjustment
		FROM Employee_Month
		WHERE (Employee_Month_ID = $1);
	ELSE
		adjustment := 0;
	END IF;

	IF(adjustment is null) THEN
		adjustment := 0;
	END IF;

	RETURN adjustment;
END;
$_$;


ALTER FUNCTION public.getadjustment(integer, integer) OWNER TO root;

--
-- Name: gettax(double precision, integer, integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION gettax(double precision, integer, integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
	reca RECORD;
	tax REAL;
BEGIN
	SELECT period_tax_type_id, Formural, tax_relief, percentage, linear, In_Tax, Employer, Employer_PS INTO reca
	FROM period_tax_types
	WHERE (period_id = $2) AND (Tax_Type_ID = $3);

	IF(reca.linear = true) THEN
		SELECT SUM(CASE WHEN tax_range < $1 
		THEN (tax_rate / 100) * (tax_range - getTaxMin(tax_range, reca.period_tax_type_id)) 
		ELSE (tax_rate / 100) * ($1 - getTaxMin(tax_range, reca.period_tax_type_id)) END) INTO tax
		FROM period_tax_rates 
		WHERE (getTaxMin(tax_range, reca.period_tax_type_id) <= $1) AND (period_tax_type_id = reca.period_tax_type_id);
	ELSIF(reca.linear = false) THEN 
		SELECT max(tax_rate) INTO tax
		FROM period_tax_rates 
		WHERE (getTaxMin(tax_range, reca.period_tax_type_id) < $1) AND (tax_range >= $1) 
			AND (period_tax_type_id = reca.period_tax_type_id);
	END IF;

	IF (tax > reca.tax_relief) THEN
		tax := tax - reca.tax_relief;
	END IF;

	RETURN tax;
END;
$_$;


ALTER FUNCTION public.gettax(double precision, integer, integer) OWNER TO root;

--
-- Name: gettaxmin(double precision, integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION gettaxmin(double precision, integer) RETURNS double precision
    LANGUAGE sql
    AS $_$
	SELECT CASE WHEN max(tax_range) is null THEN 0 ELSE max(tax_range) END 
	FROM period_tax_rates WHERE (tax_range < $1) AND (period_tax_type_id = $2);
$_$;


ALTER FUNCTION public.gettaxmin(double precision, integer) OWNER TO root;

--
-- Name: ins_applicant(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_applicant() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	rec RECORD;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF(NEW.entity_id IS NULL) THEN
			SELECT org_id INTO rec
			FROM orgs WHERE (is_default = true);

			NEW.entity_id := nextval('entitys_entity_id_seq');

			INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, Function_Role)
			VALUES (NEW.entity_id, rec.org_id, 4, 
				(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
				lower(NEW.Applicant_EMail), 'applicant');
		END IF;

		INSERT INTO sys_emailed (sys_email_id, table_id, table_name, email_level)
		VALUES (1, NEW.entity_id, 'applicant', 1);
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.ins_applicant() OWNER TO root;

--
-- Name: ins_applications(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_applications(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	rec RECORD;
	msg varchar(120);
BEGIN
	SELECT application_id INTO rec
	FROM applications 
	WHERE (intake_ID = CAST($1 as int)) AND (entity_ID = CAST($2 as int));

	IF rec.application_id is null THEN
		INSERT INTO applications (intake_ID, entity_ID)
		VALUES (CAST($1 as int), CAST($2 as int));
		msg := 'Added Job application';
	ELSE
		msg := 'There is another application for the post.';
	END IF;

	return msg;
END;
$_$;


ALTER FUNCTION public.ins_applications(character varying, character varying, character varying) OWNER TO root;

--
-- Name: ins_employee_month(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_employee_month() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Employee_Tax_Types (Employee_Month_ID, Tax_Type_ID, tax_identification, Additional, Amount, Employer, In_Tax)
	SELECT NEW.Employee_Month_ID, Default_Tax_Types.Tax_Type_ID, Default_Tax_Types.Tax_Identification, 
		Default_Tax_Types.Additional, 0, 0, Tax_Types.In_Tax
	FROM Default_Tax_Types INNER JOIN Tax_Types ON Default_Tax_Types.Tax_Type_id = Tax_Types.Tax_Type_id
	WHERE (Default_Tax_Types.active = true) AND (Default_Tax_Types.entity_ID = NEW.entity_ID);

	INSERT INTO Employee_Adjustments (Employee_Month_ID, Adjustment_ID, Amount, adjustment_type, In_payroll, In_Tax, Visible, adjustment_factor)
	SELECT NEW.Employee_Month_ID, Default_Adjustments.Adjustment_ID, Default_Adjustments.Amount,
		adjustments.adjustment_type, adjustments.In_payroll, adjustments.In_Tax, adjustments.Visible,
		(CASE WHEN adjustments.adjustment_type = 2 THEN -1 ELSE 1 END)
	FROM Default_Adjustments INNER JOIN adjustments ON Default_Adjustments.Adjustment_ID = adjustments.Adjustment_ID
	WHERE ((Default_Adjustments.final_date is null) OR (Default_Adjustments.final_date > current_date))
		AND (Default_Adjustments.active = true) AND (Default_Adjustments.entity_ID = NEW.entity_ID);

	INSERT INTO Advance_Deductions (Amount, Employee_Month_ID)
	SELECT (Amount / Pay_Period), NEW.Employee_Month_ID
	FROM Employee_Advances
	WHERE (Employee_Month_ID = NEW.Employee_Month_ID) AND (Pay_Period > 0) AND (completed = false)
		AND (Pay_upto >= current_date);

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.ins_employee_month() OWNER TO root;

--
-- Name: ins_employees(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_employees() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	rec RECORD;
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF(NEW.entity_id IS NULL) THEN
			SELECT org_id INTO rec
			FROM orgs WHERE (is_default = true);	

			NEW.entity_id := nextval('entitys_entity_id_seq');

			IF(NEW.Employee_ID is null) THEN
				NEW.Employee_ID := NEW.entity_id;
			END IF;

			INSERT INTO entitys (entity_id, org_id, entity_type_id, entity_name, User_name, Function_Role)
			VALUES (NEW.entity_id, rec.org_id, 1, 
				(NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, '')),
				lower(substring(NEW.First_name from 1 for 1) || NEW.Surname), 'staff');
		END IF;
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE entitys  SET entity_name = (NEW.Surname || ' ' || NEW.First_name || ' ' || COALESCE(NEW.Middle_name, ''))
		WHERE entity_id = NEW.entity_id;
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.ins_employees() OWNER TO root;

--
-- Name: ins_entitys(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_entitys() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN	
	IF(NEW.entity_type_id is not null) THEN
		INSERT INTO Entity_subscriptions (entity_type_id, entity_id)
		VALUES (NEW.entity_type_id, NEW.entity_id);
	END IF;

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.ins_entitys() OWNER TO root;

--
-- Name: ins_entry_form(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_entry_form(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	rec RECORD;
	formName varchar(120);
	msg varchar(120);
BEGIN
	SELECT entry_form_id INTO rec
	FROM entry_forms 
	WHERE (form_id = CAST($1 as int)) AND (entity_ID = CAST($2 as int))
		AND (completed = '0');

	SELECT form_name INTO formName FROM forms WHERE (form_id = CAST($1 as int));

	IF rec.entry_form_id is null THEN
		INSERT INTO entry_forms (form_id, entity_id) VALUES (CAST($1 as int), CAST($2 as int));
		msg := 'Added Form : ' || formName;
	ELSE
		msg := 'There is an incomplete form : ' || formName;
	END IF;

	return msg;
END;
$_$;


ALTER FUNCTION public.ins_entry_form(character varying, character varying, character varying) OWNER TO root;

--
-- Name: ins_interns(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_interns(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	rec RECORD;
	msg varchar(120);
BEGIN
	SELECT interns_id INTO rec
	FROM interns 
	WHERE (internship_ID = CAST($1 as int)) AND (entity_ID = CAST($2 as int));

	IF rec.application_id is null THEN
		INSERT INTO interns (internship_ID, entity_ID)
		VALUES (CAST($1 as int), CAST($2 as int));
		msg := 'Added internship application';
	ELSE
		msg := 'There is another application for the internship.';
	END IF;

	return msg;
END;
$_$;


ALTER FUNCTION public.ins_interns(character varying, character varying, character varying) OWNER TO root;

--
-- Name: ins_password(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_password() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.first_password := first_password();
	NEW.Entity_password := md5(NEW.first_password);

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.ins_password() OWNER TO root;

--
-- Name: ins_period_tax_types(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_period_tax_types() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Period_Tax_Rates (Period_Tax_Type_ID, Tax_Range, Tax_Rate)
	SELECT NEW.Period_Tax_Type_ID, Tax_Range, Tax_Rate
	FROM Tax_Rates
	WHERE (Tax_Type_ID = NEW.Tax_Type_ID);

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.ins_period_tax_types() OWNER TO root;

--
-- Name: ins_periods(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_periods() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Period_Tax_Types (Period_ID, Tax_Type_ID, Period_Tax_Type_Name, Formural, tax_relief, percentage, linear, Employer, Employer_PS, Tax_Type_order, In_Tax)
	SELECT NEW.Period_ID, Tax_Type_ID, Tax_Type_Name, Formural, tax_relief, percentage, linear, Employer, Employer_PS, Tax_Type_order, In_Tax
	FROM Tax_Types
	WHERE (active = true);

	INSERT INTO Employee_Month (Period_ID, pay_group_ID, Entity_ID, Bank_Branch_ID, Department_Role_ID, Bank_Account, Basic_Pay)
	SELECT NEW.Period_ID, 0, Entity_ID, Bank_Branch_ID, Department_Role_ID, Bank_Account, basic_salary
	FROM Employees
	WHERE (active = true);

	PERFORM updTax(employee_month_id, Period_id)
	FROM employee_month
	WHERE (period_id = NEW.period_id);

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.ins_periods() OWNER TO root;

--
-- Name: ins_taxes(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION ins_taxes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	INSERT INTO Default_Tax_Types (entity_ID, Tax_Type_ID)
	SELECT NEW.entity_ID, Tax_Type_ID
	FROM Tax_Types;

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.ins_taxes() OWNER TO root;

--
-- Name: process_payroll(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION process_payroll(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	rec RECORD;
	msg varchar(120);
BEGIN
	PERFORM updTax(employee_month_id, Period_id)
	FROM employee_month
	WHERE (period_id = CAST($1as int));

	msg := 'Payroll Processed';

	return msg;
END;
$_$;


ALTER FUNCTION public.process_payroll(character varying, character varying, character varying) OWNER TO root;

--
-- Name: upd_action(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION upd_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF ((NEW.approved = true) OR (NEW.rejected = true)) THEN
		NEW.action_date := now();
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.upd_action() OWNER TO root;

--
-- Name: upd_applications(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION upd_applications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	typeid	integer;
BEGIN
	IF (NEW.approved = true) THEN
		NEW.action_date := now();
		
		SELECT entity_type_id INTO typeid
		FROM entitys WHERE entity_id = NEW.entity_id;

		IF (typeid = 4) THEN
			SELECT Department_Role_id INTO typeid
			FROM intake WHERE intake_ID = NEW.intake_ID;

			INSERT INTO Employees (Department_Role_ID, entity_id, Surname, First_name, Middle_name, Date_of_birth, Gender,
				Nationality, Marital_status, Appointment_Date, Contract_Period, Employment_Terms, Identity_card, Basic_salary,
				Bank_Branch_ID, language, Interests, objective, Details)
			SELECT typeid, entity_id, Surname, First_name, Middle_name, Date_of_birth, Gender,
				Nationality, Marital_status, current_date, 3, 'Probation', Identity_card, 10000, 0, 
				language, Interests, objective, Details
			FROM Applicant
			WHERE entity_id = NEW.entity_id;

			UPDATE entitys SET entity_type_id  = 1 WHERE entity_id = NEW.entity_id;
			UPDATE entity_subscriptions SET entity_type_id  = 1 WHERE entity_id = NEW.entity_id;
		END IF;
	END IF;
	IF (NEW.rejected = true) THEN
		NEW.action_date := now();
	END IF;

	RETURN NEW;
END;
$$;


ALTER FUNCTION public.upd_applications() OWNER TO root;

--
-- Name: upd_complete_form(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION upd_complete_form(character varying, character varying, character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
	msg varchar(120);
BEGIN
	IF ($3 = '1') THEN
		UPDATE entry_forms SET completed = '1', completion_date	= now()
		WHERE (entry_form_id = CAST($1 as int));
		msg := 'Completed the form';
	ELSIF ($3 = '2') THEN
		UPDATE entry_forms SET approved = '1', approve_date = now()
		WHERE (entry_form_id = CAST($1 as int));
		msg := 'Approved the form';
	ELSIF ($3 = '3') THEN
		UPDATE entry_forms SET rejected = '1', approve_date = now()
		WHERE (entry_form_id = CAST($1 as int));
		msg := 'Rejected the form';
	END IF;

	return msg;
END;
$_$;


ALTER FUNCTION public.upd_complete_form(character varying, character varying, character varying) OWNER TO root;

--
-- Name: upd_employee_adjustments(); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION upd_employee_adjustments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	updatable boolean;
	entityid integer;
BEGIN
	SELECT monthly_update INTO updatable
	FROM adjustments WHERE Adjustment_ID = NEW.Adjustment_ID;

	SELECT Entity_ID INTO entityid
	FROM Employee_Month WHERE Employee_Month_ID = NEW.Employee_Month_ID;

	IF(updatable = true) THEN
		IF (OLD.Amount <> NEW.Amount) THEN
			UPDATE Default_Adjustments SET Amount = NEW.Amount WHERE (Entity_ID = entityid) AND (Adjustment_ID = NEW.Adjustment_ID);
		END IF;
	END IF;

	RETURN NULL;
END;
$$;


ALTER FUNCTION public.upd_employee_adjustments() OWNER TO root;

--
-- Name: updtax(integer, integer); Type: FUNCTION; Schema: public; Owner: root
--

CREATE FUNCTION updtax(integer, integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
	reca RECORD;
	income REAL;
	tax REAL;
BEGIN

	FOR reca IN SELECT Employee_Tax_Types.Employee_Tax_Type_ID, Employee_Tax_Types.Tax_Type_ID, Period_Tax_Types.Formural,
			 Period_Tax_Types.Employer_PS
		FROM Employee_Tax_Types INNER JOIN Period_Tax_Types ON (Employee_Tax_Types.Tax_Type_ID = Period_Tax_Types.Tax_Type_ID)
		WHERE (Employee_Month_ID = $1) AND (Period_Tax_Types.Period_ID = $2)
		ORDER BY Period_Tax_Types.Tax_Type_order LOOP

		EXECUTE 'SELECT ' || reca.Formural || ' FROM Employee_Month WHERE Employee_Month_ID = ' || $1 
		INTO income;

		UPDATE Employee_Tax_Types SET Amount = getTax(income, $2, reca.Tax_Type_ID),
			Employer = getTax(income, $2, reca.Tax_Type_ID) * reca.Employer_PS / 100
		WHERE Employee_Tax_Type_ID = reca.Employee_Tax_Type_ID;
	END LOOP;

	RETURN tax;
END;
$_$;


ALTER FUNCTION public.updtax(integer, integer) OWNER TO root;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE address (
    address_id integer NOT NULL,
    address_name character varying(50),
    sys_country_id character(2),
    table_name character varying(32),
    table_id integer,
    post_office_box character varying(50),
    postal_code character varying(12),
    premises character varying(120),
    street character varying(120),
    town character varying(50),
    phone_number character varying(150),
    extension character varying(15),
    mobile character varying(150),
    fax character varying(150),
    email character varying(120),
    is_default boolean,
    details text
);


ALTER TABLE public.address OWNER TO root;

--
-- Name: address_address_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE address_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.address_address_id_seq OWNER TO root;

--
-- Name: address_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE address_address_id_seq OWNED BY address.address_id;


--
-- Name: address_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('address_address_id_seq', 1, false);


--
-- Name: adjustments; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE adjustments (
    adjustment_id integer NOT NULL,
    adjustment_name character varying(50) NOT NULL,
    adjustment_type integer NOT NULL,
    adjustment_order integer DEFAULT 0 NOT NULL,
    formural character varying(430),
    monthly_update boolean DEFAULT true NOT NULL,
    in_payroll boolean DEFAULT true NOT NULL,
    in_tax boolean DEFAULT true NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    details text
);


ALTER TABLE public.adjustments OWNER TO root;

--
-- Name: adjustments_adjustment_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE adjustments_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.adjustments_adjustment_id_seq OWNER TO root;

--
-- Name: adjustments_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE adjustments_adjustment_id_seq OWNED BY adjustments.adjustment_id;


--
-- Name: adjustments_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('adjustments_adjustment_id_seq', 32, true);


--
-- Name: advance_deductions; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE advance_deductions (
    advance_deduction_id integer NOT NULL,
    employee_month_id integer,
    pay_date date DEFAULT ('now'::text)::date NOT NULL,
    amount double precision NOT NULL,
    in_payroll boolean DEFAULT true NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.advance_deductions OWNER TO root;

--
-- Name: advance_deductions_advance_deduction_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE advance_deductions_advance_deduction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.advance_deductions_advance_deduction_id_seq OWNER TO root;

--
-- Name: advance_deductions_advance_deduction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE advance_deductions_advance_deduction_id_seq OWNED BY advance_deductions.advance_deduction_id;


--
-- Name: advance_deductions_advance_deduction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('advance_deductions_advance_deduction_id_seq', 1, false);


--
-- Name: applicant; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE applicant (
    entity_id integer NOT NULL,
    surname character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    applicant_email character varying(50) NOT NULL,
    date_of_birth date,
    gender character varying(1),
    nationality character(2),
    marital_status character varying(2),
    identity_card character varying(50),
    language character varying(320),
    interests text,
    objective text,
    details text
);


ALTER TABLE public.applicant OWNER TO root;

--
-- Name: applications; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE applications (
    application_id integer NOT NULL,
    intake_id integer,
    entity_id integer,
    application_date timestamp without time zone DEFAULT now(),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    applicant_comments text,
    review text
);


ALTER TABLE public.applications OWNER TO root;

--
-- Name: applications_application_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE applications_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.applications_application_id_seq OWNER TO root;

--
-- Name: applications_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE applications_application_id_seq OWNED BY applications.application_id;


--
-- Name: applications_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('applications_application_id_seq', 1, false);


--
-- Name: approval_phases; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE approval_phases (
    approval_phase_id integer NOT NULL,
    table_name character varying(64),
    entity_type_id integer,
    approval_type_id integer,
    approval_level integer DEFAULT 1 NOT NULL,
    return_level integer DEFAULT 1 NOT NULL,
    escalation_time integer DEFAULT 3 NOT NULL,
    departmental boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.approval_phases OWNER TO root;

--
-- Name: approval_phases_approval_phase_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE approval_phases_approval_phase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.approval_phases_approval_phase_id_seq OWNER TO root;

--
-- Name: approval_phases_approval_phase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE approval_phases_approval_phase_id_seq OWNED BY approval_phases.approval_phase_id;


--
-- Name: approval_phases_approval_phase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('approval_phases_approval_phase_id_seq', 1, false);


--
-- Name: approval_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE approval_types (
    approval_type_id integer NOT NULL,
    approval_type_name character varying(50) NOT NULL,
    details text
);


ALTER TABLE public.approval_types OWNER TO root;

--
-- Name: approval_types_approval_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE approval_types_approval_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.approval_types_approval_type_id_seq OWNER TO root;

--
-- Name: approval_types_approval_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE approval_types_approval_type_id_seq OWNED BY approval_types.approval_type_id;


--
-- Name: approval_types_approval_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('approval_types_approval_type_id_seq', 1, false);


--
-- Name: approvals; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE approvals (
    approval_id integer NOT NULL,
    forward_id integer,
    table_id integer,
    approval_phase_id integer,
    entity_id integer,
    escalation_time integer DEFAULT 3 NOT NULL,
    application_date timestamp without time zone DEFAULT now() NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    narrative character varying(240),
    to_be_done text,
    what_is_done text,
    details text
);


ALTER TABLE public.approvals OWNER TO root;

--
-- Name: approvals_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE approvals_approval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.approvals_approval_id_seq OWNER TO root;

--
-- Name: approvals_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE approvals_approval_id_seq OWNED BY approvals.approval_id;


--
-- Name: approvals_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('approvals_approval_id_seq', 1, false);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE attendance (
    attendance_id integer NOT NULL,
    entity_id integer,
    attendance_date date,
    time_in time without time zone,
    time_out time without time zone,
    details text
);


ALTER TABLE public.attendance OWNER TO root;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE attendance_attendance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.attendance_attendance_id_seq OWNER TO root;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE attendance_attendance_id_seq OWNED BY attendance.attendance_id;


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('attendance_attendance_id_seq', 1, false);


--
-- Name: bank_branch; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE bank_branch (
    bank_branch_id integer NOT NULL,
    bank_id integer,
    bank_branch_name character varying(50) NOT NULL,
    bank_branch_code character varying(50),
    narrative character varying(240)
);


ALTER TABLE public.bank_branch OWNER TO root;

--
-- Name: bank_branch_bank_branch_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE bank_branch_bank_branch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.bank_branch_bank_branch_id_seq OWNER TO root;

--
-- Name: bank_branch_bank_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE bank_branch_bank_branch_id_seq OWNED BY bank_branch.bank_branch_id;


--
-- Name: bank_branch_bank_branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('bank_branch_bank_branch_id_seq', 11, true);


--
-- Name: banks; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE banks (
    bank_id integer NOT NULL,
    bank_name character varying(50) NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.banks OWNER TO root;

--
-- Name: banks_bank_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE banks_bank_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.banks_bank_id_seq OWNER TO root;

--
-- Name: banks_bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE banks_bank_id_seq OWNED BY banks.bank_id;


--
-- Name: banks_bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('banks_bank_id_seq', 5, true);


--
-- Name: case_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE case_types (
    case_type_id integer NOT NULL,
    case_type_name character varying(50),
    details text
);


ALTER TABLE public.case_types OWNER TO root;

--
-- Name: case_types_case_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE case_types_case_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.case_types_case_type_id_seq OWNER TO root;

--
-- Name: case_types_case_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE case_types_case_type_id_seq OWNED BY case_types.case_type_id;


--
-- Name: case_types_case_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('case_types_case_type_id_seq', 1, false);


--
-- Name: casual_application; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE casual_application (
    casual_application_id integer NOT NULL,
    department_id integer,
    casual_category_id integer,
    "position" integer DEFAULT 1 NOT NULL,
    work_duration integer DEFAULT 1 NOT NULL,
    approved_pay_rate real,
    application_date timestamp without time zone DEFAULT now(),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    details text
);


ALTER TABLE public.casual_application OWNER TO root;

--
-- Name: casual_application_casual_application_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE casual_application_casual_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.casual_application_casual_application_id_seq OWNER TO root;

--
-- Name: casual_application_casual_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE casual_application_casual_application_id_seq OWNED BY casual_application.casual_application_id;


--
-- Name: casual_application_casual_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('casual_application_casual_application_id_seq', 1, false);


--
-- Name: casual_category; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE casual_category (
    casual_category_id integer NOT NULL,
    casual_category_name character varying(50),
    details text
);


ALTER TABLE public.casual_category OWNER TO root;

--
-- Name: casual_category_casual_category_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE casual_category_casual_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.casual_category_casual_category_id_seq OWNER TO root;

--
-- Name: casual_category_casual_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE casual_category_casual_category_id_seq OWNED BY casual_category.casual_category_id;


--
-- Name: casual_category_casual_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('casual_category_casual_category_id_seq', 1, false);


--
-- Name: casuals; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE casuals (
    casual_id integer NOT NULL,
    entity_id integer,
    casual_application_id integer,
    start_date date,
    end_date date,
    duration integer,
    pay_rate real,
    amount_paid real,
    application_date timestamp without time zone DEFAULT now(),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    paid boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.casuals OWNER TO root;

--
-- Name: casuals_casual_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE casuals_casual_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.casuals_casual_id_seq OWNER TO root;

--
-- Name: casuals_casual_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE casuals_casual_id_seq OWNED BY casuals.casual_id;


--
-- Name: casuals_casual_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('casuals_casual_id_seq', 1, false);


--
-- Name: cv_projects; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE cv_projects (
    cv_projectid integer NOT NULL,
    entity_id integer,
    cv_project_name character varying(240),
    cv_project_date date NOT NULL,
    details text
);


ALTER TABLE public.cv_projects OWNER TO root;

--
-- Name: cv_projects_cv_projectid_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE cv_projects_cv_projectid_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cv_projects_cv_projectid_seq OWNER TO root;

--
-- Name: cv_projects_cv_projectid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE cv_projects_cv_projectid_seq OWNED BY cv_projects.cv_projectid;


--
-- Name: cv_projects_cv_projectid_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('cv_projects_cv_projectid_seq', 1, false);


--
-- Name: cv_referees; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE cv_referees (
    cv_referee_id integer NOT NULL,
    entity_id integer,
    cv_referee_name character varying(50),
    cv_referee_address text,
    details text
);


ALTER TABLE public.cv_referees OWNER TO root;

--
-- Name: cv_referees_cv_referee_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE cv_referees_cv_referee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cv_referees_cv_referee_id_seq OWNER TO root;

--
-- Name: cv_referees_cv_referee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE cv_referees_cv_referee_id_seq OWNED BY cv_referees.cv_referee_id;


--
-- Name: cv_referees_cv_referee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('cv_referees_cv_referee_id_seq', 1, false);


--
-- Name: cv_seminars; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE cv_seminars (
    cv_seminar_id integer NOT NULL,
    entity_id integer,
    cv_seminar_name character varying(240),
    cv_seminar_date date NOT NULL,
    details text
);


ALTER TABLE public.cv_seminars OWNER TO root;

--
-- Name: cv_seminars_cv_seminar_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE cv_seminars_cv_seminar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cv_seminars_cv_seminar_id_seq OWNER TO root;

--
-- Name: cv_seminars_cv_seminar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE cv_seminars_cv_seminar_id_seq OWNED BY cv_seminars.cv_seminar_id;


--
-- Name: cv_seminars_cv_seminar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('cv_seminars_cv_seminar_id_seq', 1, false);


--
-- Name: default_adjustments; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE default_adjustments (
    default_allowance_id integer NOT NULL,
    entity_id integer,
    adjustment_id integer,
    amount double precision NOT NULL,
    final_date date,
    active boolean DEFAULT true,
    narrative character varying(240)
);


ALTER TABLE public.default_adjustments OWNER TO root;

--
-- Name: default_adjustments_default_allowance_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE default_adjustments_default_allowance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.default_adjustments_default_allowance_id_seq OWNER TO root;

--
-- Name: default_adjustments_default_allowance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE default_adjustments_default_allowance_id_seq OWNED BY default_adjustments.default_allowance_id;


--
-- Name: default_adjustments_default_allowance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('default_adjustments_default_allowance_id_seq', 1, false);


--
-- Name: default_tax_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE default_tax_types (
    default_tax_type_id integer NOT NULL,
    entity_id integer,
    tax_type_id integer,
    tax_identification character varying(50),
    narrative character varying(240),
    additional double precision DEFAULT 0 NOT NULL,
    active boolean DEFAULT true
);


ALTER TABLE public.default_tax_types OWNER TO root;

--
-- Name: default_tax_types_default_tax_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE default_tax_types_default_tax_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.default_tax_types_default_tax_type_id_seq OWNER TO root;

--
-- Name: default_tax_types_default_tax_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE default_tax_types_default_tax_type_id_seq OWNED BY default_tax_types.default_tax_type_id;


--
-- Name: default_tax_types_default_tax_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('default_tax_types_default_tax_type_id_seq', 1, false);


--
-- Name: department_roles; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE department_roles (
    department_role_id integer NOT NULL,
    department_id integer,
    ln_department_role_id integer,
    department_role_name character varying(240) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    job_description text,
    job_requirements text,
    duties text,
    performance_measures text,
    details text
);


ALTER TABLE public.department_roles OWNER TO root;

--
-- Name: department_roles_department_role_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE department_roles_department_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.department_roles_department_role_id_seq OWNER TO root;

--
-- Name: department_roles_department_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE department_roles_department_role_id_seq OWNED BY department_roles.department_role_id;


--
-- Name: department_roles_department_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('department_roles_department_role_id_seq', 9, true);


--
-- Name: departments; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE departments (
    department_id integer NOT NULL,
    ln_department_id integer,
    department_name character varying(120),
    active boolean DEFAULT true NOT NULL,
    description text,
    duties text,
    reports text,
    details text
);


ALTER TABLE public.departments OWNER TO root;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE departments_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.departments_department_id_seq OWNER TO root;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE departments_department_id_seq OWNED BY departments.department_id;


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('departments_department_id_seq', 15, true);


--
-- Name: education; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE education (
    education_id integer NOT NULL,
    entity_id integer,
    education_class_id integer,
    date_from date,
    date_to date,
    name_of_school character varying(240),
    examination_taken character varying(240),
    grades_obtained character varying(50),
    details text
);


ALTER TABLE public.education OWNER TO root;

--
-- Name: education_class; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE education_class (
    education_class_id integer NOT NULL,
    education_class_name character varying(50),
    details text
);


ALTER TABLE public.education_class OWNER TO root;

--
-- Name: education_class_education_class_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE education_class_education_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.education_class_education_class_id_seq OWNER TO root;

--
-- Name: education_class_education_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE education_class_education_class_id_seq OWNED BY education_class.education_class_id;


--
-- Name: education_class_education_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('education_class_education_class_id_seq', 1, false);


--
-- Name: education_education_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE education_education_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.education_education_id_seq OWNER TO root;

--
-- Name: education_education_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE education_education_id_seq OWNED BY education.education_id;


--
-- Name: education_education_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('education_education_id_seq', 1, false);


--
-- Name: employee_adjustments; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_adjustments (
    employee_allowance_id integer NOT NULL,
    employee_month_id integer,
    adjustment_id integer,
    adjustment_type integer,
    adjustment_factor integer DEFAULT 1 NOT NULL,
    pay_date date DEFAULT ('now'::text)::date NOT NULL,
    amount double precision NOT NULL,
    in_payroll boolean DEFAULT true NOT NULL,
    in_tax boolean DEFAULT true NOT NULL,
    visible boolean DEFAULT true NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.employee_adjustments OWNER TO root;

--
-- Name: employee_adjustments_employee_allowance_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_adjustments_employee_allowance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_adjustments_employee_allowance_id_seq OWNER TO root;

--
-- Name: employee_adjustments_employee_allowance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_adjustments_employee_allowance_id_seq OWNED BY employee_adjustments.employee_allowance_id;


--
-- Name: employee_adjustments_employee_allowance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_adjustments_employee_allowance_id_seq', 1, false);


--
-- Name: employee_advances; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_advances (
    employee_advance_id integer NOT NULL,
    employee_month_id integer,
    pay_date date DEFAULT ('now'::text)::date NOT NULL,
    pay_upto date NOT NULL,
    pay_period integer DEFAULT 3 NOT NULL,
    amount double precision NOT NULL,
    in_payroll boolean DEFAULT false NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    narrative character varying(240)
);


ALTER TABLE public.employee_advances OWNER TO root;

--
-- Name: employee_advances_employee_advance_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_advances_employee_advance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_advances_employee_advance_id_seq OWNER TO root;

--
-- Name: employee_advances_employee_advance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_advances_employee_advance_id_seq OWNED BY employee_advances.employee_advance_id;


--
-- Name: employee_advances_employee_advance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_advances_employee_advance_id_seq', 1, false);


--
-- Name: employee_cases; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_cases (
    employee_case_id integer NOT NULL,
    case_type_id integer,
    entity_id integer,
    narrative character varying(240),
    case_date date,
    complaint text,
    case_action text,
    completed boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.employee_cases OWNER TO root;

--
-- Name: employee_cases_employee_case_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_cases_employee_case_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_cases_employee_case_id_seq OWNER TO root;

--
-- Name: employee_cases_employee_case_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_cases_employee_case_id_seq OWNED BY employee_cases.employee_case_id;


--
-- Name: employee_cases_employee_case_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_cases_employee_case_id_seq', 1, false);


--
-- Name: employee_leave; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_leave (
    employee_leave_id integer NOT NULL,
    entity_id integer,
    leave_type_id integer,
    leave_from date NOT NULL,
    leave_to date NOT NULL,
    leave_days integer,
    start_half_day boolean DEFAULT false NOT NULL,
    end_half_day boolean DEFAULT false NOT NULL,
    application_date timestamp without time zone DEFAULT now(),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    completed boolean DEFAULT false NOT NULL,
    narrative character varying(240),
    details text
);


ALTER TABLE public.employee_leave OWNER TO root;

--
-- Name: employee_leave_employee_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_leave_employee_leave_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_leave_employee_leave_id_seq OWNER TO root;

--
-- Name: employee_leave_employee_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_leave_employee_leave_id_seq OWNED BY employee_leave.employee_leave_id;


--
-- Name: employee_leave_employee_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_leave_employee_leave_id_seq', 1, false);


--
-- Name: employee_month; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_month (
    employee_month_id integer NOT NULL,
    entity_id integer,
    period_id integer,
    bank_branch_id integer,
    pay_group_id integer,
    department_role_id integer,
    bank_account character varying(32),
    basic_pay double precision DEFAULT 0 NOT NULL,
    details text
);


ALTER TABLE public.employee_month OWNER TO root;

--
-- Name: employee_month_employee_month_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_month_employee_month_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_month_employee_month_id_seq OWNER TO root;

--
-- Name: employee_month_employee_month_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_month_employee_month_id_seq OWNED BY employee_month.employee_month_id;


--
-- Name: employee_month_employee_month_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_month_employee_month_id_seq', 1, false);


--
-- Name: employee_overtime; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_overtime (
    employee_overtime_id integer NOT NULL,
    employee_month_id integer,
    overtime_date date NOT NULL,
    overtime double precision NOT NULL,
    overtime_rate double precision NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    narrative character varying(240),
    details text
);


ALTER TABLE public.employee_overtime OWNER TO root;

--
-- Name: employee_overtime_employee_overtime_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_overtime_employee_overtime_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_overtime_employee_overtime_id_seq OWNER TO root;

--
-- Name: employee_overtime_employee_overtime_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_overtime_employee_overtime_id_seq OWNED BY employee_overtime.employee_overtime_id;


--
-- Name: employee_overtime_employee_overtime_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_overtime_employee_overtime_id_seq', 1, false);


--
-- Name: employee_per_diem; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_per_diem (
    employee_per_diem_id integer NOT NULL,
    employee_month_id integer,
    travel_date date NOT NULL,
    return_date date NOT NULL,
    days_travelled integer NOT NULL,
    per_diem double precision DEFAULT 0 NOT NULL,
    cash_paid double precision DEFAULT 0 NOT NULL,
    tax_amount double precision DEFAULT 0 NOT NULL,
    travel_to character varying(240),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    completed boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.employee_per_diem OWNER TO root;

--
-- Name: employee_per_diem_employee_per_diem_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_per_diem_employee_per_diem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_per_diem_employee_per_diem_id_seq OWNER TO root;

--
-- Name: employee_per_diem_employee_per_diem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_per_diem_employee_per_diem_id_seq OWNED BY employee_per_diem.employee_per_diem_id;


--
-- Name: employee_per_diem_employee_per_diem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_per_diem_employee_per_diem_id_seq', 1, false);


--
-- Name: employee_tax_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employee_tax_types (
    employee_tax_type_id integer NOT NULL,
    employee_month_id integer,
    tax_type_id integer,
    tax_identification character varying(50),
    in_tax boolean DEFAULT false NOT NULL,
    amount double precision DEFAULT 0 NOT NULL,
    additional double precision DEFAULT 0 NOT NULL,
    employer double precision DEFAULT 0 NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.employee_tax_types OWNER TO root;

--
-- Name: employee_tax_types_employee_tax_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employee_tax_types_employee_tax_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employee_tax_types_employee_tax_type_id_seq OWNER TO root;

--
-- Name: employee_tax_types_employee_tax_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employee_tax_types_employee_tax_type_id_seq OWNED BY employee_tax_types.employee_tax_type_id;


--
-- Name: employee_tax_types_employee_tax_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employee_tax_types_employee_tax_type_id_seq', 1, false);


--
-- Name: employees; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employees (
    entity_id integer NOT NULL,
    employee_id character varying(12),
    department_role_id integer,
    surname character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    date_of_birth date,
    gender character varying(1),
    nationality character(2),
    marital_status character varying(2),
    appointment_date date,
    exit_date date,
    contract boolean DEFAULT false NOT NULL,
    contract_period integer NOT NULL,
    employment_terms character varying(320),
    identity_card character varying(50),
    basic_salary real,
    bank_branch_id integer,
    bank_account character varying(32),
    active boolean DEFAULT true NOT NULL,
    language character varying(320),
    interests text,
    objective text,
    details text
);


ALTER TABLE public.employees OWNER TO root;

--
-- Name: employment; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE employment (
    employment_id integer NOT NULL,
    entity_id integer,
    date_from date,
    date_to date,
    employers_name character varying(240),
    position_held character varying(240),
    details text
);


ALTER TABLE public.employment OWNER TO root;

--
-- Name: employment_employment_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE employment_employment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.employment_employment_id_seq OWNER TO root;

--
-- Name: employment_employment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE employment_employment_id_seq OWNED BY employment.employment_id;


--
-- Name: employment_employment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('employment_employment_id_seq', 1, false);


--
-- Name: entiry_refs; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE entiry_refs (
    entiry_ref_id integer NOT NULL,
    entity_id integer,
    ref_entity_id integer,
    narrative character varying(240),
    details text
);


ALTER TABLE public.entiry_refs OWNER TO root;

--
-- Name: entiry_refs_entiry_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE entiry_refs_entiry_ref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entiry_refs_entiry_ref_id_seq OWNER TO root;

--
-- Name: entiry_refs_entiry_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE entiry_refs_entiry_ref_id_seq OWNED BY entiry_refs.entiry_ref_id;


--
-- Name: entiry_refs_entiry_ref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('entiry_refs_entiry_ref_id_seq', 1, false);


--
-- Name: entity_subscriptions; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE entity_subscriptions (
    entity_subscription_id integer NOT NULL,
    entity_type_id integer,
    entity_id integer,
    details text
);


ALTER TABLE public.entity_subscriptions OWNER TO root;

--
-- Name: entity_subscriptions_entity_subscription_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE entity_subscriptions_entity_subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entity_subscriptions_entity_subscription_id_seq OWNER TO root;

--
-- Name: entity_subscriptions_entity_subscription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE entity_subscriptions_entity_subscription_id_seq OWNED BY entity_subscriptions.entity_subscription_id;


--
-- Name: entity_subscriptions_entity_subscription_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('entity_subscriptions_entity_subscription_id_seq', 1, false);


--
-- Name: entity_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE entity_types (
    entity_type_id integer NOT NULL,
    entity_type_name character varying(50),
    entity_role character varying(240),
    description text,
    details text
);


ALTER TABLE public.entity_types OWNER TO root;

--
-- Name: entity_types_entity_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE entity_types_entity_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entity_types_entity_type_id_seq OWNER TO root;

--
-- Name: entity_types_entity_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE entity_types_entity_type_id_seq OWNED BY entity_types.entity_type_id;


--
-- Name: entity_types_entity_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('entity_types_entity_type_id_seq', 1, false);


--
-- Name: entitys; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE entitys (
    entity_id integer NOT NULL,
    org_id integer,
    entity_type_id integer,
    entity_name character varying(120) NOT NULL,
    user_name character varying(32),
    super_user boolean DEFAULT false NOT NULL,
    entity_leader boolean DEFAULT false,
    function_role character varying(240),
    date_enroled timestamp without time zone DEFAULT now(),
    is_active boolean DEFAULT true,
    entity_password character varying(32) DEFAULT md5('enter'::text) NOT NULL,
    first_password character varying(32) DEFAULT 'enter'::character varying NOT NULL,
    details text
);


ALTER TABLE public.entitys OWNER TO root;

--
-- Name: entitys_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE entitys_entity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entitys_entity_id_seq OWNER TO root;

--
-- Name: entitys_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE entitys_entity_id_seq OWNED BY entitys.entity_id;


--
-- Name: entitys_entity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('entitys_entity_id_seq', 1, false);


--
-- Name: entry_forms; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE entry_forms (
    entry_form_id integer NOT NULL,
    entity_id integer,
    form_id integer,
    completed character(1) DEFAULT '0'::bpchar NOT NULL,
    approved character(1) DEFAULT '0'::bpchar NOT NULL,
    rejected character(1) DEFAULT '0'::bpchar NOT NULL,
    application_date timestamp without time zone DEFAULT now() NOT NULL,
    completion_date timestamp without time zone,
    approve_date timestamp without time zone,
    narrative character varying(240),
    answer text,
    details text
);


ALTER TABLE public.entry_forms OWNER TO root;

--
-- Name: entry_forms_entry_form_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE entry_forms_entry_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entry_forms_entry_form_id_seq OWNER TO root;

--
-- Name: entry_forms_entry_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE entry_forms_entry_form_id_seq OWNED BY entry_forms.entry_form_id;


--
-- Name: entry_forms_entry_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('entry_forms_entry_form_id_seq', 1, false);


--
-- Name: entry_sub_forms; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE entry_sub_forms (
    entry_sub_form_id integer NOT NULL,
    entry_form_id integer,
    sub_field_id integer,
    answer text
);


ALTER TABLE public.entry_sub_forms OWNER TO root;

--
-- Name: entry_sub_forms_entry_sub_form_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE entry_sub_forms_entry_sub_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entry_sub_forms_entry_sub_form_id_seq OWNER TO root;

--
-- Name: entry_sub_forms_entry_sub_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE entry_sub_forms_entry_sub_form_id_seq OWNED BY entry_sub_forms.entry_sub_form_id;


--
-- Name: entry_sub_forms_entry_sub_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('entry_sub_forms_entry_sub_form_id_seq', 1, false);


--
-- Name: evaluation_points; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE evaluation_points (
    evaluation_point_id integer NOT NULL,
    job_review_id integer,
    review_point_id integer,
    points integer DEFAULT 0 NOT NULL,
    narrative character varying(240),
    details text
);


ALTER TABLE public.evaluation_points OWNER TO root;

--
-- Name: evaluation_points_evaluation_point_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE evaluation_points_evaluation_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.evaluation_points_evaluation_point_id_seq OWNER TO root;

--
-- Name: evaluation_points_evaluation_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE evaluation_points_evaluation_point_id_seq OWNED BY evaluation_points.evaluation_point_id;


--
-- Name: evaluation_points_evaluation_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('evaluation_points_evaluation_point_id_seq', 1, false);


--
-- Name: fields; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE fields (
    field_id integer NOT NULL,
    form_id integer,
    question text,
    field_lookup text,
    field_type character varying(25) NOT NULL,
    field_class character varying(25),
    field_bold character(1) DEFAULT '0'::bpchar NOT NULL,
    field_italics character(1) DEFAULT '0'::bpchar NOT NULL,
    field_order integer DEFAULT 1,
    share_line integer,
    field_size integer DEFAULT 25 NOT NULL,
    manditory character(1) DEFAULT '0'::bpchar NOT NULL,
    show character(1) DEFAULT '1'::bpchar
);


ALTER TABLE public.fields OWNER TO root;

--
-- Name: fields_field_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE fields_field_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fields_field_id_seq OWNER TO root;

--
-- Name: fields_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE fields_field_id_seq OWNED BY fields.field_id;


--
-- Name: fields_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('fields_field_id_seq', 1, false);


--
-- Name: forms; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE forms (
    form_id integer NOT NULL,
    org_id integer,
    form_name character varying(240) NOT NULL,
    form_number character varying(50),
    version character varying(25),
    completed character(1) DEFAULT '0'::bpchar NOT NULL,
    is_active character(1) DEFAULT '0'::bpchar NOT NULL,
    form_header text,
    form_footer text,
    details text
);


ALTER TABLE public.forms OWNER TO root;

--
-- Name: forms_form_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE forms_form_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.forms_form_id_seq OWNER TO root;

--
-- Name: forms_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE forms_form_id_seq OWNED BY forms.form_id;


--
-- Name: forms_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('forms_form_id_seq', 1, false);


--
-- Name: intake; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE intake (
    intake_id integer NOT NULL,
    department_role_id integer,
    opening_date date NOT NULL,
    closing_date date NOT NULL,
    positions integer,
    location character varying(50),
    details text
);


ALTER TABLE public.intake OWNER TO root;

--
-- Name: intake_intake_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE intake_intake_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.intake_intake_id_seq OWNER TO root;

--
-- Name: intake_intake_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE intake_intake_id_seq OWNED BY intake.intake_id;


--
-- Name: intake_intake_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('intake_intake_id_seq', 1, false);


--
-- Name: interns; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE interns (
    intern_id integer NOT NULL,
    internship_id integer,
    entity_id integer,
    payment_amount real,
    start_date date,
    end_date date,
    application_date timestamp without time zone DEFAULT now(),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    applicant_comments text,
    review text
);


ALTER TABLE public.interns OWNER TO root;

--
-- Name: interns_intern_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE interns_intern_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.interns_intern_id_seq OWNER TO root;

--
-- Name: interns_intern_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE interns_intern_id_seq OWNED BY interns.intern_id;


--
-- Name: interns_intern_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('interns_intern_id_seq', 1, false);


--
-- Name: internships; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE internships (
    internship_id integer NOT NULL,
    department_id integer,
    opening_date date NOT NULL,
    closing_date date NOT NULL,
    positions integer,
    location character varying(50),
    details text
);


ALTER TABLE public.internships OWNER TO root;

--
-- Name: internships_internship_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE internships_internship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.internships_internship_id_seq OWNER TO root;

--
-- Name: internships_internship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE internships_internship_id_seq OWNED BY internships.internship_id;


--
-- Name: internships_internship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('internships_internship_id_seq', 1, false);


--
-- Name: job_reviews; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE job_reviews (
    job_review_id integer NOT NULL,
    entity_id integer,
    total_points integer,
    review_date date,
    review_done boolean DEFAULT false NOT NULL,
    recomendation text,
    details text
);


ALTER TABLE public.job_reviews OWNER TO root;

--
-- Name: job_reviews_job_review_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE job_reviews_job_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.job_reviews_job_review_id_seq OWNER TO root;

--
-- Name: job_reviews_job_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE job_reviews_job_review_id_seq OWNED BY job_reviews.job_review_id;


--
-- Name: job_reviews_job_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('job_reviews_job_review_id_seq', 1, false);


--
-- Name: kin_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE kin_types (
    kin_type_id integer NOT NULL,
    kin_type_name character varying(50),
    details text
);


ALTER TABLE public.kin_types OWNER TO root;

--
-- Name: kin_types_kin_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE kin_types_kin_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.kin_types_kin_type_id_seq OWNER TO root;

--
-- Name: kin_types_kin_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE kin_types_kin_type_id_seq OWNED BY kin_types.kin_type_id;


--
-- Name: kin_types_kin_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('kin_types_kin_type_id_seq', 9, true);


--
-- Name: kins; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE kins (
    kin_id integer NOT NULL,
    entity_id integer,
    kin_type_id integer,
    full_names character varying(120),
    date_of_birth date,
    identification character varying(50),
    relation character varying(50),
    details text
);


ALTER TABLE public.kins OWNER TO root;

--
-- Name: kins_kin_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE kins_kin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.kins_kin_id_seq OWNER TO root;

--
-- Name: kins_kin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE kins_kin_id_seq OWNED BY kins.kin_id;


--
-- Name: kins_kin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('kins_kin_id_seq', 1, false);


--
-- Name: leave_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE leave_types (
    leave_type_id integer NOT NULL,
    leave_type_name character varying(50) NOT NULL,
    allowed_leave_days integer DEFAULT 1 NOT NULL,
    leave_days_span integer DEFAULT 1 NOT NULL,
    details text
);


ALTER TABLE public.leave_types OWNER TO root;

--
-- Name: leave_types_leave_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE leave_types_leave_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.leave_types_leave_type_id_seq OWNER TO root;

--
-- Name: leave_types_leave_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE leave_types_leave_type_id_seq OWNED BY leave_types.leave_type_id;


--
-- Name: leave_types_leave_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('leave_types_leave_type_id_seq', 1, false);


--
-- Name: leave_work_days; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE leave_work_days (
    leave_work_day_id integer NOT NULL,
    employee_leave_id integer,
    work_date date NOT NULL,
    half_day boolean DEFAULT false NOT NULL,
    application_date timestamp without time zone DEFAULT now(),
    approved boolean DEFAULT false NOT NULL,
    rejected boolean DEFAULT false NOT NULL,
    action_date timestamp without time zone,
    details text
);


ALTER TABLE public.leave_work_days OWNER TO root;

--
-- Name: leave_work_days_leave_work_day_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE leave_work_days_leave_work_day_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.leave_work_days_leave_work_day_id_seq OWNER TO root;

--
-- Name: leave_work_days_leave_work_day_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE leave_work_days_leave_work_day_id_seq OWNED BY leave_work_days.leave_work_day_id;


--
-- Name: leave_work_days_leave_work_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('leave_work_days_leave_work_day_id_seq', 1, false);


--
-- Name: orgs; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE orgs (
    org_id integer NOT NULL,
    org_name character varying(50),
    is_default boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    logo character varying(50),
    details text
);


ALTER TABLE public.orgs OWNER TO root;

--
-- Name: orgs_org_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE orgs_org_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.orgs_org_id_seq OWNER TO root;

--
-- Name: orgs_org_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE orgs_org_id_seq OWNED BY orgs.org_id;


--
-- Name: orgs_org_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('orgs_org_id_seq', 1, false);


--
-- Name: pay_groups; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE pay_groups (
    pay_group_id integer NOT NULL,
    pay_group_name character varying(50),
    details text
);


ALTER TABLE public.pay_groups OWNER TO root;

--
-- Name: pay_groups_pay_group_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE pay_groups_pay_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pay_groups_pay_group_id_seq OWNER TO root;

--
-- Name: pay_groups_pay_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE pay_groups_pay_group_id_seq OWNED BY pay_groups.pay_group_id;


--
-- Name: pay_groups_pay_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('pay_groups_pay_group_id_seq', 1, false);


--
-- Name: period_tax_rates; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE period_tax_rates (
    period_tax_rate_id integer NOT NULL,
    period_tax_type_id integer,
    tax_range double precision NOT NULL,
    tax_rate double precision NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.period_tax_rates OWNER TO root;

--
-- Name: period_tax_rates_period_tax_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE period_tax_rates_period_tax_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.period_tax_rates_period_tax_rate_id_seq OWNER TO root;

--
-- Name: period_tax_rates_period_tax_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE period_tax_rates_period_tax_rate_id_seq OWNED BY period_tax_rates.period_tax_rate_id;


--
-- Name: period_tax_rates_period_tax_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('period_tax_rates_period_tax_rate_id_seq', 1, false);


--
-- Name: period_tax_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE period_tax_types (
    period_tax_type_id integer NOT NULL,
    period_id integer,
    tax_type_id integer,
    period_tax_type_name character varying(50) NOT NULL,
    pay_date date DEFAULT ('now'::text)::date NOT NULL,
    formural character varying(320),
    tax_relief real DEFAULT 0 NOT NULL,
    percentage boolean DEFAULT true NOT NULL,
    linear boolean DEFAULT true NOT NULL,
    tax_type_order integer DEFAULT 0 NOT NULL,
    in_tax boolean DEFAULT false NOT NULL,
    employer double precision NOT NULL,
    employer_ps double precision NOT NULL,
    details text
);


ALTER TABLE public.period_tax_types OWNER TO root;

--
-- Name: period_tax_types_period_tax_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE period_tax_types_period_tax_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.period_tax_types_period_tax_type_id_seq OWNER TO root;

--
-- Name: period_tax_types_period_tax_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE period_tax_types_period_tax_type_id_seq OWNED BY period_tax_types.period_tax_type_id;


--
-- Name: period_tax_types_period_tax_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('period_tax_types_period_tax_type_id_seq', 1, false);


--
-- Name: periods; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE periods (
    period_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    overtime_rate double precision NOT NULL,
    per_diem_tax_limit double precision NOT NULL,
    activated boolean DEFAULT true NOT NULL,
    closed boolean DEFAULT true NOT NULL,
    bank_header text,
    details text
);


ALTER TABLE public.periods OWNER TO root;

--
-- Name: periods_period_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE periods_period_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.periods_period_id_seq OWNER TO root;

--
-- Name: periods_period_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE periods_period_id_seq OWNED BY periods.period_id;


--
-- Name: periods_period_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('periods_period_id_seq', 1, false);


--
-- Name: phases; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE phases (
    phase_id integer NOT NULL,
    project_id integer,
    phase_name character varying(240),
    start_date date NOT NULL,
    end_date date NOT NULL,
    phase_cost real DEFAULT 0 NOT NULL,
    details text
);


ALTER TABLE public.phases OWNER TO root;

--
-- Name: phases_phase_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE phases_phase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.phases_phase_id_seq OWNER TO root;

--
-- Name: phases_phase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE phases_phase_id_seq OWNED BY phases.phase_id;


--
-- Name: phases_phase_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('phases_phase_id_seq', 1, false);


--
-- Name: project_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE project_types (
    project_type_id integer NOT NULL,
    project_type_name character varying(50) NOT NULL,
    details text
);


ALTER TABLE public.project_types OWNER TO root;

--
-- Name: project_types_project_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE project_types_project_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.project_types_project_type_id_seq OWNER TO root;

--
-- Name: project_types_project_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE project_types_project_type_id_seq OWNED BY project_types.project_type_id;


--
-- Name: project_types_project_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('project_types_project_type_id_seq', 1, false);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE projects (
    project_id integer NOT NULL,
    project_type_id integer,
    entity_id integer,
    project_name character varying(120) NOT NULL,
    signed boolean DEFAULT false NOT NULL,
    contract_ref character varying(120),
    monthly_amount real NOT NULL,
    full_amount real NOT NULL,
    project_cost real NOT NULL,
    narrative character varying(120),
    start_date date NOT NULL,
    ending_date date NOT NULL,
    details text
);


ALTER TABLE public.projects OWNER TO root;

--
-- Name: projects_project_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE projects_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.projects_project_id_seq OWNER TO root;

--
-- Name: projects_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE projects_project_id_seq OWNED BY projects.project_id;


--
-- Name: projects_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('projects_project_id_seq', 1, false);


--
-- Name: review_category; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE review_category (
    review_category_id integer NOT NULL,
    review_category_name character varying(50),
    details text
);


ALTER TABLE public.review_category OWNER TO root;

--
-- Name: review_category_review_category_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE review_category_review_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.review_category_review_category_id_seq OWNER TO root;

--
-- Name: review_category_review_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE review_category_review_category_id_seq OWNED BY review_category.review_category_id;


--
-- Name: review_category_review_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('review_category_review_category_id_seq', 1, false);


--
-- Name: review_points; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE review_points (
    review_point_id integer NOT NULL,
    review_category_id integer,
    review_point_name character varying(50),
    review_points integer DEFAULT 1 NOT NULL,
    details text
);


ALTER TABLE public.review_points OWNER TO root;

--
-- Name: review_points_review_point_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE review_points_review_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.review_points_review_point_id_seq OWNER TO root;

--
-- Name: review_points_review_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE review_points_review_point_id_seq OWNED BY review_points.review_point_id;


--
-- Name: review_points_review_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('review_points_review_point_id_seq', 1, false);


--
-- Name: skill_category; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE skill_category (
    skill_category_id integer NOT NULL,
    skill_category_name character varying(50) NOT NULL,
    details text
);


ALTER TABLE public.skill_category OWNER TO root;

--
-- Name: skill_category_skill_category_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE skill_category_skill_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.skill_category_skill_category_id_seq OWNER TO root;

--
-- Name: skill_category_skill_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE skill_category_skill_category_id_seq OWNED BY skill_category.skill_category_id;


--
-- Name: skill_category_skill_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('skill_category_skill_category_id_seq', 10, true);


--
-- Name: skill_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE skill_types (
    skill_type_id integer NOT NULL,
    skill_category_id integer,
    skill_type_name character varying(50) NOT NULL,
    basic character varying(50),
    intermediate character varying(50),
    advanced character varying(50),
    details text
);


ALTER TABLE public.skill_types OWNER TO root;

--
-- Name: skill_types_skill_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE skill_types_skill_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.skill_types_skill_type_id_seq OWNER TO root;

--
-- Name: skill_types_skill_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE skill_types_skill_type_id_seq OWNED BY skill_types.skill_type_id;


--
-- Name: skill_types_skill_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('skill_types_skill_type_id_seq', 42, true);


--
-- Name: skills; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE skills (
    skill_id integer NOT NULL,
    entity_id integer,
    skill_type_id integer,
    skill_level integer DEFAULT 1 NOT NULL,
    aquired boolean DEFAULT false NOT NULL,
    training_date date,
    trained boolean DEFAULT false NOT NULL,
    training_institution character varying(240),
    training_cost real,
    details text
);


ALTER TABLE public.skills OWNER TO root;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE skills_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.skills_skill_id_seq OWNER TO root;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE skills_skill_id_seq OWNED BY skills.skill_id;


--
-- Name: skills_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('skills_skill_id_seq', 1, false);


--
-- Name: sub_fields; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sub_fields (
    sub_field_id integer NOT NULL,
    field_id integer,
    sub_field_order integer DEFAULT 1,
    sub_title_share character varying(120),
    sub_field_type character varying(25),
    sub_field_lookup text,
    sub_field_size integer DEFAULT 10 NOT NULL,
    sub_col_spans integer DEFAULT 1 NOT NULL,
    manditory character(1) DEFAULT '0'::bpchar NOT NULL,
    show character(1) DEFAULT '1'::bpchar,
    question text
);


ALTER TABLE public.sub_fields OWNER TO root;

--
-- Name: sub_fields_sub_field_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sub_fields_sub_field_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sub_fields_sub_field_id_seq OWNER TO root;

--
-- Name: sub_fields_sub_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sub_fields_sub_field_id_seq OWNED BY sub_fields.sub_field_id;


--
-- Name: sub_fields_sub_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sub_fields_sub_field_id_seq', 1, false);


--
-- Name: sys_audit_details; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_audit_details (
    sys_audit_detail_id integer NOT NULL,
    sys_audit_trail_id integer,
    new_value text
);


ALTER TABLE public.sys_audit_details OWNER TO root;

--
-- Name: sys_audit_details_sys_audit_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_audit_details_sys_audit_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_audit_details_sys_audit_detail_id_seq OWNER TO root;

--
-- Name: sys_audit_details_sys_audit_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_audit_details_sys_audit_detail_id_seq OWNED BY sys_audit_details.sys_audit_detail_id;


--
-- Name: sys_audit_details_sys_audit_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_audit_details_sys_audit_detail_id_seq', 1, false);


--
-- Name: sys_audit_trail; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_audit_trail (
    sys_audit_trail_id integer NOT NULL,
    user_id character varying(32) NOT NULL,
    user_ip character varying(32),
    change_date timestamp without time zone DEFAULT now() NOT NULL,
    table_name character varying(32) NOT NULL,
    record_id character varying(32) NOT NULL,
    change_type character varying(32) NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.sys_audit_trail OWNER TO root;

--
-- Name: sys_audit_trail_sys_audit_trail_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_audit_trail_sys_audit_trail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_audit_trail_sys_audit_trail_id_seq OWNER TO root;

--
-- Name: sys_audit_trail_sys_audit_trail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_audit_trail_sys_audit_trail_id_seq OWNED BY sys_audit_trail.sys_audit_trail_id;


--
-- Name: sys_audit_trail_sys_audit_trail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_audit_trail_sys_audit_trail_id_seq', 1, false);


--
-- Name: sys_continents; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_continents (
    sys_continent_id character(2) NOT NULL,
    sys_continent_name character varying(120)
);


ALTER TABLE public.sys_continents OWNER TO root;

--
-- Name: sys_countrys; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_countrys (
    sys_country_id character(2) NOT NULL,
    sys_continent_id character(2),
    sys_country_code character varying(3),
    sys_country_number character varying(3),
    sys_country_name character varying(120)
);


ALTER TABLE public.sys_countrys OWNER TO root;

--
-- Name: sys_emailed; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_emailed (
    sys_emailed_id integer NOT NULL,
    sys_email_id integer,
    table_id integer,
    table_name character varying(50),
    email_level integer DEFAULT 1 NOT NULL,
    emailed boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.sys_emailed OWNER TO root;

--
-- Name: sys_emailed_sys_emailed_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_emailed_sys_emailed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_emailed_sys_emailed_id_seq OWNER TO root;

--
-- Name: sys_emailed_sys_emailed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_emailed_sys_emailed_id_seq OWNED BY sys_emailed.sys_emailed_id;


--
-- Name: sys_emailed_sys_emailed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_emailed_sys_emailed_id_seq', 1, false);


--
-- Name: sys_emails; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_emails (
    sys_email_id integer NOT NULL,
    title character varying(240) NOT NULL,
    details text
);


ALTER TABLE public.sys_emails OWNER TO root;

--
-- Name: sys_emails_sys_email_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_emails_sys_email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_emails_sys_email_id_seq OWNER TO root;

--
-- Name: sys_emails_sys_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_emails_sys_email_id_seq OWNED BY sys_emails.sys_email_id;


--
-- Name: sys_emails_sys_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_emails_sys_email_id_seq', 1, false);


--
-- Name: sys_errors; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_errors (
    sys_error_id integer NOT NULL,
    sys_error character varying(240) NOT NULL,
    error_message text NOT NULL
);


ALTER TABLE public.sys_errors OWNER TO root;

--
-- Name: sys_errors_sys_error_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_errors_sys_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_errors_sys_error_id_seq OWNER TO root;

--
-- Name: sys_errors_sys_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_errors_sys_error_id_seq OWNED BY sys_errors.sys_error_id;


--
-- Name: sys_errors_sys_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_errors_sys_error_id_seq', 1, false);


--
-- Name: sys_files; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_files (
    sys_file_id integer NOT NULL,
    table_id integer,
    table_name character varying(50),
    file_name character varying(50),
    file_type character varying(50),
    details text
);


ALTER TABLE public.sys_files OWNER TO root;

--
-- Name: sys_files_sys_file_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_files_sys_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_files_sys_file_id_seq OWNER TO root;

--
-- Name: sys_files_sys_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_files_sys_file_id_seq OWNED BY sys_files.sys_file_id;


--
-- Name: sys_files_sys_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_files_sys_file_id_seq', 1, false);


--
-- Name: sys_logins; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_logins (
    sys_login_id integer NOT NULL,
    entity_id integer,
    login_time timestamp without time zone DEFAULT now(),
    login_ip character varying(32),
    narrative character varying(240)
);


ALTER TABLE public.sys_logins OWNER TO root;

--
-- Name: sys_logins_sys_login_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_logins_sys_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_logins_sys_login_id_seq OWNER TO root;

--
-- Name: sys_logins_sys_login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_logins_sys_login_id_seq OWNED BY sys_logins.sys_login_id;


--
-- Name: sys_logins_sys_login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_logins_sys_login_id_seq', 1, true);


--
-- Name: sys_news; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_news (
    sys_news_id integer NOT NULL,
    sys_news_group integer,
    sys_news_title character varying(240),
    publish boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.sys_news OWNER TO root;

--
-- Name: sys_news_sys_news_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_news_sys_news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_news_sys_news_id_seq OWNER TO root;

--
-- Name: sys_news_sys_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_news_sys_news_id_seq OWNED BY sys_news.sys_news_id;


--
-- Name: sys_news_sys_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_news_sys_news_id_seq', 1, false);


--
-- Name: sys_passwords; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_passwords (
    sys_password_id integer NOT NULL,
    sys_user_name character varying(240) NOT NULL,
    password_sent boolean NOT NULL
);


ALTER TABLE public.sys_passwords OWNER TO root;

--
-- Name: sys_passwords_sys_password_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE sys_passwords_sys_password_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sys_passwords_sys_password_id_seq OWNER TO root;

--
-- Name: sys_passwords_sys_password_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE sys_passwords_sys_password_id_seq OWNED BY sys_passwords.sys_password_id;


--
-- Name: sys_passwords_sys_password_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('sys_passwords_sys_password_id_seq', 1, false);


--
-- Name: sys_queries; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE sys_queries (
    query_name character varying(50) NOT NULL,
    query_date timestamp without time zone DEFAULT now() NOT NULL,
    query_text text
);


ALTER TABLE public.sys_queries OWNER TO root;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE tasks (
    task_id integer NOT NULL,
    phase_id integer,
    entity_id integer,
    task_name character varying(240) NOT NULL,
    start_date date NOT NULL,
    dead_line date NOT NULL,
    end_date date NOT NULL,
    team character varying(120),
    narrative character varying(120),
    completed boolean DEFAULT false NOT NULL,
    details text
);


ALTER TABLE public.tasks OWNER TO root;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE tasks_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tasks_task_id_seq OWNER TO root;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE tasks_task_id_seq OWNED BY tasks.task_id;


--
-- Name: tasks_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('tasks_task_id_seq', 1, false);


--
-- Name: tax_rates; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE tax_rates (
    tax_rate_id integer NOT NULL,
    tax_type_id integer,
    tax_range double precision NOT NULL,
    tax_rate double precision NOT NULL,
    narrative character varying(240)
);


ALTER TABLE public.tax_rates OWNER TO root;

--
-- Name: tax_rates_tax_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE tax_rates_tax_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tax_rates_tax_rate_id_seq OWNER TO root;

--
-- Name: tax_rates_tax_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE tax_rates_tax_rate_id_seq OWNED BY tax_rates.tax_rate_id;


--
-- Name: tax_rates_tax_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('tax_rates_tax_rate_id_seq', 24, true);


--
-- Name: tax_types; Type: TABLE; Schema: public; Owner: root; Tablespace: 
--

CREATE TABLE tax_types (
    tax_type_id integer NOT NULL,
    tax_type_name character varying(50) NOT NULL,
    formural character varying(320),
    tax_relief real DEFAULT 0 NOT NULL,
    tax_type_order integer DEFAULT 0 NOT NULL,
    in_tax boolean DEFAULT false NOT NULL,
    linear boolean DEFAULT true,
    percentage boolean DEFAULT true,
    employer double precision NOT NULL,
    employer_ps double precision NOT NULL,
    active boolean DEFAULT true,
    details text
);


ALTER TABLE public.tax_types OWNER TO root;

--
-- Name: tax_types_tax_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE tax_types_tax_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tax_types_tax_type_id_seq OWNER TO root;

--
-- Name: tax_types_tax_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE tax_types_tax_type_id_seq OWNED BY tax_types.tax_type_id;


--
-- Name: tax_types_tax_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('tax_types_tax_type_id_seq', 3, true);


--
-- Name: tomcat_users; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW tomcat_users AS
    SELECT entitys.user_name, entitys.entity_password, entity_types.entity_role FROM ((entity_subscriptions JOIN entitys ON ((entity_subscriptions.entity_id = entitys.entity_id))) JOIN entity_types ON ((entity_subscriptions.entity_type_id = entity_types.entity_type_id))) WHERE (entitys.is_active = true);


ALTER TABLE public.tomcat_users OWNER TO root;

--
-- Name: vw_address; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_address AS
    SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name, address.address_id, address.address_name, address.table_name, address.table_id, address.post_office_box, address.postal_code, address.premises, address.street, address.town, address.phone_number, address.extension, address.mobile, address.fax, address.email, address.is_default, address.details FROM (address JOIN sys_countrys ON ((address.sys_country_id = sys_countrys.sys_country_id)));


ALTER TABLE public.vw_address OWNER TO root;

--
-- Name: vw_bank_branch; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_bank_branch AS
    SELECT banks.bank_id, banks.bank_name, bank_branch.bank_branch_id, bank_branch.bank_branch_name, bank_branch.bank_branch_code, bank_branch.narrative FROM (bank_branch JOIN banks ON ((bank_branch.bank_id = banks.bank_id)));


ALTER TABLE public.vw_bank_branch OWNER TO root;

--
-- Name: vw_department_roles; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_department_roles AS
    SELECT departments.department_id, departments.department_name, departments.description AS department_description, departments.duties AS department_duties, ln_department_roles.department_role_name AS parent_role_name, department_roles.department_role_id, department_roles.ln_department_role_id, department_roles.department_role_name, department_roles.job_description, department_roles.job_requirements, department_roles.duties, department_roles.performance_measures, department_roles.active, department_roles.details FROM ((department_roles JOIN departments ON ((department_roles.department_id = departments.department_id))) JOIN department_roles ln_department_roles ON ((department_roles.ln_department_role_id = ln_department_roles.department_role_id)));


ALTER TABLE public.vw_department_roles OWNER TO root;

--
-- Name: vw_periods; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_periods AS
    SELECT periods.period_id, periods.start_date, periods.end_date, periods.overtime_rate, periods.activated, periods.closed, periods.details, date_part('month'::text, periods.start_date) AS month_id, to_char((periods.start_date)::timestamp with time zone, 'YYYY'::text) AS period_year, to_char((periods.start_date)::timestamp with time zone, 'Month'::text) AS period_month, (trunc(((date_part('month'::text, periods.start_date) - (1)::double precision) / (3)::double precision)) + (1)::double precision) AS quarter, (trunc(((date_part('month'::text, periods.start_date) - (1)::double precision) / (6)::double precision)) + (1)::double precision) AS semister, periods.bank_header FROM periods ORDER BY periods.start_date;


ALTER TABLE public.vw_periods OWNER TO root;

--
-- Name: vw_employee_month; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_month AS
    SELECT vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.overtime_rate, vw_periods.activated, vw_periods.closed, vw_periods.month_id, vw_periods.period_year, vw_periods.period_month, vw_periods.quarter, vw_periods.semister, vw_periods.bank_header, vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, vw_bank_branch.bank_branch_name, vw_bank_branch.bank_branch_code, pay_groups.pay_group_id, pay_groups.pay_group_name, vw_department_roles.department_id, vw_department_roles.department_name, vw_department_roles.department_role_id, vw_department_roles.department_role_name, entitys.entity_id, entitys.entity_name, employees.employee_id, employees.surname, employees.first_name, employees.middle_name, employees.date_of_birth, employees.gender, employees.nationality, employees.marital_status, employees.appointment_date, employees.exit_date, employees.contract, employees.contract_period, employees.employment_terms, employees.identity_card, employee_month.employee_month_id, employee_month.bank_account, employee_month.basic_pay, employee_month.details, getadjustment(employee_month.employee_month_id, 4, 31) AS overtime, getadjustment(employee_month.employee_month_id, 1, 1) AS full_allowance, getadjustment(employee_month.employee_month_id, 1, 2) AS payroll_allowance, getadjustment(employee_month.employee_month_id, 1, 3) AS tax_allowance, getadjustment(employee_month.employee_month_id, 2, 1) AS full_deduction, getadjustment(employee_month.employee_month_id, 2, 2) AS payroll_deduction, getadjustment(employee_month.employee_month_id, 2, 3) AS tax_deduction, getadjustment(employee_month.employee_month_id, 3, 1) AS full_expense, getadjustment(employee_month.employee_month_id, 3, 2) AS payroll_expense, getadjustment(employee_month.employee_month_id, 3, 3) AS tax_expense, getadjustment(employee_month.employee_month_id, 4, 11) AS payroll_tax, getadjustment(employee_month.employee_month_id, 4, 12) AS tax_tax, getadjustment(employee_month.employee_month_id, 4, 22) AS net_adjustment, getadjustment(employee_month.employee_month_id, 4, 33) AS per_diem, getadjustment(employee_month.employee_month_id, 4, 34) AS advance, getadjustment(employee_month.employee_month_id, 4, 35) AS advance_deduction, (((employee_month.basic_pay + getadjustment(employee_month.employee_month_id, 4, 31)) + getadjustment(employee_month.employee_month_id, 4, 22)) - getadjustment(employee_month.employee_month_id, 4, 11)) AS net_pay, ((((((employee_month.basic_pay + getadjustment(employee_month.employee_month_id, 4, 31)) + getadjustment(employee_month.employee_month_id, 4, 22)) - getadjustment(employee_month.employee_month_id, 4, 11)) + getadjustment(employee_month.employee_month_id, 4, 33)) + getadjustment(employee_month.employee_month_id, 4, 34)) - getadjustment(employee_month.employee_month_id, 4, 35)) AS banked, ((((employee_month.basic_pay + getadjustment(employee_month.employee_month_id, 4, 31)) + getadjustment(employee_month.employee_month_id, 1, 1)) + getadjustment(employee_month.employee_month_id, 3, 1)) + getadjustment(employee_month.employee_month_id, 4, 33)) AS cost FROM ((((((employee_month JOIN vw_bank_branch ON ((employee_month.bank_branch_id = vw_bank_branch.bank_branch_id))) JOIN vw_periods ON ((employee_month.period_id = vw_periods.period_id))) JOIN pay_groups ON ((employee_month.pay_group_id = pay_groups.pay_group_id))) JOIN entitys ON ((employee_month.entity_id = entitys.entity_id))) JOIN vw_department_roles ON ((employee_month.department_role_id = vw_department_roles.department_role_id))) JOIN employees ON ((employee_month.entity_id = employees.entity_id)));


ALTER TABLE public.vw_employee_month OWNER TO root;

--
-- Name: vw_advance_deductions; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_advance_deductions AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, advance_deductions.advance_deduction_id, advance_deductions.pay_date, advance_deductions.amount, advance_deductions.in_payroll, advance_deductions.narrative FROM (advance_deductions JOIN vw_employee_month ON ((advance_deductions.employee_month_id = vw_employee_month.employee_month_id)));


ALTER TABLE public.vw_advance_deductions OWNER TO root;

--
-- Name: vw_advance_statement; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_advance_statement AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, employee_advances.pay_date, employee_advances.in_payroll, employee_advances.narrative, employee_advances.amount, (0)::real AS recovery FROM (employee_advances JOIN vw_employee_month ON ((employee_advances.employee_month_id = vw_employee_month.employee_month_id))) WHERE (employee_advances.approved = true) UNION SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, advance_deductions.pay_date, advance_deductions.in_payroll, advance_deductions.narrative, (0)::real AS amount, advance_deductions.amount AS recovery FROM (advance_deductions JOIN vw_employee_month ON ((advance_deductions.employee_month_id = vw_employee_month.employee_month_id)));


ALTER TABLE public.vw_advance_statement OWNER TO root;

--
-- Name: vw_applicant; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_applicant AS
    SELECT sys_countrys.sys_country_id, sys_countrys.sys_country_name, applicant.entity_id, applicant.surname, applicant.first_name, applicant.middle_name, applicant.date_of_birth, applicant.nationality, applicant.identity_card, applicant.language, applicant.objective, applicant.interests, applicant.details, (((((applicant.surname)::text || ' '::text) || (applicant.first_name)::text) || ' '::text) || (COALESCE(applicant.middle_name, ''::character varying))::text) AS applicant_name, to_char(age((applicant.date_of_birth)::timestamp with time zone), 'YY'::text) AS applicant_age, CASE WHEN ((applicant.gender)::text = 'M'::text) THEN 'Male'::text ELSE 'Female'::text END AS gender_name, CASE WHEN ((applicant.marital_status)::text = 'M'::text) THEN 'Married'::text ELSE 'Single'::text END AS marital_status_name FROM (applicant JOIN sys_countrys ON ((applicant.nationality = sys_countrys.sys_country_id)));


ALTER TABLE public.vw_applicant OWNER TO root;

--
-- Name: vw_intake; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_intake AS
    SELECT vw_department_roles.department_id, vw_department_roles.department_name, vw_department_roles.department_description, vw_department_roles.department_duties, vw_department_roles.department_role_id, vw_department_roles.department_role_name, vw_department_roles.job_description, vw_department_roles.job_requirements, vw_department_roles.duties, vw_department_roles.performance_measures, intake.intake_id, intake.opening_date, intake.closing_date, intake.positions, intake.location, intake.details FROM (intake JOIN vw_department_roles ON ((intake.department_role_id = vw_department_roles.department_role_id)));


ALTER TABLE public.vw_intake OWNER TO root;

--
-- Name: vw_applications; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_applications AS
    SELECT vw_intake.department_id, vw_intake.department_name, vw_intake.department_description, vw_intake.department_duties, vw_intake.department_role_id, vw_intake.department_role_name, vw_intake.job_description, vw_intake.job_requirements, vw_intake.duties, vw_intake.performance_measures, vw_intake.intake_id, vw_intake.opening_date, vw_intake.closing_date, vw_intake.positions, vw_intake.location, entitys.entity_id, entitys.entity_name, applications.application_id, applications.application_date, applications.approved, applications.rejected, applications.action_date, applications.applicant_comments, applications.review FROM ((applications JOIN entitys ON ((applications.entity_id = entitys.entity_id))) JOIN vw_intake ON ((applications.intake_id = vw_intake.intake_id)));


ALTER TABLE public.vw_applications OWNER TO root;

--
-- Name: vw_approval_phases; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_approval_phases AS
    SELECT approval_types.approval_type_id, approval_types.approval_type_name, entity_types.entity_type_id, entity_types.entity_type_name, approval_phases.approval_phase_id, approval_phases.table_name, approval_phases.approval_level, approval_phases.return_level, approval_phases.escalation_time, approval_phases.departmental, approval_phases.details FROM ((approval_phases JOIN approval_types ON ((approval_phases.approval_type_id = approval_types.approval_type_id))) JOIN entity_types ON ((approval_phases.entity_type_id = entity_types.entity_type_id)));


ALTER TABLE public.vw_approval_phases OWNER TO root;

--
-- Name: vw_approvals; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_approvals AS
    SELECT vw_approval_phases.approval_type_id, vw_approval_phases.approval_type_name, vw_approval_phases.entity_type_id, vw_approval_phases.entity_type_name, vw_approval_phases.approval_phase_id, vw_approval_phases.table_name, vw_approval_phases.approval_level, vw_approval_phases.return_level, entitys.entity_id, entitys.entity_name, approvals.approval_id, approvals.forward_id, approvals.table_id, approvals.escalation_time, approvals.application_date, approvals.approved, approvals.rejected, approvals.action_date, approvals.narrative, approvals.to_be_done, approvals.what_is_done, approvals.details FROM ((approvals JOIN vw_approval_phases ON ((approvals.approval_phase_id = vw_approval_phases.approval_phase_id))) LEFT JOIN entitys ON ((approvals.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_approvals OWNER TO root;

--
-- Name: vw_attendance; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_attendance AS
    SELECT entitys.entity_id, entitys.entity_name, attendance.attendance_id, attendance.attendance_date, attendance.time_in, attendance.time_out, attendance.details FROM (attendance JOIN entitys ON ((attendance.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_attendance OWNER TO root;

--
-- Name: vw_casual_application; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_casual_application AS
    SELECT casual_category.casual_category_id, casual_category.casual_category_name, departments.department_id, departments.department_name, casual_application.casual_application_id, casual_application."position", casual_application.application_date, casual_application.approved_pay_rate, casual_application.approved, casual_application.rejected, casual_application.action_date, casual_application.work_duration, casual_application.details FROM ((casual_application JOIN casual_category ON ((casual_application.casual_category_id = casual_category.casual_category_id))) JOIN departments ON ((casual_application.department_id = departments.department_id)));


ALTER TABLE public.vw_casual_application OWNER TO root;

--
-- Name: vw_casuals; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_casuals AS
    SELECT vw_casual_application.casual_category_id, vw_casual_application.casual_category_name, vw_casual_application.department_id, vw_casual_application.department_name, vw_casual_application.casual_application_id, vw_casual_application."position", vw_casual_application.application_date, vw_casual_application.approved_pay_rate, vw_casual_application.approved AS application_approved, vw_casual_application.rejected AS application_rejected, vw_casual_application.action_date AS application_action_date, vw_casual_application.work_duration, entitys.entity_id, entitys.entity_name, casuals.casual_id, casuals.start_date, casuals.end_date, casuals.duration, casuals.pay_rate, casuals.amount_paid, casuals.approved, casuals.rejected, casuals.action_date, casuals.paid, casuals.details FROM ((casuals JOIN vw_casual_application ON ((casuals.casual_application_id = vw_casual_application.casual_application_id))) JOIN entitys ON ((casuals.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_casuals OWNER TO root;

--
-- Name: vw_cv_projects; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_cv_projects AS
    SELECT entitys.entity_id, entitys.entity_name, cv_projects.cv_projectid, cv_projects.cv_project_name, cv_projects.cv_project_date, cv_projects.details FROM (cv_projects JOIN entitys ON ((cv_projects.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_cv_projects OWNER TO root;

--
-- Name: vw_cv_referees; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_cv_referees AS
    SELECT entitys.entity_id, entitys.entity_name, cv_referees.cv_referee_id, cv_referees.cv_referee_name, cv_referees.cv_referee_address, cv_referees.details FROM (cv_referees JOIN entitys ON ((cv_referees.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_cv_referees OWNER TO root;

--
-- Name: vw_cv_seminars; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_cv_seminars AS
    SELECT entitys.entity_id, entitys.entity_name, cv_seminars.cv_seminar_id, cv_seminars.cv_seminar_name, cv_seminars.cv_seminar_date, cv_seminars.details FROM (cv_seminars JOIN entitys ON ((cv_seminars.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_cv_seminars OWNER TO root;

--
-- Name: vw_default_adjustments; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_default_adjustments AS
    SELECT adjustments.adjustment_id, adjustments.adjustment_name, adjustments.adjustment_type, entitys.entity_id, entitys.entity_name, default_adjustments.default_allowance_id, default_adjustments.amount, default_adjustments.active, default_adjustments.final_date, default_adjustments.narrative FROM ((default_adjustments JOIN adjustments ON ((default_adjustments.adjustment_id = adjustments.adjustment_id))) JOIN entitys ON ((default_adjustments.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_default_adjustments OWNER TO root;

--
-- Name: vw_default_tax_types; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_default_tax_types AS
    SELECT entitys.entity_id, entitys.entity_name, tax_types.tax_type_id, tax_types.tax_type_name, default_tax_types.default_tax_type_id, default_tax_types.tax_identification, default_tax_types.active, default_tax_types.narrative FROM ((default_tax_types JOIN entitys ON ((default_tax_types.entity_id = entitys.entity_id))) JOIN tax_types ON ((default_tax_types.tax_type_id = tax_types.tax_type_id)));


ALTER TABLE public.vw_default_tax_types OWNER TO root;

--
-- Name: vw_departments; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_departments AS
    SELECT departments.ln_department_id, p_departments.department_name AS ln_department_name, departments.department_id, departments.department_name, departments.active, departments.description, departments.duties, departments.reports, departments.details FROM (departments JOIN departments p_departments ON ((departments.ln_department_id = p_departments.department_id)));


ALTER TABLE public.vw_departments OWNER TO root;

--
-- Name: vw_education; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_education AS
    SELECT education_class.education_class_id, education_class.education_class_name, entitys.entity_id, entitys.entity_name, education.education_id, education.date_from, education.date_to, education.name_of_school, education.examination_taken, education.grades_obtained, education.details FROM ((education JOIN education_class ON ((education.education_class_id = education_class.education_class_id))) JOIN entitys ON ((education.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_education OWNER TO root;

--
-- Name: vw_employee_adjustments; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_adjustments AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, adjustments.adjustment_id, adjustments.adjustment_name, adjustments.adjustment_type, employee_adjustments.employee_allowance_id, employee_adjustments.pay_date, employee_adjustments.amount, employee_adjustments.in_payroll, employee_adjustments.in_tax, employee_adjustments.visible, employee_adjustments.narrative FROM ((employee_adjustments JOIN adjustments ON ((employee_adjustments.adjustment_id = adjustments.adjustment_id))) JOIN vw_employee_month ON ((employee_adjustments.employee_month_id = vw_employee_month.employee_month_id)));


ALTER TABLE public.vw_employee_adjustments OWNER TO root;

--
-- Name: vw_employee_advances; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_advances AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, employee_advances.employee_advance_id, employee_advances.pay_date, employee_advances.pay_period, employee_advances.pay_upto, employee_advances.amount, employee_advances.in_payroll, employee_advances.completed, employee_advances.approved, employee_advances.rejected, employee_advances.action_date, employee_advances.narrative FROM (employee_advances JOIN vw_employee_month ON ((employee_advances.employee_month_id = vw_employee_month.employee_month_id)));


ALTER TABLE public.vw_employee_advances OWNER TO root;

--
-- Name: vw_employee_cases; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_cases AS
    SELECT case_types.case_type_id, case_types.case_type_name, entitys.entity_id, entitys.entity_name, employee_cases.employee_case_id, employee_cases.narrative, employee_cases.case_date, employee_cases.complaint, employee_cases.case_action, employee_cases.completed, employee_cases.details FROM ((employee_cases JOIN case_types ON ((employee_cases.case_type_id = case_types.case_type_id))) JOIN entitys ON ((employee_cases.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_employee_cases OWNER TO root;

--
-- Name: vw_employee_leave; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_leave AS
    SELECT entitys.entity_id, entitys.entity_name, leave_types.leave_type_id, leave_types.leave_type_name, employee_leave.employee_leave_id, employee_leave.leave_from, employee_leave.leave_to, employee_leave.start_half_day, employee_leave.end_half_day, employee_leave.approved, employee_leave.rejected, employee_leave.action_date, employee_leave.completed, employee_leave.leave_days, employee_leave.narrative, employee_leave.details FROM ((employee_leave JOIN entitys ON ((employee_leave.entity_id = entitys.entity_id))) JOIN leave_types ON ((employee_leave.leave_type_id = leave_types.leave_type_id)));


ALTER TABLE public.vw_employee_leave OWNER TO root;

--
-- Name: vw_employee_overtime; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_overtime AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, employee_overtime.employee_overtime_id, employee_overtime.overtime_date, employee_overtime.overtime, employee_overtime.overtime_rate, employee_overtime.narrative, employee_overtime.approved, employee_overtime.rejected, employee_overtime.action_date, employee_overtime.details FROM (employee_overtime JOIN vw_employee_month ON ((employee_overtime.employee_month_id = vw_employee_month.employee_month_id)));


ALTER TABLE public.vw_employee_overtime OWNER TO root;

--
-- Name: vw_employee_per_diem; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_per_diem AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, employee_per_diem.employee_per_diem_id, employee_per_diem.travel_date, employee_per_diem.return_date, employee_per_diem.days_travelled, employee_per_diem.per_diem, employee_per_diem.cash_paid, employee_per_diem.tax_amount, employee_per_diem.travel_to, employee_per_diem.approved, employee_per_diem.rejected, employee_per_diem.action_date, employee_per_diem.completed, employee_per_diem.details FROM (employee_per_diem JOIN vw_employee_month ON ((employee_per_diem.employee_month_id = vw_employee_month.employee_month_id)));


ALTER TABLE public.vw_employee_per_diem OWNER TO root;

--
-- Name: vw_employee_tax_types; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employee_tax_types AS
    SELECT vw_employee_month.employee_month_id, vw_employee_month.period_id, vw_employee_month.start_date, vw_employee_month.month_id, vw_employee_month.period_year, vw_employee_month.period_month, vw_employee_month.entity_id, vw_employee_month.entity_name, vw_employee_month.employee_id, tax_types.tax_type_id, tax_types.tax_type_name, employee_tax_types.employee_tax_type_id, employee_tax_types.tax_identification, employee_tax_types.amount, employee_tax_types.additional, employee_tax_types.employer, employee_tax_types.narrative FROM ((employee_tax_types JOIN vw_employee_month ON ((employee_tax_types.employee_month_id = vw_employee_month.employee_month_id))) JOIN tax_types ON ((employee_tax_types.tax_type_id = tax_types.tax_type_id)));


ALTER TABLE public.vw_employee_tax_types OWNER TO root;

--
-- Name: vw_employees; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employees AS
    SELECT vw_bank_branch.bank_id, vw_bank_branch.bank_name, vw_bank_branch.bank_branch_id, vw_bank_branch.bank_branch_name, vw_bank_branch.bank_branch_code, vw_department_roles.department_id, vw_department_roles.department_name, vw_department_roles.department_role_id, vw_department_roles.department_role_name, sys_countrys.sys_country_name, employees.entity_id, employees.employee_id, employees.surname, employees.first_name, employees.middle_name, (((((employees.surname)::text || ' '::text) || (employees.first_name)::text) || ' '::text) || (COALESCE(employees.middle_name, ''::character varying))::text) AS employee_name, employees.date_of_birth, employees.gender, employees.nationality, employees.marital_status, employees.appointment_date, employees.exit_date, employees.contract, employees.contract_period, employees.employment_terms, employees.identity_card, employees.basic_salary, employees.bank_account, employees.language, employees.objective, employees.active, employees.interests, employees.details, to_char(age((employees.date_of_birth)::timestamp with time zone), 'YY'::text) AS employee_age, CASE WHEN ((employees.gender)::text = 'M'::text) THEN 'Male'::text ELSE 'Female'::text END AS gender_name, CASE WHEN ((employees.marital_status)::text = 'M'::text) THEN 'Married'::text ELSE 'Single'::text END AS marital_status_name FROM (((employees JOIN vw_bank_branch ON ((employees.bank_branch_id = vw_bank_branch.bank_branch_id))) JOIN vw_department_roles ON ((employees.department_role_id = vw_department_roles.department_role_id))) JOIN sys_countrys ON ((employees.nationality = sys_countrys.sys_country_id)));


ALTER TABLE public.vw_employees OWNER TO root;

--
-- Name: vw_employment; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_employment AS
    SELECT entitys.entity_id, entitys.entity_name, employment.employment_id, employment.date_from, employment.date_to, employment.employers_name, employment.position_held, employment.details FROM (employment JOIN entitys ON ((employment.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_employment OWNER TO root;

--
-- Name: vw_entity_subscriptions; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_entity_subscriptions AS
    SELECT entity_types.entity_type_id, entity_types.entity_type_name, entitys.entity_id, entitys.entity_name, entity_subscriptions.entity_subscription_id, entity_subscriptions.details FROM ((entity_subscriptions JOIN entity_types ON ((entity_subscriptions.entity_type_id = entity_types.entity_type_id))) JOIN entitys ON ((entity_subscriptions.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_entity_subscriptions OWNER TO root;

--
-- Name: vw_entitys; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_entitys AS
    SELECT orgs.org_id, orgs.org_name, vw_address.address_id, vw_address.address_name, vw_address.sys_country_id, vw_address.sys_country_name, vw_address.table_name, vw_address.post_office_box, vw_address.postal_code, vw_address.premises, vw_address.street, vw_address.town, vw_address.phone_number, vw_address.extension, vw_address.mobile, vw_address.fax, vw_address.email, entitys.entity_id, entitys.entity_name, entitys.user_name, entitys.super_user, entitys.entity_leader, entitys.date_enroled, entitys.is_active, entitys.entity_password, entitys.first_password, entitys.details FROM ((entitys JOIN vw_address ON ((entitys.entity_id = vw_address.table_id))) JOIN orgs ON ((entitys.org_id = orgs.org_id))) WHERE ((vw_address.table_name)::text = 'entitys'::text);


ALTER TABLE public.vw_entitys OWNER TO root;

--
-- Name: vw_entry_forms; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_entry_forms AS
    SELECT entitys.entity_id, entitys.entity_name, forms.form_id, forms.form_name, entry_forms.entry_form_id, entry_forms.completed, entry_forms.approved, entry_forms.rejected, entry_forms.application_date, entry_forms.completion_date, entry_forms.approve_date, entry_forms.narrative, entry_forms.answer, entry_forms.details FROM ((entry_forms JOIN entitys ON ((entry_forms.entity_id = entitys.entity_id))) JOIN forms ON ((entry_forms.form_id = forms.form_id)));


ALTER TABLE public.vw_entry_forms OWNER TO root;

--
-- Name: vw_entry_sub_forms; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_entry_sub_forms AS
    SELECT vw_entry_forms.entry_form_id, vw_entry_forms.entity_id, vw_entry_forms.entity_name, vw_entry_forms.approved, vw_entry_forms.application_date, vw_entry_forms.completion_date, sub_fields.sub_field_id, sub_fields.field_id, sub_fields.question, entry_sub_forms.entry_sub_form_id, entry_sub_forms.answer FROM ((entry_sub_forms JOIN vw_entry_forms ON ((entry_sub_forms.entry_form_id = vw_entry_forms.entry_form_id))) JOIN sub_fields ON ((entry_sub_forms.sub_field_id = sub_fields.sub_field_id)));


ALTER TABLE public.vw_entry_sub_forms OWNER TO root;

--
-- Name: vw_job_reviews; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_job_reviews AS
    SELECT entitys.entity_id, entitys.entity_name, job_reviews.job_review_id, job_reviews.total_points, job_reviews.review_date, job_reviews.review_done, job_reviews.recomendation, job_reviews.details FROM (job_reviews JOIN entitys ON ((job_reviews.entity_id = entitys.entity_id)));


ALTER TABLE public.vw_job_reviews OWNER TO root;

--
-- Name: vw_review_points; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_review_points AS
    SELECT review_category.review_category_id, review_category.review_category_name, review_points.review_point_id, review_points.review_point_name, review_points.review_points, review_points.details FROM (review_points JOIN review_category ON ((review_points.review_category_id = review_category.review_category_id)));


ALTER TABLE public.vw_review_points OWNER TO root;

--
-- Name: vw_evaluation_points; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_evaluation_points AS
    SELECT vw_job_reviews.entity_id, vw_job_reviews.entity_name, vw_job_reviews.job_review_id, vw_job_reviews.total_points, vw_job_reviews.review_date, vw_job_reviews.review_done, vw_job_reviews.recomendation, vw_review_points.review_category_id, vw_review_points.review_category_name, vw_review_points.review_point_id, vw_review_points.review_point_name, vw_review_points.review_points, evaluation_points.evaluation_point_id, evaluation_points.points, evaluation_points.narrative, evaluation_points.details FROM ((evaluation_points JOIN vw_job_reviews ON ((evaluation_points.job_review_id = vw_job_reviews.job_review_id))) JOIN vw_review_points ON ((evaluation_points.review_point_id = vw_review_points.review_point_id)));


ALTER TABLE public.vw_evaluation_points OWNER TO root;

--
-- Name: vw_fields; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_fields AS
    SELECT forms.form_id, forms.form_name, fields.field_id, fields.question, fields.field_lookup, fields.field_type, fields.field_order, fields.share_line, fields.field_size, fields.manditory, fields.field_bold, fields.field_italics FROM (fields JOIN forms ON ((fields.form_id = forms.form_id)));


ALTER TABLE public.vw_fields OWNER TO root;

--
-- Name: vw_internships; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_internships AS
    SELECT departments.department_id, departments.department_name, internships.internship_id, internships.opening_date, internships.closing_date, internships.positions, internships.location, internships.details FROM (internships JOIN departments ON ((internships.department_id = departments.department_id)));


ALTER TABLE public.vw_internships OWNER TO root;

--
-- Name: vw_interns; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_interns AS
    SELECT entitys.entity_id, entitys.entity_name, vw_internships.department_id, vw_internships.department_name, vw_internships.internship_id, vw_internships.positions, vw_internships.opening_date, vw_internships.closing_date, interns.intern_id, interns.payment_amount, interns.start_date, interns.end_date, interns.application_date, interns.approved, interns.rejected, interns.action_date, interns.applicant_comments, interns.review FROM ((interns JOIN entitys ON ((interns.entity_id = entitys.entity_id))) JOIN vw_internships ON ((interns.internship_id = vw_internships.internship_id)));


ALTER TABLE public.vw_interns OWNER TO root;

--
-- Name: vw_kins; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_kins AS
    SELECT entitys.entity_id, entitys.entity_name, kin_types.kin_type_id, kin_types.kin_type_name, kins.kin_id, kins.full_names, kins.date_of_birth, kins.identification, kins.relation, kins.details FROM ((kins JOIN entitys ON ((kins.entity_id = entitys.entity_id))) JOIN kin_types ON ((kins.kin_type_id = kin_types.kin_type_id)));


ALTER TABLE public.vw_kins OWNER TO root;

--
-- Name: vw_leave_work_days; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_leave_work_days AS
    SELECT vw_employee_leave.entity_id, vw_employee_leave.entity_name, vw_employee_leave.leave_type_id, vw_employee_leave.leave_type_name, vw_employee_leave.employee_leave_id, vw_employee_leave.leave_from, vw_employee_leave.leave_to, vw_employee_leave.start_half_day, vw_employee_leave.end_half_day, leave_work_days.leave_work_day_id, leave_work_days.work_date, leave_work_days.half_day, leave_work_days.application_date, leave_work_days.approved, leave_work_days.rejected, leave_work_days.action_date, leave_work_days.details FROM (leave_work_days JOIN vw_employee_leave ON ((leave_work_days.employee_leave_id = vw_employee_leave.employee_leave_id)));


ALTER TABLE public.vw_leave_work_days OWNER TO root;

--
-- Name: vw_orgs; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_orgs AS
    SELECT orgs.org_id, orgs.org_name, orgs.is_default, orgs.is_active, orgs.logo, orgs.details, vw_address.sys_country_id, vw_address.sys_country_name, vw_address.address_id, vw_address.table_name, vw_address.post_office_box, vw_address.postal_code, vw_address.premises, vw_address.street, vw_address.town, vw_address.phone_number, vw_address.extension, vw_address.mobile, vw_address.fax, vw_address.email FROM (orgs JOIN vw_address ON ((orgs.org_id = vw_address.table_id))) WHERE ((vw_address.table_name)::text = 'orgs'::text);


ALTER TABLE public.vw_orgs OWNER TO root;

--
-- Name: vw_period_month; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_period_month AS
    SELECT vw_periods.month_id, vw_periods.period_year, vw_periods.period_month FROM vw_periods GROUP BY vw_periods.month_id, vw_periods.period_year, vw_periods.period_month ORDER BY vw_periods.month_id, vw_periods.period_year, vw_periods.period_month;


ALTER TABLE public.vw_period_month OWNER TO root;

--
-- Name: vw_period_quarter; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_period_quarter AS
    SELECT vw_periods.quarter FROM vw_periods GROUP BY vw_periods.quarter ORDER BY vw_periods.quarter;


ALTER TABLE public.vw_period_quarter OWNER TO root;

--
-- Name: vw_period_semister; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_period_semister AS
    SELECT vw_periods.semister FROM vw_periods GROUP BY vw_periods.semister ORDER BY vw_periods.semister;


ALTER TABLE public.vw_period_semister OWNER TO root;

--
-- Name: vw_period_tax_rates; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_period_tax_rates AS
    SELECT period_tax_types.period_tax_type_id, period_tax_types.period_tax_type_name, period_tax_types.tax_type_id, period_tax_types.period_id, period_tax_rates.period_tax_rate_id, gettaxmin(period_tax_rates.tax_range, period_tax_types.period_tax_type_id) AS min_range, period_tax_rates.tax_range AS max_range, period_tax_rates.tax_rate, period_tax_rates.narrative FROM (period_tax_rates JOIN period_tax_types ON ((period_tax_rates.period_tax_type_id = period_tax_types.period_tax_type_id)));


ALTER TABLE public.vw_period_tax_rates OWNER TO root;

--
-- Name: vw_period_tax_types; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_period_tax_types AS
    SELECT vw_periods.period_id, vw_periods.start_date, vw_periods.end_date, vw_periods.overtime_rate, vw_periods.activated, vw_periods.closed, vw_periods.month_id, vw_periods.period_year, vw_periods.period_month, vw_periods.quarter, vw_periods.semister, tax_types.tax_type_id, tax_types.tax_type_name, period_tax_types.period_tax_type_id, period_tax_types.period_tax_type_name, period_tax_types.pay_date, period_tax_types.tax_relief, period_tax_types.linear, period_tax_types.percentage, period_tax_types.formural, period_tax_types.details FROM ((period_tax_types JOIN vw_periods ON ((period_tax_types.period_id = vw_periods.period_id))) JOIN tax_types ON ((period_tax_types.tax_type_id = tax_types.tax_type_id)));


ALTER TABLE public.vw_period_tax_types OWNER TO root;

--
-- Name: vw_period_year; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_period_year AS
    SELECT vw_periods.period_year FROM vw_periods GROUP BY vw_periods.period_year ORDER BY vw_periods.period_year;


ALTER TABLE public.vw_period_year OWNER TO root;

--
-- Name: vw_phases; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_phases AS
    SELECT projects.project_id, projects.project_name, phases.phase_id, phases.phase_name, phases.start_date, phases.end_date, phases.phase_cost, phases.details FROM (phases JOIN projects ON ((phases.project_id = projects.project_id)));


ALTER TABLE public.vw_phases OWNER TO root;

--
-- Name: vw_projects; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_projects AS
    SELECT entitys.entity_id, entitys.entity_name, project_types.project_type_id, project_types.project_type_name, projects.project_id, projects.project_name, projects.signed, projects.contract_ref, projects.monthly_amount, projects.full_amount, projects.project_cost, projects.narrative, projects.start_date, projects.ending_date, projects.details FROM ((projects JOIN entitys ON ((projects.entity_id = entitys.entity_id))) JOIN project_types ON ((projects.project_type_id = project_types.project_type_id)));


ALTER TABLE public.vw_projects OWNER TO root;

--
-- Name: vw_skill_types; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_skill_types AS
    SELECT skill_category.skill_category_id, skill_category.skill_category_name, skill_types.skill_type_id, skill_types.skill_type_name, skill_types.basic, skill_types.intermediate, skill_types.advanced, skill_types.details FROM (skill_types JOIN skill_category ON ((skill_types.skill_category_id = skill_category.skill_category_id)));


ALTER TABLE public.vw_skill_types OWNER TO root;

--
-- Name: vw_skills; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_skills AS
    SELECT vw_skill_types.skill_category_id, vw_skill_types.skill_category_name, vw_skill_types.skill_type_id, vw_skill_types.skill_type_name, vw_skill_types.basic, vw_skill_types.intermediate, vw_skill_types.advanced, entitys.entity_id, entitys.entity_name, skills.skill_id, skills.skill_level, skills.aquired, skills.training_date, skills.trained, skills.training_institution, skills.training_cost, skills.details, CASE WHEN (skills.skill_level = 1) THEN 'Basic'::text WHEN (skills.skill_level = 2) THEN 'Intermediate'::text WHEN (skills.skill_level = 3) THEN 'Advanced'::text ELSE 'None'::text END AS skill_level_name, CASE WHEN (skills.skill_level = 1) THEN vw_skill_types.basic WHEN (skills.skill_level = 2) THEN vw_skill_types.intermediate WHEN (skills.skill_level = 3) THEN vw_skill_types.advanced ELSE 'None'::character varying END AS skill_level_details FROM ((skills JOIN entitys ON ((skills.entity_id = entitys.entity_id))) JOIN vw_skill_types ON ((skills.skill_type_id = vw_skill_types.skill_type_id)));


ALTER TABLE public.vw_skills OWNER TO root;

--
-- Name: vw_sub_fields; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_sub_fields AS
    SELECT vw_fields.form_id, vw_fields.form_name, vw_fields.field_id, sub_fields.sub_field_id, sub_fields.sub_field_order, sub_fields.sub_title_share, sub_fields.sub_field_type, sub_fields.sub_field_lookup, sub_fields.sub_field_size, sub_fields.sub_col_spans, sub_fields.manditory, sub_fields.question FROM (sub_fields JOIN vw_fields ON ((sub_fields.field_id = vw_fields.field_id)));


ALTER TABLE public.vw_sub_fields OWNER TO root;

--
-- Name: vw_sys_countrys; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_sys_countrys AS
    SELECT sys_continents.sys_continent_id, sys_continents.sys_continent_name, sys_countrys.sys_country_id, sys_countrys.sys_country_code, sys_countrys.sys_country_number, sys_countrys.sys_country_name FROM (sys_continents JOIN sys_countrys ON ((sys_continents.sys_continent_id = sys_countrys.sys_continent_id)));


ALTER TABLE public.vw_sys_countrys OWNER TO root;

--
-- Name: vw_tasks; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_tasks AS
    SELECT entitys.entity_id, entitys.entity_name, phases.phase_id, phases.phase_name, tasks.task_id, tasks.task_name, tasks.start_date, tasks.dead_line, tasks.end_date, tasks.team, tasks.narrative, tasks.completed, tasks.details FROM ((tasks JOIN entitys ON ((tasks.entity_id = entitys.entity_id))) JOIN phases ON ((tasks.phase_id = phases.phase_id)));


ALTER TABLE public.vw_tasks OWNER TO root;

--
-- Name: vw_tax_rates; Type: VIEW; Schema: public; Owner: root
--

CREATE VIEW vw_tax_rates AS
    SELECT tax_types.tax_type_id, tax_types.tax_type_name, tax_types.tax_relief, tax_types.linear, tax_types.percentage, tax_rates.tax_rate_id, tax_rates.tax_range, tax_rates.tax_rate, tax_rates.narrative FROM (tax_rates JOIN tax_types ON ((tax_rates.tax_type_id = tax_types.tax_type_id)));


ALTER TABLE public.vw_tax_rates OWNER TO root;

--
-- Name: address_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE address ALTER COLUMN address_id SET DEFAULT nextval('address_address_id_seq'::regclass);


--
-- Name: adjustment_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE adjustments ALTER COLUMN adjustment_id SET DEFAULT nextval('adjustments_adjustment_id_seq'::regclass);


--
-- Name: advance_deduction_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE advance_deductions ALTER COLUMN advance_deduction_id SET DEFAULT nextval('advance_deductions_advance_deduction_id_seq'::regclass);


--
-- Name: application_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE applications ALTER COLUMN application_id SET DEFAULT nextval('applications_application_id_seq'::regclass);


--
-- Name: approval_phase_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE approval_phases ALTER COLUMN approval_phase_id SET DEFAULT nextval('approval_phases_approval_phase_id_seq'::regclass);


--
-- Name: approval_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE approval_types ALTER COLUMN approval_type_id SET DEFAULT nextval('approval_types_approval_type_id_seq'::regclass);


--
-- Name: approval_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE approvals ALTER COLUMN approval_id SET DEFAULT nextval('approvals_approval_id_seq'::regclass);


--
-- Name: attendance_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE attendance ALTER COLUMN attendance_id SET DEFAULT nextval('attendance_attendance_id_seq'::regclass);


--
-- Name: bank_branch_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE bank_branch ALTER COLUMN bank_branch_id SET DEFAULT nextval('bank_branch_bank_branch_id_seq'::regclass);


--
-- Name: bank_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE banks ALTER COLUMN bank_id SET DEFAULT nextval('banks_bank_id_seq'::regclass);


--
-- Name: case_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE case_types ALTER COLUMN case_type_id SET DEFAULT nextval('case_types_case_type_id_seq'::regclass);


--
-- Name: casual_application_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE casual_application ALTER COLUMN casual_application_id SET DEFAULT nextval('casual_application_casual_application_id_seq'::regclass);


--
-- Name: casual_category_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE casual_category ALTER COLUMN casual_category_id SET DEFAULT nextval('casual_category_casual_category_id_seq'::regclass);


--
-- Name: casual_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE casuals ALTER COLUMN casual_id SET DEFAULT nextval('casuals_casual_id_seq'::regclass);


--
-- Name: cv_projectid; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE cv_projects ALTER COLUMN cv_projectid SET DEFAULT nextval('cv_projects_cv_projectid_seq'::regclass);


--
-- Name: cv_referee_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE cv_referees ALTER COLUMN cv_referee_id SET DEFAULT nextval('cv_referees_cv_referee_id_seq'::regclass);


--
-- Name: cv_seminar_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE cv_seminars ALTER COLUMN cv_seminar_id SET DEFAULT nextval('cv_seminars_cv_seminar_id_seq'::regclass);


--
-- Name: default_allowance_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE default_adjustments ALTER COLUMN default_allowance_id SET DEFAULT nextval('default_adjustments_default_allowance_id_seq'::regclass);


--
-- Name: default_tax_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE default_tax_types ALTER COLUMN default_tax_type_id SET DEFAULT nextval('default_tax_types_default_tax_type_id_seq'::regclass);


--
-- Name: department_role_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE department_roles ALTER COLUMN department_role_id SET DEFAULT nextval('department_roles_department_role_id_seq'::regclass);


--
-- Name: department_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE departments ALTER COLUMN department_id SET DEFAULT nextval('departments_department_id_seq'::regclass);


--
-- Name: education_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE education ALTER COLUMN education_id SET DEFAULT nextval('education_education_id_seq'::regclass);


--
-- Name: education_class_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE education_class ALTER COLUMN education_class_id SET DEFAULT nextval('education_class_education_class_id_seq'::regclass);


--
-- Name: employee_allowance_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_adjustments ALTER COLUMN employee_allowance_id SET DEFAULT nextval('employee_adjustments_employee_allowance_id_seq'::regclass);


--
-- Name: employee_advance_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_advances ALTER COLUMN employee_advance_id SET DEFAULT nextval('employee_advances_employee_advance_id_seq'::regclass);


--
-- Name: employee_case_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_cases ALTER COLUMN employee_case_id SET DEFAULT nextval('employee_cases_employee_case_id_seq'::regclass);


--
-- Name: employee_leave_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_leave ALTER COLUMN employee_leave_id SET DEFAULT nextval('employee_leave_employee_leave_id_seq'::regclass);


--
-- Name: employee_month_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_month ALTER COLUMN employee_month_id SET DEFAULT nextval('employee_month_employee_month_id_seq'::regclass);


--
-- Name: employee_overtime_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_overtime ALTER COLUMN employee_overtime_id SET DEFAULT nextval('employee_overtime_employee_overtime_id_seq'::regclass);


--
-- Name: employee_per_diem_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_per_diem ALTER COLUMN employee_per_diem_id SET DEFAULT nextval('employee_per_diem_employee_per_diem_id_seq'::regclass);


--
-- Name: employee_tax_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employee_tax_types ALTER COLUMN employee_tax_type_id SET DEFAULT nextval('employee_tax_types_employee_tax_type_id_seq'::regclass);


--
-- Name: employment_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE employment ALTER COLUMN employment_id SET DEFAULT nextval('employment_employment_id_seq'::regclass);


--
-- Name: entiry_ref_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE entiry_refs ALTER COLUMN entiry_ref_id SET DEFAULT nextval('entiry_refs_entiry_ref_id_seq'::regclass);


--
-- Name: entity_subscription_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE entity_subscriptions ALTER COLUMN entity_subscription_id SET DEFAULT nextval('entity_subscriptions_entity_subscription_id_seq'::regclass);


--
-- Name: entity_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE entity_types ALTER COLUMN entity_type_id SET DEFAULT nextval('entity_types_entity_type_id_seq'::regclass);


--
-- Name: entity_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE entitys ALTER COLUMN entity_id SET DEFAULT nextval('entitys_entity_id_seq'::regclass);


--
-- Name: entry_form_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE entry_forms ALTER COLUMN entry_form_id SET DEFAULT nextval('entry_forms_entry_form_id_seq'::regclass);


--
-- Name: entry_sub_form_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE entry_sub_forms ALTER COLUMN entry_sub_form_id SET DEFAULT nextval('entry_sub_forms_entry_sub_form_id_seq'::regclass);


--
-- Name: evaluation_point_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE evaluation_points ALTER COLUMN evaluation_point_id SET DEFAULT nextval('evaluation_points_evaluation_point_id_seq'::regclass);


--
-- Name: field_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE fields ALTER COLUMN field_id SET DEFAULT nextval('fields_field_id_seq'::regclass);


--
-- Name: form_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE forms ALTER COLUMN form_id SET DEFAULT nextval('forms_form_id_seq'::regclass);


--
-- Name: intake_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE intake ALTER COLUMN intake_id SET DEFAULT nextval('intake_intake_id_seq'::regclass);


--
-- Name: intern_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE interns ALTER COLUMN intern_id SET DEFAULT nextval('interns_intern_id_seq'::regclass);


--
-- Name: internship_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE internships ALTER COLUMN internship_id SET DEFAULT nextval('internships_internship_id_seq'::regclass);


--
-- Name: job_review_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE job_reviews ALTER COLUMN job_review_id SET DEFAULT nextval('job_reviews_job_review_id_seq'::regclass);


--
-- Name: kin_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE kin_types ALTER COLUMN kin_type_id SET DEFAULT nextval('kin_types_kin_type_id_seq'::regclass);


--
-- Name: kin_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE kins ALTER COLUMN kin_id SET DEFAULT nextval('kins_kin_id_seq'::regclass);


--
-- Name: leave_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE leave_types ALTER COLUMN leave_type_id SET DEFAULT nextval('leave_types_leave_type_id_seq'::regclass);


--
-- Name: leave_work_day_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE leave_work_days ALTER COLUMN leave_work_day_id SET DEFAULT nextval('leave_work_days_leave_work_day_id_seq'::regclass);


--
-- Name: org_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE orgs ALTER COLUMN org_id SET DEFAULT nextval('orgs_org_id_seq'::regclass);


--
-- Name: pay_group_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE pay_groups ALTER COLUMN pay_group_id SET DEFAULT nextval('pay_groups_pay_group_id_seq'::regclass);


--
-- Name: period_tax_rate_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE period_tax_rates ALTER COLUMN period_tax_rate_id SET DEFAULT nextval('period_tax_rates_period_tax_rate_id_seq'::regclass);


--
-- Name: period_tax_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE period_tax_types ALTER COLUMN period_tax_type_id SET DEFAULT nextval('period_tax_types_period_tax_type_id_seq'::regclass);


--
-- Name: period_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE periods ALTER COLUMN period_id SET DEFAULT nextval('periods_period_id_seq'::regclass);


--
-- Name: phase_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE phases ALTER COLUMN phase_id SET DEFAULT nextval('phases_phase_id_seq'::regclass);


--
-- Name: project_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE project_types ALTER COLUMN project_type_id SET DEFAULT nextval('project_types_project_type_id_seq'::regclass);


--
-- Name: project_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE projects ALTER COLUMN project_id SET DEFAULT nextval('projects_project_id_seq'::regclass);


--
-- Name: review_category_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE review_category ALTER COLUMN review_category_id SET DEFAULT nextval('review_category_review_category_id_seq'::regclass);


--
-- Name: review_point_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE review_points ALTER COLUMN review_point_id SET DEFAULT nextval('review_points_review_point_id_seq'::regclass);


--
-- Name: skill_category_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE skill_category ALTER COLUMN skill_category_id SET DEFAULT nextval('skill_category_skill_category_id_seq'::regclass);


--
-- Name: skill_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE skill_types ALTER COLUMN skill_type_id SET DEFAULT nextval('skill_types_skill_type_id_seq'::regclass);


--
-- Name: skill_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE skills ALTER COLUMN skill_id SET DEFAULT nextval('skills_skill_id_seq'::regclass);


--
-- Name: sub_field_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sub_fields ALTER COLUMN sub_field_id SET DEFAULT nextval('sub_fields_sub_field_id_seq'::regclass);


--
-- Name: sys_audit_detail_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_audit_details ALTER COLUMN sys_audit_detail_id SET DEFAULT nextval('sys_audit_details_sys_audit_detail_id_seq'::regclass);


--
-- Name: sys_audit_trail_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_audit_trail ALTER COLUMN sys_audit_trail_id SET DEFAULT nextval('sys_audit_trail_sys_audit_trail_id_seq'::regclass);


--
-- Name: sys_emailed_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_emailed ALTER COLUMN sys_emailed_id SET DEFAULT nextval('sys_emailed_sys_emailed_id_seq'::regclass);


--
-- Name: sys_email_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_emails ALTER COLUMN sys_email_id SET DEFAULT nextval('sys_emails_sys_email_id_seq'::regclass);


--
-- Name: sys_error_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_errors ALTER COLUMN sys_error_id SET DEFAULT nextval('sys_errors_sys_error_id_seq'::regclass);


--
-- Name: sys_file_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_files ALTER COLUMN sys_file_id SET DEFAULT nextval('sys_files_sys_file_id_seq'::regclass);


--
-- Name: sys_login_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_logins ALTER COLUMN sys_login_id SET DEFAULT nextval('sys_logins_sys_login_id_seq'::regclass);


--
-- Name: sys_news_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_news ALTER COLUMN sys_news_id SET DEFAULT nextval('sys_news_sys_news_id_seq'::regclass);


--
-- Name: sys_password_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE sys_passwords ALTER COLUMN sys_password_id SET DEFAULT nextval('sys_passwords_sys_password_id_seq'::regclass);


--
-- Name: task_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE tasks ALTER COLUMN task_id SET DEFAULT nextval('tasks_task_id_seq'::regclass);


--
-- Name: tax_rate_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE tax_rates ALTER COLUMN tax_rate_id SET DEFAULT nextval('tax_rates_tax_rate_id_seq'::regclass);


--
-- Name: tax_type_id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE tax_types ALTER COLUMN tax_type_id SET DEFAULT nextval('tax_types_tax_type_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: adjustments; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO adjustments VALUES (1, 'Sacco Allowance', 1, 0, NULL, true, true, true, true, NULL);
INSERT INTO adjustments VALUES (2, 'Bonus', 1, 0, NULL, true, true, true, true, NULL);
INSERT INTO adjustments VALUES (11, 'SACCO', 2, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (12, 'HELB', 2, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (13, 'Rent Payment', 2, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (21, 'Travel', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (22, 'Communcation', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (23, 'Tools', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (24, 'Payroll Cost', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (25, 'Health Insurance', 3, 0, NULL, true, true, false, false, NULL);
INSERT INTO adjustments VALUES (26, 'GPA Insurance', 3, 0, NULL, true, true, false, false, NULL);
INSERT INTO adjustments VALUES (27, 'Accomodation', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (28, 'Avenue Health Care', 3, 0, NULL, true, true, false, false, NULL);
INSERT INTO adjustments VALUES (29, 'Maternety Cost', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (30, 'Health care claims', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (31, 'Trainining', 3, 0, NULL, true, true, false, true, NULL);
INSERT INTO adjustments VALUES (32, 'per diem', 3, 0, NULL, true, true, false, true, NULL);


--
-- Data for Name: advance_deductions; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: applicant; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: approval_phases; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: approval_types; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO approval_types VALUES (0, 'Final', NULL);


--
-- Data for Name: approvals; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: bank_branch; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO bank_branch VALUES (0, 0, 'Cash Payment', '00-000', NULL);
INSERT INTO bank_branch VALUES (1, 1, 'University Way', NULL, NULL);
INSERT INTO bank_branch VALUES (2, 1, 'Mombasa', NULL, NULL);
INSERT INTO bank_branch VALUES (3, 1, 'Eldoret', NULL, NULL);
INSERT INTO bank_branch VALUES (4, 2, 'Moi Avenue', NULL, NULL);
INSERT INTO bank_branch VALUES (6, 3, 'Koinange', NULL, NULL);
INSERT INTO bank_branch VALUES (7, 4, 'Fourways', NULL, NULL);
INSERT INTO bank_branch VALUES (8, 5, 'Rongai', NULL, NULL);
INSERT INTO bank_branch VALUES (9, 4, 'Eldoret', NULL, NULL);
INSERT INTO bank_branch VALUES (10, 4, 'Tom Mboya', NULL, NULL);
INSERT INTO bank_branch VALUES (11, 5, 'Queensway', NULL, NULL);


--
-- Data for Name: banks; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO banks VALUES (0, 'Cash Payment', NULL);
INSERT INTO banks VALUES (1, 'Co-op', NULL);
INSERT INTO banks VALUES (2, 'KCB', NULL);
INSERT INTO banks VALUES (3, 'Standard Chartered', NULL);
INSERT INTO banks VALUES (4, 'Equity', NULL);
INSERT INTO banks VALUES (5, 'Barclays', NULL);


--
-- Data for Name: case_types; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: casual_application; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: casual_category; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: casuals; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: cv_projects; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: cv_referees; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: cv_seminars; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: default_adjustments; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: default_tax_types; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: department_roles; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO department_roles VALUES (0, 0, 0, 'Chair Person', true, NULL, NULL, NULL, NULL, NULL);
INSERT INTO department_roles VALUES (1, 0, 0, 'Chief Executive Officer', true, '- Defining short term and long term corporate strategies and objectives
- Direct overall company operations ', NULL, '- Develop and control strategic relationships with third-party companies
- Guide the development of client specific systems
- Provide leadership and monitor team performance and individual staff performance ', NULL, NULL);
INSERT INTO department_roles VALUES (2, 1, 1, 'Director, Development', true, '- To direct and guide in systems and products development.
- Provide leadership and monitor team performance and individual staff performance ', NULL, NULL, NULL, NULL);
INSERT INTO department_roles VALUES (3, 2, 0, 'Director, Projects', true, '- To direct and guide projects support services
- Train end client users 
- Provide leadership and monitor team performance and individual staff performance ', NULL, NULL, NULL, NULL);
INSERT INTO department_roles VALUES (4, 3, 0, 'Director, Infrastructure', true, '- To direct and guide projects implementation
- Train end client users 
- Provide leadership and monitor team performance and individual staff performance ', NULL, NULL, NULL, NULL);
INSERT INTO department_roles VALUES (5, 1, 2, 'System Developer', true, '- Systems analysis, design and development: To study, analyse, design, conceive system solutions, develop, test, organisational information systems with an aim of improving the data and information systems by implementing logical structures for solving problems by computer.
 
- To solve computer problems and apply computer technology to meet the individual needs of client organisations by helping them to realise maximum benefits from their investments in equipment, personnel and business processes  
 
- To design and develop web applications and web sites', 'Academic
- Degree or HND in computer science, management information systems, mathematics or engineering.
 
Technical 
- Practical knowledge and experience in a variety of systems including business, accounting, financial systems, scientific and engineering systems 
- Ability to define client needs/goals and divide solutions into individual steps and separate procedures
- Ability to use structured analysis, data modelling, information engineering, mathematical model building, sampling and cost accounting to plan systems
- Proficiency in databases, programming  and object oriented programming languages, client server applications development and multimedia and internet technology
- Practical knowledge of conventional programming languages such as Visual Basic and Delphi; object-oriented languages such as Java and C++.
- Practical Knowledge of database systems such as MS Access, Oracle, MySql, MS SQL, Postgres or Sybase.
- Ability to quickly identify appropriate programming language depending on the purpose of the program. 
- Ability to work with abstract concepts and do technical analysis
- Ability to support data communications and implement electronic commerce  and intranet strategies in client/server, Web-based, and wireless environments 
- Familiarity with digital security issues and skilled in using appropriate security technology.
- Strong technical skills, knowledge of internet working technologies, HTML,, CSS2 and JavaScript.
- Extensible Mark up Language (XML) J2EE (Java 2 Platform).
- Web programming: ASP, PHP, JSP, Java Servlets, or Perl CGI 
- Experience with following software: Macromedia Dreamweaver, Adobe Photoshop, Adobe Illustrator, Microsoft Office.
- Can work well with Operating systems: Linux and Windows (9x/2000/2000 Server/2003/XP).
- A general technical knowledge of computers hardware and computer maintenance.
 
Personal
- Analytical, logical 
- meticulous attention to detail
- patience, persistence and ability to work on exacting  analytical work, especially under pressure
- ingenuity and creativity 
- Communicate with people with people with technical and non-technical backgrounds to develop detailed understanding of user needs
- able to communicate with non-technical people', '- Practical knowledge and experience in a variety of systems including business, accounting, financial systems, scientific and engineering systems 
- Ability to define client needs/goals and divide solutions into individual steps and separate procedures
- Ability to use structured analysis, data modelling, information engineering, mathematical model building, sampling and cost accounting to plan systems
- Specify inputs to be accessed by the recommended system, design the processing steps, and format the out put to meet user needs 
- To prepare cost-benefit and return on investment analyses to help client organisations decide whether implementing the proposed technology will be financially feasible.
- Determine computer hardware and software will be needed to set the system up
- Prepare specifications, flow charts, and process diagrams for programmers, work with programmers to debug errors
- Review, analyze, design, programme, develop and implement software products
- Plan, develop and design new systems, including both hardware and software, or add new software and web applications or devise ways to apply existing systems’ resources to additional operations.
- Convert project specifications and procedures to detailed logical flow charts for coding
- Write code, complete programming , test and debug systems and applications programmes
- Create dynamic, interactive and personalised web sites
- May train, and direct the work of others
- Work with customers to develop new or custom features to software products/services
- Integrate, showcase and maintain complimentary technologies as the emerge', NULL, NULL);
INSERT INTO department_roles VALUES (6, 3, 4, 'Systems Engineer', true, 'To apply principles and techniques of computer science, engineering and mathematical to develops, test and evaluate software and systems', 'Academic
- Degree, HND in computer science, computer information systems, software engineering, electronics, or engineering 
 
Technical 
- Practical knowledge and experience in software development-operating systems and network distribution and, compilers 
- Strong programming skills and languages such as C, C++ and Java.
- Ability to quickly identify appropriate programming language depending on the purpose of the program 
- Ability to work with abstract concepts and do technical analysis
- Ability to  support data communications and implement electronic commerce  and intranet strategies in client/server, Web-based, and wireless environments 
- Familiarity with digital security issues and skilled in using appropriate security technology 
- Networking Administration: TCP/IP, File sharing, FTP, SAMBA 

Personal
- Analytical, logical 
- meticulous attention to detail
- patience, persistence and ability to work on exacting  analytical work, especially under pressure
- ingenuity and creativity 
- able to communicate with non-technical people
- Communicate with people with non-technical backgrounds to develop detailed understanding of user needs', '- Research and evaluate business systems to provide systems capabilities required for projected workloads
- Analyse user needs and design, construct, test, and maintain computer applications software or systems
- Coordinate tests, diagnose problems, recommend solutions and determine whether program requirements have been met. 
- Plans layout and installation of new systems or modification of existing systems
- May write programmes, set up, and control computer systems to solve scientific problems or automate business system applications 
- Coordinate the construction and maintenance of client systems and assist in planning future growth
- Set up client intranets', NULL, NULL);
INSERT INTO department_roles VALUES (7, 14, 3, 'Support Engineer', true, 'To provide technical support, helpdesk and administration and advice to clients and users.', 'Academic
- Degree, HND, Diploma in computer science, computer information science, management information systems
 
Technical 
- Practical knowledge and experience in software development-operating systems and network distribution and, compilers 
- Ability to  support data communications and implement electronic commerce  and intranet strategies in client/server, Web-based, and wireless environments 
- Familiarity with digital security issues and skilled in using appropriate security technology 
- Networking Administration: TCP/IP, File sharing, FTP, SAMBA 
 
Personal
- Careful listener and inquirer 
- Strong problem solving and analytical   skills
- Patience attention to detail, diagnose the problem and walk clients through the problem solving steps
- able to communicate with non-technical people
- Communicate with people with people with technical and non-technical backgrounds to develop detailed understanding of user needs', '- Help computer users solve software and hardware problems. 
- Install software or make minor repairs to computers following design or installation directions. 
- Set up computer equipment and make sure the system runs correctly. 
- Maintain record of telephone calls and e-mails. Track what types of problems, what they did to help, and what software they installed. 
- Read technical manuals, talk with users, and conduct computer tests. Learn what the problem is and find ways to solve it. 
- Supervise other computer support workers. 
- Develop training materials and train staff on company procedures. 
- Refer major hardware or software problems to the company who made it or to service technicians. 
- Evaluate new software and hardware. 
- Evaluate if customers are using the proper software and hardware for their needs. 
- Test and monitor software, hardware, and connected equipment. ', NULL, NULL);
INSERT INTO department_roles VALUES (8, 14, 3, 'Helpdesk Personel', true, 'Helpdesk support', 'Academic
- Degree, HND, Diploma in computer science, computer information science, management information systems
 
Technical 
- Practical knowledge and experience in software development-operating systems and network distribution and, compilers 
- Ability to  support data communications and implement electronic commerce  and intranet strategies in client/server, Web-based, and wireless environments 
- Familiarity with digital security issues and skilled in using appropriate security technology 
- Networking Administration: TCP/IP, File sharing, FTP, SAMBA 
 
Personal
- Careful listener and inquirer 
- Strong problem solving and analytical   skills
- Patience attention to detail, diagnose the problem and walk clients through the problem solving steps
- able to communicate with non-technical people
- Communicate with people with people with technical and non-technical backgrounds to develop detailed understanding of user needs', '- Perform system troubleshooting, diagnostics and telephone problem resolutions 
- Conduct and schedule training sessions for end users of the system.
- Coordinate hardware and software installations with both the user and the Support Engineers
- Distribute software electronically
- Create customer and management reports
- Market helpdesk services and training services', NULL, NULL);
INSERT INTO department_roles VALUES (9, 14, 3, 'System Administrator', true, 'Adminsitration of servers and network systems.', 'Academic
- Degree, HND, Diploma in computer science, computer information science, management information systems
 
Technical 
- Practical knowledge and experience in software development-operating systems and network distribution and, compilers 
- Ability to  support data communications and implement electronic commerce  and intranet strategies in client/server, Web-based, and wireless environments 
- Familiarity with digital security issues and skilled in using appropriate security technology 
- Networking Administration: TCP/IP, File sharing, FTP, SAMBA 
 
Personal
- Careful listener and inquirer 
- Strong problem solving and analytical   skills
- Patience attention to detail, diagnose the problem and walk clients through the problem solving steps
- able to communicate with non-technical people
- Communicate with people with people with technical and non-technical backgrounds to develop detailed understanding of user needs', '- Ability to solve problems quickly and automate processes. 
- A solid understanding of the system and can use performance analysis tools to tune systems. 
- Implements complex local and wide-area networks for intranets, extranets and the Internet. 
- Manages a large, complex site or network. 
- Establishes/recommends policies on system use and services. 
- Plan coordinate and implement network security measures', NULL, NULL);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO departments VALUES (0, 0, 'Board of Directors', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (1, 0, 'Development', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (2, 0, 'Projects', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (3, 0, 'Infrastructure', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (4, 0, 'Administration', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (5, 0, 'Sales and Marketing', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (10, 4, 'Human Resources', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (11, 4, 'Finance', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (12, 4, 'Procurement', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (13, 2, 'Implementation', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (14, 2, 'Support', true, NULL, NULL, NULL, NULL);
INSERT INTO departments VALUES (15, 2, 'Training', true, NULL, NULL, NULL, NULL);


--
-- Data for Name: education; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: education_class; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO education_class VALUES (1, 'Primary School', NULL);
INSERT INTO education_class VALUES (2, 'Secondary School', NULL);
INSERT INTO education_class VALUES (3, 'High School', NULL);
INSERT INTO education_class VALUES (4, 'Certificate', NULL);
INSERT INTO education_class VALUES (5, 'Diploma', NULL);
INSERT INTO education_class VALUES (6, 'Higher Diploma', NULL);
INSERT INTO education_class VALUES (7, 'Under Graduate', NULL);
INSERT INTO education_class VALUES (8, 'Post Graduate', NULL);


--
-- Data for Name: employee_adjustments; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_advances; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_cases; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_leave; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_month; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_overtime; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_per_diem; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employee_tax_types; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: employment; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: entiry_refs; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: entity_subscriptions; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO entity_subscriptions VALUES (0, 0, 0, NULL);


--
-- Data for Name: entity_types; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO entity_types VALUES (0, 'Users', 'user', NULL, NULL);
INSERT INTO entity_types VALUES (1, 'Staff', 'staff', NULL, NULL);
INSERT INTO entity_types VALUES (2, 'Client', 'client', NULL, NULL);
INSERT INTO entity_types VALUES (3, 'Supplier', 'supplier', NULL, NULL);
INSERT INTO entity_types VALUES (4, 'Applicant', 'applicant', NULL, NULL);


--
-- Data for Name: entitys; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO entitys VALUES (0, 0, 0, 'root', 'root', true, true, NULL, '2011-02-24 14:31:17.731212', true, 'e2a7106f1cc8bb1e1318df70aa0a3540', 'enter', NULL);


--
-- Data for Name: entry_forms; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: entry_sub_forms; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: evaluation_points; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: fields; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: forms; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: intake; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: interns; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: internships; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: job_reviews; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: kin_types; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO kin_types VALUES (1, 'Wife', NULL);
INSERT INTO kin_types VALUES (2, 'Husband', NULL);
INSERT INTO kin_types VALUES (3, 'Daughter', NULL);
INSERT INTO kin_types VALUES (4, 'Son', NULL);
INSERT INTO kin_types VALUES (5, 'Mother', NULL);
INSERT INTO kin_types VALUES (6, 'Father', NULL);
INSERT INTO kin_types VALUES (7, 'Brother', NULL);
INSERT INTO kin_types VALUES (8, 'Sister', NULL);
INSERT INTO kin_types VALUES (9, 'Others', NULL);


--
-- Data for Name: kins; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO leave_types VALUES (0, 'Annual Leave', 21, 7, NULL);


--
-- Data for Name: leave_work_days; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: orgs; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO orgs VALUES (0, 'default', true, true, NULL, NULL);


--
-- Data for Name: pay_groups; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO pay_groups VALUES (0, 'Default', NULL);


--
-- Data for Name: period_tax_rates; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: period_tax_types; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: periods; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: phases; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: project_types; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: review_category; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: review_points; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: skill_category; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO skill_category VALUES (1, 'Hardware', NULL);
INSERT INTO skill_category VALUES (2, 'Operating System', NULL);
INSERT INTO skill_category VALUES (3, 'Software', NULL);
INSERT INTO skill_category VALUES (4, 'Networking', NULL);
INSERT INTO skill_category VALUES (6, 'Servers', NULL);
INSERT INTO skill_category VALUES (8, 'Communication/Messaging Suite', NULL);
INSERT INTO skill_category VALUES (9, 'Voip', NULL);
INSERT INTO skill_category VALUES (10, 'Development', NULL);


--
-- Data for Name: skill_types; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO skill_types VALUES (1, 1, 'Personal Computer', 'Identify the different components of a computer', 'Understand the working of each component', 'Troubleshoot, Diagonize and Repair', NULL);
INSERT INTO skill_types VALUES (2, 1, 'Dot Matrix Printer', 'Identify the different components of a computer', 'Understand the working of each component', 'Troubleshoot, Diagonize and Repair', NULL);
INSERT INTO skill_types VALUES (3, 1, 'Ticket Printer', 'Identify the different components of a computer', 'Understand the working of each component', 'Troubleshoot, Diagonize and Repair', NULL);
INSERT INTO skill_types VALUES (4, 1, 'Hp Printer', 'Identify the different components of a computer', 'Understand the working of each component', 'Troubleshoot, Diagonize and Repair', NULL);
INSERT INTO skill_types VALUES (5, 2, 'Dos', 'Installation', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (6, 2, 'Windowsxp', 'Installation', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (7, 2, 'Linux', 'Installation', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (8, 2, 'Solaris Unix', 'Installation', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (10, 3, 'Office', 'Installation, Backup and Recovery', 'Application and Usage', 'Advanced Usage', NULL);
INSERT INTO skill_types VALUES (11, 3, 'Browsing', 'Setup ', 'Usage ', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (12, 3, 'Galileo Products', 'Setup ', 'Usage ', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (13, 3, 'Antivirus', 'Setup ', 'Updates and Support', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (9, 3, 'Dialup', 'Installation', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (21, 4, 'Dialup', 'Dialup', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (22, 4, 'Lan', 'Installation ', 'Configuration', 'Troubleshooting and Support', NULL);
INSERT INTO skill_types VALUES (23, 4, 'Wan', 'Installation', 'Configuration', 'Configuration', NULL);
INSERT INTO skill_types VALUES (29, 6, 'Samba', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (30, 6, 'Mail', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (31, 6, 'Web', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (32, 6, 'Application ', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (33, 6, 'Identity Management', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (34, 6, 'Network Management   ', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (36, 6, 'Backup And Storage Services', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (37, 8, 'Groupware', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (38, 9, 'Asterix', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (39, 10, 'Database', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (40, 10, 'Design', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (41, 10, 'Baraza', NULL, NULL, NULL, NULL);
INSERT INTO skill_types VALUES (42, 10, 'Coding Java', NULL, NULL, NULL, NULL);


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sub_fields; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_audit_details; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_audit_trail; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_continents; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO sys_continents VALUES ('AF', 'Africa');
INSERT INTO sys_continents VALUES ('AS', 'Asia');
INSERT INTO sys_continents VALUES ('EU', 'Europe');
INSERT INTO sys_continents VALUES ('NA', 'North America');
INSERT INTO sys_continents VALUES ('SA', 'South America');
INSERT INTO sys_continents VALUES ('OC', 'Oceania');
INSERT INTO sys_continents VALUES ('AN', 'Antarctica');


--
-- Data for Name: sys_countrys; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO sys_countrys VALUES ('AF', 'AS', 'AFG', '004', 'Afghanistan');
INSERT INTO sys_countrys VALUES ('AX', 'EU', 'ALA', '248', 'Aland Islands');
INSERT INTO sys_countrys VALUES ('AL', 'EU', 'ALB', '008', 'Albania');
INSERT INTO sys_countrys VALUES ('DZ', 'AF', 'DZA', '012', 'Algeria');
INSERT INTO sys_countrys VALUES ('AS', 'OC', 'ASM', '016', 'American Samoa');
INSERT INTO sys_countrys VALUES ('AD', 'EU', 'AND', '020', 'Andorra');
INSERT INTO sys_countrys VALUES ('AO', 'AF', 'AGO', '024', 'Angola');
INSERT INTO sys_countrys VALUES ('AI', 'NA', 'AIA', '660', 'Anguilla');
INSERT INTO sys_countrys VALUES ('AQ', 'AN', 'ATA', '010', 'Antarctica');
INSERT INTO sys_countrys VALUES ('AG', 'NA', 'ATG', '028', 'Antigua and Barbuda');
INSERT INTO sys_countrys VALUES ('AR', 'SA', 'ARG', '032', 'Argentina');
INSERT INTO sys_countrys VALUES ('AM', 'AS', 'ARM', '051', 'Armenia');
INSERT INTO sys_countrys VALUES ('AW', 'NA', 'ABW', '533', 'Aruba');
INSERT INTO sys_countrys VALUES ('AU', 'OC', 'AUS', '036', 'Australia');
INSERT INTO sys_countrys VALUES ('AT', 'EU', 'AUT', '040', 'Austria');
INSERT INTO sys_countrys VALUES ('AZ', 'AS', 'AZE', '031', 'Azerbaijan');
INSERT INTO sys_countrys VALUES ('BS', 'NA', 'BHS', '044', 'Bahamas');
INSERT INTO sys_countrys VALUES ('BH', 'AS', 'BHR', '048', 'Bahrain');
INSERT INTO sys_countrys VALUES ('BD', 'AS', 'BGD', '050', 'Bangladesh');
INSERT INTO sys_countrys VALUES ('BB', 'NA', 'BRB', '052', 'Barbados');
INSERT INTO sys_countrys VALUES ('BY', 'EU', 'BLR', '112', 'Belarus');
INSERT INTO sys_countrys VALUES ('BE', 'EU', 'BEL', '056', 'Belgium');
INSERT INTO sys_countrys VALUES ('BZ', 'NA', 'BLZ', '084', 'Belize');
INSERT INTO sys_countrys VALUES ('BJ', 'AF', 'BEN', '204', 'Benin');
INSERT INTO sys_countrys VALUES ('BM', 'NA', 'BMU', '060', 'Bermuda');
INSERT INTO sys_countrys VALUES ('BT', 'AS', 'BTN', '064', 'Bhutan');
INSERT INTO sys_countrys VALUES ('BO', 'SA', 'BOL', '068', 'Bolivia');
INSERT INTO sys_countrys VALUES ('BA', 'EU', 'BIH', '070', 'Bosnia and Herzegovina');
INSERT INTO sys_countrys VALUES ('BW', 'AF', 'BWA', '072', 'Botswana');
INSERT INTO sys_countrys VALUES ('BV', 'AN', 'BVT', '074', 'Bouvet Island');
INSERT INTO sys_countrys VALUES ('BR', 'SA', 'BRA', '076', 'Brazil');
INSERT INTO sys_countrys VALUES ('IO', 'AS', 'IOT', '086', 'British Indian Ocean Territory');
INSERT INTO sys_countrys VALUES ('VG', 'NA', 'VGB', '092', 'British Virgin Islands');
INSERT INTO sys_countrys VALUES ('BN', 'AS', 'BRN', '096', 'Brunei Darussalam');
INSERT INTO sys_countrys VALUES ('BG', 'EU', 'BGR', '100', 'Bulgaria');
INSERT INTO sys_countrys VALUES ('BF', 'AF', 'BFA', '854', 'Burkina Faso');
INSERT INTO sys_countrys VALUES ('BI', 'AF', 'BDI', '108', 'Burundi');
INSERT INTO sys_countrys VALUES ('KH', 'AS', 'KHM', '116', 'Cambodia');
INSERT INTO sys_countrys VALUES ('CM', 'AF', 'CMR', '120', 'Cameroon');
INSERT INTO sys_countrys VALUES ('CA', 'NA', 'CAN', '124', 'Canada');
INSERT INTO sys_countrys VALUES ('CV', 'AF', 'CPV', '132', 'Cape Verde');
INSERT INTO sys_countrys VALUES ('KY', 'NA', 'CYM', '136', 'Cayman Islands');
INSERT INTO sys_countrys VALUES ('CF', 'AF', 'CAF', '140', 'Central African Republic');
INSERT INTO sys_countrys VALUES ('TD', 'AF', 'TCD', '148', 'Chad');
INSERT INTO sys_countrys VALUES ('CL', 'SA', 'CHL', '152', 'Chile');
INSERT INTO sys_countrys VALUES ('CN', 'AS', 'CHN', '156', 'China');
INSERT INTO sys_countrys VALUES ('CX', 'AS', 'CXR', '162', 'Christmas Island');
INSERT INTO sys_countrys VALUES ('CC', 'AS', 'CCK', '166', 'Cocos Keeling Islands');
INSERT INTO sys_countrys VALUES ('CO', 'SA', 'COL', '170', 'Colombia');
INSERT INTO sys_countrys VALUES ('KM', 'AF', 'COM', '174', 'Comoros');
INSERT INTO sys_countrys VALUES ('CD', 'AF', 'COD', '180', 'Democratic Republic of Congo');
INSERT INTO sys_countrys VALUES ('CG', 'AF', 'COG', '178', 'Republic of Congo');
INSERT INTO sys_countrys VALUES ('CK', 'OC', 'COK', '184', 'Cook Islands');
INSERT INTO sys_countrys VALUES ('CR', 'NA', 'CRI', '188', 'Costa Rica');
INSERT INTO sys_countrys VALUES ('CI', 'AF', 'CIV', '384', 'Cote d Ivoire');
INSERT INTO sys_countrys VALUES ('HR', 'EU', 'HRV', '191', 'Croatia');
INSERT INTO sys_countrys VALUES ('CU', 'NA', 'CUB', '192', 'Cuba');
INSERT INTO sys_countrys VALUES ('CY', 'AS', 'CYP', '196', 'Cyprus');
INSERT INTO sys_countrys VALUES ('CZ', 'EU', 'CZE', '203', 'Czech Republic');
INSERT INTO sys_countrys VALUES ('DK', 'EU', 'DNK', '208', 'Denmark');
INSERT INTO sys_countrys VALUES ('DJ', 'AF', 'DJI', '262', 'Djibouti');
INSERT INTO sys_countrys VALUES ('DM', 'NA', 'DMA', '212', 'Dominica');
INSERT INTO sys_countrys VALUES ('DO', 'NA', 'DOM', '214', 'Dominican Republic');
INSERT INTO sys_countrys VALUES ('EC', 'SA', 'ECU', '218', 'Ecuador');
INSERT INTO sys_countrys VALUES ('EG', 'AF', 'EGY', '818', 'Egypt');
INSERT INTO sys_countrys VALUES ('SV', 'NA', 'SLV', '222', 'El Salvador');
INSERT INTO sys_countrys VALUES ('GQ', 'AF', 'GNQ', '226', 'Equatorial Guinea');
INSERT INTO sys_countrys VALUES ('ER', 'AF', 'ERI', '232', 'Eritrea');
INSERT INTO sys_countrys VALUES ('EE', 'EU', 'EST', '233', 'Estonia');
INSERT INTO sys_countrys VALUES ('ET', 'AF', 'ETH', '231', 'Ethiopia');
INSERT INTO sys_countrys VALUES ('FO', 'EU', 'FRO', '234', 'Faroe Islands');
INSERT INTO sys_countrys VALUES ('FK', 'SA', 'FLK', '238', 'Falkland Islands');
INSERT INTO sys_countrys VALUES ('FJ', 'OC', 'FJI', '242', 'Fiji');
INSERT INTO sys_countrys VALUES ('FI', 'EU', 'FIN', '246', 'Finland');
INSERT INTO sys_countrys VALUES ('FR', 'EU', 'FRA', '250', 'France');
INSERT INTO sys_countrys VALUES ('GF', 'SA', 'GUF', '254', 'French Guiana');
INSERT INTO sys_countrys VALUES ('PF', 'OC', 'PYF', '258', 'French Polynesia');
INSERT INTO sys_countrys VALUES ('TF', 'AN', 'ATF', '260', 'French Southern Territories');
INSERT INTO sys_countrys VALUES ('GA', 'AF', 'GAB', '266', 'Gabon');
INSERT INTO sys_countrys VALUES ('GM', 'AF', 'GMB', '270', 'Gambia');
INSERT INTO sys_countrys VALUES ('GE', 'AS', 'GEO', '268', 'Georgia');
INSERT INTO sys_countrys VALUES ('DE', 'EU', 'DEU', '276', 'Germany');
INSERT INTO sys_countrys VALUES ('GH', 'AF', 'GHA', '288', 'Ghana');
INSERT INTO sys_countrys VALUES ('GI', 'EU', 'GIB', '292', 'Gibraltar');
INSERT INTO sys_countrys VALUES ('GR', 'EU', 'GRC', '300', 'Greece');
INSERT INTO sys_countrys VALUES ('GL', 'NA', 'GRL', '304', 'Greenland');
INSERT INTO sys_countrys VALUES ('GD', 'NA', 'GRD', '308', 'Grenada');
INSERT INTO sys_countrys VALUES ('GP', 'NA', 'GLP', '312', 'Guadeloupe');
INSERT INTO sys_countrys VALUES ('GU', 'OC', 'GUM', '316', 'Guam');
INSERT INTO sys_countrys VALUES ('GT', 'NA', 'GTM', '320', 'Guatemala');
INSERT INTO sys_countrys VALUES ('GG', 'EU', 'GGY', '831', 'Guernsey');
INSERT INTO sys_countrys VALUES ('GN', 'AF', 'GIN', '324', 'Guinea');
INSERT INTO sys_countrys VALUES ('GW', 'AF', 'GNB', '624', 'Guinea-Bissau');
INSERT INTO sys_countrys VALUES ('GY', 'SA', 'GUY', '328', 'Guyana');
INSERT INTO sys_countrys VALUES ('HT', 'NA', 'HTI', '332', 'Haiti');
INSERT INTO sys_countrys VALUES ('HM', 'AN', 'HMD', '334', 'Heard Island and McDonald Islands');
INSERT INTO sys_countrys VALUES ('VA', 'EU', 'VAT', '336', 'Vatican City State');
INSERT INTO sys_countrys VALUES ('HN', 'NA', 'HND', '340', 'Honduras');
INSERT INTO sys_countrys VALUES ('HK', 'AS', 'HKG', '344', 'Hong Kong');
INSERT INTO sys_countrys VALUES ('HU', 'EU', 'HUN', '348', 'Hungary');
INSERT INTO sys_countrys VALUES ('IS', 'EU', 'ISL', '352', 'Iceland');
INSERT INTO sys_countrys VALUES ('IN', 'AS', 'IND', '356', 'India');
INSERT INTO sys_countrys VALUES ('ID', 'AS', 'IDN', '360', 'Indonesia');
INSERT INTO sys_countrys VALUES ('IR', 'AS', 'IRN', '364', 'Iran');
INSERT INTO sys_countrys VALUES ('IQ', 'AS', 'IRQ', '368', 'Iraq');
INSERT INTO sys_countrys VALUES ('IE', 'EU', 'IRL', '372', 'Ireland');
INSERT INTO sys_countrys VALUES ('IM', 'EU', 'IMN', '833', 'Isle of Man');
INSERT INTO sys_countrys VALUES ('IL', 'AS', 'ISR', '376', 'Israel');
INSERT INTO sys_countrys VALUES ('IT', 'EU', 'ITA', '380', 'Italy');
INSERT INTO sys_countrys VALUES ('JM', 'NA', 'JAM', '388', 'Jamaica');
INSERT INTO sys_countrys VALUES ('JP', 'AS', 'JPN', '392', 'Japan');
INSERT INTO sys_countrys VALUES ('JE', 'EU', 'JEY', '832', 'Bailiwick of Jersey');
INSERT INTO sys_countrys VALUES ('JO', 'AS', 'JOR', '400', 'Jordan');
INSERT INTO sys_countrys VALUES ('KZ', 'AS', 'KAZ', '398', 'Kazakhstan');
INSERT INTO sys_countrys VALUES ('KE', 'AF', 'KEN', '404', 'Kenya');
INSERT INTO sys_countrys VALUES ('KI', 'OC', 'KIR', '296', 'Kiribati');
INSERT INTO sys_countrys VALUES ('KP', 'AS', 'PRK', '408', 'North Korea');
INSERT INTO sys_countrys VALUES ('KR', 'AS', 'KOR', '410', 'South Korea');
INSERT INTO sys_countrys VALUES ('KW', 'AS', 'KWT', '414', 'Kuwait');
INSERT INTO sys_countrys VALUES ('KG', 'AS', 'KGZ', '417', 'Kyrgyz Republic');
INSERT INTO sys_countrys VALUES ('LA', 'AS', 'LAO', '418', 'Lao Peoples Democratic Republic');
INSERT INTO sys_countrys VALUES ('LV', 'EU', 'LVA', '428', 'Latvia');
INSERT INTO sys_countrys VALUES ('LB', 'AS', 'LBN', '422', 'Lebanon');
INSERT INTO sys_countrys VALUES ('LS', 'AF', 'LSO', '426', 'Lesotho');
INSERT INTO sys_countrys VALUES ('LR', 'AF', 'LBR', '430', 'Liberia');
INSERT INTO sys_countrys VALUES ('LY', 'AF', 'LBY', '434', 'Libyan Arab Jamahiriya');
INSERT INTO sys_countrys VALUES ('LI', 'EU', 'LIE', '438', 'Liechtenstein');
INSERT INTO sys_countrys VALUES ('LT', 'EU', 'LTU', '440', 'Lithuania');
INSERT INTO sys_countrys VALUES ('LU', 'EU', 'LUX', '442', 'Luxembourg');
INSERT INTO sys_countrys VALUES ('MO', 'AS', 'MAC', '446', 'Macao');
INSERT INTO sys_countrys VALUES ('MK', 'EU', 'MKD', '807', 'Macedonia');
INSERT INTO sys_countrys VALUES ('MG', 'AF', 'MDG', '450', 'Madagascar');
INSERT INTO sys_countrys VALUES ('MW', 'AF', 'MWI', '454', 'Malawi');
INSERT INTO sys_countrys VALUES ('MY', 'AS', 'MYS', '458', 'Malaysia');
INSERT INTO sys_countrys VALUES ('MV', 'AS', 'MDV', '462', 'Maldives');
INSERT INTO sys_countrys VALUES ('ML', 'AF', 'MLI', '466', 'Mali');
INSERT INTO sys_countrys VALUES ('MT', 'EU', 'MLT', '470', 'Malta');
INSERT INTO sys_countrys VALUES ('MH', 'OC', 'MHL', '584', 'Marshall Islands');
INSERT INTO sys_countrys VALUES ('MQ', 'NA', 'MTQ', '474', 'Martinique');
INSERT INTO sys_countrys VALUES ('MR', 'AF', 'MRT', '478', 'Mauritania');
INSERT INTO sys_countrys VALUES ('MU', 'AF', 'MUS', '480', 'Mauritius');
INSERT INTO sys_countrys VALUES ('YT', 'AF', 'MYT', '175', 'Mayotte');
INSERT INTO sys_countrys VALUES ('MX', 'NA', 'MEX', '484', 'Mexico');
INSERT INTO sys_countrys VALUES ('FM', 'OC', 'FSM', '583', 'Micronesia');
INSERT INTO sys_countrys VALUES ('MD', 'EU', 'MDA', '498', 'Moldova');
INSERT INTO sys_countrys VALUES ('MC', 'EU', 'MCO', '492', 'Monaco');
INSERT INTO sys_countrys VALUES ('MN', 'AS', 'MNG', '496', 'Mongolia');
INSERT INTO sys_countrys VALUES ('ME', 'EU', 'MNE', '499', 'Montenegro');
INSERT INTO sys_countrys VALUES ('MS', 'NA', 'MSR', '500', 'Montserrat');
INSERT INTO sys_countrys VALUES ('MA', 'AF', 'MAR', '504', 'Morocco');
INSERT INTO sys_countrys VALUES ('MZ', 'AF', 'MOZ', '508', 'Mozambique');
INSERT INTO sys_countrys VALUES ('MM', 'AS', 'MMR', '104', 'Myanmar');
INSERT INTO sys_countrys VALUES ('NA', 'AF', 'NAM', '516', 'Namibia');
INSERT INTO sys_countrys VALUES ('NR', 'OC', 'NRU', '520', 'Nauru');
INSERT INTO sys_countrys VALUES ('NP', 'AS', 'NPL', '524', 'Nepal');
INSERT INTO sys_countrys VALUES ('AN', 'NA', 'ANT', '530', 'Netherlands Antilles');
INSERT INTO sys_countrys VALUES ('NL', 'EU', 'NLD', '528', 'Netherlands');
INSERT INTO sys_countrys VALUES ('NC', 'OC', 'NCL', '540', 'New Caledonia');
INSERT INTO sys_countrys VALUES ('NZ', 'OC', 'NZL', '554', 'New Zealand');
INSERT INTO sys_countrys VALUES ('NI', 'NA', 'NIC', '558', 'Nicaragua');
INSERT INTO sys_countrys VALUES ('NE', 'AF', 'NER', '562', 'Niger');
INSERT INTO sys_countrys VALUES ('NG', 'AF', 'NGA', '566', 'Nigeria');
INSERT INTO sys_countrys VALUES ('NU', 'OC', 'NIU', '570', 'Niue');
INSERT INTO sys_countrys VALUES ('NF', 'OC', 'NFK', '574', 'Norfolk Island');
INSERT INTO sys_countrys VALUES ('MP', 'OC', 'MNP', '580', 'Northern Mariana Islands');
INSERT INTO sys_countrys VALUES ('NO', 'EU', 'NOR', '578', 'Norway');
INSERT INTO sys_countrys VALUES ('OM', 'AS', 'OMN', '512', 'Oman');
INSERT INTO sys_countrys VALUES ('PK', 'AS', 'PAK', '586', 'Pakistan');
INSERT INTO sys_countrys VALUES ('PW', 'OC', 'PLW', '585', 'Palau');
INSERT INTO sys_countrys VALUES ('PS', 'AS', 'PSE', '275', 'Palestinian Territory');
INSERT INTO sys_countrys VALUES ('PA', 'NA', 'PAN', '591', 'Panama');
INSERT INTO sys_countrys VALUES ('PG', 'OC', 'PNG', '598', 'Papua New Guinea');
INSERT INTO sys_countrys VALUES ('PY', 'SA', 'PRY', '600', 'Paraguay');
INSERT INTO sys_countrys VALUES ('PE', 'SA', 'PER', '604', 'Peru');
INSERT INTO sys_countrys VALUES ('PH', 'AS', 'PHL', '608', 'Philippines');
INSERT INTO sys_countrys VALUES ('PN', 'OC', 'PCN', '612', 'Pitcairn Islands');
INSERT INTO sys_countrys VALUES ('PL', 'EU', 'POL', '616', 'Poland');
INSERT INTO sys_countrys VALUES ('PT', 'EU', 'PRT', '620', 'Portugal');
INSERT INTO sys_countrys VALUES ('PR', 'NA', 'PRI', '630', 'Puerto Rico');
INSERT INTO sys_countrys VALUES ('QA', 'AS', 'QAT', '634', 'Qatar');
INSERT INTO sys_countrys VALUES ('RE', 'AF', 'REU', '638', 'Reunion');
INSERT INTO sys_countrys VALUES ('RO', 'EU', 'ROU', '642', 'Romania');
INSERT INTO sys_countrys VALUES ('RU', 'EU', 'RUS', '643', 'Russian Federation');
INSERT INTO sys_countrys VALUES ('RW', 'AF', 'RWA', '646', 'Rwanda');
INSERT INTO sys_countrys VALUES ('BL', 'NA', 'BLM', '652', 'Saint Barthelemy');
INSERT INTO sys_countrys VALUES ('SH', 'AF', 'SHN', '654', 'Saint Helena');
INSERT INTO sys_countrys VALUES ('KN', 'NA', 'KNA', '659', 'Saint Kitts and Nevis');
INSERT INTO sys_countrys VALUES ('LC', 'NA', 'LCA', '662', 'Saint Lucia');
INSERT INTO sys_countrys VALUES ('MF', 'NA', 'MAF', '663', 'Saint Martin');
INSERT INTO sys_countrys VALUES ('PM', 'NA', 'SPM', '666', 'Saint Pierre and Miquelon');
INSERT INTO sys_countrys VALUES ('VC', 'NA', 'VCT', '670', 'Saint Vincent and the Grenadines');
INSERT INTO sys_countrys VALUES ('WS', 'OC', 'WSM', '882', 'Samoa');
INSERT INTO sys_countrys VALUES ('SM', 'EU', 'SMR', '674', 'San Marino');
INSERT INTO sys_countrys VALUES ('ST', 'AF', 'STP', '678', 'Sao Tome and Principe');
INSERT INTO sys_countrys VALUES ('SA', 'AS', 'SAU', '682', 'Saudi Arabia');
INSERT INTO sys_countrys VALUES ('SN', 'AF', 'SEN', '686', 'Senegal');
INSERT INTO sys_countrys VALUES ('RS', 'EU', 'SRB', '688', 'Serbia');
INSERT INTO sys_countrys VALUES ('SC', 'AF', 'SYC', '690', 'Seychelles');
INSERT INTO sys_countrys VALUES ('SL', 'AF', 'SLE', '694', 'Sierra Leone');
INSERT INTO sys_countrys VALUES ('SG', 'AS', 'SGP', '702', 'Singapore');
INSERT INTO sys_countrys VALUES ('SK', 'EU', 'SVK', '703', 'Slovakia');
INSERT INTO sys_countrys VALUES ('SI', 'EU', 'SVN', '705', 'Slovenia');
INSERT INTO sys_countrys VALUES ('SB', 'OC', 'SLB', '090', 'Solomon Islands');
INSERT INTO sys_countrys VALUES ('SO', 'AF', 'SOM', '706', 'Somalia');
INSERT INTO sys_countrys VALUES ('ZA', 'AF', 'ZAF', '710', 'South Africa');
INSERT INTO sys_countrys VALUES ('GS', 'AN', 'SGS', '239', 'South Georgia and the South Sandwich Islands');
INSERT INTO sys_countrys VALUES ('ES', 'EU', 'ESP', '724', 'Spain');
INSERT INTO sys_countrys VALUES ('LK', 'AS', 'LKA', '144', 'Sri Lanka');
INSERT INTO sys_countrys VALUES ('SD', 'AF', 'SDN', '736', 'Sudan');
INSERT INTO sys_countrys VALUES ('SR', 'SA', 'SUR', '740', 'Suriname');
INSERT INTO sys_countrys VALUES ('SJ', 'EU', 'SJM', '744', 'Svalbard & Jan Mayen Islands');
INSERT INTO sys_countrys VALUES ('SZ', 'AF', 'SWZ', '748', 'Swaziland');
INSERT INTO sys_countrys VALUES ('SE', 'EU', 'SWE', '752', 'Sweden');
INSERT INTO sys_countrys VALUES ('CH', 'EU', 'CHE', '756', 'Switzerland');
INSERT INTO sys_countrys VALUES ('SY', 'AS', 'SYR', '760', 'Syrian Arab Republic');
INSERT INTO sys_countrys VALUES ('TW', 'AS', 'TWN', '158', 'Taiwan');
INSERT INTO sys_countrys VALUES ('TJ', 'AS', 'TJK', '762', 'Tajikistan');
INSERT INTO sys_countrys VALUES ('TZ', 'AF', 'TZA', '834', 'Tanzania');
INSERT INTO sys_countrys VALUES ('TH', 'AS', 'THA', '764', 'Thailand');
INSERT INTO sys_countrys VALUES ('TL', 'AS', 'TLS', '626', 'Timor-Leste');
INSERT INTO sys_countrys VALUES ('TG', 'AF', 'TGO', '768', 'Togo');
INSERT INTO sys_countrys VALUES ('TK', 'OC', 'TKL', '772', 'Tokelau');
INSERT INTO sys_countrys VALUES ('TO', 'OC', 'TON', '776', 'Tonga');
INSERT INTO sys_countrys VALUES ('TT', 'NA', 'TTO', '780', 'Trinidad and Tobago');
INSERT INTO sys_countrys VALUES ('TN', 'AF', 'TUN', '788', 'Tunisia');
INSERT INTO sys_countrys VALUES ('TR', 'AS', 'TUR', '792', 'Turkey');
INSERT INTO sys_countrys VALUES ('TM', 'AS', 'TKM', '795', 'Turkmenistan');
INSERT INTO sys_countrys VALUES ('TC', 'NA', 'TCA', '796', 'Turks and Caicos Islands');
INSERT INTO sys_countrys VALUES ('TV', 'OC', 'TUV', '798', 'Tuvalu');
INSERT INTO sys_countrys VALUES ('UG', 'AF', 'UGA', '800', 'Uganda');
INSERT INTO sys_countrys VALUES ('UA', 'EU', 'UKR', '804', 'Ukraine');
INSERT INTO sys_countrys VALUES ('AE', 'AS', 'ARE', '784', 'United Arab Emirates');
INSERT INTO sys_countrys VALUES ('GB', 'EU', 'GBR', '826', 'United Kingdom of Great Britain & Northern Ireland');
INSERT INTO sys_countrys VALUES ('US', 'NA', 'USA', '840', 'United States of America');
INSERT INTO sys_countrys VALUES ('UM', 'OC', 'UMI', '581', 'United States Minor Outlying Islands');
INSERT INTO sys_countrys VALUES ('VI', 'NA', 'VIR', '850', 'United States Virgin Islands');
INSERT INTO sys_countrys VALUES ('UY', 'SA', 'URY', '858', 'Uruguay');
INSERT INTO sys_countrys VALUES ('UZ', 'AS', 'UZB', '860', 'Uzbekistan');
INSERT INTO sys_countrys VALUES ('VU', 'OC', 'VUT', '548', 'Vanuatu');
INSERT INTO sys_countrys VALUES ('VE', 'SA', 'VEN', '862', 'Venezuela');
INSERT INTO sys_countrys VALUES ('VN', 'AS', 'VNM', '704', 'Vietnam');
INSERT INTO sys_countrys VALUES ('WF', 'OC', 'WLF', '876', 'Wallis and Futuna');
INSERT INTO sys_countrys VALUES ('EH', 'AF', 'ESH', '732', 'Western Sahara');
INSERT INTO sys_countrys VALUES ('YE', 'AS', 'YEM', '887', 'Yemen');
INSERT INTO sys_countrys VALUES ('ZM', 'AF', 'ZMB', '894', 'Zambia');
INSERT INTO sys_countrys VALUES ('ZW', 'AF', 'ZWE', '716', 'Zimbabwe');


--
-- Data for Name: sys_emailed; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_emails; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_errors; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_files; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_logins; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO sys_logins VALUES (1, 0, '2011-02-26 11:15:13.412703', 'tiger.dewcis.co.ke/192.168.0.7', NULL);


--
-- Data for Name: sys_news; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_passwords; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: sys_queries; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: root
--



--
-- Data for Name: tax_rates; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO tax_rates VALUES (1, 1, 10164, 10, NULL);
INSERT INTO tax_rates VALUES (2, 1, 19740, 15, NULL);
INSERT INTO tax_rates VALUES (3, 1, 29316, 20, NULL);
INSERT INTO tax_rates VALUES (4, 1, 38892, 25, NULL);
INSERT INTO tax_rates VALUES (5, 1, 10000000, 30, NULL);
INSERT INTO tax_rates VALUES (6, 2, 4000, 5, NULL);
INSERT INTO tax_rates VALUES (7, 2, 10000000, 0, NULL);
INSERT INTO tax_rates VALUES (8, 3, 999, 0, NULL);
INSERT INTO tax_rates VALUES (9, 3, 1499, 30, NULL);
INSERT INTO tax_rates VALUES (10, 3, 1999, 40, NULL);
INSERT INTO tax_rates VALUES (11, 3, 2999, 60, NULL);
INSERT INTO tax_rates VALUES (12, 3, 3999, 80, NULL);
INSERT INTO tax_rates VALUES (13, 3, 4999, 100, NULL);
INSERT INTO tax_rates VALUES (14, 3, 5999, 120, NULL);
INSERT INTO tax_rates VALUES (15, 3, 6999, 140, NULL);
INSERT INTO tax_rates VALUES (16, 3, 7999, 160, NULL);
INSERT INTO tax_rates VALUES (17, 3, 8999, 180, NULL);
INSERT INTO tax_rates VALUES (18, 3, 9999, 200, NULL);
INSERT INTO tax_rates VALUES (19, 3, 10999, 220, NULL);
INSERT INTO tax_rates VALUES (20, 3, 11999, 240, NULL);
INSERT INTO tax_rates VALUES (21, 3, 12999, 260, NULL);
INSERT INTO tax_rates VALUES (22, 3, 13999, 280, NULL);
INSERT INTO tax_rates VALUES (23, 3, 14999, 300, NULL);
INSERT INTO tax_rates VALUES (24, 3, 1000000, 320, NULL);


--
-- Data for Name: tax_types; Type: TABLE DATA; Schema: public; Owner: root
--

INSERT INTO tax_types VALUES (1, 'PAYE', 'getAdjustment(Employee_Month_ID, 2)', 1162, 1, false, true, true, 0, 0, true, NULL);
INSERT INTO tax_types VALUES (2, 'NSSF', 'getAdjustment(Employee_Month_ID, 1)', 0, 0, true, true, true, 0, 0, true, NULL);
INSERT INTO tax_types VALUES (3, 'NHIF', 'getAdjustment(Employee_Month_ID, 1)', 0, 0, false, false, false, 0, 0, true, NULL);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- Name: adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY adjustments
    ADD CONSTRAINT adjustments_pkey PRIMARY KEY (adjustment_id);


--
-- Name: advance_deductions_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY advance_deductions
    ADD CONSTRAINT advance_deductions_pkey PRIMARY KEY (advance_deduction_id);


--
-- Name: applicant_applicant_email_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY applicant
    ADD CONSTRAINT applicant_applicant_email_key UNIQUE (applicant_email);


--
-- Name: applicant_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY applicant
    ADD CONSTRAINT applicant_pkey PRIMARY KEY (entity_id);


--
-- Name: applications_intake_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_intake_id_key UNIQUE (intake_id, entity_id);


--
-- Name: applications_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (application_id);


--
-- Name: approval_phases_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY approval_phases
    ADD CONSTRAINT approval_phases_pkey PRIMARY KEY (approval_phase_id);


--
-- Name: approval_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY approval_types
    ADD CONSTRAINT approval_types_pkey PRIMARY KEY (approval_type_id);


--
-- Name: approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY approvals
    ADD CONSTRAINT approvals_pkey PRIMARY KEY (approval_id);


--
-- Name: attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: bank_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY bank_branch
    ADD CONSTRAINT bank_branch_pkey PRIMARY KEY (bank_branch_id);


--
-- Name: banks_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (bank_id);


--
-- Name: case_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY case_types
    ADD CONSTRAINT case_types_pkey PRIMARY KEY (case_type_id);


--
-- Name: casual_application_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY casual_application
    ADD CONSTRAINT casual_application_pkey PRIMARY KEY (casual_application_id);


--
-- Name: casual_category_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY casual_category
    ADD CONSTRAINT casual_category_pkey PRIMARY KEY (casual_category_id);


--
-- Name: casuals_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY casuals
    ADD CONSTRAINT casuals_pkey PRIMARY KEY (casual_id);


--
-- Name: cv_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY cv_projects
    ADD CONSTRAINT cv_projects_pkey PRIMARY KEY (cv_projectid);


--
-- Name: cv_referees_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY cv_referees
    ADD CONSTRAINT cv_referees_pkey PRIMARY KEY (cv_referee_id);


--
-- Name: cv_seminars_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY cv_seminars
    ADD CONSTRAINT cv_seminars_pkey PRIMARY KEY (cv_seminar_id);


--
-- Name: default_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY default_adjustments
    ADD CONSTRAINT default_adjustments_pkey PRIMARY KEY (default_allowance_id);


--
-- Name: default_tax_types_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY default_tax_types
    ADD CONSTRAINT default_tax_types_entity_id_key UNIQUE (entity_id, tax_type_id);


--
-- Name: default_tax_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY default_tax_types
    ADD CONSTRAINT default_tax_types_pkey PRIMARY KEY (default_tax_type_id);


--
-- Name: department_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY department_roles
    ADD CONSTRAINT department_roles_pkey PRIMARY KEY (department_role_id);


--
-- Name: departments_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: education_class_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY education_class
    ADD CONSTRAINT education_class_pkey PRIMARY KEY (education_class_id);


--
-- Name: education_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY education
    ADD CONSTRAINT education_pkey PRIMARY KEY (education_id);


--
-- Name: employee_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_adjustments
    ADD CONSTRAINT employee_adjustments_pkey PRIMARY KEY (employee_allowance_id);


--
-- Name: employee_advances_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_advances
    ADD CONSTRAINT employee_advances_pkey PRIMARY KEY (employee_advance_id);


--
-- Name: employee_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_cases
    ADD CONSTRAINT employee_cases_pkey PRIMARY KEY (employee_case_id);


--
-- Name: employee_leave_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_leave
    ADD CONSTRAINT employee_leave_pkey PRIMARY KEY (employee_leave_id);


--
-- Name: employee_month_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_entity_id_key UNIQUE (entity_id, period_id);


--
-- Name: employee_month_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_pkey PRIMARY KEY (employee_month_id);


--
-- Name: employee_overtime_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_overtime
    ADD CONSTRAINT employee_overtime_pkey PRIMARY KEY (employee_overtime_id);


--
-- Name: employee_per_diem_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_per_diem
    ADD CONSTRAINT employee_per_diem_pkey PRIMARY KEY (employee_per_diem_id);


--
-- Name: employee_tax_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employee_tax_types
    ADD CONSTRAINT employee_tax_types_pkey PRIMARY KEY (employee_tax_type_id);


--
-- Name: employees_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (entity_id);


--
-- Name: employment_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY employment
    ADD CONSTRAINT employment_pkey PRIMARY KEY (employment_id);


--
-- Name: entiry_refs_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entiry_refs
    ADD CONSTRAINT entiry_refs_pkey PRIMARY KEY (entiry_ref_id);


--
-- Name: entity_subscriptions_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entity_subscriptions
    ADD CONSTRAINT entity_subscriptions_entity_id_key UNIQUE (entity_id, entity_type_id);


--
-- Name: entity_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entity_subscriptions
    ADD CONSTRAINT entity_subscriptions_pkey PRIMARY KEY (entity_subscription_id);


--
-- Name: entity_types_entity_type_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entity_types
    ADD CONSTRAINT entity_types_entity_type_name_key UNIQUE (entity_type_name);


--
-- Name: entity_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entity_types
    ADD CONSTRAINT entity_types_pkey PRIMARY KEY (entity_type_id);


--
-- Name: entitys_org_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entitys
    ADD CONSTRAINT entitys_org_id_key UNIQUE (org_id, user_name);


--
-- Name: entitys_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entitys
    ADD CONSTRAINT entitys_pkey PRIMARY KEY (entity_id);


--
-- Name: entry_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entry_forms
    ADD CONSTRAINT entry_forms_pkey PRIMARY KEY (entry_form_id);


--
-- Name: entry_sub_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY entry_sub_forms
    ADD CONSTRAINT entry_sub_forms_pkey PRIMARY KEY (entry_sub_form_id);


--
-- Name: evaluation_points_job_review_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY evaluation_points
    ADD CONSTRAINT evaluation_points_job_review_id_key UNIQUE (job_review_id, review_point_id);


--
-- Name: evaluation_points_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY evaluation_points
    ADD CONSTRAINT evaluation_points_pkey PRIMARY KEY (evaluation_point_id);


--
-- Name: fields_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (field_id);


--
-- Name: forms_form_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY forms
    ADD CONSTRAINT forms_form_name_key UNIQUE (form_name, version);


--
-- Name: forms_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (form_id);


--
-- Name: intake_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY intake
    ADD CONSTRAINT intake_pkey PRIMARY KEY (intake_id);


--
-- Name: interns_internship_id_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY interns
    ADD CONSTRAINT interns_internship_id_key UNIQUE (internship_id, entity_id);


--
-- Name: interns_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY interns
    ADD CONSTRAINT interns_pkey PRIMARY KEY (intern_id);


--
-- Name: internships_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY internships
    ADD CONSTRAINT internships_pkey PRIMARY KEY (internship_id);


--
-- Name: job_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY job_reviews
    ADD CONSTRAINT job_reviews_pkey PRIMARY KEY (job_review_id);


--
-- Name: kin_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY kin_types
    ADD CONSTRAINT kin_types_pkey PRIMARY KEY (kin_type_id);


--
-- Name: kins_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY kins
    ADD CONSTRAINT kins_pkey PRIMARY KEY (kin_id);


--
-- Name: leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (leave_type_id);


--
-- Name: leave_work_days_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY leave_work_days
    ADD CONSTRAINT leave_work_days_pkey PRIMARY KEY (leave_work_day_id);


--
-- Name: orgs_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY orgs
    ADD CONSTRAINT orgs_pkey PRIMARY KEY (org_id);


--
-- Name: pay_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY pay_groups
    ADD CONSTRAINT pay_groups_pkey PRIMARY KEY (pay_group_id);


--
-- Name: period_tax_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY period_tax_rates
    ADD CONSTRAINT period_tax_rates_pkey PRIMARY KEY (period_tax_rate_id);


--
-- Name: period_tax_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY period_tax_types
    ADD CONSTRAINT period_tax_types_pkey PRIMARY KEY (period_tax_type_id);


--
-- Name: periods_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (period_id);


--
-- Name: periods_start_date_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY periods
    ADD CONSTRAINT periods_start_date_key UNIQUE (start_date);


--
-- Name: phases_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY phases
    ADD CONSTRAINT phases_pkey PRIMARY KEY (phase_id);


--
-- Name: project_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY project_types
    ADD CONSTRAINT project_types_pkey PRIMARY KEY (project_type_id);


--
-- Name: project_types_project_type_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY project_types
    ADD CONSTRAINT project_types_project_type_name_key UNIQUE (project_type_name);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project_id);


--
-- Name: projects_project_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_project_name_key UNIQUE (project_name);


--
-- Name: review_category_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY review_category
    ADD CONSTRAINT review_category_pkey PRIMARY KEY (review_category_id);


--
-- Name: review_points_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY review_points
    ADD CONSTRAINT review_points_pkey PRIMARY KEY (review_point_id);


--
-- Name: skill_category_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY skill_category
    ADD CONSTRAINT skill_category_pkey PRIMARY KEY (skill_category_id);


--
-- Name: skill_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY skill_types
    ADD CONSTRAINT skill_types_pkey PRIMARY KEY (skill_type_id);


--
-- Name: skills_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skill_id);


--
-- Name: sub_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sub_fields
    ADD CONSTRAINT sub_fields_pkey PRIMARY KEY (sub_field_id);


--
-- Name: sys_audit_details_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_audit_details
    ADD CONSTRAINT sys_audit_details_pkey PRIMARY KEY (sys_audit_detail_id);


--
-- Name: sys_audit_trail_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_audit_trail
    ADD CONSTRAINT sys_audit_trail_pkey PRIMARY KEY (sys_audit_trail_id);


--
-- Name: sys_continents_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_continents
    ADD CONSTRAINT sys_continents_pkey PRIMARY KEY (sys_continent_id);


--
-- Name: sys_continents_sys_continent_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_continents
    ADD CONSTRAINT sys_continents_sys_continent_name_key UNIQUE (sys_continent_name);


--
-- Name: sys_countrys_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_countrys
    ADD CONSTRAINT sys_countrys_pkey PRIMARY KEY (sys_country_id);


--
-- Name: sys_countrys_sys_country_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_countrys
    ADD CONSTRAINT sys_countrys_sys_country_name_key UNIQUE (sys_country_name);


--
-- Name: sys_emailed_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_emailed
    ADD CONSTRAINT sys_emailed_pkey PRIMARY KEY (sys_emailed_id);


--
-- Name: sys_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_emails
    ADD CONSTRAINT sys_emails_pkey PRIMARY KEY (sys_email_id);


--
-- Name: sys_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_errors
    ADD CONSTRAINT sys_errors_pkey PRIMARY KEY (sys_error_id);


--
-- Name: sys_files_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_files
    ADD CONSTRAINT sys_files_pkey PRIMARY KEY (sys_file_id);


--
-- Name: sys_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_logins
    ADD CONSTRAINT sys_logins_pkey PRIMARY KEY (sys_login_id);


--
-- Name: sys_news_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_news
    ADD CONSTRAINT sys_news_pkey PRIMARY KEY (sys_news_id);


--
-- Name: sys_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_passwords
    ADD CONSTRAINT sys_passwords_pkey PRIMARY KEY (sys_password_id);


--
-- Name: sys_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY sys_queries
    ADD CONSTRAINT sys_queries_pkey PRIMARY KEY (query_name);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (task_id);


--
-- Name: tasks_task_name_key; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_task_name_key UNIQUE (task_name);


--
-- Name: tax_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY tax_rates
    ADD CONSTRAINT tax_rates_pkey PRIMARY KEY (tax_rate_id);


--
-- Name: tax_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root; Tablespace: 
--

ALTER TABLE ONLY tax_types
    ADD CONSTRAINT tax_types_pkey PRIMARY KEY (tax_type_id);


--
-- Name: address_sys_country_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX address_sys_country_id ON address USING btree (sys_country_id);


--
-- Name: address_table_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX address_table_id ON address USING btree (table_id);


--
-- Name: address_table_name; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX address_table_name ON address USING btree (table_name);


--
-- Name: advance_deductions_employee_month_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX advance_deductions_employee_month_id ON advance_deductions USING btree (employee_month_id);


--
-- Name: applications_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX applications_entity_id ON applications USING btree (entity_id);


--
-- Name: applications_intake_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX applications_intake_id ON applications USING btree (intake_id);


--
-- Name: approval_phases_approval_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX approval_phases_approval_type_id ON approval_phases USING btree (approval_type_id);


--
-- Name: approval_phases_entity_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX approval_phases_entity_type_id ON approval_phases USING btree (entity_type_id);


--
-- Name: approvals_approval_phase_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX approvals_approval_phase_id ON approvals USING btree (approval_phase_id);


--
-- Name: approvals_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX approvals_entity_id ON approvals USING btree (entity_id);


--
-- Name: approvals_forward_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX approvals_forward_id ON approvals USING btree (forward_id);


--
-- Name: approvals_table_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX approvals_table_id ON approvals USING btree (table_id);


--
-- Name: attendance_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX attendance_entity_id ON attendance USING btree (entity_id);


--
-- Name: branch_bankid; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX branch_bankid ON bank_branch USING btree (bank_id);


--
-- Name: casual_application_category_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX casual_application_category_id ON casual_application USING btree (casual_category_id);


--
-- Name: casual_application_department_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX casual_application_department_id ON casual_application USING btree (department_id);


--
-- Name: casuals_casual_application_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX casuals_casual_application_id ON casuals USING btree (casual_application_id);


--
-- Name: casuals_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX casuals_entity_id ON casuals USING btree (entity_id);


--
-- Name: cv_projects_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX cv_projects_entity_id ON cv_projects USING btree (entity_id);


--
-- Name: cv_referees_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX cv_referees_entity_id ON cv_referees USING btree (entity_id);


--
-- Name: cv_seminars_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX cv_seminars_entity_id ON cv_seminars USING btree (entity_id);


--
-- Name: default_adjustments_adjustment_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX default_adjustments_adjustment_id ON default_adjustments USING btree (adjustment_id);


--
-- Name: default_adjustments_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX default_adjustments_entity_id ON default_adjustments USING btree (entity_id);


--
-- Name: default_tax_tax_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX default_tax_tax_type_id ON default_tax_types USING btree (tax_type_id);


--
-- Name: default_tax_types_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX default_tax_types_entity_id ON default_tax_types USING btree (entity_id);


--
-- Name: department_roles_department_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX department_roles_department_id ON department_roles USING btree (department_id);


--
-- Name: department_roles_ln_department_role_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX department_roles_ln_department_role_id ON department_roles USING btree (ln_department_role_id);


--
-- Name: departments_ln_department_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX departments_ln_department_id ON departments USING btree (ln_department_id);


--
-- Name: education_education_class_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX education_education_class_id ON education USING btree (education_class_id);


--
-- Name: education_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX education_entity_id ON education USING btree (entity_id);


--
-- Name: employee_adjustments_adjustment_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_adjustments_adjustment_id ON employee_adjustments USING btree (adjustment_id);


--
-- Name: employee_adjustments_employee_month_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_adjustments_employee_month_id ON employee_adjustments USING btree (employee_month_id);


--
-- Name: employee_advances_employee_month_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_advances_employee_month_id ON employee_advances USING btree (employee_month_id);


--
-- Name: employee_cases_case_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_cases_case_type_id ON employee_cases USING btree (case_type_id);


--
-- Name: employee_cases_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_cases_entity_id ON employee_cases USING btree (entity_id);


--
-- Name: employee_leave_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_leave_entity_id ON employee_leave USING btree (entity_id);


--
-- Name: employee_leave_leave_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_leave_leave_type_id ON employee_leave USING btree (leave_type_id);


--
-- Name: employee_month_bank_branch_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_month_bank_branch_id ON employee_month USING btree (bank_branch_id);


--
-- Name: employee_month_bank_pay_group_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_month_bank_pay_group_id ON employee_month USING btree (pay_group_id);


--
-- Name: employee_month_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_month_entity_id ON employee_month USING btree (entity_id);


--
-- Name: employee_month_period_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_month_period_id ON employee_month USING btree (period_id);


--
-- Name: employee_overtime_employee_month_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_overtime_employee_month_id ON employee_overtime USING btree (employee_month_id);


--
-- Name: employee_per_diem_employee_month_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_per_diem_employee_month_id ON employee_per_diem USING btree (employee_month_id);


--
-- Name: employee_tax_types_employee_month_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_tax_types_employee_month_id ON employee_tax_types USING btree (employee_month_id);


--
-- Name: employee_tax_types_tax_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employee_tax_types_tax_type_id ON employee_tax_types USING btree (tax_type_id);


--
-- Name: employees_bank_branch_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employees_bank_branch_id ON employees USING btree (bank_branch_id);


--
-- Name: employees_department_role_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employees_department_role_id ON employees USING btree (department_role_id);


--
-- Name: employees_nationality; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employees_nationality ON employees USING btree (nationality);


--
-- Name: employment_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX employment_entity_id ON employment USING btree (entity_id);


--
-- Name: entiry_refs_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entiry_refs_entity_id ON entiry_refs USING btree (entity_id);


--
-- Name: entiry_refs_ref_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entiry_refs_ref_entity_id ON entiry_refs USING btree (ref_entity_id);


--
-- Name: entity_subscriptions_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entity_subscriptions_entity_id ON entity_subscriptions USING btree (entity_id);


--
-- Name: entity_subscriptions_entity_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entity_subscriptions_entity_type_id ON entity_subscriptions USING btree (entity_type_id);


--
-- Name: entitys_org_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entitys_org_id ON entitys USING btree (org_id);


--
-- Name: entry_forms_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entry_forms_entity_id ON entry_forms USING btree (entity_id);


--
-- Name: entry_forms_form_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entry_forms_form_id ON entry_forms USING btree (form_id);


--
-- Name: entry_sub_forms_entry_form_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entry_sub_forms_entry_form_id ON entry_sub_forms USING btree (entry_form_id);


--
-- Name: entry_sub_forms_sub_field_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX entry_sub_forms_sub_field_id ON entry_sub_forms USING btree (sub_field_id);


--
-- Name: evaluation_points_job_review_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX evaluation_points_job_review_id ON evaluation_points USING btree (job_review_id);


--
-- Name: evaluation_points_review_point_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX evaluation_points_review_point_id ON evaluation_points USING btree (review_point_id);


--
-- Name: fields_form_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX fields_form_id ON fields USING btree (form_id);


--
-- Name: forms_org_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX forms_org_id ON forms USING btree (org_id);


--
-- Name: intake_department_role_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX intake_department_role_id ON intake USING btree (department_role_id);


--
-- Name: interns_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX interns_entity_id ON interns USING btree (entity_id);


--
-- Name: interns_internship_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX interns_internship_id ON interns USING btree (internship_id);


--
-- Name: internships_department_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX internships_department_id ON internships USING btree (department_id);


--
-- Name: job_reviews_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX job_reviews_entity_id ON job_reviews USING btree (entity_id);


--
-- Name: kins_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX kins_entity_id ON kins USING btree (entity_id);


--
-- Name: kins_kin_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX kins_kin_type_id ON kins USING btree (kin_type_id);


--
-- Name: leave_work_days_employee_leave_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX leave_work_days_employee_leave_id ON leave_work_days USING btree (employee_leave_id);


--
-- Name: period_tax_rates_period_tax_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX period_tax_rates_period_tax_type_id ON period_tax_rates USING btree (period_tax_type_id);


--
-- Name: period_tax_types_period_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX period_tax_types_period_id ON period_tax_types USING btree (period_id);


--
-- Name: period_tax_types_tax_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX period_tax_types_tax_type_id ON period_tax_types USING btree (tax_type_id);


--
-- Name: phases_project_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX phases_project_id ON phases USING btree (project_id);


--
-- Name: projects_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX projects_entity_id ON projects USING btree (entity_id);


--
-- Name: projects_project_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX projects_project_type_id ON projects USING btree (project_type_id);


--
-- Name: review_points_review_category_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX review_points_review_category_id ON review_points USING btree (review_category_id);


--
-- Name: skill_types_skill_category_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX skill_types_skill_category_id ON skill_types USING btree (skill_category_id);


--
-- Name: skills_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX skills_entity_id ON skills USING btree (entity_id);


--
-- Name: skills_skill_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX skills_skill_type_id ON skills USING btree (skill_type_id);


--
-- Name: sub_fields_field_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sub_fields_field_id ON sub_fields USING btree (field_id);


--
-- Name: sys_audit_details_sys_audit_trail_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sys_audit_details_sys_audit_trail_id ON sys_audit_details USING btree (sys_audit_trail_id);


--
-- Name: sys_countrys_sys_continent_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sys_countrys_sys_continent_id ON sys_countrys USING btree (sys_continent_id);


--
-- Name: sys_emailed_sys_email_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sys_emailed_sys_email_id ON sys_emailed USING btree (sys_email_id);


--
-- Name: sys_emailed_table_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sys_emailed_table_id ON sys_emailed USING btree (table_id);


--
-- Name: sys_files_table_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sys_files_table_id ON sys_files USING btree (table_id);


--
-- Name: sys_logins_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX sys_logins_entity_id ON sys_logins USING btree (entity_id);


--
-- Name: tasks_entity_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX tasks_entity_id ON tasks USING btree (entity_id);


--
-- Name: tasks_phase_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX tasks_phase_id ON tasks USING btree (phase_id);


--
-- Name: tax_rates_tax_type_id; Type: INDEX; Schema: public; Owner: root; Tablespace: 
--

CREATE INDEX tax_rates_tax_type_id ON tax_rates USING btree (tax_type_id);


--
-- Name: ins_applicant; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_applicant
    BEFORE INSERT OR UPDATE ON applicant
    FOR EACH ROW
    EXECUTE PROCEDURE ins_applicant();


--
-- Name: ins_employee_month; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_employee_month
    AFTER INSERT ON employee_month
    FOR EACH ROW
    EXECUTE PROCEDURE ins_employee_month();


--
-- Name: ins_employees; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_employees
    BEFORE INSERT OR UPDATE ON employees
    FOR EACH ROW
    EXECUTE PROCEDURE ins_employees();


--
-- Name: ins_entitys; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_entitys
    AFTER INSERT ON entitys
    FOR EACH ROW
    EXECUTE PROCEDURE ins_entitys();


--
-- Name: ins_password; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_password
    BEFORE INSERT ON entitys
    FOR EACH ROW
    EXECUTE PROCEDURE ins_password();


--
-- Name: ins_period_tax_types; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_period_tax_types
    AFTER INSERT ON period_tax_types
    FOR EACH ROW
    EXECUTE PROCEDURE ins_period_tax_types();


--
-- Name: ins_periods; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_periods
    AFTER INSERT ON periods
    FOR EACH ROW
    EXECUTE PROCEDURE ins_periods();


--
-- Name: ins_taxes; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER ins_taxes
    AFTER INSERT ON employees
    FOR EACH ROW
    EXECUTE PROCEDURE ins_taxes();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON casual_application
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON casuals
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON employee_leave
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON interns
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON leave_work_days
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON employee_advances
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON employee_overtime
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_action; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_action
    BEFORE INSERT OR UPDATE ON employee_per_diem
    FOR EACH ROW
    EXECUTE PROCEDURE upd_action();


--
-- Name: upd_applications; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_applications
    BEFORE UPDATE ON applications
    FOR EACH ROW
    EXECUTE PROCEDURE upd_applications();


--
-- Name: upd_employee_adjustments; Type: TRIGGER; Schema: public; Owner: root
--

CREATE TRIGGER upd_employee_adjustments
    AFTER UPDATE ON employee_adjustments
    FOR EACH ROW
    EXECUTE PROCEDURE upd_employee_adjustments();


--
-- Name: address_sys_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_sys_country_id_fkey FOREIGN KEY (sys_country_id) REFERENCES sys_countrys(sys_country_id);


--
-- Name: advance_deductions_employee_month_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY advance_deductions
    ADD CONSTRAINT advance_deductions_employee_month_id_fkey FOREIGN KEY (employee_month_id) REFERENCES employee_month(employee_month_id);


--
-- Name: applicant_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY applicant
    ADD CONSTRAINT applicant_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: applicant_nationality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY applicant
    ADD CONSTRAINT applicant_nationality_fkey FOREIGN KEY (nationality) REFERENCES sys_countrys(sys_country_id);


--
-- Name: applications_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: applications_intake_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY applications
    ADD CONSTRAINT applications_intake_id_fkey FOREIGN KEY (intake_id) REFERENCES intake(intake_id);


--
-- Name: approval_phases_approval_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY approval_phases
    ADD CONSTRAINT approval_phases_approval_type_id_fkey FOREIGN KEY (approval_type_id) REFERENCES approval_types(approval_type_id);


--
-- Name: approval_phases_entity_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY approval_phases
    ADD CONSTRAINT approval_phases_entity_type_id_fkey FOREIGN KEY (entity_type_id) REFERENCES entity_types(entity_type_id);


--
-- Name: approvals_approval_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY approvals
    ADD CONSTRAINT approvals_approval_phase_id_fkey FOREIGN KEY (approval_phase_id) REFERENCES approval_phases(approval_phase_id);


--
-- Name: approvals_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY approvals
    ADD CONSTRAINT approvals_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: attendance_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY attendance
    ADD CONSTRAINT attendance_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: bank_branch_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY bank_branch
    ADD CONSTRAINT bank_branch_bank_id_fkey FOREIGN KEY (bank_id) REFERENCES banks(bank_id);


--
-- Name: casual_application_casual_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY casual_application
    ADD CONSTRAINT casual_application_casual_category_id_fkey FOREIGN KEY (casual_category_id) REFERENCES casual_category(casual_category_id);


--
-- Name: casual_application_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY casual_application
    ADD CONSTRAINT casual_application_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: casuals_casual_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY casuals
    ADD CONSTRAINT casuals_casual_application_id_fkey FOREIGN KEY (casual_application_id) REFERENCES casual_application(casual_application_id);


--
-- Name: casuals_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY casuals
    ADD CONSTRAINT casuals_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: cv_projects_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY cv_projects
    ADD CONSTRAINT cv_projects_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: cv_referees_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY cv_referees
    ADD CONSTRAINT cv_referees_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: cv_seminars_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY cv_seminars
    ADD CONSTRAINT cv_seminars_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: default_adjustments_adjustment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY default_adjustments
    ADD CONSTRAINT default_adjustments_adjustment_id_fkey FOREIGN KEY (adjustment_id) REFERENCES adjustments(adjustment_id);


--
-- Name: default_adjustments_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY default_adjustments
    ADD CONSTRAINT default_adjustments_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: default_tax_types_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY default_tax_types
    ADD CONSTRAINT default_tax_types_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: default_tax_types_tax_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY default_tax_types
    ADD CONSTRAINT default_tax_types_tax_type_id_fkey FOREIGN KEY (tax_type_id) REFERENCES tax_types(tax_type_id);


--
-- Name: department_roles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY department_roles
    ADD CONSTRAINT department_roles_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: department_roles_ln_department_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY department_roles
    ADD CONSTRAINT department_roles_ln_department_role_id_fkey FOREIGN KEY (ln_department_role_id) REFERENCES department_roles(department_role_id);


--
-- Name: departments_ln_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY departments
    ADD CONSTRAINT departments_ln_department_id_fkey FOREIGN KEY (ln_department_id) REFERENCES departments(department_id);


--
-- Name: education_education_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY education
    ADD CONSTRAINT education_education_class_id_fkey FOREIGN KEY (education_class_id) REFERENCES education_class(education_class_id);


--
-- Name: education_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY education
    ADD CONSTRAINT education_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: employee_adjustments_adjustment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_adjustments
    ADD CONSTRAINT employee_adjustments_adjustment_id_fkey FOREIGN KEY (adjustment_id) REFERENCES adjustments(adjustment_id);


--
-- Name: employee_adjustments_employee_month_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_adjustments
    ADD CONSTRAINT employee_adjustments_employee_month_id_fkey FOREIGN KEY (employee_month_id) REFERENCES employee_month(employee_month_id);


--
-- Name: employee_advances_employee_month_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_advances
    ADD CONSTRAINT employee_advances_employee_month_id_fkey FOREIGN KEY (employee_month_id) REFERENCES employee_month(employee_month_id);


--
-- Name: employee_cases_case_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_cases
    ADD CONSTRAINT employee_cases_case_type_id_fkey FOREIGN KEY (case_type_id) REFERENCES case_types(case_type_id);


--
-- Name: employee_cases_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_cases
    ADD CONSTRAINT employee_cases_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: employee_leave_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_leave
    ADD CONSTRAINT employee_leave_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: employee_leave_leave_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_leave
    ADD CONSTRAINT employee_leave_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES leave_types(leave_type_id);


--
-- Name: employee_month_bank_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_bank_branch_id_fkey FOREIGN KEY (bank_branch_id) REFERENCES bank_branch(bank_branch_id);


--
-- Name: employee_month_department_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_department_role_id_fkey FOREIGN KEY (department_role_id) REFERENCES department_roles(department_role_id);


--
-- Name: employee_month_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: employee_month_pay_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_pay_group_id_fkey FOREIGN KEY (pay_group_id) REFERENCES pay_groups(pay_group_id);


--
-- Name: employee_month_period_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_month
    ADD CONSTRAINT employee_month_period_id_fkey FOREIGN KEY (period_id) REFERENCES periods(period_id);


--
-- Name: employee_overtime_employee_month_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_overtime
    ADD CONSTRAINT employee_overtime_employee_month_id_fkey FOREIGN KEY (employee_month_id) REFERENCES employee_month(employee_month_id);


--
-- Name: employee_per_diem_employee_month_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_per_diem
    ADD CONSTRAINT employee_per_diem_employee_month_id_fkey FOREIGN KEY (employee_month_id) REFERENCES employee_month(employee_month_id);


--
-- Name: employee_tax_types_employee_month_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_tax_types
    ADD CONSTRAINT employee_tax_types_employee_month_id_fkey FOREIGN KEY (employee_month_id) REFERENCES employee_month(employee_month_id);


--
-- Name: employee_tax_types_tax_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employee_tax_types
    ADD CONSTRAINT employee_tax_types_tax_type_id_fkey FOREIGN KEY (tax_type_id) REFERENCES tax_types(tax_type_id);


--
-- Name: employees_bank_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_bank_branch_id_fkey FOREIGN KEY (bank_branch_id) REFERENCES bank_branch(bank_branch_id);


--
-- Name: employees_department_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_department_role_id_fkey FOREIGN KEY (department_role_id) REFERENCES department_roles(department_role_id);


--
-- Name: employees_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: employees_nationality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_nationality_fkey FOREIGN KEY (nationality) REFERENCES sys_countrys(sys_country_id);


--
-- Name: employment_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY employment
    ADD CONSTRAINT employment_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: entiry_refs_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entiry_refs
    ADD CONSTRAINT entiry_refs_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: entiry_refs_ref_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entiry_refs
    ADD CONSTRAINT entiry_refs_ref_entity_id_fkey FOREIGN KEY (ref_entity_id) REFERENCES entitys(entity_id);


--
-- Name: entity_subscriptions_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entity_subscriptions
    ADD CONSTRAINT entity_subscriptions_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: entity_subscriptions_entity_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entity_subscriptions
    ADD CONSTRAINT entity_subscriptions_entity_type_id_fkey FOREIGN KEY (entity_type_id) REFERENCES entity_types(entity_type_id);


--
-- Name: entitys_entity_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entitys
    ADD CONSTRAINT entitys_entity_type_id_fkey FOREIGN KEY (entity_type_id) REFERENCES entity_types(entity_type_id);


--
-- Name: entitys_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entitys
    ADD CONSTRAINT entitys_org_id_fkey FOREIGN KEY (org_id) REFERENCES orgs(org_id);


--
-- Name: entry_forms_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entry_forms
    ADD CONSTRAINT entry_forms_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: entry_forms_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entry_forms
    ADD CONSTRAINT entry_forms_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: entry_sub_forms_entry_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entry_sub_forms
    ADD CONSTRAINT entry_sub_forms_entry_form_id_fkey FOREIGN KEY (entry_form_id) REFERENCES entry_forms(entry_form_id);


--
-- Name: entry_sub_forms_sub_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY entry_sub_forms
    ADD CONSTRAINT entry_sub_forms_sub_field_id_fkey FOREIGN KEY (sub_field_id) REFERENCES sub_fields(sub_field_id);


--
-- Name: evaluation_points_job_review_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY evaluation_points
    ADD CONSTRAINT evaluation_points_job_review_id_fkey FOREIGN KEY (job_review_id) REFERENCES job_reviews(job_review_id);


--
-- Name: evaluation_points_review_point_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY evaluation_points
    ADD CONSTRAINT evaluation_points_review_point_id_fkey FOREIGN KEY (review_point_id) REFERENCES review_points(review_point_id);


--
-- Name: fields_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY fields
    ADD CONSTRAINT fields_form_id_fkey FOREIGN KEY (form_id) REFERENCES forms(form_id);


--
-- Name: forms_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY forms
    ADD CONSTRAINT forms_org_id_fkey FOREIGN KEY (org_id) REFERENCES orgs(org_id);


--
-- Name: intake_department_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY intake
    ADD CONSTRAINT intake_department_role_id_fkey FOREIGN KEY (department_role_id) REFERENCES department_roles(department_role_id);


--
-- Name: interns_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY interns
    ADD CONSTRAINT interns_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: interns_internship_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY interns
    ADD CONSTRAINT interns_internship_id_fkey FOREIGN KEY (internship_id) REFERENCES internships(internship_id);


--
-- Name: internships_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY internships
    ADD CONSTRAINT internships_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(department_id);


--
-- Name: job_reviews_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY job_reviews
    ADD CONSTRAINT job_reviews_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: kins_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY kins
    ADD CONSTRAINT kins_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: kins_kin_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY kins
    ADD CONSTRAINT kins_kin_type_id_fkey FOREIGN KEY (kin_type_id) REFERENCES kin_types(kin_type_id);


--
-- Name: leave_work_days_employee_leave_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY leave_work_days
    ADD CONSTRAINT leave_work_days_employee_leave_id_fkey FOREIGN KEY (employee_leave_id) REFERENCES employee_leave(employee_leave_id);


--
-- Name: period_tax_rates_period_tax_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY period_tax_rates
    ADD CONSTRAINT period_tax_rates_period_tax_type_id_fkey FOREIGN KEY (period_tax_type_id) REFERENCES period_tax_types(period_tax_type_id);


--
-- Name: period_tax_types_period_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY period_tax_types
    ADD CONSTRAINT period_tax_types_period_id_fkey FOREIGN KEY (period_id) REFERENCES periods(period_id);


--
-- Name: period_tax_types_tax_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY period_tax_types
    ADD CONSTRAINT period_tax_types_tax_type_id_fkey FOREIGN KEY (tax_type_id) REFERENCES tax_types(tax_type_id);


--
-- Name: phases_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY phases
    ADD CONSTRAINT phases_project_id_fkey FOREIGN KEY (project_id) REFERENCES projects(project_id);


--
-- Name: projects_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: projects_project_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_project_type_id_fkey FOREIGN KEY (project_type_id) REFERENCES project_types(project_type_id);


--
-- Name: review_points_review_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY review_points
    ADD CONSTRAINT review_points_review_category_id_fkey FOREIGN KEY (review_category_id) REFERENCES review_category(review_category_id);


--
-- Name: skill_types_skill_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY skill_types
    ADD CONSTRAINT skill_types_skill_category_id_fkey FOREIGN KEY (skill_category_id) REFERENCES skill_category(skill_category_id);


--
-- Name: skills_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: skills_skill_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_skill_type_id_fkey FOREIGN KEY (skill_type_id) REFERENCES skill_types(skill_type_id);


--
-- Name: sub_fields_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY sub_fields
    ADD CONSTRAINT sub_fields_field_id_fkey FOREIGN KEY (field_id) REFERENCES fields(field_id);


--
-- Name: sys_audit_details_sys_audit_trail_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY sys_audit_details
    ADD CONSTRAINT sys_audit_details_sys_audit_trail_id_fkey FOREIGN KEY (sys_audit_trail_id) REFERENCES sys_audit_trail(sys_audit_trail_id);


--
-- Name: sys_countrys_sys_continent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY sys_countrys
    ADD CONSTRAINT sys_countrys_sys_continent_id_fkey FOREIGN KEY (sys_continent_id) REFERENCES sys_continents(sys_continent_id);


--
-- Name: sys_emailed_sys_email_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY sys_emailed
    ADD CONSTRAINT sys_emailed_sys_email_id_fkey FOREIGN KEY (sys_email_id) REFERENCES sys_emails(sys_email_id);


--
-- Name: sys_logins_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY sys_logins
    ADD CONSTRAINT sys_logins_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: tasks_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_entity_id_fkey FOREIGN KEY (entity_id) REFERENCES entitys(entity_id);


--
-- Name: tasks_phase_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_phase_id_fkey FOREIGN KEY (phase_id) REFERENCES phases(phase_id);


--
-- Name: tax_rates_tax_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY tax_rates
    ADD CONSTRAINT tax_rates_tax_type_id_fkey FOREIGN KEY (tax_type_id) REFERENCES tax_types(tax_type_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

