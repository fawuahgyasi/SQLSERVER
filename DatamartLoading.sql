
USE Project_DataMart
ALTER TABLE DimEmployee
ADD EffectiveDate Datetime,ExpiredDate Datetime,Status Varchar(50)

ALTER TABLE DimProduct
ADD EffectiveDate Datetime,ExpiredDate Datetime,Status Varchar(50)


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
ALTER PROC DUMP_TO_STAGING_EMPLOYEE
AS
BEGIN

	INSERT INTO Project_DataMart..DimEmployee
SELECT EmployeeNationalIDAlternateKey,
       FirstName,
       LastName,
       ISNULL(MiddleName,''),
       EffectiveDate,
       ExpiredDate,
       Status1
 FROM
 (
MERGE Project_DataMart..DimEmployee AS TARGET
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
--2. DUMP_TO_DataWareHouse_PRODUCT 

ALTER PROC DUMP_TO_STAGING_PRODUCT
AS
BEGIN

	INSERT INTO Project_DataMart..DimProduct
SELECT ProductAlternateKey,
       StandardCost,
       ProductCategoryName,
       ProductSubcategoryName,
       EffectiveDate,
       ExpiredDate,
       Status
 FROM
 (
MERGE Project_DataMart..DimProduct AS TARGET---STAGING
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


---DimTime

ALTER PROC DUMPTIME 
AS 
BEGIN
WITH MYTIME (
             FullDateAlternateKey,
             MonthNumberOfYear,
             EnglishMonthName,
             CalenderQuater,
             CalenderYear,
             FiscalQuater,
             FiscalYear
             ) AS 
             (
             SELECT 
					 FullDateAlternateKey,
					 MonthNumberOfYear,
					 EnglishMonthName,
					 CalenderQuater,
					 CalenderYear,
					 FiscalQuater,
					 FiscalYear 
             FROM Project_Staging..DimTime
			        
               )
   MERGE INTO Project_DataMart..DimTime AS TARGET
   USING MYTIME AS SOURCE 
   
   ON TARGET.FullDateAlternateKey = SOURCE.FullDateAlternateKey
   
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
				         FullDateAlternateKey,
						 MonthNumberOfYear,
						 EnglishMonthName,
						 CalenderQuater,
						 CalenderYear,
						 FiscalQuater,
						 FiscalYear
						 );
   
END


---DIM SALES COUNTRY

CREATE PROC SalesCountryDW 
AS 
BEGIN
WITH MYSALESCTY(
			  
				 SalesCountryAlternateKey,
				 CountryName
			    ) AS
			    (
			    SELECT 
			    
			            SalesCountryAlternateKey,
				        CountryName
					   
			           
			    FROM Project_Staging..DimSC
					
			        )
			        
MERGE INTO Project_DataMart..DimSalesCountry AS TARGET
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



INSERT INTO Project_DataMart..FactInternetSales

--DUMP INTO THE FactIntenetSales

WITH MYFACTINTRESELL (  
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
                      INSERT INTO Project_DataMart..FactInternetSales 
                      SELECT 
                            ProductKey,
						   SalesCountryKey,
						   OrderQty,
						   StandardCost,
						   TotalProductStandardCost, 
						   SalesAmount , 
						   NetProfitAmount
				       FROM MYFACTINTRESELL
                     
                      
 ---FactInternetSales

 GO
 WITH MYFACTRESELLER (  
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
				      
				      
					  INNER JOIN Project_Staging..DimPDT DP
					  ON P.ProductNumber = DP.ProductAlternateKey
				      
					  INNER JOIN Project_Staging..DimSC DSC
					  ON SSOH.TerritoryID = DSC.SalesCountryAlternateKey
				      
					  INNER JOIN Project_Staging..DimTime DT
					  ON SSOH.OrderDate = DT.FullDateAlternateKey
				      
					  INNER JOIN Project_Staging..DimEMP DE
					  ON HRE.NationalIDNumber = DE.EmployeeNationalIDAlternateKey

                      )                     
                      INSERT INTO Project_DataMart..FactInternetSales 
                      SELECT 
                           ProductKey,
						   SalesCountryKey,
						   OrderQty,
						   StandardCost,
						   TotalProductStandardCost, 
						   SalesAmount , 
						   NetProfitAmount
				       FROM MYFACTRESELLER
      









---------------------------
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

