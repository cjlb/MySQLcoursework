
SELECT 
	T1.tno AS theatreNo,
	T1.dd AS dom,
	T1.mm AS month,
	T1.yy AS year,
	T1.cou AS numOps
	FROM (
		SELECT theatreNo as tno, DAY(startDateTime) AS dd, MONTHNAME(startDateTime) AS mm, YEAR(startDateTime) AS yy, COUNT(*) AS cou, startDateTime
		FROM Hospital_Operation
		GROUP BY tno, dd,mm,yy
		ORDER BY tno, cou DESC
	) AS T1
	INNER JOIN (
		SELECT T2.tno, MAX(T2.cou) AS mc
		FROM
		(
			SELECT theatreNo as tno, DAY(startDateTime) AS dd, MONTHNAME(startDateTime) AS mm, YEAR(startDateTime) AS yy, COUNT(*) AS cou
			FROM Hospital_Operation
			GROUP BY tno, dd,mm,yy
		) AS T2
		GROUP BY T2.tno
	) AS T3
	ON T1.tno = T3.tno AND T1.cou = mc
	ORDER BY theatreNo, T1.startDateTime
	
