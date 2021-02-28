-- Answer to the 2nd Database Assignment 2019/20
--
-- CANDIDATE NUMBER 181355
-- Please insert your candidate number in the line above.
-- Do NOT remove ANY lines of this template.


-- In each section below put your answer in a new line 
-- BELOW the corresponding comment.
-- Use ONE SQL statement ONLY per question.
-- If you don’t answer a question just leave 
-- the corresponding space blank. 
-- Anything that does not run in SQL you MUST put in comments.
-- Your code should never throw a syntax error.
-- Questions with syntax errors will receive zero marks.

-- DO NOT REMOVE ANY LINE FROM THIS FILE.

-- START OF ASSIGNMENT CODE


-- @@01
DROP TABLE IF EXISTS Hospital_MedicalRecord;

CREATE TABLE Hospital_MedicalRecord (
recNo SMALLINT UNSIGNED,
patient CHAR(9),
doctor CHAR(9),
enteredOn TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
diagnosis MEDIUMTEXT NOT NULL,
treatment VARCHAR(1000),
-- keys
PRIMARY KEY(recNo,patient),
CONSTRAINT FK_patient FOREIGN KEY (patient) REFERENCES Hospital_Patient(NINumber) ON DELETE CASCADE ON UPDATE RESTRICT,
CONSTRAINT FK_doctor FOREIGN KEY(doctor) REFERENCES Hospital_Doctor(NINumber) ON DELETE SET NULL ON UPDATE RESTRICT
);

-- @@02
ALTER TABLE Hospital_MedicalRecord 
	ADD duration TIME;
	
-- @@03
UPDATE Hospital_Doctor
	SET salary = salary * 0.9
	WHERE FIND_IN_SET('ear',expertise) != 0 OR null;
	
-- @@04
SELECT 
	fname,
	lname,
	YEAR(dateOfBirth) AS born	
FROM Hospital_Patient
WHERE  city LIKE '%right%' -- where city name contains 'right'
ORDER BY lname, fname;

-- @@05

SELECT 
	NINumber,
	fname,
	lname, 
	ROUND(weight/(height/100),3) AS BMI -- apply formula and round to 3 dp for BMI
FROM Hospital_Patient
WHERE TIMESTAMPDIFF(YEAR, dateOfBirth, CURDATE()) < 30; -- calculate age in years

-- @@06
SELECT COUNT(*) AS number
FROM Hospital_Doctor;

-- @@07
SELECT 
	NINumber, 
	lname, 
	COUNT(*) AS operations
FROM Hospital_Doctor JOIN Hospital_CarriesOut
ON NiNumber = doctor AND YEAR(startDateTime) = YEAR(CURDATE())
GROUP BY NINumber
ORDER BY operations DESC;

-- @@08
SELECT 
	A.NINumber, 
	UPPER(LEFT(A.fname,1)) AS init, -- take first letter of name and make it uppercase
	A.lname
FROM Hospital_Doctor A JOIN Hospital_Doctor B 
ON B.mentored_by = A.NINumber AND A.mentored_by IS NULL; 

-- @@09
SELECT 
	A.theatreNo AS theatre, 
	CONCAT(A.startDateTime,A.theatreNo) AS startTime1,
	TIME(B.startDateTime) AS startTime2
FROM Hospital_Operation A JOIN Hospital_Operation B
-- find overlap on ops with matching dates and where op A starts before op B
ON ADDTIME(A.startDateTime,A.duration) > B.startDateTime AND  A.startDateTime < B.startDateTime AND DATE(A.startDateTime) = DATE(B.startDateTime) 
GROUP BY CONCAT(A.startDateTime,A.theatreNo);

-- @@10
SELECT 
	T1.tno AS theatreNo,
	T1.dd AS dom,
	T1.mm AS month,
	T1.yy AS year,
	T1.cou AS numOps
FROM ( -- generates table with each op grouped by theatre number and date
	SELECT 
		theatreNo as tno, 
		DAY(startDateTime) AS dd, 
		MONTHNAME(startDateTime) AS mm, 
		YEAR(startDateTime) AS yy, 
		COUNT(*) AS cou, 
		startDateTime
	FROM Hospital_Operation
	GROUP BY tno, dd,mm,yy
	ORDER BY tno, cou DESC
) AS T1
INNER JOIN (
	SELECT 
		T2.tno, 
		MAX(T2.cou) AS mc -- find max number of ops for each theatre number
	FROM
	(
		SELECT 
			theatreNo as tno, 
			DAY(startDateTime) AS dd, 
			MONTHNAME(startDateTime) AS mm, 
			YEAR(startDateTime) AS yy, 
			COUNT(*) AS cou
		FROM Hospital_Operation
		GROUP BY tno, dd,mm,yy
	) AS T2
	GROUP BY T2.tno
) AS T3
ON T1.tno = T3.tno AND T1.cou = mc -- join when theatre number matches and when num ops = max num ops
ORDER BY theatreNo, T1.startDateTime ASC;


-- @@11
SELECT 
	theatreNo, 
	results.lastMay,
	results.thisMay,
	results.thisMay - results.lastMay AS increase -- find increase
FROM (
	SELECT
		theatreNo,
		COUNT(IF(MONTH(startDateTime) = 5 AND YEAR(startDateTime) = YEAR(CURDATE()) - 1,1,NULL)) AS lastMay,
		COUNT(IF(MONTH(startDateTime) = 5 AND YEAR(startDateTime) = YEAR(CURDATE()) ,1,NULL)) AS thisMay
	FROM Hospital_Operation
	GROUP BY theatreNo
) AS results
WHERE results.thisMay - results.lastMay > 0 -- where there is a positive increase
ORDER BY results.thisMay - results.lastMay DESC;


-- @@12
delimiter $$

DROP FUNCTION IF EXISTS usage_theatre;

CREATE FUNCTION usage_theatre(teNo INTEGER UNSIGNED,yy YEAR ) RETURNS VARCHAR(100)
BEGIN

	DECLARE sum_duration INTEGER UNSIGNED;
	DECLARE Result VARCHAR(30);
	DECLARE mins_remaining INTEGER UNSIGNED;
	DECLARE hours INTEGER UNSIGNED;
	DECLARE hours_remaining INTEGER UNSIGNED;
	DECLARE days INTEGER UNSIGNED;
	DECLARE cou INTEGER UNSIGNED;
	
	-- test for future year
	IF ( yy > YEAR(CURDATE())) THEN 
		RETURN 'The year is in the future';
	-- test for theatre number not existing
	ELSEIF ( NOT EXISTS (SELECT teNo FROM Hospital_Operation WHERE teNo = theatreNo)) THEN 
		RETURN CONCAT('There is no operating theatre ', teNo);
	-- test for there being no operations
	ELSEIF ((SELECT COUNT(*) FROM Hospital_Operation WHERE teNo = theatreNo) = 0) THEN
		RETURN CONCAT('Operating theatre ', teNo, ' had no operations in ', yy);
	ELSE 		
		SET sum_duration = 0;
		-- store duration as seconds to preserve accuracy and allow for a large amount of time to be stored
		SELECT SUM(TIME_TO_SEC(duration)) INTO sum_duration FROM Hospital_Operation WHERE YEAR(startDateTime) = yy AND theatreNo = teNo;
		
		-- convert seconds into whole minutes (round down), ignore remaining seconds
		SET sum_duration = FLOOR(sum_duration/60);
		-- convert minutes to hours, store remainder
		SET mins_remaining  = MOD(sum_duration,60);
		SET hours = FLOOR(sum_duration/60); 
		-- convert hours to days, store remainder
		SET hours_remaining  = MOD(hours,24);
		SET days = FLOOR(hours/24);
		
		RETURN CONCAT(days, 'days ', hours_remaining, 'hrs ', mins_remaining, 'mins ');
	END IF;
	
END
$$


-- END OF ASSIGNMENT CODE