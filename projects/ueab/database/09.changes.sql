

CREATE TABLE content_levels (
	content_level		integer primary key,
	required_courses	integer default 1 not null,
	narrative			varchar(250)
);

ALTER  TABLE students 
ADD sys_audit_trail_id	integer references sys_audit_trail;

CREATE INDEX students_org_id ON students (org_id);
CREATE INDEX students_sys_audit_trail_id ON students (sys_audit_trail_id);


CREATE OR REPLACE FUNCTION updstudents() RETURNS trigger AS $$
DECLARE
	v_user_id		varchar(50);
	v_user_ip		varchar(50);
BEGIN
	IF (OLD.fullbursary = false) and (NEW.fullbursary = true) THEN
		SELECT user_id, user_ip INTO v_user_id, v_user_ip
		FROM sys_audit_trail
		WHERE (sys_audit_trail_id = NEW.sys_audit_trail_id);
		IF(v_user_id is null)THEN
			v_user_id := current_user;
			v_user_ip := cast(inet_client_addr() as varchar);
		ELSE
			SELECT user_name INTO v_user_id
			FROM entitys WHERE entity_id::varchar = v_user_id;
		END IF;
	
		INSERT INTO sys_audit_trail (user_id, user_ip, table_name, record_id, change_type, narrative)
		VALUES (v_user_id, v_user_ip, 'students', NEW.studentid, 'approve', 'Approve full Bursary');
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_passed(double precision, double precision, integer, varchar(12), varchar(12)) RETURNS boolean AS $$
DECLARE
	passed 				boolean;
	v_required_courses	integer;
	v_courses			integer;
BEGIN
	passed := false;
	
	IF($1 >= $2) THEN
		passed := true;
	ELSIF($3 is not null)THEN
		SELECT count(courseid) INTO v_courses
		FROM courseoutline
		WHERE (content_level = $3) AND (studentid = $4) AND (majorid = $5)
			AND (courseweight >= gradeweight);
		IF(v_courses is null)THEN v_courses := 0; END IF;
		
		SELECT required_courses INTO v_required_courses
		FROM content_levels
		WHERE (content_level = $3);
		IF(v_required_courses is null)THEN v_required_courses := 1; END IF;
		
		IF(v_courses >=  v_required_courses)THEN passed := true; END IF;
	END IF;

    RETURN passed;
END;
$$ LANGUAGE plpgsql;
			