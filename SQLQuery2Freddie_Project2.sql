use pubs

--1--
SELECT emp_id [Employee ID], fname [First name], lname [Last name], CONVERT(char(12),hire_date,107) [Hire date]
FROM employee

--2--
SELECT MONTH(ord_date) [MONTH(1993)],SUM(qty) [Total Orders]
FROM sales
WHERE YEAR(ord_date) = 1993
GROUP BY MONTH(ord_date)

--3--
SELECT title_id,SUM(qty) [Total quantity ordered]
FROM sales
GROUP BY title_id
HAVING SUM(qty) > = 50

--4----

SELECT DATEDIFF(dd,MAX(hire_date),GETDATE()) [Days since the last hire] 
FROM employee

---5---
SELECT DATEDIFF(YEAR,'March 6,1984',GETDATE()) [AGE 1],
       DATEDIFF(YEAR,'September 7,1944',GETDATE()) [AGE 2]
       
--6---
SELECT type [Type],AVG(price) [Average price]
FROM titles
WHERE type LIKE '%cook'
GROUP BY type
       
--7---
SELECT title_id,title,type,pub_id,price,ISNULL(royalty,0) royalty
FROM titles 

-- 8---
SELECT power(2.0,32) [2 to the 32nd power]

---9---
ALTER TABLE AuditTrail
ALTER Column WhoDoneit
ADD CONSTRAINT DF_WhoDoneIT DEFAULT SYSTEM_USER FOR WhoDoneIt
 

---10-----
/*
ALTER TABLE Whse.InStock
ADD SKUd Varchar(20)
*/

UPDATE Whse.InStock
SET SKUd = LTRIM(SKU)


---11----

 UPDATE POINTS
 SET X = CAST(SUBSTRING(Point,2,CHARINDEX(',',point)-2) AS DECIMAL(38,10)),
     Y = Cast(SUBSTRING(Point,CHARINDEX(',',Point)+1,LEN(Point)-CHARINDEX(',',Point)-1) AS DECIMAL (38,10))
     
     
---12---

SELECT DB_ID('AdventureWorks')
SELECT OBJECT_ID('AdventureWorks.Production.Product')
DECLARE @tableid  int;

Use Adventureworks

go

SELECT database_id, index_id, index_type_desc, index_depth, index_level

, avg_fragmentation_in_percent, fragment_count, page_count

FROM sys.dm_db_index_physical_stats

( DB_ID('AdventureWorks') -- database id

, OBJECT_ID('AdventureWorks.Production.Product') -- table object id

, NULL -- index_id; NULL -> ALL indexes

, NULL -- partition_number; NULL -> ALL

,'DETAILED' -- mode: NULL (the default) | DEFAULT |

) -- 'LIMITED' | 'SAMPLED' | 'DETAILED'

go 
