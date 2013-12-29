USE Northwind

--1-----
SELECT O.OrderID 
FROM Orders O
INNER JOIN Customers C
ON C.CustomerID = O.CustomerID
WHERE C.CompanyName = 'Island Trading'

--RESULTS--ROW=10


  --2---
SELECT OrderID 
FROM Orders
WHERE CUSTOMERID IN
(
 SELECT CustomerID
 FROM Customers
 WHERE CompanyName = 'Island Trading'
 )
 
 --RESULTS--ROW=10
 
 ---3---
 SELECT O.ProductID,P.ProductName,SUM(O.Quantity) [Total Sold]
 FROM Products P
 INNER JOIN [Order Details] O
 ON O.ProductID = P.ProductID
 GROUP BY O.ProductID,P.ProductName
 HAVING SUM(O.Quantity) < 100
 
 ---RESULTS--ROW = 1 
 
 ---4---
 SELECT DISTINCT E.LastName,E.FirstName
 FROM Employees E
 INNER JOIN Orders O
 ON E.EmployeeID = O.EmployeeID
 INNER JOIN Customers C
 ON C.CustomerID = O.CustomerID
 WHERE C.CompanyName = 'Island Trading'
 
----RESULTS -- ROW = 7. 

---5 ----
SELECT LastName,FirstName
FROM Employees 
WHERE EmployeeID IN 
 (SELECT EmployeeID 
  FROM Orders
  WHERE CustomerID IN
     (SELECT CustomerID 
      FROM Customers 
      WHERE CompanyName = 'Island Trading'
      )
      )
---RESULTS--- ROW = 7

---6----
SELECT DISTINCT E.LastName, E.FirstName
FROM Employees E
LEFT OUTER JOIN Orders
ON E.EmployeeID = Orders.Employeeid
AND
OrderDate   
BETWEEN 'March 1,1997' and 'March 7,1997'
WHERE ORDERS.EmployeeID IS NULL
--- Results -- ROw 3

---7---
SELECT LastName,FirstName
FROM Employees
WHERE EmployeeID NOT IN 
 (SELECT  EmployeeID 
  FROM Orders
  WHERE OrderDate BETWEEN 'March 1,1997' and 'March 7,1997')
---Results Row 3

---8---

SELECT DISTINCT CompanyName,ContactName,City,Region,PostalCode,Country,Phone
FROM Customers C
INNER JOIN Orders O
ON C.CustomerID = O.CustomerID
WHERE O.OrderID IN (
SELECT O.OrderID  from [Order Details] OD
INNER JOIN Orders O
ON OD.OrderID = O.OrderID
WHERE O.OrderID IN
(
Select ORderID from [Order Details] OD
 Inner join Products P 
 ON OD.ProductID = P.ProductID
 WHERE P.ProductName = 'Tofu'))
 UNION  
SELECT CompanyName,ContactName,City,Region,PostalCode,Country,Phone
FROM Suppliers S
INNER JOIN Products P
ON S.SupplierID = P.SupplierID
WHERE P.ProductName = 'Tofu'

--Results Row = 19
 
 ---9----

USE AdventureWorks
SELECT HRE.EmployeeID, HRE.NationalIDNumber,HRE.Title,PC.FirstName,PC.MiddleName,PC.LastName
FROM HumanResources.Employee HRE
INNER JOIN Person.Contact PC
ON HRE.ContactID = PC.ContactID
WHERE PC.Title is not null

---Results Rows = 8

---10----

SELECT HRE.EmployeeID, HRE.NationalIDNumber,HRE.Title,PC.FirstName,PC.MiddleName,PC.LastName
FROM HumanResources.Employee HRE
INNER JOIN Person.Contact PC
ON HRE.ContactID = PC.ContactID
WHERE HRE.EmployeeID IN
(SELECT ManagerID from HumanResources.Employee WHERE ManagerID is Not NULL)
--Results Rows = 47 

---11---

SELECT  P.CITY , P.POSTALCODE 
from PERSON.Address P
INNER JOIN HumanResources.EmployeeAddress HRE
ON HRE.AddressID = P.AddressID

INTERSECT 

SELECT P.CITY, P.POSTALCODE
FROM Person.Address P
INNER JOIN Sales.CustomerAddress S
ON S.AddressId = P.AddressID

---Results Rows 23

---12---

SELECT TOP 1 WITH TIES SSD.SalesOrderId, SSD.ProductID,PP.Name,SSH.OrderDate
FROM Sales.SalesOrderDetail SSD	
INNER JOIN Sales.SalesOrderHeader SSH
ON SSD.SalesOrderID = SSH.SalesOrderID
INNER JOIN Production.Product PP
ON SSD.ProductID = PP.ProductID
ORDER BY SSH.OrderDate DESC

---Results-- Rows: 96

---13----

SELECT   Temp.ProductID,Temp.Name 
From 
(SELECT TOP 1 WITH TIES PP.ProductID,PP.Name,SSH.OrderDate
FROM Sales.SalesOrderDetail SSD	
INNER JOIN Sales.SalesOrderHeader SSH
ON SSD.SalesOrderID = SSH.SalesOrderID
INNER JOIN Production.Product PP
ON SSD.ProductID = PP.ProductID
ORDER BY YEAR(SSH.OrderDate) DESC  ) Temp
EXCEPT
SELECT PP.ProductID,PP.Name 
FROM Production.Product PP
INNER JOIN Production.ProductReview PPR
ON PPR.ProductID = PP.ProductID

---Results Rows:181 

---14---
SELECT SalesOrderID ,CustomerID from 
(SELECT  TOP 1 WITH TIES SSO.SalesOrderID,SSO.BillToAddressID,SCA.CustomerID,SCA.AddressID,SSO.OrderDate
FROM Sales.SalesOrderHeader SSO
INNER JOIN Sales.CustomerAddress SCA
ON SSO.CustomerID = SCA.CustomerID
ORDER BY YEAR(SSO.OrderDate) DESC
) TEMP
WHERE TEMP.BillToAddressID != TEMP.AddressID
SELECT TOP 1 * from Sales.SalesOrderHeader
--Results : Rows: 25. 

---15---

SELECT P.Name [Product Name],V.Name [Vendor Name]  
FROM  Purchasing.ProductVendor PPV
INNER JOIN Purchasing.Vendor V
ON PPV.VendorID = V.VendorID
INNER JOIN Production.Product P
ON P.ProductID = PPV.ProductID
WHERE P.ProductSubcategoryID 
IN (SELECT  ProductSubcategoryID 
    FROM Production.ProductSubcategory 
    WHERE Name ='Shorts')

----Results : Rows 7

---16---

SELECT EmployeeID, FirstName,LastName
FROM Person.Contact PC
INNER JOIN HumanResources.Employee HRE
ON PC.ContactID = HRE.ContactID
WHERE HRE.EmployeeID IN (
SELECT SalesPersonId From  Sales.SalesPerson
INTERSECT
SELECT EmployeeID FROM Purchasing.PurchaseOrderHeader
)
--Results: Rows 0