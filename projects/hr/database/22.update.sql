CREATE TABLE adjustment_effects (
	adjustment_effect_id	integer primary key,
	adjustment_effect_name	varchar(50) not null
);

ALTER TABLE adjustments ADD adjustment_effect_id	integer references adjustment_effects;
CREATE INDEX adjustments_adjustment_effect_id ON adjustments(adjustment_effect_id);

INSERT INTO adjustment_effects (adjustment_effect_id, adjustment_effect_name) VALUES (0, 'General');
INSERT INTO adjustment_effects (adjustment_effect_id, adjustment_effect_name) VALUES (1, 'Housing');
INSERT INTO adjustment_effects (adjustment_effect_id, adjustment_effect_name) VALUES (2, 'Insurance');

