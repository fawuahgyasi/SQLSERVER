USE AdventureWorks 

SELECT TOP 1 * from Sales.SalesOrderDetail
SELECT TOP 1 * from Sales.SalesOrderHeader
SELECT TOP 1 * FROm Sales.SalesPersonQuotaHistory

SELECT SalesPersonID,SUM(TotalDue) [TotalDue] , AVG(TotalDue) [AverageDue] 
FROM Sales.SalesOrderHeader 
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID 

SELECT SSP.SalesPersonID, PC.FirstName,ISNULL(PC.MiddleName,' ') MiddleName, PC.LastName,PC.EmailAddress,PC.Phone, SSP.SalesYTD YearToDateSales
FROM Sales.SalesPerson SSP
INNER JOIN HumanResources.Employee HRE 
ON SSP.SalesPersonID = HRE.EmployeeID
INNER JOIN Person.Contact PC 
ON PC.ContactID = HRE.ContactID

USE Batch50
SELECT * FROM 