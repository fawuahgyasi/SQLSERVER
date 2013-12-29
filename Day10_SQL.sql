--"," delimiter UDF--
ALTER FUNCTION [dbo].[Split](@List nvarchar(2000),	@SplitOn nvarchar(5))  
RETURNS @RtnValue table 
(Id int identity(1,1),Value nvarchar(100)
) 
AS  
BEGIN
While (Charindex(@SplitOn,@List)>0)
Begin
Insert Into @RtnValue (value)
Select 
    Value = ltrim(rtrim(Substring(@List,1,Charindex(@SplitOn,@List)-1)))
Set @List = Substring(@List,Charindex(@SplitOn,@List)+len(@SplitOn),len(@List))
End
Insert Into @RtnValue (Value)
    Select Value = ltrim(rtrim(@List))

    Return
END
--Examples to implement multivalues in Sprocs--
ALTER PROCEDURE P1(@EmpID Varchar(Max))
AS
--Declare @EmpID Varchar(Max)
--SET @EmpID = '10,20,30,40'
Select * from AdventureWorks.HumanResources.Employee
WHERE EmployeeID IN (Select Value from dbo.Split(@EmpID,';'))

EXECUTE P1 '18;21;30'

Select ID,Value from dbo.Split(1,1)

Declare @FName Varchar(Max)
SET @FName = 'Kim,Pilar,Jay,Carla'
Select FirstName,LastName from AdventureWorks.Person.Contact
Where FirstName IN (Select Value from dbo.Split(@FName,','))

/*--##TRIGGERS##--
Triggers are pre-compiled set of T-SQL Statements that are automatically
executed on a particular DDL,DML or Log-on event.

--Types of Triggers--
1. Log-on Triggers responds to log-on events
2. DDL Triggers responds to (Create,Alter,Drop)
3. DML Triggers reponds to (Insert,Update, Delete)

1. Log-on Triggers-- responds to log on event on Server
Scope: Serer Level

2.DDl Triggers -- responds to (C,A,D)
Scope: Database Level */

--Create a Trigger that will prevent any usr to create a table in your
--database.

--Syntax-

CREATE TRIGGER <Trigger_Name> ON <Database>
AFTER/FOR CREATE_TABLE/DROP_TABLE/ALTER_TABLE AS

CREATE TRIGGER Deny_Creating ON DATABASE
DECLARE @TabName Varchar(max)
SELECT @TabName = ST.name from sys.Tables ST 
where ST.Create_Date=(Select MAX(Create_date) from sys.tables)

SET @SQL_Query = ' DROP Table ' + @TabName
--PRINT @SQL_QUERY
EXECUTE (@SQL_Query)
--------------------------------

CREATE TABLE Test_Trig
( 
ID INT,
Name Varchar(100)
)
--Dropping Trigger--
DROP TRIGGER Deny_Creating ON DATABASE

-- *DDL AFTER Triggers works on Views *--

--DML Triggers--
--Scope: Table Level(Data Level)

--Syntax--

CREATE TRIGGER <trigger_name> ON <table_name>
INSTEAD OF/AFTER INSERT/UPDATE/DELETE AS
BEGIN
.
.
.
END

--Scenario: Sales and Stocks

CREATE TABLE Sales_Trig
(
SalesID INT,
PID INT,
Qty INT,
Name Varchar(100)
)

CREATE TABLE Stocks_Trig
(
PID INT,
PName Varchar(50),
Qty INT
)

INSERT INTO Stocks_Trig Values (100,'Iphone',45)
INSERT INTO Stocks_Trig Values (101,'Laptops',68)
INSERT INTO Stocks_Trig Values (102,'Camera',25)
INSERT INTO Stocks_Trig Values (101,'Desktops',70)

Select * from Stocks_Trig



--Case 1: Using Instead of Trigger--

CREATE TRIGGER Sales_Trigger ON Sales_Trig
INSTEAD OF INSERT AS

DECLARE @Req_Qty INT, @Req_PID INT, @Ava_Qty INT
SELECT @Req_Qty = Qty, @Req_PID = PID FROM inserted

SELECT @Ava_Qty = Qty from Stocks_trig
WHERE PID = @Req_PID

IF @Req_Qty <= @Ava_Qty
BEGIN
INSERT INTO Sales_Trig
Select * from inserted

UPDATE Stocks_Trig
SET Qty = Qty - @Req_Qty
WHERE PID = @Req_PID
END

ELSE
PRINT ' Out of Stock'

Select * from Sales_trig
--INSERT INTO Sales_Trig Values(1,100,5,'Iphone')
Select * from Stocks_trig

--Case 2:--

CREATE TRIGGER Sales_Trigger_After ON Sales_Trig
AFTER INSERT AS

DECLARE @Req_Qty INT, @Req_PID INT, @Ava_Qty INT
SELECT @Req_Qty = Qty, @Req_PID = PID FROM inserted

SELECT @Ava_Qty = Qty from Stocks_trig
WHERE PID = @Req_PID

IF @Req_Qty <= @Ava_Qty
BEGIN
UPDATE Stocks_Trig
SET Qty = Qty - @Req_Qty
WHERE PID = @Req_PID
END

ELSE
PRINT ' Out of Stock'


Select * from Sales_trig
--INSERT INTO Sales_Trig Values(2,101,5,'Laptops')
Select * from Stocks_trig

/* Create a Single Instead of Trigger on Stock Table for Insert, Update
and delete and notify DBA which DML Statements has caused the trigger to get
fired */

--for eg: 

INSERT INTO Stocks_trig Values (...)
--your output shild be:
--Trigger got fired on INSERT Statement--

CREATE TRIGGER Test_Trig ON Stocks_trig
INSTEAD OF INSERT,UPDATE,DELETE AS

Declare @InsertRows INT, @DeletedRows INT

Select * from inserted
Select * from deleted

SELECT @InsertRows = COUNT(*) FROm inserted
SELECT @DeletedRows = COUNT(*) from deleted

IF @InsertRows <>0 and @DeletedRows = 0
PRINT 'Trigger got fired on Insert Statement'

ELSE IF @InsertRows =0 and @DeletedRows <> 0
PRINT 'Trigger got fired on Delete Statement'

ELSE IF @InsertRows <>0 and @DeletedRows <> 0
PRINT 'Trigger got fired on Update Statement'

ELSE
PRINT 'Something is Wrong'

INSERT INTO Stocks_trig Values (3,'abc',30)
DELETE FROM Stocks_trig
where PID = 100

UPDATE Stocks_trig
SET PID = 1000
WHERE PID IN(100,101)

Select * from Stocks_trig

/*
(3 row(s) affected) -- Reords effected in Inserted Magic Table--

(3 row(s) affected) -- Records effected in Deleted Magic Table--
Trigger got fired on Update Statement

(3 row(s) affected) -- Records that would be effected in Actual base Table--*/

--Assuming that there are two stand-alone tables Parent and Child,simulate
--PK and FK relationship between these two tables with T1 as Parent and
--T2 as child Table for inserting data */

CREATE TABLE T1
(
ID INT,
Name Varchar(10)
)

CREATE TABLE T2
(
ID INT,
Address Varchar(10)
)

--
ALTER TRIGGER T_PKFK ON T2
INSTEAD OF INSERT AS

Declare @ID_value INT
Select * from inserted

SELECT @ID_value = ID from inserted
IF (Select COUNT(*) from T1 where ID = @ID_value) =1

INSERT INTO T2
Select * from inserted

ELSE
PRINT 'Cannot insert into Child Table before Parent Table'

INSERT INTO T1 Values (4,'CCC')
Go 3

Select * from T1
Select * from T2

INSERT INTO T2 Values (2,'CA')

--simulate on-Delete cascade functionality for T1 being Parent and T2 being
-- child table */

ALTER TRIGGER T12 ON T1
FOR DELETE AS

Declare @ID_Value INT
--Select * from deleted

SELECT @ID_Value = ID FROM deleted
DELETE FROM T2 WHERE ID = @ID_Value
-------------------------------------

Select * from T1
Select * from T2

DELETE FROM T1
Where ID = 1

--Create a Trigger that will populate an Archive Table which would hold all
--the historical records/data from the base table .

--Base Table Structure--
--BTable (ID,Fname,Lname,Salary)

--Archive Table Structure
--ATable (ID,Fname,Lname,Salary,Flag,TTime,User)

Dataset in the Flag column of ATable should be as follows:
I -- for Insert
D-- for Delete
U_Old --for record which got replaced with UPDATE
U_new -- for record which was updated with UPDATE */

CREATE TABLE BTable
(
ID INT,
Fname Varchar(10),
LName Varchar(10),
Salary Money)

CREATE TABLE ATable
(
ID INT,
FName Varchar(10),
LName Varchar(10),
Salary Money,
Flag Varchar(50),
TTime DateTime,
[User] Varchar(Max)
)

CREATE TRIGGER Archive_Trig ON BTable
AFTER INSERT,UPDATE,DELETE AS

Declare @InsertedRows INT, @DeletedRows INT

SELECT @InsertedRows = COUNT(*) from inserted
SELECT @DeletedRows = COUNT(*) from deleted

IF @InsertedRows <> 0 AND @DeletedRows = 0
INSERT INTO ATable
Select ID,Fname,LName,Salary,'I',GETDATE(),SYSTEM_USER from inserted

ELSE IF @InsertedRows = 0 AND @DeletedRows <> 0
INSERT INTO ATable
Select ID,Fname,LName,Salary,'D',GETDATE(),SYSTEM_USER from deleted

ELSE IF @InsertedRows <> 0 AND @DeletedRows <> 0
BEGIN
INSERT INTO ATable
Select ID,Fname,LName,Salary,'U_Old',GETDATE(),SYSTEM_USER from deleted

INSERT INTO ATable
Select ID,Fname,LName,Salary,'U_New',GETDATE(),SYSTEM_USER from inserted

END

ELSE
PRINT 'No action performed on ATable (0 rows affected)'

INSERT INTO BTable Values (1,'G1','J1',100)
INSERT INTO BTable Values (2,'G2','J2',200)
INSERT INTO BTable Values (3,'G3','J3',300)

DELETE FROM BTable 
WHERE ID = 1

UPDATE BTable
SET ID = 22
WHERE ID = 2

TRUNCATE TABLE BTable


Select * from BTable
Select * from ATable






