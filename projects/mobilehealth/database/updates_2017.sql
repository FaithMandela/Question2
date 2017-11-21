ALTER TABLE decision_support ADD COLUMN age_type varchar(10);
---- additional history questions
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(53,'How long ago did you give birth','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(54,'Is this your first baby','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(55,'How many PNC have you attended since you gave birth (after release from hospital)','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(56,'Is this your first pregnancy','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(57,'How many months pregnant are you','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(58,'So far, how many ANC visits have you received for this pregnancy','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(59,'How soon after birth did you start breast feeding','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(60,'What has the child fed on since birth','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(61,'Yesterday (throughout the day and night) what was the child fed on','');
INSERT INTO mother_mpp_info_def (mother_mpp_def_id,question,details)VALUES(62,'How many months pregnant were you when you first attended ANC','');

----death survey email alert

INSERT INTO sys_emails (sys_email_id, org_id, sys_email_name, default_email, title, details) 
VALUES (2,0,'Survey Death Alert', '', 'Survey Death Alert', '');

CREATE OR REPLACE FUNCTION aft_survey_death() RETURNS trigger AS $$
DECLARE
	v_survey_death_id		integer;
BEGIN

	IF((TG_OP = 'INSERT') AND (NEW.response != '0') AND (NEW.response != ''))THEN
		SELECT survey_death_id INTO v_survey_death_id
		FROM survey_death 
		WHERE (survey_death_id = NEW.survey_death_id) AND (response != '0') AND (response != '');		
		INSERT INTO sys_emailed (sys_email_id,org_id, table_id, table_name, email_type) VALUES (2,0, v_survey_death_id, 'survey_death', 1);		
		END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER aft_survey_death AFTER INSERT OR UPDATE ON survey_death
	FOR EACH ROW EXECUTE PROCEDURE aft_survey_death();

---- table to store all the dss questions and their expected responses as per mobile app

CREATE TABLE mother_def_info_options(
	mother_def_info_option_id		serial primary key,
	mother_mpp_def_id			integer references mother_mpp_info_def,
	response				integer,
	response_option			varchar(200),
	details					text
);
CREATE INDEX mother_def_info_options_mother_mpp_def_id ON mother_def_info_options(mother_mpp_def_id);

INSERT INTO mother_def_info_options (mother_def_info_option_id,mother_mpp_def_id,response,response_option)
VALUES
 (1,1,1,'Yes'), 
 (2,1,2,'No'),
 (3,2,1,'Yes'), 
 (4,2,2,'No'),
 (5,3,1,'Yes'),
 (6,3,2,'No'),
 (7,4,1,'Yes'), 
 (8,4,2,'No'),
 (9,5,1,'Yes'), 
 (10,5,2,'No'), 
 (11,6,1,'Yes'), 
 (12,6,2,'No'),
 (13,7,1,'Yes'), 
 (14,7,2,'No'),
 (15,8,1,'Yes'),
 (16,8,2,'No'),
 (17,9,1,'Yes'), 
 (18,9,2,'No'),
 (19,10,1,'Yes'), 
 (20,10,2,'No'),
 (21,11,1,'Yes'), 
 (22,11,2,'No'), 
 (23,12,1,'Yes'), 
 (24,12,2,'No'), 
 (25,13,1,'Yes'),
 (26,13,2,'No'), 
 (27,14,1,'Yes'), 
 (28,14,2,'No'), 
 (29,15,1,'Yes'),
 (30,15,2,'No'),
 (31,16,1,'Yes'), 
 (32,16,2,'No'), 
 (33,17,1,'Yes'), 
 (34,17,2,'No'), 
 (35,56,1,'Yes'),
 (36,56,2,'No'), 
 (37,57,1,'1 to 3 months'), 
 (38,57,2,'4 to 6 months'), 
 (39,57,3,'7 to 9 months'), 
 (40,57,4,'N/A'),
 (41,58,1,'None'), 
 (42,58,2,'1 visits'), 
 (43,58,3,'2 visits'), 
 (44,58,4,'3 visits'), 
 (45,58,5,'4 +'),
 (46,62,1,'1 to 3 months'), 
 (47,62,2,'4 to 6 months'), 
 (48,62,3,'7 to 9 months'), 
 (49,62,4,'N/A'), 
 (50,18,1,'Yes'), 
 (51,18,2,'No'), 
 (52,19,1,'Yes'), 
 (53,19,2,'No'), 
 (54,20,1,'Yes'), 
 (55,20,2,'No'), 
 (56,21,1,'Yes'), 
 (57,21,2,'No'), 
 (58,22,1,'Yes'), 
 (59,22,2,'No'), 
 (60,23,1,'Yes'), 
 (61,23,2,'No'), 
 (62,24,1,'Yes'), 
 (63,24,2,'No'), 
 (64,25,1,'Yes'), 
 (65,25,2,'No'), 
 (66,26,1,'Yes'), 
 (67,26,2,'No'),
 (68,27,1,'Yes'), 
 (69,27,2,'No'), 
 (70,28,1,'Yes'), 
 (71,28,2,'No'), 
 (72,29,1,'Yes'), 
 (73,29,2,'No'), 
 (74,30,1,'Yes'),
 (75,30,2,'No'), 
 (76,31,1,'Yes'), 
 (77,31,2,'No'), 
 (78,32,1,'Yes'), 
 (79,32,2,'No'),
 (80,33,1,'Yes'), 
 (81,33,2,'No'), 
 (82,53,1,'Less than 1 week ago'),
 (83,53,2,'1 to 2 weeks ago'),
 (84,53,3,'2 to 3 weeks ago'), 
 (85,53,4,'3 to 4 weeks ago'), 
 (86,53,5,'4 to 5 weeks ago'),
 (87,53,6,'5 to 6 weeks ago'),
 (88,53,7,'More than 6 weeks ago'), 
 (89,54,1,'Yes'), 
 (90,54,2,'No'),
 (91,55,1,'NONE'), 
 (92,55,2,'1 VISIT'), 
 (93,55,3,'2 VISITS'), 
 (94,55,4,'More than 2 visits'),
 (95,44,1,'Yes'), 
 (96,44,2,'No'), 
 (97,45,1,'Yes'), 
 (98,45,2,'No'),
 (99,46,1,'Yes'), 
 (100,46,2,'No'),
 (101,47,1,'Yes'), 
 (102,47,2,'No'),
 (103,48,1,'Yes'), 
 (104,48,2,'No'),
 (105,49,1,'Yes'), 
 (106,49,2,'No'),
 (107,50,1,'Yes'), 
 (108,50,2,'No'),
 (109,51,1,'Yes'), 
 (110,51,2,'No'),
 (111,52,1,'Yes'), 
 (112,52,2,'No'),
 (113,59,1,'Immediately/ less than 30 minutes'), 
 (114,59,2,'30 minutes to 1 hour'),
 (115,59,3,'More than 1 hour'),
 (116,59,4,'Dont know'),
 (117,59,5,'Never'),
 (118,60,1,'Breast milk only'),
 (119,60,2,'Breast milk and plain water'),
 (120,60,3,'Breast milk and water(with salt and sugar)'),
 (121,60,4,'Other(solid food, dairy, other liquids)'),
 (122,61,1,'Breast milk only'),
 (123,61,2,'Breast milk and water'),
 (124,61,3,'Breast milk and water(with salt and sugar)'),
 (125,61,4,'Other(solid food, dairy, other liquids)'),
 (126,34,1,'Yes'), 
 (127,34,2,'No'),
 (128,35,1,'Yes'), 
 (129,35,2,'No'),
 (130,36,1,'Yes'), 
 (131,36,2,'No'),
 (132,37,1,'Yes'), 
 (133,37,2,'No'), 
 (134,38,1,'Yes'), 
 (135,38,2,'No'),
 (136,39,1,'Yes'), 
 (137,39,2,'No'),
 (138,40,1,'Yes'), 
 (139,40,2,'No'),
 (140,41,1,'Yes'), 
 (141,41,2,'No'),
 (142,42,1,'Yes'), 
 (143,42,2,'No'),
 (144,43,1,'Yes'), 
 (145,43,2,'No');


--- views alter and updates

CREATE OR REPLACE VIEW vw_danger_survey_question_signs AS
	SELECT 
	mother_def_info_options.mother_def_info_option_id,mother_def_info_options.mother_mpp_def_id,

	mother_mpp_info_def.question,

	mother_def_info_options.response,mother_def_info_options.response_option
		FROM mother_def_info_options
		INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = mother_def_info_options.mother_mpp_def_id;

CREATE VIEW vw_dss_surveys AS
	SELECT
		decision_support.survey_id, 

		decision_support.name,decision_support.village_id ,decision_support.mobile ,decision_support.age ,decision_support.gender ,decision_support.org_id,
		decision_support.survey_time,decision_support.location_lat,decision_support.location_lng,decision_support.survey_status,decision_support.health_worker_id,
		decision_support.dsselection,decision_support.remarks,decision_support.guardian ,decision_support.u_sid,
		decision_support.weight,decision_support.age_type,

		surveys.household_number,surveys.household_member,surveys.return_reason,surveys.supervisor_remarks,surveys.dssxelection,
		surveys.mobile_num,surveys.reg_id,surveys.members,surveys.nickname ,surveys.landmark

		FROM decision_support
		INNER JOIN surveys ON decision_support.survey_id = surveys.survey_id
		WHERE decision_support.survey_id = surveys.survey_id;

--DROP VIEW vw_dss_survey_support CASCADE;

CREATE OR REPLACE VIEW vw_dss_survey_support AS
	SELECT 
		decision_support.survey_id, 
		decision_support.name,decision_support.village_id ,decision_support.mobile ,decision_support.age ,decision_support.gender ,decision_support.org_id,
		decision_support.survey_time,decision_support.location_lat,decision_support.location_lng,decision_support.survey_status,decision_support.health_worker_id,
		decision_support.dsselection,decision_support.remarks,decision_support.guardian ,decision_support.u_sid,
		decision_support.weight, decision_support.age_type,

		health_workers.worker_name,
		CASE decision_support.dsselection
		    WHEN 11 THEN 'PREGNANT'::text
		    WHEN 12 THEN 'POSTPARTUM'::text
		    WHEN 21 THEN 'NEWBORN'::text
		    WHEN 22 THEN 'NEWBORN'::text
		    ELSE 'N/A'::text
		END AS category_name

		FROM decision_support
		INNER JOIN health_workers ON decision_support.health_worker_id = health_workers.health_worker_id
		WHERE decision_support.health_worker_id = health_workers.health_worker_id;

CREATE OR REPLACE VIEW vw_dss_mpp AS
SELECT 
	decision_survey.mother_info_def_id ,mother_mpp_info_def.question,decision_survey.response ,
	CASE 
	---pregnant mother questions
            WHEN (decision_survey.mother_info_def_id = 1) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 1) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 2) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 2) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 3) AND decision_survey.response = 1 THEN 'Yes'::text 
            WHEN (decision_survey.mother_info_def_id = 3) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 4) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 4) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 5) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 5) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 6) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 6) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 7) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 7) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 8) AND decision_survey.response = 1 THEN 'Yes'::text 
            WHEN (decision_survey.mother_info_def_id = 8) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 9) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 9) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 10) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 10) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 11) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 11) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 12) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 12) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 13) AND decision_survey.response = 1 THEN 'Yes'::text 
            WHEN (decision_survey.mother_info_def_id = 13) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 14) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 14) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 15) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 15) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 16) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 16) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 17) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 17) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 56) AND decision_survey.response = 1 THEN 'Yes'::text 
            WHEN (decision_survey.mother_info_def_id = 56) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 57) AND decision_survey.response = 1 THEN '1 to 3 months'::text
            WHEN (decision_survey.mother_info_def_id = 57) AND decision_survey.response = 2 THEN '4 to 6 months'::text
            WHEN (decision_survey.mother_info_def_id = 57) AND decision_survey.response = 3 THEN '7 to 9 months'::text
            WHEN (decision_survey.mother_info_def_id = 57) AND decision_survey.response = 4 THEN 'N/A'::text 

            WHEN (decision_survey.mother_info_def_id = 58) AND decision_survey.response = 1 THEN 'None'::text
            WHEN (decision_survey.mother_info_def_id = 58) AND decision_survey.response = 2 THEN '1 visits'::text
            WHEN (decision_survey.mother_info_def_id = 58) AND decision_survey.response = 3 THEN '2 visits'::text
            WHEN (decision_survey.mother_info_def_id = 58) AND decision_survey.response = 4 THEN '3 visits'::text
            WHEN (decision_survey.mother_info_def_id = 58) AND decision_survey.response = 5 THEN '4 +'::text 

            WHEN (decision_survey.mother_info_def_id = 62) AND decision_survey.response = 1 THEN '1 to 3 months'::text
            WHEN (decision_survey.mother_info_def_id = 62) AND decision_survey.response = 2 THEN '4 to 6 months'::text
            WHEN (decision_survey.mother_info_def_id = 62) AND decision_survey.response = 3 THEN '7 to 9 months'::text
            WHEN (decision_survey.mother_info_def_id = 62) AND decision_survey.response = 4 THEN 'N/A'::text
            
        --- postpartum mothers
            WHEN (decision_survey.mother_info_def_id = 18) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 18) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 19) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 19) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 20) AND decision_survey.response = 1 THEN 'Yes'::text            
            WHEN (decision_survey.mother_info_def_id = 20) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 21) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 21) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 22) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 22) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 23) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 23) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 24) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 24) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 25) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 25) AND decision_survey.response = 2 THEN 'No'::text  

            WHEN (decision_survey.mother_info_def_id = 26) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 26) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 27) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 27) AND decision_survey.response = 2 THEN 'No'::text  

            WHEN (decision_survey.mother_info_def_id = 28) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 28) AND decision_survey.response = 2 THEN 'No'::text  

            WHEN (decision_survey.mother_info_def_id = 29) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 29) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 30) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 30) AND decision_survey.response = 2 THEN 'No'::text 
 
            WHEN (decision_survey.mother_info_def_id = 31) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 31) AND decision_survey.response = 2 THEN 'No'::text  

            WHEN (decision_survey.mother_info_def_id = 32) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 32) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 33) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 33) AND decision_survey.response = 2 THEN 'No'::text

            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 1 THEN 'Less than 1 week ago'::text
            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 2 THEN '1 to 2 weeks ago'::text  
            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 3 THEN '2 to 3 weeks ago'::text
            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 4 THEN '3 to 4 weeks ago'::text  
            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 5 THEN '4 to 5 weeks ago'::text 
            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 6 THEN '5 to 6 weeks ago'::text 
            WHEN (decision_survey.mother_info_def_id = 53) AND decision_survey.response = 7 THEN 'More than 6 weeks ago'::text 
             
            WHEN (decision_survey.mother_info_def_id = 54) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 54) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 55) AND decision_survey.response = 1 THEN 'NONE'::text
            WHEN (decision_survey.mother_info_def_id = 55) AND decision_survey.response = 2 THEN '1 VISIT'::text  
            WHEN (decision_survey.mother_info_def_id = 55) AND decision_survey.response = 3 THEN '2 VISITS'::text
            WHEN (decision_survey.mother_info_def_id = 55) AND decision_survey.response = 4 THEN 'More than 2 visits'::text 

    	--- Newborn questions
            WHEN (decision_survey.mother_info_def_id = 44) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 44) AND decision_survey.response = 2 THEN 'No'::text 
 
            WHEN (decision_survey.mother_info_def_id = 45) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 45) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 46) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 46) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 47) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 47) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 48) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 48) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 49) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 49) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 50) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 50) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 51) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 51) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 52) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 52) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 59) AND decision_survey.response = 1 THEN 'Immediately/ less than 30 minutes'::text
            WHEN (decision_survey.mother_info_def_id = 59) AND decision_survey.response = 2 THEN '30 minutes to 1 hour'::text 
            WHEN (decision_survey.mother_info_def_id = 59) AND decision_survey.response = 3 THEN 'More than 1 hour'::text
            WHEN (decision_survey.mother_info_def_id = 59) AND decision_survey.response = 4 THEN 'Dont know'::text 
            WHEN (decision_survey.mother_info_def_id = 59) AND decision_survey.response = 5 THEN 'Never'::text

            WHEN (decision_survey.mother_info_def_id = 60) AND decision_survey.response = 1 THEN 'Breast milk only'::text
            WHEN (decision_survey.mother_info_def_id = 60) AND decision_survey.response = 2 THEN 'Breast milk and plain water'::text 
            WHEN (decision_survey.mother_info_def_id = 60) AND decision_survey.response = 3 THEN 'Breast milk and water(with salt and sugar)'::text
            WHEN (decision_survey.mother_info_def_id = 60) AND decision_survey.response = 4 THEN 'Other(solid food, dairy, other liquids)'::text 

            WHEN (decision_survey.mother_info_def_id = 61) AND decision_survey.response = 1 THEN 'Breast milk only'::text
            WHEN (decision_survey.mother_info_def_id = 61) AND decision_survey.response = 2 THEN 'Breast milk and water'::text  
            WHEN (decision_survey.mother_info_def_id = 61) AND decision_survey.response = 3 THEN 'Breast milk and water(with salt and sugar)'::text 
            WHEN (decision_survey.mother_info_def_id = 61) AND decision_survey.response = 4 THEN 'Other(solid food, dairy, other liquids)'::text

            WHEN (decision_survey.mother_info_def_id = 34) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 34) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 35) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 35) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 36) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 36) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 37) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 37) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 38) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 38) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 39) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 39) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 40) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 40) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 41) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 41) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 42) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 42) AND decision_survey.response = 2 THEN 'No'::text 

            WHEN (decision_survey.mother_info_def_id = 43) AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN (decision_survey.mother_info_def_id = 43) AND decision_survey.response = 2 THEN 'No'::text

                          
        END AS response_name,     

	decision_survey.survey_id ,decision_survey.dss_id ,decision_survey.survey_100_id ,
	decision_survey.reg_id

		FROM decision_survey
		INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id;


CREATE OR REPLACE VIEW vw_dss_chv_2017 AS
	SELECT 
	vw_villages.village_id,vw_villages.sub_location_name,vw_villages.village_name,

	vw_dss_survey_support.survey_id, vw_dss_survey_support.name,vw_dss_survey_support.mobile,
	(vw_dss_survey_support.age||' '||vw_dss_survey_support.age_type) AS age,vw_dss_survey_support.category_name,
	vw_dss_survey_support.worker_name,vw_dss_survey_support.survey_time,

	vw_dss.question,vw_dss.response_name

		 FROM vw_dss_survey_support
		 INNER JOIN vw_dss ON vw_dss_survey_support.survey_id = vw_dss.survey_id
		 INNER JOIN vw_villages ON vw_dss_survey_support.village_id = vw_villages.village_id;

---- replacing case in vw_dss

CREATE OR REPLACE VIEW vw_dss AS 
 SELECT mother_mpp_info_def.mother_mpp_def_id,
    mother_mpp_info_def.question,
    mother_mpp_info_def.details,
    decision_survey.survey_100_id,
    decision_survey.survey_id,
    decision_survey.dss_id,
    decision_survey.response,
        CASE
            WHEN decision_survey.mother_info_def_id = 1 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 1 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 2 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 2 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 3 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 3 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 4 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 4 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 5 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 5 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 6 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 6 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 7 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 7 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 8 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 8 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 9 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 9 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 10 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 10 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 11 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 11 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 12 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 12 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 13 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 13 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 14 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 14 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 15 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 15 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 16 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 16 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 17 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 17 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 56 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 56 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 57 AND decision_survey.response = 1 THEN '1 to 3 months'::text
            WHEN decision_survey.mother_info_def_id = 57 AND decision_survey.response = 2 THEN '4 to 6 months'::text
            WHEN decision_survey.mother_info_def_id = 57 AND decision_survey.response = 3 THEN '7 to 9 months'::text
            WHEN decision_survey.mother_info_def_id = 57 AND decision_survey.response = 4 THEN 'N/A'::text
            WHEN decision_survey.mother_info_def_id = 58 AND decision_survey.response = 1 THEN 'None'::text
            WHEN decision_survey.mother_info_def_id = 58 AND decision_survey.response = 2 THEN '1 visits'::text
            WHEN decision_survey.mother_info_def_id = 58 AND decision_survey.response = 3 THEN '2 visits'::text
            WHEN decision_survey.mother_info_def_id = 58 AND decision_survey.response = 4 THEN '3 visits'::text
            WHEN decision_survey.mother_info_def_id = 58 AND decision_survey.response = 5 THEN '4 +'::text
            WHEN decision_survey.mother_info_def_id = 62 AND decision_survey.response = 1 THEN '1 to 3 months'::text
            WHEN decision_survey.mother_info_def_id = 62 AND decision_survey.response = 2 THEN '4 to 6 months'::text
            WHEN decision_survey.mother_info_def_id = 62 AND decision_survey.response = 3 THEN '7 to 9 months'::text
            WHEN decision_survey.mother_info_def_id = 62 AND decision_survey.response = 4 THEN 'N/A'::text
            WHEN decision_survey.mother_info_def_id = 18 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 18 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 19 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 19 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 20 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 20 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 21 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 21 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 22 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 22 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 23 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 23 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 24 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 24 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 25 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 25 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 26 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 26 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 27 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 27 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 28 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 28 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 29 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 29 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 30 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 30 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 31 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 31 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 32 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 32 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 33 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 33 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 1 THEN 'Less than 1 week ago'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 2 THEN '1 to 2 weeks ago'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 3 THEN '2 to 3 weeks ago'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 4 THEN '3 to 4 weeks ago'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 5 THEN '4 to 5 weeks ago'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 6 THEN '5 to 6 weeks ago'::text
            WHEN decision_survey.mother_info_def_id = 53 AND decision_survey.response = 7 THEN 'More than 6 weeks ago'::text
            WHEN decision_survey.mother_info_def_id = 54 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 54 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 55 AND decision_survey.response = 1 THEN 'NONE'::text
            WHEN decision_survey.mother_info_def_id = 55 AND decision_survey.response = 2 THEN '1 VISIT'::text
            WHEN decision_survey.mother_info_def_id = 55 AND decision_survey.response = 3 THEN '2 VISITS'::text
            WHEN decision_survey.mother_info_def_id = 55 AND decision_survey.response = 4 THEN 'More than 2 visits'::text
            WHEN decision_survey.mother_info_def_id = 44 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 44 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 45 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 45 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 46 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 46 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 47 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 47 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 48 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 48 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 49 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 49 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 50 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 50 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 51 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 51 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 52 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 52 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 59 AND decision_survey.response = 1 THEN 'Immediately/ less than 30 minutes'::text
            WHEN decision_survey.mother_info_def_id = 59 AND decision_survey.response = 2 THEN '30 minutes to 1 hour'::text
            WHEN decision_survey.mother_info_def_id = 59 AND decision_survey.response = 3 THEN 'More than 1 hour'::text
            WHEN decision_survey.mother_info_def_id = 59 AND decision_survey.response = 4 THEN 'Dont know'::text
            WHEN decision_survey.mother_info_def_id = 59 AND decision_survey.response = 5 THEN 'Never'::text
            WHEN decision_survey.mother_info_def_id = 60 AND decision_survey.response = 1 THEN 'Breast milk only'::text
            WHEN decision_survey.mother_info_def_id = 60 AND decision_survey.response = 2 THEN 'Breast milk and plain water'::text
            WHEN decision_survey.mother_info_def_id = 60 AND decision_survey.response = 3 THEN 'Breast milk and water(with salt and sugar)'::text
            WHEN decision_survey.mother_info_def_id = 60 AND decision_survey.response = 4 THEN 'Other(solid food, dairy, other liquids)'::text
            WHEN decision_survey.mother_info_def_id = 61 AND decision_survey.response = 1 THEN 'Breast milk only'::text
            WHEN decision_survey.mother_info_def_id = 61 AND decision_survey.response = 2 THEN 'Breast milk and water'::text
            WHEN decision_survey.mother_info_def_id = 61 AND decision_survey.response = 3 THEN 'Breast milk and water(with salt and sugar)'::text
            WHEN decision_survey.mother_info_def_id = 61 AND decision_survey.response = 4 THEN 'Other(solid food, dairy, other liquids)'::text
            WHEN decision_survey.mother_info_def_id = 34 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 34 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 35 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 35 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 36 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 36 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 37 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 37 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 38 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 38 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 39 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 39 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 40 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 40 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 41 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 41 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 42 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 42 AND decision_survey.response = 2 THEN 'No'::text
            WHEN decision_survey.mother_info_def_id = 43 AND decision_survey.response = 1 THEN 'Yes'::text
            WHEN decision_survey.mother_info_def_id = 43 AND decision_survey.response = 2 THEN 'No'::text
            ELSE 'N/A'::text
        END AS response_name
   FROM decision_survey
     JOIN mother_mpp_info_def ON decision_survey.mother_info_def_id = mother_mpp_info_def.mother_mpp_def_id;

---- replacing vw_mother_mpp case responces

CREATE OR REPLACE VIEW vw_mother_mpp AS 
 SELECT mother_mpp_info_def.mother_mpp_def_id,
    mother_mpp_info_def.question,
    mother_mpp_info_def.details,
    surveys.survey_id,
    mother_mpp.mother_mpp_id,
    mother_mpp.response,
    mother_mpp.survey_100_id,
    mother_mpp.reg_id,
        CASE
            WHEN mother_mpp_info_def.mother_mpp_def_id = 1 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 1 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 2 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 2 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 3 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 3 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 4 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 4 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 5 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 5 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 6 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 6 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 7 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 7 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 8 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 8 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 9 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 9 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 10 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 10 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 11 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 11 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 12 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 12 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 13 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 13 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 14 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 14 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 15 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 15 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 16 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 16 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 17 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 17 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 56 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 56 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 57 AND mother_mpp.response::text = '1'::text THEN '1 to 3 months'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 57 AND mother_mpp.response::text = '2'::text THEN '4 to 6 months'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 57 AND mother_mpp.response::text = '3'::text THEN '7 to 9 months'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 57 AND mother_mpp.response::text = '4'::text THEN 'N/A'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 58 AND mother_mpp.response::text = '1'::text THEN 'None'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 58 AND mother_mpp.response::text = '2'::text THEN '1 visits'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 58 AND mother_mpp.response::text = '3'::text THEN '2 visits'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 58 AND mother_mpp.response::text = '4'::text THEN '3 visits'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 58 AND mother_mpp.response::text = '5'::text THEN '4 +'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 62 AND mother_mpp.response::text = '1'::text THEN '1 to 3 months'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 62 AND mother_mpp.response::text = '2'::text THEN '4 to 6 months'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 62 AND mother_mpp.response::text = '3'::text THEN '7 to 9 months'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 62 AND mother_mpp.response::text = '4'::text THEN 'N/A'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 18 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 18 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 19 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 19 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 20 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 20 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 21 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 21 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 22 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 22 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 23 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 23 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 24 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 24 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 25 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 25 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 26 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 26 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 27 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 27 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 28 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 28 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 29 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 29 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 30 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 30 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 31 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 31 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 32 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 32 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 33 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 33 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '1'::text THEN 'Less than 1 week ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '2'::text THEN '1 to 2 weeks ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '3'::text THEN '2 to 3 weeks ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '4'::text THEN '3 to 4 weeks ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '5'::text THEN '4 to 5 weeks ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '6'::text THEN '5 to 6 weeks ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 53 AND mother_mpp.response::text = '7'::text THEN 'More than 6 weeks ago'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 54 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 54 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 55 AND mother_mpp.response::text = '1'::text THEN 'NONE'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 55 AND mother_mpp.response::text = '2'::text THEN '1 VISIT'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 55 AND mother_mpp.response::text = '3'::text THEN '2 VISITS'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 55 AND mother_mpp.response::text = '4'::text THEN 'More than 2 visits'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 44 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 44 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 45 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 45 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 46 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 46 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 47 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 47 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 48 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 48 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 49 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 49 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 50 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 50 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 51 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 51 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 52 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 52 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 59 AND mother_mpp.response::text = '1'::text THEN 'Immediately/ less than 30 minutes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 59 AND mother_mpp.response::text = '2'::text THEN '30 minutes to 1 hour'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 59 AND mother_mpp.response::text = '3'::text THEN 'More than 1 hour'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 59 AND mother_mpp.response::text = '4'::text THEN 'Dont know'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 59 AND mother_mpp.response::text = '5'::text THEN 'Never'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 60 AND mother_mpp.response::text = '1'::text THEN 'Breast milk only'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 60 AND mother_mpp.response::text = '2'::text THEN 'Breast milk and plain water'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 60 AND mother_mpp.response::text = '3'::text THEN 'Breast milk and water(with salt and sugar)'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 60 AND mother_mpp.response::text = '4'::text THEN 'Other(solid food, dairy, other liquids)'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 61 AND mother_mpp.response::text = '1'::text THEN 'Breast milk only'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 61 AND mother_mpp.response::text = '2'::text THEN 'Breast milk and water'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 61 AND mother_mpp.response::text = '3'::text THEN 'Breast milk and water(with salt and sugar)'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 61 AND mother_mpp.response::text = '4'::text THEN 'Other(solid food, dairy, other liquids)'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 34 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 34 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 35 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 35 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 36 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 36 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 37 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 37 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 38 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 38 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 39 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 39 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 40 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 40 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 41 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 41 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 42 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 42 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 43 AND mother_mpp.response::text = '1'::text THEN 'Yes'::text
            WHEN mother_mpp_info_def.mother_mpp_def_id = 43 AND mother_mpp.response::text = '2'::text THEN 'No'::text
            ELSE 'N/A'::text
        END AS response_name,
    mother_mpp.child_no,
    mother_mpp.survey_status
   FROM mother_mpp
     JOIN mother_mpp_info_def ON mother_mpp.mother_mpp_def_id = mother_mpp_info_def.mother_mpp_def_id
     JOIN surveys ON mother_mpp.survey_id = surveys.survey_id
  ORDER BY mother_mpp.mother_mpp_id;

----========================================
--- 513 indicators view update

CREATE OR REPLACE VIEW vw_ref_513 AS 
SELECT 
survey_513_info_def.survey_513_def_id,survey_513_info_def.question,survey_513_info_def.details,
    survey_513.survey_id,survey_513_data.survey_513_id, survey_513_data.response,
        CASE 
		---HH Members in Age Cohort
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 1 THEN '0 - 28 days'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 2 THEN '29 days - 11 months'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 3 THEN '2 - 59 months'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 4 THEN '5 - 12 years'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 5 THEN '13 - 24 girls'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 6 THEN '13 - 24 boys'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 7 THEN '25 -59 years'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 1) AND survey_513_data.response = 8 THEN '60 years and above'::text
		 ---Relationship to HHH
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 1 THEN 'HHH'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 2 THEN 'Spouse'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 3 THEN 'Child (B)'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 4 THEN 'Child (R)'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 5 THEN 'Grand Child'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 6 THEN 'Brother/Sister'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 2) AND survey_513_data.response = 7 THEN 'Others'::text
		 ---Orphan
		 WHEN (survey_513_info_def.survey_513_def_id = 3) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 3) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 3) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---Birth certificate
		 WHEN (survey_513_info_def.survey_513_def_id = 4) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 4) AND survey_513_data.response = 2 THEN 'No'::text
		 ---"In school"
		 WHEN (survey_513_info_def.survey_513_def_id = 5) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 5) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 5) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Pregnant"
		 WHEN (survey_513_info_def.survey_513_def_id = 6) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 6) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 6) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Mother and Child Health Booklet"
		 WHEN (survey_513_info_def.survey_513_def_id = 7) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 7) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 7) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"ANC (at least 4 visits)"
		 WHEN (survey_513_info_def.survey_513_def_id = 8) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 8) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 8) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Delivered by Skilled Birth Attendant"
		 WHEN (survey_513_info_def.survey_513_def_id = 9) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 9) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 9) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Exclusive breastfeeding "
		 WHEN (survey_513_info_def.survey_513_def_id = 10) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 10) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 10) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Using Family Planning Methods"
		 WHEN (survey_513_info_def.survey_513_def_id = 11) AND survey_513_data.response = 1 THEN 'None'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 11) AND survey_513_data.response = 2 THEN 'Modern'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 11) AND survey_513_data.response = 3 THEN 'Traditional/Natural'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 11) AND survey_513_data.response = 4 THEN 'N/A'::text
		 ---"Penta 1 Given"
		 WHEN (survey_513_info_def.survey_513_def_id = 12) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 12) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 12) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Penta 2 Given"
		 WHEN (survey_513_info_def.survey_513_def_id = 13) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 13) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 13) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Measles Given"
		 WHEN (survey_513_info_def.survey_513_def_id = 14) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 14) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 14) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Fully Immunized"
		 WHEN (survey_513_info_def.survey_513_def_id = 15) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 15) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 15) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Vitamin A Given"
		 WHEN (survey_513_info_def.survey_513_def_id = 16) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 16) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 16) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Children 6-23 months received 3 or more food groups three times a day"
		 WHEN (survey_513_info_def.survey_513_def_id = 17) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 17) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 17) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Severely Malnourished (MAUC indicating Yellow)"
		 WHEN (survey_513_info_def.survey_513_def_id = 18) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 18) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 18) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---19;"LLIN use"
		 WHEN (survey_513_info_def.survey_513_def_id = 19) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 19) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 19) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Known chronic illness "
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 1 THEN 'NONE'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 2 THEN 'DIABETES'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 3 THEN 'CANCERS'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 4 THEN 'MENTAL ILLNESS'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 5 THEN 'HYPERTENSION'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 6 THEN 'CHRONIC RESPIRATORY DISEASES'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 20) AND survey_513_data.response = 7 THEN 'OTHER'::text
		 ---"Cough (2 Weeks and above) ""
		 WHEN (survey_513_info_def.survey_513_def_id = 21) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 21) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 21) AND survey_513_data.response = 3 THEN 'N/A'::text
		 ---"Knows HIV status"
		 WHEN (survey_513_info_def.survey_513_def_id = 22) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 22) AND survey_513_data.response = 2 THEN 'No'::text
		 ---"Disability "
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 1 THEN 'None'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 2 THEN 'Visual'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 3 THEN 'Hearing'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 4 THEN 'Speech'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 5 THEN 'Physical'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 6 THEN 'Mental'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 23) AND survey_513_data.response = 7 THEN 'Other'::text
		 ---"Moderately Malnourished (MAUC indicating Yellow)"
		 WHEN (survey_513_info_def.survey_513_def_id = 30) AND survey_513_data.response = 1 THEN 'Yes'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 30) AND survey_513_data.response = 2 THEN 'No'::text
		 WHEN (survey_513_info_def.survey_513_def_id = 30) AND survey_513_data.response = 3 THEN 'N/A'::text
            
        END AS response_name,
    survey_513_data.uid
   FROM survey_513_data
     JOIN survey_513_info_def ON survey_513_data.survey_513_def_id = survey_513_info_def.survey_513_def_id
     JOIN survey_513 ON survey_513_data.survey_id = survey_513.survey_id;


