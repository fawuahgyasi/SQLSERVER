SELECT Temp.SalesOrderId,Temp.TotalDue From
(Select RANK() OVER (ORDER BY TotalDUE DESC) as 'Rank', * from Sales.SalesOrderHeader) Temp
WHERE Temp.Rank = 3
/*
TEMPORARY TABLES
*/
Select TOP 1 WITH TIES RANK() OVER (ORDER BY TotalDUE DESC) as 'Rank', * from Sales.SalesOrderHeader
ORDER BY TotalDue
CREATE TABLE #Employee
(
ID INT,
Name Varchar(10)
)

INSERT INTO #Employee Values (1,'A'),(2,'B'),(3,'C')

SELECT * FROM #Employee

--Scope: Bound to a session of the user who created it

--- Creating Global Temporary Table


CREATE TABLE 
ID INT,
Name Varchar(10)
)

INSERT INTO ##Employee Values (1,'A'),(2,'B'),(3,'C')

CREATE VIEW V_Sheme WITH SCHEMABINDING AS
(SElect ID,Name from dbo.V_test)

SELECT * from V_Sheme

ALTER TABLE V_test
DROP Column ID

DROP VIEW V_Sheme
DROP TABLE V_Test


USE AdventureWorks;
GO
SELECT i.ProductID, p.Name, i.LocationID, i.Quantity
    ,RANK() OVER 
    (PARTITION BY i.LocationID ORDER BY i.Quantity DESC) AS 'RANK'
FROM Production.ProductInventory i 
    INNER JOIN Production.Product p 
        ON i.ProductID = p.ProductID
ORDER BY p.Name;
GO