--## User-Defined Function (4th Database)


CREATE FUNCTION UDF_Addition( @No1 INT, @No2 INT)
RETURNS INT
AS 
BEGIN
RETURN @No1 + @No2
END
SELECT dbo.UDF_Addition (10,2)


CREATE FUNCTION UDF_Multiplication( @No1 INT, @No2 INT)
RETURNS INT
AS 
BEGIN
RETURN @No1 * @No2
END


SELECT dbo.UDF_Multiplication (122,33)


alter function udf_snd()
returns int
as 
begin
Declare @var int
set @var = DATEPART(ms,getdate())+ DATEPART(second,getdate()) * 1000 
   + DATEPART(minute,getdate()) * 60 * 1000 + DATEPART(hour,getdate()) * 60*60*1000
   return @var
   END
   
   
   select dbo.UDF_SND()
   
   
---
-- IN line UDF
---has a return statement. 

CREATE FUNCTION UDF_Emp(@EmpID INT)
RETURNs TABLE
RETURN (SELECT * FROM  AdventureWorks.HumanResources.Employee
where EmployeeID = @EmpID)

SELECT * FROM dbo.UDF_Emp(109)


--3. Multi line or table valued function. 

CREATE FUNCTION UdF_Multi(@EmpID INT)
RETURNS @TabVar Table (ID INT, Firstname varchar(100), Title Varchar(100))
as
BEGIN
INSERT INTO @TabVar
SELECT HRE.EmployeeId,PC.FirstName,HRE.Title From 
AdventureWorks.HumanResources.Employee HRE
INNER JOIN AdventureWorks.Person.Contact PC
ON HRE.ContactID = PC.ContactID
WHERE HRE.EmployeeID = @EmpID
RETURN
END

SELECT * FROM dbo.UDF_Multi(109)
CREATE TABLE T111 (ID INT, NAME VARCHAR(12))

CREATE FUNCTION LIMIT()
RETURNS INT
AS
BEGIN
DECLARE @COUNT1 INT 
DECLARE @T123 Table (ID int, name varchar(20))
select @COUNT1 = COUNT(*) from @T123
if @Count1 < = 10
(
INSERT INTO @T123 VAlues (1,'FReddie'),(2,'fre'),(3,'ikll')
if @Count1 >10
RETURN 0
)
