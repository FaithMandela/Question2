

INSERT INTO degrees(degreeid, degreelevelid, degreename)
VALUES ('PMED', 'UND', 'Pre-medicine');


UPDATE qstudents SET finaceapproval = false, financeclosed = false, closed = false, approved = false
WHERE quarterid IN ('2017/2018.1', '2017/2018.1M') AND
studentdegreeid IN (SELECT studentdegreeid FROM studentdegrees WHERE studentid IN
('79161', '79164', '79274', '79447', '79527', '79626', '79628', '79631', '79637', '79647', '79779', '79816', '79913', '79973', '79979', '79980', '80123', '80130', '80151', '80189', '80221', '80248', '80254', '80319', '80349', '80449', '80456', '80467', '80474', '80589', '80675', '80690', '80708', '80808', '80839', '80924', '80983', '81008', '81036', '81091', '81209', '81314', '81405', '81444', '81608', '81750', '81938', '81979', '82164', '82213', '82304', '82405', '82469', '82648', '82743', '82864', '83396', '83791', '83850', '84253', '84330', '84556', '84749', '84824', '84860', '85109', '85266', '85542', '85554', '85979', '86682', '16/0042', '16/0488', '16/0549', '16/0954', '16/0975', '16/1415', '16/1436', '16/1810', 'PR/16/0010', 'PR/16/0014', 'PR/16/0038', 'PR/16/0046', 'PR/16/0062', 'PR/16/0071'));

UPDATE studentdegrees SET degreeid = 'PMED', sublevelid = 'UGPM'
WHERE studentdegreeid IN
(SELECT studentdegreeid FROM studentdegrees WHERE studentid IN
('79161', '79164', '79274', '79447', '79527', '79626', '79628', '79631', '79637', '79647', '79779', '79816', '79913', '79973', '79979', '79980', '80123', '80130', '80151', '80189', '80221', '80248', '80254', '80319', '80349', '80449', '80456', '80467', '80474', '80589', '80675', '80690', '80708', '80808', '80839', '80924', '80983', '81008', '81036', '81091', '81209', '81314', '81405', '81444', '81608', '81750', '81938', '81979', '82164', '82213', '82304', '82405', '82469', '82648', '82743', '82864', '83396', '83791', '83850', '84253', '84330', '84556', '84749', '84824', '84860', '85109', '85266', '85542', '85554', '85979', '86682', '16/0042', '16/0488', '16/0549', '16/0954', '16/0975', '16/1415', '16/1436', '16/1810', 'PR/16/0010', 'PR/16/0014', 'PR/16/0038', 'PR/16/0046', 'PR/16/0062', 'PR/16/0071'));


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



UPDATE qstudents SET quarterid = '2017/2018.1'
WHERE sublevelid = 'UGPM' AND quarterid = '2017/2018.1M';

