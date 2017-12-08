CREATE EXTENSION oracle_fdw;

CREATE SERVER oradb FOREIGN DATA WRAPPER oracle_fdw OPTIONS (dbserver '62.24.121.34:1521/ETRAVEL');

GRANT USAGE ON FOREIGN SERVER oradb TO postgres;
--DROP USER MAPPING  IF EXISTS FOR postgres SERVER oradb

CREATE USER MAPPING FOR postgres SERVER oradb OPTIONS (user 'MISUSER', password 'password');

--DROP FOREIGN TABLE ora_loyalty;
CREATE FOREIGN TABLE ora_loyalty (
  LOY_CUST_CODE         character varying(10),
  LOY_DOC_NUMBER        character varying(25),
  LOY_SERV_NUMBER       character varying(25),
  LOY_PAX_NAME          character varying(75),
  LOY_AIRLINE_RELEASE   character varying(10),
  LOY_AIRLINE_NAME      character varying(75),
  LOY_CURRENCY          character varying(10),
  LOY_EX_RATE           real,
  LOY_INVAMT            real,
  LOY_CLASS_DESC        character varying(50),
  LOY_ROUTING           character varying(50),
  LOY_FINAL_DEST        character varying(50),
  LOY_LOC_INT           character varying(1),
  LOY_POST_STATUS       character varying(1),
  LOY_STATUS	        character varying(1),
  LOY_DATE	             date
) SERVER oradb OPTIONS (schema 'KE042T3', table 'LOYALTY_TEXT');
DROP FOREIGN TABLE CUSTOMER_DETAILS;
CREATE FOREIGN TABLE CUSTOMER_DETAILS (
  CUSTOMER_CODE        character varying(10),
  CUSTOMER_NAME        character varying(75)
  ) SERVER oradb OPTIONS (schema 'KE042T3', table 'MIS_CUSTOMER_DETAILS');
