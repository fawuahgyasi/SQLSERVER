---Date: Nov, 7, 2013

---Join Simulation 

CREATE TABLE Employee
(
EID INT, 
Name Varchar(10)
)

CREATE TABLE ADDRESS
(
EID INT,
CITY varchar (10),
State Char(2)
)

INSERT INTO Employee Values (1,'ABC'),(2,'DEF'),(3,'xyz'),(4,'PQR'),(5,'WXY')
INSERT INTO ADDRESS (EID,CITY,State) Values (1,'Poway','CA'),(2,'San Diego','CA'),(3,'Pomerado','PA'),(6,'LaJolla','TX'),(7,'Civic','LA')

SELECT * FROM Employee
SELECT * from ADDRESS


--INNER JOIN

SELECT * FROM Employee E 
INNER JOIN ADDRESS A
ON A.EID= E.EID

--FULL OUTER JOIN
SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID

-- INNER JOIN FROM FULL OUTER JOIN
SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID
WHERE A.EID is NOT NULL and E.EID IS NOT NULL


--- LOJ from FOJ

SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID
WHERE E.EID is NOT NULL
---LOJ
SELECT * FROM Employee E 
LEFT OUTER JOIN ADDRESS A
ON A.EID= E.EID

--RESTRICTED LOJ from FOJ

SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID
WHERE A.EID is null and E.EID is not null 


--ROJ from full outer join

SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID
WHERE A.EID is not null


--- RESTRICTED ROJ from full outer join

SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID
WHERE A.EID is not null and E.EID is NULL

--RESTRICTED FULL OUTER JOIN

SELECT * FROM Employee E 
FULL OUTER JOIN ADDRESS A
ON A.EID= E.EID
WHERE A.EID is  null or E.EID is null

-- WE CAN simulate all types of joins using FOJ excetp Cross JOIN --
-- Cross Join--
/*
Cross join is the cartisian product of all the row from the left table with all the rows from the right table.
*/

SELECT * from 
Employee,ADDRESS

--OR--

SELECT * from Employee
CROSS JOIN ADDRESS
CROSS JOIN Test


USE AdventureWorks

SELECT COUNT(*),HRE2.ManagerID,HRE2.Title,PC.FirstName,PC.LastName 
FROM HumanResources.Employee HRE
 INNER JOIN HumanResources.Employee hre2 
 On hre2.EmployeeID = hre.ManagerID
 inner JOIN Person.Contact pc
 ON PC.ContactID = HRE2.ContactID
GROUP BY HRE2.ManagerID,HRE2.Title,PC.FirstName,PC.LastName
hAVING COUNT(*) > =6
oRDER BY 1 dESC


SELECT DISTINCT HRE1.EmployeeID, HRE2.ManagerID, HRE1.Title,PC.Firstname,PC.LastName,
(PA.AddressLine1 + PA.AddressLine2) 'Address' from HumanResources.Employee HRE1
INNER JOIN HumanResources.Employee HRE2
ON HRE1.EmployeeID = HRE2.ManagerID
INNER JOIN Person.Contact PC
ON HRE1.ContactID = PC.ContactID
INNER JOIN HumanResources.EmployeeAddress HEA
ON HEA.EmployeeID = HRE1.EmployeeID
INNER JOIN Person.Address PA
ON pA.AddressID = HEA.AddressID
--47: Managers
--290: Employee
--243 - Not mangers


-- GET the information of all employees who are not managers


SELECT  HRE1.EmployeeID, HRE1.ManagerID, HRE1.Title,PC.Firstname,PC.LastName,
(PA.AddressLine1 + PA.AddressLine2) 'Address' from HumanResources.Employee HRE1
LEFT OUTER JOIN HumanResources.Employee HRE2
ON HRE1.EmployeeID = HRE2.ManagerID
INNER JOIN Person.Contact PC
ON HRE1.ContactID = PC.ContactID
LEFT JOIN HumanResources.EmployeeAddress HEA
ON HEA.EmployeeID = HRE1.EmployeeID
INNER JOIN Person.Address PA
ON pA.AddressID = HEA.AddressID
WHERE HRE2.ManagerID is NULL

SELECT  DISTINCT HRE1.EmployeeID, HRE1.ManagerID, HRE1.Title,PC.Firstname,PC.LastName,
(PA.AddressLine1 + PA.AddressLine2) 'Address' from HumanResources.Employee HRE1
LEFT OUTER JOIN HumanResources.Employee HRE2
ON HRE1.EmployeeID = HRE2.ManagerID
INNER JOIN Person.Contact PC
ON HRE1.ContactID = PC.ContactID
LEFT JOIN HumanResources.EmployeeAddress HEA
ON HEA.EmployeeID = HRE1.EmployeeID
INNER JOIN Person.Address PA
ON pA.AddressID = HEA.AddressID
WHERE HRE1.ManagerID IS NULL

--Sbuqueries
/*RETrieve EmployeeID, Firstname, Lastname of all employees. 
*/

---Using joins
SELECT HRE.EMployeeID ,PC.FIrstname,PC.Lastname from HumanResources.Employee HRE
INNER JOIN Person.Contact PC
ON PC.ContactID = HRE.ContactID


SELECT EmployeeID From HumanResources.Employee
WHERE ContactID IN (Select ContactID From Person.Contact)




/* 1. What are the differences between joins and sub-queries
   2. What are the limitations of sub queries
   3 What are the selections quidelines for Sub-Queries
   4. What are sub-queries
   
   */
   
   SELECT EmployeeID from HumanResources.Employee
   WHERE EmployeeID not in (Select ManagerID from HumanResources.Employee WHERE ManagerID is not null)

   SELECT EmployeeID from 
   HumanResources.Employee HRE
   LEFT OUTER JOIN Sales.SalesPerson SS
   ON HRE.EmployeeID = SS.SalesPersonID
   WHERE SS.SalesPersonID IS NULL
   
   
   SELECT EmployeeID from HumanResources.Employee 
   WHERE EmployeeID not in (Select SalesPersonID from Sales.SalesPerson)
   
   
   --- SET OPERATORS
   
   /*
   UNION,UNION ALL, EXCEPT, INTERSECT
   Syntax: 
   SELECT Col1,Col2,Col3 FROM T1
   UNION/UNION ALL/EXCEPT/INTERSECT
   Rules: 
   1. The no. of columns in first SELECT Statement must be same as no. of columns in second SELECT statement. 
   2. The metadata of all the columns in first SELECT statement MUST e exactly same as the metadata of all coumns in second 
   SELECT Statement accordingly.
   3. Dont use * operator in either of the query
   4. ORDER BY clause do not work first SELECT Statement 
   */
   
   /* Hierachy --
   1. Joins (Joins 2 or more tables horizontally)
   2. Sub-Queries
   3. SET Operators (joins 2 or more tables vertically)
   */
   
   
   /*-- In class assigment --
   1. Get me the informatoin of all employees who are NOT managesr and ahre being managed by atleast 3 Employees who are managess
   2. Get the information of all intermediate level Managers( Hint All managesr except CEO)
   3. Get the info of all Managers who Manage two or more managers which intern manges at least 2 employees who are not Managers (leaf-level employee)
   4.Get me a dataset that shows all employees that make more than the averate rate
   5.Return all the employ
   */
   
   /*
   Solution
   */
   
   --1
   
   
   
   --2. 
select mANAGERiD , COUNT(EMPLOYEEid) [number of EMPLOYEES] FROM HumanResources.Employee 
where ManagerID not IN (
(Select ManagerID from HumanResources.Employee
WHERE EmployeeID NOT IN 
(Select ManagerID from HumanResources.Employee
WHERE ManagerID IS NOT NULL)
)
)
gROUP BY ManagerID


----3-----
select mANAGERiD , COUNT(EMPLOYEEid) [number of EMPLOYEES] FROM HumanResources.Employee 
where emplOYEEid iN (
(Select ManagerID from HumanResources.Employee
WHERE EmployeeID NOT IN 
(Select ManagerID from HumanResources.Employee
WHERE ManagerID IS NOT NULL)
gROUP BY ManagerID
hAVING COUNT(eMPLOYEEid)>=2))
gROUP BY ManagerID
hAVING COUNT(EMPLOYEEiD) >=2 

seleCT Employeeid FROM HumanResources.Employee WHERE 
ManagerID = 109
---- COUNT(EMPLOYEEid) [number of EMPLOYEES],
Select DISTINCT ManagerID,Title from HumanResources.Employee
WHERE EmployeeID NOT IN 
(Select ManagerID from HumanResources.Employee
WHERE ManagerID IS NOT NULL)



--mANAGERS OF MORE THAN 2. 

SELECT ManagerID 
From HumanResources.Employee
GROUP BY ManagerID
Having COUNT(EMployeeID) > =2 



select EmployeeID  FROM HumanResources.Employee WHERE EmployeeID noT IN ( 
Select EmployeeID from HumanResources.Employee
WHERE EmployeeID NOT IN 
(Select ManagerID from HumanResources.Employee
WHERE ManagerID IS NOT NULL))


seLECT  FROM HumanResources.Employee
WHERE ManagerID in (

