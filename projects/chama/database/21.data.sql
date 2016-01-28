

INSERT INTO contribution_types VALUES(0,0,'Shares Contribution', FALSE, 'Cash raised is valued in shares');
INSERT INTO contribution_types VALUES(1,0,'Member Contribution', TRUE, 'Cash raised for chama members');
INSERT INTO contribution_types VALUES(2,0,'Salary Contribution', FALSE, 'Cash raised to pay chama employees');
INSERT INTO contribution_types VALUES(3,0,'Operations Contribution', FALSE, 'Cash raised to purchase items');

ALTER TABLE investments DROP COLUMN amount CASCADE;
ALTER TABLE investments ADD COLUMN principal real;
ALTER TABLE investments ADD COLUMN period real;
ALTER TABLE investments ADD COLUMN monthly_returns real;
ALTER TABLE investments ADD COLUMN total_payment real;
ALTER TABLE investments ADD COLUMN investment_name varchar(120);

alter table investment_types add interest_amount real;

alter table investments drop status;
alter table investments add approve_status varchar (16) ;

alter table contributions add meeting_id integer references meetings;
 

