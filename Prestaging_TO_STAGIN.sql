/*
	PRESTAGING TABLES
	
	1. DIMEMP---Employee
	2. DIMSC----Sales Country
	3. DIMTIME  Dim Tim

*/

---FROM DUMP TO STAGGING TABLES. 

--DIMEMP to DIMEMPLOYEE
--FirstName,LastName--- SCD Type 2
--
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
EXEC DUMP_TO_STAGING_EMPLOYEE

SELECT * FROM DIMEMPLOYEE
TRUNCATE TABLE DIMEMPLOYEE
--=============================================================================================================

--DIMEMP to DIMEMPLOYEE
--FirstName,LastName--- SCD Type 2
--
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
MERGE DimProduct AS TARGET
USING DimPDT AS SOURCE
 
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

SELECT * FROM DIMPRODUCT
TRUNCATE TABLE DIMPRODDUCT


--======================================================================================================================
--DUMP_TO_STAGING_SALES_COUNTRY
CREATE PROC DUMP_TO_STAGING_SALES_COUNTRY
AS
BEGIN

	MERGE INTO DimSalesCountry AS TARGET
USING DimSC AS SOURCE
      ON TARGET.SalesCountryAlternateKEy = SOURCE.SalesCountryAlternateKey 
      --AND 
         --CHECKSUM(Target.SalesCountryAlternateKey,Target.CountryName) = 
         --CHECKSUM(SOURCE.SalesCountryAlternateKey,SOURCE.CountryName)
      
      WHEN NOT MATCHED BY TARGET 
      THEN    INSERT (
                   SalesCountryAlternateKey,
				   CountryName
				 ) VALUES (
				           SalesCountryAlternateKey,
				           CountryName
						   
						   );
END


--======================================

SELECT * FROM DIMSalesCOuntry
EXEC DUMP_TO_STAGING_SALES_COUNTRY
SELECT * FROM DimSalesCountry