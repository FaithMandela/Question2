---Project Database File
Create table trial(
	trial_id		serial primary key,
	trial_name		varchar(50),
	narrative		varchar(120),
	details			text
	);



CREATE VIEW vw_trial AS
	SELECT trial.trial_id, trial.trial_name, trial.narrative, trial.details
	FROM trial;