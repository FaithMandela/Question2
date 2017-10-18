CREATE TABLE pesapal_trans(
  pesapal_trans_id                  serial PRIMARY key,
  merchant_orderid                  integer references passengers,
  pesapal_transaction_tracking_id   character varying(200),
  status                            character varying(30),
  trans_method                      character varying(30),
  jp_timestamp                      timestamp without time zone DEFAULT now(),
  details                           text,
UNIQUE(pesapal_transaction_tracking_id,merchant_orderid)
);
CREATE INDEX pesapal_trans_passenger_id ON pesapal_trans (merchant_orderid);


ALTER TABLE passengers add COLUMN kesamount real;
ALTER TABLE policy_members add COLUMN kesamount real;

CREATE OR REPLACE VIEW vw_pesapal_trans AS
 SELECT pesapal_trans.pesapal_trans_id, pesapal_trans.merchant_orderid, pesapal_trans.pesapal_transaction_tracking_id,
     pesapal_trans.status, pesapal_trans.jp_timestamp, pesapal_trans.details,
     vw_allpassengers.kesamount,  vw_allpassengers.passenger_name,pesapal_trans.trans_method
   FROM pesapal_trans
     JOIN vw_allpassengers ON pesapal_trans.merchant_orderid = vw_allpassengers.passenger_id;

     CREATE  OR REPLACE VIEW vw_logs AS
    SELECT logs.logsid, logs.transid, logs.entity_id, logs.userip, passengers.kesamount as amount_1, passengers.totalamount_covered as amount_2, logs.transdate,
       logs.portal, logs.status,passengers.passenger_name, passengers.passenger_email,entitys.primary_email,entitys.entity_name
    FROM logs
    INNER JOIN passengers ON passengers.passenger_id = logs.transid
    INNER JOIN entitys ON entitys.entity_id = logs.entity_id;
