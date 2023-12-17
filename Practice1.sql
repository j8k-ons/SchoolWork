
/* Practice Problem 1 */
-- result: Pulled Product InDate instead of Invoice dates, otherwise code structure is correct. 
DECLARE @PCODE VARCHAR(20), @COUNT INT, @PurchaseDate VARCHAR(20); 
BEGIN
	SET @PCODE = '13-Q2/P2'; 
	SET @COUNT = (SELECT COUNT(*) FROM dbo.PRODUCT WHERE P_CODE = @PCODE); 
	IF @COUNT > 0
		BEGIN 
			SET @PurchaseDate = (
				SELECT MAX(INV_DATE) 
				FROM dbo.INVOICE I JOIN LINE L on I.INV_NUMBER = L.INV_NUMBER 
				WHERE P_CODE = @PCODE);  
			PRINT CONCAT(@PCODE, ' was last sold on ', @PurchaseDate); 
		END;
	ELSE
		BEGIN
			PRINT 'Product has never been purchased'; 
		END; 
END; 

--SELECT * FROM dbo.INVOICE I JOiN LINE L ON i.INV_NUMBER = l.INV_NUMBER WHERE p_CODE = '13-Q2/p2'; 

/* Practice Problem 2 */ 
DECLARE @PATID INT = 1160,
		@BookNum INT, 
		@BookTitle VARCHAR(100), 
		@COUNTBOOKS INT = 0; 
DECLARE 
	CHECKOUT_C CURSOR FOR SELECT B.BOOK_NUM, B.BOOK_TITLE
							FROM FACT.CHECKOUT C JOIN FACT.BOOK B ON B.BOOK_NUM = C.BOOK_NUM
							WHERE C.PAT_ID = @PATID; 
BEGIN
	PRINT('Book Check Out History'); 
	OPEN CHECKOUT_C; 
	FETCH NEXT FROM CHECKOUT_C INTO @BookNum, @BookTitle; 
	WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT CONCAT('Book Number: ', @BookNum, '. Book Title: ', @BookTitle); 
			FETCH NEXT FROM CHECKOUT_C INTO @BookNum, @BookTitle; 
			SET @COUNTBOOKS += 1;
		END; 
	CLOSE CHECKOUT_C; 
	DEALLOCATE CHECKOUT_C; 

	IF @COUNTBOOKS = 0
		BEGIN
			PRINT CONCAT('Patron ', @PATID, ' has never checked out a book.'); 
		END
	ELSE 
		BEGIN
			PRINT CONCAT('Patron ', @PATID, ' has checked out ', @COUNTBOOKS, ' books.'); 
		END; 
END; 

SELECT * FROM FACT.PATRON; 