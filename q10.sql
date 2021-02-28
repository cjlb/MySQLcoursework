SELECT tno,  dom,month,YEAR, x.max AS numOps
FROM (
	SELECT T.theatreNo AS tno,T.dom, T.month, T.year, MAX(T.numOps) AS max
	FROM 
	(
		SELECT theatreNo, DAY(startDateTime) AS dom, MONTHNAME(startDateTime) AS month, YEAR(startDateTime) AS year,COUNT(*) AS numOps
		FROM Hospital_Operation
		GROUP BY theatreNo,dom, month,year
	) AS T
	GROUP BY theatreNo
	) AS X
WHERE numOps = X.max











