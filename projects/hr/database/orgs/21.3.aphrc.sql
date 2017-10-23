

ALTER TABLE leave_types 
ADD 	maximum_days			real default 0 not null;

ALTER TABLE employee_leave_types
ADD 	leave_ending			date;


DROP VIEW vw_employee_leave_types;
CREATE VIEW vw_employee_leave_types AS
	SELECT entitys.entity_id, entitys.entity_name, leave_types.leave_type_id, leave_types.leave_type_name, 
		leave_types.allowed_leave_days, leave_types.leave_days_span, leave_types.use_type,
		leave_types.month_quota, leave_types.initial_days, leave_types.maximum_carry, leave_types.include_holiday,
		employee_leave_types.org_id, employee_leave_types.employee_leave_type_id, employee_leave_types.leave_balance, 
		employee_leave_types.leave_starting, employee_leave_types.leave_ending, employee_leave_types.details,
		(CASE WHEN employee_leave_types.leave_ending < current_date THEN false ELSE true END) as leave_valid
	FROM employee_leave_types INNER JOIN entitys ON employee_leave_types.entity_id = entitys.entity_id
		INNER JOIN leave_types ON employee_leave_types.leave_type_id = leave_types.leave_type_id;
		