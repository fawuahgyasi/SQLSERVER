USE Batch50

go 
--
create table CleanTable(
              EID INT ,
              Name Varchar(50),
              City Varchar(50)
              )
 --Inserting data into clean table   
Insert into CleanTable Values ( 100,'Peter','Poway'),
                               (101,'Alexander','Los Angeles'),
                               (102,'Jonathan','San Diego'),
                               (103,'Samantha','Redlands'),
                               (103,'Amanda','Redlands'),
                               (101,'Alexander','Los Angeles')
                               
   --Dirty table---                            
SELECT * INTO  DirtyTable 
 FROM CleanTable WHERE 1=2    
 
 
 Insert into DirtyTable values (100,'Petter','Poway'),
                               (100,'Pete','Poway'),
                               (101,'Alex','Los Angeles'),
                               (102,'Samanthaaa','Redlands'),
                               (103,'Amanda','Redlands')                            
            
            
    select * FROM dbo.FuzzyLookUPOUT
       select * from    dbo.FuzzyLookupMatchIndex            