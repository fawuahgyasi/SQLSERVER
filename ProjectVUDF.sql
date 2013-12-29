----2

CREATE FUNCTION RETURNLAST (@CompanyName VARCHAR(200))
RETURNS TABLE
RETURN (SELECT E.FirstName,E.LastName 
FROM dbo.Orders O
INNER JOIN dbo.Employees E
ON O.EmployeeID =O.EmployeeID
INNER JOIN dbo.Customers C
ON C.CustomerID = O.CustomerID
WHERE C.CompanyName = @CompanyName)

SELECT * from  RETURNLAST('Quick-Stop')

----3
ALTER FUNCTION NEXT_CLASS(@Month Varchar(15),@Year Varchar(10))
RETURNS @TABLE TABLE (EmployeeID INT, HireDate Date, LastName Varchar(100), FirstName Varchar(100),EmailAddress Varchar(200))
AS
BEGIN
IF (@Month) = 2 OR (@Month) = 8
INSERT INTO @TABLE
SELECT HRE.EmployeeID,HRE.HireDate,PC.LastName, PC.FirstName, PC.EmailAddress
FROM HumanResources.Employee HRE
INNER JOIN Person.Contact PC
ON HRE.ContactID = PC.ContactID
WHERE @Year-YEAR(HRE.HireDate) < = 2
RETURN
END

SELECT * FROM NEXT_CLASS(5,2003)

ALTER FUNCTION dbo.Distance(@sLat DECIMAL(10,1),@sLon DECIMAL(10,1), @pLat DECIMAL(10,1) ,@pLon DECIMAL(10,1))
RETURNS DECIMAL(10,1) 
AS
BEGIN
DECLARE @DISTANCE DECIMAL(10,1)
SET @DISTANCE = 
 SQRT( ((69.17 * (@sLat - @pLat) )

* (69.17 * (@sLat - @pLat))

+ ( 57.56 * (@sLon - @pLon) )

* ( 57.56 * (@sLon - @pLon)))) 
return @Distance
END
--34.0664 and longitude 118.3103 and p at latitude 33.6784 and longitude 118.0054, 
SELECT dbo.Distance(34.0664,118.3103,33.6784,111.0054) DISTANCE