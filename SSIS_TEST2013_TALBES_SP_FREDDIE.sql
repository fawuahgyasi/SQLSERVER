
/*
SSIS_Test this table is created based on the number of Columns in the EXCEL FILE. 
Its just a recieving table for now data types can be altered once data has arrived. 
*/
CREATE TABLE SSIS_Test (
                        Column1 NVARCHAR(30),
                        Column2 NVARCHAR(30),
                        Column3 NVARCHAR(30),
                        Column4 NVARCHAR(30),
                        Column5 NVARCHAR(30),
                        Column6 NVARCHAR(30),
                        Column7 NVARCHAR(30),
                        Column8 NVARCHAR(30),
                        Column9 NVARCHAR(30)
                        )
                        
                        
                        select * from SSIS_Test
                        /*
                        STORED PROC TO DELETE ALL NULLS AND BLANKS ENTIES FROM ENTIRE ROWS. 
                        */
                        CREATE PROC CLEAN_DUMP 
                        AS 
                        BEGIN
                        DELETE FROM SSIS_Test 
                        WHERE 
                        Column1 = ' ' AND
                        Column2 = ' ' AND
                        Column3 = ' ' AND
                        Column4 = ' ' AND
                        Column5 = ' ' AND
                        Column6 = ' ' AND
                        Column7 = ' ' AND
                        Column8 = ' ' AND
                        Column9 = ' '  
                        
                        DELETE FROM SSIS_Test 
                        WHERE 
                        Column1 IS NULL AND
                        Column2 IS NULL AND
                        Column3 IS NULL AND
                        Column4 IS NULL AND
                        Column5 IS NULL AND
                        Column6 IS NULL AND
                        Column7 IS NULL AND
                        Column8 IS NULL AND
                        Column9 IS NULL
                        
                        END
                        
                        --FOR TESTING PURPOSES
                        DELETE FROM SSIS_Test