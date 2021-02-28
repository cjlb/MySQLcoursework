SELECT X.theatreNo ,X.dom, X.month, X.year, MAX(X.num) AS maxOps
FROM 
(
	SELECT theatreNo, DAY(startDateTime) AS dom, MONTHNAME(startDateTime) AS month, YEAR(startDateTime) AS year,COUNT(*) AS num
	FROM Hospital_Operation
	GROUP BY theatreNo,dom, month,year
	HAVING num >= 1
) X
GROUP BY theatreNo




 


