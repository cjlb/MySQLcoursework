SELECT A.NINumber, UPPER(LEFT(A.fname,1)) AS init, A.lname
FROM Hospital_Doctor A JOIN Hospital_Doctor B 
ON B.mentored_by = A.NINumber AND A.mentored_by IS NULL;


