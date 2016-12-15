---Project Database File
CREATE TABLE mitch(
	mitch_id	 serial primary key,
	column_1		varchar(120),
	column_2		varchar(120),
	column_3		varchar(120),
	details			text
);

CREATE TABLE mitch2(
	mitch2_id	 serial primary key,
	mitch_id		integer references	mitch,
	column_1		varchar(120),
	column_2		varchar(120),
	column_3		varchar(120),
	details			text
);


	