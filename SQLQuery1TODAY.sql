


SELECT  FacilityTypeID From FacilityType
WHERE facilityTypeDescription = 'Outlet'

--1---
SELECT C.CityName,Count(C.cityName) [Total Number Outlet Facilites] FROM 
City C
INNER JOIN Zip Z
ON C.cityID = Z.cityID
INNER JOIN Facility F
ON Z.zipCode = F.facilityZip
WHERE F.facilityZip IN (
SELECT DISTINCT F.facilityZip From
 facility F
 INNER JOIN FacilityType FT
 ON F.facilityTypeID=FT.facilityTypeID
WHERE facilityTypeDescription = 'Outlet')

GROUP BY C.cityName
ORDER BY [Total Number Outlet Facilites] DESC

---RESULTS Rows: 1290. 


---2----

SELECT CC.CountyName,Count(CC.CountyName) [Total Number Outlet Facilites] FROM 
City C
INNER JOIN County CC
ON C.countyID = CC.countyID
INNER JOIN Zip Z
ON C.cityID = Z.cityID
INNER JOIN Facility F
ON Z.zipCode = F.facilityZip
WHERE f.facilityZip IN (

SELECT DISTINCT F.facilityZip From
 facility F
 INNER JOIN FacilityType FT
 ON F.facilityTypeID=FT.facilityTypeID
 AND FT.facilityTypeDescription = 'Warehouse')
--WHERE facilityTypeDescription = 'warehouse')

GROUP BY CC.countyName
ORDER BY [Total Number Outlet Facilites] DESC

---3----

SELECT DISTINCT F.FacilityName FROM
Facility F
INNER JOIN FacilityType FT
ON F.facilityTypeID = FT.facilityTypeID
AND FT.facilityTypeDescription = 'Warehouse'

SELECT F.FacilityName, COUNT(*) [Total Number of Outlets]FROM 
(
SELECT F.SuppliedBy FROM
Facility F
INNER JOIN FacilityType FT
ON F.facilityTypeID = FT.facilityTypeID
AND FT.facilityTypeDescription = 'outlet'

WHERE F.SuppliedBy IN (
SELECT DISTINCT F.facilityID FROM
Facility F
INNER JOIN FacilityType FT
ON F.facilityTypeID = FT.facilityTypeID
AND FT.facilityTypeDescription = 'Warehouse')
) TEMP
INNER JOIN Facility F
ON TEMP.SuppliedBy = F.facilityID

GROUP BY F.facilityName


---4---
SELECT  DISTINCT P.ProductName--,C.taxPercentage,C.countyID
FROM CountyTax C 
INNER JOIN ProductSubCategory PPS
ON PPS.productCategoryID = C.productCategoryID
INNER JOIN Product P
ON P.productSubCategoryID = PPS.productSubCategoryID
WHERE C.taxPercentage = 0

--Results: Row: 102
SELECT * FROM ##Employee
---5---
---

/*
5. Write a query that will display the facility names, 
the city, total revenue that they generated along with their 
ranks for those facilities with the highest revenue. 
*/

SELECT RANK() OVER (ORDER BY Total_Revenue ),FacilityName,CityName,Total_Revenue
FROM(
SELECT FacilityName,CityName, SUM(Revenue) TOTAL_REVENUE 
FROm (
SELECT DISTINCT F.facilityName,C.cityName,(SD.saleprice) [Revenue]
FROM salesDetail SD
INNER JOIN FacilityProductMaster FPM
ON FPM.facilityProductID = SD.facilityProductID
INNER JOIN Facility F
ON F.facilityID = FPM.facilityID
INNER JOIN Zip Z
ON Z.zipCode = F.facilityZip
INNER JOIN City C
ON C.cityID = Z.cityID
) TEMP
GROUP BY TEMP.Facilityname,TEMP.cityName
) TEMP2

---6
/*
6. Write a query that will display the facility names, 
the city, total revenue that they generated along with their ranks for those 
facilities with the least revenue. 
*/

SELECT RANK() OVER (ORDER BY Total_Revenue )FacilityName,CityName,Total_Revenue
FROM(
SELECT FacilityName,CityName, SUM(Revenue) TOTAL_REVENUE 
FROm (
SELECT DISTINCT F.facilityName,C.cityName,(SD.saleprice) [Revenue]
FROM salesDetail SD
INNER JOIN FacilityProductMaster FPM
ON FPM.facilityProductID = SD.facilityProductID
INNER JOIN Facility F
ON F.facilityID = FPM.facilityID
INNER JOIN Zip Z
ON Z.zipCode = F.facilityZip
INNER JOIN City C
ON C.cityID = Z.cityID
) TEMP
GROUP BY TEMP.Facilityname,TEMP.cityName
) TEMP2
--ROW: 74
---7--
/*
7. Write a query that displays the name of the facilities that do not sell the product Light bulbs. 
*/
SELECT F.facilityName,P.productName 
From FacilityProductMaster FPM
INNER JOIN Product P
ON P.productID = FPM.productID
INNER JOIN Facility F
ON FPM.facilityID = F.facilityID
AND P.productID NOT IN (

SELECT productID 
FROM Product  
WHERE productName = 'light bulbs')

---ROWS: 376951

--8--
/*
8. Write a query that displays the product category names 
and the total revenue that they generated for the month of November 2008. 
*/
SELECT TOP 1 * from FacilityProductMaster
SELECT TOP 1 * from facilityProductMasterHistoryRM