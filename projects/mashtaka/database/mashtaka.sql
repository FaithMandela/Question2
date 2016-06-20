---Project Database File

CREATE TABLE Price_List (
	price_list_id 					serial primary key,
	price_list_name					varchar (120),
	amount							real,
	details							text
);

CREATE TABLE Payments (
	payment_id 						serial primary key,
	price_list_id					integer references Price_List,
	payment_name					varchar (120),
	payment_date					date, 
	details							text
);

CREATE TABLE Services (

	service_id						serial primary key,
	price_list_id					integer references Price_List,
	service_name					varchar (120),
	service_date					date,
	details							text
);
