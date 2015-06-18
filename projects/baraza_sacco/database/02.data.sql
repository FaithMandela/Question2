
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (2,2,'Bildad Otieno Agwena','14691117','Bildard.Agwena@dewcis.com','2006-09-01', 'bagwena');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (3,3,'Edwin Muhindi Njoroge','20207028','Edwin.Muhindi@dewcis.com','2006-09-01', 'emuhindi');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (4,4,'Joseph Mugambi Kaindio','22174935','Joseph.Mugambi@dewcis.com','2006-09-01', 'jmugambi');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (5,5,'Jackline Nyakio Maina','22618309','Jackline.Maina@dewcis.com','2006-09-01', 'jmaina');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (6,6,'Robert Machui Mwaniki','22471180','Robert.Mwaniki@dewcis.com','2006-09-01', 'rmwaniki');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (7,7,'Mohammed Hamisi Manguze','12894617','Mohamed.Manguze@dewcis.com','2006-09-01', 'mmanguze');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (8,8,'Robert Ndungu Njoroge','22652967','Robert.Njoroge@dewcis.com','2006-09-01', 'rnjoroge');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (9,9,'Eric Wanjohi Githaiga','21160650','Eric.Wanjohi@dewcis.com','2006-09-01', 'ewanjohi');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (10,10,'Paul Micheni Ngeera','20855179','Paul.Ngeera@dewcis.com','2006-09-01', 'pngeera');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (11,11,'Victor Bahati Paliah','20815774','Bahati.Paliah@dewcis.com','2006-09-01', 'vbahati');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (12,12,'Simon Osoo Chitwa','22276554','Simon.Osoo@dewcis.com','2006-09-01', 'sosoo');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (14,14,'Nyalala Wills Olando','22753984','Wills.Olando@dewcis.com','2006-09-01', 'wolando');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (13,13,'Grace Ndonga Njoki','11679615','Grace.Ndonga@dewcis.com','2006-09-01', 'gndonga');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (15,15,'Hilary Kiragu Wanjiru','21892575','Hilary.Kiragu@dewcis.com','2006-09-01', 'hkiragu');
INSERT INTO members (memberid, staffno, membername, idnumber, email, startdate, memberlogin) VALUES (16,16,'Mercy Kaguu Kinyua','23751148','Mercy.Kinyua@dewcis.com','2006-09-01', 'mkinyua');
UPDATE members SET isactive = true, entrydate = '2006-09-01', email = '', idnumber = '';

SELECT pg_catalog.setval('members_memberid_seq', 20, true);

UPDATE members SET payroll = 2500.0 WHERE memberid = 2;
UPDATE members SET payroll = 3000.0 WHERE memberid = 3;
UPDATE members SET payroll = 3000.0 WHERE memberid = 4;
UPDATE members SET payroll = 3000.0 WHERE memberid = 5;
UPDATE members SET payroll = 2500.0 WHERE memberid = 6;
UPDATE members SET payroll = 3500.0 WHERE memberid = 7;
UPDATE members SET payroll = 3000.0 WHERE memberid = 8;
UPDATE members SET payroll = 2000.0 WHERE memberid = 9;
UPDATE members SET payroll = 2500.0 WHERE memberid = 10;
UPDATE members SET payroll = 3000.0 WHERE memberid = 11;
UPDATE members SET payroll = 2500.0 WHERE memberid = 12;
UPDATE members SET payroll = 2000.0 WHERE memberid = 13;
UPDATE members SET payroll = 2000.0 WHERE memberid = 14;
UPDATE members SET payroll = 3000.0 WHERE memberid = 15;
UPDATE members SET payroll = 2500.0 WHERE memberid = 16;

INSERT INTO loantypes (loantypename, defaultinterest) VALUES ('Emergency Loan', 6);
INSERT INTO loantypes (loantypename, defaultinterest) VALUES ('Education Loan', 12);
INSERT INTO loantypes (loantypename, defaultinterest) VALUES ('Development Loan', 15);

INSERT INTO Periods (StartDate, EndDate) VALUES ('2006-09-01', '2006-10-01');
SELECT updPeriods(1);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2006-10-01', '2006-11-01');
SELECT updPeriods(2);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2006-11-01', '2006-12-01');
SELECT updPeriods(3);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2006-12-01', '2007-01-01');
SELECT updPeriods(4);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2007-01-01', '2007-02-01');
SELECT updPeriods(5);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2007-02-01', '2007-03-01');
SELECT updPeriods(6);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2007-03-01', '2007-04-01');
SELECT updPeriods(7);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2007-04-01', '2007-05-01');
SELECT updPeriods(8);
UPDATE members SET payroll = 5820 WHERE memberid = 10;
UPDATE members SET payroll = 6800 WHERE memberid = 11;

INSERT INTO loans (loantypeid, memberid, loandate, principle, interest, repaymentperiod, monthlyrepayment, loanapproved) VALUES (3, 10, '2007-05-01', 16000, 12, 4, 4320, true);
INSERT INTO loans (loantypeid, memberid, loandate, principle, interest, repaymentperiod, monthlyrepayment, loanapproved) VALUES (3, 11, '2007-05-01', 15000, 12, 4, 5300, true);

INSERT INTO Periods (StartDate, EndDate) VALUES ('2007-05-01', '2007-06-01');
SELECT updPeriods(9);
INSERT INTO Periods (StartDate, EndDate) VALUES ('2007-06-01', '2007-07-01');
SELECT updPeriods(10);

INSERT INTO loans (loantypeid, memberid, loandate, principle, interest, repaymentperiod, monthlyrepayment, loanapproved) VALUES (3, 5, '2007-06-07', 20000, 12, 5, 4000, true);
UPDATE members SET payroll = 5500 WHERE memberid = 5;
INSERT INTO loans (loantypeid, memberid, loandate, principle, interest, repaymentperiod, monthlyrepayment, loanapproved) VALUES (3, 16, '2007-06-07', 20000, 12, 5, 4000, true);
UPDATE members SET payroll = 5500 WHERE memberid = 16;
INSERT INTO loans (loantypeid, memberid, loandate, principle, interest, repaymentperiod, monthlyrepayment, loanapproved) VALUES (3, 3, '2007-06-07', 100000, 12, 12, 8000, true);
UPDATE members SET payroll = 9000 WHERE memberid = 3;

UPDATE members SET isactive = true;



