---CURSORS

DECLARE <Cursor_Name> CURSOR STATIC/FORWARD_ONLY/DYNAMIC/KEYSET/SCROLL/READ_ONLY 
FOR
<AND SELECT QUERY>
...
GO
..
OPEN<CURSOR_NAME>
FETCH NEXT/FIRST/PRIOR/ABSOLUTE 30/RELATIVE -3
FROM <cursor_name>
...
...
....
CLOSE <CURSOR_NAME>
DEALLOCATE <Cursor_name>

---Person with ID ##with Name ## has PhoneNO ##

SET NOCOUNT ON 
DECLARE @ID_Value INT,@Name_Value VARCHAR(100),@Phone_Value INT,@String Varchar(Max)
DECLARE Row_Operation CURSOR
FOR 

SELECT * FROM dbo.Cur_Test
OPEN Row_Operation
FETCH Row_Operation INTO @ID_Value,@Name_Value,@Phone_Value
WHILE @@FETCH_STATUS = 0
BEGIN
SET @String	 = 'Person with ID ' + CONVERT(Varchar(10),@ID_Value) +' with Name' +@Name_Value +' has Phone' + CONVERT(varchar(10),@Phone_Value) 
PRINT @String
FETCH Row_Operation INTO @Id_Value,@Name_Value,@Phone_Value
END
CLOSE Row_Operation
DEALLOCATE Row_Operation
SET NOCOUNT OFF







CREATE TABLE Cur_Test
(
ID INT,
Name Varchar(100),
PhoneNo INT
)


INSERT INTO Cur_Test Values(1,'AAA',11111)
INSERT INTO Cur_Test Values(1,'AAA',22222)
INSERT INTO Cur_Test Values(1,'AAA',33333)
INSERT INTO Cur_Test Values(1,'AAA',44444)
INSERT INTO Cur_Test Values(1,'AAA',55555)
INSERT INTO Cur_Test Values(1,'AAA',66666)
INSERT INTO Cur_Test Values(1,'AAA',77777)

BEGIN TRANSACTION T1

UPDATE Cur_Test SET Name= 'FREDDIE' WHERE ID =1
SELECT * FROM Cur_Test

SAVE TRANSACTION S1 ---Checkpoint

BEGIN TRANSACTION S2

TRUNCATE TABLE Cur_Test 
SELECT * FROM Cur_Test

ROLLBACK TRANSACTION S1

INSERT INTO Cur_Test Values (9,'G3',12345)
COMMIT TRANSACTION T1


/*

USE BCP to dump all the information of Employee 
(Ewith no middle name
*/

SELECT HRE.EMPLOYEEID, HRE.Title,PC.FirstName,PC.Lastname from 
AdventureWorks.HumanResources.Employee HRE
INNER JOIN AdventureWorks.Person.Contact PC
ON PC.ContactID = HRE.ContactID
WHERE PC.MiddleName is NULL

---BCP utility command--
BCP "SELECT HRE.EMPLOYEEID, HRE.Title,PC.FirstName,PC.Lastname from AdventureWorks.HumanResources.Employee HRE INNER JOIN AdventureWorks.Person.Contact PC ON PC.ContactID = HRE.ContactID WHERE PC.MiddleName is NULL " queryout: C:\BCP\EmployeeInfo.txt -c -T



SELECT HRE.EMPLOYEEID, HRE.Title,PC.FirstName,PC.Lastname INTO NEWEMP from AdventureWorks.HumanResources.Employee HRE INNER JOIN AdventureWorks.Person.Contact PC ON PC.ContactID = HRE.ContactID WHERE 1=0

BULK INSERT Batch50.dbo.NEWEMP FROM 'C:\BCP\EmployeeInfo.txt'

SELECT * FROM NEWEMP

WITH EmployeeInfo
AS
(
SELECT HRE.EMPLOYEEID, HRE.Title,PC.FirstName,PC.Lastname from 
AdventureWorks.HumanResources.Employee HRE
INNER JOIN AdventureWorks.Person.Contact PC
ON PC.ContactID = HRE.ContactID
WHERE PC.MiddleName is NULL
)
SELECT * from EMployeeInfo

--
select * from EmployeeInfo 


WITH TEST_DML
AS

(SELECT * from Cur_Test)
INSERT INTO TEST_DML VAlues (10,'GJ',9999)
SELECT * from TEST_DML



CREATE TABLE MYEMPLOYEES
(
EMPLOYEEID SMALLINT NOT NULL,
FIRSTNAME VARCHAR(50) NOT NULL,
LASTNAME VARCHAR(50) NOT NULL,
TITLE VARCHAR(50) NOT NULL,
DEPTID SMALLINT NOT NULL,
MANAGERID INT NULL,
CONSTRAINT PK_mYEMPLOYEE_eMPLOYEEID PRIMARY KEY CLUSTERED (eMPLOYEEID ASC))

pOPULATE TABLE WITH VALUES---

INSERT INTO MyEmployees Values

(1,'Ken','Snchez','Chief Executive Officer',16,NULL)

,(273,'Brian','Welcker','Vice President of Sales',3,1)

,(274,'Stephen','Jiang','North American Sales Manager',3,273)

,(275,'Michael','Blythe','North Sales Representative',3,274)

,(276,'Linda','Mitchell','North Sales Representative',3,274)

,(285,'Syed','Abbas','Pacific Sales Manager',3,273)

,(286,'Lynn','Tsoflias','Sales Representative',3,285)

,(16,'David','Bradley','Marketing Manager',4,273)

,(23, 'Mary','Gibson','Marketing Specialist',4,16)

SELECT * FROM MYEMPLOYEES
WITH DirectReports (MANAGERID,EMPLOYEEID,TITLE,DEPTID,LEVEL)
AS
(
--ANCHOR MEMBER DEFINITION
SELECT E.MANAGERID,E.EMPLOYEEID,E.TITLE,EDH.DEPARTMENTID,0 AS LEVEL
FROM DBO.MYEMPLOYEES E
INNER JOIN AdventureWorks.HumanResources.EmployeeDepartmentHistory EDH
ON E.EMPLOYEEID = EDH.EmployeeID AND EDH.EndDate IS NULL
WHERE E.MANAGERID IS NULL
UNION ALL

--RECURSSIVE MEMBER DEFINITIONS

SELECT E.MANAGERID,E.EMPLOYEEID,E.TITLE,EDH.DEPARTMENTID,LEVEL+1
FROM DBO.MYEMPLOYEES E
INNER JOIN AdventureWorks.HumanResources.EmployeeDepartmentHistory EDH
ON E.EMPLOYEEID =EDH.EmployeeID AND EDH.EndDate IS NULL
INNER JOIN DirectReports D
ON E.MANAGERID = D.EMPLOYEEID
)
SELECT * FROM DirectReports

truNCATE TABLE MYEMPLOYEES
