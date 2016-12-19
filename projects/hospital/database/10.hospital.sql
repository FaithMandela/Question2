---Project Database File

CREATE TABLE patients (
	patient_id				serial primary key,
	patient_name			varchar(50),
	date_of_birth			date,
	sex						char(1),
	details					text
);

CREATE TABLE consultations (
	consultation_id			serial primary key,
	patient_id				integer references patients,
	visit_date				date,
	temp					real,
	pressure				varchar(12),
	symptoms				text,
	details					text
);

CREATE VIEW vw_consultations AS
	SELECT patients.patient_id, patients.patient_name, 
		consultations.consultation_id, consultations.visit_date, consultations.temp, consultations.pressure, 
		consultations.symptoms, consultations.details
	FROM consultations INNER JOIN patients ON consultations.patient_id = patients.patient_id;