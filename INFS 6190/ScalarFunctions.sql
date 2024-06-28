-- Scalar functions with Dates
-- Definition of a scalar function: Takes multiple parameters and returns a singular values 

-- Get current date and time
SELECT GETDATE() AS "Current Date"; 

-- Formatting Dates

-- FORMAT FUNCTION
SELECT INV_NUM, INV_DATE, FORMAT(INV_DATE, 'MMMM dd, yyyy hh:mm:ss tt')
FROM INVOICE
ORDER BY INV_NUM; 

-- FORMAT function is inefficient, CONVERT is used more frequency
SELECT INV_NUM, INV_DATE, CONVERT(varchar, INV_DATE, 111)
FROM INVOICE
ORDER BY INV_NUM; 

-- Decomposing Dates
-- DATENAME (Pulls Date out as Character)
SELECT INV_NUM
	, INV_DATE
	, DATENAME(WEEKDAY, INV_DATE) AS "WEEKDAY"
	, DATENAME(MONTH, INV_DATE) AS "INVOICE MONTH"
	, DATENAME(DD, INV_DATE) AS "DAY OF MONTH"
	, DATENAME(YEAR, INV_DATE) AS "INVOICE YEAR"
FROM INVOICE
ORDER BY INV_NUM; 

-- DATEPART 
-- (PULLS OUT AS NUMERIC INSTEAD OF CHARACTER)
SELECT INV_NUM, INV_DATE, DATEPART(mm, inv_date) as "MONTH"
FROM INVOICE
ORDER BY INV_NUM; 

SELECT INV_NUM
	 , INV_DATE
	 , DATEPART(YEAR, INV_DATE) + 1 AS "One Year Later"-- Showing the numeric property
FROM INVOICE
ORDER BY INV_NUM; 

SELECT INV_NUM
	 , INV_DATE
	 , DATEPART(Q, INV_DATE) AS "Quarter" -- Q / QQ / QUARTER all work
	 , DATEPART(DAYOFYEAR, INV_DATE) AS "Day of Year" 
	 , DATEPART(WEEK, INV_DATE) AS "Week of Year"
	 , DATEPART(HOUR, INV_DATE) AS "Hour"
	 , DATEPART(N, INV_DATE) AS "Minutes"
	 , DATEPART(S, INV_DATE) AS "Seconds"
FROM INVOICE
ORDER BY INV_NUM; 

-- DATE ARITHMETIC
--  USES 01/01/1900 as origin date

SELECT GETDATE() + 10; -- Returns 10 days from current date
SELECT GETDATE() + .25; -- Returns 1/4 days, or 6 hours from now
SELECT GETDATE() + .125; -- Returns 1/8 of a day, or 3 hours from now. 
SELECT GETDATE() - 100; -- Returns 100 days ago. 

-- Using Fractions

SELECT GETDATE() + 1.0/24; -- Returns 1 hour from now.

-- Datetime2 values are incompatible with arithmetic operators without convertion to datetime 
SELECT CAST( INV_DATE AS DATETIME) + 1 -- adds 1 day 
FROM INVOICE; 

-- DATEADD value allows it to be directly changed
SELECT INV_NUM
	, INV_DATE
	, DATEADD(YEAR, 1, INV_DATE) AS "1 YEAR LATER"
	, DATEADD(MONTH, 3, INV_DATE) AS "3 MONTHS LATER"
	, DATEADD(DAY, 7, INV_DATE) AS "1 WEEK LATER"
	, DATEADD(HOUR, 12, INV_DATE) AS "12 HOURS LATER"
	, DATEADD(MINUTE, 30, INV_DATE) AS "30 MINUTES LATER"
	, DATEADD(SECOND, -30, INV_DATE) AS "30 SECONDS BEFORE"
FROM INVOICE
ORDER BY INV_NUM; 

-- DATEDIFF
SELECT INV_NUM
	, INV_DATE
	, DATEDIFF(YEAR, INV_DATE, GETDATE()) AS "YEARS SINCE"
	, DATEDIFF(MONTH, INV_DATE, GETDATE()) AS "MONTHS SINCE"
	, DATEDIFF(DAY, INV_DATE, GETDATE()) AS "DAYS SINCE"
	, DATEDIFF(HOUR, INV_DATE, GETDATE()) AS "HOURS SINCE" 
	, DATEDIFF(MINUTE, INV_DATE, GETDATE()) AS "MINUTES SINCE"
	, DATEDIFF(SECOND, INV_DATE, GETDATE()) AS "SECONDS SINCE"
FROM INVOICE
ORDER BY INV_NUM; 

-- EOMONTH (Returns end of month)
SELECT INV_NUM
	, INV_DATE
	, EOMONTH(INV_DATE)
FROM INVOICE
ORDER BY INV_NUM; 

-- USING DATE FUNCTIONS IN THE WHERE CLAUSE
SELECT * 
FROM INVOICE
WHERE CAST(INV_DATE AS DATE) = '2021-04-30'; 

-- MONTH, YEAR, and DAY SHORT CUTS

SELECT INV_NUM, INV_DATE, MONTH(INV_DATE) AS "Month", YEAR(INV_DATE) AS "YEAR", DAY(INV_DATE) AS "DAY"
FROM INVOICE
ORDER BY INV_NUM; 


-----------------------------------------
------- NUMERIC SCALAR FUNCTIONS --------
-----------------------------------------

-- ROUND FUNCTION
SELECT LEDGER_NUM, LEDGER_AMT, ROUND(LEDGER_AMT, -2) -- Negative numbers go to the left of the decimal. 
FROM LEDGER
ORDER BY LEDGER_NUM;

-- Truncation using ROUND FUNCTION
SELECT LEDGER_NUM, LEDGER_AMT, ROUND(LEDGER_AMT, 1, 1) -- Any number other than 0 in the third argument will truncate the number using the round function (this will not round up) 
FROM LEDGER
ORDER BY LEDGER_NUM;

-- CEILING FUNCTION
SELECT LEDGER_NUM, LEDGER_AMT, CEILING(LEDGER_AMT) -- Smallest int number larger than number provided. 
FROM LEDGER
ORDER BY LEDGER_NUM; 

-- FLOOR FUNCTION  ( different from truncate when working with negative numbers) 
SELECT LEDGER_NUM, LEDGER_AMT, FLOOR(LEDGER_AMT) -- Largest int number smaller than number provided. 
FROM LEDGER
ORDER BY LEDGER_NUM;

-- MODULO OPERATION
SELECT LEDGER_NUM, LEDGER_AMT, LEDGER_AMT % 1 -- Provides the remainder after division
FROM LEDGER
ORDER BY LEDGER_NUM;


-- USING A MODULO OPERATION IN PRACTICE
SELECT C.CUST_CODE
	, LEDGER_AMT AS "REGULAR AMOUNT"
	, CUST_BALANCE
	, CEILING(CUST_BALANCE / LEDGER_AMT) AS "NUMBER OF PAYMENTS"
	, CAST(CUST_BALANCE / LEDGER_AMT AS INT) AS "REGULAR PAYMENTS"
	, CUST_BALANCE % LEDGER_AMT AS "FINAL PAYMENT"
FROM CUSTOMER C JOIN LEDGER L ON C.CUST_CODE = L.CUST_CODE
WHERE LEDGER_TRANSTYPE = 'P'
ORDER BY C.CUST_CODE, LEDGER_NUM; 

-----------------------------------------
---- CHARACTER SCALAR FUNCTIONS ---------
-----------------------------------------

SELECT PROD_NUM, PROD_NAME, PROD_CATEGORY
FROM PRODUCT 
ORDER BY PROD_NUM; 

-- TRIM 
-- Useful for trimming char field data types or free form text fields of spaces
SELECT LTRIM('                  LITERAL                    ');
SELECT CONCAT(RTRIM('HELP   '),'ME'); 
SELECT CONCAT(TRIM('         Jacob           '),'Owens'); 

-- Also useful for clearing things other than spaces
SELECT PROD_NUM, PROD_NAME, TRIM('WARE' FROM PROD_CATEGORY)
FROM PRODUCT 
ORDER BY PROD_NUM; 

-- LEFT, RIGHT
SELECT CUST_CODE
	, CUST_LNAME
	, CUST_PHONE
	, LEFT(CUST_PHONE, 3) AS "Exchange"
	, RIGHT(CUST_PHONE, 4) AS "Subscriber Number"
FROM CUSTOMER
ORDER BY CUST_CODE; 


-- REPLICATE to generate repeated values
SELECT REPLICATE('0',20); 

SELECT CONCAT(REPLICATE('0',5),CUST_CODE)
FROM CUSTOMER
ORDER BY CUST_CODE; 

-- Controls the length of values even when it hits 4 digits and above
SELECT RIGHT(CONCAT(REPLICATE('0',5),CUST_CODE), 7)
FROM CUSTOMER
ORDER BY CUST_CODE; 

SELECT PROD_NUM, LEFT(CONCAT(PROD_NAME, REPLICATE('.', 50)),50), PROD_CATEGORY
FROM PRODUCT
ORDER BY PROD_NUM; 

-- String Lengths

-- LEN Function
---- Does not count trailing spaces
---- 
SELECT PROD_NUM, PROD_NAME, LEN(PROD_NAME)
FROM PRODUCT 
ORDER BY PROD_NUM; 

-- DATALENGTH
--- Tells you the number of bytes
--- If you are using unicode, the characters can take more than one byte to represent so this function could be a huge issue. 
SELECT PROD_NUM, PROD_NAME, LEN(PROD_NAME) AS "LEN LENGTH", DATALENGTH(CONCAT(PROD_NAME, REPLICATE(' ',5))) AS "Data Lenghth"
FROM PRODUCT 
ORDER BY PROD_NUM; 

-- VARCHAR NVARCHAR

SELECT PROD_NUM, PROD_NAME, LEN(PROD_NAME), DATALENGTH(PROD_NAME), LEN(CAST(PROD_NAME AS NVARCHAR)), DATALENGTH(CAST(PROD_NAME AS NVARCHAR))
FROM PRODUCT
ORDER BY PROD_NUM; 


-- REPLACE function
SELECT EMP_NUM, EMP_LNAME, REPLACE(EMP_TITLE, 'IT', 'INFORMATION TECHNOLOGY')
FROM EMPLOYEE
WHERE EMP_TITLE LIKE '%IT%'
ORDER BY EMP_NUM; 

SELECT 'THIS IS this'; 

-- What if you want to replace uppercase THIS and not lowercase this??

--COLLATION 
--- (Default is Latin1_General_CP1_CI_AS (DONT CHANGE)) Right click db, properties, options > Collation
--- CI means "Case Insensitive"
--- AS means "Accent sensitive" 


--- You can change it during a query
SELECT REPLACE('THIS is this' COLLATE LATIN1_GENERAL_BIN, 'THIS', 'THAT'); 

SELECT PROD_NAME
FROM PRODUCT
WHERE PROD_NAME COLLATE LATIN1_GENERAL_BIN LIKE '%ax%'; 


SELECT PROD_NUM
	, PROD_NAME
	, REVERSE(PROD_NAME) -- reverses a string and makes it exactly backwards
FROM PRODUCT
ORDER BY PROD_NUM; 

SELECT VEND_NUM
	, VEND_NAME
	, VEND_STREET
	, CHARINDEX(' ', VEND_STREET, CHARINDEX(' ', VEND_STREET, 1) + 1) -- brings in the index number of a character. 1 is where to start looking default. This finds the second occurence. 
FROM VENDOR
ORDER BY VEND_NUM; 

SELECT VEND_NUM
	, VEND_NAME
	, VEND_STREET
	, LEN(VEND_STREET) AS 'Length of Street'
	, LEFT(VEND_STREET, CHARINDEX(' ', VEND_STREET) - 1) AS 'Street Number'
	, RIGHT(VEND_STREET, CHARINDEX(' ', REVERSE(VEND_STREET))) AS 'Road Type' -- Finds the first blank space coming in from the right. 
	, SUBSTRING(VEND_STREET, CHARINDEX(' ', VEND_STREET) +1, LEN(VEND_STREET) - CHARINDEX(' ', VEND_STREET) - CHARINDEX(' ', REVERSE(VEND_STREET))) AS 'Name of Road'
FROM VENDOR
ORDER BY VEND_NUM; 

-- CREATE BAD PEOPLE

SELECT * INTO STU513DB.DBO.BAD_PEOPLE FROM STARTERDB.TECHRESELL.BAD_PEOPLE
SELECT * INTO STU513DB.DBO.PATTERNS FROM STARTERDB.TECHRESELL.PATTERNS

-- PATTERN MATCHING

SELECT * FROM PATTERNS; 

SELECT * 
FROM CUSTOMER
WHERE CUST_STREET LIKE '[1-4]%' -- REGEX of OR using []; 

SELECT * 
FROM CUSTOMER
WHERE CUST_LNAME LIKE '[A-C][AEIOU]%' -- REGEX of OR using [], second letter a vowel
ORDER BY CUST_LNAME; 


SELECT * 
FROM CUSTOMER
WHERE CUST_LNAME LIKE '[A-C]_[^AEIOU]%' -- REGEX of NOT using [^XXXX], second letter does not matter, third letter a not a vowel in this case
ORDER BY CUST_LNAME; 


-- Using Pattern Matching in Scalar functions

SELECT BAD_NUM
	, BAD_PHONE
	, CHARINDEX('5.6', BAD_PHONE) -- Exact match
FROM BAD_PEOPLE
ORDER BY BAD_NUM; 

-- PatIndex 
SELECT BAD_NUM
	, BAD_PHONE
	, PATINDEX('%[56].[1-3]%', BAD_PHONE) -- Finds an index of a pattern. 
FROM BAD_PEOPLE
ORDER BY BAD_NUM; 
