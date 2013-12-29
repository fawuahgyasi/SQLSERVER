/*

*/

CREATE VIEW Vi_USER AS
(SELECT EMPLOYEEID, TITLE from AdventureWorks.HumanResources.Employee)

SELECT * from Vi_USER

--lAYER 2
CREATE VIEW V2_user2 AS
(SELECT Employeeid FROM Vi_USER)


--- Joining view
SELECT * FROM Vi_USER V1
INNER JOIN V2_user2 V2
ON V1.EmployeeID = V2.EmployeeID


/*
CREATE A VIEW tha will hold EmployeeID, FirstName, LastName, Title, CurrentRate  
*/
ALTER VIEW EmpInfo AS
(
SELECT  TOP 100.00 percent AHRE.EmployeeID,APC.FirstName,APC.LastName,AHRE.Title,AHEP.Rate CurrentRate
FROM AdventureWorks.HumanResources.Employee AHRE
INNER JOIN AdventureWorks.Person.Contact APC
ON AHRE.ContactID = APC.ContactID
INNER JOIN AdventureWorks.HumanResources.EmployeePayHistory AHEP
ON AHRE.EmployeeID = AHEP.EmployeeID
WHERE AHEP.RateChangeDate =
(select MAX(rATEcHANGEDATE) FROM AdventureWorks.HumanResources.EmployeePayHistory
wherE EmployeeID = AHEP.EmployeeID)
order by 5 desc )

SELECT * from EmpInfo


CREATE VIEW EMP_NOMN AS 
(
SELECT AHE.EmployeeID, APC.FirstName,APA.AddressLine1
FROM AdventureWorks.HumanResources.Employee AHE
INNER JOIN AdventureWorks.Person.Contact APC
ON APC.ContactID = AHE.ContactID
INNER JOIN AdventureWorks.HumanResources.EmployeeAddress AHEA
ON AHEA.EmployeeID = AHE.EmployeeID
INNER JOIN AdventureWorks.Person.Address APA
ON APA.AddressID = AHEA.AddressID
WHERE APC.MiddleName IS NULL)


CREATE TABLE V_Test
(
ID INT,
Name Varchar(10)
)
INSERT INTO V_Test Values (1,'CCS'),(2,'POWAY'),(3,'San DIEGO')

ALTER VIEW V_test1 AS
SELECT * from V_Test
WHERE ID BETWEEN 5 and 10
WITH CHECK OPTION

SELECT * from V_Test---Table

INSERT INTO V_test1 Values (2,'PA'),(11,'TX')

DELETE FROM V_test1
WHERE ID= 1

---DELETING Duplicate Records--

--Finding Unique records using distinct and not using distinct

CREATE TABLE Dup_Test
(
ID INT,
NAME Varchar(20)
)

INSERT INTO Dup_Test Values (1,'A'),(1,'A'),(2,'B'),(3,'C'),(4,'C'),(4,'D'),(4,'D'),(5,'E')

SELECT * from Dup_Test

ALTER VIEW V_Dup AS (
SELECT ROW_NUMBER() OVER (Partition by ID,Name order by ID desc) as [Rw_no] ,* from Dup_Test)

SELECT * from V_Dup

DELETE FROM V_Dup 

--Table Variable--(Only for Mocks)

DECLARE @Var1 TABLE 
(
Col1 INT PRIMARY KEY,
COl2 Varchar)

INSERT  into @Var1 values (1,'lj;l')
/*
1. Table variables are faster than permanment tables
2. referred at complile time
3. Stored in RAM memeory
4. DML and DCL Operations but not DDL opearations

Disadvangate
1. Worse perfomance for data access in case of huse row counts above 10000
2. Scope of Table variable is Batch bound
3. Table Variables cannot have contraints (check this for PK)
4. Table variables do not generate Statistics. 
5. Table variabl cannot have indexes
*/

EXECUTE @Var


---COMPUTER BY CLAUSE---
SELECT SSOH.SalesPersonId,SSOH.CustomerID,SSOH.TotalDue from Sales.SalesOrderHeader SSOH
WHERE SSOH.SalesPersonID IS NOT NULL
ORDER BY 1,2
COMPUTE SUM(SSOH.TotalDue),AVG(SSOH.TOtalDUE) BY SSOH.SalesPersonID,SSOH.CustomerId