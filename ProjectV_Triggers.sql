/*
3. [Northwind] Create an INSTEAD OF trigger that prints a "not allowed"-type error message whenever a delete is attempted on the Customers table. Then create a query that deletes a single row from Customers. Paste the code for the trigger definition, the test query, and the output from execution of the test query into your project Word document. 
*/

CREATE TRIGGER NO_DELETE_FOR_CUSTOMER ON Customers
INSTEAD OF DELETE
AS
BEGIN
DECLARE @DELETEDROW INT

SELECT @DELETEDROW = COUNT(*) FROM deleted

IF @DELETEDROW > 0

PRINT 'NOT ALLOWED'

END 
---
---SELECT TOP 1 * FROM Customers
DELETE FROM Customers WHERE CustomerID = 'ALFKI'
           
/*
4. [Northwind] Create a trigger on the Products table that prints a message for a specific product whenever an update is made to the UnitsInStock column of the table. (You will need to use IF UPDATE in your update trigger.)

The output message should say which product was updated, and the new UnitsInStock value. Construct the output message in a variable named @string, then use RAISERROR (@string, 10, 1) to have the message printed to the messages tab of the results.

Perform an update to test the trigger. Paste the trigger definition, the test query, and the output into your project Word document. 
*/
GO
ALTER TRIGGER CHECKUPDATE ON Products
INSTEAD OF UPDATE 
AS
BEGIN
DECLARE @string VARCHAR(MAX)
DECLARE @ProductID INT
DECLARE @Unitsinstock INT
SELECT @ProductID = ProductID, @Unitsinstock = UnitsInStock from inserted


IF UPDATE(UnitsInStock)
SET @string = 'Product with ID ' + CONVERT(VARCHAR(20),@ProductID) + ' was updated with a new UnitInStock of :' + CONVERT(VARCHAR(20),@Unitsinstock)
 --EXEC(@string)
 RAISERROR(@string,10,1)
END

--SELECT TOP 1 * FROM Products

---TEST
	UPDATE Products 
	SET UnitsInStock =50
	where ProductID = 1
	
	select * from products where ProductID =1
--GO




--BEGING OF 6

SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

CREATE TABLE [dbo].[OrderArchive](

[OrderID] [int] NOT NULL,

[CustomerID] [nchar](5),

[EmployeeID] [int] NULL,

[OrderDate] [datetime] NULL,

[RequiredDate] [datetime] NULL,

[ShippedDate] [datetime] NULL,

[ShipVia] [int] NULL,

[Freight] [money] NULL,

[ShipName] [nvarchar](40),

[ShipAddress] [nvarchar](60),

[ShipCity] [nvarchar](15),

[ShipRegion] [nvarchar](15),

[ShipPostalCode] [nvarchar](10),

[ShipCountry] [nvarchar](15)

) ON [PRIMARY]

GO

ALTER TABLE dbo.[Order Details]

DROP CONSTRAINT FK_Order_Details_Orders

GO 

/*
Create a trigger named dbo.tdArchiveOrders that writes rows deleted from the Orders table into the OrderArchive table.

Create a stored procedure named dbo.pDeleteOldestOrders that (1) determines the earliest year and month of OrderDate values in the Orders table, and then (2) deletes all orders with an OrderDate in that year and month.

[If you want to play with the delete statement but not have it take effect, enclose your code between BEGIN TRAN and ROLLBACK TRAN statements.]

In your project document, show the code for creation of the trigger and creation of the stored procedure. Run the stored procedure, and show the "rowcount" output in Messages (i.e. the "<n> row(s) affected" message). Then show the results of: SELECT OrderID, OrderDate FROM dbo.OrderArchive.

[Put the rows back into Orders and recreate the [Order Details] foreign key by executing the following code:

SET IDENTITY_INSERT dbo.Orders ON

GO

INSERT dbo.Orders

(OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate,

ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion,

ShipPostalCode, ShipCountry)

SELECT * FROM dbo.OrderArchive

GO

SET IDENTITY_INSERT dbo.Orders OFF

TRUNCATE TABLE dbo.OrderArchive

GO

ALTER TABLE dbo.[Order Details]

ADD CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (OrderID)

REFERENCES dbo.Orders (OrderID)

GO 
*/
---6. 
-CREATE TRIGGER dbo.tdArchiveOrders ON Orders
	AFTER DELETE AS
	BEGIN
	INSERT INTO OrderArchive 
	SELECT * FROM deleted

END
GO

----STORED PROCEDURE----

 CREATE PROC dbo.pDeleteOldestOrders
 AS
	 DECLARE @EARLIEST_YEAR VARCHAR(20),@EARLIEST_MONTH VARCHAR(20)
	 BEGIN
	 SELECT  @EARLIEST_YEAR =  YEAR(MIN(O.OrderDate)),@EARLIEST_MONTH= MONTH(MIN(O.OrderDate))  FROM Orders O
	 
	 DELETE FROM Orders 
	 WHERE YEAR(OrderDate) = @EARLIEST_YEAR AND MONTH(ORDERDate) = @EARLIEST_MONTH
 
 END
 
 
 BEGIN TRAN
 --USING THE STORED PROCEDURE
 EXEC dbo.pDeleteOldestOrders
 ROLLBACK TRAN
 --TESTING THE STORED PROCEDURE
 SELECT OrderID, OrderDate FROM dbo.OrderArchive
 
 
 SET IDENTITY_INSERT dbo.Orders ON

GO

INSERT dbo.Orders

(OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate,

ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion,

ShipPostalCode, ShipCountry)

SELECT * FROM dbo.OrderArchive

GO

SET IDENTITY_INSERT dbo.Orders OFF

TRUNCATE TABLE dbo.OrderArchive

GO

ALTER TABLE dbo.[Order Details]

ADD CONSTRAINT FK_Order_Details_Orders FOREIGN KEY (OrderID)

REFERENCES dbo.Orders (OrderID)

GO 
--SELECT COUNT(*) FROM Orders
--SELECT * FROM OrderArchive
------


/*
7. [Northwind] You must have completed item 6 before starting this item. Execute the following code to create an OrderDetailsArchive table:

SELECT * INTO dbo.OrderDetailsArchive FROM dbo.[Order Details] WHERE 1 = 2

GO

Modify the dbo.tdArchiveOrders trigger to be an INSTEAD OF trigger that first copies all rows in [Order Details] that have an OrderID value equal to that of a to-be-deleted order to the OrderDetailsArchive table, then deletes those rows from [Order Details], then copies rows to be deleted from Orders to the OrderArchive table, and finally deletes the rows from Orders.

[Note: If this were an AFTER trigger, the FK constraint would keep the delete from happening, and the AFTER trigger would never fire.]

Paste the code used for altering the trigger into your project Word document.

Execute the stored procedure dbo.pDeleteOldestOrders.

To demonstrate the results, execute the following query:

SELECT oa.OrderID, oa.OrderDate, oda.ProductID, oda.quantity

FROM dbo.OrderArchive oa JOIN dbo.OrderDetailsArchive oda

ON oa.OrderID = oda.OrderID 
*/
--7
SELECT * INTO dbo.OrderDetailsArchive 
FROM dbo.[Order Details] 
WHERE 1 = 2

GO 
--SELECT * FROM [Order Details]


ALTER TRIGGER dbo.tdArchiveOrders ON Orders
INSTEAD OF DELETE AS
BEGIN

--COPY TO BE DELETED FILES INTO ORDERDETAILSARCHIVE
INSERT INTO dbo.OrderDetailsArchive
	SELECT O.OrderID,O.ProductID,O.UnitPrice,O.Quantity,O.Discount 
	FROM [Order Details] O
	INNER JOIN deleted d 
	ON d.OrderID = O.OrderID 

--- Archiving ordersDetails into orderdetails archive. 
DELETE FROM [Order Details] 
WHERE OrderID IN 
	(SELECT O.OrderID FROM [Order Details] O
INNER JOIN deleted d 
ON d.OrderID = O.OrderID)

---Archiving Data from Orders into OrderArchive. 
INSERT INTO OrderArchive
SELECT * FROM deleted

---FINALLY DELETE ROWS FROM ORDERS
DELETE FROM Orders 
WHERE OrderID IN 
	(SELECT OrderID from deleted)

END

---TEST PROCEDURE
EXEC dbo.pDeleteOldestOrders

SELECT oa.OrderID, oa.OrderDate, oda.ProductID, oda.quantity

FROM dbo.OrderArchive oa JOIN dbo.OrderDetailsArchive oda

ON oa.OrderID = oda.OrderID





---8

/*
8.	Use SET IDENTITY_INSERT, INSERT … SELECT …, and TRUNCATE TABLE queries to restore the Orders and [Order Details] tables to their original state.  These queries will have to be in the proper order, due to the FK constraint on OrderID in [Order Details].  Paste those queries into your project Word document.
Demonstrate, with a variation of the item 7 "demonstrate the results" query, that the rows have indeed been returned to the original tables.


*/
 
 SET IDENTITY_INSERT dbo.Orders ON

GO

INSERT dbo.Orders

(OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate,

ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion,

ShipPostalCode, ShipCountry)

SELECT * FROM dbo.OrderArchive

GO



INSERT [Order Details]
(OrderID, ProductID,UnitPrice,Quantity,Discount)
SELECT * FROM dbo.OrderDetailsArchive

GO

TRUNCATE TABLE dbo.OrderArchive
TRUNCATE TABLE dbo.OrderDetailsArchive

--DEMONSTRATION

SELECT oa.OrderID, oa.OrderDate, oda.ProductID, oda.quantity

FROM dbo.OrderArchive oa JOIN dbo.OrderDetailsArchive oda

ON oa.OrderID = oda.OrderID



 
 