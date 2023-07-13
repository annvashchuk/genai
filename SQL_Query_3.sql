;WITH CTE_Total_Sales
AS
(
SELECT 
 SUM(Quantity) as Quantity
,SUM(Quantity) * SUM([Unit Price]) as Revenue
,DATEPART(QUARTER,[Invoice Date Key]) as [Quarter]
,DATEPART(YEAR,[Invoice Date Key]) as [Year]
FROM [Fact].[Sale] 
GROUP BY 
 DATEPART(QUARTER,[Invoice Date Key])
,DATEPART(YEAR,[Invoice Date Key])
),
CTE_Customer_Sales
as
(
SELECT 
 c.[Customer Key]
  ,[Customer] as CustomerName
  ,SUM(s.Quantity) as Quantity
  ,SUM(s.Quantity) * SUM([Unit Price]) as Revenue
  ,DATEPART(QUARTER,s.[Invoice Date Key]) as [Quarter]
  ,DATEPART(YEAR,s.[Invoice Date Key]) as [Year]
FROM [Fact].[Sale] s
INNER JOIN [Dimension].[Customer] c
ON s.[Customer Key] = c.[Customer Key]
GROUP BY 
  c.[Customer Key]
 ,c.[Customer]
 ,DATEPART(QUARTER,[Invoice Date Key])
 ,DATEPART(YEAR,[Invoice Date Key])
 )
 SELECT 
  [CustomerName]
 ,(CAST(cs.Quantity as numeric(19,8))* 100.00)/CAST(ts.Quantity as numeric(19,8)) as [TotalQuantityPercentage]
 ,(cs.Revenue * 100.00)/ts.Revenue as [TotalRevenuePercentage]
 ,ts.[Quarter]
 ,ts.[Year]
 FROM CTE_Total_Sales ts
 INNER JOIN CTE_Customer_Sales cs
 ON ts.[Quarter] = cs.[Quarter]
 AND ts.[Year] = cs.[Year]
