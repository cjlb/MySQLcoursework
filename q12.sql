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


