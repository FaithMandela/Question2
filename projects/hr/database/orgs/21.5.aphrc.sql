		
CREATE OR REPLACE FUNCTION leave_aplication(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
	v_leave_balance			real;
	v_leave_total			real;
	v_leave_overlap			integer;
	v_approve_status		varchar(16);
	v_table_id				integer;
	v_employee_month_id		integer;
	v_month_leave			real;
	v_leave_ending			date;
	rec						RECORD;
	msg 					varchar(120);
BEGIN
	msg := 'Leave applied';

	SELECT leave_types.leave_days_span, leave_types.month_limit, leave_types.maximum_days,
		employee_leave.employee_leave_id, employee_leave.entity_id, employee_leave.leave_type_id,
		employee_leave.leave_days, employee_leave.leave_from, employee_leave.leave_to,
		employee_leave.contact_entity_id, employee_leave.narrative,
		adjustments.adjustment_id, adjustments.adjustment_type
		INTO rec
	FROM leave_types INNER JOIN employee_leave ON leave_types.leave_type_id = employee_leave.leave_type_id
		LEFT JOIN adjustments ON leave_types.adjustment_id = adjustments.adjustment_id
	WHERE (employee_leave.employee_leave_id = CAST($1 as int));
	
	SELECT leave_ending INTO v_leave_ending 
	FROM employee_leave_types 
	WHERE (entity_id = rec.entity_id) AND (leave_type_id = rec.leave_type_id);

	v_leave_balance := get_leave_balance(rec.entity_id, rec.leave_type_id);
	
	SELECT sum(employee_leave.leave_days) INTO v_leave_total
	FROM employee_leave 
	WHERE (entity_id = rec.entity_id) AND (leave_type_id = rec.leave_type_id) AND (approve_status = 'Rejected');

	SELECT count(employee_leave_id) INTO v_leave_overlap
	FROM employee_leave
	WHERE (entity_id = rec.entity_id) AND (approve_status <> 'Rejected')
		AND (employee_leave_id <> rec.employee_leave_id)
		AND (((leave_from, leave_to) OVERLAPS (rec.leave_from - 1, rec.leave_to + 1)) = true);
		
	SELECT sum(employee_leave_id) INTO v_month_leave
	FROM employee_leave
	WHERE (entity_id = rec.entity_id) AND (approve_status <> 'Rejected')
		AND (leave_type_id = rec.leave_type_id)
		AND (to_char(leave_from, 'YYYYMM') =  to_char(current_date, 'YYYYMM'));
	IF(v_month_leave is null)THEN v_month_leave := 0; END IF;

	SELECT approve_status INTO v_approve_status
	FROM employee_leave
	WHERE (employee_leave_id = CAST($1 as int));
	
	IF(rec.adjustment_id is not null)THEN
		SELECT employee_month.employee_month_id INTO v_employee_month_id
		FROM periods INNER JOIN employee_month ON periods.period_id = employee_month.period_id
		WHERE (employee_month.entity_id = rec.entity_id)
		AND (rec.leave_from BETWEEN periods.start_date AND periods.end_date);
	END IF;
	
	IF(rec.contact_entity_id is null)THEN
		RAISE EXCEPTION 'You must enter a contact person.';
	ELSIF(v_approve_status <> 'Draft')THEN
		msg := 'Your application is not a draft.';
		RAISE EXCEPTION '%', msg;
	ELSIF(rec.leave_days > rec.leave_days_span)THEN
		msg := 'Days applied for excced the span allowed';
		RAISE EXCEPTION '%', msg;
	ELSIF(rec.leave_from < current_date - 60)THEN
		msg := 'Apply leave within correct period';
		RAISE EXCEPTION '%', msg;
	ELSIF(v_leave_balance <= 0)THEN
		msg := 'You do not have enough days to apply for this leave';
		RAISE EXCEPTION '%', msg;
	ELSIF(v_leave_overlap > 0)THEN
		msg := 'You have applied for overlaping leave days';
		RAISE EXCEPTION '%', msg;
	ELSIF((rec.month_limit > 0) AND (v_month_leave > rec.month_limit))THEN
		msg := 'You exceed the month limit';
		RAISE EXCEPTION '%', msg;
	ELSIF((rec.maximum_days > 0) AND (v_leave_total > rec.maximum_days))THEN
		msg := 'You exceed the total allowed leave day limit';
		RAISE EXCEPTION '%', msg;
	ELSIF((v_leave_ending is not null) AND (v_leave_ending < rec.leave_to))THEN
		msg := 'You are not allowed to apply for the leave past ' || to_char(v_leave_ending, 'DD Mon YYYY');
		RAISE EXCEPTION '%', msg;
	ELSIF((rec.adjustment_id is not null) AND (v_employee_month_id is null))THEN
		msg := 'This leave has an allowance or deduction and needs to be applied on a valid month';
		RAISE EXCEPTION '%', msg;
	ELSE
		UPDATE employee_leave SET approve_status = 'Completed'
		WHERE (employee_leave_id = CAST($1 as int));
		
		SELECT workflow_table_id INTO v_table_id
		FROM employee_leave
		WHERE (employee_leave_id = CAST($1 as int));
		
		UPDATE approvals SET approval_narrative = rec.narrative
		WHERE (table_name = 'employee_leave') AND (table_id = v_table_id);
	END IF;

	return msg;
END;
$$ LANGUAGE plpgsql;

