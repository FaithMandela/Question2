CREATE TABLE pesapal_trans(
  pesapal_trans_id serial NOT NULL,
  merchant_orderid integer references passengers,
  pesapal_transaction_tracking_id character varying(200),
  status character varying(30),
  jp_timestamp timestamp without time zone DEFAULT now(),
  details text

);
CREATE INDEX pesapal_trans_passenger_id ON pesapal_trans (merchant_orderid);
