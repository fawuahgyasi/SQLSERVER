
---1---
CREATE PROC P1 (@String Varchar(100))
AS
BEGIN
DECLARE @QT varchar(200)
SET @QT =
'SELECT C.CompanyName, O.OrderID
FROM  Orders O
INNER JOIN Customers C
ON C.CustomerID = O.CustomerID
WHERE C.CompanyName Like'+ ' ''' +@String + '%' + ''''

PRINT(@QT)
EXEC (@QT)
END

EXEC P1 'FR'

RESULTS 24 ROWS. 
CompanyName                              OrderID
---------------------------------------- -----------
France restauration                      10671
France restauration                      10860
France restauration                      10971


---2---

--Return Order details of product by with OrderId, Product Id or both. 

CREATE PROC P2(@OrderId INT = NULL, @ProductID INT = NULL)
AS
DECLARE @SQL1 VARCHAR(MAX)
DECLARE @SQL2 VARCHAR(MAX)
DECLARE @SQL  VARCHAR(MAX)

SET @SQL =
'SELECT P.ProductName [Product Name],OD.Quantity [Quantity] ,O.OrderDate 
FROM [Order Details] OD 
INNER JOIN Products P
ON OD.ProductID = P.ProductID
INNER JOIN Orders O
ON OD.OrderID= O.OrderID ' 

IF @OrderId IS NOT NULL AND @ProductID IS NULL
SET @SQL2 = 'WHERE O.ORDERID = ' + CONVERT(VARCHAR(20),@OrderId)
ELSE IF @OrderId IS NULL AND @ProductID IS NOT NULL
SET @SQL2 = 'WHERE P.PRODUCTID = ' + CAST(@PRODUCTID AS VARCHAR(20))
ELSE IF @OrderId IS NOT NULL AND @ProductID IS NOT NULL
SET @SQL2 = ' WHERE O.OrderID = '+ CONVERT(VARCHAR(20),@OrderId) + 
            ' AND ' + 'P.ProductID = ' + CONVERT(VARCHAR(20),@ProductID)
ELSE 
PRINT 'GIVE AT LEAST ONE INTEGER INPUT'

SET @SQL1 = @SQL + @SQL2 

PRINT(@SQL1)
EXEC (@SQL1)
RETURN 0

EXEC P2 10248,NULL