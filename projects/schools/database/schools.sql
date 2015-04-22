CREATE TABLE student_guardians(
	
		student_guardian_id			serial primary key,
		entity_id					integer references entitys,
		details						text
	);