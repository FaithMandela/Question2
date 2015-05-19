CREATE TABLE doctor (
  doctorid				serial primary key,
  doctorname			varchar(50),
  doctorshift			time
  );
  
CREATE TABLE patient (
  patientid				serial primary key,
  patientname			varchar(50),
  patientdetails		text,
  visitdate				date,
  patientlastvisit		date
  );
  
CREATE TABLE nurse (
  nurseid				serial primary key,
  nursename				varchar (50),
  nursedetails			text,
  nurseshift			time,
  doctorid				integer
  );
