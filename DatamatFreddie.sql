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


/*
A dump for SalesOrderHeader and SalesOrderDetails: 
It will be needed for joins in creatint the fact tables. 
*/

--TABLE FOR SALES ORDER DETAIL DUMP
SELECT * INTO DumpSalesOrderDetail 
 FROM ProjectOLTP.Sales.SalesOrderDetail
  WHERE 1=2

--Table for Sales Order Header Dump

SELECT * INTO DumpSalesOrderHeader
   FROM ProjectOLTP.Sales.SalesOrderHeader 
   WHERE 1=2
   
---Had problems with identity colummn in SalesOrderHeader
--Droping the Identity property on the columns

ALTER TABLE DUMPSalesOrderHeader
ALTER COLUMN SalesOrderID INT 

ALTER TABLE DUMPSalesOrderDetail
ALTER COLUMN SalesOrderDetailID INT 

ALTER TABLE DUMPSalesOrderDetail
ALTER COLUMN SalesOrderID INT 
---------------------------------------------------------------
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
                                
                                
                                
---=========================================================================================================

    /*
    MY DAMP INTO THE STAGING AREA
   */
   
   ---1-----
CREATE PROC DUMPEMPLOYEE 
AS 
BEGIN
WITH MYEMPLOYEE(
				   --EmployeeID,
				   EmployeeNationalIDAlternateKey, 
				   FirstName ,
				   LastName  ,
				   MiddleName
				   --DATACHECK
			    ) AS
			    (
			    SELECT --HRE.EmployeeID,
			           HRE.NationalIDNumber,
			           PC.FirstName,
			           PC.LastName,
			           PC.MiddleName
			           --CHECKSUM(HRE.NationalIDNumber,PC.FirstName,PC.LastName)
			           
			    FROM ProjectOLTP.HumanResources.Employee HRE
					
					INNER JOIN ProjectOLTP.Person.Contact PC
					ON PC.ContactID = HRE.ContactID
			        )
			        
MERGE INTO DimEMP AS TARGET
USING MYEMPLOYEE AS SOURCE
      ON TARGET.EmployeeNationalIDAlternateKey = SOURCE.EmployeeNationalIDAlternateKey AND 
         CHECKSUM(Target.EmployeeNationalIDAlternateKey,Target.FirstName,Target.LastName) = 
         CHECKSUM(SOURCE.EmployeeNationalIDAlternateKey,SOURCE.FirstName,SOURCE.LastName)
      
      WHEN NOT MATCHED BY TARGET 
      THEN    INSERT (
                   EmployeeNationalIDAlternateKey, 
				   FirstName ,
				   LastName  ,
				   MiddleName
				   --DATACHECK
				 ) VALUES (
				           EmployeeNationalIDAlternateKey, 
						   FirstName ,
						   LastName  ,
						   MiddleName
						   );
END						   
EXEC DUMPEMPLOYEE


---2----
--DUMP PRODUCT

CREATE PROC DUMPPRODUCT 
AS 
BEGIN
WITH MYPRODUCT(
			   ProductAlternateKey,
               StandardCost,
               ProductCategoryName,
               ProductSubcategoryName
			    ) AS
			    (
			    SELECT P.ProductNumber,
					   P.StandardCost,
					   PC.Name,
					   PS.Name
			           
			    FROM ProjectOLTP.Production.Product P
					
					INNER JOIN ProjectOLTP.Production.ProductSubcategory PS
					ON PS.ProductSubcategoryID = P.ProductSubcategoryID
					INNER JOIN ProjectOLTP.Production.ProductCategory PC
					ON PC.ProductCategoryID = PS.ProductCategoryID
			        )
			        
MERGE INTO DimPDT AS TARGET
USING MYPRODUCT AS SOURCE
      ON TARGET.ProductAlternateKey = SOURCE.ProductAlternateKey AND 
         CHECKSUM(Target.ProductAlternateKey,Target.ProductCategoryName,Target.ProductSubcategoryName) = 
         CHECKSUM(SOURCE.ProductAlternateKey,SOURCE.ProductCategoryName,SOURCE.ProductSubcategoryName)
      
      WHEN NOT MATCHED BY TARGET 
      THEN    INSERT (
                   ProductAlternateKey,
				   StandardCost,
				   ProductCategoryName,
				   ProductSubcategoryName
				 ) VALUES (
				           ProductAlternateKey,
						   StandardCost,
						   ProductCategoryName,
						   ProductSubcategoryName
						   
						   );
END						   
EXEC DUMPPRODUCT


----3-----
--DUMP Sales COUNTRY
ALTER PROC DUMPSC 
AS 
BEGIN
WITH MYSALESCTY(
			  
				 SalesCountryAlternateKey,
				 CountryName
			    ) AS
			    (
			    SELECT DISTINCT SSOH.TerritoryID,
					   SST.Name
					   
			           
			    FROM ProjectOLTP.Sales.SalesOrderHeader SSOH
					
					INNER JOIN ProjectOLTP.Sales.SalesTerritory SST
					ON SSOH.TerritoryID= SST.TerritoryID
					
			        )
			        
MERGE INTO DimSC AS TARGET
USING MYSALESCTY AS SOURCE
      ON TARGET.SalesCountryAlternateKEy = SOURCE.SalesCountryAlternateKey AND 
         CHECKSUM(Target.SalesCountryAlternateKey,Target.CountryName) = 
         CHECKSUM(SOURCE.SalesCountryAlternateKey,SOURCE.CountryName)
      
      WHEN NOT MATCHED BY TARGET 
      THEN    INSERT (
                   SalesCountryAlternateKey,
				   CountryName
				 ) VALUES (
				           SalesCountryAlternateKey,
				           CountryName
						   
						   );
END


-----5----
--DIM TIME

ALTER PROC DUMPTIME 
AS 
BEGIN
WITH MYTIME (
             ORDERDATE,
             MonthNumberOfYear,
             EnglishMonthName,
             CalenderQuater,
             CalenderYear,
             FiscalQuater,
             FiscalYear
             ) AS 
             (
             SELECT DISTINCT SOH.OrderDate,
                    DATEPART(MM,SOH.OrderDate) MonthNumberOfYear,
                    DATENAME(MONTH,SOH.OrderDate) EnglishMonthName,
                    DATEPART(QUARTER,SOH.OrderDate) CalenderQuater,
                    YEAR(SOH.OrderDate) CalenderYear,
                    DATEPART(QUARTER,SOH.OrderDate) CalenderQuater,
                    dbo.FISCALYEAR(SOH.Orderdate) FiscalYear
			        
             FROM Project_Staging.dbo.DumpSalesOrderHeader SOH
             
				 INNER JOIN Project_Staging.dbo.DumpSalesOrderDetail SOD
				 ON SOD.SalesOrderID = SOH.SalesOrderID 
               )
   MERGE INTO DimTime AS TARGET
   USING MYTIME AS SOURCE 
   
   ON TARGET.FullDateAlternateKey = SOURCE.ORDERDATE
   
   WHEN NOT MATCHED BY TARGET THEN
         INSERT (
                 FullDateAlternateKey,
				 MonthNumberOfYear,
				 EnglishMonthName,
				 CalenderQuater,
				 CalenderYear,
				 FiscalQuater,
				 FiscalYear)
				 VALUES (
				         ORDERDATE,
						 MonthNumberOfYear,
						 EnglishMonthName,
						 CalenderQuater,
						 CalenderYear,
						 FiscalQuater,
						 FiscalYear
						 );
   
END 

---4----
-----------------------------------------------
--Dump Store Proc into dbo.DumpSalesOrderDetail
-----------------------------------------------
CREATE PROC DUMP_SalesOrderDetail
AS
BEGIN
WITH MYSOD(
				   SalesOrderID,
				   SalesOrderDetailID, 
				   CarrierTrackingNumber ,
				   OrderQty  ,
				   ProductID,
				   SpecialOfferID,
				   UnitPrice,
				   UnitPriceDiscount,
				   LineTotal,
				   rowguid,
				   ModifiedDate
				  
			    ) AS
			    (
			    SELECT 
			           SalesOrderID,
					   SalesOrderDetailID, 
					   CarrierTrackingNumber ,
					   OrderQty  ,
					   ProductID,
					   SpecialOfferID,
					   UnitPrice,
					   UnitPriceDiscount,
					   LineTotal,
					   rowguid,
					   ModifiedDate
			           
			           
			    FROM ProjectOLTP.Sales.SalesOrderDetail SOD
					
			        )
			        
MERGE INTO DumpSalesOrderDetail AS TARGET
USING MYSOD AS SOURCE
      ON TARGET.SalesOrderDetailID = SOURCE.SalesOrderDetailID AND
         TARGET.SalesOrderID = SOURCE.SalesOrderID
      
      WHEN NOT MATCHED BY TARGET 
      THEN    INSERT (
                   SalesOrderID,
					   SalesOrderDetailID, 
					   CarrierTrackingNumber ,
					   OrderQty  ,
					   ProductID,
					   SpecialOfferID,
					   UnitPrice,
					   UnitPriceDiscount,
					   LineTotal,
					   rowguid,
					   ModifiedDate
				 ) VALUES (
				       SalesOrderID,
					   SalesOrderDetailID, 
					   CarrierTrackingNumber ,
					   OrderQty  ,
					   ProductID,
					   SpecialOfferID,
					   UnitPrice,
					   UnitPriceDiscount,
					   LineTotal,
					   rowguid,
					   ModifiedDate
						   );
						   
END

--5--
-----------------------------------------------
--Dump Store Proc into dbo.DumpSalesOrderHeader
-----------------------------------------------
ALTER PROC DUMP_SalesOrderHeader
AS
BEGIN
WITH MYSOH(
				   SalesOrderID,
				   RevisionNumber, 
				   OrderDate ,
				   DueDate  ,
				   ShipDate,
				   Status,
				   OnlineOrderFlag,
				   SalesOrderNumber,
				   PurchaseOrderNumber,
				   AccountNumber,
				   CustomerID,
				   ContactID,
				   SalesPersonID,
				   TerritoryID,
				   BillToAddressID,
				   ShipToAddressID,
				   ShipMethodID,
				   CreditCardID,
				   CreditCardApprovalCode,
				   CurrencyRateID,
				   SubTotal,
				   TaxAmt,
				   Freight,
				   TotalDue,
				   Comment,
				   rowguid,
				   ModifiedDate
				  
			    ) AS
			    (
			    SELECT 
			           SalesOrderID,
					   RevisionNumber, 
					   OrderDate ,
					   DueDate  ,
					   ShipDate,
					   Status,
					   OnlineOrderFlag,
					   SalesOrderNumber,
					   PurchaseOrderNumber,
					   AccountNumber,
					   CustomerID,
					   ContactID,
					   SalesPersonID,
					   TerritoryID,
					   BillToAddressID,
					   ShipToAddressID,
					   ShipMethodID,
					   CreditCardID,
					   CreditCardApprovalCode,
					   CurrencyRateID,
					   SubTotal,
					   TaxAmt,
					   Freight,
					   TotalDue,
					   Comment,
					   rowguid,
					   ModifiedDate
			           
			           
			    FROM ProjectOLTP.Sales.SalesOrderHeader SOH
					
			        )
			        
MERGE INTO DumpSalesOrderHeader AS TARGET
USING MYSOH AS SOURCE
      ON TARGET.SalesOrderID = SOURCE.SalesOrderID 
      
      WHEN NOT MATCHED BY TARGET 
      THEN    INSERT (
                       SalesOrderID,
				   RevisionNumber, 
				   OrderDate ,
				   DueDate  ,
				   ShipDate,
				   Status,
				   OnlineOrderFlag,
				   SalesOrderNumber,
				   PurchaseOrderNumber,
				   AccountNumber,
				   CustomerID,
				   ContactID,
				   SalesPersonID,
				   TerritoryID,
				   BillToAddressID,
				   ShipToAddressID,
				   ShipMethodID,
				   CreditCardID,
				   CreditCardApprovalCode,
				   CurrencyRateID,
				   SubTotal,
				   TaxAmt,
				   Freight,
				   TotalDue,
				   Comment,
				   rowguid,
				   ModifiedDate
				 ) VALUES (
				       SalesOrderID,
				   RevisionNumber, 
				   OrderDate ,
				   DueDate  ,
				   ShipDate,
				   Status,
				   OnlineOrderFlag,
				   SalesOrderNumber,
				   PurchaseOrderNumber,
				   AccountNumber,
				   CustomerID,
				   ContactID,
				   SalesPersonID,
				   TerritoryID,
				   BillToAddressID,
				   ShipToAddressID,
				   ShipMethodID,
				   CreditCardID,
				   CreditCardApprovalCode,
				   CurrencyRateID,
				   SubTotal,
				   TaxAmt,
				   Freight,
				   TotalDue,
				   Comment,
				   rowguid,
				   ModifiedDate
						   );
						   
END



/*
--===========================================
--Store Procedure for my dumps to Staging.
==============================================
*/
ALTER  PROC MYDUMPS
AS
BEGIN
EXEC DUMPSC --Dump into the DimSC
EXEC DUMPPRODUCT--Dump into the DIMPDT
EXEC DUMPEMPLOYEE---Dump into the DimEmployee
EXEC DUMP_SalesOrderDetail --Dump into DumpSalesOrderDetail
EXEC DUMP_SalesOrderHeader --Dump into DumpSalesOrderHeader
EXEC DUMPTIME--Dump into DimTim
END

EXEC MYDUMPS


--============================================
--FUNCTIONS: 
--============================================
---FISCAL YEAR FUNCTION
------------------------           
 CREATE FUNCTION FISCALYEAR(@Date DateTime)
 RETURNS INT
 AS
 BEGIN
 RETURN
        CASE 
		  WHEN MONTH(@Date) > 6 
		   THEN YEAR(@Date) + 1
		   ELSE YEAR(@Date)
		  END --AS FicalYear  
 END   
SEleCT dbo.FISCALYEAR(GETDATE())      

---FISCAL QUATER FUNCTION
---------------------------
ALTER FUNCTION FISCALQUATER(@Date Datetime)
RETURNS INT
AS 
BEGIN
RETURN 
      --declare @mydate date = '04/01/2012'
--SELECT
    --@mydate as date,
    CASE
        WHEN MONTH(@date) BETWEEN 1  AND 3  THEN 1
        WHEN MONTH(@date) BETWEEN 4  AND 6  THEN 2 
        WHEN MONTH(@date) BETWEEN 7  AND 9  THEN 3   
        WHEN MONTH(@date) BETWEEN 10 AND 12 THEN 4 
    END 
 END
 
 
 
 --=============================================
 --Stored Procedues for staging to DatawareHousse. 
 --=============================================  
 
 --From DimEMP to DIMEMPLOYEE
 ----------------------------
 
 --DIMEMP to DIMEMPLOYEE
--FirstName,LastName--- SCD Type 2
--

--1.DUMP_TO_STAGING_EMPLOYEE:
----------------------------
CREATE PROC DUMP_TO_STAGING_EMPLOYEE
AS
BEGIN

	INSERT INTO DimEmployee
SELECT EmployeeNationalIDAlternateKey,
       FirstName,
       LastName,
       ISNULL(MiddleName,''),
       EffectiveDate,
       ExpiredDate,
       Status1
 FROM
 (
MERGE DimEMployee AS TARGET
USING DimEMP AS SOURCE
 
ON TARGET.EmployeeNationalIDAlternateKey = SOURCE.EmployeeNationalIDAlternateKey
    --AND Target.Status1 = 'Current'
		--AND CHECKSUM(TARGET.EmployeeNationalIDAlternateKey,TARGET.FirstName,TARGET.LastName) = 
		--	CHECKSUM(TARGET.EmployeeNationalIDAlternateKey,TARGET.FirstName,TARGET.LastName)

WHEN NOT MATCHED BY TARGET
                    --THEN DO A NEW INSERT

                    THEN 
                         INSERT (EmployeeNationalIDAlternateKey,
                                 FirstName,
                                 LastName,
                                 MiddleName,
                                 EffectiveDate,
                                 Status1
                                 )
                                 VALUES 
                                       (
                                        SOURCE.EmployeeNationalIDAlternateKey,
                                        SOURCE.FirstName,
                                        SOURCE.Lastname,
                                        ISNULL(MiddleName,''),
                                        GETDATE(),
                                        'Current'
                                        )--;ROLLBACK TRAN
  WHEN MATCHED  
                    AND
                        (SOURCE.Firstname<> Target.Firstname
                     OR  SOURCE.Lastname <> Target.LastName)
                    AND TARGET.Status1 = 'Current'
                    THEN 
                    UPDATE 
                          SET Status1 = 'NOTCURRENT',
                              ExpiredDate = GETDATE()
                              
  WHEN NOT MATCHED BY SOURCE AND TARGET.Status1 = 'Current'
   THEN                 
       UPDATE SET Status1 = 'NOTCURRENT',
                  ExpiredDate = GETDATE()
    OUTPUT $action AS Action_OUT
        ,SOURCE.EmployeeNationalIDAlternateKey,SOURCE.FirstName,SOURCE.LastName,SOURCE.MiddleName,GETDATE() EffectiveDate,NULL ExpiredDate,'CURRENT' Status1
) AS MergeOutput
WHERE MergeOutput.Action_OUT = 'UPDATE'
  
;                                  
END

--Testing Employee Proc.
-------------------------
EXEC DUMP_TO_STAGING_EMPLOYEE

SELECT * FROM DIMEMPLOYEE
TRUNCATE TABLE DIMEMPLOYEE       


--=========================
--2. DUMP_TO_STAGING_PRODUCT 

CREATE PROC DUMP_TO_STAGING_PRODUCT
AS
BEGIN

	INSERT INTO DimProduct
SELECT ProductAlternateKey,
       StandardCost,
       ProductCategoryName,
       ProductSubcategoryName,
       EffectiveDate,
       ExpiredDate,
       Status
 FROM
 (
MERGE DimProduct AS TARGET---STAGING
USING DimPDT AS SOURCE ---PRESTAGING
 
ON TARGET.ProductAlternateKey = SOURCE.ProductAlternateKey
    --AND Target.Status1 = 'Current'
		--AND CHECKSUM(TARGET.EmployeeNationalIDAlternateKey,TARGET.FirstName,TARGET.LastName) = 
		--	CHECKSUM(TARGET.EmployeeNationalIDAlternateKey,TARGET.FirstName,TARGET.LastName)

WHEN NOT MATCHED BY TARGET
                    --THEN DO A NEW INSERT

                    THEN 
                         INSERT (  ProductAlternateKey,
								   StandardCost,
								   ProductCategoryName,
								   ProductSubcategoryName,
								   EffectiveDate,
								   Status
                                 )
                                 VALUES 
                                       (
                                       SOURCE.ProductAlternateKey,
									   SOURCE.StandardCost,
									   SOURCE.ProductCategoryName,
									   SOURCE.ProductSubcategoryName,
                                       GETDATE(),
                                       'Current'
                                        )
  WHEN MATCHED  
                    AND
                        (SOURCE.ProductCategoryName<> Target.ProductCategoryName
                     OR  SOURCE.ProductSubcategoryName <> Target.ProductSubcategoryName
                     OR   SOURCE.StandardCost <> TARGET.StandardCost)
                    AND TARGET.Status = 'Current'
                    THEN 
                    UPDATE 
                          SET Status = 'NOTCURRENT',
                              ExpiredDate = GETDATE(),
                              --COST IS TYPE1 : I'm not interested in the previous price. 
                              TARGET.StandardCost = SOURCE.StandardCost                   
  --The case of a deleted item
  ------------------------------                                            
  WHEN NOT MATCHED BY SOURCE AND TARGET.Status = 'Current'
   THEN                 
       UPDATE SET Status = 'NOTCURRENT',
                  ExpiredDate = GETDATE()
                  
    ---Perform an insert on all type2 changes and mark as current.               
    OUTPUT $action AS Action_OUT
        ,
       SOURCE.ProductAlternateKey,
	   SOURCE.StandardCost,
	   SOURCE.ProductCategoryName,
	   SOURCE.ProductSubcategoryName,
       GETDATE() EffectiveDate,
       NULL ExpiredDate,
       'Current' Status
        
) AS MergeOutput
WHERE MergeOutput.Action_OUT = 'UPDATE'
  
;                                  
END

--Testing Product Proc.
EXEC DUMP_TO_STAGING_PRODUCT
SELECT * FROM DimPDT
SELECT * FROM DIMPRODUCT
TRUNCATE TABLE DIMPRODUCT 

--===========================================
--Store Procedure for my dumps to Staging.
--==============================================
--MASTER TRANSFER TO STAGING
CREATE  PROC MYDUMPS_TO_STAGING
AS
BEGIN
EXEC DUMP_TO_STAGING_EMPLOYEE
EXEC DUMP_TO_STAGING_PRODUCT
EXEC DUMP_TO_STAGING_SALES_COUNTRY
END
EXEC MYDUMPS_TO_STAGING

--============================================== 
--STORED PROCEDURES TO DO PRESTAGING AND STAGING
--==============================================
CREATE PROC PRESTAGING_AND_STAGING
AS
BEGIN
EXEC MYDUMPS ---ALL INCREMENTAL LOADS to PRESTAGING
EXEC MYDUMPS_TO_STAGING --- ALL LOADS TO STAGING DIMS
END
--TESTING PRESTAGING_AND_STAGING PROC
EXEC PRESTAGING_AND_STAGING

--SP_CONFIGURE 'nested_triggers',0
--GO
--RECONFIGURE
--GO


SELECT TOP 20 * from  DumpSalesOrderDetail
SELECT TOP 20 * from  DumpSalesOrderHeader
SELECT TOP 10 * from  DimEmployee
SELECT TOP 10 * FROM  DimTime


                 