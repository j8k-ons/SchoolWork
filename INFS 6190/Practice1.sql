-- Practice 1

-- 1. Write a query to display the customer code, first name, last name, and balance fro all customers with a balance greater than $2500. Sort the results by customer last name then first name (375)

SELECT C.CUST_CODE, C.CUST_FNAME, C.CUST_LNAME, C.CUST_BALANCE
FROM CUSTOMER C
WHERE C.CUST_BALANCE > 2500
ORDER BY C.CUST_LNAME, C.CUST_FNAME; 

-- 2. Write a query to display the vendor name and address (concatenate the entire vendor address into a single field) for all vendors in CA sorted by city name and vendor name (9)

SELECT V.VEND_NAME
	 , CONCAT(V.VEND_STREET, ' ', V.VEND_CITY, ', ', V.VEND_STATE, ' ', V.VEND_ZIP) AS "Vendor Address"
FROM VENDOR V
WHERE V.VEND_STATE IN ('CA')
ORDER BY V.VEND_CITY, V.VEND_NAME; 

-- 3. Write a query to display the product number, product name, and the required inventory cost for each product in the "Hardware" category, sorted by quantity on hand in descending order and product name
--	  in ascending order. Required inventory cost is calculated as the product's price multiplied by the reorder point (prod_min). (255) 

SELECT P.PROD_NUM
	, P.PROD_NAME
	, (P.PROD_MIN * PROD_PRICE) AS 'Required Cost'
FROM PRODUCT P
WHERE P.PROD_CATEGORY = 'Hardware'
ORDER BY P.PROD_QOH DESC, P.PROD_NAME ASC; 

-- 4. Write a query to display the ledger number, customer code, and ledger amount for all payments over $5000 paid in cash. Have the output sorted in descending order by amount. (2)

SELECT L.LEDGER_NUM, L.CUST_CODE, L.LEDGER_AMT
FROM [Ledger] L
WHERE L.LEDGER_AMT > 5000 AND L.LEDGER_PAYTYPE = 'Cash'
ORDER BY L.LEDGER_AMT DESC; 

-- 5. Write a query to display the ledger number, ledger date, and payment amount for all payments made by check for amounts between $4000 and $5000, and credit card payments greater than $3000. Have the
--    output sorted by payment amount in descending order and then by date in ascending order. (19 rows)

SELECT L.LEDGER_NUM, L.LEDGER_DATE, L.LEDGER_AMT, L.LEDGER_PAYTYPE
FROM [LEDGER] L
WHERE (L.LEDGER_PAYTYPE = 'Check' AND L.LEDGER_AMT BETWEEN 4000 AND 5000) OR (L.LEDGER_PAYTYPE = 'CCARD' AND L.LEDGER_AMT > 3000)
ORDER BY L.LEDGER_AMT DESC, L.LEDGER_DATE ASC; 

-- 6. Write a query to display all product information for the following products: 100, 140, 200, 251, 320, 335, and 338. Sort the output by product number. (7 rows)

SELECT * 
FROM PRODUCT 
WHERE PRODUCT.PROD_NUM IN (100,140,200,251,320,335, 338)
ORDER BY PRODUCT.PROD_NUM; 

-- 7. Write a query to display the vendor number, name, and state for all vendors that have “Special” in the name. Sort the output by vendor state and then by vendor name. (22 rows)

SELECT V.VEND_NUM, V.VEND_NAME, V.VEND_STATE
FROM VENDOR V
WHERE V.VEND_NAME LIKE '%Special%'
ORDER BY V.VEND_STATE, V.VEND_NAME; 


-- 8. Write a query to display the customer code, first name, last name, and balance along with the invoice number, date, and total for all customers with an invoice total greater than their current balance. Only
-- include customers from the state of Pennsylvania (PA) in your result, and sort the results by the customer’s last name in ascending order and then by invoice total in descending order. (119 rows)

SELECT C.CUST_CODE
	, C.CUST_FNAME
	, C.CUST_LNAME
	, C.CUST_BALANCE
	, I.INV_NUM
	, I.INV_DATE
	, I.INV_TOTAL
FROM CUSTOMER C
JOIN INVOICE I ON I.CUST_CODE = C.CUST_CODE
WHERE C.CUST_BALANCE < I.INV_TOTAL AND C.CUST_STATE IN ('PA')
ORDER BY C.CUST_LNAME ASC, I.INV_TOTAL DESC; 

-- 9. Write a query to display the invoice number and date along with the line numbers, product number, line quantity and line price for all invoices that were placed on or after July 3rd, 2021 but before July 6th,
--    2021. Sort the results by invoice number and line number. (207 rows)

SELECT I.INV_NUM, I.INV_DATE, L.LINE_NUM, L.PROD_NUM, L.LINE_QTY, L.LINE_PRICE
FROM INVOICE I
JOIN LINE L ON L.INV_NUM = I.INV_NUM
WHERE I.INV_DATE BETWEEN '2021-07-03' AND '2021-07-06'
ORDER BY I.INV_NUM, L.LINE_NUM; 

/* 10. Write a query to display the employee number, employee email address, invoice number, invoice date,
and invoice total for all employees with a salary greater than $10,000 and that were hired before
January 1, 2012 and had an invoice with a total greater than $3,000. Sort the results by employee
number then invoice number. (20 rows) */

SELECT E.EMP_NUM, E.EMP_EMAIL, I.INV_NUM, I.INV_DATE, I.INV_TOTAL
FROM EMPLOYEE E
JOIN INVOICE I ON I.EMPLOYEE_ID = E.EMP_NUM
WHERE E.EMP_SALARY > 10000 AND E.EMP_HIREDATE < '2012-01-01' AND I.INV_TOTAL > 3000 
ORDER BY E.EMP_NUM, I.INV_NUM; 

/* 11. Write a query to display the customer code, last name, first name, and the number of invoices
associated with each customer. Sort the results in descending order by the number of invoices then
ascending order by customer last name. (3171 rows) */ 

SELECT C.CUST_CODE, C.CUST_LNAME, C.CUST_FNAME, COUNT(I.INV_NUM) As 'Number of Invoices'
FROM CUSTOMER C
JOIN INVOICE I ON I.CUST_CODE = C.CUST_CODE
GROUP BY C.CUST_CODE, C.CUST_LNAME, C.CUST_FNAME
ORDER BY COUNT(I.INV_NUM) DESC, C.CUST_LNAME ASC; 

/*12. Write a query to display the customer code and the sum of all payments in the ledger made by each
customer. Sort the results by customer code. (3112 rows) */

SELECT C.CUST_CODE, SUM(L.LEDGER_AMT) AS "Sum of Payments"
FROM CUSTOMER C
JOIN [LEDGER] L ON L.CUST_CODE = C.CUST_CODE
WHERE L.LEDGER_PAYTYPE IS NOT NULL
GROUP BY  C.CUST_CODE
ORDER BY C.CUST_CODE; 

/*13. Write a query to display the customer code and average payment made by credit card for that customer
in the ledger. Limit the result to customers that have more than 5 credit card payments. Sort the output
by average payment in descending order. (4 rows) */

SELECT C.CUST_CODE, AVG(L.LEDGER_AMT) AS "Average Credit Card Payment"
FROM CUSTOMER C
JOIN [LEDGER] L ON L.CUST_CODE = C.CUST_CODE
WHERE L.LEDGER_PAYTYPE = 'CCARD' 
GROUP BY C.CUST_CODE
HAVING COUNT(*) > 5
ORDER BY AVG(L.LEDGER_AMT) DESC; 

/* 14. Write a query to display the vendor number, vendor name, number of products, and average price of
products from each vendor, including vendors that do not provide any products. Sort the results by the
number of products and then by vendor name. (63 rows) */ 

SELECT DISTINCT V.VEND_NUM
			  , V.VEND_NAME
			  , VENDCOUNT.[Number of Products]
			  , AVG(P.PROD_PRICE) AS 'Average Price'
FROM VENDOR V 
LEFT JOIN PRODUCT P ON P.VEND_ID = V.VEND_NUM
LEFT JOIN
			(SELECT P.VEND_ID, COUNT(DISTINCT PROD_NUM) AS 'Number of Products'
			FROM PRODUCT P
			GROUP BY P.VEND_ID) AS VENDCOUNT ON VENDCOUNT.VEND_ID = P.VEND_ID
GROUP BY 
	V.VEND_NUM
	, VENDCOUNT.[Number of Products]
	, V.VEND_NAME
ORDER BY 
	VENDCOUNT.[Number of Products]
	, V.VEND_NAME; 



/* 15. Write a query to display the average employee salary for employee’s that are not associated with any
invoices. (1 row) */ 

SELECT AVG(E.EMP_SALARY) AS "Average Salary"
FROM (SELECT E.EMP_NUM, COUNT(I.INV_NUM) AS "Invoice Count" FROM EMPLOYEE E
LEFT JOIN INVOICE I ON I.EMPLOYEE_ID = E.EMP_NUM
GROUP BY E.EMP_NUM) AS EMPNUMS
JOIN EMPLOYEE E ON EMPNUMS.EMP_NUM = E.EMP_NUM
WHERE EMPNUMS.[Invoice Count] = 0; 
