CREATE TABLE tmpnbosegment(
	tmpnbosegment_id		serial primary key,
	smo_cd 				varchar(50), 
	mst_cus_id 			varchar(50),
	sub_id_name 			varchar(240), 
	boi_cntry_cd 			varchar(50),
	booking_type			varchar(50),
	boi_booking_date 		varchar(50),
	pcc 				varchar(50),
	c_count 			varchar(50),
	acs_crs_number 			varchar(50)
);

