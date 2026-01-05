USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Airport_DW')
CREATE DATABASE Airport_DW;
GO

USE Airport_DW;
GO

CREATE TABLE DimDate (
    DateKey INT NOT NULL PRIMARY KEY, -- 20250101
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    Day INT NOT NULL,
    DayName NVARCHAR(20) NOT NULL,
    Quarter INT NOT NULL
);

CREATE TABLE DimRoutes (
    RouteID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Departure_City NVARCHAR(100),
    Departure_Country NVARCHAR(100),
    Arrival_City NVARCHAR(100),
    Arrival_Country NVARCHAR(100),
    Flight_Distance_KM FLOAT
);

CREATE TABLE DimAircrafts (
    AircraftID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Model_Name NVARCHAR(100),
    Manufacturer NVARCHAR(100),
    Capacity INT
);

CREATE TABLE FactDepartures (
    FactID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DateKey INT NOT NULL FOREIGN KEY REFERENCES DimDate(DateKey),
    RouteID INT NOT NULL FOREIGN KEY REFERENCES DimRoutes(RouteID),
    AircraftID INT NOT NULL FOREIGN KEY REFERENCES DimAircrafts(AircraftID),
    Tickets_Sold INT,
    Total_Revenue MONEY,
    Flight_Duration_Minutes INT
);
GO