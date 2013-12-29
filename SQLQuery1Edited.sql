--CLASS ASSIGMENT---


--1. 

---All managers ID except the CEO
SELECT DISTINCT ManagerID 
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL

--EMPLOYEE WHO ARE NOT MANAGERS with THEIR MANAGERS(LEAVE EMPLOYESS)
SELECT EMPLOYEEID,ManagerID
FROM HumanResources.Employee
WHERE EmployeeID NOT IN
--SET OF MANAGER IDS EXCEPT THE CEO
(
SELECT DISTINCT ManagerID 
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
)

---MANAGERS OF LEAF EMPLOYESS(40 leave managers)
SELECT DISTINCT ManagerID
FROM HumanResources.Employee
WHERE EmployeeID NOT IN
(
SELECT DISTINCT ManagerID 
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
)

--- LEAF Managers mangaging  2 or more leaf employess.(37 of them) 
 
SELECT ManagerID, COUNT(EMPLOYEEID) [EMPLOYEES THEY MANAGE]
FROM HumanResources.Employee
WHERE EmployeeID NOT IN
--SET OF MANAGER IDS EXCEPT THE CEO
(
SELECT DISTINCT ManagerID 
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
)
GROUP BY ManagerID
HAVING COUNT (EMPLOYEEID) > = 2

---- From the results above (Manager_ 7 manages 6),(Manager 38 manages 12). Give it a try. 
SELECT EMPLOYEEID from HumanResources.Employee
WHERE ManagerID = 38

------------------------------------------------

--Managers managing more that 2


(SELECT ManagerID, COUNT(EMPLOYEEID) [EMPLOYEES THEY MANAGE]
FROM HumanResources.Employee
WHERE EmployeeID NOT IN
--SET OF MANAGER IDS EXCEPT THE CEO
(
SELECT DISTINCT ManagerID 
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
)
GROUP BY ManagerID
HAVING COUNT (EMPLOYEEID) > 1)

EXCEPT
(SELECT ManagerID, COUNT(EMPLOYEEID)
FROM HumanResources.Employee
WHERE ManagerID !=109
GROUP BY ManagerID
Having COUNT(ManagerID) > 1
)




----------------------------------
--MANAGERS OF MANAGERS EXCEPT CEO
SELECT  DISTINCT ManagerID
FROM HumanResources.Employee 
WHERE ManagerID NOT IN 
--MANAGER OF LEAVES
(SELECT ManagerID--, COUNT(EMPLOYEEID) [EMPLOYEES THEY MANAGE]
FROM HumanResources.Employee
WHERE EmployeeID NOT IN
--SET OF MANAGER IDS EXCEPT THE CEO
(
SELECT DISTINCT ManagerID 
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL 
)
) AND ManagerID != 109

------------------------------------------------

select mANAGERiD , COUNT(EMPLOYEEid) [number of EMPLOYEES] 
FROM HumanResources.Employee 
where emplOYEEid iN (
(
Select ManagerID from HumanResources.Employee
WHERE EmployeeID NOT IN 
(Select ManagerID from HumanResources.Employee
WHERE ManagerID IS NOT NULL)
gROUP BY ManagerID
hAVING COUNT(eMPLOYEEid)>=2
)
)
gROUP BY ManagerID
hAVING COUNT(EMPLOYEEiD) >=2

SELECT EMPLOYEEID from HumanResources.Employee
WHERE ManagerID =  273


select distinct HRE2.ManagerID from HumanResources.Employee HRE1
left outer join HumanResources.Employee HRE2
on HRE1.EmployeeID = HRE2.ManagerID
where HRE1.EmployeeID != 109
except
SELECT DISTINCT ManagerID
FROM HumanResources.Employee
WHERE EmployeeID NOT IN
(
SELECT DISTINCT ManagerID
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
)
 Sent at 12:54 AM on Friday
 


