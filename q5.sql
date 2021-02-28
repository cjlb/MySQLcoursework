SELECT NINumber,fname,lname, ROUND(weight/(height/100),3) AS BMI
FROM Hospital_Patient
WHERE TIMESTAMPDIFF(YEAR, dateOfBirth, CURDATE()) < 30;