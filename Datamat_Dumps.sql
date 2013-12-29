SELECT HRE.EMPLOYEEID,PC.FIRSTNAME,PC.LASTNAME
FROM HumanResources.Employee HRE
INNER JOIN PERSON.CONTACT PC
on PC.ContactID = HRE.ContactID

--ALTER TABLE DimEmp
--ALTER COLUMN MiddleName nvarchar(50) NULL
--ADD  DATACHECK AS CHECKSUM(EmployeeNationalIDAlternateKey,FirstName,LastName)
--SELECT * FROM DimEMP
--ALTER TABLE Dim


/*
    MY DAMP INTO THE PRESTAGING AREA
*/
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


--DIM TIME

CREATE PROC DUMPTIME 
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
			        
             FROM ProjectOLTP.Sales.SalesOrderHeader SOH
             
				 INNER JOIN ProjectOLTP.Sales.SalesOrderDetail SOD
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



--Store Procedure for my dumps
ALTER  PROC MYDUMPS
AS
BEGIN
EXEC DUMPSC --Dump into the DimSC
EXEC DUMPPRODUCT--Dump into the DIMPDT
EXEC DUMPEMPLOYEE---Dump into the DimEmployee
EXEC DUMPTIME--Dump into DimTim
END

--Executing all the DUMP Procs. 
EXEC MYDUMPS
















































--DUMP INTO THE FactIntenetSales

WITH MYFACTRESELLER (  EmployeeKey,
				       ProductKey,
				       SalesCountryKey,
				       OrderQty,
				       StandardCost,
				       TotalProductStandardCost, 
				       SalesAmount , 
				       NetProfitAmount
				      ) AS 
				      (

				SELECT DE.EmployeeKey,
				       DP.ProductKey,
				       DSC.SalesCountryKey,
				       SSOD.OrderQty,
				       P.StandardCost,(
				       P.StandardCost * SSOD.OrderQty) TotalProductStandardCost, 
				       SSOD.LineTotal SalesAmount , 
				       SSOD.LineTotal - (P.StandardCost * SSOD.OrderQty) NetProfitAmount 

					  FROM ProjectOLTP.Sales.SalesOrderHeader SSOH
				      
					  INNER JOIN ProjectOLTP.Sales.SalesOrderDetail SSOD
					  ON SSOH.SalesOrderID = SSOD.SalesOrderID
				      
					  INNER JOIN ProjectOLTP.Production.Product P
					  ON P.ProductID = SSOD.ProductID
				      
					  INNER JOIN ProjectOLTP.HumanResources.Employee HRE
				      
					  ON SSOH.SalesPersonID = HRE.EmployeeID
				      
				      
					  INNER JOIN DimPDT DP
					  ON P.ProductNumber = DP.ProductAlternateKey
				      
					  INNER JOIN DimSC DSC
					  ON SSOH.TerritoryID = DSC.SalesCountryAlternateKey
				      
					  INNER JOIN DimTime DT
					  ON SSOH.OrderDate = DT.FullDateAlternateKey
				      
					  INNER JOIN DimEMP DE
					  ON HRE.NationalIDNumber = DE.EmployeeNationalIDAlternateKey

                      )
                      
                      
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
                      
 ---FactInternetSales

 
 WITH MYFACTRESELLER (  EmployeeKey,
				       ProductKey,
				       SalesCountryKey,
				       OrderQty,
				       StandardCost,
				       TotalProductStandardCost, 
				       SalesAmount , 
				       NetProfitAmount
				      ) AS 
				      (

				SELECT 
				       DP.ProductKey,
				       DSC.SalesCountryKey,
				       SSOD.OrderQty,
				       P.StandardCost,(
				       P.StandardCost * SSOD.OrderQty) TotalProductStandardCost, 
				       SSOD.LineTotal SalesAmount , 
				       SSOD.LineTotal - (P.StandardCost * SSOD.OrderQty) NetProfitAmount 

					  FROM ProjectOLTP.Sales.SalesOrderHeader SSOH
				      
					  INNER JOIN ProjectOLTP.Sales.SalesOrderDetail SSOD
					  ON SSOH.SalesOrderID = SSOD.SalesOrderID
				      
					  INNER JOIN ProjectOLTP.Production.Product P
					  ON P.ProductID = SSOD.ProductID
				      
					  INNER JOIN ProjectOLTP.HumanResources.Employee HRE
				      
					  ON SSOH.SalesPersonID = HRE.EmployeeID
				      
				      
					  INNER JOIN DimPDT DP
					  ON P.ProductNumber = DP.ProductAlternateKey
				      
					  INNER JOIN DimSC DSC
					  ON SSOH.TerritoryID = DSC.SalesCountryAlternateKey
				      
					  INNER JOIN DimTime DT
					  ON SSOH.OrderDate = DT.FullDateAlternateKey
				      
					  INNER JOIN DimEMP DE
					  ON HRE.NationalIDNumber = DE.EmployeeNationalIDAlternateKey

                      )                     

