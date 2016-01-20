--DROP TABLE etravel;
CREATE TABLE etravel(
    etravel_id                      serial primary key,
    transfer_assignment_id          integer,
    ticket_airline                  varchar(10) NOT NULL,
    ticket_number                   varchar(20) NOT NULL,
    ticket_location                 varchar(10) NOT NULL,
    ticket_date                     date NOT NULL,
    ticket_currency                 varchar(10) NOT NULL,
    ticket_agent                    varchar(10) NOT NULL,
    ticket_pax_name                 varchar(75) NOT NULL,
    car_reference                   real NOT NULL,
    car_type                        varchar(10) NOT NULL,
    car_renting_location            varchar(75) NOT NULL,
    car_voucher_issued              date NOT NULL,
    car_rate                        real DEFAULT 0 NOT NULL,
    car_from_date                   date NOT NULL,
    car_to_date                     date,
    ticket_booking_clerk            varchar(10),
    ticket_destination_tax          real DEFAULT 0 NOT NULL,
    ticket_commission_amount_1      real DEFAULT 0 NOT NULL,
    ticket_discount_amount_1        real DEFAULT 0 NOT NULL,
    ts_service_1                    varchar(10) NOT NULL,
    ts_amount_1                     real DEFAULT 0 NOT NULL,
    ts_service_2                    varchar(10) NOT NULL,
    ts_amount_2                     real DEFAULT 0 NOT NULL,
    ticket_customer_1               varchar(10),
    ticket_lpo                      varchar(25),
    ticket_lpo_date                 date,
    ticket_status                   varchar(1) DEFAULT 'S' NOT NULL,
    car_remarks                     varchar(200),
    car_renting_station             varchar(50) NOT NULL,
    car_drop_station                varchar(50) NOT NULL,
    ticket_retention_charges_air    real DEFAULT 0 NOT NULL,
    ticket_retention_charges_agent  real DEFAULT 0 NOT NULL,
    ready			                boolean default false,
    picked                          boolean default false
);












Column Name	                Type	 Length	Mandatory	Validation	Remarks

 Airline_Code    	        varchar	 10	 Y	Y	CODE FOR EACH TYPE OF SALES (PICKUP/TRANSFER) FOR MIS REPORTING
 Sales_Reference_Number	    varchar	 20	 Y	Y	UNIQUE IDENTIFICATION NUMBER
 Sales Branch	            varchar	 10	 Y	Y	SALES BRANCH
 Sales_date	                DATE        	 Y		SALES DATE (DD/MON/YY)
 Currency	                varchar	 10	 Y	Y	CURRENCY CODE (KES/USD)
 Supplier	                varchar	 10	 Y	Y	SUPPLIER/PROVIDER/AGENT
 Pax_name	                varchar	 75	 Y		PASSENGER NAME
 Booking_reference	        varchar	 50	 Y		CONFIRMATION NUMBER / REFERENCE NUMBER
 Car_type	                varchar	 10	 Y	Y	CAR MODEL /BRAND
 Place Of_issue	            varchar	 50	 Y		CITY NAME / CODE
 Issue_date	                DATE	 	     Y		SAME AS SALES DATE (DD/MON/YY)
 Car_rate	                NUMBER	 	     Y		RATE PER DAY
 Car_from date	            DATE	 	     Y		RENT START DATE  (DD/MON/YY)
 Car_to_date	            DATE	 	     Y		RENT END DATE (DD/MON/YY)
 Booking Clark	            varchar	 10	 Y	Y	BOOKING HANDLER/EXECUTIVE
 Tax	                    NUMBER	 	     N		TAX IF ANY APPLICABLE
 Commision	                NUMBER	 	     N		COMMISION FROM SUPPLIER /PROVIDER
 Discount	                NUMBER	 	     N		DISCOUNT GIVEN TO PASSENEGER
 Sfeecode1	                varchar	 10	 N	Y	SERVICE FEE CODE
 Service Fee1	            NUMBER	 	     N		SERVICE FEE AMOUNT
 Sfeecode2	                varchar	 10	 N	Y	MARKUP / EXTRA COLLECTION CODE
 Service Fee2	            NUMBER	 	     N		MARKUP AMOUNT
 Customer_code	            varchar	 10	 N	Y	CUSTOMER CODE
 LPO	                    varchar	 10	 N		PURCHASE ORDER
 Lpo_date	                DATE	 	     N		PURCHASE ORDER DATE (DD/MON/YY)
 Sales_type	                varchar	 2	 Y	Y	SALES OR REFUND  (S/R)
 Remarks	                varchar	 200 N		REMARKS / NARRATION
 Pick Up Renting station	varchar	 50	 Y		PROCESSED DATE AND TIME
 Drop of  Station	        varchar	 50	 Y		RENTING PLACE/LOCATION
 AGT_CANX_FEES	            NUMBER	 	     N		AGENT /SUPPLIER CANX. FEE
 AGENCY_CANX_FEE	        NUMBER	 	     N		BUNSON TRAVEL SERVICE FEE ON REFUND


