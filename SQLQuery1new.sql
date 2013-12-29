/*
 Feddie Awuah-Gyasi 
 Final Exams. 
*/
USE AdventureWorks
--1. How many Customers?

SELECT COUNT(CustomerID)
FROM Sales.Customer

-- Answer: 19185

--2. How many  Employees I have for year 2004
SELECT COUNT(HED.EmployeeID) 
FROM  HumanResources.EmployeeDepartmentHistory HED
WHERE YEAR(HED.StartDate) >= 2004 
     OR YEAR(HED.EndDate) >= 2004
     OR YEAR(HED.EndDate) IS NULL
     
---Annser: 290


--3. 

SELECT TOP 1 EMPLOYEEID,DateDiff(DD,HRE.BirthDate,GETDATE()) AGE
FROM HumanResources.Employee HRE
ORDER BY AGE DESC

--- OLDEST EMPLOYEE:EMPLOYEEID 268

SELECT TOP 1 EMPLOYEEID,DateDiff(DD,HRE.BirthDate,GETDATE()) AGE
FROM HumanResources.Employee HRE
ORDER BY AGE ASC 

---- YOUNGEST EMPLOYEE: EMPLOYEEID 120



---4
SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2004

---Average salese for 2004 = 2307.8569


--5
SELECT TOP 1 SSO.ProductID, PP.Name,SSo.OrderQty,SSH.OrderDate
FROM Sales.SalesOrderDetail SSO
INNER JOIN Sales.SalesOrderHeader SSH
ON SSO.SalesOrderID= SSH.SalesOrderID
INNER JOIN Production.Product PP
ON PP.ProductID = SSO.ProductID
WHERE YEAR(SSH.OrderDate) = 2004
ORDER BY SSO.OrderQty DESC

--- Product Name:  869: Womens Mountain Shorts.L 

--6

SELECT TOP 1 SSO.ProductID, PP.Name,PPC.Name [Product Categeory],PPS.Name [Subcategory Name],OrderQty,SSH.OrderDate
FROM Sales.SalesOrderDetail SSO
INNER JOIN Sales.SalesOrderHeader SSH
ON SSO.SalesOrderID= SSH.SalesOrderID
INNER JOIN Production.Product PP
ON PP.ProductID = SSO.ProductID
INNER JOIN Production.ProductSubcategory PPS
ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
INNER JOIN Production.ProductCategory PPC
ON PPC.ProductCategoryID = PPS.ProductCategoryID
WHERE YEAR(SSH.OrderDate) = 2004
ORDER BY SSO.OrderQty DESC

--- Product Category: Clothing
--- Subcategory : Shorts

--7

SELECT SS.SalesPersonID , AVG (SS.TotalDUE) [AVERAGE SALES]
FROM Sales.SalesOrderHeader SS
WHERE YEAR(OrderDate) = 2004
GROUP BY SS.SalesPersonID

--8 
SELECT TOP 1 SSO.CustomerID,(SSO.TotalDUE)
FROM Sales.SalesOrderHeader SSO
INNER JOIN Sales.StoreContact SSC
ON SSC.CustomerID = SSO.CustomerID
WHERE YEAR(SSO.ORDerDATE) = 2004

GROUP BY SSO.CustomerID,SSO.TotalDue




--



---

WHERE







