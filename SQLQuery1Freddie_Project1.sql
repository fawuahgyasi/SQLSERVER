USE pubs

/*
Project 1
Freddie (FREDERICK AWUAH-GYASI)
*/
-- 1.--- 
SELECT title_id, title
FROM titles

-- 2.---- 
SELECT fname [first name] , lname [last name] ,emp_id [employee ID], job_lvl [job level]
FROM employee

--3. ----
SELECT title
FROM titles
WHERE title_id = 'PC9999'


--4. ---
SELECT au_lname [author last name], city , state, zip [zip code]
FROM authors
WHERE zip > '90000'

--5. ---
SELECT title, price 
FROM titles
WHERE price BETWEEN 10 AND 15

--6. ---
SELECT emp_id [employee ID], lname [last name], job_lvl [job level]
FROM employee
WHERE job_lvl IN (35,100,200)

---7. ---
SELECT title_id,title 
FROM titles
WHERE title LIKE '%computer%'


---8. ---
SELECT * 
FROM stores
WHERE stor_name LIKE '[D,E]%'


---9.---
SELECT * 
FROM titles
WHERE royalty IS NULL

---10.----
SELECT stor_id [store ID], title_id [title ID],ord_date [order date],qty [quantity sold]
FROM sales
WHERE (YEAR(ord_date) = 1994) AND ((qty>20) OR (payterms = 'Net 30'))





