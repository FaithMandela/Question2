

ALTER TABLE pay_scales ADD 	currency_id				integer references currency;
CREATE INDEX pay_scales_currency_id ON pay_scales(currency_id);
UPDATE pay_scales SET currency_id = 1;

CREATE TABLE vw_pay_scales AS
	SELECT currency.currency_id, currency.currency_name, currency.currency_symbol,
		pay_scales.org_id, pay_scales.pay_scale_id, pay_scales.pay_scale_name,
		pay_scales.min_pay, pay_scales.max_pay, pay_scales.details
	FROM pay_scales INNER JOIN currency ON pay_scales.currency_id = currency.currency_id;

	