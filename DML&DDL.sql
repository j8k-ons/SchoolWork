
/* Create Tables */

create schema bigbear; 
GO
create table bigbear.member(
	mem_num int primary key, 
	mem_lname varchar(20) not null, 
	mem_fname varchar(20) not null, 
	mem_street varchar(30), 
	mem_city varchar(30), 
	mem_state char(2) default 'TN', 
	mem_zip char(5)
);

create table bigbear.account(
	acc_num varchar(7) primary key, 
	acc_opendate date default getdate(), 
	acc_balance decimal(10,2), 
	acc_limit decimal(10,2) default 5000 not null, 
	mem_num int not null, 
	constraint account_mem_num_fk foreign key (mem_num) references bigbear.member);  

/* INSERT COMMANDS */ 
/* Should not be included in applications because table structures will change over time. Always use an insert with an attribute list. */

INSERT INTO bigbear.member VALUES (1, 'Patel', 'Jasmine', '101 Main Street', 'Anytown', 'AL', '35150');

SELECT * FROM bigbear.member

INSERT INTO bigbear.member VALUES (2, 'Johnson', 'Jack', NULL, NULL, NULL, NULL); 

/* Commit and Rollback */ 
/* Transaction sql commands - a logical unit of work. For example, a transfer of $1000 from a savings account to a checking account. It requires two commands, and you want both or neither to happen. */ 
/* Microsoft SMSS uses auto-committ where it treats each individual command as a full transactions. You can change this to wait on the Commit command */ 

SELECT * FROM bigbear.member; 

begin transaction mytransaction;


/* INSERT with attribute list */ 
/* Avoids the problems of depending on order or number of columns in a table */ 

INSERT INTO bigbear.member (mem_num, mem_lname, mem_fname, mem_street, mem_city, mem_zip) VALUES (3, 'Jake', 'Owens', '104 Signal', 'Chattanooga', '37377');
/* Update commands */ 
SELECT * FROM bigbear.member;

UPDATE bigbear.member
SET mem_city = 'Memphis' 
WHERE mem_num = 1; 

-- Alter a table by adding a column 

alter table bigbear.account
add acc_closedate date; 


-- Add a not null constraint to an existing column
alter table bigbear.account
alter column acc_balance decimal(10,2) not null; 

-- Add a default value to an existing column

alter table bigbear.account
add constraint account_balance_dv default 0 for acc_balance; 

-- check constraint (enforces a domain of allowable values)

alter table bigbear.account
add constraint account_bal_limit_ck check (acc_balance <= acc_limit); 

-- DROP table command

DROP TABLE bigbear.account; 

/* Identity columns for surrogate keys */ 

-- Must be defined when we create the table. 

create table bigbear.assignment(
assign_num int identity(100,2) primary key, 
mem_num int not null, 
field_num int not null); 

insert into bigbear.assignment values (2, 13); 

select * from bigbear.assignment