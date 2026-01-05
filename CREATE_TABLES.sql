USE AirportDB;
GO
CREATE TABLE dbo.AircraftModels (
    ModelID INT PRIMARY KEY IDENTITY(1,1),
    ModelName NVARCHAR(100) NOT NULL,
    Manufacturer NVARCHAR(100),
    Capacity INT NOT NULL
);

CREATE TABLE dbo.Aircrafts (
    AircraftID INT PRIMARY KEY IDENTITY(1,1),
    RegistrationNumber NVARCHAR(20) UNIQUE NOT NULL,
    ModelID INT FOREIGN KEY REFERENCES dbo.AircraftModels(ModelID),
    ManufactureDate DATE
);

CREATE TABLE dbo.Airports (
    AirportID INT PRIMARY KEY IDENTITY(1,1),
    IataCode CHAR(3) UNIQUE NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Country NVARCHAR(100) NOT NULL
);

CREATE TABLE dbo.Routes (
    RouteID INT PRIMARY KEY IDENTITY(1,1),
    FlightNumber NVARCHAR(10) NOT NULL,
    DepartureAirportID INT FOREIGN KEY REFERENCES dbo.Airports(AirportID),
    ArrivalAirportID INT FOREIGN KEY REFERENCES dbo.Airports(AirportID),
    Distance INT,
    CONSTRAINT CHK_Airports CHECK (DepartureAirportID <> ArrivalAirportID)
);

CREATE TABLE dbo.Positions (
    PositionID INT PRIMARY KEY IDENTITY(1,1),
    PositionName NVARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    PositionID INT FOREIGN KEY REFERENCES dbo.Positions(PositionID),
    HireDate DATE
);

CREATE TABLE dbo.Departures (
    DepartureID BIGINT PRIMARY KEY IDENTITY(1,1),
    RouteID INT FOREIGN KEY REFERENCES dbo.Routes(RouteID),
    AircraftID INT FOREIGN KEY REFERENCES dbo.Aircrafts(AircraftID),
    ActualDepartureDateTime DATETIME,
    TicketsSold INT,
    PricePerTicket DECIMAL(10,2),
    Status_Name NVARCHAR(50) -- Landed, Delayed, Cancelled
);

CREATE TABLE dbo.DepartureCrew (
    DepartureID BIGINT FOREIGN KEY REFERENCES dbo.Departures(DepartureID),
    EmployeeID INT FOREIGN KEY REFERENCES dbo.Employees(EmployeeID),
    PRIMARY KEY (DepartureID, EmployeeID)
);
USE AirportDW;
GO

CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY, -- формат YYYYMMDD
    FullDate DATE,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT
);

CREATE TABLE dbo.DimFlightStatus (
    StatusKey INT PRIMARY KEY IDENTITY(1,1),
    StatusName NVARCHAR(50)
);

CREATE TABLE dbo.DimAircrafts (
    AircraftKey INT PRIMARY KEY IDENTITY(1,1),
    RegistrationNumber NVARCHAR(20),
    ModelName NVARCHAR(100),
    Capacity INT
);

CREATE TABLE dbo.DimRoutes (
    RouteKey INT PRIMARY KEY IDENTITY(1,1),
    FlightNumber NVARCHAR(10),
    SourceCity NVARCHAR(100),
    DestCity NVARCHAR(100)
);

CREATE TABLE dbo.DimEmployees (
    EmployeeKey INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(150),
    PositionName NVARCHAR(50)
);

CREATE TABLE dbo.FactDepartures (
    FactKey BIGINT PRIMARY KEY IDENTITY(1,1),
    DateKey INT FOREIGN KEY REFERENCES dbo.DimDate(DateKey),
    AircraftKey INT FOREIGN KEY REFERENCES dbo.DimAircrafts(AircraftKey),
    RouteKey INT FOREIGN KEY REFERENCES dbo.DimRoutes(RouteKey),
    StatusKey INT FOREIGN KEY REFERENCES dbo.DimFlightStatus(StatusKey),
    TicketsSold INT,
    TotalRevenue MONEY
);

CREATE TABLE dbo.FactCrewFlights (
    FactCrewKey BIGINT PRIMARY KEY IDENTITY(1,1),
    EmployeeKey INT FOREIGN KEY REFERENCES dbo.DimEmployees(EmployeeKey),
    FactKey BIGINT FOREIGN KEY REFERENCES dbo.FactDepartures(FactKey)
);