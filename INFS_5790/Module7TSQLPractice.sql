/* Hello world programs - Variables */

DECLARE @FNAME VARCHAR(10),
		@LNAME VARCHAR(10); 

BEGIN
	SET NOCOUNT ON; /* Prevents the Number of rows affected count message */
	SET @FNAME = 'John'; 
	SET @LNAME = 'Smith'; 
	PRINT 'I want to print this to the screen'; 
	PRINT CONCAT('Hello, ', @FNAME, ' ', @LNAME); 
	SELECT 'I want to print this'; 
	SELECT CONCAT('Hello, ', @FNAME, ' ' , @LNAME); 
END; 

SET NOCOUNT OFF; /* Turn the Number of Rows affected message back on for other code */

DECLARE @MYCOUNT INT = 5; 
BEGIN
	PRINT @MYCOUNT; 
	SET @MYCOUNT = 10; 
	PRINT @MYCOUNT; 
	SET @MYCOUNT = @MYCOUNT + 5; 
	PRINT @MYCOUNT; 
	SET @MYCOUNT += 5; 
	PRINT @MYCOUNT; 
END; 

/* Conditional Statements */

DECLARE @X INT = 5, @Y DECIMAL(5,1) = 2000.1, @TOTAL DECIMAL(6,1); 

BEGIN
	SET @TOTAL = @X * @Y; 
	IF @X = 5
		BEGIN
			PRINT @X; 
			PRINT @Y; 
		END; 
	IF @TOTAL < 100
		BEGIN
			PRINT 'The Total is Small'; 
		END;
	ELSE IF @TOTAL BETWEEN 100 AND 999
		BEGIN
			PRINT 'The total is medium'; 
		END; 
	ELSE IF @TOTAL BETWEEN 1000 AND 5000
		BEGIN 
			PRINT 'The total is big'; 
		END; 
	ELSE 
		BEGIN
			PRINT 'The total is huge'; 
		END; 

END; 

/* Iterative Statements */

DECLARE @MYCOUNTER INT = 1; 

BEGIN
	WHILE @MYCOUNTER <= 20
		BEGIN
			PRINT CONCAT('MyCounter = ', @MYCOUNTER); 
			SET @MYCOUNTER += 1; 
			IF @MYCOUNTER = 10
				BEGIN 
					BREAK; /* Immediately ends while loop */
					RETURN; /* Quits the entire program to sends to the end of the program */
				END; 
		END; 
		PRINT 'Loop has finished'; 
END; 

/* DML Commands in TSQL */

DECLARE @F_NAME VARCHAR(20), @L_NAME VARCHAR(20), @MEMNUM INT; 
BEGIN
	SET @F_NAME = 'Sammy'; 
	SET @L_NAME = 'Jones'; 
	SET @MEMNUM = 101; 
	INSERT INTO bigbear.member (mem_num, mem_fname, mem_lname) VALUES (@MEMNUM, @F_NAME, @L_NAME); 
	PRINT 'Insert finished'; 
END; 

SELECT * FROM bigbear.member; 

/* Update command */

DECLARE @STREET VARCHAR(30), @CITY VARCHAR(30), @STATE CHAR(2), @ZIPCODE CHAR(5); 
BEGIN
	SET @STREET = '101 MAIN STREET'; 
	SET @CITY  = 'MURFREESBORO'; 
	SET @STATE = 'TN'; 
	SET @ZIPCODE = '37132'; 
	UPDATE bigbear.member
	SET mem_street = @STREET,
		mem_city = @CITY,
		mem_state = @STATE, 
		mem_zip = @ZIPCODE
	WHERE mem_num = 101; 
END; 

SELECT * from bigbear.member where mem_num = 101; 

/* Delete Command */

DECLARE @MEMBERNUMBER INT; 

BEGIN
	SET @MEMBERNUMBER = 101; 
	DELETE FROM bigbear.member 
	WHERE mem_num = @MEMBERNUMBER; 
	print 'Member deleted'; 
END; 

SELECT * FROM bigbear.member; 

/* Select Queries in TSQL */

DECLARE @NUM INT, @FIRSTNAME VARCHAR(30), @LASTNAME VARCHAR(30), @COUNT INT; 
BEGIN
	SELECT @num = mem_num, 
		   @FIRSTNAME = mem_fname, 
		   @LASTNAME = mem_lname
	FROM bigbear.member
	WHERE mem_num = 1; -- required for this, because you can only store one value from each row into the variables. If not here, it will return last row. 
	PRINT CONCAT(@FIRSTNAME, ' ', @LASTNAME, ' has member number ', @NUM); 
	SET @COUNT = (SELECT COUNT(*) FROM bigbear.member); -- If it returns one row and one column, you can retrieve the value in a set command
	PRINT @COUNT
END; 

/* Selecting data with a cursor */

-- You always have a loop when working with a cursor

DECLARE PROD_C CURSOR FOR
	SELECT P_CODE, P_DESCRIPT, P_PRICE, P_QOH
	FROM dbo.PRODUCT JOIN dbo.VENDOR ON PRODUCT.V_CODE = VENDOR.V_CODE
	WHERE V_STATE IN ('TN', 'FL'); 
DECLARE @PCODE VARCHAR(10), @PDESCRIPT VARCHAR(50), @PPRICE DECIMAL(10,2), @PQOH INT, @TOTALPRICE DECIMAL(12,2), @LOW INT = 0, @HIGH INT = 0; 
BEGIN
	OPEN PROD_C; -- RUNS THE SELECT QUERY AND CREATES THE CURSOR IN MEMORY
	FETCH NEXT FROM PROD_C INTO @PCODE, @PDESCRIPT, @PPRICE, @PQOH; --Setting things up for the while loop
	WHILE @@FETCH_STATUS = 0 -- system global variable that is set to 0 if it actually retrieves a value
		BEGIN
			SET @TOTALPRICE = @PPRICE * @PQOH; 
			IF @TOTALPRICE < 1000
				BEGIN 
					SET @LOW += 1; 
				end;
			ELSE 
				BEGIN 
					SET @HIGH += 1; 
				END; 
			PRINT CONCAT(@PCODE, ': ', @PDESCRIPT, ' has a total of $', @TOTALPRICE); 
			FETCH NEXT FROM PROD_C INTO @PCODE, @PDESCRIPT, @PPRICE, @PQOH; --iterating to the next row in the process. 
		END; 
	CLOSE PROD_C; -- FREES THE CURSOR AND ITS MEMORY LOCKS. 
	DEALLOCATE PROD_C; -- DESTROYS CURSOR DEFINITION AND FREES UP THE MEMORY FROM THE SYSTEM. 
	PRINT CONCAT('There are ', @LOW, ' products with a low total.'); 
	PRINT CONCAT('There are ', @HIGH, ' products with a high total.'); 
END; 
