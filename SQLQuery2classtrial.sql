/*
Class Practice. 

*/
ALTER PROC myClass1 (@ProductName VARCHAR(Max))
AS
SELECT FP.productID,F.facilityName,C.cityName
FROM Facility F
INNER JOIN FacilityProductMaster FP
ON F.facilityID = FP.facilityID
INNER JOIN Product P
ON P.productID = FP.productID
INNER JOIN Zip Z
ON z.zipCode = F.facilityZip
INNER JOIN City C
ON z.cityID = C.cityID
WHERE P.productID NOT IN
(SELECT P.productID 
 FROM Product P
 INNER JOIN FacilityProductMaster FP
 ON p.productID = fp.productID
 WHERE P.productName = @ProductName) 
EXEC myClass1 Carrots
---2

CREATE PROC MYPROC2 (@ProductName Varchar(max))
AS
SELECT (C.firstName + C.lastName ) 'Name'
FROM Customer C
INNER JOIN sales S
ON S.customerID = C.customerID
INNER JOIN ProductReturn PR
ON PR.billNumber = S.billNumber
INNER JOIN ReturnCondition R
ON R.returnConditionID = PR.returnConditionID
INNER JOIN FacilityProductMaster FPM
ON S.FacilityID = FPM.FacilityID
INNER JOIN Product P
ON P.productID = FPm.productID
WHERE R.returnConditionDescription = 'Damaged' and P.productName = @ProductName

---3

ALTER PROC myProc3 (@facilityName Varchar(Max),@SalesDate varchar(max),@total_Reve int out)
AS
SELECT @total_Reve= SUM(SD.Saleprice) 
FROM Facility F
INNER JOIN sales S
ON S.facilityID = f.facilityID
INNER JOIN salesDetail SD
ON SD.billNumber = S.billNumber
WHERE S.billDate = @SalesDate  and F.facilityName = @facilityName
GROUP BY F.facilityName

SELECT f.facilityName, SUM(SD.Saleprice) 
FROM Facility F
INNER JOIN sales S
ON S.facilityID = f.facilityID
INNER JOIN salesDetail SD
ON SD.billNumber = S.billNumber
WHERE S.billDate = @SalesDate  and F.facilityName = @facilityName
GROUP BY F.facilityName

DEClare @total_reve INT 
EXEC myProc3 'SuperStore Outlet #471 : Lancaster','2008-12-04 15:21:07.573',@total_Reve out
Print @total_Reve


---4
CREATE PROC MYPROC4 (@faciltyname Varchar(100),@Profit int out)
AS
SELECT @Profit = SUM((SD.saleprice -FPM.costPricePerUnit)*SD.unitsSold)
FROM Facility F
INNER JOIN sales S
ON S.facilityID = f.facilityID
INNER JOIN salesDetail SD
ON SD.billNumber = S.billNumber
INNER JOIN FacilityProductMaster FPM
ON FPM.facilityID =F.facilityID
WHERE F.facilityName = @faciltyname

DECLARE @Profit INT
EXEC MYPROC4 'SuperStore Outlet #471 : Lancaster',@Profit out
print @Profit


Select TOP 1 * from FacilityProductMaster
SELECT * from FacilityType
SELECT * FROM Facility



SELECT F.facilityID,F.facilityName,F.SuppliedBy,FP.reOrderLevel,FP.reOrderQty,FP.QOH 
FROM  FacilityProductMaster FP
INNER JOIN Facility F
ON F.facilityID = FP.facilityID
INNER JOIN FacilityType FT 
ON FT.facilityTypeID = F.facilityTypeID
WHERE (FT.facilityTypeDescription = 'Outlet' or FT.facilityTypeDescription = 'Online') 
AND FP.QOH < = FP.reOrderLevel
GO

GO
SELECT F.facilityID,F.facilityName,F.SuppliedBy,FP.reOrderLevel,FP.reOrderQty,FP.QOH 
FROM  FacilityProductMaster FP
INNER JOIN Facility F
ON F.facilityID = FP.facilityID
INNER JOIN FacilityType FT 
ON FT.facilityTypeID = F.facilityTypeID
WHERE F.facilityID IN 
(
SELECT F.SuppliedBy
FROM  FacilityProductMaster FP
INNER JOIN Facility F
ON F.facilityID = FP.facilityID
INNER JOIN FacilityType FT 
ON FT.facilityTypeID = F.facilityTypeID
WHERE (FT.facilityTypeDescription = 'Outlet' or FT.facilityTypeDescription = 'Online') 
AND FP.QOH < = FP.reOrderLevel)


DECLARE @FACILITYOUT INT,@REORDER_QTY INT
DECLARE @SUPPLIEDBY_iD int

DECLARE @TABLE TABLE (ROWNUMBER INT,facilityID INT,facilityName VARChAR(50),SuppliedBy int,reOrderLevel int,reOrderQty int,QOH int)

INSERT INTO @TABLE  
SELECT ROW_NUMBER() OVER (ORDER BY F.FACILITYID),F.facilityID,F.facilityName,F.SuppliedBy,FP.reOrderLevel,FP.reOrderQty,FP.QOH 
FROM  FacilityProductMaster FP
INNER JOIN Facility F
ON F.facilityID = FP.facilityID
INNER JOIN FacilityType FT 
ON FT.facilityTypeID = F.facilityTypeID
WHERE (FT.facilityTypeDescription = 'Outlet' or FT.facilityTypeDescription = 'Online') 
AND FP.QOH < = FP.reOrderLevel
UPDATE FacilityProductMaster
      SET QOH = QOH + @REORDER_QTY
      WHERE facilityID = @fACILITYOUT 
      
UPDATE FacilityProductMaster
      SET QOH = QOH - @REORDER_QTY 
      WHERE facilityID = @SUPPLIEDBY_id )
