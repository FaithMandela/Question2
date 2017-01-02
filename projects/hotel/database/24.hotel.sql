---- Hotel tables

CREATE TABLE service_types (
	service_type_id			serial primary key,
	org_id					integer references orgs,
	service_type_name		varchar(50) not null unique,
	details					text
);
CREATE INDEX service_types_org_id ON service_types (org_id);

CREATE TABLE room_types (
	room_type_id			serial primary key,
	org_id					integer references orgs,
	room_type_name			varchar(50) not null unique,
	units					integer default 10 not null,
	details					text
);
CREATE INDEX room_types_org_id ON room_types (org_id);

CREATE TABLE rooms (
	room_id					serial primary key,
	room_type_id			integer references room_types,
	org_id					integer references orgs,
	room_number				varchar(50) not null,
	is_active				boolean not null default true,
	operation_date			date,
	details					text
);
CREATE INDEX rooms_room_type_id ON rooms (room_type_id);
CREATE INDEX rooms_org_id ON rooms (org_id);

CREATE TABLE room_block (
	room_block_id			serial primary key,
	room_id					integer references rooms,
	org_id					integer references orgs,
	date_from				date not null,
	date_to					date not null,
	narrative				varchar(240)
);
CREATE INDEX room_block_room_id ON room_block (room_id);
CREATE INDEX room_block_org_id ON room_block (org_id);

CREATE TABLE room_rates (
	room_rate_id			serial primary key,
	room_type_id			integer references room_types,
	service_type_id			integer references service_types,
	currency_id				integer references currency,
	org_id					integer references orgs,
	current_rate			real not null,
	date_start				date not null,
	date_end				date not null,
	is_active				boolean default false,
	tax1					real not null default 16,
	tax2					real not null default 0,
	tax3					real not null default 0,
	exchange_rate			real default 1 not null,
	details					text
);
CREATE INDEX room_rates_room_type_id ON room_rates (room_type_id);
CREATE INDEX room_rates_service_type_id ON room_rates (service_type_id);
CREATE INDEX room_rates_currency_id ON room_rates (currency_id);
CREATE INDEX room_rates_org_id ON room_rates (org_id);

CREATE TABLE reserve_modes (
	reserve_mode_id			serial primary key,
	org_id					integer references orgs,
	reserve_mode_name		varchar(50) not null unique,
	details					text
);
CREATE INDEX reserve_modes_org_id ON reserve_modes (org_id);

CREATE TABLE bookings (
	booking_id				serial primary key,
	entity_id				integer references entitys,
	room_rate_id			integer references room_rates,
	reserve_mode_id			integer references reserve_modes,
	currency_id				integer references currency,
	org_id					integer references orgs,
	booking_date			date not null default current_date,
	arrival_date			date not null,
	arrival_time			time,
	departure_date			date not null,
	departure_time			time,
	units					integer not null default 1,
	confirmed				boolean default false,
	closed					boolean default false,
	book_rate				real not null default 0,
	commision				real not null default 0,
	discount				real not null default 0,
	tax1					real not null default 16,
	tax2					real not null default 16,
	tax3					real not null default 16,
	exchange_rate			real default 1 not null,
	payment_method			varchar(50),
	details					text
);
CREATE INDEX bookings_entity_id ON bookings (entity_id);
CREATE INDEX bookings_room_rate_id ON bookings (room_rate_id);
CREATE INDEX bookings_reserve_mode_id ON bookings (reserve_mode_id);
CREATE INDEX bookings_currency_id ON bookings (currency_id);
CREATE INDEX bookings_org_id ON bookings (org_id);

CREATE TABLE residents (
	resident_id		 		serial primary key,
	entity_id				integer references entitys,
	org_id					integer references orgs,
	resident_name			varchar(120) not null,
	email					varchar(120),
	identification			varchar(120),
	date_of_birth			date,
	details					text
);
CREATE INDEX residents_entity_id ON residents (entity_id);
CREATE INDEX residents_org_id ON residents (org_id);

CREATE TABLE stay (
	stay_id					serial primary key,
	booking_id				integer references bookings,
	resident_id				integer references residents,
	room_id					integer references rooms,
	org_id					integer references orgs,
	arrival_date			date not null,
	arrival_time			time,
	departure_date			date not null,
	departure_time			time,
	completed				boolean not null default false,
	room_cleared			boolean not null default false,
	details					text
);
CREATE INDEX stay_room_id ON stay (room_id);
CREATE INDEX stay_booking_id ON stay (booking_id);
CREATE INDEX stay_resident_id ON stay (resident_id);
CREATE INDEX stay_org_id ON stay (org_id);

CREATE TABLE receipts (
	receipt_id				serial primary key,
	booking_id				integer references bookings,
	bank_account_id			integer references bank_accounts,
	journal_id				integer references journals,
	currency_id				integer references currency,
	sys_audit_trail_id		integer references sys_audit_trail,
	org_id					integer references orgs,
	receipt_number			varchar(50),
	pay_date				date not null,
	cleared					boolean default false not null,
	tx_type					integer default 1 not null,
	amount					float not null,
	exchange_rate			real default 1 not null,
	details					text
);
CREATE INDEX receipts_booking_id ON receipts (booking_id);
CREATE INDEX receipts_bank_account_id ON receipts (bank_account_id);
CREATE INDEX receipts_journal_id ON receipts (journal_id);
CREATE INDEX receipts_currency_id ON receipts (currency_id);
CREATE INDEX receipts_sys_audit_trail_id ON receipts (sys_audit_trail_id);
CREATE INDEX receipts_org_id ON receipts (org_id);


CREATE VIEW vw_rooms AS
	SELECT room_types.room_type_id, room_types.room_type_name, 
		rooms.org_id, rooms.room_id, rooms.room_number, rooms.is_active, rooms.operation_date, 
		rooms.details
	FROM rooms INNER JOIN room_types ON rooms.room_type_id = room_types.room_type_id;
	
CREATE VIEW vw_room_rates AS
	SELECT room_types.room_type_id, room_types.room_type_name,
		service_types.service_type_id, service_types.service_type_name,
		currency.currency_id, currency.currency_name,  
		room_rates.org_id, room_rates.room_rate_id, room_rates.current_rate, room_rates.date_start, 
		room_rates.date_end, room_rates.is_active, room_rates.tax1, room_rates.tax2, room_rates.tax3, 
		room_rates.exchange_rate, room_rates.details
	FROM room_rates INNER JOIN room_types ON room_rates.room_type_id = room_types.room_type_id
		INNER JOIN service_types ON room_rates.service_type_id = service_types.service_type_id
		INNER JOIN currency ON room_rates.currency_id = currency.currency_id;

CREATE VIEW vw_bookings AS
	SELECT vw_room_rates.room_type_id, vw_room_rates.room_type_name,
		vw_room_rates.service_type_id, vw_room_rates.service_type_name,
		vw_room_rates.room_rate_id, vw_room_rates.current_rate, vw_room_rates.date_start, vw_room_rates.date_end,
		entitys.entity_id, entitys.entity_name,
		currency.currency_id, currency.currency_name,
		reserve_modes.reserve_mode_id, reserve_modes.reserve_mode_name,
		bookings.org_id, bookings.booking_id, bookings.booking_date, bookings.arrival_date, bookings.arrival_time, 
		bookings.departure_date, bookings.departure_time, bookings.units, bookings.confirmed, bookings.closed, 
		bookings.book_rate, bookings.commision, bookings.discount, bookings.tax1, bookings.tax2, bookings.tax3, 
		bookings.exchange_rate, bookings.payment_method, bookings.details
	FROM bookings INNER JOIN vw_room_rates ON bookings.room_rate_id = vw_room_rates.room_rate_id
		INNER JOIN entitys ON bookings.entity_id = entitys.entity_id
		INNER JOIN currency ON bookings.currency_id = currency.currency_id
		INNER JOIN reserve_modes ON bookings.reserve_mode_id = reserve_modes.reserve_mode_id;
		
CREATE VIEW vw_residents AS
	SELECT entitys.entity_id, entitys.entity_name, 
		residents.org_id, residents.resident_id, residents.residentname, residents.email, 
		residents.identification, residents.date_of_birth, residents.details
	FROM residents INNER JOIN entitys ON residents.entity_id = entitys.entity_id;
	
CREATE OR REPLACE FUNCTION ins_bookings() RETURNS TRIGGER AS $$
DECLARE
	myrec RECORD;
	raterec RECORD;
BEGIN
	SELECT INTO raterec max(currentrate) as mcurrrenrate, max(tax1) as mtax1, max(tax2) as mtax2, max(tax3) as mtax3
	FROM roomrates
        WHERE (room_type_id = NEW.room_type_id) AND (service_type_id = NEW.service_type_id) 
		AND (startdate <= NEW.arrivaldate) AND (enddate >= NEW.arrivaldate) AND (droprate = false);

	SELECT INTO myrec commision, discount FROM clients INNER JOIN Residents ON clients.clientid = Residents.clientid
		WHERE ResidentID = NEW.ResidentID;

	IF (raterec.mcurrrenrate is not null) THEN
		NEW.bookrate = raterec.mcurrrenrate;
		NEW.tax1 = raterec.mtax1;
		NEW.tax2 = raterec.mtax2;
		NEW.tax3 = raterec.mtax3;
		NEW.commision = myrec.commision;
		NEW.discount = myrec.discount;
		NEW.exchangerate = getcurrencyrate(NEW.currencyid);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_bookings BEFORE INSERT ON bookings
    FOR EACH ROW EXECUTE PROCEDURE ins_bookings();

CREATE OR REPLACE FUNCTION ins_stay() RETURNS TRIGGER AS $$
DECLARE
	myrec RECORD;
BEGIN
	SELECT INTO myrec commision, discount, bookrate, tax1, tax2, tax3, currencyid, exchangerate,
		service_type_id, arrivaldate, arrivaltime, departuredate, departuretime
	FROM Bookings WHERE Bookingid = NEW.Bookingid;

	NEW.stayrate = myrec.bookrate;
	NEW.staycommision = myrec.commision;
	NEW.staydiscount = myrec.discount;
	NEW.tax1 = myrec.tax1;
	NEW.tax2 = myrec.tax2;
	NEW.tax3 = myrec.tax3;
	NEW.currencyid = myrec.currencyid;
	NEW.exchangerate = myrec.exchangerate;
	NEW.service_type_id = myrec.service_type_id;
	NEW.arrivaldate = myrec.arrivaldate;
	NEW.arrivaltime = myrec.arrivaltime;
	NEW.departuredate = myrec.departuredate;
	NEW.departuretime = myrec.departuretime;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_stay BEFORE INSERT ON stay
    FOR EACH ROW EXECUTE PROCEDURE ins_stay();


