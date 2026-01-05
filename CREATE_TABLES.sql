USE Airport_DW;
GO

CREATE TABLE DimDate (
    DateKey INT NOT NULL PRIMARY KEY, -- Формат YYYYMMDD
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    Day INT NOT NULL,
    DayName NVARCHAR(20) NOT NULL,
    Quarter INT NOT NULL
);
GO

CREATE TABLE DimRoutes (
    RouteID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Departure_City NVARCHAR(100) NOT NULL,
    Departure_Country NVARCHAR(100) NOT NULL,
    Arrival_City NVARCHAR(100) NOT NULL,
    Arrival_Country NVARCHAR(100) NOT NULL,
    Flight_Distance_KM FLOAT
);
GO

CREATE TABLE DimAircrafts (
    AircraftID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Model_Name NVARCHAR(100),
    Manufacturer NVARCHAR(100),
    Capacity INT
);
GO

CREATE TABLE FactDepartures (
    FactID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DateKey INT NOT NULL,      
    RouteID INT NOT NULL,      
    AircraftID INT NOT NULL,   
    
    Tickets_Sold INT,
    Total_Revenue MONEY,
    Flight_Duration_Minutes INT
);
GO