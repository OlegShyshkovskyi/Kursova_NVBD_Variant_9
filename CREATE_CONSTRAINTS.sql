USE AirportDW;
GO

ALTER TABLE dbo.FactDepartures 
ADD CONSTRAINT FK_Fact_Date FOREIGN KEY (DateKey) 
REFERENCES DimDate(DateKey);
GO

ALTER TABLE dbo.FactDepartures 
ADD CONSTRAINT FK_Fact_Route FOREIGN KEY (RouteKey) 
REFERENCES DimRoutes(RouteKey);
GO

ALTER TABLE dbo.FactDepartures 
ADD CONSTRAINT CHK_Revenue CHECK (TotalRevenue >= 0);
GO