CREATE VIEW vw_dss_surveys AS
	SELECT
		decision_support.survey_id, 

		decision_support.name,decision_support.village_id ,decision_support.mobile ,decision_support.age ,decision_support.gender ,decision_support.org_id,
		decision_support.survey_time,decision_support.location_lat,decision_support.location_lng,decision_support.survey_status,decision_support.health_worker_id,
		decision_support.dsselection,decision_support.remarks,decision_support.guardian ,decision_support.u_sid,
		decision_support.weight, decision_support.age_type,

		surveys.household_number,surveys.household_member,surveys.return_reason,surveys.supervisor_remarks,surveys.dssxelection,
		surveys.mobile_num,surveys.reg_id,surveys.members,surveys.nickname ,surveys.landmark

		FROM decision_support
		INNER JOIN surveys ON decision_support.survey_id = surveys.survey_id
		WHERE decision_support.survey_id = surveys.survey_id;

CREATE VIEW vw_dss_survey_support AS
	SELECT 
		decision_support.survey_id, 
		decision_support.name,decision_support.village_id ,decision_support.mobile ,decision_support.age ,decision_support.gender ,decision_support.org_id,
		decision_support.survey_time,decision_support.location_lat,decision_support.location_lng,decision_support.survey_status,decision_support.health_worker_id,
		decision_support.dsselection,decision_support.remarks,decision_support.guardian ,decision_support.u_sid,
		decision_support.weight, decision_support.age_type,

		decision_survey.mother_info_def_id,decision_survey.response,decision_survey.dss_id,decision_survey.survey_100_id,
		decision_survey.reg_id

		FROM decision_support
		INNER JOIN decision_survey ON decision_support.survey_id = decision_survey.survey_id
		WHERE decision_support.survey_id = decision_survey.survey_id;

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

CREATE VIEW vw_dss_mpp AS
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

CREATE OR REPLACE vw_mother_mpp AS
  SELECT mother_mpp_info_def.mother_mpp_def_id,
    mother_mpp_info_def.question,
    mother_mpp_info_def.details,
    surveys.survey_id,
    mother_mpp.mother_mpp_id,
    mother_mpp.response,
    mother_mpp.survey_100_id,
    mother_mpp.reg_id,
        CASE 
			---pregnant mother questions
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 1) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 1) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 2) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 2) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 3) AND mother_mpp.response = '1'::text THEN 'Yes'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 3) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 4) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 4) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 5) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 5) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 6) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 6) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 7) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 7) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 8) AND mother_mpp.response = '1'::text THEN 'Yes'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 8) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 9) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 9) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 10) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 10) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 11) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 11) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 12) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 12) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 13) AND mother_mpp.response = '1'::text THEN 'Yes'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 13) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 14) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 14) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 15) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 15) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 16) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 16) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 17) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 17) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 56) AND mother_mpp.response = '1'::text THEN 'Yes'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 56) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 57) AND mother_mpp.response = '1'::text THEN '1 to 3 months'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 57) AND mother_mpp.response = '2'::text THEN '4 to 6 months'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 57) AND mother_mpp.response = '3'::text THEN '7 to 9 months'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 57) AND mother_mpp.response = '4'::text THEN 'N/A'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 58) AND mother_mpp.response = '1'::text THEN 'None'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 58) AND mother_mpp.response = '2'::text THEN '1 visits'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 58) AND mother_mpp.response = '3'::text THEN '2 visits'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 58) AND mother_mpp.response = '4'::text THEN '3 visits'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 58) AND mother_mpp.response = '5'::text THEN '4 +'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 62) AND mother_mpp.response = '1'::text THEN '1 to 3 months'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 62) AND mother_mpp.response = '2'::text THEN '4 to 6 months'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 62) AND mother_mpp.response = '3'::text THEN '7 to 9 months'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 62) AND mother_mpp.response = '4'::text THEN 'N/A'::text
            
        --- postpartum mothers
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 18) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 18) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 19) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 19) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 20) AND mother_mpp.response = '1'::text THEN 'Yes'::text            
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 20) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 21) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 21) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 22) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 22) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 23) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 23) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 24) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 24) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 25) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 25) AND mother_mpp.response = '2'::text THEN 'No'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 26) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 26) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 27) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 27) AND mother_mpp.response = '2'::text THEN 'No'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 28) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 28) AND mother_mpp.response = '2'::text THEN 'No'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 29) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 29) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 30) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 30) AND mother_mpp.response = '2'::text THEN 'No'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 31) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 31) AND mother_mpp.response = '2'::text THEN 'No'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 32) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 32) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 33) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 33) AND mother_mpp.response = '2'::text THEN 'No'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '1'::text THEN 'Less than 1 week ago'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '2'::text THEN '1 to 2 weeks ago'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '3'::text THEN '2 to 3 weeks ago'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '4'::text THEN '3 to 4 weeks ago'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '5'::text THEN '4 to 5 weeks ago'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '6'::text THEN '5 to 6 weeks ago'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 53) AND mother_mpp.response = '7'::text THEN 'More than 6 weeks ago'::text              
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 54) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 54) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 55) AND mother_mpp.response = '1'::text THEN 'NONE'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 55) AND mother_mpp.response = '2'::text THEN '1 VISIT'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 55) AND mother_mpp.response = '3'::text THEN '2 VISITS'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 55) AND mother_mpp.response = '4'::text THEN 'More than 2 visits'::text 

    	--- Newborn questions
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 44) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 44) AND mother_mpp.response = '2'::text THEN 'No'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 45) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 45) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 46) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 46) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 47) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 47) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 48) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 48) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 49) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 49) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 50) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 50) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 51) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 51) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 52) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 52) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 59) AND mother_mpp.response = '1'::text THEN 'Immediately/ less than 30 minutes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 59) AND mother_mpp.response = '2'::text THEN '30 minutes to 1 hour'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 59) AND mother_mpp.response = '3'::text THEN 'More than 1 hour'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 59) AND mother_mpp.response = '4'::text THEN 'Dont know'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 59) AND mother_mpp.response = '5'::text THEN 'Never'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 60) AND mother_mpp.response = '1'::text THEN 'Breast milk only'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 60) AND mother_mpp.response = '2'::text THEN 'Breast milk and plain water'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 60) AND mother_mpp.response = '3'::text THEN 'Breast milk and water(with salt and sugar)'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 60) AND mother_mpp.response = '4'::text THEN 'Other(solid food, dairy, other liquids)'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 61) AND mother_mpp.response = '1'::text THEN 'Breast milk only'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 61) AND mother_mpp.response = '2'::text THEN 'Breast milk and water'::text  
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 61) AND mother_mpp.response = '3'::text THEN 'Breast milk and water(with salt and sugar)'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 61) AND mother_mpp.response = '4'::text THEN 'Other(solid food, dairy, other liquids)'::text


            WHEN (mother_mpp_info_def.mother_mpp_def_id = 34) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 34) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 35) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 35) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 36) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 36) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 37) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 37) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 38) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 38) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 39) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 39) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 40) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 40) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 41) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 41) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 42) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 42) AND mother_mpp.response = '2'::text THEN 'No'::text 
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 43) AND mother_mpp.response = '1'::text THEN 'Yes'::text
            WHEN (mother_mpp_info_def.mother_mpp_def_id = 43) AND mother_mpp.response = '2'::text THEN 'No'::text
            
            ELSE 'N/A'::text
        END AS response_name,
    mother_mpp.child_no,
    mother_mpp.survey_status
   FROM mother_mpp
     JOIN mother_mpp_info_def ON mother_mpp.mother_mpp_def_id = mother_mpp_info_def.mother_mpp_def_id
     JOIN surveys ON mother_mpp.survey_id = surveys.survey_id
  ORDER BY mother_mpp.mother_mpp_id;