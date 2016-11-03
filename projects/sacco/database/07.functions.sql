--alter table contributions drop deposit_amount cascade ;
--alter table contributions drop deposit_date cascade ;

alter table contributions add receipt real default 0 ;
alter table contributions add receipt_date date;
