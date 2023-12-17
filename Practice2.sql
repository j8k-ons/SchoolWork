
/* SQL Practice 2 */

CREATE SCHEMA Practice2; 

CREATE TABLE Practice2.Committee(
	Com_Num numeric(3,0) primary key, 
	Com_Name varchar(45) unique not null, 
	Com_Points numeric(2,0)
)

CREATE TABLE Practice2.Member (
	Mem_Num int primary key, 
	Mem_FName varchar(15) not null, 
	Mem_LName varchar(15) not null,
	Mem_Phone char(7)
)
CREATE TABLE Practice2.Roster (
	Com_Num numeric(3,0),
	Mem_Num int,
	Roster_Role varchar(7) CHECK (Roster_Role IN ('CHAIR','VICE','MEMBER')), 
	Roster_Date date, 
	Roster_Multiplier numeric(2,1) default 1,
	PRIMARY KEY (Com_Num, Mem_Num),
	FOREIGN KEY (Com_Num) REFERENCES Practice2.Committee (Com_Num),
	FOREIGN KEY (Mem_Num) REFERENCES Practice2.Member (Mem_Num)
)

/* 2. Inserts */

INSERT INTO Practice2.Member (Mem_Num, Mem_FName, Mem_LName, Mem_Phone) VALUES (1111,'Sam', 'Waters','1234567'),(2222,'Nicholas', 'Dearing', '2345678'),(3333,'Telly','Makems',''),(4444,'Carlos','Arias','4567890'); 

SELECT * FROM Practice2.Member;

INSERT INTO Practice2.Committee (Com_Num, Com_Name, Com_Points) VALUES (101,'FunRun',2),(102,'DonorWall',3),(119,'MealsOnWheels',10); 

SELECT * FROM Practice2.Committee; 

INSERT INTO Practice2.Roster (Com_Num, Mem_Num, Roster_Role, Roster_Date, Roster_Multiplier)
VALUES 
	(101, 3333, 'CHAIR', '2020-05-23',1),
	(101, 2222, 'MEMBER','2020-05-28',.8),
	(119, 1111, 'VICE', '2020-06-01',1.5),
	(102, 2222, 'CHAIR','2020-06-02',2.5),
	(102, 4444, 'MEMBER', '2020-05-11', 1),
	(119, 4444, 'MEMBER', '2020-05-23', 1.5); 


SELECT * FROM Practice2.Roster; 

BEGIN TRANSACTION practice2transaction; 

UPDATE Practice2.Member
SET Mem_Phone = '5678901'
WHERE Mem_Num = 4444; 

DELETE FROM Practice2.Roster
WHERE Mem_Num = 2222 AND Com_Num = 102; 

UPDATE Practice2.Roster
SET Roster_Date = '2020-04-10'
WHERE Mem_Num = 3333 AND Com_Num = 101; 

ALTER TABLE Practice2.Roster
ADD CONSTRAINT MaxMinMulti CHECK (Roster_Multiplier >= 0 OR Roster_Multiplier <= 3)

UPDATE Practice2.Roster
SET Roster_Multiplier = 1.8
WHERE Mem_Num = 2222 AND Com_Num = 101; 

UPDATE Practice2.Committee
SET Com_Points = 5
WHERE Com_Num = 119; 

COMMIT; 

BEGIN TRANSACTION Practice2Transaction2; 

DELETE FROM Practice2.Roster
WHERE Com_Num = 119

DELETE FROM Practice2.Committee
WHERE Com_Num = 119 

UPDATE Practice2.Committee
SET Com_Points = Com_Points + 2

ROLLBACK; 