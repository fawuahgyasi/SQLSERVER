SELECT HRE.EMPLOYEEID,
       PC.FirstName+' ' + ISNULL(PC.MiddleName,' ') + ' ' + PC.LastName [Full Name],
       HRE.Title,
       PA.AddressLine1,
       PA.City,
       PA.PostalCode,
       PSP.Name State,
       PCR.Name Country
       
FROM AdventureWorks.HumanResources.Employee HRE

INNER JOIN AdventureWorks.Person.Contact PC
ON PC.ContactID = HRE.ContactID 

INNER JOIN AdventureWorks.HumanResources.EmployeeAddress HREA
ON HRE.EmployeeID = HREA.EmployeeID 
INNER JOIN AdventureWorks.Person.Address PA
ON PA.AddressID = HREA.AddressID 
INNER JOIN AdventureWorks.Person.StateProvince PSP
ON PSP.StateProvinceID = PA.StateProvinceID
INNER JOIN Person.CountryRegion PCR
ON PCR.CountryRegionCode = PSP.CountryRegionCode


SELECT 
       PC.EnglishProductCategoryName ProductCategoryName,
       PS.EnglishProductSubcategoryName ProductSubcategoryName,
       P.EnglishProductName ProductName,
       SUM(FRS.OrderQuantity) Quantity,
       SUM(FRS.SalesAmount)   TotalAmount
       
       
FROM DimProduct P
INNER JOIN dbo.DimProductSubcategory PS
ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory PC
ON PC.ProductCategoryKey = PS.ProductCategoryKey
INNER JOIN dbo.FactResellerSales FRS
ON FRS.ProductKey = P.ProductKey

GROUP BY  PC.EnglishProductCategoryName ,
       PS.EnglishProductSubcategoryName ,
       P.EnglishProductName 
       
       
       
       SELECT DISTINCT EnglishProductCategoryName
FROM            DimProductCategory


SELECT Distinct EnglishProductSubcategoryName
FROM DimProductSubcategory PS
INNER JOIN DimProductCategory PC
ON PS.ProductCategoryKey= PC.ProductCategoryKey
AND PC.EnglishProductCategoryName = @ProdCat


select distinct PCR.Name
from person.CountryRegion PCR
INNER JOIN Person.StateProvince PSP
ON PSP.CountryRegionCode = PCR.CountryRegionCode
INNER JOIN Person.Address PA
ON PA.StateProvinceID = PSP.StateProvinceID
WHERE PSP.Name = @StateName

SELECT DISTINCT Name
FROM            Person.CountryRegion AS PCR




SELECT  DST.SalesTerritoryGroup,
        DST.SalesTerritoryCountry Country,
        DR.ResellerName Reseller, 
        PC.EnglishProductCategoryName ProductCategory,
        SUM(FRS.OrderQuantity) Qty,
        SUM(FRS.SalesAmount) SalesAmount
FROM dbo.DimProduct P
		INNER JOIN dbo.DimProductSubcategory PS
		ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
		INNER JOIN dbo.DimProductCategory PC
		ON PC.ProductCategoryKey = PS.ProductCategoryKey 
		INNER JOIN FactResellerSales FRS
		ON FRS.ProductKey = P.ProductKey 
		INNER JOIN DimReseller DR
		ON DR.ResellerKey = FRS.ResellerKey 
		INNER JOIN DimGeography DG
		ON DG.GeographyKey = DR.GeographyKey
		INNER JOIN DimSalesTerritory DST
		ON DST.SalesTerritoryKey = DG.SalesTerritoryKey
GROUP BY 
        DST.SalesTerritoryGroup,
        DST.SalesTerritoryCountry ,
        DR.ResellerName , 
        PC.EnglishProductCategoryName 



-------------------------------------------------
SELECT  DST.SalesTerritoryGroup,
        DST.SalesTerritoryCountry Country,
        --DR.ResellerName Reseller, 
        PC.EnglishProductCategoryName ProductCategory,
        SUM(FRS.OrderQuantity) Qty,
        SUM(FRS.SalesAmount) SalesAmount
FROM dbo.DimProduct P
		INNER JOIN dbo.DimProductSubcategory PS
		ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
		INNER JOIN dbo.DimProductCategory PC
		ON PC.ProductCategoryKey = PS.ProductCategoryKey 
		INNER JOIN FactResellerSales FRS
		ON FRS.ProductKey = P.ProductKey 
		INNER JOIN DimReseller DR
		ON DR.ResellerKey = FRS.ResellerKey 
		INNER JOIN DimGeography DG
		ON DG.GeographyKey = DR.GeographyKey
		INNER JOIN DimSalesTerritory DST
		ON DST.SalesTerritoryKey = DG.SalesTerritoryKey
GROUP BY 
        DST.SalesTerritoryGroup,
        DST.SalesTerritoryCountry ,
        --DR.ResellerName , 
        PC.EnglishProductCategoryName




SELECT 
        DR.ResellerName Reseller,
        DG.City, 
        DG.StateProvinceName,
        SUM(FRS.OrderQuantity) Qty,
        SUM(FRS.SalesAmount) SalesAmount
FROM dbo.DimProduct P
		INNER JOIN dbo.DimProductSubcategory PS
		ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
		INNER JOIN dbo.DimProductCategory PC
		ON PC.ProductCategoryKey = PS.ProductCategoryKey 
		INNER JOIN FactResellerSales FRS
		ON FRS.ProductKey = P.ProductKey 
		INNER JOIN DimReseller DR
		ON DR.ResellerKey = FRS.ResellerKey 
		INNER JOIN DimGeography DG
		ON DG.GeographyKey = DR.GeographyKey
		INNER JOIN DimSalesTerritory DST
		ON DST.SalesTerritoryKey = DG.SalesTerritoryKey
		WHERE DST.SalesTerritoryCountry = 'United States'
GROUP BY 
        DR.ResellerName ,
        DG.City, 
        DG.StateProvinceName
