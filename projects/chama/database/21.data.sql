

INSERT INTO contribution_types VALUES(1,0,'Member Contribution', TRUE, 'Cash raised for chama members');

ALTER TABLE investments DROP COLUMN amount CASCADE;
ALTER TABLE investments ADD COLUMN principal real;
ALTER TABLE investments ADD COLUMN period real;
ALTER TABLE investments ADD COLUMN monthly_returns real;
ALTER TABLE investments ADD COLUMN total_payment real;
ALTER TABLE investments ADD COLUMN investment_name varchar(120);

ALTER TABLE investments DROP status;
ALTER TABLE investments ADD approve_status varchar (16) ;

ALTER TABLE contribution_types DROP merry_go_round CASCADE;

ALTER TABLE investment_types ADD interest_amount real;

ALTER TABLE contributions ADD meeting_id integer references meetings;
ALTER TABLE contributions ADD merry_go_round_percentage real;
ALTER TABLE contributions ADD actual_amount real;
ALTER TABLE contributions DROP contribution_date CASCADE;
ALTER TABLE contributions ADD merry_go_round boolean default true;
ALTER TABLE contributions DROP confirmation CASCADE;
ALTER TABLE contributions DROP member_payment CASCADE;
ALTER TABLE contributions DROP share_value CASCADE;

ALTER TABLE meetings ADD entity_id integer references entitys;


