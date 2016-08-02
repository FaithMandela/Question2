create table tmpnbosegment(
tmpnbosegment_id	serial primary key,
smo_cd 			varchar(12), 
mst_cus_id 		varchar(12),
sub_id_name 		varchar(240), 
boi_cntry_cd 		varchar(12),
booking_type		varchar(12),
boi_booking_date 	date,
pcc 			varchar(12),
count 			varchar(12),
acs_crs_number 		varchar(12)
);

