-- CSDL webgaming (SQL Server) — các bảng chính đồ án Website bán laptop
-- Database First đã tồn tại; script này chỉ mô tả / bổ sung nếu thiếu.

IF DB_ID(N'webgaming') IS NULL
	CREATE DATABASE webgaming;
GO
USE webgaming;
GO

IF OBJECT_ID(N'dbo.Brand', N'U') IS NULL
CREATE TABLE dbo.Brand (
	ID bigint IDENTITY PRIMARY KEY,
	Name nvarchar(40) NOT NULL,
	MenuID bigint NULL
);

IF OBJECT_ID(N'dbo.ItemType', N'U') IS NULL
CREATE TABLE dbo.ItemType (
	ID bigint IDENTITY PRIMARY KEY,
	TypeName nvarchar(30) NOT NULL,
	MenuID bigint NULL
);

IF OBJECT_ID(N'dbo.Item', N'U') IS NULL
CREATE TABLE dbo.Item (
	ID bigint IDENTITY PRIMARY KEY,
	Name nvarchar(400) NOT NULL,
	PurcharsePrice decimal(18,0) NULL,
	SellPrice decimal(18,0) NOT NULL,
	DateImport datetime NULL,
	Quantity int NULL,
	TypeID bigint NULL,
	BrandID bigint NULL,
	Picture nvarchar(400) NULL,
	Active bit NULL,
	ShortTitle nvarchar(1000) NULL,
	Describe nvarchar(max) NULL
);

IF OBJECT_ID(N'dbo.Customer', N'U') IS NULL
CREATE TABLE dbo.Customer (
	ID bigint IDENTITY PRIMARY KEY,
	Username nvarchar(50) NOT NULL,
	Passwords nvarchar(100) NOT NULL,
	Name nvarchar(100) NULL,
	Address nvarchar(200) NULL,
	EmailAddress nvarchar(100) NULL,
	Phone nvarchar(20) NULL,
	Picture nvarchar(200) NULL
);

IF OBJECT_ID(N'dbo.[Order]', N'U') IS NULL
CREATE TABLE dbo.[Order] (
	ID bigint IDENTITY PRIMARY KEY,
	Orderdate datetime NULL,
	Deliverydate datetime NULL,
	Status bit NULL,
	CustomerID bigint NULL,
	Deliverystatus bit NULL,
	Totalprice decimal(18,0) NULL
);

IF OBJECT_ID(N'dbo.OrderDetail', N'U') IS NULL
CREATE TABLE dbo.OrderDetail (
	ID bigint IDENTITY PRIMARY KEY,
	Quantity int NOT NULL,
	ItemId bigint NULL,
	OrderID bigint NULL,
	Totalprice decimal(18,0) NULL
);

IF OBJECT_ID(N'dbo.Admin', N'U') IS NULL
CREATE TABLE dbo.Admin (
	Username nvarchar(50) PRIMARY KEY,
	Passwords nvarchar(100) NOT NULL,
	Name nvarchar(100) NULL,
	Picture nvarchar(200) NULL
);
GO
