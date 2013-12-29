---MERGE-----

--Create a target table
CREATE TABLE Products
(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Rate MONEY
) 
GO
--Insert records into target table
INSERT INTO Products
VALUES
(1, 'Tea', 10.00),
(2, 'Coffee', 20.00),
(3, 'Muffin', 30.00),
(4, 'Biscuit', 40.00)
GO
--Create source table
CREATE TABLE UpdatedProducts
(
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Rate MONEY
) 
GO
--Insert records into source table
INSERT INTO UpdatedProducts
VALUES
(1, 'Tea', 10.00),
(2, 'Coffee', 25.00),
(3, 'Muffin', 35.00),
(5, 'Pizza', 60.00)
GO
SELECT * FROM Products
SELECT * FROM UpdatedProducts
GO



--Synchronize the target table with
--refreshed data from source table
MERGE Products AS TARGET
USING UpdatedProducts AS SOURCE 
ON (TARGET.ProductID = SOURCE.ProductID) 
--When records are matched, update 
--the records if there is any change
WHEN MATCHED AND TARGET.ProductName <> SOURCE.ProductName 
OR TARGET.Rate <> SOURCE.Rate THEN 
UPDATE SET TARGET.ProductName = SOURCE.ProductName, 
TARGET.Rate = SOURCE.Rate 
--When no records are matched, insert
--the incoming records from source
--table to target table
WHEN NOT MATCHED BY TARGET THEN 
INSERT (ProductID, ProductName, Rate) 
VALUES (SOURCE.ProductID, SOURCE.ProductName, SOURCE.Rate)
--When there is a row that exists in target table and
--same record does not exist in source table
--then delete this record from target table
WHEN NOT MATCHED BY SOURCE THEN 
DELETE
--$action specifies a column of type nvarchar(10) 
--in the OUTPUT clause that returns one of three 
--values for each row: 'INSERT', 'UPDATE', or 'DELETE', 
--according to the action that was performed on that row
OUTPUT $action, 
DELETED.ProductID AS TargetProductID, 
DELETED.ProductName AS TargetProductName, 
DELETED.Rate AS TargetRate, 
INSERTED.ProductID AS SourceProductID, 
INSERTED.ProductName AS SourceProductName, 
INSERTED.Rate AS SourceRate; 
SELECT @@ROWCOUNT;
GO




----PIVOT EXAMPLE

create table DailyIncome(VendorId nvarchar(10), IncomeDay nvarchar(10), IncomeAmount int)

--drop table DailyIncome

insert into DailyIncome values ('SPIKE', 'FRI', 100)

insert into DailyIncome values ('SPIKE', 'MON', 300)

insert into DailyIncome values ('FREDS', 'SUN', 400)

insert into DailyIncome values ('SPIKE', 'WED', 500)

insert into DailyIncome values ('SPIKE', 'TUE', 200)

insert into DailyIncome values ('JOHNS', 'WED', 900)

insert into DailyIncome values ('SPIKE', 'FRI', 100)

insert into DailyIncome values ('JOHNS', 'MON', 300)

insert into DailyIncome values ('SPIKE', 'SUN', 400)

insert into DailyIncome values ('JOHNS', 'FRI', 300)

insert into DailyIncome values ('FREDS', 'TUE', 500)

insert into DailyIncome values ('FREDS', 'TUE', 200)

insert into DailyIncome values ('SPIKE', 'MON', 900)

insert into DailyIncome values ('FREDS', 'FRI', 900)

insert into DailyIncome values ('FREDS', 'MON', 500)

insert into DailyIncome values ('JOHNS', 'SUN', 600)

insert into DailyIncome values ('SPIKE', 'FRI', 300)

insert into DailyIncome values ('SPIKE', 'WED', 500)

insert into DailyIncome values ('SPIKE', 'FRI', 300)

insert into DailyIncome values ('JOHNS', 'THU', 800)

insert into DailyIncome values ('JOHNS', 'SAT', 800)

insert into DailyIncome values ('SPIKE', 'TUE', 100)

insert into DailyIncome values ('SPIKE', 'THU', 300)

insert into DailyIncome values ('FREDS', 'WED', 500)

insert into DailyIncome values ('SPIKE', 'SAT', 100)

insert into DailyIncome values ('FREDS', 'SAT', 500)

insert into DailyIncome values ('FREDS', 'THU', 800)

insert into DailyIncome values ('JOHNS', 'TUE', 600)

SELECT * FROM DailyIncome
select * from DailyIncome

pivot (avg (IncomeAmount) for IncomeDay in ([MON],[TUE],[WED],[THU],[FRI],[SAT],[SUN])) as AvgIncomePerDay