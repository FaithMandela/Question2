---Total number of Households
SELECT 1 as m_order,'Total number of Households'AS Indicator,
    COUNT(household_number) AS Number_of_Indicator
        FROM vw_surveys
            WHERE
    vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
                 AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---Total of new households
SELECT 2 as m_order,'        Total of new households'AS Indicator,
    COUNT(household_number) AS Number_of_Indicator
        FROM vw_surveys
            WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_surveys.survey_status = 0
                 AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Total number of follow-up HH
SELECT 3 as m_order,'        Total number of follow-up HH'AS Indicator,
    COUNT(household_number) AS Number_of_Indicator
        FROM vw_surveys
            WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_surveys.survey_status = 4
                 AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

union
------------------MNCH Indicator-----------------------------------------------------
---Total no. of pregnant women
SELECT 4 as m_order,'Total no. of pregnant women'AS Indicator,
    COUNT(vw_survey_mother.mother_info_def_id) AS Number_of_Indicator
        FROM vw_survey_mother
        INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
            WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_mother.mother_info_def_id = 1
         AND vw_survey_mother.response = 1
                 AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Total No. of women attending ANC
SELECT 5 as m_order,'Total No. of women attending ANC'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_survey_referrals
        INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
            WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 1
         AND vw_survey_referrals.response = '1'
                 AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


-----Total No. of women attending ANC
UNION
-----1. None
    SELECT 6 as m_order,'Total No. of women attending ANC:- (i). None'AS Indicator,
        COUNT(vw_surveys.health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
        INNER JOIN decision_survey ON decision_survey.survey_id = vw_surveys.survey_id
            WHERE
            vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
             AND decision_survey.response = 1
             AND decision_survey.mother_info_def_id = 58
            AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----2. 1 visit
    SELECT 7 as m_order,'          (ii). 1 visit'AS Indicator,
        COUNT(vw_surveys.health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
        INNER JOIN decision_survey ON decision_survey.survey_id = vw_surveys.survey_id
            WHERE
             vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
             AND decision_survey.response = 2
             AND decision_survey.mother_info_def_id = 58
             AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----3. 2 visits
    SELECT 8 as m_order,'          (iii). 2 visits'AS Indicator,
        COUNT(vw_surveys.health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
        INNER JOIN decision_survey ON decision_survey.survey_id = vw_surveys.survey_id
            WHERE
             vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
             AND decision_survey.response = 3
             AND decision_survey.mother_info_def_id = 58
             AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----4. 3 visits
    SELECT 9 as m_order,'          (iv). 3 visits'AS Indicator,
        COUNT(vw_surveys.health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
        INNER JOIN decision_survey ON decision_survey.survey_id = vw_surveys.survey_id
            WHERE
             vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
             AND decision_survey.response = 4
             AND decision_survey.mother_info_def_id = 58
             AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----5. 4+
    SELECT 10 as m_order,'          (v). 4+'AS Indicator,
        COUNT(vw_surveys.health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
        INNER JOIN decision_survey ON decision_survey.survey_id = vw_surveys.survey_id
            WHERE
             vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
             AND decision_survey.response = 5
             AND decision_survey.mother_info_def_id = 58
             AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Total number of pregnant women referred to start ANC at
--SELECT 11 as m_order,'Total number of pregnant women referred to start ANC at'AS Indicator,
    --COUNT(health_worker_id) AS Number_of_Indicator
        --FROM  vw_survey_100
        --INNER JOIN decision_survey ON vw_survey_100.dss_id = decision_survey.dss_id
            --WHERE
             --vw_survey_100.health_worker_id = '$P!{health_worker_id}'
             --AND vw_survey_100.village_id = '$P!{village_id}'
             --AND vw_survey_100.referral_reason LIKE 'To start ANC%'
             --AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

--UNION
---1 to 3 months pregnant
SELECT 11 as m_order,'Total number of pregnant women referred to start ANC at 1 to 3 months pregnant'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_survey_100
        INNER JOIN decision_survey ON vw_survey_100.dss_id = decision_survey.dss_id
            WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
             AND decision_survey.response = 1
         AND vw_survey_100.referral_reason LIKE 'To start ANC%'
                 AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---4 to 6 months pregnant
SELECT 12 as m_order,'          4 to 6 months pregnant'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_survey_100
        INNER JOIN decision_survey ON vw_survey_100.dss_id = decision_survey.dss_id
            WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
             AND decision_survey.response = 2
         AND vw_survey_100.referral_reason LIKE 'To start ANC%'
                 AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---7 to 9 months pregnant
SELECT 13 as m_order,'          7 to 9 months pregnant'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_survey_100
    INNER JOIN decision_survey ON vw_survey_100.dss_id = decision_survey.dss_id
            WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
             AND decision_survey.response = 3
         AND vw_survey_100.referral_reason LIKE 'To start ANC%'
                 AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Total NO. of NEW mothers reffered for PNC
SELECT 14 as m_order,'Total NO. of NEW mothers reffered for PNC'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
    INNER JOIN vw_dss ON vw_dss.survey_id = vw_surveys.survey_id
            WHERE
        vw_surveys.health_worker_id = '$P!{health_worker_id}'
        AND vw_surveys.village_id = '$P!{village_id}'
        AND vw_dss.mother_mpp_def_id = 54
        AND vw_dss.response = 1
                AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Total of new mother attending PNC
--SELECT 15 as m_order,'Total Total of new mother attending PNC'AS Indicator,
    --COUNT(health_worker_id) AS Number_of_Indicator
        --FROM  vw_surveys
    --INNER JOIN vw_dss ON vw_dss.survey_id = vw_surveys.survey_id
            --WHERE
        --vw_surveys.health_worker_id = '$P!{health_worker_id}'
        --AND vw_surveys.village_id = '$P!{village_id}'
        --AND vw_dss.mother_mpp_def_id = 55
                --AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

--UNION
---None
SELECT 15 as m_order,'Total Total of new mother attending PNC. None'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
    INNER JOIN vw_dss ON vw_dss.survey_id = vw_surveys.survey_id
    INNER JOIN decision_survey ON vw_surveys.survey_id = decision_survey.survey_id
            WHERE
        vw_surveys.health_worker_id = '$P!{health_worker_id}'
        AND vw_surveys.village_id = '$P!{village_id}'
        AND vw_dss.mother_mpp_def_id = 55
        AND decision_survey.response = 1
                AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---1 Visit
SELECT 16 as m_order,'          1 Visit'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
    INNER JOIN vw_dss ON vw_dss.survey_id = vw_surveys.survey_id
    INNER JOIN decision_survey ON vw_surveys.survey_id = decision_survey.survey_id
            WHERE
        vw_surveys.health_worker_id = '$P!{health_worker_id}'
        AND vw_surveys.village_id = '$P!{village_id}'
        AND vw_dss.mother_mpp_def_id = 55
        AND decision_survey.response = 2
                AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
----2 Visits
SELECT 17 as m_order,'          2 Visits'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
    INNER JOIN vw_dss ON vw_dss.survey_id = vw_surveys.survey_id
    INNER JOIN decision_survey ON vw_surveys.survey_id = decision_survey.survey_id
            WHERE
        vw_surveys.health_worker_id = '$P!{health_worker_id}'
        AND vw_surveys.village_id = '$P!{village_id}'
        AND vw_dss.mother_mpp_def_id = 55
        AND decision_survey.response = 3
                AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---More than 2 visits
SELECT 18 as m_order,'          More than 2 visits'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
        FROM  vw_surveys
    INNER JOIN vw_dss ON vw_dss.survey_id = vw_surveys.survey_id
    INNER JOIN decision_survey ON vw_surveys.survey_id = decision_survey.survey_id
            WHERE
        vw_surveys.health_worker_id = '$P!{health_worker_id}'
        AND vw_surveys.village_id = '$P!{village_id}'
        AND vw_dss.mother_mpp_def_id = 55
        AND decision_survey.response = 4
                AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
---Pregnant woman counselled on Individual Birth Plan (IBP)
SELECT 19 as m_order,'Pregnant woman counselled on Individual Birth Plan (IBP)'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_mother
    INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_mother.mother_info_def_id = 2
         AND vw_survey_mother.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---No. of woman  delivered by skilled attendant
SELECT 20 as m_order,'No. of woman  delivered by skilled attendant'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_mother
    INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_mother.mother_info_def_id = 4
         AND vw_survey_mother.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---No. of woman  delivered by unskilled attendant
SELECT 21 as m_order,'No. of woman  delivered by unskilled attendant'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_mother
    INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_mother.mother_info_def_id = 3
         AND vw_survey_mother.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---No. of New-born CHVs visited at home within 48 hours of delivery
SELECT 22 as m_order,'No. of New-born CHVs visited at home within 48 hours of delivery'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_mother
    INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_mother.mother_info_def_id = 5
         AND vw_survey_mother.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---Mother with new-born counselled on Exclusive Breast Feeding (EBF)
SELECT 23 as m_order,'Mother with new-born counselled on Exclusive Breast Feeding (EBF)'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_mother
    INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_mother.mother_info_def_id = 6
         AND vw_survey_mother.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Neonates exclusively breastfed in the first 28 days
SELECT 24 as m_order,'Neonates exclusively breastfed in the first 28 days'AS Indicator,
    count(surveys.health_worker_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN surveys ON surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 60 
     AND decision_survey.response = 1
         AND surveys.health_worker_id = '$P!{health_worker_id}'
         AND surveys.village_id = '$P!{village_id}'        
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Babies breastfed within 1 hour of birth
SELECT 25 as m_order,'Babies breastfed within 1 hour of birth'AS Indicator,
    count(surveys.health_worker_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN surveys ON surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 59 
     AND decision_survey.response = 2 
         AND surveys.health_worker_id = '$P!{health_worker_id}'
         AND surveys.village_id = '$P!{village_id}'        
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


--------------------------Referral Indicators----------------------
UNION
---Total No. of Referrals
SELECT 26 as m_order,'Total No. of Referrals'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         health_worker_id = '$P!{health_worker_id}'
         AND village_id = '$P!{village_id}'
         AND (survey_status = '0' OR survey_status = '4')
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
--Pregnant women
SELECT 27 as m_order,'       Pregnant women'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         health_worker_id = '$P!{health_worker_id}'
         AND village_id = '$P!{village_id}'
         AND (survey_status = '0' OR survey_status = '4')
         AND category = 2
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
----Newborns
SELECT 28 as m_order,'       Newborns'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         health_worker_id = '$P!{health_worker_id}'
         AND village_id = '$P!{village_id}'
         AND (survey_status = '0' OR survey_status = '4')
         AND category = 4
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
----Postpartum
SELECT 29 as m_order,'       Postpartum'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         health_worker_id = '$P!{health_worker_id}'
         AND village_id = '$P!{village_id}'
         AND (survey_status = '0' OR survey_status = '4')
         AND category = 1
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
----Home delivery referred for Post Natal Care (PNC) Services
SELECT 30 as m_order,'       Home delivery referred for Post Natal Care (PNC) Services'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 4
         AND vw_survey_referrals.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
----Children < 5years
SELECT 31 as m_order,'       Children < 5years'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND (vw_survey_referrals.referral_info_def_id = 5 OR vw_survey_referrals.referral_info_def_id = 6)
         AND vw_survey_referrals.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
----Total no. of children 0 – 11 Months referred for immunization
SELECT 32 as m_order,'       Total no. of children 0 – 11 Months referred for immunization'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 5
         AND vw_survey_referrals.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

 UNION
---Referral per service
-----1. ANC _______________
SELECT 33 as m_order,'Referral per service:- 1. ANC'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 1
         AND vw_survey_referrals.response = '1'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---------To start ANC
SELECT 34 as m_order,'                              (i). To start ANC'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 1
         AND vw_survey_referrals.response = '1'
         AND vw_surveys.survey_status = 0
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
---------Not 1st ANC
SELECT 35 as m_order,'                             (ii). Not 1st ANC'AS Indicator,
    COUNT(health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 1
         AND vw_survey_referrals.response = '1'
         AND vw_surveys.survey_status = 4
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----2. Delivery
SELECT 36 as m_order,'                   2. Delivery'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 2
         AND decision_survey.response = 3
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----3. Postpartum family planning
SELECT 37 as m_order,'                   3. Postpartum family planning'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 1
         AND decision_survey.response = 1
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----4. Other postpartum services
SELECT 38 as m_order,'                   4. Other postpartum services'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 1
         AND decision_survey.response = 2
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----5. Growth monitoring for low birth weigh
SELECT 39 as m_order,'                   5. Growth monitoring for low birth weigh'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 4
         AND decision_survey.response = 1
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----6. Immunization
SELECT 40 as m_order,'                   6. Immunization'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 4
         AND decision_survey.response = 3
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----7. Family planning
SELECT 41 as m_order,'                   7. Family planning'AS Indicator,
    COUNT(vw_surveys.health_worker_id) AS Number_of_Indicator
    FROM  vw_surveys
    INNER JOIN vw_survey_referrals ON vw_survey_referrals.survey_id = vw_surveys.survey_id
    INNER JOIN decision_survey ON decision_survey.survey_id = vw_surveys.survey_id
        WHERE
         vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND vw_survey_referrals.referral_info_def_id = 3
         AND vw_survey_referrals.response = '1'
         AND decision_survey.response = 1
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----8. Growth monitoring
SELECT 42 as m_order,'                   8. Growth monitoring'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 4
         AND decision_survey.response = 2
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----9. General services
SELECT 43 as m_order,'                   9. General services'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
    INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
---Total No. of Referrals ( with Danger signs)
SELECT 44 as m_order,'Total No. of Referrals ( with Danger signs)'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----Pregnant women
SELECT 45 as m_order,'      Pregnant women 'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND category = 2
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----Newborns
SELECT 46 as m_order,'      Newborns'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND category = 4
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----Postpartum
SELECT 47 as m_order,'      Postpartum'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND category = 1
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
---Number of identified danger signs among
--SELECT 48 as m_order,'Number of identified danger signs among'AS Indicator,
    --COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    --FROM  vw_survey_100
        --WHERE
         --vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         --AND vw_survey_100.village_id = '$P!{village_id}'
         --AND form_serial LIKE 'DSS%'
         --AND form_serial LIKE 'DSSX%'
         --AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


--UNION
-----Pregnant women at least 2
SELECT 48 as m_order,'Number of identified danger signs among. Pregnant women at least 2'AS Indicator,
    COUNT(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id::int BETWEEN 1::int AND 17::int
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>1
     AND vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

UNION
-----Newborns   at least 4
SELECT 49 as m_order,'                Newborns   at least 4'AS Indicator,
    COUNT(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id::int BETWEEN 44::int AND 52::int
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>4
     AND vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
-----Postpartum at least 2
SELECT 50 as m_order,'                Postpartum at least 2'AS Indicator,
    COUNT(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id::int BETWEEN 18::int AND 33::int
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>2
    AND vw_surveys.health_worker_id = '$P!{health_worker_id}'
         AND vw_surveys.village_id = '$P!{village_id}'
         AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
         
UNION
---Number of correctly identified danger signs among
-----Pregnant women  at least 2
SELECT 51 as m_order,'Number of correctly identified danger signs among. Pregnant women at least 2'AS Indicator,
    COUNT(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.form_serial LIKE 'DSS%' AND survey_100.correct = 1
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>2
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION

-----Newborns  at least 4
SELECT 52 as m_order,'                Newborns   at least 4'AS Indicator,
    COUNT(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.form_serial LIKE 'DSS%' AND survey_100.correct = 1
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>4
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
-----Postpartum at least 2
SELECT 53 as m_order,'                Postpartum at least 2'AS Indicator,
    COUNT(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.form_serial LIKE 'DSS%' AND survey_100.correct = 1
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>2
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date



UNION
---Total No. of effective referrals _____________
SELECT 54 as m_order,'Total No. of effective referrals'AS Indicator,
    COUNT(survey_100_id) AS Number_of_Indicator
    FROM  survey_100
        WHERE survey_status = 1
         AND health_worker_id = '$P!{health_worker_id}'
         AND village_id = '$P!{village_id}'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
-----Stand-alone 100 ______________
SELECT 55 as m_order,'     Stand-alone 100'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND form_serial NOT LIKE 'DSS%'
         AND form_serial NOT LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
-----Pregnant women accessing ANC
SELECT 56 as m_order,'                Pregnant women accessing ANC'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 2
         AND form_serial NOT LIKE 'DSS%'
         AND form_serial NOT LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
-----Postpartum women accessing PNC
SELECT 57 as m_order,'                Postpartum women accessing PNC'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 1
         AND form_serial NOT LIKE 'DSS%'
         AND form_serial NOT LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
-----Newborn accessing services
SELECT 58 as m_order,'                Newborn accessing services'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 4
         AND form_serial NOT LIKE 'DSS%'
         AND form_serial NOT LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
----MoH 100/514 & DSS
SELECT 59 as m_order,'     MoH 100/514 & DSS'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
----Pregnant women accessing ANC
SELECT 60 as m_order,'                Pregnant women accessing ANC'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 2
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
----Postpartum women accessing PNC
SELECT 61 as m_order,'                Postpartum women accessing PNC'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 2
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date


UNION
----Newborn accessing services
SELECT 62 as m_order,'                Newborn accessing services'AS Indicator,
    COUNT(vw_survey_100.health_worker_id) AS Number_of_Indicator
    FROM  vw_survey_100
        WHERE
         vw_survey_100.health_worker_id = '$P!{health_worker_id}'
         AND vw_survey_100.village_id = '$P!{village_id}'
         AND vw_survey_100.category = 4
         AND form_serial LIKE 'DSS%'
         AND form_serial LIKE 'DSSX%'
         AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date

----==== followups---==
UNION
-----To the selected 5 facilities
SELECT 63 as m_order,'followups. To the selected 5 facilities'AS Indicator,
    count(survey_100.link_health_facility_id)AS Number_of_Indicator FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.link_health_facility_id != 6
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION

--Total No. of tracked
--Pregnant women
SELECT 64 as m_order,'Total No. of tracked. Pregnant women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.track_id = 1 AND survey_100.track_status LIKE 'Tracked%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date 
    
UNION
--Post partum women
SELECT 65 as m_order,'                Post partum women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.track_id = 1 AND survey_100.track_status LIKE 'Tracked%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date 
    
UNION
--Newborn
SELECT 66 as m_order,'                Newborn'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.track_id = 1 AND survey_100.track_status LIKE 'Tracked%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Total No. not tracked
--Pregnant women
SELECT 67 as m_order,'Total No. not tracked.  Pregnant women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.track_id = 0 AND survey_100.track_status LIKE 'Not tracked%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date 
    
UNION
--Post partum women
SELECT 68 as m_order,'               Post partum women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.track_id = 0 AND survey_100.track_status LIKE 'Not tracked%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Newborn
SELECT 69 as m_order,'                Newborn'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.track_id = 0 AND survey_100.track_status LIKE 'Not tracked%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--To the alternative facility
SELECT 70 as m_order,'To the alternative facility'AS Indicator,
    count(survey_100.link_health_facility_id)AS Number_of_Indicator FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.link_health_facility_id = 6
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Total of those who visited the referral facility
--Pregnant women ______
SELECT 71 as m_order,'Total of those who visited the referral facility. Pregnant women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.visit_id = 1 AND survey_100.visit_status LIKE 'Visited other health facility%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Post partum women _____
SELECT 72 as m_order,'                Post partum women'AS Indicator,
   count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.visit_id = 1 AND survey_100.visit_status LIKE 'Visited other health facility%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Newborn _______
SELECT 73 as m_order,'                Newborn'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.visit_id = 1 AND survey_100.visit_status LIKE 'Visited other health facility%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Total of those who did not reach the referral facility
--Pregnant women _________
SELECT 74 as m_order,'Total of those who did not reach the referral facility. Pregnant women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.visit_id = 0 AND survey_100.visit_status LIKE 'Did not visit other health facility%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Post partum women _____
SELECT 75 as m_order,'                Post partum women'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.visit_id = 0 AND survey_100.visit_status LIKE 'Did not visit other health facility%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Newborn _____________
SELECT 76 as m_order,'                Newborn'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.visit_id = 0 AND survey_100.visit_status LIKE 'Did not visit other health facility%'
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Referral facilities
--No. referred to Bahati
SELECT 77 as m_order,'Referral facilities. No. referred to Bahati'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.link_health_facility_id = 2
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--No. referred to Biafra Lions
SELECT 78 as m_order,'                No. referred to Biafra Lions'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.link_health_facility_id = 8 
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--No. referred to Easteleigh H/centre
SELECT 79 as m_order,'                No. referred to Easteleigh H/centre'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.link_health_facility_id = 7
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--No. referred to IOM
SELECT 80 as m_order,'                No. referred to IOM'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.link_health_facility_id = 3 
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--No. referred to Pumwani Majengo
SELECT 81 as m_order,'                No. referred to Pumwani Majengo'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.link_health_facility_id = 4
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--No. to alternative facility
SELECT 82 as m_order,'                No. to alternative facility'AS Indicator,
    count(survey_100.health_worker_id)AS Number_of_Indicator FROM survey_100
    WHERE survey_100.link_health_facility_id = 6 
    AND survey_100.health_worker_id = '$P!{health_worker_id}'
    AND survey_100.village_id = '$P!{village_id}'
    AND referral_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
---Total No. of reported deaths ________
SELECT 83 as m_order,'Total No. of reported deaths'AS Indicator,
   SUM(COALESCE((survey_death.response)::int))AS Number_of_Indicator
    FROM survey_death
    INNER JOIN surveys ON surveys.survey_id = survey_death.survey_id
    WHERE surveys.survey_id = survey_death.survey_id
    AND survey_death.death_info_def_id != 5 
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
---0 – 28 days ______________
SELECT 84 as m_order,'                0 – 28 days'AS Indicator,
    SUM(COALESCE((survey_death.response)::int))AS Number_of_Indicator
    FROM survey_death
    INNER JOIN surveys ON surveys.survey_id = survey_death.survey_id
    WHERE surveys.survey_id = survey_death.survey_id
    AND survey_death.death_info_def_id = 1  
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
---29 days to 11 months _____________
SELECT 85 as m_order,'                29 days to 11 months'AS Indicator,
    SUM(COALESCE((survey_death.response)::int))AS Number_of_Indicator
    FROM survey_death
    INNER JOIN surveys ON surveys.survey_id = survey_death.survey_id
    WHERE surveys.survey_id = survey_death.survey_id
    AND survey_death.death_info_def_id = 2  
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
---12months to 59 months
SELECT 86 as m_order,'                12months to 59 months'AS Indicator,
    SUM(COALESCE((survey_death.response)::int))AS Number_of_Indicator
    FROM survey_death
    INNER JOIN surveys ON surveys.survey_id = survey_death.survey_id
    WHERE surveys.survey_id = survey_death.survey_id
    AND survey_death.death_info_def_id = 3
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
---Maternal deaths _______________
SELECT 87 as m_order,'                Maternal deaths'AS Indicator,
    SUM(COALESCE((survey_death.response)::int))AS Number_of_Indicator
    FROM survey_death
    INNER JOIN surveys ON surveys.survey_id = survey_death.survey_id
    WHERE surveys.survey_id = survey_death.survey_id
    AND survey_death.death_info_def_id = 4
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
---Others deaths
SELECT 88 as m_order,'                Others deaths'AS Indicator,
   COUNT(survey_death.survey_death_id) AS Number_of_Indicator
    FROM survey_death
    INNER JOIN surveys ON surveys.survey_id = survey_death.survey_id
    WHERE surveys.survey_id = survey_death.survey_id
    AND survey_death.death_info_def_id = 5
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = 35
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION

--Defaulter Information
--ANC defaulter referred
SELECT 89 as m_order,'Defaulter Information.  ANC defaulter referred'AS Indicator,
    count(surveys.survey_id) FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 1 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--Immunization defaulter referred
SELECT 90 as m_order,'               Immunization defaulter referred'AS Indicator,
    count(surveys.survey_id) AS Number_of_Indicator FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 2 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--TB treatment defaulter traced and referred
SELECT 91 as m_order,'                TB treatment defaulter traced and referred'AS Indicator,
   count(surveys.survey_id) AS Number_of_Indicator FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 3 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    
UNION
--ART defaulter traced and referred
SELECT 92 as m_order,'                ART defaulter traced and referred'AS Indicator,
    count(surveys.survey_id) AS Number_of_Indicator FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 4 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
UNION
--HIV exposed infant (HEI) defaulters traced and referred
SELECT 93 as m_order,'               HIV exposed infant (HEI) defaulters traced and referred'AS Indicator,
   count(surveys.survey_id) AS Number_of_Indicator FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 5 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = '$P!{health_worker_id}'
    AND surveys.village_id = '$P!{village_id}'
    AND survey_time::date  BETWEEN '$P!{start_date}'::date AND  '$P!{end_date}'::date
    

ORDER BY m_order ASC