SELECT health_workers.health_worker_id,health_workers.worker_name,

---=============================(PART A)======================

---Total number of Households
(SELECT COUNT(household_number) FROM surveys
    WHERE surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS household_numbers,

  ---Total of new households
(SELECT COUNT(household_number) FROM surveys WHERE survey_status = 0
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS new_household_numbers,

---Total number of follow-up HH
(SELECT COUNT(household_number) FROM surveys WHERE survey_status = 4
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS followup_hh,

---Total no. of pregnant women
(SELECT  COUNT(vw_survey_mother.mother_info_def_id)FROM vw_survey_mother
    INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
    WHERE vw_survey_mother.mother_info_def_id = 1 AND vw_survey_mother.response = 1
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS total_pregnant_women,

---Total No. of women attending ANC
(SELECT  COUNT(health_worker_id) FROM  vw_survey_referrals
    INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
    WHERE vw_survey_referrals.referral_info_def_id = 1 AND vw_survey_referrals.response = '1'
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS women_attending_ANC,

---Total number attending 4 + ANC Visits
(SELECT count(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 58 AND decision_survey.response = 5
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS attending_4_plus_ANC_visits,

---Total No. of referred for ANC
(SELECT COUNT(health_worker_id) FROM  vw_survey_referrals
   INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
   WHERE  vw_survey_referrals.referral_info_def_id = 1 AND vw_surveys.health_worker_id = health_workers.health_worker_id
   AND survey_time::date  BETWEEN '2016-01-01'::date AND  NOW()::date)AS reffered_for_ANC,

---Total number of pregnant women referred to start ANC at 1 to 3 months pregnant
(SELECT COUNT(health_worker_id) FROM  vw_survey_referrals INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
   WHERE  vw_survey_referrals.referral_info_def_id = 1 AND vw_survey_referrals.response = '1'
   AND vw_surveys.health_worker_id = health_workers.health_worker_id
   AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS oneto3months_ANC,

---Total number of pregnant women referred to start ANC at  4 to 6 months pregnant
(SELECT COUNT(health_worker_id) FROM  vw_survey_referrals INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
    WHERE vw_survey_referrals.referral_info_def_id = 1 AND vw_survey_referrals.response = '2'
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS fourto6months_ANC,

---Total number of pregnant women referred to start ANC at 7 to 9 months pregnant
(SELECT COUNT(health_worker_id) FROM  vw_survey_referrals INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE vw_survey_referrals.referral_info_def_id = 1 AND vw_survey_referrals.response = '3' AND
        vw_surveys.health_worker_id = health_workers.health_worker_id
        AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS sevento9months_ANC,

---Pregnant woman counselled on Individual Birth Plan (IBP)
(SELECT COUNT(health_worker_id) FROM  vw_survey_referrals INNER JOIN vw_surveys ON vw_survey_referrals.survey_id = vw_surveys.survey_id
        WHERE vw_survey_referrals.survey_id = vw_surveys.survey_id
        AND vw_survey_referrals.referral_info_def_id = 4 AND
        vw_surveys.health_worker_id = health_workers.health_worker_id
        AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS IBP,

---No. of woman  delivered by skilled attendant
(SELECT COUNT(health_worker_id) FROM  vw_survey_mother INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE vw_survey_mother.mother_info_def_id = 4 AND vw_survey_mother.response = '1'
        AND vw_surveys.health_worker_id = health_workers.health_worker_id
        AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS skilled_attendant,

---No. of woman  delivered by unskilled attendant
(SELECT COUNT(health_worker_id) FROM vw_survey_mother INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
        WHERE  vw_survey_mother.mother_info_def_id = 3 AND vw_survey_mother.response = '1'
        AND vw_surveys.health_worker_id = health_workers.health_worker_id
        AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS unskilled_attendant,

---Total number of mothers referred for PNC
(SELECT COUNT(health_worker_id)FROM  vw_survey_100 WHERE (survey_status = '0' OR survey_status = '4') AND category = 1
    AND health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS referred_PNC,

---Total number of new mothers referred for PNC
(SELECT count(surveys.health_worker_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN surveys ON surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 54 and decision_survey.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS new_mother_referred_PNC,

---Total of new mother attending at least 2 PNC
(SELECT count(surveys.health_worker_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN surveys on surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 55 AND decision_survey.response = 4
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS new_mother_referred_2PNC,

---Total of new mother referred for postpartum family planning
(SELECT COUNT(vw_survey_100.health_worker_id)FROM  vw_survey_100
  INNER JOIN decision_survey ON decision_survey.survey_100_id = vw_survey_100.survey_100_id
  WHERE vw_survey_100.category = 1 AND decision_survey.response = 1
  AND vw_survey_100.health_worker_id = health_workers.health_worker_id
  AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS referred_2PNC_family_planning,

---No. of New-born CHVs visited at home within 48 hours of delivery
(SELECT COUNT(health_worker_id)FROM  vw_survey_mother INNER JOIN vw_surveys ON vw_survey_mother.survey_id = vw_surveys.survey_id
   WHERE vw_survey_mother.mother_info_def_id = 5 AND vw_survey_mother.response = '1'
   AND vw_surveys.health_worker_id = health_workers.health_worker_id
   AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS newborn_visited_48hrs,

---Babies breastfed within 1 hour of birth
(SELECT count(surveys.health_worker_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN surveys ON surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 59 AND decision_survey.response = 2 AND
    surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS newborn_breastfed_1hr,

---Neonates exclusively breastfeed in the 1st 28 days
(SELECT count(surveys.health_worker_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN surveys ON surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id = 60 AND decision_survey.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS newborn_breastfed_1st_28days,

---Mother with new-born counselled on Exclusive Breast Feeding (EBF
(SELECT count(survey_mother.mother_info_def_id) FROM survey_mother
    INNER JOIN surveys ON surveys.survey_id = survey_mother.survey_id
    WHERE survey_mother.mother_info_def_id = 6 AND survey_mother.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date) AS Exclusive_Breast_Feeding,

---Total number of newborn referred for low birth weight
(SELECT count(health_worker_id) FROM vw_survey_100
    WHERE referral_reason LIKE 'Growth monitoring for low birth weight%' AND
    health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date) AS low_birth_weight,

---Total No. of Referrals of newborns ( with Danger signs)
(SELECT count(health_worker_id) FROM vw_survey_100
    WHERE category= 4 AND form_serial LIKE 'DSS%' AND
    health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date) AS newborns_with_Danger_signs,

----=====================(PART B)==================================

---Total No. of Referrals of pregnant women ( with Danger signs)
(SELECT count(health_worker_id) FROM vw_survey_100
    WHERE category= 2 AND form_serial LIKE 'DSS%' AND
    health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date) AS pregnant_with_Danger_signs,

---Total No. of Referrals of postpartum women( with Danger signs)
(SELECT count(health_worker_id) FROM vw_survey_100
    WHERE category= 1 AND form_serial LIKE 'DSS%' AND
    health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date) AS postpartaum_with_Danger_signs,

---Total  of postpartum women referred for family planning
(SELECT count(health_worker_id) FROM vw_survey_100
    WHERE referral_reason LIKE 'Postpartum family services%' AND
    health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date) AS postpartum_family_planning,

---Total number of  pregnant women identified with at least 2 danger signs
(SELECT count(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id::int BETWEEN 1::int AND 17::int
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>1
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS pregnant_2_danger_signs,

---Total number of newborn identified with at least 4 danger signs
(SELECT count(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id::int BETWEEN 44::int AND 52::int
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>4
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS newborn_4_danger_signs,

---Total number of postpartum women identified with at least 4 danger signs
(SELECT count(decision_survey.mother_info_def_id) FROM decision_survey
    INNER JOIN mother_mpp_info_def ON mother_mpp_info_def.mother_mpp_def_id = decision_survey.mother_info_def_id
    INNER JOIN vw_surveys ON vw_surveys.survey_id = decision_survey.survey_id
    WHERE decision_survey.mother_info_def_id::int BETWEEN 18::int AND 33::int
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>4
    AND vw_surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS postpartum_4_danger_signs,

---Total number of  correctly at least 2 identified danger signs among pregnant women
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.form_serial LIKE 'DSS%' AND survey_100.correct = 1
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>2
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS pregnant_2_correctly_danger_signs,

---Total no. of correctly at least 2 identified danger signs among pregnant women

---Total no. of correctly at least 4 identified danger signs among newborn
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.form_serial LIKE 'DSS%' AND survey_100.correct = 1
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>4
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS newborn_4_correctly_danger_signs,

---Total no. of correctly at least 2 identified danger signs among postpartum women
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.form_serial LIKE 'DSS%' AND survey_100.correct = 1
    AND (SELECT count(decision_survey.response) FROM decision_survey WHERE decision_survey.response=1)>2
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS postpartum_2_correctly_danger_signs,

---Referral to the 5  facilities
(SELECT count(survey_100.link_health_facility_id) FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.link_health_facility_id != 6
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS Referral_to_5_facilities,

---Total No. of effective referrals ( pregnant women -ANC)
(SELECT count(survey_100.survey_100_id) FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.category = 2 AND survey_100.form_serial LIKE 'DSSXPG%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS effective_referrals_pregnant_women_ANC,

---Total No. of effective referrals ( newborn)
(SELECT count(survey_100.survey_100_id) FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.category = 2 AND survey_100.form_serial LIKE 'DSSXAB%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS effective_referrals_newborn,

---Total No. of effective referrals ( postpartum)
(SELECT count(survey_100.survey_100_id) FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.category = 2 AND survey_100.form_serial LIKE 'DSSXPM%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS effective_referrals_postpartum,

---Total No. of tracked pregnant women
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.track_id = 1 AND survey_100.track_status LIKE 'Tracked%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS tracked_pregnant_women,

---Total No. of tracked newborn
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.track_id = 1 AND survey_100.track_status LIKE 'Tracked%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS tracked_newborn,

---Total No. of tracked postpartum
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.track_id = 1 AND survey_100.track_status LIKE 'Tracked%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS tracked_postpartum,

---Referral to the alternative  facilities
(SELECT count(survey_100.link_health_facility_id) FROM survey_100
    INNER JOIN link_health_facilities ON link_health_facilities.link_health_facility_id = survey_100.link_health_facility_id
    WHERE survey_100.link_health_facility_id = 6
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS Referral_to_alternative_facilities,

---Total No. of  pregnant women who visited the facility
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 2 AND survey_100.visit_id = 1 AND survey_100.visit_status LIKE 'Visited other health facility%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS pregnant_women_visited_facility,

---Total No. of newborn who visited the facility
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 4 AND survey_100.visit_id = 1 AND survey_100.visit_status LIKE 'Visited other health facility%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS newborn_visited_facility,

---Total No. of postpartum who visited the facility
(SELECT count(survey_100.health_worker_id) FROM survey_100
    WHERE survey_100.category = 1 AND survey_100.visit_id = 1 AND survey_100.visit_status LIKE 'Visited other health facility%'
    AND survey_100.health_worker_id = health_workers.health_worker_id
    AND referral_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS postpartum_visited_facility,

---ANC defaulter referred
(SELECT count(surveys.survey_id) FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 1 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS ANC_defaulter_referred,

---Immunization defaulter referred
(SELECT count(surveys.survey_id) FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 2 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS Immunization_defaulter_referred,

---TB treatment defaulter traced and referred
(SELECT count(surveys.survey_id) FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 3 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS TB_treatment_defaulter_traced_referred,

---ART defaulter traced and referred
(SELECT count(surveys.survey_id) FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 4 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS ART_defaulter_traced_referred,

---HIV exposed infant (HEI) defaulters traced and referred
(SELECT count(surveys.survey_id) FROM surveys
    INNER JOIN survey_defaulters ON survey_defaulters.survey_id = surveys.survey_id
    WHERE survey_defaulters.defaulters_info_def_id = 5 AND survey_defaulters.response = 1
    AND surveys.health_worker_id = health_workers.health_worker_id
    AND survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date)AS HEI_defaulters_traced_referred
    
FROM health_workers
INNER JOIN surveys ON surveys.health_worker_id = health_workers.health_worker_id
WHERE survey_time::date BETWEEN '2016-01-01'::date AND  NOW()::date
GROUP BY health_workers.health_worker_id,health_workers.worker_name
ORDER BY health_workers.health_worker_id ASC