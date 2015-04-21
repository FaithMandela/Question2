

DELETE FROM studentmajors WHERE studentdegreeid is null;

SELECT studentdegreeid, count(studentmajorid)
FROM studentmajors
GROUP BY studentdegreeid
HAVING count(studentmajorid) > 1;



