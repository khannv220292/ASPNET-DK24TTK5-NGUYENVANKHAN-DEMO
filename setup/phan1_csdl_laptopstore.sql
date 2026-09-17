-- CSDL laptopstore (SQL Server) — schema các bảng chính đồ án Website bán laptop
-- Khớp cấu trúc local SQL Server. Dữ liệu đầy đủ nằm trong database.sql.

USE [master]
GO
IF DB_ID(N'laptopstore') IS NULL
    CREATE DATABASE [laptopstore];
GO
USE [laptopstore]
GO

-- Drop child tables first if re-running schema-only
IF OBJECT_ID(N'dbo.[Payment]', N'U') IS NOT NULL DROP TABLE dbo.[Payment];
IF OBJECT_ID(N'dbo.[OrderDetail]', N'U') IS NOT NULL DROP TABLE dbo.[OrderDetail];
IF OBJECT_ID(N'dbo.[Order]', N'U') IS NOT NULL DROP TABLE dbo.[Order];
IF OBJECT_ID(N'dbo.[Item]', N'U') IS NOT NULL DROP TABLE dbo.[Item];
IF OBJECT_ID(N'dbo.[Blogs]', N'U') IS NOT NULL DROP TABLE dbo.[Blogs];
IF OBJECT_ID(N'dbo.[Banner]', N'U') IS NOT NULL DROP TABLE dbo.[Banner];
IF OBJECT_ID(N'dbo.[Customer]', N'U') IS NOT NULL DROP TABLE dbo.[Customer];
IF OBJECT_ID(N'dbo.[Admin]', N'U') IS NOT NULL DROP TABLE dbo.[Admin];
IF OBJECT_ID(N'dbo.[ItemType]', N'U') IS NOT NULL DROP TABLE dbo.[ItemType];
IF OBJECT_ID(N'dbo.[Brand]', N'U') IS NOT NULL DROP TABLE dbo.[Brand];
IF OBJECT_ID(N'dbo.[Menu]', N'U') IS NOT NULL DROP TABLE dbo.[Menu];
GO

CREATE TABLE dbo.[Menu] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(40) NULL,
    [Link] nvarchar(40) NULL,
    CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[Brand] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(30) NOT NULL,
    [MenuID] bigint NULL,
    CONSTRAINT [PK_Brand] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[ItemType] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [TypeName] nvarchar(30) NOT NULL,
    [MenuID] bigint NULL,
    CONSTRAINT [PK_ItemType] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[Admin] (
    [Username] nvarchar(400) NOT NULL,
    [Passwords] nvarchar(400) NOT NULL,
    [Name] nvarchar(45) NOT NULL,
    [Picture] nvarchar(max) NULL,
    CONSTRAINT [PK_Admin] PRIMARY KEY CLUSTERED ([Username])
);
GO
CREATE TABLE dbo.[Customer] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Username] nvarchar(400) NOT NULL,
    [Passwords] nvarchar(400) NOT NULL,
    [Name] nvarchar(45) NOT NULL,
    [Address] nvarchar(100) NULL,
    [EmailAddress] char(100) NULL,
    [Phone] varchar(15) NULL,
    [Picture] nvarchar(max) NULL,
    CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED ([ID])
);
GO
ALTER TABLE dbo.[Customer] ADD CONSTRAINT [UQ__Customer__536C85E4D13A6333] UNIQUE ([Username]);
GO
CREATE TABLE dbo.[Banner] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Picture] nvarchar(200) NULL,
    CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[Blogs] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [DateImport] datetime NULL,
    [Title] nvarchar(max) NULL,
    [ShortTitle] nvarchar(max) NULL,
    [Picture] nvarchar(200) NULL,
    [Describe] nvarchar(max) NULL,
    CONSTRAINT [PK_Blogs] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[Item] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(400) NOT NULL,
    [PurcharsePrice] decimal(18,0) NULL,
    [SellPrice] decimal(18,0) NOT NULL,
    [DateImport] datetime NULL,
    [Quantity] int NULL,
    [TypeID] bigint NULL,
    [BrandID] bigint NULL,
    [Picture] nvarchar(400) NULL,
    [Active] bit NULL,
    [ShortTitle] nvarchar(1000) NULL,
    [Describe] nvarchar(max) NULL,
    CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[Order] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Orderdate] datetime NULL,
    [Deliverystatus] bit NULL,
    [Deliverydate] datetime NULL,
    [Status] bit NULL,
    [Totalprice] decimal(18,0) NULL,
    [CustomerID] bigint NULL,
    CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[OrderDetail] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Quantity] int NOT NULL,
    [ItemId] bigint NULL,
    [OrderID] bigint NULL,
    [Totalprice] decimal(18,0) NULL,
    CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED ([ID])
);
GO
CREATE TABLE dbo.[Payment] (
    [ID] bigint IDENTITY(1,1) NOT NULL,
    [Payprices] decimal(18,0) NULL,
    [OrderID] bigint NULL,
    CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED ([ID])
);
GO

-- Foreign keys (same as database.sql)
ALTER TABLE dbo.[Brand] WITH CHECK ADD CONSTRAINT [FK__Brand__MenuID__4D94879B] FOREIGN KEY ([MenuID]) REFERENCES dbo.[Menu] ([ID]);
ALTER TABLE dbo.[Brand] CHECK CONSTRAINT [FK__Brand__MenuID__4D94879B];
GO
ALTER TABLE dbo.[Item] WITH CHECK ADD CONSTRAINT [FK__Item__BrandID__4E88ABD4] FOREIGN KEY ([BrandID]) REFERENCES dbo.[Brand] ([ID]);
ALTER TABLE dbo.[Item] CHECK CONSTRAINT [FK__Item__BrandID__4E88ABD4];
GO
ALTER TABLE dbo.[Item] WITH CHECK ADD CONSTRAINT [FK__Item__TypeID__4F7CD00D] FOREIGN KEY ([TypeID]) REFERENCES dbo.[ItemType] ([ID]);
ALTER TABLE dbo.[Item] CHECK CONSTRAINT [FK__Item__TypeID__4F7CD00D];
GO
ALTER TABLE dbo.[ItemType] WITH CHECK ADD CONSTRAINT [FK__ItemType__MenuID__5070F446] FOREIGN KEY ([MenuID]) REFERENCES dbo.[Menu] ([ID]);
ALTER TABLE dbo.[ItemType] CHECK CONSTRAINT [FK__ItemType__MenuID__5070F446];
GO
ALTER TABLE dbo.[Order] WITH CHECK ADD CONSTRAINT [FK__Order__CustomerI__5165187F] FOREIGN KEY ([CustomerID]) REFERENCES dbo.[Customer] ([ID]);
ALTER TABLE dbo.[Order] CHECK CONSTRAINT [FK__Order__CustomerI__5165187F];
GO
ALTER TABLE dbo.[OrderDetail] WITH CHECK ADD CONSTRAINT [FK__OrderDeta__ItemI__52593CB8] FOREIGN KEY ([ItemId]) REFERENCES dbo.[Item] ([ID]);
ALTER TABLE dbo.[OrderDetail] CHECK CONSTRAINT [FK__OrderDeta__ItemI__52593CB8];
GO
ALTER TABLE dbo.[OrderDetail] WITH CHECK ADD CONSTRAINT [FK__OrderDeta__Order__534D60F1] FOREIGN KEY ([OrderID]) REFERENCES dbo.[Order] ([ID]);
ALTER TABLE dbo.[OrderDetail] CHECK CONSTRAINT [FK__OrderDeta__Order__534D60F1];
GO
ALTER TABLE dbo.[Payment] WITH CHECK ADD CONSTRAINT [FK__Payment__OrderID__5441852A] FOREIGN KEY ([OrderID]) REFERENCES dbo.[Order] ([ID]);
ALTER TABLE dbo.[Payment] CHECK CONSTRAINT [FK__Payment__OrderID__5441852A];
GO