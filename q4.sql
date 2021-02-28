SELECT fname,lname,YEAR(dateOfBirth) AS born	
FROM Hospital_Patient
WHERE  city LIKE '%right%'
ORDER BY lname, fname;