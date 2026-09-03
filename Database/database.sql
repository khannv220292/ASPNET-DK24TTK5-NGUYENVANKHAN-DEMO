CREATE DATABASE webgaming;
GO
USE webgaming;
GO

CREATE TABLE Admin (
    Username NVARCHAR(50) PRIMARY KEY,
    Passwords NVARCHAR(50) NOT NULL,
    Name NVARCHAR(100)
);

CREATE TABLE Brand (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL
);

CREATE TABLE ItemType (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL
);

CREATE TABLE Item (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(150) NOT NULL,
    PurcharsePrice DECIMAL(18,2) DEFAULT 0,
    SellPrice DECIMAL(18,2) NOT NULL CHECK (SellPrice >= 0),
    DateImport DATETIME DEFAULT GETDATE(),
    Quantity INT NOT NULL DEFAULT 0 CHECK (Quantity >= 0),
    TypeID INT FOREIGN KEY REFERENCES ItemType(ID),
    BrandID INT FOREIGN KEY REFERENCES Brand(ID),
    Picture NVARCHAR(250),
    Active BIT DEFAULT 1,
    Describe NTEXT
);

CREATE TABLE Customer (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Passwords NVARCHAR(50) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(250),
    Phone NVARCHAR(20)
);

CREATE TABLE [Order] (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    Orderdate DATETIME DEFAULT GETDATE(),
    Deliverystatus NVARCHAR(50) DEFAULT N'Chờ xử lý',
    Totalprice DECIMAL(18,2) DEFAULT 0,
    CustomerID BIGINT FOREIGN KEY REFERENCES Customer(ID)
);

CREATE TABLE OrderDetail (
    ID BIGINT IDENTITY(1,1) PRIMARY KEY,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    ItemId BIGINT FOREIGN KEY REFERENCES Item(ID),
    OrderID BIGINT FOREIGN KEY REFERENCES [Order](ID),
    Totalprice DECIMAL(18,2) NOT NULL
);

-- Dữ liệu mẫu
INSERT INTO Admin VALUES ('admin', '123456', N'Quản trị viên');
INSERT INTO Brand VALUES (N'Dell'), (N'ASUS'), (N'Lenovo'), (N'Apple');
INSERT INTO ItemType VALUES (N'Gaming'), (N'Văn phòng'), (N'Đồ họa cao cấp');
INSERT INTO Item (Name, PurcharsePrice, SellPrice, Quantity, TypeID, BrandID, Picture, Active, Describe)
VALUES 
(N'Dell Inspiron 15', 12000000, 14500000, 10, 2, 1, 'dell.jpg', 1, N'Core i5, RAM 16GB, SSD 512GB'),
(N'ASUS TUF Gaming F15', 18000000, 21990000, 5, 1, 2, 'asus.jpg', 1, N'Core i7, RTX 3050, 144Hz'),
(N'MacBook Air M2', 22000000, 24500000, 4, 3, 4, 'macbook.jpg', 1, N'Chip M2, 8GB RAM, SSD 256GB');
