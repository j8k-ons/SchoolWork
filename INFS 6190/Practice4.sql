-- Practice 4

/*
1a. Use an analytic function to display the customer code, ledger number, ledger date, payment
amount, and the average amount of payments from that customer. Sort the results by ledger date.
(6609 rows)
*/

SELECT CUST_CODE
	, LEDGER_NUM
	, LEDGER_DATE
	, FORMAT(LEDGER_AMT,'C') AS LEDGER_AMT
	, FORMAT(CAST(AVG(LEDGER_AMT) OVER (PARTITION BY CUST_CODE) AS DECIMAL(10,2)),'C') AS 'AVERAGE PAYMENT'
FROM LEDGER
WHERE LEDGER_TRANSTYPE = 'P'
ORDER BY LEDGER_DATE; 


/*
1b. Produce the same result using an aggregate function in an inline view instead of an analytic function.
*/

SELECT AVGPAY.CUST_CODE
	, LEDGER_NUM
	, LEDGER_DATE
	, FORMAT(LEDGER_AMT,'C') AS LEDGER_AMT
	--, FORMAT(CAST(AVG(LEDGER_AMT) OVER (PARTITION BY CUST_CODE) AS DECIMAL(10,2)),'C') AS 'AVERAGE PAYMENT'
	, FORMAT(AVGPAY.AVGPAYMENT,'C') AS 'AVERAGE PAYMENT'
FROM LEDGER JOIN ( 
					SELECT CUST_CODE
						, AVG(LEDGER_AMT) AS 'AVGPAYMENT'
						FROM LEDGER
						WHERE LEDGER_TRANSTYPE = 'P'
						GROUP BY CUST_CODE
				) AVGPAY ON AVGPAY.CUST_CODE = LEDGER.CUST_CODE
WHERE LEDGER_TRANSTYPE = 'P'
ORDER BY LEDGER_DATE, CUST_CODE; 


/*
1c. Produce the same result using an aggregate function using a common table expression (CTE).
*/

WITH AVGPAY AS (
	SELECT CUST_CODE
		, AVG(LEDGER_AMT) AS 'AVGPAYMENT'
		FROM LEDGER
		WHERE LEDGER_TRANSTYPE = 'P'
		GROUP BY CUST_CODE
		)

SELECT AVGPAY.CUST_CODE
	, LEDGER_NUM
	, LEDGER_DATE
	, FORMAT(LEDGER_AMT,'C') AS LEDGER_AMT
	, FORMAT(AVGPAY.AVGPAYMENT,'C') AS 'AVERAGE PAYMENT'
FROM LEDGER JOIN AVGPAY ON LEDGER.CUST_CODE = AVGPAY.CUST_CODE
WHERE LEDGER_TRANSTYPE = 'P'
ORDER BY LEDGER_DATE, CUST_CODE; 

/*
2a. Write a query using an analytic function to display the invoice number, line number, line quantity,
product number, total number of units in that invoice (across all lines in that invoice), and the
average line units of that product sold (across all invoices). Sort the output by invoice number and
line number. (27,667 rows)
*/

SELECT L.INV_NUM
	, L.LINE_NUM
	, L.PROD_NUM
	, L.LINE_QTY
	, SUM(LINE_QTY) OVER (PARTITION BY INV_NUM) AS 'TOTAL UNITS IN INVOICE'
	, AVG(LINE_QTY) OVER (PARTITION BY PROD_NUM) AS 'AVERAGE QTY'
FROM LINE L
ORDER BY INV_NUM, LINE_NUM; 


/*
2b. Produce the same result using an aggregate function in an inline view.
*/

SELECT SUMS.INV_NUM
	, LINE_NUM
	, AVGS.PROD_NUM
	, LINE_QTY
	, SUMS.TOTALUNIT AS 'TOTAL UNITS IN INVOICE'
	, CAST(AVGS.AVGUNIT AS DECIMAL(10,2)) AS 'AVERAGE QTY'
FROM LINE JOIN (
	SELECT INV_NUM
		, SUM(LINE_QTY) AS 'TOTALUNIT'
	FROM LINE
	GROUP BY INV_NUM
	) SUMS ON LINE.INV_NUM = SUMS.INV_NUM
JOIN (
	SELECT PROD_NUM
		, AVG(LINE_QTY) AS 'AVGUNIT'
	FROM LINE
	GROUP BY PROD_NUM
	) AVGS ON LINE.PROD_NUM = AVGS.PROD_NUM
ORDER BY INV_NUM, LINE_NUM;

/*
2c. Produce the same result using an aggregate function with a common table expression (CTE).
*/

WITH SUMS AS
(
	SELECT INV_NUM
		, SUM(LINE_QTY) AS 'TOTALUNIT'
	FROM LINE
	GROUP BY INV_NUM
),

AVGS AS 
(
	SELECT PROD_NUM
		, AVG(LINE_QTY) AS 'AVGUNIT'
	FROM LINE
	GROUP BY PROD_NUM
)

SELECT SUMS.INV_NUM
	, LINE_NUM
	, AVGS.PROD_NUM
	, LINE_QTY
	, SUMS.TOTALUNIT AS 'TOTAL UNITS IN INVOICE'
	, CAST(AVGS.AVGUNIT AS DECIMAL(10,2)) AS 'AVERAGE QTY'
FROM LINE JOIN SUMS ON SUMS.INV_NUM = LINE.INV_NUM
	JOIN AVGS ON AVGS.PROD_NUM = LINE.PROD_NUM
ORDER BY INV_NUM, LINE_NUM; 

/*
3. Write a query to display the vendor name, product number, product name, quantity on hand and a
ranking of products based on the quantity on hand (larger quantity on hand is ranked 1st). (If there
are 3 products that tie for a rank of 1, then the next product should have a rank of 4). (1108 rows)
*/

SELECT VENDOR.VEND_NAME
	, PRODUCT.PROD_NUM
	, PRODUCT.PROD_NAME
	, PRODUCT.PROD_QOH
	, RANK() OVER (PARTITION BY PROD_NAME ORDER BY PROD_QOH) AS 'RANK'
FROM PRODUCT
JOIN VENDOR ON PRODUCT.VEND_ID = PRODUCT.VEND_ID
ORDER BY PROD_QOH DESC



/*
4. Write a query to display the vendor number, vendor name, product number, product name,
quantity on hand and a ranking of products based on the quantity on hand of products from each
vendor. If there are 3 products from the same vendor that tie for a rank of 1, then the next product
from that vendor should have a rank of 4. (1108 rows)
*/

SELECT VEND_NUM
	, VEND_NAME
	, PROD_NUM
	, PROD_NAME
	, PROD_QOH
	, RANK() OVER (PARTITION BY VEND_ID ORDER BY PROD_QOH DESC) AS "PRODUCTS FROM VENDOR"
FROM VENDOR
JOIN PRODUCT ON PRODUCT.VEND_ID = VENDOR.VEND_NUM; 

/*
5. Write a query to display the vendor number, vendor name, number of different products that your
company carries from that vendor, and a ranking of vendors based on the number of products from
them that the company carries from largest to smallest. (57 rows)
*/

SELECT VEND_NUM
	, VEND_NAME
	, VENDPRODS.ProductCount
	, RANK() OVER (ORDER BY VENDPRODS.PRODUCTCOUNT DESC) AS "Count Ranking"
FROM VENDOR
JOIN ( SELECT VEND_ID, COUNT(PROD_NUM) AS 'ProductCount' FROM PRODUCT GROUP BY VEND_ID) AS VENDPRODS ON VENDPRODS.VEND_ID = VENDOR.VEND_NUM; 


/*
6. Write a query to display the invoice number, invoice total, line number, line total, and a running
total of all lines in that invoice. The line total is calculated as the line quantity times the line price.
The output should be in order by invoice number and line number. (27,667 rows)
*/

SELECT I.INV_NUM
	, I.INV_TOTAL
	, L.LINE_NUM 
	,(L.LINE_PRICE * L.LINE_QTY) AS "Line Total"
	, SUM(L.LINE_PRICE * L.LINE_QTY) OVER (PARTITION BY I.INV_NUM ORDER BY I.INV_NUM, LINE_NUM) AS 'RUNNING TOTAL'
FROM LINE L
JOIN INVOICE I ON I.INV_NUM = L.INV_NUM; 


/*
7. Write a query to display the customer code, ledger number, payment amount, and amount of that
customer’s previous payment. If there was no previous payment for this customer, make the
previous payment appear as zero (0). (6609 rows)
*/

SELECT CUST_CODE
	, L.LEDGER_NUM
	, L.LEDGER_AMT
-- 	, LAG(EMP_SALARY, 1, 0) OVER (PARTITION BY EMP_TITLE ORDER BY EMP_HIREDATE) AS PREVIOUS
	, LAG(LEDGER_AMT, 1, 0) OVER (PARTITION BY CUST_CODE ORDER BY CUST_CODE) AS PREVIOUS
FROM LEDGER L
WHERE LEDGER_TRANSTYPE = 'P';

/*
8. Write a query to display the customer code, ledger number, payment amount, amount of that
customer’s previous payment, and the difference between the current payment and the previous
payment. (6609 rows)
*/

SELECT CUST_CODE
	, LEDGER_NUM
	, LEDGER_AMT
	, LAG(LEDGER_AMT, 1, 0) OVER (PARTITION BY CUST_CODE ORDER BY CUST_CODE) AS "PREVIOUS PAYMENT"
	, LEDGER_AMT - LAG(LEDGER_AMT, 1, 0) OVER (PARTITION BY CUST_CODE ORDER BY CUST_CODE) AS "PAYMENT DIFFERENCE"
FROM LEDGER
WHERE LEDGER_TRANSTYPE = 'P'; 


/*
9. Write a query to display the customer code, ledger number, payment amount, and the average of
the last 3 payments that were made prior to the current payment. If a given payment had no
previous payments, use a function to have the Previous 3 Payment Average appear as zero (0)
instead of being null. (6609 rows)
*/

SELECT CUST_CODE
	, LEDGER_NUM
	, LEDGER_AMT
	, AVG(LEDGER_AMT) OVER (PARTITION BY CUST_CODE ORDER BY CUST_CODE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Average3
FROM LEDGER L
WHERE LEDGER_TRANSTYPE = 'P'; 


/*
10. Write a query to display the customer code, customer last name, balance, date of each invoice, and
the number of days since that customer’s previous invoice. Calculate the number of days without
regard to the time of day that the invoices were placed. Limit the results to only customers that
have a balance greater than $5000. Sort the results by the customer balance in descending order,
then by the customer code and invoice date in ascending order. (29 rows)
*/

SELECT CUSTOMER.CUST_CODE
	, CUST_LNAME
	, CUST_BALANCE
	, FORMAT(INVOICE.INV_DATE, 'yyyy-MM-dd') AS INV_DATE
	, DATEDIFF(DAY, LAG(INVOICE.INV_DATE) OVER (PARTITION BY INVOICE.CUST_CODE ORDER BY INVOICE.INV_DATE), INVOICE.INV_DATE) AS 'DAYS SINCE LAST INVOICE'
FROM CUSTOMER 
	JOIN INVOICE ON INVOICE.CUST_CODE = CUSTOMER.CUST_CODE
WHERE CUST_BALANCE > 5000
ORDER BY CUST_BALANCE DESC, CUSTOMER.CUST_CODE, INVOICE.INV_DATE


/*
11. Write a query to display the customer code, last name, balance, invoice date, and days since last
invoice, just as in the query above. However, also limit the results to only the last invoice placed by
those customers. Continue to sort by balance in descending order and then customer code in
ascending order. (6 rows)
*/

SELECT C.CUST_CODE
	, CUST_LNAME
	, CUST_BALANCE
	, DATEDIFF(DAY, LAG(I.INV_DATE) OVER (PARTITION BY I.CUST_CODE ORDER BY I.INV_DATE), I.INV_DATE) AS 'DAYS SINCE LAST INVOICE'
FROM CUSTOMER C
JOIN INVOICE I ON I.CUST_CODE = C.CUST_CODE


/*
12 Write a query to display the customer code, last name, balance, the average number of days
between each customer’s orders and the number of orders by that customer. Limit the results to
only customers with a balance greater than $5000. Do not consider time of day when determining
the number of days between orders. Sort the results by the number of orders in descending order,
and then by the average days between orders in ascending order. (6 rows)
*/


/*
13. Write a query to display the customer code, last name, balance, number of invoices, and ranking by
number of invoices and balance. The rankings should be such that a higher number of invoices is
ranked before a lower number of invoices. Within ties for number of invoices, the ranking should
consider the customer balance with higher balances being ranked before lower balances. Limit the
query to only consider customers with a balance greater than $3000. Sort the results by the ranking
in ascending order and then by customer code. (218 rows)
*/
