SELECT * from
 Person.Contact
 INNER JOIN HumanResources.Employee
 ON Person.Contact.ContactID = HumanResources.Employee.ContactID
 ORDER BY Person.Contact.ContactID
 
 
 SELECT * FROM 
 HumanResources.Employee 
 WHERE EmployeeID NOT IN 
 (SELECT ManagerId from HumanResources.Employee where ManagerID is not null)
 
 
 SELECT EMPLOYEEID from HumanResources.Employee
 UNION
 SELECT ManagerId from HumanResources.Employee
USE Batch50
CREATE PROC P1(@EmpID INT)
AS
SELECT * from  AdventureWorks.HumanResources.Employee
WHERE EmployeeID = @EmpID

EXECUTE P1 109


CREATE PROC P2( @EMPID INT , @Title Varchar(100) OUT ) 
AS
SELECT @Title = Title from AdventureWorks.HumanResources.Employee

WHERE EmployeeID = @EMPID

DECLARE @Results Varchar(100),@Return INT
EXECUTE @Return = P2 109, @Results OUT 

PRINT @Results

go
CREATE PROC P3 (@Name Varchar(50)=null,@ContactID INT = null)
AS 
BEGIN
IF @Name IS NOT NULL and @ContactID IS NULL
SELECT * from AdventureWorks.Person.Contact
WHERE FirstName = @Name

ELSE IF @Name IS NULL and @ContactID is NOT NULL
SELECT * from AdventureWorks.Person.Contact
where ContactID= @ContactID

else if @Name is NOT NULL AND @ContactID IS NOT NULL
SELECT * from AdventureWorks.Person.Contact
where ContactID = @ContactID and FirstName = @Name
else

print 'NEED NAME OR CONTACT ID '
END


EXEC P3 'kIM' 
EXEC P3 @NAME = 'kIM'
EXEC P3 @NAME = 'KIM',@ContactID = 15
exeC P3 NULL, NULL

alter PROC P4 (@START_RANGE INT, @END_RANGE INT, @TITLE VARCHAR(100) OUT)
AS
BEGIN
IF (@START_RANGE <= @END_RANGE)
SELECT HRE.EmployeeID, PC.FirstName, PC.LastName,HRE.Title
FROM AdventureWorks.Person.Contact PC
INNER JOIN AdventureWorks.HumanResources.Employee HRE
ON HRE.ContactID = PC.ContactID
WHERE HRE.EmployeeID BETWEEN @START_RANGE AND @END_RANGE

ELSE IF (@START_RANGE > @END_RANGE)
PRINT 'SMALLER START_RANGE'

DECLARE  @MIDDLERANG INT
SET @MIDDLERANG = (@START_RANGE + @END_RANGE)/2

SELECT @TITLE = TITLE FROM AdventureWorks.HumanResources.Employee
WHERE EMPLOYEEID = @mIDDLERANG
end

deCLARE @RESULT vARCHAR(100)
eXEC P4 30,50,  @RESULT OUT
pRINT @RESULT


/*
Create a SP tht will accept a table name and get me all the 
columns names along with thier data-types and sizes
TableNames: sys.columns, sys.types,sys.schemas,sys.tables
Colnames: schemaname,tablename,columnname,datatype,maxlength*/

CREATE PROC P5 ( @Tablename Varchar(100))
AS
SELECT SS.nAME AS 'SCHEMNAME',ST.nAME AS 'TABLENAME',SC.NAME AS 'COLUMNNAME',
STY.NAME AS 'DATATYPES',SC.MAX_LENGTH AS 'MAXlENGTH'
FROM SYS.tables ST
INNER JOIN SYS.columns SC
ON SC.object_id = ST.object_id
INNER JOIN SYS.types STY
ON STY.system_type_id = SC.system_type_id
INNER JOIN SYS.schemas SS
ON SS.schema_id = ST.schema_id
WHERE ST.name = @Tablename


execute P5 'Employee'


/*
Create a sp tha will create a chema name and table name and return me the corrensponding infor of their
columns on what the user passses the input*/

alter PROC P6 (@SCHEMANAME VARCHAR(100)=null, @TABLENAME VARCHAR (100)= NULL)
with encryption as
BEGIN
IF @SCHEMANAME IS NULL AND @TABLENAME IS NOT NULL
SELECT SS.nAME AS 'SCHEMNAME',ST.nAME AS 'TABLENAME',SC.NAME AS 'COLUMNNAME',
STY.NAME AS 'DATATYPES',SC.MAX_LENGTH AS 'MAXlENGTH'
FROM SYS.tables ST
INNER JOIN SYS.columns SC
ON SC.object_id = ST.object_id
INNER JOIN SYS.types STY
ON STY.system_type_id = SC.system_type_id
INNER JOIN SYS.schemas SS
ON SS.schema_id = ST.schema_id
WHERE ST.name = @Tablename

ELSE IF @SCHEMANAME IS NOT NULL AND @TABLENAME IS NULL

SELECT SS.nAME AS 'SCHEMNAME',ST.nAME AS 'TABLENAME',SC.NAME AS 'COLUMNNAME',
STY.NAME AS 'DATATYPES',SC.MAX_LENGTH AS 'MAXlENGTH'
FROM SYS.tables ST
INNER JOIN SYS.columns SC
ON SC.object_id = ST.object_id
INNER JOIN SYS.types STY
ON STY.system_type_id = SC.system_type_id
INNER JOIN SYS.schemas SS
ON SS.schema_id = ST.schema_id
WHERE SS.name = @SCHEMANAME

ELSE IF @SCHEMANAME IS NOT NULL AND @TABLENAME IS NOT NULL

SELECT SS.nAME AS 'SCHEMNAME',ST.nAME AS 'TABLENAME',SC.NAME AS 'COLUMNNAME',
STY.NAME AS 'DATATYPES',SC.MAX_LENGTH AS 'MAXlENGTH'
FROM SYS.tables ST
INNER JOIN SYS.columns SC
ON SC.object_id = ST.object_id
INNER JOIN SYS.types STY
ON STY.system_type_id = SC.system_type_id
INNER JOIN SYS.schemas SS
ON SS.schema_id = ST.schema_id
WHERE SS.name = @SCHEMANAME AND ST.name = @TABLENAME
ELSE 
print 'ENTER AT LEAST ONE'

END

EXEC P6 DBO,employee


CREATE PROC P7 (@SCHEMANAME VARCHAR(100)=null, @TABLENAME VARCHAR (100)= NULL)
AS
