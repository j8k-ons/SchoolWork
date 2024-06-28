-- Performance Tuning

SELECT CUST_LNAME
	, CUST_FNAME
	, CUST_BALANCE
	, LINE_QTY 
	, LINE_PRICE
FROM CUSTOMER C 
JOIN INVOICE I ON C.CUST_CODE = I.CUST_CODE 
JOIN LINE L ON I.INV_NUM = L.INV_NUM
WHERE I.INV_NUM = 1001 AND PROD_NUM = 235; 

-- Statistics that are generated
SET STATISTICS TIME ON; -- Time info
SET STATISTICS IO ON; -- Input Output

/* Elapsed time is normally larger than the CPU time. CPU time + all the locks/bottlenecks/waits = Elapsed Time. CPU is greater than Elapsed time when the query gets parallelized across CPU cores. */ 

-- Advanced query optimization involves changing server level permissions 

-- How to tune a query to reduce CPU time? 
-- Storage is typically slowest piece of the server ops. 

/* Physical reads are the slowest. 
	Logical reads moves it into the buffer cache and holds it there until it is pushed it out of the buffer. 
	Read-ahead reads are when the database predicts you will need data so it reads ahead while waiting. 
	LOBS are large objects that are handled differently because they are large. 

	Table Scan is the worst operation you can have the read do.
	Hash joins are used when large sets of unordered data are joined. 
	Nested loops joins are used when the tables are sorted already and one is larger than others. 
	Join conditions are always best with indexes. 
	Indexes slow down DML operations because all the indexes must be updated. 

SQL Server is aggressive in the memory usage trying to buffer and cache as much as it can. */ 

SELECT 19 % 10; -- Non unique remainder hash for 10 groups. 

ALTER TABLE INVOICE ALTER COLUMN INV_NUM INT NOT NULL; 
ALTER TABLE INVOICE ADD PRIMARY KEY(INV_NUM); 
ALTER TABLE LINE ALTER COLUMN INV_NUM INT NOT NULL; 
ALTER TABLE LINE ALTER COLUMN LINE_NUM INT NOT NULL; 
ALTER TABLE LINE ADD PRIMARY KEY (INV_NUM, LINE_NUM); 
ALTER TABLE CUSTOMER ADD PRIMARY KEY(CUST_CODE); 

ALTER TABLE INVOICE ADD CONSTRAINT INVOICE_CUST_CODE_FK FOREIGN KEY (CUST_CODE) REFERENCES CUSTOMER(CUST_CODE); 
ALTER TABLE LINE ADD CONSTRAINT LINE_INV_NUM_FK FOREIGN KEY ( INV_NUM) REFERENCES INVOICE(INV_NUM); 

-- Run this again and look at the execution plan. 
SELECT CUST_LNAME
	, CUST_FNAME
	, CUST_BALANCE
	, LINE_QTY 
	, LINE_PRICE
FROM CUSTOMER C 
JOIN INVOICE I ON C.CUST_CODE = I.CUST_CODE 
JOIN LINE L ON I.INV_NUM = L.INV_NUM
WHERE I.INV_NUM = 1001 AND PROD_NUM = 235; 