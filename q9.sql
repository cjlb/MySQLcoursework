SELECT A.theatreNo AS theatre, CONCAT(A.startDateTime,A.theatreNo) AS startTime1,TIME(B.startDateTime) AS startTime2
FROM Hospital_Operation A  JOIN Hospital_Operation B
ON ADDTIME(A.startDateTime,A.duration) > B.startDateTime AND  A.startDateTime < B.startDateTime AND DATE(A.startDateTime) = DATE(B.startDateTime)



