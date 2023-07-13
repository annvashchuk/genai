;WITH CTE_Current_Period
AS
(
SELECT 
 si.[Stock Item Key] as ProductID
,[Stock Item] as ProductName
,SUM(Quantity) as Quantity
,SUM(Quantity) * SUM(s.[Unit Price]) as Revenue
,DATEPART(QUARTER,[Invoice Date Key]) as [Quarter]
,DATEPART(YEAR,[Invoice Date Key]) as [Year]
FROM [Fact].[Sale] s
  INNER JOIN [Dimension].[Stock Item] si
  ON s.[Stock Item Key] = si.[Stock Item Key]
GROUP BY 
 si.[Stock Item Key]
,[Stock Item]
,DATEPART(QUARTER,[Invoice Date Key])
,DATEPART(YEAR,[Invoice Date Key])
)
SELECT 
  curr.[ProductName]
, ((curr.Revenue * 100.00)/prev.Revenue) - 100 as [GrowthRevenueRate]
, (cast(curr.Quantity as numeric(19,6))*100.00/cast(prev.Quantity as numeric(19,6))) - 100 as [GrowthQuantityRate]
, curr.[Quarter] as [CurrentQuarter]
, curr.[Year] as [CurrentYear]
, prev.[Quarter] as [PreviousQuarter]
, prev.[Year] as [PreviousYear] 
FROM CTE_Current_Period curr
LEFT JOIN CTE_Current_Period prev
ON curr.ProductID = prev.ProductID
AND curr.[Quarter] = prev.[Quarter] 
AND curr.[Year] = prev.[Year] + 1
