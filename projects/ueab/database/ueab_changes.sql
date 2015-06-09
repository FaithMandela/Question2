
CREATE TABLE countys(

county_id		char(2) primary key,
county_name		varchar(50)


);

ALTER TABLE students 
ADD COLUMN disability varchar(5),
ADD COLUMN dis_details text,
ADD COLUMN county_id char(2) references countys;

CREATE INDEX students_county_id ON students (county_id);

INSERT INTO countys(county_id, county_name)
VALUES	('MO', 'Mombasa'),
		('KW','Kwale'),
		('KI','Kilifi'),
		('TR','Tana River'),
		('LA','Lamu'),
		('TT','Taita-Taveta'),
		('GA','Garissa'),
		('WA','Wajir'),
		('MA','Mandera'),
		('MR','Marsabit'),
		('IS','Isiolo'),
		('ME','Meru'),
		('TN','Tharaka-Nithi'),
		('EB','Embu'),
		('KT','Kitui'),
		('MC','Machakos'),
		('MK','Makueni'),
		('NY','Nyandarua'),
		('NR','Nyeri'),
		('KR','Kirinyaga'),
		('MU','Muranga'),
		('KB','Kiambu'),
		('TK','Turkana'),
		('WP','West Pokot'),
		('SA','Samburu'),
		('TZ','Trans Nzoia'),
		('UG','Uasin Gishu'),
		('EM','Elgeyo-Marakwet'),
		('ND','Nandi'),
		('BR','Baringo'),
		('LP','Laikipia'),
		('NK','Nakuru'),
		('NO','Narok'),
		('KJ','kajiado');
		
	
	ALTER TABLE grades
	ADD COLUMN p_minrange integer,
	ADD COLUMN p_maxrange integer;
		
		
	





