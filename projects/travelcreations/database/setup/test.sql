select TICKET_AGENT,TICKET_NUMBER,TICKET_CLASS,CLASS_DESCRIPTION description, TICKET_PAX_NAME,TICKET_SECTOR_1,TICKET_SECTOR_2,TICKET_SECTOR_3,TICKET_SECTOR_4,TICKET_SECTOR_5,TICKET_FINAL_DEST FINAL_DEST, TICKET_REFERENCE_1 invoice_amount,
TICKET_LOCAL_INTER local_international,TICKET_BOOKING_CLERK, TICKET_CUSTOMER_1 customer_code, ar_name customer_name, TICKET_REFERENCE_1 INVOICE_NUMBER,TICKET_REFERENCE_AMOUNT_1 INVOICE_AMOUNT,
AR_POBOX PO_BOX, AR_ADDRESS_2 ADDRESS, AR_TELEPHONE TELEPHONE_NO, AR_EMAIL EMAIL,AR_CREDIT_DAYS CREDIT_DAYS, AR_BALANCE INVOICE_BALANCE, AR_CREATED_BY CREATED_BY, AR_CREATED_ON CREATED_ON,AR_NOTES MEMBERSHIP_NO
from id_ticket_details, id_ar_master, ID_CLASS_MASTER
where ticket_customer_1 = ar_code AND TICKET_CLASS = CLASS_CODE