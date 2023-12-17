/* Hello World Programs
	Variables */

-- Has to be declared before it is used
-- Anonymous block (does not become permanent database)

DECLARE @FNAME VARCHAR(10), @LNAME VARCHAR(10); 
BEGIN 
	SET @FNAME = 'John'; 
	SET @LNAME = 'Smith'; 
	PRINT CONCAT('Hello, ', @FNAME,' ', @LNAME); 
	SELECT 'I want to print this in a table'; 
END; 

SET NOCOUNT OFF; 

DECLARE @MYCOUNT INT = 5; 

BEGIN 
	PRINT @MYCOUNT; 
	SET @MYCOUNT += 5;
	Print @MYCOUNT; 
END; 

/* IF STATEMENTS */

DECLARE @X INT = 5, @Y DECIMAL(5,1) = 200.1, @TOTAL DECIMAL(6,1); 
BEGIN 
	SET @TOTAL = @X * @Y; 
	IF @X = 5
		BEGIN
			PRINT @X;
			PRINT @Y;
			PRINT @TOTAL;
		END;
	IF @TOTAL < 100
		BEGIN 
			PRINT 'The total is small';
		END; 
	ELSE IF @TOTAL BETWEEN 100 AND 1000
		BEGIN
			PRINT 'The total is not small';
		END; 
	ELSE IF @TOTAL BETWEEN 1000 AND 5000
		BEGIN 
			PRINT 'The total is large'; 
		END; 
	ELSE 
		BEGIN
			PRINT 'The total is impossible';
		END; 
END; 

/* Loops */

DECLARE @MYCOUNTER INT = 0; 
BEGIN 
	WHILE @MYCOUNTER <= 20
		BEGIN
			PRINT CONCAT('MyCOUNTER = ', @MYCOUNTER); 
			SET @MYCOUNTER += 1; 
			IF @MYCOUNTER = 10
				BEGIN
					RETURN;
				END; 
		END; 
	PRINT ('Loop Finished');
END; 