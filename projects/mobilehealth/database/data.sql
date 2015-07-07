-- mother information
INSERT INTO mother_info_defs( mother_info_def_id,question, details ) VALUES
(1, 'Pregnant','Record  by  Indicating  with a tick (✔) whether a household female member is  pregnant or (X) if the household female member is  not pregnant. The CHV should observe or ask the woman in the household. Record N/A if the member is not a woman of reproductive age (15-49 years)'),
(2, 'Pregnant woman counselled on Individual Birth Plan (IBP)','Record  by  Indicating  with a tick (✔) whether the pregnant woman is counselled on Individual Birth Plan (IBP) or (X) if not. Record N/A if the member is not a pregnant woman'),
(3, 'Woman delivered by unskilled attendant','Record   by marking with a tick (✔ )  if delivery since the last visit was by unskilled attendant.Note – traditional birth attendants (TBA)  are considered unskilled. Record N/A if the member is not a woman who delivered since last visit'),
(4, 'Woman  delivered by skilled attendant','Record   by marking with a tick (✔ )  if delivery since the last visit was by skilled attendant.Note – traditional birth attendants (TBA) are considered not skilled attendants. Record N/A if the member is not a woman who delivered since last visit'),
(5, 'New-born visited at home within 48 hours of delivery','Record  by  Indicating  with a tick (✔) if New-born was visited at home within 48 hours of delivery or (X) if not. Record N/A if the member is not a new-born'),
(6, 'Mother with new-born counselled on Exclusive Breast Feeding (EBF)','Record  by  Indicating  with a tick (✔) if Mother with new-born (0-28 days) is counselled on Exclusive Breast Feeding (EBF) or (X) if not. Record N/A if the household member is not a mother of a new-born'),
(7, 'Woman 15-49yrs provided with Family Planning commodities by CHVs','Record  by  Indicating  with a tick (✔) if a Woman 15-49 years is provided with Family Planning commodities by CHVs or (X) if a woman of 15-49 years was not provided. Record N/A if the member is not a woman of reproductive age (15-49 years)')
     

-- child information
INSERT INTO child_info_defs( child_info_def_id, question, details ) VALUES
(1, 'Gender', '1 male, 2 femail'),
(2, 'Child 0-59 months participating in growth monitoring','Record  by  Indicating  with a tick (✔) if a Child 0-59 months participating in growth monitoring or (X) if not. Record N/A if the household member is not a child of 0-59 months'),
(3, 'Child 6-59 months with MUAC (Red) indicating severe malnutrition','Record  by  Indicating  with a tick (✔) if a Child 6-59 months has MUAC (Red) indicating severe malnutrition or (X) if not. Record N/A if the household member is not a child of 6-59 months'),
(4, 'Child 6-59 months with MUAC (Yellow) indicating  moderate malnutrition','Record  by  Indicating  with a tick (✔) if a Child 6-59 months has MUAC (Yellow) indicating moderate malnutrition or (X) if not. Record N/A if the household member is not a child of 6-59 months'),
(5, 'Child  12-59 months dewormed','Record by marking a tick (✔ )  when the child 12-59 months  in the household was dewormed in the last 6 months or (X) if the child was not . Record N/A if the household member is not a child of 12-59 months')

INSERT INTO referral_info_defs( referral_info_def_id, question, details) VALUES
(1, 'Pregnant woman referred for ANC', 'Record by marking a tick (✔ )  when the Pregnant woman is referred for ANC or (X) if not. Record N/A if the household member is not a pregnant woman'),
(2, 'Pregnant women referred for skilled delivery','Record by marking a tick (✔ )  when the Pregnant woman is referred for skilled delivery or (X) if not. Record N/A if the household member is not a pregnant woman'),
(3, 'Woman referred for family planning services','Record by marking a tick (✔ )  when the woman of 15-49 years is referred for family planning services or (X) if not. Record N/A if the household member is not a woman of 15-49 years'),
(4, 'Home delivery referred for Post Natal Care (PNC) Services','Record by marking a tick (✔ ) if a home delivery is referred for Post Natal Care (PNC) Services or (X) if not. Record N/A if the household member is not a mother who delivered at home'),
(5, 'Child 0-11 months referred for immunization','Record by marking a tick (✔ ) if a child 0-11 months is referred for immunization services or (X) if not. Record N/A if the household member is not a child of 0-11 months'),
(6, 'Child 6-59 months referred for Vitamin A supplementation','Record by marking a tick (✔ ) if a child between 6 months of age to 59 Months is referred for Vitamin A supplementation  or (X) if not. Record N/A if the household member is not a child of 6-59 months'),
(7, 'Cough more than 2 weeks referred','Record by marking a tick (✔ ) if a chronic cough for two or more weeks is referred to a  health facility  or (X) if not. Record N/A when the household member has  not had chronic cough or had had it for less than 2 weeks'),
(8, 'Referred for HIV Counselling and Testing (HCT)','Record by marking a tick (✔ ) if  referred for HIV Counselling and Testing (HCT) or (X) if not. Record N/A for a small child'),
(9, 'Elderly (60 +) referred for routine health check-ups','Record by marking a tick (✔ ) if elderly  (60 years and above) is referred to a health facility for routine check-ups or (X) if not. Record N/A if the member is not eldery with 60 or more years'),
(10, 'A: Diabetes','Known cases of chronic illness  referred'),
(11, 'B: Cancer','Known cases of chronic illness  referred'),
(12, 'C: Mental Illness','Known cases of chronic illness  referred'),
(13, 'D: Hypertension','Known cases of chronic illness  referred'),
(14, 'E: Others (specify in remarks)','Known cases of chronic illness  referred');


-- defaulters info
INSERT INTO defaulters_info_defs( defaulters_info_def_id, question, details ) VALUES
(1, 'ANC defaulter referred', 'Record by marking a tick (✔ ) if  ANC defaulter is referred to a health facility or (X) if not. Record N/A if the member is not an ANC defaulter'),
(2, 'Immunization defaulter referred', 'Record by marking a tick (✔ ) if Child 0-59 months of age who defaulted on immunization has been referred for immunization or (X) if not. Record N/A if the member is not a child of 0-59 months or is a child of 0-59 months but did not default on immunization'),
(3, 'TB treatment defaulter traced and referred', 'Record by marking a tick (✔ ) if a Tuberculosis (TB) defaulter is referred to a health facility or (X) if not. Record N/A if the member has not had TB or has had TB but did not default'),
(4, 'ART defaulter referred', 'Record by marking a tick (✔ ) if an ART defaulter is referred to a health facility or (X) if not. Record N/A if the member has not been on ART or has been on ART but has not defaulted');



INSERT INTO death_info_defs(death_info_def_id, question, details)VALUES 
(1, 'A: 0-28 days', '(Record all deaths between zero to 28 days of age) which occurred in the month'),
(2, 'b: 29 days-11 months', '(Record all deaths between 29 days to 11 months of age) which occurred in the month'),
(3, 'c: 12-59 months', '(Record all deaths between 12-59 months of age) which occurred in the month'),
(4, 'd: Maternal', '(Record all deaths of women during pregnancy or child birth or within 42 days after delivery) which occurred in the month'),
(5, 'e: Other deaths', '(Record all deaths in the household and not counted above) which occurred in the month');






-- household info
INSERT INTO household_info_defs( household_info_def_id, question, details ) VALUES
(1, 'Household  has a  functional latrine in use','Observe and record with a tick (✔)  if the household  has a functional latrine in use or (X) if the household does not have a functional  latrine in use. This also includes all types of toilets and whether they are functional or not'),
(2, 'Household with hand washing facilities','Observe and record with a tick (✔)  if the  household has hand  washing  facilities (e.g.  hand wash basin, tippy tap, leaky  tin) or (X) if the  household does not have hand  washing  facilities'),
(3, 'Household  using treated water', 'Ask and record with a tick (✔) if the household is always using treated　water　for　drinking  or (X) if the household is not always using treated   water for drinking')



