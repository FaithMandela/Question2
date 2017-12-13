

INSERT INTO degrees(degreeid, degreelevelid, degreename)
VALUES ('PMED', 'UND', 'Pre-medicine');

UPDATE studentmajors SET majorid = 'PRMD' WHERE majorid = 'pred';
UPDATE qmcharges SET majorid = 'PRMD' WHERE majorid = 'pred';
UPDATE qmchargedefinations SET majorid = 'PRMD' WHERE majorid = 'pred';
DELETE FROM majorcontents WHERE majorid = 'pred';
DELETE FROM majors WHERE majorid = 'pred';
UPDATE majorcontents SET contenttypeid = 1 WHERE majorid = 'PRMD' AND contenttypeid is null;

UPDATE qstudents SET finaceapproval = false, financeclosed = false, closed = false, approved = false
WHERE quarterid IN ('2017/2018.1', '2017/2018.1M') AND
studentdegreeid IN (SELECT studentdegreeid FROM studentdegrees WHERE studentid IN
('79161', '79164', '79274', '79447', '79527', '79626', '79628', '79631', '79637', '79647', '79779', '79816', '79913', '79973', '79979', '79980', '80123', '80130', '80151', '80189', '80221', '80248', '80254', '80319', '80349', '80449', '80456', '80467', '80474', '80589', '80675', '80690', '80708', '80808', '80839', '80924', '80983', '81008', '81036', '81091', '81209', '81314', '81405', '81444', '81608', '81750', '81938', '81979', '82164', '82213', '82304', '82405', '82469', '82648', '82743', '82864', '83396', '83791', '83850', '84253', '84330', '84556', '84749', '84824', '84860', '85109', '85266', '85542', '85554', '85979', '86682', '16/0042', '16/0488', '16/0549', '16/0954', '16/0975', '16/1415', '16/1436', '16/1810', 'PR/16/0010', 'PR/16/0014', 'PR/16/0038', 'PR/16/0046', 'PR/16/0062', 'PR/16/0071'));

UPDATE studentdegrees SET degreeid = 'PMED', sublevelid = 'UGPM'
WHERE studentdegreeid IN
(SELECT studentdegreeid FROM studentdegrees WHERE studentid IN
('79161', '79164', '79274', '79447', '79527', '79626', '79628', '79631', '79637', '79647', '79779', '79816', '79913', '79973', '79979', '79980', '80123', '80130', '80151', '80189', '80221', '80248', '80254', '80319', '80349', '80449', '80456', '80467', '80474', '80589', '80675', '80690', '80708', '80808', '80839', '80924', '80983', '81008', '81036', '81091', '81209', '81314', '81405', '81444', '81608', '81750', '81938', '81979', '82164', '82213', '82304', '82405', '82469', '82648', '82743', '82864', '83396', '83791', '83850', '84253', '84330', '84556', '84749', '84824', '84860', '85109', '85266', '85542', '85554', '85979', '86682', '16/0042', '16/0488', '16/0549', '16/0954', '16/0975', '16/1415', '16/1436', '16/1810', 'PR/16/0010', 'PR/16/0014', 'PR/16/0038', 'PR/16/0046', 'PR/16/0062', 'PR/16/0071'));

UPDATE studentmajors SET majorid = 'PRMD'
WHERE studentdegreeid IN
(SELECT studentdegreeid FROM studentdegrees WHERE studentid IN
('79161', '79164', '79274', '79447', '79527', '79626', '79628', '79631', '79637', '79647', '79779', '79816', '79913', '79973', '79979', '79980', '80123', '80130', '80151', '80189', '80221', '80248', '80254', '80319', '80349', '80449', '80456', '80467', '80474', '80589', '80675', '80690', '80708', '80808', '80839', '80924', '80983', '81008', '81036', '81091', '81209', '81314', '81405', '81444', '81608', '81750', '81938', '81979', '82164', '82213', '82304', '82405', '82469', '82648', '82743', '82864', '83396', '83791', '83850', '84253', '84330', '84556', '84749', '84824', '84860', '85109', '85266', '85542', '85554', '85979', '86682', '16/0042', '16/0488', '16/0549', '16/0954', '16/0975', '16/1415', '16/1436', '16/1810', 'PR/16/0010', 'PR/16/0014', 'PR/16/0038', 'PR/16/0046', 'PR/16/0062', 'PR/16/0071'));


UPDATE studentpayments SET qstudentid = 287665 WHERE qstudentid = 285271;
UPDATE studentpayments SET qstudentid = 287687 WHERE qstudentid = 283418;
UPDATE studentpayments SET qstudentid = 287237 WHERE qstudentid = 285177;
UPDATE studentpayments SET qstudentid = 287947 WHERE qstudentid = 287064;
UPDATE studentpayments SET qstudentid = 287676 WHERE qstudentid = 287126;
UPDATE studentpayments SET qstudentid = 288150 WHERE qstudentid = 287047;
UPDATE studentpayments SET qstudentid = 287842 WHERE qstudentid = 287228;
UPDATE studentpayments SET qstudentid = 288011 WHERE qstudentid = 287219;
UPDATE studentpayments SET qstudentid = 288451 WHERE qstudentid = 287018;
UPDATE studentpayments SET qstudentid = 286912 WHERE qstudentid = 287606;
UPDATE studentpayments SET qstudentid = 288460 WHERE qstudentid = 287607;
UPDATE studentpayments SET qstudentid = 288500 WHERE qstudentid = 287166;
UPDATE studentpayments SET qstudentid = 287999 WHERE qstudentid = 287052;
UPDATE studentpayments SET qstudentid = 288867 WHERE qstudentid = 286674;
UPDATE studentpayments SET qstudentid = 287928 WHERE qstudentid = 287619;
UPDATE studentpayments SET qstudentid = 288545 WHERE qstudentid = 287050;
UPDATE studentpayments SET qstudentid = 288181 WHERE qstudentid = 287019;

UPDATE qgrades SET qstudentid = 287665 WHERE qstudentid = 285271;
UPDATE qgrades SET qstudentid = 287687 WHERE qstudentid = 283418;
UPDATE qgrades SET qstudentid = 287237 WHERE qstudentid = 285177;
UPDATE qgrades SET qstudentid = 287947 WHERE qstudentid = 287064;
UPDATE qgrades SET qstudentid = 287676 WHERE qstudentid = 287126;
UPDATE qgrades SET qstudentid = 288150 WHERE qstudentid = 287047;
UPDATE qgrades SET qstudentid = 287842 WHERE qstudentid = 287228;
UPDATE qgrades SET qstudentid = 288011 WHERE qstudentid = 287219;
UPDATE qgrades SET qstudentid = 288451 WHERE qstudentid = 287018;
UPDATE qgrades SET qstudentid = 286912 WHERE qstudentid = 287606;
UPDATE qgrades SET qstudentid = 288460 WHERE qstudentid = 287607;
UPDATE qgrades SET qstudentid = 288500 WHERE qstudentid = 287166;
UPDATE qgrades SET qstudentid = 287999 WHERE qstudentid = 287052;
UPDATE qgrades SET qstudentid = 288867 WHERE qstudentid = 286674;
UPDATE qgrades SET qstudentid = 287928 WHERE qstudentid = 287619;
UPDATE qgrades SET qstudentid = 288545 WHERE qstudentid = 287050;
UPDATE qgrades SET qstudentid = 288181 WHERE qstudentid = 287019;

UPDATE approvallist SET qstudentid = 287665 WHERE qstudentid = 285271;
UPDATE approvallist SET qstudentid = 287687 WHERE qstudentid = 283418;
UPDATE approvallist SET qstudentid = 287237 WHERE qstudentid = 285177;
UPDATE approvallist SET qstudentid = 287947 WHERE qstudentid = 287064;
UPDATE approvallist SET qstudentid = 287676 WHERE qstudentid = 287126;
UPDATE approvallist SET qstudentid = 288150 WHERE qstudentid = 287047;
UPDATE approvallist SET qstudentid = 287842 WHERE qstudentid = 287228;
UPDATE approvallist SET qstudentid = 288011 WHERE qstudentid = 287219;
UPDATE approvallist SET qstudentid = 288451 WHERE qstudentid = 287018;
UPDATE approvallist SET qstudentid = 286912 WHERE qstudentid = 287606;
UPDATE approvallist SET qstudentid = 288460 WHERE qstudentid = 287607;
UPDATE approvallist SET qstudentid = 288500 WHERE qstudentid = 287166;
UPDATE approvallist SET qstudentid = 287999 WHERE qstudentid = 287052;
UPDATE approvallist SET qstudentid = 288867 WHERE qstudentid = 286674;
UPDATE approvallist SET qstudentid = 287928 WHERE qstudentid = 287619;
UPDATE approvallist SET qstudentid = 288545 WHERE qstudentid = 287050;
UPDATE approvallist SET qstudentid = 288181 WHERE qstudentid = 287019;

UPDATE qposting_logs SET qstudentid = 287665 WHERE qstudentid = 285271;
UPDATE qposting_logs SET qstudentid = 287687 WHERE qstudentid = 283418;
UPDATE qposting_logs SET qstudentid = 287237 WHERE qstudentid = 285177;
UPDATE qposting_logs SET qstudentid = 287947 WHERE qstudentid = 287064;
UPDATE qposting_logs SET qstudentid = 287676 WHERE qstudentid = 287126;
UPDATE qposting_logs SET qstudentid = 288150 WHERE qstudentid = 287047;
UPDATE qposting_logs SET qstudentid = 287842 WHERE qstudentid = 287228;
UPDATE qposting_logs SET qstudentid = 288011 WHERE qstudentid = 287219;
UPDATE qposting_logs SET qstudentid = 288451 WHERE qstudentid = 287018;
UPDATE qposting_logs SET qstudentid = 286912 WHERE qstudentid = 287606;
UPDATE qposting_logs SET qstudentid = 288460 WHERE qstudentid = 287607;
UPDATE qposting_logs SET qstudentid = 288500 WHERE qstudentid = 287166;
UPDATE qposting_logs SET qstudentid = 287999 WHERE qstudentid = 287052;
UPDATE qposting_logs SET qstudentid = 288867 WHERE qstudentid = 286674;
UPDATE qposting_logs SET qstudentid = 287928 WHERE qstudentid = 287619;
UPDATE qposting_logs SET qstudentid = 288545 WHERE qstudentid = 287050;
UPDATE qposting_logs SET qstudentid = 288181 WHERE qstudentid = 287019;


DELETE FROM qstudents WHERE qstudentid IN
(SELECT ab.qstudentid
FROM
(SELECT qstudentid, studentdegreeid, org_id FROM qstudents
WHERE quarterid = '2017/2018.1' AND sublevelid = 'UGPM') as aa
INNER JOIN
(SELECT qstudentid, studentdegreeid, org_id FROM qstudents
WHERE quarterid = '2017/2018.1M' AND sublevelid = 'UGPM') as ab
ON aa.studentdegreeid = ab.studentdegreeid);

UPDATE qstudents SET quarterid = '2017/2018.1'
WHERE sublevelid = 'UGPM' AND quarterid = '2017/2018.1M';


UPDATE sublevels SET degreelevelid = 'UND' WHERE sublevelid = 'UGPM';
UPDATE qcharges SET quarterid = '2017/2018.1', degreelevelid = 'UND'
WHERE (quarterid = '2017/2018.1M') AND (sublevelid = 'UGPM');
UPDATE qmcharges SET quarterid = '2017/2018.1'
WHERE (quarterid = '2017/2018.1M') AND (sublevelid = 'UGPM');
UPDATE qchargedefinations SET quarterid = '2017/2018.1'
WHERE (quarterid = '2017/2018.1M') AND (sublevelid = 'UGPM');
UPDATE qmchargedefinations SET quarterid = '2017/2018.1'
WHERE (quarterid = '2017/2018.1M') AND (sublevelid = 'UGPM');




SELECT qstudentid, studentdegreeid, studentid, org_id FROM qstudentview WHERE quarterid = '2017/2018.1' AND studentdegreeid IN
(SELECT studentdegreeid FROM qstudentview WHERE sublevelid = 'UGPM' AND quarterid = '2017/2018.1M')
ORDER BY studentdegreeid;

SELECT qstudentid, studentdegreeid, org_id FROM qstudents WHERE quarterid = '2017/2018.1' AND studentdegreeid IN
(SELECT studentdegreeid FROM qstudents WHERE sublevelid = 'UGPM' AND quarterid = '2017/2018.1M')
ORDER BY studentdegreeid;

SELECT * FROM studentpayments WHERE qstudentid IN
SELECT qstudentid, studentdegreeid, org_id FROM qstudents WHERE quarterid = '2017/2018.1M' AND studentdegreeid IN
(SELECT studentdegreeid FROM qstudents WHERE sublevelid = 'UGPM' AND quarterid = '2017/2018.1')
ORDER BY studentdegreeid;

SELECT * FROM studentpayments WHERE qstudentid IN
(SELECT qstudentid FROM qstudents WHERE quarterid = '2017/2018.1M' AND studentdegreeid IN
(SELECT studentdegreeid FROM qstudents WHERE sublevelid = 'UGPM' AND quarterid = '2017/2018.1')
ORDER BY studentdegreeid);

SELECT studentpayments.studentpaymentid, qstudents.qstudentid, qstudents.studentdegreeid
FROM qstudents LEFT JOIN studentpayments ON qstudents.qstudentid = studentpayments.qstudentid
WHERE qstudents.quarterid = '2017/2018.1' AND qstudents.studentdegreeid IN
(SELECT qstudents.studentdegreeid
FROM studentpayments INNER JOIN qstudents ON studentpayments.qstudentid = qstudents.qstudentid
WHERE qstudents.sublevelid = 'UGPM' AND qstudents.quarterid = '2017/2018.1M');
