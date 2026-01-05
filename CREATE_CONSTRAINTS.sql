USE Airport_DW;
GO

ALTER TABLE FactDepartures
ADD CONSTRAINT FK_Fact_Date FOREIGN KEY (DateKey)
REFERENCES DimDate(DateKey);
GO

ALTER TABLE FactDepartures
ADD CONSTRAINT FK_Fact_Route FOREIGN KEY (RouteID)
REFERENCES DimRoutes(RouteID);
GO

ALTER TABLE FactDepartures
ADD CONSTRAINT FK_Fact_Aircraft FOREIGN KEY (AircraftID)
REFERENCES DimAircrafts(AircraftID);
GO