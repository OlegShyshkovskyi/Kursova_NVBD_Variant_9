USE Airport_DW;
GO

TRUNCATE TABLE DimDate;

DECLARE @StartDate DATE = '2015-01-01';
DECLARE @EndDate DATE = '2026-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (DateKey, FullDate, Year, Month, MonthName, Day, DayName, Quarter)
    VALUES (
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT),
        @StartDate,
        YEAR(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DAY(@StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATEPART(QUARTER, @StartDate)
    );
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO