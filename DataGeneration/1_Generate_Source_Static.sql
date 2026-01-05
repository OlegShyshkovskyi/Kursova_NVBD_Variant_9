USE AirportDB;
GO

SET NOCOUNT ON;
PRINT '1. Inserting Static Data (Airports, Models, Positions)...';

INSERT INTO dbo.AircraftModels (ModelName, Manufacturer, TotalSeats, MaxDistanceKM) VALUES
('Boeing 737-800', 'Boeing', 189, 5765),
('Boeing 777-300ER', 'Boeing', 396, 13649),
('Airbus A320', 'Airbus', 150, 6100),
('Airbus A380', 'Airbus', 525, 15200),
('Embraer E190', 'Embraer', 114, 4537),
('Bombardier CRJ900', 'Bombardier', 90, 2876),
('Boeing 787-9', 'Boeing', 290, 14140),
('Airbus A321neo', 'Airbus', 206, 7400);

INSERT INTO dbo.Positions (PositionName, BaseSalary) VALUES
('Commander', 120000.00), 
('First Officer', 80000.00),
('Senior Stewardess', 45000.00), 
('Stewardess', 35000.00), 
('Technician', 40000.00);

INSERT INTO dbo.Airports (IataCode, AirportName, City, Country) VALUES
('LWO', 'Lviv Danylo Halytskyi', 'Lviv', 'Ukraine'),
('KBP', 'Boryspil Intl', 'Kyiv', 'Ukraine'),
('WAW', 'Warsaw Chopin', 'Warsaw', 'Poland'),
('JFK', 'John F. Kennedy', 'New York', 'USA'),
('LHR', 'Heathrow', 'London', 'UK'),
('CDG', 'Charles de Gaulle', 'Paris', 'France'),
('FRA', 'Frankfurt', 'Frankfurt', 'Germany'),
('DXB', 'Dubai Intl', 'Dubai', 'UAE'),
('IST', 'Istanbul', 'Istanbul', 'Turkey'),
('AMS', 'Schiphol', 'Amsterdam', 'Netherlands'),
('MUC', 'Munich', 'Munich', 'Germany'),
('BCN', 'Barcelona-El Prat', 'Barcelona', 'Spain'),
('FCO', 'Fiumicino', 'Rome', 'Italy'),
('YYZ', 'Toronto Pearson', 'Toronto', 'Canada'),
('HND', 'Tokyo Haneda', 'Tokyo', 'Japan');

PRINT '2. Generating 1000 Realistic Employees...';

WITH FirstNames(Val) AS (
    SELECT 'Oleksandr' UNION ALL SELECT 'Dmytro' UNION ALL SELECT 'Andrii' UNION ALL 
    SELECT 'Serhii' UNION ALL SELECT 'Ivan' UNION ALL SELECT 'Volodymyr' UNION ALL 
    SELECT 'Mykola' UNION ALL SELECT 'Taras' UNION ALL SELECT 'Ihor' UNION ALL 
    SELECT 'John' UNION ALL SELECT 'Michael' UNION ALL SELECT 'David' UNION ALL 
    SELECT 'Robert' UNION ALL SELECT 'James' UNION ALL SELECT 'William' UNION ALL 
    SELECT 'Thomas' UNION ALL SELECT 'Daniel' UNION ALL SELECT 'Matthew' UNION ALL
    SELECT 'Maria' UNION ALL SELECT 'Olena' UNION ALL SELECT 'Anna' UNION ALL 
    SELECT 'Yulia' UNION ALL SELECT 'Nataliia' UNION ALL SELECT 'Oksana' UNION ALL 
    SELECT 'Tetiana' UNION ALL SELECT 'Iryna' UNION ALL SELECT 'Svitlana' UNION ALL
    SELECT 'Sarah' UNION ALL SELECT 'Jessica' UNION ALL SELECT 'Emily' UNION ALL 
    SELECT 'Jennifer' UNION ALL SELECT 'Lisa' UNION ALL SELECT 'Laura'
),
LastNames(Val) AS (
    SELECT 'Melnyk' UNION ALL SELECT 'Shevchenko' UNION ALL SELECT 'Boyko' UNION ALL 
    SELECT 'Kovalenko' UNION ALL SELECT 'Bondarenko' UNION ALL SELECT 'Tkachenko' UNION ALL 
    SELECT 'Kravchenko' UNION ALL SELECT 'Oliynyk' UNION ALL SELECT 'Koliada' UNION ALL 
    SELECT 'Kozak' UNION ALL SELECT 'Savchenko' UNION ALL SELECT 'Rudenko' UNION ALL 
    SELECT 'Moroz' UNION ALL SELECT 'Lysenko' UNION ALL SELECT 'Pavlenko' UNION ALL
    SELECT 'Smith' UNION ALL SELECT 'Johnson' UNION ALL SELECT 'Williams' UNION ALL 
    SELECT 'Brown' UNION ALL SELECT 'Jones' UNION ALL SELECT 'Garcia' UNION ALL 
    SELECT 'Miller' UNION ALL SELECT 'Davis' UNION ALL SELECT 'Rodriguez' UNION ALL 
    SELECT 'Martinez' UNION ALL SELECT 'Hernandez' UNION ALL SELECT 'Lopez' UNION ALL 
    SELECT 'Gonzalez' UNION ALL SELECT 'Wilson' UNION ALL SELECT 'Anderson'
)
INSERT INTO dbo.Employees (FirstName, LastName, PositionID, HireDate, Email)
SELECT TOP 1000
    FN.Val,
    LN.Val,
    (ABS(CHECKSUM(NEWID())) % 5) + 1, -- Random Position (1-5)
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3650), GETDATE()), -- Random HireDate
    LOWER(LEFT(FN.Val, 1) + '.' + LN.Val + CAST(ABS(CHECKSUM(NEWID())) % 999 AS VARCHAR) + '@airport.com')
FROM FirstNames FN
CROSS JOIN LastNames LN
ORDER BY NEWID();

PRINT '3. Generating 550 Aircrafts...';

WITH E1(N) AS (SELECT 1 FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1))dt(n)),
E2(N) AS (SELECT 1 FROM E1 a CROSS JOIN E1 b),
E4(N) AS (SELECT 1 FROM E2 a CROSS JOIN E2 b)
INSERT INTO dbo.Aircrafts (RegistrationNumber, ModelID, ManufactureDate, Status)
SELECT TOP 550
    'UR-' + CAST(1000 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR),
    (ABS(CHECKSUM(NEWID())) % 8) + 1,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 5000), GETDATE()),
    'Active'
FROM E4;

PRINT '4. Generating 200 Routes...';

INSERT INTO dbo.Routes (FlightNumber, DepartureAirportID, ArrivalAirportID, ScheduledDepartureTime, ScheduledDurationMinutes)
SELECT TOP 200
    'FL-' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 100 AS VARCHAR),
    D.AirportID,
    A.AirportID,
    DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, '00:00'),
    60 + (ABS(CHECKSUM(NEWID())) % 600)
FROM dbo.Airports D
CROSS JOIN dbo.Airports A
WHERE D.AirportID <> A.AirportID
ORDER BY NEWID();

PRINT 'REFERENCE DATA GENERATED SUCCESSFULLY';
GO