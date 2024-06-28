/* 
SQL PRACTICE 2
*/

/*

1. Write a query using a pattern to retrieve all products whose name meets the following criteria: 
1) start with the word “WORD”, and 2) somewhere after “WORD” have a number. (4 rows)

*/

SELECT * 
FROM PRODUCT
WHERE PROD_NAME LIKE 'WORD%[1-9]%'
ORDER BY PROD_NAME; 

/* 

2. Write a query using a pattern to retrieve all products whose names begin with either 2 or 3 
digits followed by either a space or a letter. Sort the result by product number. (8 rows)
 
*/ 

SELECT * 
FROM PRODUCT
WHERE PROD_NAME LIKE '[0-9][0-9][0-9][ A-Z]%' OR PROD_NAME LIKE '[0-9][0-9][ A-Z]%'
ORDER BY PROD_NUM; 

/* 

3. Write a query using a pattern to retrieve all products whose names contain only letters. Sort 
the result by product number. (342 rows) 

*/

SELECT *
FROM PRODUCT 
WHERE PATINDEX('%[^A-Z]%',PROD_NAME) = 0
ORDER BY PROD_NUM; 

/* 

4. Write a query using a pattern to retrieve all products whose names contain “page”, regardless of 
capitalization, but do not begin or end with “page”. (5 rows)

*/ 

SELECT *
FROM PRODUCT
WHERE PROD_NAME LIKE '_%page%_'; 

/* 

5. Write a query to return the employee number, employee last name, and day of the week that 
each employee was hired. Sort the output by employee number. (293 rows) 

*/

SELECT EMP_NUM, EMP_LNAME, DATENAME(WEEKDAY, EMP_HIREDATE) AS "DAY HIRED"
FROM EMPLOYEE 
ORDER BY EMP_NUM; 


/*
6. Write a query to return the number of employees hired on a Friday.
*/ 

SELECT COUNT(*) AS "NUMBER HIRED ON A FRIDAY"
FROM EMPLOYEE
WHERE DATENAME(WEEKDAY,EMP_HIREDATE) = 'Friday'; 

/* 
7. Write a query to return the number of employees hired between 5pm and 5am, regardless of 
the day. 
*/

SELECT COUNT(*) AS "NUMBER HIRED AT NIGHT"
FROM EMPLOYEE
WHERE DATEPART(HOUR, EMP_HIREDATE) >= 17 OR DATEPART(HOUR, EMP_HIREDATE) < 5; 

/*
8. Write a query to return the day of the week and the number of employees hired on that day of 
the week.
*/ 

SELECT DATENAME(WEEKDAY, EMP_HIREDATE) AS "DAY", COUNT(*) AS "NUMBER HIRED"
FROM EMPLOYEE 
GROUP BY DATENAME(WEEKDAY, EMP_HIREDATE)
ORDER BY DATENAME(WEEKDAY, EMP_HIREDATE)

/*
9. Write a query to display the employee number and employee last name of the employees hired 
between 1pm on April 18, 2012 and 10am on November 30, 2012. Sort the output by the 
hiredate. (28 rows)
*/ 

SELECT EMP_NUM, EMP_LNAME
FROM EMPLOYEE
WHERE EMP_HIREDATE BETWEEN '2012-04-18 13:00:00' AND '2012-11-30 10:00:00'
ORDER BY EMP_HIREDATE; 

/* 
10.  Write a query to display the employee number, employee last name, employee hire date, 
invoice number, invoice date, and invoice total for all invoices that were completed by an
employee that had been working for the company at least 15 years at the time the invoice was 
completed. Sort the output by invoice number. (915 rows) 
*/ 

SELECT EMP_NUM
	, EMP_LNAME
	, EMP_HIREDATE
	, INV_NUM
	, INV_DATE
	, INV_TOTAL 
FROM EMPLOYEE
JOIN INVOICE ON INVOICE.EMPLOYEE_ID = EMPLOYEE.EMP_NUM
WHERE DATEDIFF(YEAR, EMP_HIREDATE, INV_DATE) >= 15
ORDER BY INV_NUM; 

/* 

11. Write a query to display the customer code, customer last name, customer balance, invoice 
number, invoice date, and invoice total for all invoices placed any time on January 25, 2022. Sort 
the output by customer code and then by invoice number. (23 rows)

*/ 

SELECT INVOICE.CUST_CODE
	, CUST_LNAME
	, CUST_BALANCE
	, INV_NUM
	, FORMAT(INV_DATE, 'dd/MM/yyyy') AS 'Invoice Date'
	, INV_TOTAL
FROM INVOICE 
JOIN CUSTOMER ON CUSTOMER.CUST_CODE = INVOICE.CUST_CODE
WHERE FORMAT(INV_DATE, 'yyyy-MM-dd') = '2022-01-25'
ORDER BY CUST_CODE, INV_NUM; 

/*
12. Write a query to display the customer code, customer last name, customer balance, invoice 
number, invoice, date, and invoice total for all invoices placed on February 14, 2022 at or before 
noon. Sort the result in descending order by invoice total. (8 rows)
*/ 

SELECT CUSTOMER.CUST_CODE
	, CUST_LNAME
	, CUST_BALANCE
	, INV_NUM
	, INV_DATE
	, INV_TOTAL
FROM CUSTOMER
JOIN INVOICE ON INVOICE.CUST_CODE = CUSTOMER.CUST_CODE
WHERE INV_DATE BETWEEN '2022-02-14 00:00:00' AND '2022-02-14 12:00:00'
ORDER BY INV_TOTAL DESC; 

/* 
13. Without using a CASE statement, write a query to display the invoice number, invoice date, 
invoice total, and the date of the next Friday following the invoice date for all invoices that have 
a total greater than $4000. Sort by invoice number. (9 rows)
 */ 

 SELECT INV_NUM
	, INV_DATE
--	, INV_TOTAL
	, CHOOSE(DATEPART(WEEKDAY,INV_DATE)
		, FORMAT(CAST(INV_DATE AS DATETIME) +5, 'yyyy-MM-dd') 
		, FORMAT(CAST(INV_DATE AS DATETIME) +4, 'yyyy-MM-dd')
		, FORMAT(CAST(INV_DATE AS DATETIME) +3, 'yyyy-MM-dd')
		, FORMAT(CAST(INV_DATE AS DATETIME) +2, 'yyyy-MM-dd')
		, FORMAT(CAST(INV_DATE AS DATETIME) +1, 'yyyy-MM-dd')
		, FORMAT(CAST(INV_DATE AS DATETIME) +7, 'yyyy-MM-dd')
		, FORMAT(CAST(INV_DATE AS DATETIME) +6, 'yyyy-MM-dd')) AS "NEXT FRIDAY"
FROM INVOICE
WHERE INV_TOTAL > 4000
ORDER BY INV_NUM; 


/* 

14.  Write a query to display the invoice number, customer code, invoice date, and last day of the 
month in which the invoice occurred for all invoices that occurred during the first 3 days of a 
month. Sort by customer code, then by invoice number. (714 rows)

*/ 

SELECT INV_NUM
	, CUST_CODE
	, FORMAT(INV_DATE, 'yyyy-MM-dd') AS 'Invoice Date'
	, EOMONTH(INV_DATE) AS 'LAST DAY OF THE MONTH'
FROM INVOICE
WHERE DATEPART(DAY, INV_DATE) IN (1,2,3)
ORDER BY CUST_CODE, INV_NUM; 

/* 
15a. Write a query without using a CASE statement to display all ledger activity for customer code 
600. For the ledger transaction type, instead of displaying the values C or P, display the words 
Charge or Payment. Sort the output in order by ledger date. (6 rows)
*/ 

SELECT LEDGER_NUM
	, LEDGER_DATE
	, REPLACE(REPLACE(LEDGER_TRANSTYPE, 'C', 'Charge'), 'P', 'Payment') AS TYPE
	, LEDGER_AMT
	, INV_NUM
	, CUST_CODE
	, LEDGER_PAYTYPE
	, LEDGER_PAYTYPENUM
FROM LEDGER
WHERE CUST_CODE = 600
ORDER BY LEDGER_DATE; 

SELECT LEDGER_NUM
	, LEDGER_DATE
	, IIF(LEDGER_TRANSTYPE = 'C', 'Charge', IIF(LEDGER_TRANSTYPE ='P', 'Payment', LEDGER_TRANSTYPE)) AS TYPE
	, LEDGER_AMT
	, INV_NUM
	, CUST_CODE
	, LEDGER_PAYTYPE
	, LEDGER_PAYTYPENUM
FROM LEDGER
WHERE CUST_CODE = 600
ORDER BY LEDGER_DATE; 

-- Write the same ledger as a CASE statement

SELECT LEDGER_NUM
	, LEDGER_DATE
	, CASE LEDGER_TRANSTYPE
		WHEN 'C' THEN 'Charge'
		WHEN 'P' THEN 'Payment'
	  END TYPE
	, LEDGER_AMT
	, INV_NUM
	, CUST_CODE
	, LEDGER_PAYTYPE
	, LEDGER_PAYTYPENUM
FROM LEDGER
WHERE CUST_CODE = 600
ORDER BY LEDGER_DATE; 

SELECT * 
FROM LEDGER; 

/*
16a. Write a query to display the ledger number, ledger date, ledger amount, payment type, and 
payment number for all payments in the ledger by customer 138. If the payment type is CCard 
then have the payment type display Credit Card. If the payment number is null, then have it 
display “None Required”.
*/

SELECT LEDGER_NUM
	, LEDGER_DATE
	, LEDGER_AMT
	, CASE LEDGER_PAYTYPE WHEN 'CCARD' THEN 'Credit Card' ELSE LEDGER_PAYTYPE END 'PAYMENT TYPE'
	, IIF(LEDGER_PAYTYPENUM IS NULL, 'None Required', LEDGER_PAYTYPENUM) AS 'PAYMENT NUMBER'
FROM LEDGER
WHERE CUST_CODE = 138 AND LEDGER_PAYTYPE IS NOT NULL
ORDER BY LEDGER_AMT DESC; 

-- Write without CASE 

SELECT LEDGER_NUM
	, LEDGER_DATE
	, LEDGER_AMT
	, IIF(LEDGER_PAYTYPE ='CCARD', 'Credit Card', LEDGER_PAYTYPE) AS 'PAYMENT TYPE'
	, IIF(LEDGER_PAYTYPENUM IS NULL, 'None Required', LEDGER_PAYTYPENUM) AS 'PAYMENT NUMBER'
FROM LEDGER
WHERE CUST_CODE = 138 AND LEDGER_PAYTYPE IS NOT NULL
ORDER BY LEDGER_AMT DESC; 

/*
17a. Write a query (without a join) to display the customer code, the sum of all of that customer’s 
payments in the ledger, and the sum of all of that customer’s charges in the ledger. Each 
customer should be represented by a single row in the output. Sort the output by customer 
code. (3171 rows)
*/

SELECT 
	CUST_CODE
	, SUM(IIF(LEDGER_PAYTYPE IS NOT NULL, LEDGER_AMT, 0)) AS "SUM OF PAYMENTS"
	, SUM(IIF(LEDGER_TRANSTYPE = 'C', LEDGER_AMT, 0)) AS "SUM OF CHARGES"
FROM LEDGER
GROUP BY CUST_CODE
ORDER BY CUST_CODE; 

/*
18. Write a query to display the product numbers and number of times that those products appear on 
the same invoice. Do not include a product paired with itself. Limit the output to product pairings 
that appeared together more than once. Sort the output in descending order by the number of 
times the products appear on the same invoice, then by the first product number in ascending 
order. (4284 rows)
*/ 

SELECT P2.PROD_NUM, P1.PROD_NUM, COUNT(L1.INV_NUM) AS "NUM TIMES ON SAME INVOICE"
FROM PRODUCT P1
CROSS JOIN PRODUCT P2
JOIN LINE L1 ON P1.PROD_NUM = L1.PROD_NUM
JOIN LINE L2 ON P2.PROD_NUM = L2.PROD_NUM
JOIN INVOICE ON INVOICE.INV_NUM = L1.INV_NUM
WHERE (P1.PROD_NUM != P2.PROD_NUM) AND (L2.INV_NUM = L1.INV_NUM)
GROUP BY P1.PROD_NUM, P2.PROD_NUM
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, P2.PROD_NUM ASC; 


/* 
19.  It is cheaper to buy software from vendors in cases of 7 units. Write a query to display the software 
products that need to be reordered (i.e., the quantity is less than the minimum), the number of 
units it would take to get the quantity on hand back to the minimum level, how many cases and 
singles it will take to purchase that many units. Sort by product number. (198 rows)
*/ 

SELECT PROD_NUM
	, PROD_NAME
	, (PROD_MIN - PROD_QOH) AS "NEEDED"
	, FLOOR((PROD_MIN - PROD_QOH) / 7) AS "CASES"
	, (PROD_MIN-PROD_QOH) % 7 AS "SINGLES"
FROM PRODUCT 
WHERE PROD_CATEGORY = 'Software' AND (PROD_QOH < PROD_MIN)
ORDER BY PROD_NUM; 

/* 
20. With the same assumptions as above about purchasing in cases, also assume that our cost to buy a 
software product in a case is 10% less than the price we sell it for (prod_price), rounded to the 
nearest penny. Write a query to return how many of the product we currently have, how many we 
need to get to the minimum, how many cases we would have to buy to get us to at least the 
minimum (no singles, only cases), how much that many cases will cost, and what our quantity on 
hand for that product will be after we buy that many cases. As above, limit to software products 
that need to be reordered. Sort by product number. (198 rows)
*/

SELECT PROD_NUM
	, PROD_NAME
	, PROD_QOH AS "CURRENTQTY"
	, (PROD_MIN - PROD_QOH) AS "NEEDED"
	, CEILING(CAST(PROD_MIN - PROD_QOH AS DECIMAL) / 7) AS  "CASES"
	, ROUND((PROD_PRICE - (PROD_PRICE * .1)),2) AS "COST"
	, ROUND(CEILING(CAST(PROD_MIN - PROD_QOH AS DECIMAL) / 7) * (PROD_PRICE - (PROD_PRICE * .1)),2) AS "PURCHTOTAL"
	, PROD_QOH + (CEILING(CAST(PROD_MIN - PROD_QOH AS DECIMAL) / 7) * 7) AS "NEWQTY"
FROM PRODUCT
WHERE PROD_CATEGORY = 'Software' AND (PROD_QOH < PROD_MIN)
ORDER BY PROD_NUM; 