/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [SalesPersonID]
      ,[TotalDue]
      ,[AverageDue]
  FROM [Batch50].[dbo].[SalesAggregation]
  
  DELETE FROM [Batch50].[dbo].[SalesAggregation]