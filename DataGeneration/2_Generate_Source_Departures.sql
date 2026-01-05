USE AirportDB;
GO

SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM dbo.Routes) OR NOT EXISTS (SELECT 1 FROM dbo.Aircrafts)
BEGIN
    PRINT 'ПОМИЛКА: Таблиці Routes або Aircrafts порожні! Спочатку запустіть скрипт Етапу 1.';
    RETURN;
END

PRINT 'Step 5: Generating 500,000 Departures (Optimized via Temp Table)...';

DECLARE @MinRouteID INT = (SELECT MIN(RouteID) FROM dbo.Routes);
DECLARE @RangeRoute INT = (SELECT MAX(RouteID) - MIN(RouteID) + 1 FROM dbo.Routes);
DECLARE @MinAircraftID INT = (SELECT MIN(AircraftID) FROM dbo.Aircrafts);
DECLARE @RangeAircraft INT = (SELECT MAX(AircraftID) - MIN(AircraftID) + 1 FROM dbo.Aircrafts);

CREATE TABLE #RandomStaging (
    RouteID INT,
    AircraftID INT,
    ActualDepDate DATETIME,
    Price DECIMAL(10,2),
    StatusChance INT,
    LoadFactor FLOAT
);

PRINT '   -> Generating random numbers...';

WITH 
    E1(N) AS (SELECT 1 FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1))dt(n)),
    E2(N) AS (SELECT 1 FROM E1 a CROSS JOIN E1 b), -- 100
    E4(N) AS (SELECT 1 FROM E2 a CROSS JOIN E2 b), -- 10,000
    E6(N) AS (SELECT 1 FROM E4 a CROSS JOIN E2 b), -- 1,000,000
    Generator AS (SELECT TOP 500000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N FROM E6)
INSERT INTO #RandomStaging
SELECT 
    @MinRouteID + (ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % @RangeRoute),
    @MinAircraftID + (ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % @RangeAircraft),
    DATEADD(MINUTE, -CAST(ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % (5256000) AS INT), GETDATE()),
    50 + (ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % 500),
    ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % 100,
    (ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % 100) / 100.0
FROM Generator;

PRINT '   -> Inserting into target table...';

INSERT INTO dbo.Departures (RouteID, AircraftID, ActualDepartureDateTime, ActualArrivalDateTime, TicketsSold, FlightStatus, PricePerTicket)
SELECT 
    rs.RouteID,
    rs.AircraftID,
    rs.ActualDepDate,
    DATEADD(MINUTE, r.ScheduledDurationMinutes, rs.ActualDepDate), -- Дата прильоту
    CAST(m.TotalSeats * rs.LoadFactor AS INT), -- Квитки
    CASE 
        WHEN rs.StatusChance < 90 THEN 'Landed'
        WHEN rs.StatusChance < 95 THEN 'Delayed'
        ELSE 'Cancelled'
    END,
    rs.Price
FROM #RandomStaging rs
INNER JOIN dbo.Routes r ON rs.RouteID = r.RouteID
INNER JOIN dbo.Aircrafts a ON rs.AircraftID = a.AircraftID
INNER JOIN dbo.AircraftModels m ON a.ModelID = m.ModelID;

DROP TABLE #RandomStaging;

PRINT 'DONE! Records generated successfully.';
SELECT count(*) as TotalDepartures FROM dbo.Departures;
GO