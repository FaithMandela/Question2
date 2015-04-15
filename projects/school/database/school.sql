CREATE TABLE students (
	student_id			varchar(12) primary key,
	student_name		varchar(50) not null,
	guardian_name		varchar(50) not null,
	address				varchar(50),
	town				varchar(50),
	admission_date		date not null,
	birth_date			date,
	house				varchar(50),
	stream				varchar(10),
	details				text
);

CREATE TABLE subjects (
	subject_id			serial primary key,
	subject_name		varchar(50) not null,
	details				text
);

CREATE TABLE teachers (
	teacher_id			serial primary key,
	teacher_name		varchar(50) not null,
	joining_date		date,
	birth_date			date,
	details				text
);

CREATE TABLE teacher_allocations (
	teacher_allocation_id	serial primary key,
	subject_id			integer references subjects,
	teacher_id			integer references teachers,
	classes				varchar(50),
	details				text
);
CREATE INDEX teacher_allocations_subject_id ON teacher_allocations (subject_id);
CREATE INDEX teacher_allocations_teacher_id ON teacher_allocations (teacher_id);

CREATE TABLE votes (
	vote_id				varchar(12) primary key,
	vote_name			varchar(50) not null,
	income_account		integer,
	expense_account		integer,
	details				text
);

CREATE TABLE vote_defaults (
	vote_default_id		serial primary key,
	vote_id				varchar(12) references votes,
	classes				varchar(50),
	terms				varchar(50),
	amount				real
);
CREATE INDEX vote_defaults_vote_id ON vote_defaults (vote_id);

CREATE TABLE terms (
	term_id				varchar(12) primary key,
	start_date			date,
	end_date			date,
	closed				boolean default false not null,
	details				text
);

CREATE TABLE vote_terms (
	vote_term_id		serial primary key,
	term_id				varchar(12) references terms,
	vote_id				varchar(12) references votes,
	amount				real not null,
	class				integer default 0 not null,
	details				text
);
CREATE INDEX vote_terms_vote_id ON vote_terms (vote_id);
CREATE INDEX vote_terms_term_id ON vote_terms (term_id);

CREATE TABLE std_terms (
	std_term_id			serial primary key,
	term_id				varchar(12) references terms,
	student_id			varchar(12) references students,
	journal_id			integer,
	std_class			integer,
	details				text
);
CREATE INDEX std_terms_student_id ON std_terms (student_id);
CREATE INDEX std_terms_term_id ON std_terms (term_id);

CREATE TABLE exams (
	exam_id				serial primary key,
	std_term_id			integer references std_terms,
	subject_id			integer references subjects,
	teacher_id			integer references teachers,
	CAT1				real,
	CAT2				real,
	exam				real,
	details				text
);
CREATE INDEX exams_std_term_id ON exams (std_term_id);
CREATE INDEX exams_subject_id ON exams (subject_id);
CREATE INDEX exams_teacher_id ON exams (teacher_id);

CREATE TABLE receipts (
	receipt_id			serial primary key,
	student_id			varchar(12) references students,
	journal_id			integer,
	receipt_date		date,
	amount				real,
	bank_name			varchar(50),
	cheque_number		varchar(50),
	details				text
);
CREATE INDEX receipts_student_id ON receipts (student_id);

CREATE TABLE vote_allocations (
	vote_allocation_id	serial primary key,
	receipt_id			integer references receipts,
	vote_id				varchar(12) references votes,
	vote_amount			real
);
CREATE INDEX vote_allocations_receipt_id ON vote_allocations (receipt_id);
CREATE INDEX vote_allocations_vote_id ON vote_allocations (vote_id);

CREATE TABLE items (
	item_id				serial primary key,
	item_name			varchar(50),
	details				text
);

CREATE TABLE item_issued (
	item_issue_id		serial primary key,
	student_id			varchar(12) references students,
	item_id				integer references items, 
	teacher_id			integer references teachers,
	issue_date			date default current_date not null,
	issue_condition		varchar(30),
	return_condition	varchar(30),
	is_returned			boolean default false not null,	
	return_date			date,
	extra_cost			real,			
	details				text
);
CREATE INDEX item_issued_student_id ON item_issued (student_id);
CREATE INDEX item_issued_item_id ON item_issued (item_id);
CREATE INDEX item_issued_teacher_id ON item_issued (teacher_id);

CREATE VIEW vw_teacher_allocations AS
	SELECT subjects.subject_id, subjects.subject_name, teachers.teacher_id, teachers.teacher_name, 
		teacher_allocations.teacher_allocation_id, teacher_allocations.classes, teacher_allocations.details
	FROM teacher_allocations INNER JOIN subjects ON teacher_allocations.subject_id = subjects.subject_id
		INNER JOIN teachers ON teacher_allocations.teacher_id = teachers.teacher_id;

CREATE VIEW vw_vote_defaults AS
	SELECT votes.vote_id, votes.vote_name, vote_defaults.vote_default_id, vote_defaults.classes, 
		vote_defaults.terms, vote_defaults.amount
	FROM vote_defaults INNER JOIN votes ON vote_defaults.vote_id = votes.vote_id;

CREATE VIEW vw_vote_terms AS
	SELECT terms.term_id, terms.start_date, EXTRACT(year FROM terms.start_date) as term_year,
		substring(terms.term_id from 6 for 1) as term,
		votes.vote_id, votes.vote_name, vote_terms.vote_term_id, vote_terms.amount, 
		vote_terms.class, vote_terms.details
	FROM vote_terms INNER JOIN terms ON vote_terms.term_id = terms.term_id
		INNER JOIN votes ON vote_terms.vote_id = votes.vote_id;

CREATE VIEW vw_std_terms AS
	SELECT students.student_id, students.student_name, students.admission_date, students.birth_date,
		terms.term_id, terms.start_date, EXTRACT(year FROM terms.start_date) as term_year,
		substring(terms.term_id from 6 for 1) as term,
		std_terms.std_term_id, std_terms.std_class, std_terms.details
	FROM std_terms INNER JOIN students ON std_terms.student_id = students.student_id
		INNER JOIN terms ON std_terms.term_id = terms.term_id;

CREATE VIEW vw_std_term_vote AS
	SELECT vw_std_terms.student_id, vw_std_terms.student_name, vw_std_terms.term_id, 
		vw_std_terms.std_class, vw_vote_terms.vote_id, vw_vote_terms.vote_name, 
		vw_vote_terms.amount
	FROM vw_std_terms INNER JOIN vw_vote_terms ON (vw_std_terms.term_id = vw_vote_terms.term_id)
		AND (vw_std_terms.std_class = vw_vote_terms.class);

CREATE VIEW vw_exams AS
	SELECT vw_std_terms.student_id, vw_std_terms.student_name, vw_std_terms.admission_date, vw_std_terms.birth_date,
		vw_std_terms.term_id, vw_std_terms.start_date, vw_std_terms.term_year,
		vw_std_terms.term, vw_std_terms.std_term_id, vw_std_terms.std_class,
		subjects.subject_id, subjects.subject_name, teachers.teacher_id, teachers.teacher_name, 
		exams.exam_id, exams.cat1, exams.cat2, exams.exam, exams.details
	FROM exams INNER JOIN vw_std_terms ON exams.std_term_id = vw_std_terms.std_term_id
		INNER JOIN subjects ON exams.subject_id = subjects.subject_id
		INNER JOIN teachers ON exams.teacher_id = teachers.teacher_id;

CREATE VIEW vw_receipts AS
	SELECT students.student_id, students.student_name, receipts.receipt_id, receipts.receipt_date, 
		receipts.amount, receipts.bank_name, receipts.cheque_number, receipts.details
	FROM receipts INNER JOIN students ON receipts.student_id = students.student_id;

CREATE VIEW vw_vote_allocations AS
	SELECT vw_receipts.student_id, vw_receipts.student_name, vw_receipts.receipt_id, vw_receipts.receipt_date, 
		vw_receipts.amount, vw_receipts.bank_name, vw_receipts.cheque_number,
		votes.vote_id, votes.vote_name, vote_allocations.vote_allocation_id, vote_allocations.vote_amount
	FROM vote_allocations INNER JOIN vw_receipts ON vote_allocations.receipt_id = vw_receipts.receipt_id
		INNER JOIN votes ON vote_allocations.vote_id = votes.vote_id;

CREATE VIEW vw_item_issued AS
	SELECT items.item_id, items.item_name, students.student_id, students.student_name, 
		teachers.teacher_id, teachers.teacher_name, item_issued.item_issue_id, item_issued.issue_date, 
		item_issued.issue_condition, item_issued.return_condition, item_issued.is_returned, 
		item_issued.return_date, item_issued.extra_cost, item_issued.details
	FROM item_issued INNER JOIN items ON item_issued.item_id = items.item_id
		INNER JOIN students ON item_issued.student_id = students.student_id
		INNER JOIN teachers ON item_issued.teacher_id = teachers.teacher_id;

CREATE OR REPLACE FUNCTION ins_students() RETURNS trigger AS $$
DECLARE
	termid	varchar(12);
BEGIN

	SELECT MAX(terms.term_id) INTO termid
	FROM terms;

	INSERT INTO std_terms (term_id, student_id, std_class)
	VALUES (termid, NEW.student_id, 1);

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_students AFTER INSERT ON students
    FOR EACH ROW EXECUTE PROCEDURE ins_students();

CREATE OR REPLACE FUNCTION ins_terms() RETURNS trigger AS $$
DECLARE
	studentrec RECORD;
	tm varchar(1);
BEGIN	
	
	SELECT substring(NEW.term_id FROM 6 FOR 1) INTO tm;

	IF(tm = '1') THEN
		INSERT INTO std_terms (term_id, student_id, std_class)
		SELECT NEW.term_id, student_id, MAX(std_class)+1
		FROM std_terms
		GROUP BY student_id;
	ELSE
		INSERT INTO std_terms (term_id, student_id, std_class)
		SELECT NEW.term_id, student_id, MAX(std_class)
		FROM std_terms
		GROUP BY student_id;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ins_terms AFTER INSERT ON terms
    FOR EACH ROW EXECUTE PROCEDURE ins_terms();




