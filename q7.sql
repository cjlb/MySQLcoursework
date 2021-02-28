SELECT 
	NINumber, 
	lname, 
	COUNT(*) AS operations
FROM Hospital_Doctor JOIN Hospital_CarriesOut
ON NiNumber = doctor AND YEAR(startDateTime) = YEAR(CURDATE())
GROUP BY NINumber
ORDER BY operations DESC;
