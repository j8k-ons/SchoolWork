
-- SCHEMA
CREATE SCHEMA FACT; 

-- COPY TABLES INTO SCHEMA FACT

SELECT * INTO STU279DB.FACT.AUTHOR FROM STARTERDB.FACT.AUTHOR; 
SELECT * INTO STU279DB.FACT.BOOK FROM STARTERDB.FACT.BOOK; 
SELECT * INTO STU279DB.FACT.CHECKOUT FROM STARTERDB.FACT.CHECKOUT; 
SELECT * INTO STU279DB.FACT.PATRON FROM STARTERDB.FACT.PATRON; 
SELECT * INTO STU279DB.FACT.WRITES FROM STARTERDB.FACT.WRITES; 

-- When making a mistake how do we get it back? 

-- Drop the tables, then recreate it by copying from the StarterDB database


-- GO Command
-- Seperates comamands into seperate batches. When we press execute, it runs all the files in the command. 

select * from sys.schemas; 