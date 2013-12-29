/* Create a Data Mart that should be capable of providing efficient

    support in decision making in terms of Production and Sales in the

    company. Data Mart will be responsible for tracking trends and

    historical patterns of SalesAmount, NetProfit

    by Employee, Product, ProductSubCategory, ProductCategory taking

    place in different countries. Users would be interested in generating

    reports from DM and would like to see information atleast on monthly

    basis. Identify required Dimension Tables, Fact Tables and

    Grain involved in creation of DM. Also, perform ETL on newly created

    DM for inital load. (use AdventureWorks database as OLTP source for DM)

    Also create ETL mapping documents that would map source coulmns from

    OLTP tables to corresponding OLAP tables during the process of designing)

 

*/


 /*
OLTP Tables: 
-------------
1. HumanResources.Employee
2. Production.Product
3. ProductSubCategory
4. ProductCategory
5. Sales.SalesTerritory
6. Sales.SalesOrderDetail
7. Sales.SalesOrderHeader
8. Person.Contact
 */
 
 
/*
PRESTAGING & STAGING AREA WITH IT'S DIMENSIONS 
*/

----CREATING THE PRESTAGING & STAGING AREA DATABASE. 
CREATE DATABASE Project_Staging

USE Project_Staging
                   --==DIM EMPLOYEE==
--Tracking Table
CREATE TABLE TrackEMP (
                        EmployeeID NVARCHAR(15) NULL,
                        DATACHECK INT
                       )
--PreStaging                     
CREATE TABLE   DimEmployee(
						   EmployeeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						   EmployeeNationalIDAlternateKey NVARCHAR(15) NOT NULL UNIQUE,
						   FristName NVARCHAR(50) NOT NULL,
						   LastName  NVARCHAR(50) NOT NULL,
						   MiddleName NVARCHAR(50) NOT NULL,
						   EffectiveDate DATETIME NOT NULL,
						   ExpiredDate   DATETIME NULL,
						   Status NVARCHAR(50)
					       )
--Staging
SELECT * INTO DimEMP FROM DimEmployee WHERE 1=2	
		
				  
					--==DimProduct==

--Tracking
CREATE TABLE TrackPDT (
                        ProductID NVARCHAR(15) NULL,
                        DATACHECK INT
                       )
--PreStaging                      					  				   
CREATE TABLE   DimProduct (
						   ProductKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						   ProductAlternateKey NVARCHAR(25) NOT NULL UNIQUE ,
						   StandardCost MONEY NULL,
						   ProductCategoryName NVARCHAR(50) NOT NULL,
						   ProductSubcategoryName NVARCHAR(50) NOT NULL,
						   EffectiveDate DATETIME NOT NULL,
						   ExpiredDate   DATETIME NULL,
						   Status NVARCHAR(50) NULL
                          )	
--Staging                          
 SELECT * INTO DimPDT FROM DimProduct WHERE 1=2 
 
 
                         				   
                    --==DimSalesCountry==
--Tracking                
CREATE TABLE TrackSC (
                        SalesTerritoryID INT NOT NULL,
                        DATACHECK INT
                       )                            
 --PreStaging                                     
CREATE TABLE   DimSalesCountry  (
                                 SalesCountryKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                 SalesCountryAlternateKey INT NOT NULL UNIQUE,
                                 CountryName NVARCHAR(50) NOT NULL
                                )
 ---Staging                              
 SELECT * INTO DimSC FROM DimSalesCountry WHERE 1=2    
 
 
                            
--DimTime
CREATE TABLE   DimTime    (
						   TimeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						   FullDateAlternateKey DATETIME NOT NULL,
						   MonthNumberOfYear TINYINT NULL,
						   EnglishMonthName NVARCHAR(25) NULL,
						   CalenderQuater TINYINT NULL,
						   CalenderYear CHAR(4) NULL,
						   FiscalQuater TINYINT NULL,
						   FiscalYear CHAR(4) NULL
					      )
SELECT * INTO DimTm FROM DimTime WHERE 1=2
ALTER TABLE DimTm
ALTER COLUMN FullDateAlternateKey NVARCHAR(20) NOT NULL --MONTH/YEAR
--FactInternetSales
CREATE TABLE   FactInternetSales(
								 ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey) ,
								 SalesCountryKey INT FOREIGN KEY REFERENCES DimSalesCountry(SalesCountryKey),
								 OrderDateKey  INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 DueDateKey    INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 ShipDateKey   INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 OrderQuantity SMALLINT NULL,
							-- SalesOrderNumber NVARCHAR(20) NOT NULL,
								 ProductStandardCost MONEY NULL,
								 TotalProductStandardCost MONEY NULL,
								 SalesAmount MONEY NULL,
								 NetProfitAmount MONEY NULL
                               )
 SELECT * INTO FactIS FROM FactInternetSales WHERE 1=2

--Prestaging

--FactResellerSales
CREATE TABLE   FactResellerSales(
                                 EmployeeKey INT FOREIGN KEY REFERENCES DimEmployee(EmployeeKey),
								 ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey),
								 SalesCountryKey INT FOREIGN KEY REFERENCES DimSalesCountry(SalesCountryKey),
								 OrderDateKey  INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 DueDateKey    INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 ShipDateKey   INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 OrderQuantity SMALLINT NULL,
							  --SalesOrderNumber NVARCHAR(20) NOT NULL,
								 ProductStandardCost MONEY NULL,
								 TotalProductStandardCost MONEY NULL,
								 SalesAmount MONEY NULL,
								 NetProfitAmount MONEY NULL
                                )
--Staging
 SELECT * INTO FactRS FROM FactResellerSales WHERE 1=2






--========================================================================================================================================


















/*
DATA MART CREATION
*/

---CREATING THE DATA MART-----
CREATE DATABASE Project_DataMart

----Dimenstions
/*
  
   -------------------------------------        
1. DimEmployee(
       EmployeeKey,
       EmployeeNationalIDAlternateKey,
       FristName,
       LastName
               )
   Source: HumanResource.Employee
           Person.Contact
  ---------------------------------------
  
2. DimProduct (ProductKey,
               ProductAlternateKey,
               StandardCost,
               ProductCategoryName
               ProductSubcategoryName
               )
    Source:Production.Product
           Production.ProductSubcategory
           Production.Productcategory
  -----------------------------------------
               
3. DimSalesCountry  (SalesCountryKey,
                     SalesCountryAlternate,
                     CountryName
                     )
   Source: Sales.SalesTerritory
           Sales.SalesOrderHeader
  ------------------------------------------    
                 
4. DimTime    (TimeKey,
               FullDateAlternateKey,
               MonthNumberOfYear,
               EnglishMonthName,
               CalenderQuater(tinyint,null),
               CalenderYear(Char(4),null),
               FiscalQuater(tinyint,null),
               FiscalYear(char(4),null)
               )
    Source: Sales.SalesOrderHeader
   ------------------------------------------
                
5. FactInternetSales(ProductKey,
					 SalesCountryKey
					 OrderDateKey
					 DueDateKey ,
					 ShipDateKey 
					 SalesOrderNumber
					 ProductStandardCost
					 TotalProductStandardCost
					 SalesAmount
					 OrderQuantity
					 NetProfitAmount

                     )
                     
 
 6. FactResellerSales(EmployeeKey,
                      ProductKey,
					  SalesCountryKey
					  OrderDateKey
					  DueDateKey ,
					  ShipDateKey 
					  SalesOrderNumber
					  ProductStandardCost
					  TotalProductStandardCost
					  SalesAmount
					  OrderQuantity
					  NetProfitAmount
                      )                  
               
             
                     

*/




----Creating Dimensions. 

USE Project_DataMart
--DimEmployee
CREATE TABLE   DimEmployee(
						   EmployeeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						   EmployeeNationalIDAlternateKey NVARCHAR(15) NOT NULL UNIQUE,
						   FristName NVARCHAR(50) NOT NULL,
						   LastName  NVARCHAR(50) NOT NULL,
						   MiddleName NVARCHAR(50) NOT NULL,
						   EffectiveDate DATETIME NOT NULL,
						   ExpiredDate   DATETIME NULL,
						   Status NVARCHAR(50) NULL
					       )
					  
--DimProduct					  				   
CREATE TABLE   DimProduct (
						   ProductKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						   ProductAlternateKey NVARCHAR(25) NOT NULL UNIQUE ,
						   StandardCost MONEY NULL,
						   ProductCategoryName NVARCHAR(50) NOT NULL,
						   ProductSubcategoryName NVARCHAR(50) NOT NULL,
						   EffectiveDate DATETIME NOT NULL,
						   ExpiredDate   DATETIME NULL,
						   Status NVARCHAR(50) NULL
                          )					   
--DimSalesCountry
CREATE TABLE   DimSalesCountry  (
                                 SalesCountryKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
                                 SalesCountryAlternateKey INT NOT NULL UNIQUE,
                                 CountryName NVARCHAR(50) NOT NULL
                                )
                                
--DimTime
CREATE TABLE   DimTime    (
						   TimeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
						   FullDateAlternateKey NVARCHAR(20) NOT NULL,---MONTH/YEAR PART
						   MonthNumberOfYear TINYINT NULL,
						   EnglishMonthName NVARCHAR(25) NULL,
						   CalenderQuater TINYINT NULL,
						   CalenderYear CHAR(4) NULL,
						   FiscalQuater TINYINT NULL,
						   FiscalYear CHAR(4) NULL
					      )


--FactInternetSales
CREATE TABLE   FactInternetSales(
								 ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey) ,
								 SalesCountryKey INT FOREIGN KEY REFERENCES DimSalesCountry(SalesCountryKey),
								 OrderDateKey  INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 DueDateKey    INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 ShipDateKey   INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 OrderQuantity SMALLINT NULL,
								 SalesOrderNumber NVARCHAR(20) NOT NULL,
								 ProductStandardCost MONEY NULL,
								 TotalProductStandardCost MONEY NULL,
								 SalesAmount MONEY NULL,
								 NetProfitAmount MONEY NULL
                                )

--FactResellerSales
CREATE TABLE   FactResellerSales(
                                 EmployeeKey INT FOREIGN KEY REFERENCES DimEmployee(EmployeeKey),
								 ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey),
								 SalesCountryKey INT FOREIGN KEY REFERENCES DimSalesCountry(SalesCountryKey),
								 OrderDateKey  INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 DueDateKey    INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 ShipDateKey   INT FOREIGN KEY REFERENCES  DimTime(TimeKey),
								 OrderQuantity SMALLINT NULL,
								 SalesOrderNumber NVARCHAR(20) NOT NULL,
								 ProductStandardCost MONEY NULL,
								 TotalProductStandardCost MONEY NULL,
								 SalesAmount MONEY NULL,
								 NetProfitAmount MONEY NULL
                                )




--==========================================================================================================





      
          







SELECT TOP 20 * from  Sales.SalesTerritory




 SELECT Purchasing.PurchaseOrderDetail
 SELECT TOP 1 * FROM Production.ProductCostHistory
 SELECT SSOD.ProductID, SSOD.UnitPrice,SSOD.LineTotal,PP.StandardCost from Sales.SalesOrderDetail SSOD
 INNER JOIN Production.Product PP
 ON PP.ProductID = SSOD.ProductID WHERE PP.StandardCost < SSOD.UnitPrice
 SELECT TOP 1 * from Sales.SalesOrderHeader 
 SELECT TOP 1 * from Sales.SalesOrderDetail
 SELECT TOP 1 * From Production.Product
 select *  FROM Production.ProductListPriceHistory where ProductID = 709