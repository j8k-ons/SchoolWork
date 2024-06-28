
/* Add the following column to your INVOICE table to store the shipment weight for each invoice order: INV_WEIGHT decimal(7,2) */

ALTER TABLE INVOICE 
ADD INV_WEIGHT DECIMAL(7,2); 

/* 2. Create a synonym named TECH_INV that points to the WEIGHTS table in the TECHRESELL schema in the STARTERDB database. */

CREATE SYNONYM TECH_INV FOR STARTERDB.TECHRESELL.WEIGHTS; 

/* Use the synonym you just created to update all invoices in your INVOICE table to include the appropriate values from the inv_weight column 
in the WEIGHTS table in the TECHRESELL schema in the STARTERDB database. */ 

UPDATE INVOICE 
SET INVOICE.INV_WEIGHT = T.INV_WEIGHT
FROM INVOICE I JOIN TECH_INV T ON I.INV_NUM = T.INV_NUM;

/* 4. Create in index of the invoice weights in your INVOICE table. */ 

CREATE INDEX weightIndex ON INVOICE(INV_WEIGHT); 

/* 5. Create a synonym named SHIPPING that points to the SHIPPING table in the TECHRESELL schema in the STARTERDB database. */

CREATE SYNONYM SHIPPING FOR STARTERDB.TECHRESELL.SHIPPING; 
 
/* 6. Write a query to retrieve the customer’s first name, last name, street, city, state, zip, invoice number, invoice total, shipping cost, and 
shipment total (invoice total plus shipping cost) for all customer orders in Tennessee, assuming that all shipments will be sent by “Ground” 
shipping method. Sort the output by invoice date. (90 rows) */ 

SELECT CUST_FNAME
	, CUST_LNAME
	, CUST_STREET
	, CUST_CITY
	, CUST_STATE
	, CUST_ZIP
	, I.INV_NUM
	, I.INV_TOTAL
	, S.SHIP_CHARGE
	, I.INV_TOTAL + S.SHIP_CHARGE AS 'TOTAL WITH SHIPPING'
FROM CUSTOMER
JOIN INVOICE I ON I.CUST_CODE = CUSTOMER.CUST_CODE
JOIN SHIPPING S ON I.INV_WEIGHT BETWEEN S.SHIP_MINWEIGHT AND S.SHIP_MAXWEIGHT
WHERE CUST_STATE = 'TN' AND S.SHIP_TYPE = 'Ground'
ORDER BY INV_DATE;  

/* 7. Write a query to display the vendor state, and a semicolon separated list of all vendor names in that state. Sort the names in alphabetical 
order within the list. Sort the resulting rows by vendor state. */ 

SELECT VEND_STATE
	, STRING_AGG(VEND_NAME, ', ') WITHIN GROUP (ORDER BY VEND_NAME) AS VENDORS
FROM VENDOR
GROUP BY VEND_STATE
ORDER BY VEND_STATE;

/* 8.  Write a query to display a pivoted table showing the number of different products sold by vendors in each state during each month. */

WITH BASETABLE 
AS (
	SELECT DISTINCT VEND_STATE
		, L.PROD_NUM
		, DATENAME(M, INV_DATE) AS MONTH
	FROM PRODUCT P
	JOIN LINE L ON L.PROD_NUM = P.PROD_NUM
	JOIN INVOICE I ON I.INV_NUM = L.INV_NUM
	JOIN VENDOR V ON V.VEND_NUM = P.VEND_ID
)
SELECT * 
FROM BASETABLE
PIVOT (
	COUNT(PROD_NUM)
	FOR VEND_STATE IN
		   ([AK], [AL], [AR], [AZ], [CA], [CO], [CT], [DE], [FL], [GA], [HI], [IA], [ID],
			[IL], [IN], [KS], [KY], [LA], [MA], [MD], [ME], [MI], [MN], [MO], [MS], [MT],
			[NC], [ND], [NE], [NH], [NJ], [NM], [NV], [NY], [OH], [OK], [OR], [PA], [RI],
			[SC], [SD], [TN], [TX], [UT], [VA], [VT], [WA], [WI], [WV], [WY])
	) AS RESULT
ORDER BY
CASE MONTH
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
END; 


/* 9. Write a query to produce a pivoted table of product sales that shows the total sales of products within each product category by month and 
year. The total sales are the sum of the line quantity multiplied by the line price for every sale in that month and year. Sort the output by year 
and then by month. */ 

WITH BASETABLE AS 
(
	SELECT P.PROD_CATEGORY
		, YEAR(INV_DATE) AS YEAR
		, MONTH(INV_DATE) AS MONTH
		, LINE_QTY * LINE_PRICE AS TOTAL
	FROM PRODUCT P
		JOIN LINE L ON P.PROD_NUM = L.PROD_NUM
		JOIN INVOICE I  ON L.INV_NUM = I.INV_NUM
) 
SELECT YEAR AS Year, MONTH AS Month, FORMAT(Hardware, 'C') AS Hardware, FORMAT(Software, 'C') AS Software
FROM BASETABLE
PIVOT (
	SUM(TOTAL)
	FOR PROD_CATEGORY IN (Hardware,Software)) AS RESULT
ORDER BY YEAR, MONTH; 



SELECT YEAR(INV_DATE) AS YEAR
	, MONTH(INV_DATE) AS MONTH
	, SUM(HWPROD_CATS.Totals) AS 'Hardware'
	--, SUM(SWPROD_CATS.Totals) AS 'Sofware'
FROM INVOICE I 
	JOIN (
		SELECT LINE.INV_NUM 
			, SUM(LINE_QTY * LINE_PRICE) AS 'Totals'
		FROM PRODUCT 
		JOIN LINE ON LINE.PROD_NUM = PRODUCT.PROD_NUM 
		WHERE PROD_CATEGORY = 'Hardware' 
		GROUP BY PROD_CATEGORY, LINE.INV_NUM
		) AS HWPROD_CATS ON I.INV_NUM = HWPROD_CATS.INV_NUM
GROUP BY YEAR(INV_DATE), MONTH(INV_DATE)
ORDER BY YEAR, MONTH;