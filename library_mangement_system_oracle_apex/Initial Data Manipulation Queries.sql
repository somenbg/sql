---------------------------------------------------
--Seperating multiple authors and reformatting some junk
select isbn10,isbn13,author from books where author like '%;%';

select * from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) 
where part_5 is not null;

create table author(
    author_id number(10) not null,
    name varchar2(50) not null);
    
select isbn13,part_1,part_2,part_3,part_4,part_5 from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) ;
--Creating temporary tables for authors prior to load
create table auth_temp (isbn int,
    name varchar2(255));
create table auth_temp1 (isbn int,
    name varchar2(255));

insert into AUTH_TEMP(
select isbn13,part_1 from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) 
union
select isbn13,part_2 from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) where part_2 is not null
union
select isbn13,part_3 from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) where part_3 is not null
union
select isbn13,part_4 from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) where part_4 is not null
union
select isbn13,part_5 from (
SELECT b.*
,REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b) where part_5 is not null);
truncate table auth_temp;
insert into auth_temp(
SELECT REGEXP_SUBSTR (author, '[^,]+', 1, 1) AS part_1
, REGEXP_SUBSTR (author, '[^,]+', 1, 2) AS part_2
, REGEXP_SUBSTR (author, '[^,]+', 1, 3) AS part_3
, REGEXP_SUBSTR (author, '[^,]+', 1, 4) AS part_4
, REGEXP_SUBSTR (author, '[^,]+', 1, 5) AS part_5
FROM books b where author like '%;%');
select * from auth_temp where name like '%;%';

select isbn,part_1 from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\&]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\&]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\&]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%');
select isbn,part_2 from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\&]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\&]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\&]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%') where part_2 is not null;
select isbn,part_3 from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\&]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\&]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\&]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%') where part_3 is not null
;

--Inserting an unique data row
insert into auth_temp1 (
select isbn,replace(name,'?',' ') from auth_temp where name like '%?%');

--Inserting already cleaned data
insert into auth_temp1(
select isbn,name from (
select isbn,name from ( 
select isbn,name from auth_temp where name not like '%?%')where name not like '%&%')where name not like '%;%');

SET ESCAPE ON;--This is too include "&" in the query
select * from AUTH_TEMP where name like '%\&amp%';

SELECT isbn,REGEXP_SUBSTR (name, '[^\&]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\&]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\&]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%';

select isbn,trim(part_3||part_11||part_2) from (
select isbn,REGEXP_SUBSTR (part_1, '[^\&]+', 1, 1) AS part_11,part_2,part_3 from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\;]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\;]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\;]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%' ));

--Inserting reformatted and cleaned data
insert into AUTH_TEMP1 (
select isbn,trim(part_3||part_11||part_2) from (
select isbn,replace(part_1,'\&amp','\&') as part_11,part_2,part_3 from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\;]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\;]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\;]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%')));

select isbn,replace(part_1,'\&amp','\&'),part_2,part_3 from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\;]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\;]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\;]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%');

select count(unique(isbn)) from AUTH_TEMP1;
select * from AUTH_TEMP1 where isbn=9780671720797;

select isbn,part_1||part_22||part_21 from (
select isbn,part_1,REGEXP_SUBSTR(part_2, '[^\;]+', 1, 2) AS part_21
,REGEXP_SUBSTR(part_2, '[^\;]+', 1, 3) AS part_22
from (
SELECT isbn,REGEXP_SUBSTR (name, '[^\&]+', 1, 1) AS part_1
, REGEXP_SUBSTR (name, '[^\&]+', 1, 2) AS part_2
, REGEXP_SUBSTR (name, '[^\&]+', 1, 3) AS part_3
FROM auth_temp b where name like '%;%') where part_2 is not null);

select * from AUTH_TEMP
minus
select * from AUTH_TEMP1;
------------------------------------------
--Seperate author name and isbn. Create 2 seperate tables. Generate primary key using sequence.
--Creating a sequence for unique records
CREATE SEQUENCE test_seq
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;

--To add column to a table
alter table auth_temp1 add author_id int ;

--Inserting author_id using sequence
update auth_temp1 set AUTHOR_ID=test_seq.nextval;

create table book_authors(
    author_id int not null,
    isbn int not null);
    
insert into book_AUTHORS (select author_id,isbn from auth_temp1);

select * from BOOK_AUTHORS;

create table authors(
    author_id int,
    name varchar2(100));

--Inserting only unique authors
insert into authors(name) (select unique(name) from AUTH_TEMP1);
update authors set AUTHOR_ID=test_seq.nextval;
insert into book_authors (select b.author_id,a.isbn from AUTH_TEMP1 a join authors b on a.name=b.name);
-----------------------------------------------------------------------------------------
--Seperating title from books.
create table book(
    isbn int,
    title varchar2(255));
insert into book (select isbn13,title from books);
------------------------------------------------------------------------------------------
--Creating book_copies
create table book_copies_temp(
    book_id varchar2(20),
    isbn int,
    branch_id int,
    copies int);
select * from book_copies_temp;
create table book_copies(
    book_id varchar2(20),
    isbn int,
    branch_id int);

insert into book_copies_temp (select a.book_id,b.isbn13,a.branch_id,a.no_of_copies from book_copies_main a join books b on a.book_id=b.isbn10);    

insert into book_copies (select a.book_id,b.isbn13,a.branch_id from book_copies_main a join books b on a.book_id=b.isbn10);    
--------------------------------------------------------------------------------------------------------
create table book_loans(
    loan_id int,
    book_id varchar2(20),
    card_no varchar2(20),
    date_out date,
    due_date date,
    date_in date);
    
create table fines(
    loan_id int,
    fine_amt int,
    paid varchar2(10));
----------------------------------------
select * from book;--main book for book_authors and book_copies
select * from book_authors;
select * from authors;--main author for book_authors
select * from library_branch;--main library for book_copies
select * from book_copies;--main for book_loans
select * from book_copies_temp;--main for book_loans but includes no_of_copies
select * from borrowers;--for book_loans
select * from book_loans;--card_no==borrower_id--each loan automatically generates a loan_id and date_out
select * from fines;--if date_in is greater than due_date the loan_id moves to fines table

--More Junk
SELECT * FROM authors
minus
SELECT * FROM authors 
WHERE REGEXP_LIKE(name,'[ A-Za-z0-9.{}[]|]');

SELECT * FROM authors where name like '%ダン・デプロスペロ%';

select * from authors where name like '%' ||chr(194) || '%';

SELECT
     special_char,
     COUNT (*)
FROM
(
SELECT author_id,
SUBSTR(name,REGEXP_INSTR (name, '[^a-z|A-Z|0-9| ]'),1) special_char
FROM authors
WHERE REGEXP_LIKE (name, '[^a-z|0-9| ]', 'i')
) temp
GROUP BY special_char;

select * from books where author like '%�%';
---------------------------------------------
desc book_loans;
drop table book_loans;
create table book_loans(
    loan_id int,
    book_id varchar2(20),
    card_no varchar2(20),
    branch_id int,
    date_out date,
    due_date date,
    date_in date);



select count(unique(BOOK_ID||isbn||Branch_id)) from book_copies;
-----------------------------------------------------------------

select * from book;--main book for book_authors and book_copies
select * from book_authors;
select * from authors;--main author for book_authors
select * from library_branch;--main library for book_copies
select * from book_copies;--main for book_loans
select * from book_copies_main;
select * from book_copies_temp;
select * from borrowers;--for book_loans
select * from book_loans;--card_no==borrower_id--each loan automatically generates a loan_id and date_out
select * from fines;--if date_in is greater than due_date the loan_id moves to fines table

drop SEQUENCE loan_seq;
CREATE SEQUENCE loan_seq
START WITH 100000
INCREMENT BY 1
NOCACHE
NOCYCLE;

insert into book_loans(BOOK_ID,card_no,BRANCH_ID,DATE_OUT) values
((select book_id from (select * from book_copies order by dbms_random.value) where rownum<600),
(select borrower_id from (select * from borrowers order by dbms_random.value) where rownum<600),
(select branch_id from (select * from book_copies order by dbms_random.value) where rownum<600),
(select * from (select to_date('2015-01-01', 'yyyy-mm-dd')+trunc(dbms_random.value(1,1000)) from book_copies) where rownum<600));

desc book_loans;

select count(*) from book sample(3);
insert into book_loans(BOOK_ID) (select borrower_id from (select * from borrowers order by dbms_random.value) where rownum<600);
select book_id from (select * from book_copies order by dbms_random.value) where rownum<600; --- book_id

select borrower_id from (select * from borrowers order by dbms_random.value) where rownum<600; --- card_no

select branch_id from (select * from book_copies order by dbms_random.value) where rownum<600; --- branch_id

select * from (select to_date('2015-01-01', 'yyyy-mm-dd')+trunc(dbms_random.value(1,1000)) from book_copies) where rownum<600;

select * from (select loan_seq.nextval from book_copies) where rownum<600;

desc book_loans;
create table book_temp(
    bid varchar(20));
create table card_temp(
    bid varchar(20));
create table branch_temp(
    bid int);
create table out_temp(
    bid date);
create table due_temp(
    bid date);
create table in_temp(
    bid date);
insert into loan_temp values (loan_seq.nextval);

select count(loanid) from loan_temp;


truncate table loan_temp;
select loan_seq.nextval from dual where rownum<600;

/*Generate loan id
BEGIN 
    FOR x IN 1 .. 599 LOOP
         INSERT INTO loan_temp (LOANID)
         select book_id from (select * from book_copies order by dbms_random.value) where rownum<600;
    END LOOP;
END;
*/

insert into book_loans(loan_id) (select loanid from loan_temp);
select * from book_loans where date_out is not null;
select * from loan_temp;
/*
BEGIN 
    FOR x IN 1 .. 599 LOOP
         INSERT INTO loan_temp (LOANID)
         select round(dbms_random.value(1,10)) from dual;
    END LOOP;
END;*/

select round(dbms_random.value(1,10)) from dual;

truncate table book_temp;

insert into book_temp (select book_id from (select * from book_copies order by dbms_random.value) where rownum<600);
insert into card_temp (select borrower_id from (select * from borrowers order by dbms_random.value) where rownum<600);
insert into branch_temp (select branch_id from (select * from book_copies order by dbms_random.value) where rownum<600);
insert into out_temp (select * from (select to_date('2015-01-01', 'yyyy-mm-dd')+trunc(dbms_random.value(1,1000)) from book_copies) where rownum<600);
insert into due_temp (select bid+7 from out_temp);
insert into in_temp(bid) (select bid+(select round(dbms_random.value(1,10)) from dual) from out_temp);

drop table date_master;
create table date_master(
    d1 date,d2 date,d3 date);
    
select * from loan_temp;
truncate table loan_temp;
insert into date_master (select bid,bid+7,bid+dbms_random.value(1,10) from out_temp);

select * from date_master;

truncate table in_temp;
select * from due_temp;
select * from in_temp;

update book_loans set card_no=(select borrower_id from (select * from borrowers order by dbms_random.value) where rownum<600) where book_id is not null;

select a.bid,b.bid,c.bid,d.d1,d.d2,d.d3 from book_temp a join card_temp b on a.id=b.id join branch_temp c on c.id=b.id join date_master d on d.id=c.id;
select * from book_temp a join card_temp b on a.id=b.id join branch_temp c on c.id=b.id join out_temp d on d.id=c.id join due_temp e on e.id=d.id join in_temp f on f.id=e.id where a.bid='0440180953';

desc book_loans;

insert into book_loans(BOOK_ID,card_no,BRANCH_ID,DATE_OUT,DUE_DATE,DATE_IN)
(select a.bid,b.bid,c.bid,d.d1,d.d2,d.d3 from book_temp a join card_temp b on a.id=b.id join branch_temp c on c.id=b.id join date_master d on d.id=c.id);

select * from book_loans;
update book_loans set loan_id=temp_seq.nextval;

truncate table book_loans;
drop table fines_temp;
create table fines_temp as select * from book_loans where date_in-date_out>8;
select date_in-date_out from book_loans where date_in-date_out>8;
select * from book_loans where date_in-date_out>8;

drop sequence temp_seq;
CREATE SEQUENCE temp_seq
START WITH 1000
INCREMENT BY 1
NOCACHE
NOCYCLE;
desc book_temp;
alter table date_master add id int;
update date_master set id=temp_seq.nextval;
--------------------------------------------------
create table fines_temp as select * from book_loans where date_in-date_out>8;
select * from fines_temp;
alter table fines_temp drop column days;
select (round(date_in-DATE_OUT)-7)*2 from fines_temp;--- fine amount
desc fines;
select round(DBMS_RANDOM.VALUE (0, 1)) from dual; --- yes/no
create table status(
    status int);
/*
BEGIN 
    FOR x IN 1 .. 149 LOOP
         INSERT INTO status (status)
         select round(DBMS_RANDOM.VALUE (0, 1)) from dual;
    END LOOP;
END;*/
select * from status;
alter table fines_temp add id int;
update fines_temp set id=temp_seq.nextval;
truncate table status;
insert into fines (select a.loan_id,(round(a.date_in-a.DATE_OUT)-7)*2,b.stat from fines_temp a join status b on a.id=b.id);
select * from fines;

select * from fines a join book_loans b on a.loan_id=b.loan_id join borrowers c on c.borrower_id=b.card_no where a.paid='YES';
-------------------------------
drop table incre_table;

CREATE TABLE incre_table (
 column_id int,
 column_description VARCHAR2(50)
);

alter table incre_table add (col_id number GENERATED BY DEFAULT ON NULL AS IDENTITY);
alter table incre_table modify column_id GENERATED BY DEFAULT ON NULL AS IDENTITY;


select * from incre_table;
truncate table incre_table;

insert into incre_table(column_description) values ('djkdasddaasahadkdh');

insert into incre_table values (NULL,'djkdasddaasahadkdh');

--------------------------------------------------------------------
/*
select * from sxb180023.BORROWERS;

select max(borrower_id) from borrowers;

drop sequence test1;

CREATE SEQUENCE test1
START WITH 001003
INCREMENT BY 1
NOCACHE
NOCYCLE;

to_char(test1.nextval, '000099');
create or replace trigger BORROWERS_T1
BEFORE
insert or update or delete on sxb180023.borrowers
for each row
begin
BEGIN
  SELECT 'ID' || to_char(test1.NEXTVAL,'000099')
  INTO   :new.borrower_id
  FROM   dual;
END;
end;

select to_char(test1.nextval, '000099') from dual;*/
---------------------------------------------
--To merge back the authors
SELECT isbn,book_id,title,
       LISTAGG(name, ', ') WITHIN GROUP (ORDER BY name) AS names,branch_id,copies
  FROM (
       select unique(c.isbn),c.book_id,b.title,a.name,c.copies,c.branch_id from book_copies_temp c join book b on c.isbn=b.isbn join book_authors d on b.isbn=d.isbn join authors a on d.author_id=a.author_id
       )
 GROUP BY isbn,book_id,title,branch_id,copies;














