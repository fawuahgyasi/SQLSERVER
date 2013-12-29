USE STAGING
GO

CREATE TABLE HRE_DATA(
                      EMPLOYEEID INT,
                      TITLE NVARCHAR(50),
                      BIRTHDATE DATETIME,
                      HIREDATE DATETIME,
                      GENDER NCHAR
                      
                      )
--ALTER TABLE HRE_DATA 
--ADD CONTACTID INT
CREATE TABLE PC_DATA(
                     CONTACTID INT,
                     FIRSTNAME NVARCHAR(50),
                     MIDDLENAME NVARCHAR(50),
                     LASTNAME NVARCHAR(50)
                     )



USE edw

GO 

	CREATE TABLE DIMEMPLOYEE(
							  EMPLOYEEKEY INT IDENTITY(1,1) PRIMARY KEY,
							  EMPLOYEEALTERNATEKEY INT,
							  TITLE NVARCHAR(50),--T2
							  BIRTHDATE DATETIME,--T0
							  HIREDATE DATETIME,-- T0
							  FIRSTNAME NVARCHAR(50),--T2
							  MIDDLENAME NVARCHAR(50),--T1
							  LASTNAME NVARCHAR(50),--T2
							  GENDER NCHAR(1),--T1
							  STARTDATE DATETIME,
							  ENDDATE DATETIME
							  )
CREATE PROC MYLOAD
AS 
BEGIN							  
INSERT INTO STAGING..HRE_DATA
                          SELECT EmployeeID,Title,BirthDate,HireDate,Gender,ContactID
                          FROM AdventureWorks.HumanResourceS.Employee	
                          
INSERT INTO STAGING..PC_DATA
                          SELECT CONTACTID,FirstName,MiddleName,LastName
                          FROM AdventureWorks.Person.Contact 	
                          
                          
END

EXEC MYMYLOAD

SELECT HRE.EMPLOYEEID,HRE.TITLE,HRE.BIRTHDATE,HRE.HIREDATE,
       PC.FIRSTNAME,PC.MIDDLENAME,PC.LASTNAME,HRE.GENDER
FROM HRE_DATA HRE
INNER JOIN PC_DATA PC
ON HRE.CONTACTID = PC.CONTACTID
use STAGING
update HRE_Data 
set title = 'tool manager'
where employeeID = 4

delete from HRE_data where employeeid = 4
use batch50
select * From dbo.Employee1_Table
selec