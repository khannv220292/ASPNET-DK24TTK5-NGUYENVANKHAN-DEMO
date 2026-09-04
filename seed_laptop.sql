USE webgaming;
GO
UPDATE Menu SET Name = N'Lenovo' WHERE ID = 1;
UPDATE Menu SET Name = N'Dell' WHERE ID = 2;
UPDATE Menu SET Name = N'HP' WHERE ID = 3;
UPDATE Menu SET Name = N'Phụ kiện' WHERE ID = 4;
GO
UPDATE ItemType SET TypeName = N'ThinkPad T', MenuID = 1 WHERE ID = 1;
UPDATE ItemType SET TypeName = N'ThinkPad X', MenuID = 1 WHERE ID = 2;
UPDATE ItemType SET TypeName = N'Latitude', MenuID = 2 WHERE ID = 3;
UPDATE ItemType SET TypeName = N'XPS / Precision', MenuID = 2 WHERE ID = 4;
UPDATE ItemType SET TypeName = N'Elitebook', MenuID = 3 WHERE ID = 5;
UPDATE ItemType SET TypeName = N'ZBook', MenuID = 3 WHERE ID = 6;
UPDATE ItemType SET TypeName = N'SSD / Adapter', MenuID = 4 WHERE ID = 7;
UPDATE ItemType SET TypeName = N'Bàn phím', MenuID = 4 WHERE ID = 8;
UPDATE ItemType SET TypeName = N'Chuột', MenuID = 4 WHERE ID = 9;
UPDATE ItemType SET TypeName = N'Đế tản nhiệt', MenuID = 4 WHERE ID = 10;
GO
UPDATE Brand SET Name = N'Còn hàng', MenuID = 1 WHERE ID = 1;
UPDATE Brand SET Name = N'Thanh lý', MenuID = 2 WHERE ID = 2;
GO
UPDATE Item SET
  Name = N'ThinkPad T14 Gen 2',
  TypeID = 1, BrandID = 1,
  SellPrice = 12990000, PurcharsePrice = 10500000, Quantity = 12, Active = 1,
  ShortTitle = N'i5-1145G7 / 16GB / 512GB / 14" FHD',
  Describe = N'<p><b>Laptop Lenovo ThinkPad T14 Gen 2</b> (nhập khẩu, phong cách laptopusa.com.vn).</p><p>CPU Intel Core i5-1145G7, RAM 16GB, SSD 512GB, màn 14 inch FHD, Windows 11.</p><p>Phù hợp văn phòng, doanh nhân. Bảo hành 3-6 tháng tại laptop.khannv.vn.</p>'
WHERE ID = 1;
UPDATE Item SET
  Name = N'ThinkPad X1 Carbon 9',
  TypeID = 2, BrandID = 1,
  SellPrice = 15990000, PurcharsePrice = 13200000, Quantity = 8, Active = 1,
  ShortTitle = N'i5-1135G7 / 8GB / 256GB / 14" siêu nhẹ',
  Describe = N'<p><b>Lenovo ThinkPad X1 Carbon Gen 9</b> siêu nhẹ, vỏ carbon.</p><p>i5-1135G7, 8GB, SSD 256GB, 14 inch. Máy xách tay USA.</p>'
WHERE ID = 2;
UPDATE Item SET
  Name = N'Latitude 7420',
  TypeID = 3, BrandID = 1,
  SellPrice = 11990000, PurcharsePrice = 9800000, Quantity = 15, Active = 1,
  ShortTitle = N'i7-1185G7 / 16GB / 512GB / 14" FHD',
  Describe = N'<p><b>Dell Latitude 7420</b> Core i7 thế hệ 11, 16GB RAM, SSD 512GB.</p><p>Laptop doanh nghiệp bền, bàn phím êm, webcam HD.</p>'
WHERE ID = 3;
UPDATE Item SET
  Name = N'XPS 15 7590',
  TypeID = 4, BrandID = 2,
  SellPrice = 18990000, PurcharsePrice = 15500000, Quantity = 5, Active = 1,
  ShortTitle = N'i7-9750H / 16GB / 512GB / RTX 1650',
  Describe = N'<p><b>Dell XPS 15 7590</b> màn 15.6 inch, card RTX, thanh lý tồn kho (Clear Stock).</p>'
WHERE ID = 4;
UPDATE Item SET
  Name = N'Elitebook 840 G10',
  TypeID = 5, BrandID = 1,
  SellPrice = 21990000, PurcharsePrice = 18500000, Quantity = 7, Active = 1,
  ShortTitle = N'i7-1360P / 16GB / 512GB / 14" FHD',
  Describe = N'<p><b>HP Elitebook 840 G10</b> Core i7 1360P, 16GB, SSD 512GB. Máy doanh nhân HP.</p>'
WHERE ID = 5;
UPDATE Item SET
  Name = N'ZBook Firefly 14',
  TypeID = 6, BrandID = 1,
  SellPrice = 13990000, PurcharsePrice = 11200000, Quantity = 6, Active = 1,
  ShortTitle = N'i7-10610U / 16GB / 512GB / 14"',
  Describe = N'<p><b>HP ZBook Firefly 14 G7</b> workstation mỏng nhẹ.</p>'
WHERE ID = 6;
UPDATE Item SET
  Name = N'Dell G3 3500',
  TypeID = 3, BrandID = 1,
  SellPrice = 14990000, PurcharsePrice = 12100000, Quantity = 9, Active = 1,
  ShortTitle = N'i7-10750H / 16GB / 512GB / GTX 1650',
  Describe = N'<p><b>Dell G3 3500 Gaming</b> i7-10750H, GTX 1650, 16GB, SSD 512GB.</p>'
WHERE ID = 7;
UPDATE Item SET
  Name = N'ThinkPad E14 Gen2',
  TypeID = 1, BrandID = 1,
  SellPrice = 10990000, PurcharsePrice = 8900000, Quantity = 20, Active = 1,
  ShortTitle = N'i7-1165G7 / 16GB / 512GB / 14.1"',
  Describe = N'<p><b>Lenovo ThinkPad E14 Gen 2</b> i7-1165G7, 16GB, 512GB. Giá tốt sinh viên.</p>'
WHERE ID = 14;
UPDATE Item SET
  Name = N'Latitude 5430',
  TypeID = 3, BrandID = 1,
  SellPrice = 13490000, PurcharsePrice = 11000000, Quantity = 11, Active = 1,
  ShortTitle = N'i7-1265U / 16GB / 512GB / 14" FHD',
  Describe = N'<p><b>Dell Latitude 5430</b> Core i7 Gen 12, 16GB, SSD 512GB.</p>'
WHERE ID = 15;
UPDATE Item SET
  Name = N'Legion Y740 15',
  TypeID = 1, BrandID = 2,
  SellPrice = 16990000, PurcharsePrice = 14000000, Quantity = 4, Active = 1,
  ShortTitle = N'i7-9750H / 16GB / 1TB / RTX 2060',
  Describe = N'<p><b>Lenovo Legion Y740</b> gaming, RTX 2060, thanh lý.</p>'
WHERE ID = 16;
GO
UPDATE Banner SET Picture = N'laptop-sieu-nhe-gigabyte-u4-khuyen-mai-soc-len-den-8-trieu-dong-vi1655466865.jpg' WHERE ID = 2;
GO
SELECT ID, Name, TypeID FROM Item;
SELECT ID, Name FROM Menu;
SELECT ID, TypeName, MenuID FROM ItemType;
GO
