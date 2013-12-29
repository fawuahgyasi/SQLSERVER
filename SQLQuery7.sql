---TRIGGERS

ALTER TRIGGER Deny_Creatting ON Database
FOR CREATE_TABLE AS
PRINT 'Create Statement Issued'
DECLARE @TabName Varchar(100), @SQL_QUERY varchar(Max)

SELECT @TabName= ST.name from sys.tables ST
where st.create_date = ( select MAX(create_date) from sys.tables)

SET @SQL_QUERY = 'DROP TABLE ' + @TabName
PRINT @SQL_QUERY
EXECUTE (@SQL_Query)

DROP TRIGGER Deny_Creatting ON Database

--DML TRIGGERS

CREATE TABLE sales_trig
(
SalesID INT,
PID INT,
QTY INT,
Name Varchar(100)
)

CREATE TABLE STOCKS_TRIG
(
PID INT,
PName Varchar(50),
QTY INT
)

INSERT INTO STOCKS_TRIG Values (100,'Iphone',45),(102,'Laptops',45),(101,'Camera',25),(102,'Desktop',70)

--Case1: Using Instead of Trigger

ALTER TRIGGER Sales1_trig ON Sales_Trig
INSTEAD OF INSert AS
BEGIN 
   DECLARE @REg_QTY INT, @REG_PID INT, @AVA_QTY INT
   SELECT @REg_QTY= Qty, @REG_PID = PID FROM inserted
   SELECT @AVA_QTY = QTy From Stocks_Trig WHERE Pid = @REG_PID
   
    IF @REg_QTY <= @AVA_QTY
    BEGIN
       INSERT INTO Sales_Trig
         select * From inserted
         
       UPDATE Stocks_Trig SET QTY = QTY - @REg_QTY WHERE PID = @REG_PID
       
       END
       
       ELSE PRINT 'OUT OF STOCK'
       
       END
       
       
   INSERT INTO Sales_trig Values(1,100,5,'Iphone')
       SELECT * FROM stocks_trig
       
       
       
       /*
       CREATE A SINGLE INSTEAD OF TRIGGER ON STOCK TABLE FOR INSERT UPDATE AND DElETE AND NOTIFY DBA WHICH STATEMENTS HAS CAUSED
       THE TRIGGER TO GET FIRED
       
       
       */
INSERT INTO Stocks_trig values(...)
--Your output should be : 
---Trigger got fired on INSERT statement---


CREATE TRIGGER Test_Me ON Stocks_trig 
	AFTER INSERT,UPDATE,DELETE AS
	DECLARE @InsertRows INT,@DeleteRows INT 
	
	SELECT * FROM inserted
	SELECT * FROM Deleted
	
	SELECT @InsertRows = COUNT(*) FROM inserted
	SELECT @DeleteRows = COUNT(*) FROM DELETED
	
	IF @InsertRows <> 0 and @DeleteRows = 0
	PRINT 'Trigger got fired on Insert Statement'
	
	ELSE IF @InsertRows = 0 and @DeleteRows <> 0
	PRINT 'Trigger got fired on Delete Statemet'
	
	ELSE IF @InsertRows <> 0 and @DeleteRows<> 0
	PRINT 'Trigger got fired on Update Statement'
	
	ELSE
	PRINT 'SOMETHING IS WRONG '
	DROP TRIGGER Test_Me
	
	insert INTO STOCKS_TRIG VALUES (1,'ABC',30)
	DELETE FROM STOCKS_trig where PID = 100
	
	UPDATE STOCKS_Trig
	SET PID = 100
	WHERE PID = 102
	
	
	/*---Assumming that  there are two stand alone tables Parent and Child, simlulate PK and FK relationships between these two tables with T1
	as Parent and T2 s Child table for inserting data*/
	
	Create Table Parent1( ID INt)
	CREATE TABLE CHILD1(ID INT)
	
	
	CREATE TRIGGER FK_SIM ON Parent1
	AFTER INSERT,UPDATE, DELETE AS
	
    DECLARE @ID_Value INT
    SELECT * from deleted
    
    SELECT @ID_Value = ID from deleted
    SELECT * FROM deleted
    Select @ID_Value = ID from deleted 
    DELETE FROM Child1 where ID = @ID_Value
    
   
   DELETE from Parent1 where ID=1
    
    INSERT INTO Parent1 Values(2)
    select * from child1
    insert into child1 values(1),(2)
    GO 3 

 DROP TRIGGER FK_SIM
   
/* Create a trigger that will populate an archive table which would hold all the historical records .data from the base table. 
 
 Base Table Structure 
 BTable(ID,Fname,Lname,Salary)
 Archived Table Structure
 Atable(ID,Fname,Lname,Salary,Flag,TTime,User) */
 
 CREATE TABLE  BTable(ID INT,Fname VARCHAR,Lname INT,Salary INT)
 CREATE TABLE  Atable(ID INT,Fname VARCHAR,Lname INT,Salary INT,Flag VARCHAR,TTime DATE,User1 varchar)
 
  CREATE TRIGGER UPD ON BTable AFTER INSERT,UPDATE,DELETE
  
  AS
  
  DECLARE @Flag Varchar
  DECLARE @USER Varchar
  DECLARE @TT DAte
  DECLARE @InsertRows INT,@DeleteRows INT 
  
  SELECT @USER = SYSTEM_USER , @TT = GETDATE()
  
  SELECT @InsertRows = COUNT(*) FROM inserted
  SELECT @DeleteRows = COUNT(*) FROM DELETED
  
  IF @InsertRows <> 0 and @DeleteRows = 0
	INSERT INTO Atable
	SELECT ID,Fname,Lname,Salary,'I',GETDATE(),SYSTEM_USER from inserted
	
	ELSE IF @InsertRows = 0 and @DeleteRows <> 0
	INSERT INTO Atable
	SELECT ID,Fname,Lname,Salary,'D',GETDATE(),SYSTEM_USER from deleted
	
	ELSE IF @InsertRows <> 0 and @DeleteRows<> 0
	BEGIN
	INSERT INTO Atable
	SELECT ID,Fname,Lname,Salary,'U_old',GETDATE(),SYSTEM_USER from deleted
	
	INSERT INTO Atable
	SELECT ID,Fname,Lname,Salary,'U_New',GETDATE(),SYSTEM_USER from inserted
	
	END
	ELSE
	PRINT 'NO action performed on ATable (Vurn was there)'
	
	INSERT INTO BTable Values (1,'G1','J1',100)
	INSERT INTO BTable Values (1,'G2','J2',200)
	INSERT INTO BTable Values (1,'G3','J3',300)
	
	DELETE FROM BTable
	WHERE ID = 1 
	
	UPDate BTable
	SET ID = 22
	WHERE ID = 2
	
	
	BEGIN TRANSACTION T1
	
	UPDATE Cur_Test 
	