;WITH CTE_Aggregation
AS
(
SELECT 
[Stock Item] as ProductName
,SUM(Quantity) as Quantity
,SUM(Quantity) * SUM(s.[Unit Price]) as Revenue
,'Q' + CAST(DATEPART(QUARTER,[Invoice Date Key]) as varchar) as [Quarter]
,DATEPART(YEAR,[Invoice Date Key]) as [Year]
,ROW_NUMBER() OVER (PARTITION BY DATEPART(QUARTER,[Invoice Date Key]),DATEPART(YEAR,[Invoice Date Key]) ORDER BY SUM(Quantity) desc, SUM(Quantity) * SUM(s.[Unit Price]) desc) as RN
FROM [Fact].[Sale] s
  INNER JOIN [Dimension].[Stock Item] si
  ON s.[Stock Item Key] = si.[Stock Item Key]
GROUP BY 
 [Stock Item]
,DATEPART(QUARTER,[Invoice Date Key])
,DATEPART(YEAR,[Invoice Date Key])
)
SELECT ProductName, Quantity as SalesQuantity, Revenue as [SalesRevenue], Quarter, Year
FROM CTE_Aggregation
WHERE RN <= 10