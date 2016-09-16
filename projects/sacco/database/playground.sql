CREATE OR REPLACE FUNCTION ins_gurrantors() RETURNS trigger AS
$BODY$
DECLARE
    v_total_amount      real;
    v_balance     real;
    v_already_g           real;
    loanamount            real;
    v_shares           real;
    v_loan              record;
    v_amount            integer;
    v_gurrantor          boolean;
    msg                 varchar(120);
BEGIN
msg := 'Loan gurranteed';
v_gurrantor  = true;
 --check mainas share/contribution value
 SELECT  sum(contribution_amount + additional_payments) into  v_shares from contributions where entity_id = NEW.entity_id;
     v_already_g := 0;
     
     --haha get the total amount for guarantors of that loan 
     select sum(amount) into v_already_g from gurrantors where loan_id  = NEW.loan_id;---this
     -- haha naho get the principle amount for the loan
     select principle into loanamount from loans where loan_id  = NEW.loan_id;
    
    -- haha rî display values uone kama ziko sawa, ukimaliza comment out so that it can proceed
    raise exception 'v_already_g % | loanamount % | guarantee amount %', v_already_g, loanamount, NEW.amount ;
    
    -- haha tondü niho utaranyita rî compare the amount for the new guarantor you are trying to add and see if it will exceed the remaining amount to be guaranteed
    
     if NEW.amount > (loanamount - v_already_g) then
         raise exception 'amount remaining for guarantee is %',(loanamount - v_already_g);
     -- îno else unaweza kula na thufu ukishaona how much is already guaranteed

     else 
         raise exception 'loans are %', v_already_g ;
     end if;
-- The above is the easiest gükü küngî ndioî üküririra kü   nonga kîoro ø˚∆  
