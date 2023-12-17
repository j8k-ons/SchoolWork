
/* SQL Practice 1 */

-- 1. Write a query that displays the booktitle, cost and year of publication for every book in the system. 
SELECT B.BOOK_TITLE
	, B.BOOK_COST
	, B.BOOK_YEAR
FROM STU279DB.FACT.BOOK B; 

-- 2. Write a query that displays the first and last name of every patron. 

SELECT P.PAT_FNAME
	, P.PAT_LNAME
FROM STU279DB.FACT.PATRON P; 

-- 3. Write a uery to display the checkout number, check out date, and due date for every book that has been checked out. 

SELECT C.CHECK_NUM
	, C.CHECK_OUT_DATE
	, C.CHECK_DUE_DATE
FROM FACT.CHECKOUT C; 

-- 4. Write a query to display the book number, book title, and year of publication for every book. 

SELECT B.BOOK_NUM
	, B.BOOK_TITLE AS TITLE
	, B.BOOK_YEAR AS 'Year Published'
FROM FACT.BOOK B
ORDER BY B.BOOK_NUM; 

-- 5. Write a query to display the different years that books have been published in. Include each year only once. 

SELECT DISTINCT B.BOOK_YEAR 
FROM FACT.BOOK B; 

-- 6. Write a query to display the different subjects that FACT has books on. Include each subject only once. 

SELECT DISTINCT B.BOOK_SUBJECT
FROM FACT.BOOK B 

-- 7. Write a query to display the patron ID, book number, and days kept for each checkout. The days kept is the difference from the date on which the book is returned to the date it was check out. 

SELECT C.PAT_ID AS PATRON
	, C.BOOK_NUM AS BOOK
	, DATEDIFF("DAY",C.CHECK_OUT_DATE, C.CHECK_IN_DATE) AS 'Days Kept'
FROM FACT.CHECKOUT C; 

-- 8. Write a query to display the book number, title, and cost of each book. 

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, FORMAT(B.BOOK_COST, 'C') AS 'Replacement Cost'
FROM FACT.BOOK B

-- 9. Write a query to display the patron ID, patron full name, and patron type for each patron. 

SELECT P.PAT_ID
	, CONCAT(P.PAT_FNAME,' ',P.PAT_LNAME) AS 'Patron Name'
	, P.PAT_TYPE
FROM FACT.PATRON P; 

-- 10. Write a query to display the book number, title with year, and subject for each book. 

SELECT B.BOOK_NUM
	, CONCAT(B.BOOK_TITLE, ' (',B.BOOK_YEAR,')') AS BOOK
	, B.BOOK_SUBJECT
FROM FACT.BOOK B; 

-- 11. Write a query to display the months during which a checkout was made. Display each month with a checkout only once. 

SELECT DISTINCT FORMAT(C.CHECK_OUT_DATE, 'MMMM') AS MONTH
FROM FACT.CHECKOUT C; 

-- 12. Write a query to display the author last name, author first name, and book number for each book written by that author. 

SELECT A.AU_LNAME
	, A.AU_FNAME
	, W.BOOK_NUM
FROM FACT.AUTHOR A
JOIN FACT.WRITES W ON W.AU_ID = A.AU_ID
 
-- 13.  Write a query to display the author id, book number, title and year for each book.

SELECT W.AU_ID
	, B.BOOK_NUM
	, B.BOOK_TITLE
	, B.BOOK_YEAR
FROM FACT.BOOK B
JOIN FACT.WRITES W ON W.BOOK_NUM = B.BOOK_NUM

-- 14.  Write a query to display the author name (last name then first name separated by a comma and space), book title and cost for each book.

SELECT CONCAT(A.AU_LNAME, ', ', A.AU_FNAME) AS 'Author Name'
	, B.BOOK_TITLE
	, B.BOOK_COST
FROM FACT.BOOK B
JOIN FACT.WRITES W ON W.BOOK_NUM = B.BOOK_NUM
JOIN FACT.AUTHOR A ON A.AU_ID = W.AU_ID

-- 15. Write a query to display the checkout number, book number, patron id, checkout date and due date for every checkout that has ever occurred in the system. Sort the results by checkout date in descending order.

SELECT C.CHECK_NUM
	, C.BOOK_NUM, C.PAT_ID
	, FORMAT(C.CHECK_OUT_DATE,'MMMM dd, yyyy') AS 'Date Out'
	, C.CHECK_DUE_DATE AS 'Date Due'
FROM FACT.CHECKOUT C
ORDER BY 'Date Out' DESC; 

/* 16.  Write a query to display the book title, year, and subject for every book. Sort
the results by book subject in ascending order, year in descending order, and then
title in ascending order. */

SELECT B.BOOK_TITLE
	, B.BOOK_YEAR
	, B.BOOK_SUBJECT
FROM FACT.BOOK B
ORDER BY B.BOOK_SUBJECT, B.BOOK_YEAR DESC, B.BOOK_TITLE; 

/* 17. Write a query to display the patron id, book number, patron first name and last
name, and book title for all currently checked out books. (Remember to use the
redundant relationship described in the assignment instructions for current
checkouts.) Sort the output by patron last name and book title. */

SELECT B.PAT_ID
	, B.BOOK_NUM
	, P.PAT_FNAME
	, P.PAT_LNAME
	, B.BOOK_TITLE
FROM FACT.BOOK B
JOIN FACT.PATRON P ON P.PAT_ID = B.PAT_ID
ORDER BY P.PAT_LNAME, B.BOOK_TITLE;

/* 18. Write a query to display the book number, title, and year for all books published in 2021. */

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, B.BOOK_YEAR
FROM FACT.BOOK B
WHERE B.BOOK_YEAR = '2021'; 

/* 19.  Write a query to display the book number, title and year of publication for all books in the “Database” subject */

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, B.BOOK_YEAR
FROM FACT.BOOK B
WHERE B.BOOK_SUBJECT = 'Database'; 

/* 20.  Write a query to display the checkout number, book number, and checkout date of all books checked out before April 8, 2023. */

SELECT C.CHECK_NUM
	, C.BOOK_NUM
	, C.CHECK_OUT_DATE
FROM FACT.CHECKOUT C
WHERE C.CHECK_OUT_DATE < '2023-04-08'; 

/* 21. Write a query to display the book number, title and year of all books published after 2021 and on the subject of "Programming". */

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, B.BOOK_YEAR
FROM FACT.BOOK B
WHERE 
	B.BOOK_YEAR	> '2021' 
	AND
	B.BOOK_SUBJECT = 'Programming';

/* 22. Write a query to display the book number, title, year of publication, subject and cost of all books that are on the subjects of 
	"Middleware" or "Cloud", and that cost more than $70. */

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, B.BOOK_YEAR
	, B.BOOK_SUBJECT
	, B.BOOK_COST
FROM FACT.BOOK B
WHERE
	B.BOOK_SUBJECT IN ('Middleware','Cloud')
	AND
	B.BOOK_COST > '70';

/* 23. Write a query to dsiplay the author ID, first name, last name, and year of birth for all authors born in the decade of the 1980's */

SELECT A.AU_ID
	, A.AU_FNAME
	, A.AU_LNAME
	, A.AU_BIRTHYEAR
FROM FACT.AUTHOR A
WHERE
	AU_BIRTHYEAR BETWEEN 1980 AND 1989; 

/* 24. Write a query to display the book number, title, and year of publication for all books that contain the word "Database" in the title. */

SELECT B.BOOK_NUM
	, B.BOOK_TITLE AS "Title"
	, B.BOOK_YEAR AS "Year Published" 
FROM FACT.BOOK B
WHERE
	B.BOOK_TITLE LIKE '%Database%'; 


/* 25. Write a query to display the patron ID, first and last name of all patrons that are students */

SELECT P.PAT_ID
	, P.PAT_FNAME
	, P.PAT_LNAME
FROM FACT.PATRON P
WHERE
	P.PAT_TYPE = 'Student'; 


/* 26. Write a query to display the patron ID, first and last name, and patron type for all patrons whose last name begins with the letter C */

SELECT P.PAT_ID
	, P.PAT_FNAME
	, P.PAT_LNAME
	, P.PAT_TYPE
FROM FACT.PATRON P
WHERE
	P.PAT_LNAME LIKE 'C%'; 

/* 27. Write a query to display the author ID, first and last name of all authors whose year of birth is unknown' */ 

SELECT A.AU_ID	
	, A.AU_FNAME
	, A.AU_LNAME
FROM FACT.AUTHOR A
WHERE
	A.AU_BIRTHYEAR IS NULL; 

/* 28. Write a query to display the author ID, first and last name of all authors whose
year of birth is known. Sort the results by author last name and then by first
name */

SELECT A.AU_ID
	, A.AU_FNAME
	, A.AU_LNAME
FROM FACT.AUTHOR A
WHERE 
	A.AU_BIRTHYEAR IS NOT NULL
ORDER BY 
	A.AU_LNAME, A.AU_FNAME

/* 29. Write a query to display the checkout number, book number, patron ID, check out
date, and due date for all checkouts that have not been returned yet. Sort the
results by book number. */ 

SELECT 
	C.CHECK_NUM
	, C.BOOK_NUM
	, C.PAT_ID
	, C.CHECK_OUT_DATE
	, C.CHECK_DUE_DATE
FROM 
	FACT.CHECKOUT C
WHERE 
	C.CHECK_IN_DATE IS NULL
ORDER BY 
	C.BOOK_NUM; 

/* 30.  Write a query to display the author ID, first name, last name, and year of birth
for all authors. Sort the results in descending order by year of birth, and then
in ascending order by last name. */ 

SELECT 
	A.AU_ID
	, A.AU_FNAME
	, A.AU_LNAME
	, A.AU_BIRTHYEAR
FROM 
	FACT.AUTHOR A
ORDER BY 
	A.AU_BIRTHYEAR DESC
	, A.AU_LNAME;

/* 31.  Write a query to display the patron ID, full name (first and last), and patron type
for all patrons. Sort the results by patron type, then by last name and first
name. */

SELECT 
	P.PAT_ID
	, CONCAT(P.PAT_FNAME, ' ', P.PAT_LNAME) AS 'NAME'
	, P.PAT_TYPE
FROM 
	FACT.PATRON P
ORDER BY 
	P.PAT_TYPE
	, P.PAT_LNAME
	, P.PAT_FNAME

/* 32. Write a query to display the number of books that are in the FACT system */ 

SELECT COUNT(1) AS 'Number of Books'
FROM 
	FACT.BOOK; 

/* 33. Write a query to display the number of different book subjects in the FACT system */ 

SELECT COUNT( DISTINCT B.BOOK_SUBJECT) AS 'Number of Subjects'
FROM 
	FACT.BOOK B; 

/* 34. Write a query to display the number of books that are available (i.e., not
currently checked out, remember to use the redundant relationship described in the
instructions) */

SELECT COUNT(1) AS 'Available Books'
FROM FACT.BOOK B
WHERE 
	B.PAT_ID IS NULL; 

/* 35. Write a query to display the highest book cost in the system */ 

SELECT FORMAT(MAX(B.BOOK_COST), 'C') AS 'Most Expensive'
FROM FACT.BOOK B; 

/* 36. Write a query to display the lowest book cost in the system */ 

SELECT FORMAT(MIN(B.BOOK_COST), 'C') AS 'Least Expensive'
FROM FACT.BOOK B; 

/* 37. Write a query to display the number of different patrons that have ever checked out a book */ 

SELECT COUNT(DISTINCT C.PAT_ID) AS 'DIFFERENT PATRONS'
FROM  FACT.CHECKOUT C; 

/* 38. Write a query to display the subject and the number of books in each subject. Sort the results by book subject */ 

SELECT B.BOOK_SUBJECT
	, COUNT(B.BOOK_SUBJECT) AS 'Books in Subject'
FROM FACT.BOOK B
GROUP BY 
	B.BOOK_SUBJECT
ORDER BY 
	B.BOOK_SUBJECT; 

/* 39.  Write a query to display the author ID and the number of books written by that
author. Sort the results in descending order by the number of books written, then
in ascending order by author id. */

SELECT W.AU_ID
	, COUNT(W.BOOK_NUM) AS "Books Written"
FROM 
	FACT.WRITES W
GROUP BY W.AU_ID
ORDER BY "Books Written" DESC, W.AU_ID; 

/* 40. Write a query to display the number of checkouts that have occurred in each month.
Sort the results by the number of checkouts in the month in descending order */ 

SELECT FORMAT(C.CHECK_OUT_DATE, 'MMMM') AS 'Month'
	, COUNT(1) AS 'Num Checkouts'
FROM FACT.CHECKOUT C
GROUP BY FORMAT(C.CHECK_OUT_DATE, 'MMMM')
ORDER BY 'Num Checkouts' DESC; 

/* 41. Write a query to display the total value of all books in the library. */ 

SELECT FORMAT(SUM(B.BOOK_COST), 'C') AS 'Library Value'
FROM FACT.BOOK B;

/* 42. Write a query to display the book number and the number of times each book has been
checked out. Do not include books that have never been checked out. Sort the
results by the number of times checked out in descending order, then by book number
in ascending order */

SELECT C.BOOK_NUM, COUNT(1) AS 'Times Checked Out'
FROM FACT.CHECKOUT C
GROUP BY C.BOOK_NUM
ORDER BY 'Times Checked Out' DESC; 

/* 43.  Write a query to display the author ID, first and last name, book number, and book
title of all books in the subject “Cloud”. Sort the results by book title and then
by author last name. */ 

SELECT W.AU_ID
	, CONCAT(A.AU_FNAME,' ', A.AU_LNAME) AS 'AUTHOR_NAME'
	, B.BOOK_NUM
	, B.BOOK_TITLE
FROM FACT.BOOK B
JOIN FACT.WRITES W ON W.BOOK_NUM = B.BOOK_NUM
JOIN FACT.AUTHOR A ON A.AU_ID = W.AU_ID
WHERE 
	B.BOOK_SUBJECT = 'Cloud'
ORDER BY B.BOOK_TITLE, A.AU_LNAME

/* 44. Write a query to display the book number, title, patron ID, last name, and patron
type for all books currently checked out to a patron. Sort the results by book
title. */ 

SELECT C.BOOK_NUM
	, B.BOOK_TITLE
	, C.PAT_ID
	, P.PAT_LNAME
	, P.PAT_TYPE 
FROM 
	FACT.CHECKOUT C
JOIN 
	FACT.BOOK B ON B.BOOK_NUM = C.BOOK_NUM
JOIN 
	FACT.PATRON P ON P.PAT_ID = C.PAT_ID
WHERE
	C.CHECK_IN_DATE IS NULL
ORDER BY 
	B.BOOK_TITLE;

/* 45. Write a query to display the book number, title, and number of times each book has
been checked out. Include books that have never been checked out. Sort the results
in descending order by the number times checked out, then by title. */

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, COUNT(C.BOOK_NUM) AS 'Times Checked Out'
FROM FACT.CHECKOUT C
RIGHT JOIN FACT.BOOK B ON B.BOOK_NUM = C.BOOK_NUM
GROUP BY B.BOOK_NUM, B.BOOK_TITLE
ORDER BY 'Times Checked Out' DESC, B.BOOK_TITLE

/* 46. Write a query to display the book number, title, and number of times each book has
been checked out. Limit the results to books that have been checked out more than
5 times. Sort the results in descending order by the number of times checked out,
and then by title. */ 

SELECT CHECKOUTS.BOOK_NUM
	, CHECKOUTS.BOOK_TITLE
	, CHECKOUTS.[Times Checked Out]
FROM 
(
SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, COUNT(C.BOOK_NUM) AS 'Times Checked Out'
FROM FACT.CHECKOUT C
JOIN FACT.BOOK B ON B.BOOK_NUM = C.BOOK_NUM
GROUP BY B.BOOK_NUM, B.BOOK_TITLE
) AS CHECKOUTS
WHERE 
	CHECKOUTS.[Times Checked Out] > 5
ORDER BY 
	CHECKOUTS.[Times Checked Out] DESC
	, CHECKOUTS.BOOK_TITLE

/* 47.  Write a query to display the author ID, first name, last name, the number of books
written by that author, and the average cost of those books. Limit the results to
include only books that are on the subjects “Cloud” and “Programming”. Also, limit
the results to only authors that have written more than one book in those subjects.
Sort the results by the number of books written in descending order and then in
ascending order by average cost, and then in ascending order by author last name. */

SELECT * 
FROM 
(SELECT A.AU_ID
	, A.AU_FNAME
	, A.AU_LNAME
	, COUNT(W.BOOK_NUM) AS 'Books Written'
	, FORMAT(AVG(B.BOOK_COST),'C') AS 'Average Cost'
FROM FACT.AUTHOR A
JOIN FACT.WRITES W ON W.AU_ID = A.AU_ID
JOIN FACT.BOOK B ON B.BOOK_NUM = W.BOOK_NUM
WHERE B.BOOK_SUBJECT IN ('Cloud', 'Programming')
GROUP BY A.AU_ID, A.AU_FNAME, A.AU_LNAME) AS WRITTEN
WHERE WRITTEN.[Books Written] > 1
ORDER BY WRITTEN.[Books Written] DESC, WRITTEN.[Average Cost], WRITTEN.AU_LNAME


/* 48.  Write a query to display the author ID, author last name, book title, checkout
date, and patron last name for all the books written by authors with the last name
“Bruer” that have ever been checked out by patrons with the last name “Miles” */

SELECT W.AU_ID
	, A.AU_LNAME
	, B.BOOK_TITLE
	, C.CHECK_OUT_DATE
	, P.PAT_LNAME
FROM FACT.WRITES W
JOIN FACT.AUTHOR A ON A.AU_ID = W.AU_ID
JOIN FACT.BOOK B ON B.BOOK_NUM = W.BOOK_NUM
JOIN FACT.CHECKOUT C ON C.BOOK_NUM = B.BOOK_NUM
JOIN FACT.PATRON P ON P.PAT_ID = C.PAT_ID
WHERE A.AU_LNAME = 'Bruer' AND P.PAT_LNAME = 'Miles'; 


/* 49.  Without using a subquery, write a query to display the patron ID, first and last
name of all patrons that have never checked out any book. Sort the result by
patron last name then first name. */ 

SELECT P.PAT_ID
	, P.PAT_FNAME
	, P.PAT_LNAME
FROM FACT.CHECKOUT C
RIGHT JOIN FACT.PATRON P ON P.PAT_ID = C.PAT_ID
WHERE C.CHECK_NUM IS NULL
ORDER BY P.PAT_LNAME, P.PAT_FNAME;


/* 50. Without using a subquery, write a query to display the book number and title of
books that have never been checked out by any patron. Sort the results by book
title */ 

SELECT B.BOOK_NUM
	, B.BOOK_TITLE
FROM FACT.CHECKOUT C
RIGHT JOIN FACT.BOOK B ON B.BOOK_NUM = C.BOOK_NUM
WHERE C.CHECK_NUM IS NULL
ORDER BY B.BOOK_TITLE; 

/* 51. Write a query to display the patron ID, last name, number of times that patron has
ever checked out a book, and the number of different books the patron has ever
checked out. For example, if a given patron has checked out the same book twice,
that would count as 2 checkouts but only 1 book. Limit the results to only patrons
that have made at least 3 checkouts. Sort the results in descending order by
number of books, then in descending order by number of checkouts, then in ascending
order by patron ID. */ 

SELECT *
FROM
(SELECT P.PAT_ID
	, P.PAT_LNAME
	, COUNT(C.CHECK_NUM) AS 'NUM CHECKOUTS'
	, COUNT(DISTINCT C.BOOK_NUM) AS 'NUM DIFFERENT BOOKS'
FROM FACT.PATRON P
JOIN FACT.CHECKOUT C ON C.PAT_ID = P.PAT_ID
GROUP BY P.PAT_ID, P.PAT_LNAME ) AS CHECKOUTS
WHERE CHECKOUTS.[NUM CHECKOUTS] >=3
ORDER BY CHECKOUTS.[NUM DIFFERENT BOOKS] DESC, CHECKOUTS.[NUM CHECKOUTS] DESC, CHECKOUTS.PAT_ID

/* 52. Write a query to display the book number, title, and cost of books that cost more than the average book cost. Sort the results by the book title. */

SELECT B.BOOK_NUM, B.BOOK_TITLE, B.BOOK_COST
FROM FACT.BOOK B
WHERE B.BOOK_COST > (SELECT AVG(B.BOOK_COST) FROM FACT.BOOK B)
ORDER BY B.BOOK_TITLE;

/* 53.  Write a query to display the book number, title, and cost of any book that has a
cost lower than the cost of the cheapest book on the subject of Programming */

SELECT B.BOOK_NUM, B.BOOK_TITLE, B.BOOK_COST
FROM FACT.BOOK B
WHERE B.BOOK_COST < (SELECT MIN(B.BOOK_COST) FROM FACT.BOOK B WHERE B.BOOK_SUBJECT = ('Programming')); 

/* 54.  Without using any type of JOIN, write a query to display the patron ID, first name
and last name of every patron that has never checked out any book. Sort the
results by the patron last name and then first name. (27 rows) */ 


SELECT P.PAT_ID, P.PAT_FNAME, P.PAT_LNAME
FROM FACT.PATRON P
WHERE P.PAT_ID NOT IN (SELECT C.PAT_ID FROM FACT.CHECKOUT C)
ORDER BY P.PAT_LNAME, P.PAT_FNAME

/* 55.  Without using any type of JOIN, write a query to display the book number and title
of the books that have never been checked out. Sort the results by book title. */

SELECT B.BOOK_NUM, B.BOOK_TITLE
FROM FACT.BOOK B
WHERE B.BOOK_NUM NOT IN (SELECT C.BOOK_NUM FROM FACT.CHECKOUT C)
ORDER BY B.BOOK_TITLE; 

/* 56. Write a query to display the author ID, first and last name for all authors that
have never written a book with the subject “Programming”. Sort the results by
author last name. */ 

SELECT DISTINCT A.AU_ID, A.AU_FNAME, A.AU_LNAME
FROM FACT.WRITES W
JOIN FACT.AUTHOR A ON A.AU_ID = W.AU_ID
WHERE A.AU_ID NOT IN (SELECT W.AU_ID FROM FACT.WRITES W JOIN FACT.BOOK B ON W.BOOK_NUM = B.BOOK_NUM WHERE B.BOOK_SUBJECT = 'Programming')
ORDER BY A.AU_LNAME


/* 57. Write a query to display the book number, title, subject, average cost of books
within that subject, and the difference between each book’s cost and the average
cost of books in that subject. Sort the results by book title */ 

SELECT B.BOOK_NUM, B.BOOK_TITLE, B.BOOK_SUBJECT, FORMAT(SUBJECTCOST.[Average Subject Cost],'C') AS 'Avg Subj Cost', FORMAT(B.BOOK_COST - SUBJECTCOST.[Average Subject Cost], 'C')  AS 'DIFFERENCE'
FROM 
(SELECT B.BOOK_SUBJECT, AVG(B.BOOK_COST) AS 'Average Subject Cost'
FROM FACT.BOOK B
GROUP BY B.BOOK_SUBJECT) AS SUBJECTCOST
JOIN FACT.BOOK B ON B.BOOK_SUBJECT = SUBJECTCOST.BOOK_SUBJECT
ORDER BY B.BOOK_TITLE; 

/* 58.  Write a query to display the book number, title, subject, author last name, and the
number of books written by that author. Limit the results to books in the “Cloud”
subject. Sort the results by book title and then author last name */ 


SELECT B.BOOK_NUM
	, B.BOOK_TITLE
	, B.BOOK_SUBJECT
	, AUTHORNUM.AU_LNAME
	, AUTHORNUM.[Num Books by Author]
FROM
(SELECT A.AU_ID
	, A.AU_LNAME
	, COUNT(W.BOOK_NUM) AS 'Num Books by Author'
FROM FACT.WRITES W
JOIN FACT.AUTHOR A ON A.AU_ID = W.AU_ID
GROUP BY A.AU_ID, A.AU_LNAME) AS AUTHORNUM
JOIN FACT.WRITES W ON W.AU_ID = AUTHORNUM.AU_ID
JOIN FACT.BOOK B ON B.BOOK_NUM = W.BOOK_NUM
WHERE B.BOOK_SUBJECT = 'Cloud'
ORDER BY B.BOOK_TITLE, AUTHORNUM.AU_LNAME

/* 59.  Write a query to display the lowest average cost of books within a subject and the
highest average cost of books within a subject. */ 

SELECT FORMAT(MIN(AVGCOST.SubjectAvgCost), 'C') AS 'Lowest Avg Cost', FORMAT(MAX(AVGCOST.SubjectAvgCost),'C') AS 'Highest Avg Cost'
FROM 
(SELECT B.BOOK_SUBJECT, AVG(B.BOOK_COST) AS 'SubjectAvgCost'
FROM FACT.BOOK B
GROUP BY B.BOOK_SUBJECT) AS AVGCOST