/*

*/

SELECT HRE.EmployeeID,PP.ProductID,ROUND(SUM(FR.SalesAmount),2) TOTALSales

FROM DimEmployee DE
	
	INNER JOIN AdventureWorks.HumanResources.Employee HRE 
	ON DE.EmployeeNationalIDAlternateKey = HRE.NationalIDNumber
	
	INNER JOIN FactResellerSales FR
	ON FR.EmployeeKey = DE.EmployeeKey
	
	INNER JOIN DimProduct DP
	ON DP.ProductKey = FR.ProductKey
	
	INNER JOIN AdventureWorks.Production.Product PP
	ON PP.ProductNumber = DP.ProductAlternateKey
	
	INNER JOIN DimSalesTerritory DST
	ON DST.SalesTerritoryKey = FR.SalesTerritoryKey
	
	INNER JOIN DimTime DT 
	ON DT.TimeKey = FR.OrderDateKey

WHERE DATEDIFF(YY,DE.BirthDate,GETDATE())> = 40
      AND DT.CalendarQuarter IN (2,3) 
      AND DST.SalesTerritoryRegion = 'NorthWest'
      AND DT.CalendarYear = 2002

GROUP BY HRE.EmployeeID,PP.ProductID

     EXCEPT 

--USE AdventureWorks

SELECT HRE.EmployeeID, PP.ProductID,ROUND(SUM(SOD.LineTotal),2)

FROM AdventureWorks.HumanResources.Employee HRE

	INNER JOIN AdventureWorks.Sales.SalesOrderHeader SOH
	ON SOH.SalesPersonID = HRE.EmployeeID

	INNER JOIN AdventureWorks.Sales.SalesOrderDetail SOD
	
	ON SOH.SalesOrderID = SOD.SalesOrderID
	
	INNER JOIN AdventureWorks.Production.Product PP
	ON PP.ProductID = SOD.ProductID
	
	INNER JOIN AdventureWorks.Sales.SalesTerritory SST
	ON SST.TerritoryID = SOH.TerritoryID
	
	WHERE DATEDIFF(YY,HRE.BirthDate, GETDATE()) > = 40 
	      AND SST.Name = 'NorthWest'
	      AND YEAR(SOH.OrderDate) = 2002
	      AND MONTH(SOH.OrderDate) between 4 and 9
	GROUP BY HRE.EmployeeID, PP.ProductID   
	
	
/*
GET ME THE TOTALSALES of Adventureworks Company BY Product,ProductSubCategory and ProductCateggory from Monday to Friday that happened Online during the 4th quater of Fiscal Year of 2002
Column Requested in Report:-->
ProductCategory,ProductSubCategory,ProductName,MonthNameOfQuater,TotalSales
*/


----OLAP------

SELECT DPC.EnglishProductCategoryName,DPS.EnglishProductSubcategoryName,DP.EnglishProductName,DT.EnglishMonthName, SUM(FIS.SalesAmount) TOTAL_SALES
  
FROM DimProduct DP
      --From internetSales
      INNER JOIN FactInternetSales FIS
      ON FIS.ProductKey = DP.ProductKey
      
      ---Subcatecory
      INNER JOIN DimProductSubcategory DPS
      ON DPS.ProductSubcategoryKey = DP.ProductSubcategoryKey 
      
      ---Category
      INNER JOIN DimProductCategory DPC
      ON DPC.ProductCategoryKey = DPS.ProductCategoryKey
     
     ---Time
      INNER JOIN DimTime DT
      ON DT.TimeKey = FIS.OrderDateKey 
      
      
WHERE DT.DayNumberOfWeek BETWEEN 2 AND 6
      AND DT.FiscalYear =2002
      AND DT.FiscalQuarter =4
      
GROUP BY DPC.EnglishProductCategoryName,DPS.EnglishProductSubcategoryName,DP.EnglishProductName,DT.EnglishMonthName

EXCEPT

---OLTP------
SELECT PC.Name,PPS.Name,PP.Name,DateName(M,SOH.OrderDate), SUM(SOD.LineTotal)

FROM AdventureWorks.Production.Product PP

     INNER  JOIN AdventureWorks.Sales.SalesOrderDetail SOD
     ON SOD.ProductID = PP.ProductID
     
     INNER  JOIN AdventureWorks.Sales.SalesOrderHeader SOH
     ON SOH.SalesOrderID = SOD.SalesOrderID
     
     INNER JOIN AdventureWorks.Production.ProductSubcategory PPS
     ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
     
     INNER JOIN AdventureWorks.Production.ProductCategory PC
     ON PC.ProductCategoryID = PPS.ProductCategoryID
     
WHERE DateName(DW,SOH.OrderDate) IN ('Monday','Tuesday','Wednesday','Thursday','Friday')
      AND SOH.OnlineOrderFlag = 1
      AND YEAR(SOH.OrderDate) = 2002
      AND MONTH(SOH.OrderDate) IN (4,5,6)
GROUP BY PPS.Name,PP.Name,PC.Name,DateName(M,SOH.OrderDate)
     
   




