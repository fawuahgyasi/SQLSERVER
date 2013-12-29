----Freddie
/*
1. [Northwind] Create a view that lists all order ID's for customer 'Island Trading'. 
You may use the join or the subquery you created in the Unit 4 Project, query 1 or 2. 
Show the result of the sp_helptext stored procedure for this view:

EXEC sp_helptext '<viewname
*/
--1
CREATE VIEW CUST_ORDERS AS

SELECT O.OrderID
FROM  Orders O
INNER JOIN Customers C
ON C.CustomerID = O.CustomerID
WHERE C.CompanyName = 'Island Trading'

EXEC sp_helptext 'CUST_ORDERS'

--2

/*
2. [Northwind] Create a view that lists the last name and 
first name of all employees who have sold to 'Island Trading'. 
Use the query you created in the Unit 4 Project, query 4. 
The underlying tables must be prevented from having columns added, 
having columns removed, or having the data type of a column changed, 
if those changes will affect the view. The view must be encrypted. 
Show the code you executed to create the view, 
and show the result of the sp_helptext stored procedure for this view:

EXEC sp_helptext '<viewname>' 
*/

CREATE VIEW CUST_ORDER_IT WITH SCHEMABINDING AS
SELECT E.FirstName,E.LastName 
FROM dbo.Orders O
INNER JOIN dbo.Employees E
ON O.EmployeeID =O.EmployeeID
INNER JOIN dbo.Customers C
ON C.CustomerID = O.CustomerID
WHERE C.CompanyName = 'Island Trading'

EXEC sp_helptext 'CUST_ORDER_IT' 



--3
/*
3. Write a script that performs the following tasks:

a. Define a variable to hold the maximum database ID value.

b. Set that variable equal to the maximum database ID value.
 Use the database_id of the sys.databases table in master.

c. Use PRINT to print the value of the variable. 
*/

DECLARE @MaxDB_ID INT

SELECT @MaxDB_ID = max(database_id) from SYS.databases
PRINT @MaxDB_ID
GO
--4

/*
4. Write a script that performs the following tasks. 
The script will need to use variables and WHILE.

a. Perform b. and c. for each database. 
Start with the database having database ID of 1, then 2, and 
continue until you reach the maximum database ID value.
 Use your code from problem 3 to determine the value for the maximum database ID. 
 Your loop should stop there.

b. Determine the name of the database (and cause a variable of datatype 
sysname to have a value of that name). Hint: Use the DB_NAME function.

c. Construct a character string that says 'Database ID <value> is <database_name>'. 
(For example: Database ID 1 is master.) A variable should hold this string as its value.
 Use PRINT to print the variable. 
*/


DECLARE @DB_Name Varchar(50),@COUNTER INT = 1 
DECLARE @DB_ID INT,@MaxDB_ID INT,@String Varchar(100)

SELECT @MaxDB_ID = max(database_id) from SYS.databases

WHILE (@COUNTER <= @MaxDB_ID)
BEGIN

SELECT 
    @DB_Name = name,
    @DB_ID = database_id
     from Sys.databases
     WHERE database_id = @COUNTER
SET @String = 'Database ID ' +CONVERT(VARCHAR(10),@DB_ID) + ' is ' + @DB_Name

Print(@String)
SET @COUNTER = @COUNTER + 1
END
DROP Database FREDDIE1
---5

GO

DECLARE @DB_Name Varchar(50),@COUNTER INT = 1 
DECLARE @DB_ID INT,@MaxDB_ID INT,@String Varchar(100)

SELECT @MaxDB_ID = max(database_id) from SYS.databases
WHILE (@COUNTER <= @MaxDB_ID)
BEGIN

SELECT 
    @DB_Name = name,
    @DB_ID = database_id
     from Sys.databases
     WHERE database_id = @COUNTER
     IF(@DB_ID IS NOT NULL AND @DB_Name IS NOT NULL)
     BEGIN
     SET @String = 'Database ID ' +CONVERT(VARCHAR(10),@DB_ID) + ' is ' + @DB_Name

     Print(@String)
     END
SET @COUNTER = @COUNTER + 1

END

---6
/*
6. Define a variable @DayOfWeek and set it equal to the day of the week of the current datetime, 
using GETDATE() and DATEPART. Define another variable, @dayname.
 Write a CASE statement that sets variable @DayName equal to 'Sunday' if the day of

the week value is 1, 'Monday' if 2, etc. 
Print the @DayName value. Use of proper data types for your variables is a must. 
*/
DECLARE @DayName Varchar(15),@DayOfWeek int 
SELECT @DayOfWeek = DatePart(dw,GETDATE()) 
SET @DayName =
CASE @DayOfWeek 
               WHEN 1 THEN 'Sunday'
               WHEN 2 THEN 'Monday'
               WHEN 3 THEN 'Tuesday'
               WHEN 4 THEN 'Wednesday'
               WHEN 5 THEN 'Thursday'
               WHEN 6 THEN 'Friday'
               WHEN 7 THEN 'Saturday'
               ELSE 'DayOfWeek is between 1 and 7'
               END
PRINT @DayName


--
/*
7. Define a variable @FirstDayOfMonth to hold a character string long enough 
for the date format of your choice. 
Define a table variable @results that has one column to hold the @FirstDayOfMonth values. 
For each month of the current year (variable @mo), 
set @FirstDayOfMonth equal to a constructed character string representing the first day of the month, 
and insert this @FirstDayOfMonth value into the @results table. 
After exiting the "month" loop, select all rows from @results. 
Use of proper data types for your variables is a must. 
*/
GO
DECLARE @FirstDayOfMonth  Varchar(30)
DECLARE @results TABLE 
     (
     FirstDayOfMonth Varchar(30)
     )
DECLARE @COUNTER INT = 1
 
 WHILE (@COUNTER <= 12)
 BEGIN
 SET @FirstDayOfMonth = CONVERT(Varchar(2),@COUNTER)+'/'+ '1' + '/' + CONVERT(VARCHAR(4),YEAR(GETDATE()))
 INSERT INTO @results Values (@FirstDayOfMonth)    
-- PRINT @FirstDayOFMonth
 SET @COUNTER = @COUNTER + 1
 END
 SELECT * FROM @results
 

 ---8
 GO
DECLARE @FirstDayOfMonth  Varchar(30)
DECLARE @DayName Varchar(30)
DECLARE @results TABLE 
     (
     FirstDayOfMonth Varchar(30),
     DayName Varchar(20)
     )
DECLARE @COUNTER INT = 1
 
 WHILE (@COUNTER <= 12)
 BEGIN
 SET @FirstDayOfMonth = CONVERT(Varchar(2),@COUNTER)+'/'+ '1' + '/' + CONVERT(VARCHAR(4),YEAR(GETDATE()))
 SET @Dayname = DATENAME(DW,@FirstDayOfMonth)
 INSERT INTO @results Values (@FirstDayOfMonth,@DayName)    
-- PRINT @FirstDayOFMonth
 SET @COUNTER = @COUNTER + 1
 END
 SELECT * FROM @results
 
 
 ---9

DECLARE @sql Varchar(500)
DECLARE @s_name varchar(50)
SET @s_name = 'HumanResources'

SET @sql = 'SELECT s.name [Schema Name] , t.name [Table Name]
           FROM sys.schemas s 
           INNER JOIN sys.tables t
           ON s.schema_id = t.schema_id 
           WHERE s.name = '+ ''''+@s_name+''''
           
SELECT @sql 
EXEC(@sql)