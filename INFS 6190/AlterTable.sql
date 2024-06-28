
-- ALTER TABLE 
CREATE SCHEMA bigbear; 

CREATE TABLE stu513db.bigbear.account(
	acc_num varchar(7) primary key, 
	acc_opendate date default getdate(), 
	acc_balance decimal(10,2), 
	acc_limit decimal(10,2) default 5000 not null, 
	mem_num int not null, 
	constraint account_mem_num_fk foreign key(mem_num) references bigbear.member
	); 

ALTER TABLE bigbear.account
add acc_closedate date; 

ALTER TABLE bigbear.account
alter column acc_balance decimal(10,2) not null; 