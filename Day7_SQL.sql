/* --## Dynamic SQL (DSQL)##--
1. Dynamic SQL refers to cod/script which can be used to operate on different data-sets based on some
dynamic values supplied by front-end applications.
2. Declare variables: Which makes SQL code dynamic
3. Mix and match of DSQL and TSQL
4. Main disadvantage of DSQL is that we are opening SQL Server for SQL Injection attacks 

--Variables in SQL Server--
1. Variables in SQL Server are created using DECLARE Statement
2. Every-time we execute DSQL variables have to be freshly declared.
3. Scope of each variable is batch-bound  */

DECLARE @Var INT -- Declare a variable of INT datatype
--something that starts with @ arfe User-defined variables
--Something that starts with @@ are system variables

--System Variables--
1. @@Error
2. @@Identity
3. Scope_Identity
4. @@Version
5. @@RowCount
6. @@Fetch_Status

Select @@VERSION

Select @@ERROR -- recently occured error.

DECLARE @Var INT
SET @Var = 10
PRINT @Var

--Write me a DSQL Code to get FirstName and LastName of all the employees. You are geting table_name from 
--front-end application--

DECLARE @Tab_Name Varchar(Max), @SQL_QUERY Varchar(Max)
SET @Tab_Name = 'HumanResources.Employee'

SET @SQL_QUERY = 'SELECT FirstName, LastName from '+ @Tab_Name
PRINT (@SQL_QUERY)

EXECUTE(@SQL_QUERY)

/* Wriet a DSQL cod to get all the employees whi are NOT managers (EmployeeID,Title,FirstName,LastName,HireDate
/Birthdate in 107 style format along with ManagerID of those whose FirstName starts with '?%' 

Here you are getting a filter condition (?) as character from front-end application. Also, user has the choice to
select either HireDate or BirthDate from front-end application */

DECLARE @Filter Varchar(1), @Date_Clm Varchar(100)
DECLARE @SQLQUERY Varchar(Max)

SET @Filter = 'g'
SET @Date_Clm ='BirthDate' --These Stataments are for Testing the code at Back-end not for front-end

SET @SQLQUERY = 'SELECT HRE2.EmployeeID,HRE2.Title,PC.FirstName,PC.LastName, HRE2.ManagerID, 
		CONVERT(Varchar(50),HRE2.' + @Date_Clm + ',107) as ' + @Date_Clm + ' FROM HumanResources.Employee HRE1
		RIGHT OUTER JOIN HumanResources.Employee HRE2
		ON HRE1.ManagerID = HRE2.EmployeeID
		INNER JOIN Person.Contact PC
		ON PC.ContactID = HRE2.ContactID
		WHERE HRE1.EmployeeID IS NULL AND PC.FirstName LIKE '''+ @Filter + '%'''
		
PRINT (@SQLQUERY) -- Printing SQL Statament is for Testing the code at Back-end not for front-end
EXECUTE (@SQLQUERY)
				
/* Write a query in which you are getting TableName,two column names, Start and End EmployeeiD range for
filter condition from front-end application that would be exeuted in back-end databases */

Select <variable>,<variable> from <variable>
where EmployeeID between <variable> and <variable>

GO
DECLARE @Col1 Varchar(50), @Col2 Varchar(50), @Tab_Name Varchar(Max), 
@StrRng INT, @EndRng INT, @SQLQUERY Varchar(max)

SET @Col1 = 'EmployeeID'
SET @Col2 = 'Rate'
SET @Tab_Name = 'HumanResources.EmployeePayHistory'
SET @StrRng = 1
SET @EndRng = 10

SET @SQLQUERY = 'SELECT '+ @Col1 + ',' + @Col2 + ' FROM ' + @Tab_Name
+ ' WHERE EmployeeID BETWEEN ' + CAST(@StrRng AS Varchar(10)) + ' AND ' + 
CAST(@EndRng AS Varchar(10))

PRINT (@SQLQUERY)

EXECUTE (@SQLQUERY)

/* Write  DSQL code that will display the total Sales of Product by
Product Category, Product Sub-Category and Product in which you are
getting filter values of Product Category Name and Product Sub-Category
Name from front-end application */
GO
DECLARE @ProdCNm Varchar(50), @ProdSCNm Varchar(50)
DECLARE @SQL_QUERY Varchar(Max)

SET @ProdCNm = 'Clothing'
SET @ProdSCNm = 'Caps'

SET @SQL_QUERY = 'SELECT DPC.EnglishProductCategoryName, 
DPSC.EnglishProductSubCategoryName,
DP.EnglishProductName, SUM(FRS.SalesAmount) AS TotalSales 
FROM dbo.DimProductCategory DPC
INNER JOIN dbo.DimProductSubCategory DPSC
ON DPC.ProductCategoryKey = DPSC.ProductCategoryKey
INNER JOIN dbo.DimProduct DP
ON DPSC.ProductSubCategoryKey = DP.ProductSubCategoryKey
INNER JOIN dbo.FactResellerSales FRS
ON FRS.ProductKey = Dp.ProductKey
WHERE DPC.EnglishProductCategoryName = '''+ @ProdCNm +'' ' AND  
DPSC.EnglishProductSubCategoryName = ''' + @ProdSCNm + '''
GROUP BY DPC.EnglishProductCategoryName, DPSC.EnglishProductSubCategoryName,
DP.EnglishProductName'

PRINT (@SQL_QUERY)
EXECUTE (@SQL_QUERY)

--Dynamic SQL can also be executed using--

DECLARE @ProdCNm Varchar(50), @ProdSCNm Varchar(50)
--DECLARE @SQL_QUERY Varchar(Max)

SET @ProdCNm = 'Clothing'
SET @ProdSCNm = 'Caps'

EXECUTE('SELECT DPC.EnglishProductCategoryName, 
DPSC.EnglishProductSubCategoryName,
DP.EnglishProductName, SUM(FRS.SalesAmount) AS TotalSales 
FROM dbo.DimProductCategory DPC
INNER JOIN dbo.DimProductSubCategory DPSC
ON DPC.ProductCategoryKey = DPSC.ProductCategoryKey
INNER JOIN dbo.DimProduct DP
ON DPSC.ProductSubCategoryKey = DP.ProductSubCategoryKey
INNER JOIN dbo.FactResellerSales FRS
ON FRS.ProductKey = Dp.ProductKey
WHERE DPC.EnglishProductCategoryName = '''+ @ProdCNm +''' AND  
DPSC.EnglishProductSubCategoryName = ''' + @ProdSCNm + '''
GROUP BY DPC.EnglishProductCategoryName, DPSC.EnglishProductSubCategoryName,
DP.EnglishProductName')

--Control-Flow Statements--
/* 1. While Statements
   2. IF ELSE Statements
   3. CASE Statements */
   
--While Loop (Syantax)

DECLARE @Counter INT
SET @Counter = 0

WHILE (@Counter<10)
BEGIN
<logic statements>
SET @Counter = @Counter+1
END

/* 1.WHILE Loops are used to loop through a table in Row-by-Row basis

/* Loop through a table T6(ID,Name,PhoneNo) and give me the output in the
format:

Person with ID ## with Name ## has PhoneNO ### */ */

CREATE TABLE T6
(
ID INT,
Name Varchar(20),
PhoneNo INT
)

INSERT INTO T6 Values (1,'G1',11111),(2,'G2',22222),(3,'G3',33333),
(4,'G4',44444),(5,'G5',55555)

Select * from T6

GO

DECLARE @Counter INT =1, @MaxRows INT
DECLARE @ID_Value INT, @Name_Value Varchar(100),@Phone_Value INT,
@String Varchar(Max)
SELECT @MaxRows = COUNT(*) from T6 --OR SET @MaxRows = (Select Count(*) from T6)
WHILE(@Counter <=@MaxRows)
BEGIN
SELECT @ID_Value = ID,@Name_Value = Name,@Phone_Value = PhoneNo FROM
T6 where ID = @Counter

SET @String = 'Person with ID: ' + CAST(@ID_Value AS Varchar(10)) + ' with
name: ' + @Name_Value + ' has phoneno: ' + CAST(@Phone_value AS varchar(10))

PRINT (@String)

SET @Counter = @Counter +1
END

ALTER TABLE T6
DROP COLUMN ID
GO
--Looping through a table having no integer column--
DECLARE @Counter INT = 1, @MaxRows INT
DECLARE @Tab TABLE(RwNo INT,Name Varchar(10),Phone INT)
DECLARE @Name_Value Varchar(10), @Phone_value INT, @String Varchar(Max)

INSERT INTO @Tab
SELECT ROW_NUMBER() OVER (ORDER BY Name) as'RwNo',Name,PhoneNo from T6

SET @MaxRows = (Select COUNT(*) from @Tab)
WHILE(@Counter <=@MaxRows)
BEGIN
SELECT @Name_Value = Name,@Phone_Value = Phone FROM
@Tab where RwNo = @Counter

SET @String = 'Person with name: ' + @Name_Value + ' has phoneno: ' 
+ CAST(@Phone_value AS varchar(10))

PRINT (@String)

SET @Counter = @Counter +1
END

/* For WHILE Loops we MUTS have an integer column in the underlying table with
the data in a particular pattern or else you have to use appropriate 
Ranking function */

--IF..ELSe(Syntax)

IF<Condition>
BEGIn
<statement>
END
ELSE IF<Condition>
BEGIN
<Statement>
END

/* In Table T6 grant a user permission to see only data other than G1 and G3
in the same format as discussed in last example */

DECLARE @Counter INT = 1, @MaxRows INT
DECLARE @Tab TABLE(RwNo INT,Name Varchar(10),Phone INT)
DECLARE @Name_Value Varchar(10), @Phone_value INT, @String Varchar(Max)

INSERT INTO @Tab
SELECT ROW_NUMBER() OVER (ORDER BY Name) as'RwNo',Name,PhoneNo from T6

SET @MaxRows = (Select COUNT(*) from @Tab)
WHILE(@Counter <=@MaxRows)
BEGIN
SELECT @Name_Value = Name,@Phone_Value = Phone FROM
@Tab where RwNo = @Counter

IF @Name_Value<>'G1' AND @Name_Value !='G3'
BEGIN
SET @String = 'Person with name: ' + @Name_Value + ' has phoneno: ' 
+ CAST(@Phone_value AS varchar(10))

PRINT (@String)
END
ELSE
PRINT 'Restricted Data'

SET @Counter = @Counter + 1
END

--CASE Statement--
--Similar to SWITCh.. CASE in most programming langugae.
--Donot use BEGIN for CASE Statements

/* Add extra information of Address in the above data for each record. 
Following are the address for each person--

ID 1 -->LA
ID 2 --> SD
ID 3 --> TX
ID 4 --> NY
ID 5--> PA
Person with Name: G1 has Phone No: 11111 lives in LA -- */
GO
DECLARE @Counter INT = 1, @MaxRows INT
DECLARE @Tab TABLE(RwNo INT,Name Varchar(10),Phone INT)
DECLARE @Name_Value Varchar(10), @Phone_value INT, @String Varchar(Max),
@Address_value Varchar(10),@ID_value INT 

INSERT INTO @Tab
SELECT ROW_NUMBER() OVER (ORDER BY Name) as'RwNo',Name,PhoneNo from T6

SET @MaxRows = (Select COUNT(*) from @Tab)
WHILE(@Counter <=@MaxRows)
BEGIN
SELECT @Name_Value = Name,@Phone_Value = Phone, @ID_value = RwNo FROM
@Tab where RwNo = @Counter

SET @Address_value =
CASE @ID_Value WHEN 1 THEN 'LA'
			   WHEN 2 THEN 'SD'
			   WHEN 3 THEN 'TX'
			   WHEN 4 THEN 'NY'
			   WHEN 5 THEN 'PA'
ELSE 'ID should be between 1 and 5'
END

SET @String = 'Person with name: ' + @Name_Value + ' has phoneno: ' 
+ CAST(@Phone_value AS varchar(10)) + ' lives in : '+ @Address_value

PRINT @String
SET @Counter = @Counter +1
END












