--- AUTHENTICATION. 

CREATE LOGIN Batch503 with password ='password'
ALTER LOGIN Batch503 DISABLE
DROP LOGIN Batch503
--Error Handgin---

--TRY CATCH
--RaiseError()
--@@Error
BEGIN TRY
<Set of SQL statements that might generate error
END TRY>

BEGIN CATCH
<Set of sql statments thatshould be executed if error occur>
END CATCH

CREATE PROC SimpleInterest (@Principle Money,@Rate Float,@Time INT,@SI Float OUT)

AS
BEGIN TRY 
SET @SI = (@principle*(1+@Rate))/@Time 
RETURN 0
END TRY
BEGIN CATCH
RAISERROR('Time cannot be 0',6,0)
RETURN 1
END Catch 

DECLARE @SI Float, @RE INT
EXEC @RE = SimpleInterest 1000,0.123,1,@SI OUT
PRINT @SI


----RAISERROR('Message',11,1)
--SEverity 0-12---> Information Message
--Severity 11-20---> Critical Errors
---Severity 21-24 --> System Critical Errors

--3. @@Error(Only way of handling errors in SQL 2000
SET @SI = (@principle*(1+@Rate))/@Time
IF @@Error <> 0
<Error Worklow>
Else
<continue>





