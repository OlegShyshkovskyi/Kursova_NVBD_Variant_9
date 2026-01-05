USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Airport_DW')
DROP DATABASE Airport_DW;
GO

CREATE DATABASE Airport_DW;
GO