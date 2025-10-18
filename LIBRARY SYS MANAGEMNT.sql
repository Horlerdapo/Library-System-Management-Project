
-- CREATING DATABASE LIBRARY SYSTEM MANAGEMENT

CREATE DATABASE library_system_management;
USE library_system_management;

DROP TABLE IF EXISTS books;
CREATE TABLE books (
	isbn VARCHAR(50) PRIMARY KEY,	
    book_title VARCHAR(50),
	category VARCHAR(50),	
    rental_price FLOAT,	
    status VARCHAR(50),
    author VARCHAR(50),	
    publisher VARCHAR(50)
);


DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
	branch_id VARCHAR(50) PRIMARY KEY,	
    manager_id VARCHAR(50),
	branch_address VARCHAR(50),
	contact_no VARCHAR(50)
);


DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	emp_id	VARCHAR(50) PRIMARY KEY,
    emp_name VARCHAR(50),
	position VARCHAR(50),
	salary FLOAT,
	branch_id VARCHAR(50)
);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
	issued_id VARCHAR(50) PRIMARY KEY,
	issued_member_id VARCHAR(50),
	issued_book_name VARCHAR(50),
	issued_date DATE,
	issued_book_isbn VARCHAR(50),
	issued_emp_id VARCHAR(50)
);


DROP TABLE IF EXISTS members;
CREATE TABLE members (
	member_id VARCHAR(50) PRIMARY KEY,
	member_name VARCHAR(50),
	member_address VARCHAR(50),
	reg_date DATE
);


DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status (
	return_id VARCHAR(50) PRIMARY KEY,
	issued_id VARCHAR(50),
	return_book_name VARCHAR(50),
	return_date DATE,
	return_book_isbn VARCHAR(50)
);


SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;


-- DATA MODELLING

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);


ALTER TABLE issued_status
ADD CONSTRAINT fk_isbn
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);


ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);


ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


-- PROJECT TASK (QUESTIONS)

/* -- TASK 1. CREATE A NEW BOOK RECORD ('978-6-129-456-2', 'To kill a mockingbird', 'classic', 6.00,
	'yes', 'Harper', 'Lee', 'J.B Lippincott & Co.') */
    
   INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
   VALUES ('978-1-06-129456-2', 'To kill a mockingbird', 'classic', 6.00,
	'yes', 'Harper Lee', 'J.B Lippincott & Co.');
 
 
 
 /*TASK 2. UPDATE AN EXISTING MEMBER'S ADDRESS*/
 
UPDATE members
SET member_address = 'Otokiti Housing Estate'
WHERE member_id = 'c101';


 /*TASK 3. DELETE RECORD FROM THE ISSUED_STATUS TABLE
 OBJECTIVES: DELETE RECORD WITH ISSUED ID = IS104*/
 
 DELETE FROM issued_status
 WHERE issued_id = 'IS140';
 
 
  /*TASK 4. RETRIEVE ALL BOOKS ISSUED BY A SPECIFIC EMPLOYEE WITH ID = E101*/
  
  SELECT ist.issued_book_name,
		ep.emp_id
  FROM issued_status ist
  JOIN employees ep
  ON ep.emp_id = ist.issued_emp_id
  WHERE ep.emp_id = 'E101';
  
  
   /*TASK 5. LIST MEMBERS WHO HAVE ISSUED MORE THAN ONE BOOK*/ 
   
   SELECT COUNT(member_id) AS no_of_members,
		ist.issued_book_name
   FROM members m
   JOIN issued_status ist
   ON ist.issued_member_id = m.member_id
   GROUP BY ist.issued_book_name
   HAVING COUNT(member_id) > 1 ;
   
   
   /*TASK 6. CREATE SUMMARY TABLE TO GENERATE NEW TABLES BASED ON QUERY BOOK TITLE AND TOTAL BOOK ISSUED COUNT*/
   
   CREATE TABLE total_book_issued
   AS
   SELECT 
		bk.book_title,
		COUNT(ist.issued_member_id) AS Total_book_issued
   FROM books bk
   JOIN issued_status ist
   ON bk.isbn = ist.issued_book_isbn
   GROUP BY bk.book_title;
   
   
   
   /*TASK 7. RETRIEVE ALL BOOKS IN A SPECIFIC CATEGORY 'CLASSIC'*/
   
   SELECT *
   FROM books
   WHERE category = 'classic';
   
   
   /*TASK 8. FIND TOTAL RENTAL INCOME BY CATEGORY*/
   
   SELECT category,
		SUM(rental_price) AS total_rental_price
   FROM books
   GROUP BY category;
   
   
   /*TASK 9. LIST MEMBERS WHO REGISTERED IN THE LAST 180 DAYS*/
   
   SELECT *
   FROM members
   WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;
   
   
   -- I HAD TO INSERT RECENT DATES INTO MEMBERS TABLE, ELSE THE TABLE WOULD RETURN NOTHING
   
   INSERT INTO members (member_id, member_name, member_address, reg_date)
   VALUES ('C120', 'Oluwatosin Akande', 'Otokiti Estate', '2025-07-15'),
		('C122', 'Oladapo Akande', 'Otokiti Estate', '2025-09-04');
        
        
/*TASK 10. LIST EMPLOYEES WITH THEIR BRANCH MANAGERS NAME & BRANCH DETAILS*/

SELECT *
FROM employees ep
JOIN branch br
ON br.branch_id = ep.branch_id;

SELECT *
FROM branch
