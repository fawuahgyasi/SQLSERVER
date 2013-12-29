use AdventureWorks

SELECT SUM(TotalDue) 'Total Sales' 
From Sales.SalesOrderHeader


Select TOP 1 * from sales.SalesOrderHeader

SELECT CustomerID, ('$ ' + CAST(SUM(TotalDue) as Varchar(50)) ) [Total Salary]
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
Having SUM(TotalDue) >10000
ORDER BY [Total Salary] DESC

Select (FirstName+' ' + ISNULL(MiddleName,'') + ' ' + LastName) [FullName]
FROM Person.Contact

SELECT TOP 1 CustomerID, (SUM(TotalDue)) 'Total Sales' 
From Sales.SalesOrderHeader
GROUP BY CustomerID 
ORDER BY [Total Sales] DESC 

---Database Engine execution sequence followed by Programmers 
/*
SELECT 
FROM 
WHERE
GROUP BY
HAVING
ORDER BY

----
SQL SERVER QUERY execution Order

FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
*/

--
/*
GETDATE(), GETUTDATE(),DATEADD(), DATEDIFF(),CAST(),CONVERT(),YEAR(),MONTH(),DAY()
*/





SELECT DATEADD(mm,3,GETDATE())

SELECT SalesOrderID,OrderDate,ShipDate,DateDiff(hour,ORderDate,ShipDate) ResponsTime
FROM Sales.SalesOrderHeader
ORDER BY 4 DESC


Select ( UPPER(FirstName) + ISNULL(MiddleName,' ') + Lower(LastName)) 'FULLname'
FROM Person.Contact


SELECT SUBSTRING(FirstName,1,1) + '.' + ISNULL(SUBSTRING(MiddleName,1,1),' ') + '.' + SUBSTRING(LastName,1,1)
FROM Person.Contact
ORDER BY SUBSTRING(FirstName,3,1)


--Get the difference between OrderDate and CurrentDate and display the oldest order being placed on the 
--Top along with OrderDate in the format Nov 6,13)

SELECT CAST(DAtediff(DD,OrderDate,GETDAte())as Varchar(20))+ ' days' ,CONVERT(Varchar(12),OrderDate,7) [Order Date], CONVERT(VarChar(12),GETDATE(),7) CurrentDate
FROM Sales.SalesOrderHeader
ORDER BY 1 DESC

/*
Convert can be used as cast but give extra styling.  
*/

SELECT EmployeeID ,'$ ' + CAST(SUM(TotalDue) as Varchar(20)) [Total Sales]
FROM Purchasing.PurchaseOrderHeader
GROUP BY EmployeeID


SELECT EmployeeID ,'$ ' + CONVERT(VARCHAR(20),SUM(TotalDue)) [Total Sales]
FROM Purchasing.PurchaseOrderHeader
GROUP BY EmployeeID

SELECT VEndorID, EmployeeID ,'$ ' + CONVERT(VARCHAR(20),SUM(TotalDue)) [Total Sales],COUNT(VendorID)
FROM Purchasing.PurchaseOrderHeader
GROUP BY VendorID,EmployeeID
ORDER BY VendorID

---INNER JOIN:
/*
Type of joins 
1. INNER JOINS -- Gets all the matching records from both tables based on the joining column
2. OUTER JOINS 
  2.1 LEFT OUTER JOIN -- Gets all the non-matching records from the left table + one copy of mathcing records 
  from both tables. 
  2.2 RIGHT
  

*/


--Report to extract employee information along with Firstname and Lastname
--INNER JOIN--
SELECT HRE.EmployeeID,HRE.Title,PC.FirstName, PC.LastName 
FROM HumanResources.Employee HRE
INNER JOIN Person.Contact PC
ON HRE.ContactID=PC.ContactID

CREATE TABLE TOP_TEST
(
ID INT,
Name Varchar(23)
)

INSERT INTO TOP_TEST Values (1,'A')
GO 3
INSERT INTO TOP_TEST Values (2,'B')
INSERT INTO TOP_TEST Values (3,'c')
Go 4

select * from TOP_TEST

SELECT TOP 1 WITH TIES * from TOP_TEST
ORDER BY 1
SELECT TOP 2 WITH TIES * FROM TOP_TEST
ORDER BY 1
SELECT TOP 3 WITH TIES * FROM TOP_TEST
ORDER BY 1
SELECT TOP 4 WITH TIES * FROM TOP_TEST
ORDER BY 1


create table ptest
(
ID INT NOT NULL,
NAME VARCHAR(10)
)
ALTER TABLE ptest
ADD CONSTRAINT PK_PTEST_ID Primary KEY (ID)

CREATE TABLE C_Test
(
ID INT,
LNAME VARCHAR(10)
)
ALTER TABLE C_TEST

ADD CONSTRAINT FK_P_Test_C_TEST_ID FOREIGN KEY (ID) REFERENCES PTest(ID)
ON DELETE CASCADE
ON UPDATE CASCADE
Select * from ptest
select * from C_Test


INSERT INTO ptest values (1,'A'),(2,'b'),(3,'C')
INSERT INTO C_Test values (1,'AA'),(2,'bb'),(3,'CC')

 update ptest
 SET ID = 10
WHERE ID= 2


SELECT A.EmployeeID,FirstName + ISNULL(MiddleName,' ')+LastName, AVG(Rate)
FROM HumanResources.Employee A
INNER JOIN HumanResources.EmployeePayHistory B
ON A.EmployeeID = B.EmployeeID
INNER JOIN Person.Contact P
ON P.ContactID= A.ContactID
GROUP BY A.EmployeeID,FirstName,LastName,MiddleName
Having AVG(Rate) > 20
ORDER BY 3 DESC




-- Get me employee information along with their firstname,lastname,and address information.
SELECT HRE.EmployeeID,PC.FirstName,PC.LastName,HRE.Title,(ISNULL(PA.AddressLine1,' ') + ISNULL(PA.AddressLine2,' ')) ADDRESS,PA.City,PS.Name,PS.StateProvinceCode
FROM HumanResources.Employee HRE
INNER JOIN Person.Contact PC
ON HRE.ContactID=PC.ContactID
INNER JOIN HumanResources.EmployeeAddress HEA
ON HRE.EmployeeID = HEA.EmployeeID
INNER JOIN Person.Address PA
ON HEA.AddressID = PA.AddressID
INNER JOIN Person.StateProvince PS
ON PA.StateProvinceID = PS.StateProvinceID

--RESTRICTED FULL OUTER JOIN---
SELECT HRE.EmployeeID,PC.FirstName,PC.LastName
FROM HumanResources.Employee HRE
FULL OUTER JOIN Person.Contact PC
ON HRE.ContactID = PC.ContactID
WHERE HRE.EmployeeID IS NULL and PC.ContactID is NULL

CREATE DOMAIN Branch Char(4)

DB_ID
OBJECT_ID




