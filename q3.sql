UPDATE Hospital_Doctor
	SET salary = salary * 0.9
	WHERE FIND_IN_SET('ear',expertise) != 0 OR null;