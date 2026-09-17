-- Full schema + data dump from local SQL Server
-- Generated: 2026-09-17 10:14:30
-- Source: localhost / laptopstore
USE [master]
GO
IF DB_ID(N'laptopstore') IS NULL
    CREATE DATABASE [laptopstore];
GO
USE [laptopstore]
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO
-- Drop FKs / tables (child first)
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
-- ===== Menu : 11 rows =====
SET IDENTITY_INSERT dbo.[Menu] ON;
GO
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (1, N'Lenovo', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (2, N'Dell', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (3, N'HP', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (4, N'Phụ kiện', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (5, N'Asus', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (7, N'Acer', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (8, N'Apple', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (9, N'Gigabyte', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (10, N'LG', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (11, N'MSI', NULL);
INSERT INTO dbo.[Menu] ([ID], [Name], [Link]) VALUES (13, N'LG', NULL);
GO
SET IDENTITY_INSERT dbo.[Menu] OFF;
GO
-- ===== Brand : 2 rows =====
SET IDENTITY_INSERT dbo.[Brand] ON;
GO
INSERT INTO dbo.[Brand] ([ID], [Name], [MenuID]) VALUES (1, N'Còn hàng', 1);
INSERT INTO dbo.[Brand] ([ID], [Name], [MenuID]) VALUES (2, N'Thanh lý', 2);
GO
SET IDENTITY_INSERT dbo.[Brand] OFF;
GO
-- ===== ItemType : 16 rows =====
SET IDENTITY_INSERT dbo.[ItemType] ON;
GO
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (1, N'ThinkPad T', 1);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (2, N'ThinkPad X', 1);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (3, N'Latitude', 2);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (4, N'XPS / Precision', 2);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (5, N'Laptop HP', 3);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (6, N'OmniBook', NULL);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (7, N'SSD / Adapter', 4);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (8, N'Bàn phím', 4);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (9, N'Chuột', 4);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (10, N'Đế tản nhiệt', 4);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (12, N'Asus', NULL);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (13, N'MacBook Neo', 8);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (14, N'Acer Predator', 7);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (15, N'Acer Nitro', 7);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (16, N'Gigabyte', 9);
INSERT INTO dbo.[ItemType] ([ID], [TypeName], [MenuID]) VALUES (17, N'MSI ', 11);
GO
SET IDENTITY_INSERT dbo.[ItemType] OFF;
GO
-- ===== Admin : 1 rows =====
INSERT INTO dbo.[Admin] ([Username], [Passwords], [Name], [Picture]) VALUES (N'Admin', N'PQvWLmGwRii3yftVSaD5Wh1BwqlPRsuIjO9YEEQGbJJsYXB0b3Aua2hhbm52LnZu', N'Nguyen Van Admin', N'hinh.png');
GO
-- ===== Customer : 9 rows =====
SET IDENTITY_INSERT dbo.[Customer] ON;
GO
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (3, N'quanghuy', N'123456', N'Bùi Quang Huy', N'Hà Nội', N'quanghuy@gmail.com                                                                                  ', N'0394073514', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (4, N'Admin', N'admin', N'Admin', N'Vinh Long', N'admin@khannvshop.vn                                                                                 ', N'0123456789', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (5, N'guest_0978111017', N'8e343c1e', N'Nguyễn Văn Khan', N'369 An Dương Vương, Phường 1, Quận 10, Hồ Chí Minh', N'0978111017@guest.local                                                                              ', N'0978111017', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (6, N'guest_0978111019', N'650bc6fa', N'Le Ngoc Hung', N'Lo 10 Duong so 2 KCN Tan Tao, An Binh, Ninh Kieu, Can Tho', N'0978111019@guest.local                                                                              ', N'0978111019', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (7, N'guest_0978222456', N'e622971a', N'Phan Văn Mẫn', N'120 Hồng bàng, Phường 10, Quận 10, Hồ Chí Minh', N'0978222456@guest.local                                                                              ', N'0978222456', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (8, N'guest_0911122202', N'c344e4e5', N'huỳnh kim thoa', N'hồng bàng, Tân Thuận Đông, Quận 7, Hồ Chí Minh', N'0911122202@guest.local                                                                              ', N'0911122202', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (9, N'guest_0778945123', N'60d8351a', N'PHAN VĂN MẪN', N'02 PHAN VĂN TRỊ, Phường 13, Gò Vấp, Hồ Chí Minh', N'0778945123@guest.local                                                                              ', N'0778945123', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (10, N'guest_978123456', N'b689b65f', N'NGUYỄN VĂN A', N'93 KINH DƯƠNG VƯƠNG, Hải Châu I, Hải Châu, Đà Nẵng', N'978123456@guest.local                                                                               ', N'978123456', NULL);
INSERT INTO dbo.[Customer] ([ID], [Username], [Passwords], [Name], [Address], [EmailAddress], [Phone], [Picture]) VALUES (11, N'user1', N'5DIG5U+af0I01KmKr8wf0h1AFtLxdlIe97C5atnK/25sYXB0b3Aua2hhbm52LnZu', N'Nguyễn Thị C', N'369 An dương Vương', N'nguyenvankhan.itc@gmail.com                                                                         ', N'0978111017', NULL);
GO
SET IDENTITY_INSERT dbo.[Customer] OFF;
GO
-- ===== Banner : 3 rows =====
SET IDENTITY_INSERT dbo.[Banner] ON;
GO
INSERT INTO dbo.[Banner] ([ID], [Picture]) VALUES (1, N'20260907205940864_dae692.webp');
INSERT INTO dbo.[Banner] ([ID], [Picture]) VALUES (2, N'20260907210616081_cb7a8b.webp');
INSERT INTO dbo.[Banner] ([ID], [Picture]) VALUES (3, N'20260907210359773_a3963e.webp');
GO
SET IDENTITY_INSERT dbo.[Banner] OFF;
GO
-- ===== Blogs : 0 rows =====
-- (no data)
GO
-- ===== Item : 38 rows =====
SET IDENTITY_INSERT dbo.[Item] ON;
GO
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (1, N'LENOVO THINKPAD T14 ', 15999000, 14990000, '2026-09-14 00:00:00.000', 12, 1, 1, N'20260914203211103_bd9049.jpg', 1, N'LENOVO THINKPAD T14 Gen 6 Ultra 7 265U RAM 32GB SSD 512GB 14INCH WUXGA IPS- Máy mới 99%', N'<p class="mb-1.5 font-bold" style="box-sizing: border-box; margin: 0px 0px 6px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 700; font-weight: bold; color: #2b2b2b; font-family: Roboto, ''Segoe UI'', Arial, sans-serif; background-color: #ffffff;">Cấu h&igrave;nh nổi bật</p>
<dl class="grid grid-cols-[auto_1fr] gap-x-3 gap-y-1 text-[13px]" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; display: grid; grid-template-columns: auto 1fr; gap: 4px 12px; font-size: 13px; color: #2b2b2b; font-family: Roboto, ''Segoe UI'', Arial, sans-serif; background-color: #ffffff;">
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">CPU</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">Intel&reg; Core&trade; Ultra 7 265U Processor with vPro&reg; (E-cores up to 4.20 GHz, P-cores up to 5.30 GHz with Turbo Boost, 12 Cores, 14 Threads, 12 MB Cache)</dd>
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">RAM</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">32GB (2x16GB DDR5 5600MT/s)</dd>
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">Đĩa Cứng</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">512GB PCIe Gen 4 SSD (2280)</dd>
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">Card đồ họa</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">Intel&reg; graphics</dd>
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">M&agrave;n h&igrave;nh</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">14inch (1920 x 1200) IPS, antiglare, 400nit, 45% NTSC, 3M Dual Brightness Enhancement Film (DBEF5) Eyesafe&reg; low blue-light certified</dd>
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">Hệ điều h&agrave;nh</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">Window 11 License</dd>
<dt class="font-medium text-muted" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed; --tw-font-weight: 500; color: #545b66;">Xuất Xứ</dt>
<dd style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px solid #e8eaed;">H&agrave;ng Nhập Khẩu</dd>
</dl>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (2, N'ThinkPad X1 Carbon 9', 17200000, 15990000, '2023-05-02 00:00:00.000', 8, 2, 1, N'shopping.webp', 1, N'i5-1135G7 / 8GB / 256GB / 14" siêu nhẹ', N'<p><strong>Lenovo ThinkPad X1 Carbon Gen 9</strong> si&ecirc;u nhẹ, vỏ carbon.</p>
<p>i5-1135G7, 8GB, SSD 256GB, 14 inch. M&aacute;y x&aacute;ch tay USA.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (3, N'Latitude 7420', 12999000, 11990000, '2023-05-02 00:00:00.000', 15, 3, 1, N'Latitude 7420.jpg', 1, N'i7-1185G7 / 16GB / 512GB / 14" FHD', N'<p><strong>Dell Latitude 7420</strong> Core i7 thế hệ 11, 16GB RAM, SSD 512GB.</p>
<p>Laptop doanh nghiệp bền, b&agrave;n ph&iacute;m &ecirc;m, webcam HD.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (4, N'XPS 15 7590', 19500000, 18990000, '2023-05-02 00:00:00.000', 5, 4, 2, N'XPS 15 7590.jpg', 1, N'i7-9750H / 16GB / 512GB / RTX 1650', N'<p><strong>Dell XPS 15 7590</strong> m&agrave;n 15.6 inch, card RTX, thanh l&yacute; tồn kho (Clear Stock).</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (5, N'Elitebook 6 G11', 35900000, 42590000, '2026-09-03 18:04:30.000', 8, 5, 1, N'Latitude 7420.jpg', 1, N'U7-255H / 16GB / 512GB / 14 WUXGA', N'<p><strong>HP Elitebook 6 G11 - BQ9N4PT</strong> (phongvu.vn).</p>
<p>Ultra 7-255H, Intel Graphics, 16GB, 512GB, 1.4kg, 14 WUXGA IPS. Gia 42.590.000d.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (6, N'OmniBook 7 14', 35490000, 31590000, '2026-09-03 18:04:30.000', 10, 5, 1, N'XPS 15 7590.jpg', 1, N'Ultra 7-255U / 16GB / 512GB / 14 WUXGA', N'<p><strong>HP OmniBook 7 14-fr0027TU - C1MN1PA</strong>.</p>
<p>Ultra 7-255U, 16GB, 512GB, 1.41kg, 14 WUXGA IPS. Gia 31.590.000d.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (7, N'Dell G3 3500', 15500000, 14990000, '2023-05-02 00:00:00.000', 9, 3, 1, N'Victus 15 RTX4050.jpg', 1, N'i7-10750H / 16GB / 512GB / GTX 1650', N'<p><strong>Dell G3 3500 Gaming</strong> i7-10750H, GTX 1650, 16GB, SSD 512GB.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (14, N'ThinkPad E14 Gen2', 8900000, 7990000, '2026-09-14 00:00:00.000', 20, 1, 1, N'x_m_5__36_1.webp', 1, N'i7-1165G7 / 16GB / 512GB / 14.1"', N'<p><strong>Lenovo ThinkPad E14 Gen 2</strong> i7-1165G7, 16GB, 512GB. Gi&aacute; tốt sinh vi&ecirc;n.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (15, N'Latitude 5430', 11000000, 13490000, '2023-05-02 00:00:00.000', 11, 3, 1, N'Laptop HP 14 em0023AU - D0BG7PA.webp', 1, N'i7-1265U / 16GB / 512GB / 14" FHD', N'<p><strong>Dell Latitude 5430</strong> Core i7 Gen 12, 16GB, SSD 512GB.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (16, N'Legion Y740 15', 14000000, 16990000, '2023-05-02 00:00:00.000', 4, 1, 2, N'Laptop HP Legion Y740 15.jpg', 1, N'i7-9750H / 16GB / 1TB / RTX 2060', N'<p><strong>Lenovo Legion Y740</strong> gaming, RTX 2060, thanh l&yacute;.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (17, N'HP 14 em0023AU', 17990000, 20990000, '2026-09-03 18:04:30.000', 15, 5, 1, N'Laptop HP HP 14 em0023AU.png', 1, N'R5 7520U / 16GB / 512GB / 14 FHD', N'<p><strong>HP 14 em0023AU - D0BG7PA</strong>.</p>
<p>Ryzen 5 7520U, AMD Radeon, 16GB, 512GB, 1.4kg, 14 FHD IPS. Tiet kiem 3.000.000d. Gia 20.990.000d.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (18, N'Laptop HP ProBook 4 G1I 16 BQ5D8PT', 33000000, 32790000, '2026-09-03 18:04:30.000', 6, 5, 1, N'20260914204822121_c4fa19.webp|20260914204822145_981c1c.webp', 1, N'U5-225H/16GB/512GB PCIE/16.0 WUXGA/WIN11PRO/BẠC', N'<p><a class="table-content__item level-2" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; margin-top: 5px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#laptop-hp-probook-4-g1i-16-bq5d9pt-ben-bi-voi-tinh-nang-bao-mat-vuot-troi" data-v-1bddbad4="">1. Laptop HP ProBook 4 G1I 16 BQ5D9PT - Bền bỉ với t&iacute;nh năng bảo mật vượt trội</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#intel-core-ultra-5-225h-so-huu-npu-tang-toc-xu-ly-ai-toi-uu" data-v-1bddbad4="">1.1. Intel Core Ultra 5 225H sở hữu NPU, tăng tốc xử l&yacute; AI tối ưu</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#16gb-ddr5-5600mhz-o-nvme-512gb-2-khe-sodimm-linh-hoat" data-v-1bddbad4="">1.2. 16GB DDR5 5600MHz, ổ NVMe 512GB, 2 khe SODIMM linh hoạt</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#khung-nhom-pike-silver-thiet-ke-mong-chi-1-09cm" data-v-1bddbad4="">1.3. Khung nh&ocirc;m Pike Silver, thiết kế mỏng chỉ 1,09cm</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#14-nhan-xu-ly-len-den-4-9-ghz-gpu-intel-arc-130t-tich-hop" data-v-1bddbad4="">1.4. 14 nh&acirc;n xử l&yacute; l&ecirc;n đến 4,9 GHz, GPU Intel Arc 130T t&iacute;ch hợp</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#sac-usb-c-65w-pin-li-ion-56wh-bluetooth-5-3-wi-fi-6e" data-v-1bddbad4="">1.5. Sạc USB-C 65W, pin Li-ion 56Wh, Bluetooth 5.3, Wi-Fi 6E</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#man-hinh-ips-16-inch-wuxga-ti-le-16-10-rong-hon" data-v-1bddbad4="">1.6. M&agrave;n h&igrave;nh IPS 16 inch WUXGA, tỉ lệ 16:10 rộng hơn</a><a class="table-content__item level-2" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; margin-top: 5px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-hp-probook-4-g1i-16-bq5d9pt.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-1uZppfRh_WJ471uBGmkmXWLCy-JyDVCNyG6P5En4dkc1AA4VylzbBoCZBoQAvD_BwE#mua-ngay-laptop-hp-probook-4-g1i-16-bq5d9pt-chinh-hang-tai-cellphones" data-v-1bddbad4="">2. Mua ngay laptop HP ProBook 4 G1I 16 BQ5D9PT ch&iacute;nh h&atilde;ng tại laptop.khannv.vn</a></p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (19, N'Laptop HP 14-hc0028TU Ultra 5 225U/AI/16GB/512GB/14" FHD/Win11 (D72BJPA)', 21000000, 24990000, '2026-09-19 18:04:30.000', 11, 5, 1, N'20260914222658675_ce0b58.webp', 1, N'Laptop HP 14-hc0028TU Ultra 5 225U/AI/16GB/512GB/14" FHD/Win11 (D72BJPA)', N'<p><a style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; text-decoration: inherit; font-family: __Inter_48b81b, __Inter_Fallback_48b81b; font-size: 14px; font-variant-ligatures: none; text-align: justify; background-color: #ffffff; color: #1250dc !important; --tw-text-opacity: 1 !important;" href="https://fptshop.com.vn/may-tinh-xach-tay/hp-14-hc0028tu-ultra-5-225u-d72bjpa"><span style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; font-weight: bolder;">HP 14-hc0028TU</span></a><span style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; font-weight: bolder; font-family: __Inter_48b81b, __Inter_Fallback_48b81b; font-size: 14px; font-variant-ligatures: none; text-align: justify; background-color: #ffffff;">&nbsp;g&acirc;y ấn tượng với bộ vi xử l&yacute; Intel Core Ultra 5 225U cực mạnh đi c&ugrave;ng 16 GB RAM DDR5 tốc độ cao, gi&uacute;p bạn l&agrave;m việc năng suất v&agrave; hiệu quả hơn. Với thiết kế thanh lịch v&agrave; mỏng nhẹ, HP 14-hc0028TU sẽ mang đến trải nghiệm học tập, l&agrave;m việc v&agrave; giải tr&iacute; linh hoạt ở bất cứ đ&acirc;u.</span></p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (20, N'Laptop HP 14‑EM0023AU D0BG7PA', 20500000, 20990000, '2026-09-03 18:04:30.000', 9, 5, 1, N'ssss_2__1_76 (1).webp', 1, N'Core 5 120U / 16GB / 512GB / 14 FHD', N'Laptop HP 14‑EM0023AU D0BG7PA');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (21, N'OmniBook 5 16', 23000000, 25990000, '2026-09-03 18:04:30.200', 7, 5, 1, N'laptop-hp-05.jpg', 1, N'R5 8640HS / 16GB / 512GB / 16 WUXGA', N'<p><b>HP OmniBook 5 16-ag1069AU - BZ7T1PA</b>.</p><p>Ryzen 5 8640HS, 16GB, 512GB, 1.8kg, 16 WUXGA. Gia 25.990.000d.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (22, N'Laptop HP 250R G10 C3SH7AT', 22990000, 22990000, '2026-09-03 18:04:30.000', 11, 5, 1, N'laptop-hp-victus-16-r0298tx-ae0n5pa.webp', 1, N'Core 5 120U / 16GB / 512GB / 15.6 FHD', N'<p><strong>HP 250R G10 - C3SH7AT</strong>.</p>
<p><span style="color: #4a4a4a; font-family: Inter, Roboto, sans-serif; font-size: 14px; text-align: justify; background-color: #ffffff;">Laptop HP 250R G10 C3SH7AT l&agrave; d&ograve;ng m&aacute;y t&iacute;nh x&aacute;ch tay văn ph&ograve;ng sở hữu sự c&acirc;n bằng tối ưu giữa năng lực xử l&yacute; dữ liệu v&agrave; t&iacute;nh di động linh hoạt cao. Thiết bị được trang bị cấu h&igrave;nh hiện đại, đ&aacute;p ứng tốt nhu cầu học tập v&agrave; l&agrave;m việc hằng ng&agrave;y. Thiết bị sở hữu thiết kế m&agrave;u bạc sang trọng, ph&ugrave; hợp với m&ocirc;i trường văn ph&ograve;ng hiện đại.</span></p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (23, N'Laptop HP EliteBook 640 G11 A7LB4PT', 32990000, 32990000, '2026-09-03 18:04:30.000', 5, 5, 1, N'laptop-hp-03.jpg', 1, N'Laptop HP EliteBook 640 G11 A7LB4PT (Ultra 7 165U/ 16GB/ 512GB SSD/ 14 inch WUXGA/ Win11/ Silver/ Vỏ nhôm)', N'<p><span style="font-size: 13px; background-color: #ffffff; color: #222222; font-family: arial, verdana, sans-serif;">Bộ VXL: Ultra 7 165U 1.2GHz</span></p>
<p><span style="font-size: 13px; background-color: #ffffff; color: #222222; font-family: arial, verdana, sans-serif;">Bộ nhớ RAM: 16Gb DDR5 5600</span></p>
<ul class="ul" style="box-sizing: border-box; margin: 0px; padding: 0px; list-style: none; color: #222222; font-family: arial, verdana, sans-serif; font-size: 13px; background-color: #ffffff;">
<li style="box-sizing: border-box; padding: 4px 0px; overflow: hidden;">
<h3 style="box-sizing: border-box; font-size: 13px; margin: 0px; padding: 0px; line-height: 1.45; font-weight: 400;">Ổ cứng: 512Gb SSD</h3>
</li>
<li style="box-sizing: border-box; padding: 4px 0px; overflow: hidden;">
<h3 style="box-sizing: border-box; font-size: 13px; margin: 0px; padding: 0px; line-height: 1.45; font-weight: 400;">Card m&agrave;n h&igrave;nh: VGA onboard - Intel UHD Graphics</h3>
</li>
<li style="box-sizing: border-box; padding: 4px 0px; overflow: hidden;">
<h3 style="box-sizing: border-box; font-size: 13px; margin: 0px; padding: 0px; line-height: 1.45; font-weight: 400;">K&iacute;ch thước m&agrave;n h&igrave;nh: 14.0inch WUXGA</h3>
</li>
<li style="box-sizing: border-box; padding: 4px 0px; overflow: hidden;">
<h3 style="box-sizing: border-box; font-size: 13px; margin: 0px; padding: 0px; line-height: 1.45; font-weight: 400;">Hệ điều h&agrave;nh: Windows 11 Home</h3>
</li>
</ul>
<p>.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (24, N'Victus 15 RTX4050', 25000000, 28990000, '2026-09-03 18:04:30.000', 8, 5, 1, N'Victus 15 RTX4050.jpg', 1, N'i5-13420H / RTX 4050 / 16GB / 512GB', N'<ul class="a-unordered-list a-vertical a-spacing-mini" style="box-sizing: border-box; margin: 0px 0px 0px 18px; color: #0f1111; padding: 0px; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; background-color: #ffffff;">
<li class="a-spacing-mini" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">16GB RAM | 512GB SSD</span></li>
<li class="a-spacing-mini" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Equipped With The Most Powerful and Fast 12th Gen Intel 8-core i5-12450H</span></li>
<li class="a-spacing-mini" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">15.6" FHD (1920 x 1080) IPS Anti-glare 144Hz, Dedicated NVIDIA GeForce RTX 3050 Graphic</span></li>
<li class="a-spacing-mini" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">1 x SuperSpeed USB-C, 2 x SuperSpeed USB-A, 1 x HDMI 2.1, 1 x Ethernet RJ45, 1 x Multi-format SD Media Card Reader</span></li>
<li class="a-spacing-mini" style="box-sizing: border-box; list-style: disc; overflow-wrap: break-word; margin: 0px;"><span class="a-list-item" style="box-sizing: border-box;">Microsoft Windows 11 Professional, Backlit Keyboard, Bluetooth 5.3, Bang &amp; Olufsen, HP Wide Vision 720p HD Camera, Fast Charge</span></li>
</ul>
<div id="product-details-jumplink" class="a-section" style="box-sizing: border-box; margin-bottom: 0px; color: #0f1111; font-family: ''Amazon Ember'', Arial, sans-serif; font-size: 14px; background-color: #ffffff;"><span class="caretnext" style="box-sizing: border-box; color: #cc6600; font-size: 1.2em; font-weight: bold; margin-left: 4px;">&rsaquo;</span>&nbsp;<a id="seeMoreDetailsLink" class="a-link-normal" style="box-sizing: border-box; text-decoration-line: none; color: #2162a1;" href="https://www.amazon.com/HP-Victus-15-Anti-Glare-i5-12450H/dp/B0FPQCQFDQ/ref=sr_1_1?adgrpid=199821483096&amp;dib=eyJ2IjoiMSJ9.IRSkL50BgGmTYjpdGhBGkFiNMj8gM6hiwIXyw7koe74DbgvTemXzfNBJUsfNdoRC0YmxTkyysX_6-JlFBoZcd1Vp-IYW5vJgp9Z0C_kF0cU_FcPHPtrQ8mLuNofokuceDY2CFsx5L1UXL7L5FPc6O4m9jvLMZnE3Ec7N3qNWI1hEAgXQyMFQktGK-VsU1jHSbsX4HzAByuUiS4h2WZ2pGU6QccDgAhLYYfERCwqS3Qc.UDa84F9PkyJqdZRZqj9339C4omnjV0-kB4b1WF8iE0k&amp;dib_tag=se&amp;hvadid=821459476946&amp;hvdev=c&amp;hvlocphy=9266805&amp;hvnetw=g&amp;hvqmt=b&amp;hvrand=7891174707161489396&amp;hvtargid=kwd-2444322779215&amp;hydadcr=21442_13333166&amp;keywords=hp%2Bvictus%2B15%2Brtx%2B3050%2B16gb&amp;mcid=31a549421ee630bda6e44bf7e78c3407&amp;qid=1788498312&amp;sr=8-1&amp;th=1#productDetails">See more product details</a></div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (25, N'OmniBook X Flip', 28000000, 31390000, '2026-09-03 18:04:30.200', 6, 5, 1, N'laptop-hp-05.jpg', 1, N'Ultra 5-226V / 16GB / 512GB / 14 WUXGA', N'<p><b>HP OmniBook X Flip 14-fm0088TU - BZ7Q2PA</b>.</p><p>U5-226V, 16GB, 512GB, 1.3kg, 14 WUXGA. Gia 31.390.000d.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (26, N'ProBook 4 G1i', 28000000, 32490000, '2026-09-03 18:04:30.000', 7, 5, 1, N'Laptop HP HP 14 em0023AU.png', 1, N'Ultra 7-255U / 16GB / 512GB / 14 WUXGA', N'<p><strong>HP ProBook 4 G1i - BQ5C7PT</strong>.</p>
<p>Ultra 7-255U, 16GB, 512GB, 1.4kg, 14 WUXGA. Gia 32.490.000d.</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (27, N'Laptop HP 14 em0023AU - D0BG7PA ', 20990000, 20990000, '2026-09-03 20:08:09.000', 1, 5, 1, N'Laptop HP 14 em0023AU - D0BG7PA.webp', 1, N'Laptop HP 14 em0023AU - D0BG7PA (Ryzen 5 7520U/ 16GB/ 512GB/ Windows 11 Home SL)', N'<p>Laptop HP 14 em0023AU - D0BG7PA (Ryzen 5 7520U/ 16GB/ 512GB/ Windows 11 Home SL)</p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (28, N'Laptop ASUS TUF Gaming F15 FX506HF', 15000000, 17490000, '2026-09-03 20:53:27.000', 5, 12, 1, N'laptop-hp-01.jpg', 1, N'Laptop ASUS TUF Gaming F15 FX506HF', N'<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<ul class="text-specifi active" style="box-sizing: border-box; margin: 0px; padding: 0px; list-style: none; overflow: hidden;">
<li style="box-sizing: border-box; margin: 0px; padding: 10px; display: block; overflow: hidden; border-bottom: 1px solid #eaecf0;">
<aside style="box-sizing: border-box; margin: 0px; padding: 0px; overflow: hidden;"><span class="" style="box-sizing: border-box; margin: 0px; padding: 0px; display: block; overflow: hidden; line-height: 20px;">&nbsp;</span></aside>
</li>
</ul>
</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (29, N'Laptop Dell Inspiron 15 3520 8D10NK', 16000000, 15290000, '2026-09-03 20:53:27.000', 9, 3, 1, N'20260914203717547_46ad72.webp', 1, N'Laptop Dell Inspiron 15 3520 i5 1235U/16GB/512GB/15.6"FHD/Win11/Office HS24/OS365', N'<p style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; font-family: __Inter_48b81b, __Inter_Fallback_48b81b; font-size: 14px; font-variant-ligatures: none; background-color: #ffffff; text-align: justify; margin: revert !important;"><span style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; font-weight: bolder;">Dell Inspiron 15 3520 l&agrave; lựa chọn l&yacute; tưởng cho người d&ugrave;ng văn ph&ograve;ng, sinh vi&ecirc;n v&agrave; những ai y&ecirc;u cầu cao về năng lực đa nhiệm. Sở hữu chip Intel Core i5 thế hệ 12, RAM 16GB, ổ cứng SSD 512GB c&ugrave;ng m&agrave;n h&igrave;nh 120Hz, sản phẩm n&agrave;y l&agrave; minh chứng cho xu hướng laptop đa năng, hiệu quả m&agrave; vẫn giữ t&iacute;nh cơ động cao.</span></p>
<p><span style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; font-weight: bolder;">&nbsp;</span></p>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (30, N'Laptop Lenovo Ideapad 3 15IAU7', 15990000, 10900000, '2026-09-04 00:00:00.000', 0, 2, 2, N'20260914202332185_ae3fdf.jpg|20260914202357434_74440c.jpg', 1, N'Laptop Lenovo Ideapad 3 15IAU7 i3 1215U/8GB/256GB/Win11 (82RK00RWVN)', N'<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<ul class="text-specifi active" style="box-sizing: border-box; margin: 0px; padding: 0px; list-style: none; overflow: hidden;">
<li style="box-sizing: border-box; margin: 0px; padding: 10px; display: block; overflow: hidden; border-bottom: 1px solid #eaecf0;">
<aside style="box-sizing: border-box; margin: 0px 30px 0px 0px; padding: 0px; float: left; width: 200px; max-width: 30%;"><span style="box-sizing: border-box; margin: 0px; padding: 0px; font-weight: 600; display: block; overflow: hidden; line-height: 20px;">C&ocirc;ng nghệ CPU:</span></aside>
<aside style="box-sizing: border-box; margin: 0px; padding: 0px; overflow: hidden;"><span class="" style="box-sizing: border-box; margin: 0px; padding: 0px; display: block; overflow: hidden; line-height: 20px;"><a style="box-sizing: border-box; margin: 0px; padding: 0px; text-decoration-line: none; transition: 0.2s; color: #2997ff;" href="https://www.thegioididong.com/tin-tuc/chip-intel-the-he-12-la-gi-1400953" target="_blank" rel="noopener">Intel Core i3 Alder Lake</a>&nbsp;-&nbsp;<a style="box-sizing: border-box; margin: 0px; padding: 0px; text-decoration-line: none; transition: 0.2s; color: #2997ff;" href="https://www.thegioididong.com/hoi-dap/tim-hieu-chip-intel-core-i3-1215u-chi-tiet-ve-1473649" target="_blank" rel="noopener">1215U</a></span></aside>
</li>
<li style="box-sizing: border-box; margin: 0px; padding: 10px; display: block; overflow: hidden; border-bottom: 1px solid #eaecf0;">
<aside style="box-sizing: border-box; margin: 0px 30px 0px 0px; padding: 0px; float: left; width: 200px; max-width: 30%;"><span style="box-sizing: border-box; margin: 0px; padding: 0px; font-weight: 600; display: block; overflow: hidden; line-height: 20px;">Số nh&acirc;n:</span></aside>
<aside style="box-sizing: border-box; margin: 0px; padding: 0px; overflow: hidden;"><span class="" style="box-sizing: border-box; margin: 0px; padding: 0px; display: block; overflow: hidden; line-height: 20px;">6</span></aside>
</li>
<li style="box-sizing: border-box; margin: 0px; padding: 10px; display: block; overflow: hidden; border-bottom: 1px solid #eaecf0;">
<aside style="box-sizing: border-box; margin: 0px 30px 0px 0px; padding: 0px; float: left; width: 200px; max-width: 30%;"><span style="box-sizing: border-box; margin: 0px; padding: 0px; font-weight: 600; display: block; overflow: hidden; line-height: 20px;">Số luồng:</span></aside>
<aside style="box-sizing: border-box; margin: 0px; padding: 0px; overflow: hidden;"><span class="" style="box-sizing: border-box; margin: 0px; padding: 0px; display: block; overflow: hidden; line-height: 20px;">8</span></aside>
</li>
<li style="box-sizing: border-box; margin: 0px; padding: 10px 10px 0px; display: block; overflow: hidden; border-bottom: 0px;">
<aside style="box-sizing: border-box; margin: 0px 30px 0px 0px; padding: 0px; float: left; width: 200px; max-width: 30%;"><span style="box-sizing: border-box; margin: 0px; padding: 0px; font-weight: 600; display: block; overflow: hidden; line-height: 20px;">Tốc độ CPU:</span></aside>
<aside style="box-sizing: border-box; margin: 0px; padding: 0px; overflow: hidden;"><span class="" style="box-sizing: border-box; margin: 0px; padding: 0px; display: block; overflow: hidden; line-height: 20px;">1.2GHz</span></aside>
</li>
</ul>
</div>
<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<h3 style="box-sizing: border-box; margin: 0px; padding: 0px; font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-size-adjust: none; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-variant-emoji: normal; font-weight: 500; font-stretch: normal; font-size: 16px; line-height: 20px; color: #171d29; outline: 0px;">Đồ hoạ (GPU)</h3>
</div>
<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<h3 style="box-sizing: border-box; margin: 0px; padding: 0px; font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-size-adjust: none; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-variant-emoji: normal; font-weight: 500; font-stretch: normal; font-size: 16px; line-height: 20px; color: #171d29; outline: 0px;">Bộ nhớ RAM, Ổ cứng</h3>
</div>
<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<h3 style="box-sizing: border-box; margin: 0px; padding: 0px; font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-size-adjust: none; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-variant-emoji: normal; font-weight: 500; font-stretch: normal; font-size: 16px; line-height: 20px; color: #171d29; outline: 0px;">M&agrave;n h&igrave;nh</h3>
</div>
<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<h3 style="box-sizing: border-box; margin: 0px; padding: 0px; font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-size-adjust: none; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-variant-emoji: normal; font-weight: 500; font-stretch: normal; font-size: 16px; line-height: 20px; color: #171d29; outline: 0px;">Cổng kết nối &amp; t&iacute;nh năng mở rộng</h3>
</div>
<div class="box-specifi" style="box-sizing: border-box; margin: 0px 0px 10px; padding: 0px; overflow: hidden; color: #344054; font-family: Arial, Helvetica, sans-serif; font-size: 14px; background-color: #ffffff;">
<h3 style="box-sizing: border-box; margin: 0px; padding: 0px; font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-size-adjust: none; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-variant-emoji: normal; font-weight: 500; font-stretch: normal; font-size: 16px; line-height: 20px; color: #171d29; outline: 0px;">K&iacute;ch thước - Khối lượng - Pin</h3>
</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (31, N'MacBook Neo 13 8GB/256GB/20W', 18790000, 16590000, '2026-09-14 21:52:33.000', 1, 13, 1, N'20260914205039306_228054.webp|20260914205039318_b08409.webp', 1, N'MacBook Neo 13 8GB/256GB/20W', N'<h1 class="mb-2 text-textOnWhitePrimary b2-medium pc:l6-semibold" style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; font-family: __Inter_48b81b, __Inter_Fallback_48b81b; font-variant-ligatures: none; background-color: #ffffff; font-size: 20px !important; color: #090d14 !important; line-height: 28px !important; margin: 0px 0px 0.5rem !important 0px;">MacBook Neo 13&nbsp;<span class="break-all" style="border: 0px solid #e5e7eb; box-sizing: border-box; --tw-border-spacing-x: 0; --tw-border-spacing-y: 0; --tw-translate-x: 0; --tw-translate-y: 0; --tw-rotate: 0; --tw-skew-x: 0; --tw-skew-y: 0; --tw-scale-x: 1; --tw-scale-y: 1; --tw-scroll-snap-strictness: proximity; --tw-ring-offset-width: 0px; --tw-ring-offset-color: #fff; --tw-ring-color: rgba(59,130,246,.5); --tw-ring-offset-shadow: 0 0 #0000; --tw-ring-shadow: 0 0 #0000; --tw-shadow: 0 0 #0000; --tw-shadow-colored: 0 0 #0000; word-break: break-all !important;">8GB/256GB/20W</span></h1>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (32, N'MacBook Air M5 13 inch 2026 10CPU 8GPU 16GB 512GB Sạc 70W ', 37590000, 35590000, '2026-09-04 21:58:15.000', 10, 13, 1, N'laptop-hp-05.jpg', 1, N'MacBook Air M5 13 inch 2026 10CPU 8GPU 16GB 512GB Sạc 70W | Chính hãng Apple Việt Nam', N'MacBook Air M5 13 inch 2026 10CPU 8GPU 16GB 512GB Sạc 70W ');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (33, N'Laptop Acer Nitro ProPanel ANV15-41-R7CR ', 27490000, 27490000, '2026-09-05 15:58:27.573', 5, 15, 1, N'shopping.webp', 1, N'Laptop Acer Nitro ProPanel ANV15-41-R7CR (Ryzen 5 7535HS/ GeForce RTX™ 4050/ 16GB/ 512GB/ Win 11 Home SL)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;">Đặc điểm nổi bật</h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">CPU: AMD Ryzen&trade; 5 7535HS (3.3 GHz - 4.55 GHz/ 16MB/ 6 nh&acirc;n, 12 lu&ocirc;̀ng)<br style="box-sizing: border-box;" />VGA: GeForce RTX&trade; 4050 6GB GDDR6, 194 AI TOPs<br style="box-sizing: border-box;" />RAM: 1 x 16GB 4800MHz DDR5 (Hỗ trợ tối đa 96GB)<br style="box-sizing: border-box;" />Ổ cứng: 512GB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 15.6" Full HD (1920 x 1080) IPS, 180Hz, M&agrave;n h&igrave;nh kh&ocirc;ng cảm ứng, Acer ComfyView, 100% sRGB<br style="box-sizing: border-box;" />OS: Windows 11 Home SL</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (34, N'Laptop Acer Gaming Nitro ProPanel ANV15-52-50RB ', 31990000, 31990000, '2026-09-05 16:00:39.160', 2, 15, 1, N'Latitude 7420.jpg', 1, N'Laptop Acer Gaming Nitro ProPanel ANV15-52-50RB (Core 5 210H/ GeForce RTX™ 4050/ 16GB/ 512GB/ Windows 11 Home SL)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;"><strong>Đặc điểm nổi bật</strong></h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">CPU: Intel&reg; Core&trade; 5 210H (2.2 GHz - 4.8 GHz/ 12MB/ 8 nh&acirc;n, 12 luồng)<br style="box-sizing: border-box;" />VGA: GeForce RTX&trade; 4050 6GB GDDR6, 194 AI TOPs<br style="box-sizing: border-box;" />RAM: 1 x 16GB 5200MHz DDR5 (Hỗ trợ tối đa 96GB)<br style="box-sizing: border-box;" />Ổ cứng: 512GB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 15.6" Full HD (1920 x 1080) IPS, 180Hz, M&agrave;n h&igrave;nh kh&ocirc;ng cảm ứng, 100% sRGB<br style="box-sizing: border-box;" />OS: Windows 11 Home SL</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (35, N'Laptop Acer Predator Triton 14 AI PT14-52T-99TU', 93990000, 93990000, '2026-09-05 16:09:32.083', 2, 14, 1, N'XPS 15 7590.jpg', 1, N'Laptop Acer Predator Triton 14 AI PT14-52T-99TU (Ultra 9-288V/ GeForce RTX™ 5070/ 32GB/ 2TB/ Win 11 Home SL)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;">Đặc điểm nổi bật</h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">CPU: Intel&reg; Core&trade; Ultra 9-288V (3.3 GHz - 5.1 GHz/ 12MB/ 8 nh&acirc;n, 8 lu&ocirc;̀ng)<br style="box-sizing: border-box;" />NPU: Intel&reg; AI Boost 48 TOPS (Total up to 120 TOPs)<br style="box-sizing: border-box;" />VGA: GeForce RTX&trade; 5070 8GB GDDR7, 798 AI TOPs<br style="box-sizing: border-box;" />RAM: 32GB Onboard 8533MHz LPDDR5x (Kh&ocirc;ng n&acirc;ng cấp được)<br style="box-sizing: border-box;" />Ổ cứng: 2TB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 14.5" 2.8K (2880 x 1800) OLED, 120Hz, M&agrave;n h&igrave;nh cảm ứng, Acer CineCrystal, 100% DCI-P3<br style="box-sizing: border-box;" />OS: Windows 11 Home SL</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (36, N'Laptop Acer Predator Helios Neo - PHN16-I31-50H7', 49990000, 49990000, '2026-09-05 16:11:40.877', 4, 14, 1, N'Victus 15 RTX4050.jpg', 1, N'Laptop Acer Predator Helios Neo - PHN16-I31-50H7 (i5-14450HX/ GeForce RTX™ 5050/ 32GB/ 512GB/ Windows 11 Home SL)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;">Đặc điểm nổi bật</h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">CPU: Intel&reg; Core&trade; i5-14450HX (2.4 GHz - 4.8 GHz/ 20MB/ 10 nh&acirc;n, 16 luồng)<br style="box-sizing: border-box;" />VGA: GeForce RTX&trade; 5050 8GB GDDR7, 440 AI TOPs<br style="box-sizing: border-box;" />RAM: 2 x 16GB 5600MHz DDR5 (Hỗ trợ tối đa 96GB)<br style="box-sizing: border-box;" />Ổ cứng: 512GB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 16" WUXGA (1920 x 1200) IPS, 180Hz, M&agrave;n h&igrave;nh kh&ocirc;ng cảm ứng, Acer ComfyView, 100% sRGB<br style="box-sizing: border-box;" />OS: Windows 11 Home SL</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (37, N'Laptop Asus Zenbook 14 UX3405CA-ST1713W', 29990000, 29990000, '2026-09-05 16:34:09.420', 4, 12, 1, N'Laptop HP 14 em0023AU - D0BG7PA.webp', 1, N'Laptop Asus Zenbook 14 UX3405CA-ST1713W (Ultra 5-225H/ 16GB/ 512GB/ Windows 11 Home)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;">Đặc điểm nổi bật</h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">
<p style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px;">CPU: Intel&reg; Core&trade; Ultra 5-225H (1.7 GHz - 4.9 GHz/ 18MB/ 14 nh&acirc;n, 14 luồng)<br style="box-sizing: border-box;" />NPU: Intel&reg; AI Boost 13 TOPS<br style="box-sizing: border-box;" />RAM: 16GB Onboard 7467MHz LPDDR5x<br style="box-sizing: border-box;" />Ổ cứng: 512GB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 14" 2.8K (2880 x 1800) OLED, 120Hz, M&agrave;n h&igrave;nh kh&ocirc;ng cảm ứng, 500 nits, 100% DCI-P3<br style="box-sizing: border-box;" />OS: Win 11 Home</p>
</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (38, N'Laptop HP OmniBook X 14-fe1010QU - B53KBPA', 33890000, 31890000, '2026-09-05 16:53:55.000', 8, 5, 1, N'laptop-hp-victus-16-r0298tx-ae0n5pa.webp', 1, N'Laptop HP OmniBook X 14-fe1010QU - B53KBPA (Snapdragon X1P 42 100/ 16GB/ 512GB/ Win 11 Home SL + Office)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;">Đặc điểm nổi bật</h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">
<p style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px;">CPU: Snapdragon X1P 42 100 (3.2 GHz - 3.4 GHz/ 30MB/ 8 nh&acirc;n, 8 lu&ocirc;̀ng)<br style="box-sizing: border-box;" />NPU: Qualcomm&reg; Hexagon&trade; NPU up to 45TOPS<br style="box-sizing: border-box;" />RAM: 16GB Onboard 8448MHz LPDDR5 (tối đa 16GB)<br style="box-sizing: border-box;" />Ổ cứng: 512GB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 14" 2.2K IPS, M&agrave;n h&igrave;nh cảm ứng<br style="box-sizing: border-box;" />OS: Win 11 Home SL + Office 2021</p>
</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (39, N'DELL XPS 14 DA14260 (2026)', 79000000, 65000000, '2026-09-14 00:00:00.000', 2, 4, 1, N'20260914204711215_672f97.webp|20260914204711234_afec14.webp', 1, N'DELL XPS 14 DA14260 (2026) sang trọng, tối giản và cao cấp', N'<ul style="box-sizing: border-box; list-style: none; padding: 0px; margin: 0px; display: flex; flex-direction: column; gap: 8px; color: #0f1419; font-family: system-ui, -apple-system, ''Segoe UI'', Roboto, ''Helvetica Neue'', Arial, sans-serif; font-size: 13.5px;">
<li style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">CPU:</span>&nbsp;Intel Core Ultra X7 358H Up To 4.8GHz (16 Cores, 16 Threads, 18MB Cache - 50 TOPS NPU)</li>
<li style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">RAM:</span>&nbsp;LPDDR5X 32GB 9600MHz</li>
<li style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">SSD:</span>&nbsp;1TB PCIe Gen4 M.2 SSD</li>
<li style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">VGA:</span>&nbsp;Intel&reg; Arc&trade; graphics</li>
<li style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">DISPLAY:</span>&nbsp;14" IPS 2K (1920 x 1200), 1-120Hz, InfinityEdge non-touch display, Anti-Glare, 100% sRGB, Dolby Vision, 500-nits</li>
<li style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">CONDITION:</span>&nbsp;New 100% Full Box</li>
<li class="pdp-warranty-li" style="box-sizing: border-box; position: relative; padding-left: 0px;">&nbsp;<span style="box-sizing: border-box; font-weight: bold;">WARRANTY:</span>&nbsp;Bảo h&agrave;nh 12 th&aacute;ng</li>
</ul>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (40, N'Laptop ASUS TUF Gaming F16 FX607VJR-TU320W', 29290000, 28290000, '2026-09-05 17:01:38.000', 2, 12, 1, N'20260914203357191_fd3aa2.webp', 1, N'Laptop ASUS TUF Gaming F16 FX607VJR-TU320W - CORE 5-205H/16GB/512GB PCIE/VGA 6GB RTX3050/16.0 WUXGA', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;"><a class="table-content__item level-2" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; margin-top: 5px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#laptop-asus-tuf-gaming-f16-fx607vjr-tu320w-laptop-gaming-ben-bi" data-v-1bddbad4="">1. Laptop ASUS TUF Gaming F16 FX607VJR-TU320W - Laptop gaming bền bỉ</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#cong-nghe-ai-va-tinh-nang-thong-minh" data-v-1bddbad4="">1.1. C&ocirc;ng nghệ AI v&agrave; t&iacute;nh năng th&ocirc;ng minh</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#suc-manh-phan-cung-cung-tan-nhiet" data-v-1bddbad4="">1.2. Sức mạnh phần cứng c&ugrave;ng tản nhiệt</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#kha-nang-da-nhiem-va-luu-tru" data-v-1bddbad4="">1.3. Khả năng đa nhiệm v&agrave; lưu trữ</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#phong-cach-thiet-ke-chuan-tuf" data-v-1bddbad4="">1.4. Phong c&aacute;ch thiết kế chuẩn TUF</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#man-hinh-sac-net-va-muot-ma" data-v-1bddbad4="">1.5. M&agrave;n h&igrave;nh sắc n&eacute;t v&agrave; mượt m&agrave;</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#thoi-luong-pin-ben-bi-va-da-dang-cong-ket-noi" data-v-1bddbad4="">1.6. Thời lượng pin bền bỉ v&agrave; đa dạng cổng kết nối</a><a class="table-content__item level-2" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; display: block; font-size: 14px; margin-top: 5px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-asus-tuf-gaming-f16-fx607vjr-tu320w.html?region_id=12869030&amp;gad_source=1&amp;gad_campaignid=22438452411&amp;gbraid=0AAAAADi3SZmwj9sYkSZEnwffRlgrlRTrm&amp;gclid=CjwKCAjwtp7VBhBjEiwAJfpV-w32EpC_INfkySYV4prEu9_MYVjP7mSS3j5PBJS-4zgnmNRBsC6JZhoC028QAvD_BwE#ai-nen-mua-laptop-asus-tuf-gaming-f16-fx607vjr-tu320w-su-dung" data-v-1bddbad4="">2. Ai n&ecirc;n mua Laptop ASUS TUF Gaming F16 FX607VJR-TU320W sử dụng?</a></h2>
</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (41, N'Laptop Gigabyte Gaming A16 3THK3VN893SH', 38990000, 38990000, '2026-09-05 17:04:52.277', 12, 16, 1, N'shopping.webp', 1, N'Laptop Gigabyte Gaming A16 3THK3VN893SH (Ryzen 7 260/ GeForce RTX™ 5050/ 16GB/ 512GB/ Windows 11 Home SL)', N'<div class="css-4qwh8s" style="box-sizing: border-box; margin: 0px 0px 0.5rem; padding: 0px; border: 0px; display: flex; -webkit-box-align: center; align-items: center; -webkit-box-pack: justify; justify-content: space-between; color: #333333; font-family: Roboto, sans-serif; font-size: 14px;">
<h2 class="css-284mj3" style="box-sizing: border-box; margin: 0px; font-weight: 500; line-height: 24px; font-size: 18px; color: #1b1d29; padding: 0px; border: 0px;">Đặc điểm nổi bật</h2>
<div class="button-text css-19cqi99" style="box-sizing: border-box; margin: 0px; padding: 0px; border-image: initial; opacity: 1; color: #1990ff; text-decoration: unset; font-size: 13px; line-height: 20px; overflow: hidden; display: inline; -webkit-box-orient: vertical; -webkit-line-clamp: unset; max-width: unset; min-width: unset; transition: color 0.3s; border: 1px none unset;">Xem th&ocirc;ng tin chi tiết</div>
</div>
<div class="css-7i51" style="box-sizing: border-box; margin: 0px; padding: 0px; border: 0px; font-size: 13px; line-height: 20px; overflow: hidden; color: #434657; font-family: Roboto, sans-serif;">CPU: AMD Ryzen&trade; 7 260 (3.8 GHz - 5.1 GHz/ 16MB/ 8 nh&acirc;n, 16 luồng)<br style="box-sizing: border-box;" />VGA: GeForce RTX&trade; 5050 8GB GDDR7, 440 AI TOPs<br style="box-sizing: border-box;" />RAM: 1 x 16GB 5600MHz DDR5 (Hỗ trợ tối đa 64GB)<br style="box-sizing: border-box;" />Ổ cứng: 512GB SSD M.2 NVMe<br style="box-sizing: border-box;" />M&agrave;n h&igrave;nh: 16" WUXGA (1920 x 1200) IPS, 165Hz, M&agrave;n h&igrave;nh kh&ocirc;ng cảm ứng,<br style="box-sizing: border-box;" />OS: Windows 11 Home SL</div>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (42, N'Laptop MSI Modern 15 F1MG-1264VN', 19990000, 19990000, '2026-09-14 22:35:55.000', 5, 17, 1, N'20260914223531819_883936.jpg', 1, N'Laptop MSI Modern 15 F1MG-1264VN (Core 5 120U, 16GB, 512GB, Full HD, Win11)', N'Laptop MSI Modern 15 F1MG-1264VN');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (43, N'Laptop GIGABYTE Gaming A16 GA6H', 37950000, 36990000, '2026-09-14 22:50:18.533', 20, 16, 1, N'20260914224933359_ed83c1.jpg|20260914224948458_a8b25a.jpg', 1, N'Laptop GIGABYTE Gaming A16 GA6H - GAMING-A16-CVHI3VN893SH (i7 13620H, 16GB, 512GB, RTX5060 8GB, WUXGA 165Hz, Win11)', N'<h2 class="boxrate__title" style="box-sizing: border-box; margin: 0px; padding: 0px; font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-size-adjust: none; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-variant-emoji: normal; font-stretch: normal; font-size: 16px; line-height: 32px; font-family: Arial, Helvetica, sans-serif; color: #333333; outline: 0px; background-color: #ffffff;">Đ&aacute;nh gi&aacute; Laptop GIGABYTE Gaming A16 GA6H - GAMING-A16-CVHI3VN893SH (i7 13620H, 16GB, 512GB, RTX5060 8GB, WUXGA 165Hz, Win11)</h2>');
INSERT INTO dbo.[Item] ([ID], [Name], [PurcharsePrice], [SellPrice], [DateImport], [Quantity], [TypeID], [BrandID], [Picture], [Active], [ShortTitle], [Describe]) VALUES (44, N'Laptop MSI Crosshair 16 HX AI D2XWGKG-034VN', 57990000, 57999000, '2026-09-14 23:07:55.827', 5, 17, 1, N'20260914230701925_1bf531.webp', 1, N'U7-255HX/16GB/1TB PCIE/VGA 8GB RTX5070/16.0 QHD+', N'<p><a class="table-content__item level-2" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; margin-top: 5px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#msi-crosshair-16-hx-ai-d2xwgkg-034vn-suc-manh-ai-but-pha-hieu-nang-dinh-cao" data-v-1bddbad4="">1. MSI Crosshair 16 HX AI D2XWGKG-034VN - Sức mạnh AI bứt ph&aacute;, hiệu năng đỉnh cao</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#suc-manh-xu-ly-ai-chuyen-dung-tu-npu-intel-ai-boost" data-v-1bddbad4="">1.1. Sức mạnh xử l&yacute; AI chuy&ecirc;n dụng từ NPU Intel AI Boost</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#hieu-nang-vuot-troi-voi-intel-core-ultra-7-va-gpu-rtx-5070" data-v-1bddbad4="">1.2. Hiệu năng vượt trội với Intel Core Ultra 7 v&agrave; GPU RTX 5070</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#da-nhiem-muot-ma-va-toc-do-truy-xuat-vuot-troi" data-v-1bddbad4="">1.3. Đa nhiệm mượt m&agrave; v&agrave; tốc độ truy xuất vượt trội</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#thiet-ke-an-tuong-voi-tong-mau-xam-va-vat-lieu-cao-cap" data-v-1bddbad4="">1.4. Thiết kế ấn tượng với t&ocirc;ng m&agrave;u x&aacute;m v&agrave; vật liệu cao cấp</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#man-hinh-16-inch-cung-tam-nen-ips-level-tan-so-quet-240hz" data-v-1bddbad4="">1.5. M&agrave;n h&igrave;nh 16 inch c&ugrave;ng tấm nền IPS-Level, tần số qu&eacute;t 240Hz</a><a class="table-content__item level-3" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; display: block; font-size: 14px; padding-left: 20px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#pin-dung-luong-lon-va-kha-nang-ket-noi-toan-dien" data-v-1bddbad4="">1.6. Pin dung lượng lớn v&agrave; khả năng kết nối to&agrave;n diện</a><a class="table-content__item level-2" style="box-sizing: inherit; color: #4a4a4a; cursor: pointer; text-decoration-line: none; display: block; font-size: 14px; margin-top: 5px; font-family: Inter, Roboto, sans-serif; text-align: justify;" href="https://cellphones.com.vn/laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn.html#mua-laptop-msi-crosshair-16-hx-ai-d2xwgkg-034vn-chinh-hang-tai-cellphones" data-v-1bddbad4="">2. Mua laptop MSI Crosshair 16 HX AI D2XWGKG-034VN ch&iacute;nh h&atilde;ng tại laptop.khannv.vn</a></p>');
GO
SET IDENTITY_INSERT dbo.[Item] OFF;
GO
-- ===== Order : 8 rows =====
SET IDENTITY_INSERT dbo.[Order] ON;
GO
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (11, '2023-05-03 17:38:15.510', NULL, '2023-05-03 17:39:27.367', 1, 350000, 3);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (17, '2026-09-05 17:08:43.627', 1, '2026-09-05 17:16:48.130', 1, 20990000, 6);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (18, '2026-09-05 17:10:18.243', 1, '2026-09-05 17:14:48.610', 1, 314890000, 7);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (19, '2026-09-05 17:47:30.483', 1, '2026-09-07 20:55:01.633', 1, 49990000, 5);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (20, '2026-09-14 22:11:30.323', 0, NULL, 0, 16590000, 8);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (21, '2026-09-14 22:19:30.413', 1, '2026-09-14 22:19:41.467', 1, 24990000, 9);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (22, '2026-09-14 22:22:10.873', 0, NULL, 0, 15290000, 10);
INSERT INTO dbo.[Order] ([ID], [Orderdate], [Deliverystatus], [Deliverydate], [Status], [Totalprice], [CustomerID]) VALUES (23, '2026-09-16 21:07:31.503', 1, '2026-09-16 21:09:14.123', 1, 49990000, 5);
GO
SET IDENTITY_INSERT dbo.[Order] OFF;
GO
-- ===== OrderDetail : 8 rows =====
SET IDENTITY_INSERT dbo.[OrderDetail] ON;
GO
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (5, 1, 15, 11, 350000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (10, 1, 27, 17, 20990000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (11, 1, 38, 18, 314890000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (14, 1, 36, 19, 49990000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (15, 1, 31, 20, 16590000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (16, 1, 19, 21, 24990000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (17, 1, 29, 22, 15290000);
INSERT INTO dbo.[OrderDetail] ([ID], [Quantity], [ItemId], [OrderID], [Totalprice]) VALUES (18, 1, 36, 23, 49990000);
GO
SET IDENTITY_INSERT dbo.[OrderDetail] OFF;
GO
-- ===== Payment : 6 rows =====
SET IDENTITY_INSERT dbo.[Payment] ON;
GO
INSERT INTO dbo.[Payment] ([ID], [Payprices], [OrderID]) VALUES (3, 350000, 11);
INSERT INTO dbo.[Payment] ([ID], [Payprices], [OrderID]) VALUES (4, 314890000, 18);
INSERT INTO dbo.[Payment] ([ID], [Payprices], [OrderID]) VALUES (5, 20990000, 17);
INSERT INTO dbo.[Payment] ([ID], [Payprices], [OrderID]) VALUES (9, 49990000, 19);
INSERT INTO dbo.[Payment] ([ID], [Payprices], [OrderID]) VALUES (10, 24990000, 21);
INSERT INTO dbo.[Payment] ([ID], [Payprices], [OrderID]) VALUES (11, 49990000, 23);
GO
SET IDENTITY_INSERT dbo.[Payment] OFF;
GO
-- Foreign keys
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
PRINT N'laptopstore restore complete.';
GO
