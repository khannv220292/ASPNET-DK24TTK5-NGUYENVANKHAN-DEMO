# -*- coding: utf-8 -*-
import pyodbc

conn = pyodbc.connect(
    "Driver={ODBC Driver 17 for SQL Server};Server=localhost;Database=webgaming;Trusted_Connection=yes;"
)
cur = conn.cursor()

cur.execute("UPDATE ItemType SET TypeName = N'Elitebook' WHERE ID = 5")
cur.execute("UPDATE ItemType SET TypeName = N'OmniBook' WHERE ID = 6")

hps = [
    (5, "Elitebook 6 G11", 35900000, 42590000, 8, 5, 1, "U7-255H / 16GB / 512GB / 14 WUXGA",
     "<p><b>Laptop HP Elitebook 6 G11 - BQ9N4PT</b> (Nguồn: phongvu.vn/c/laptop-hp).</p><p>CPU Ultra 7-255H, Intel Graphics, RAM 16GB, SSD 512GB, 1.4kg, 14 inch WUXGA IPS. Windows 11.</p><p>Giá niêm yết 43.490.000đ, bán 42.590.000đ.</p>"),
    (6, "OmniBook 7 14", 29000000, 31590000, 10, 6, 1, "Ultra 7-255U / 16GB / 512GB / 14 WUXGA",
     "<p><b>HP OmniBook 7 14-fr0027TU - C1MN1PA</b>.</p><p>Ultra 7-255U, 16GB, 512GB, 1.41kg, 14 inch WUXGA IPS.</p>"),
]

# extra new ids
new_rows = [
    (17, "HP 14 em0023AU", 17990000, 20990000, 15, 6, 1, "R5 7520U / 16GB / 512GB / 14 FHD",
     "<p><b>Laptop HP 14 em0023AU - D0BG7PA</b>.</p><p>Ryzen 5 7520U, AMD Radeon, 16GB, 512GB, 1.4kg, 14 FHD IPS. Tiết kiệm 3.000.000đ.</p>"),
    (18, "ProBook 4 G11", 30000000, 34990000, 6, 5, 1, "Ultra 5-225U / 16GB / 512GB / 14 WUXGA",
     "<p><b>HP ProBook 4 G11 - BQ5B3PT</b>.</p><p>Ultra 5-225U, Intel Graphics, 16GB, 512GB, 1.4kg, 14 WUXGA IPS.</p>"),
    (19, "HP 14-hc0028TU", 21000000, 24990000, 12, 6, 1, "Ultra 5-225U / 16GB / 512GB / 14 FHD",
     "<p><b>HP 14-hc0028TU - D72BJPA</b> Win 11 Home SL.</p><p>U5-225U, 16GB, 512GB, 1.4kg, 14 FHD 60Hz. Tiết kiệm 4.000.000đ.</p>"),
    (20, "HP 14-ep1012TU", 20500000, 23490000, 9, 6, 1, "Core 5 120U / 16GB / 512GB / 14 FHD",
     "<p><b>HP 14-ep1012TU - D72CPPA</b>. Trả góp 0%.</p><p>Core 5 120U, 16GB, 512GB, 1.4kg, 14 FHD.</p>"),
    (21, "OmniBook 5 16", 23000000, 25990000, 7, 6, 1, "R5 8640HS / 16GB / 512GB / 16 WUXGA",
     "<p><b>HP OmniBook 5 16-ag1069AU - BZ7T1PA</b>.</p><p>Ryzen 5 8640HS, 16GB, 512GB, 1.8kg, 16 WUXGA IPS.</p>"),
    (22, "HP 250R G10", 18900000, 22490000, 11, 5, 1, "Core 5 120U / 16GB / 512GB / 15.6 FHD",
     "<p><b>HP 250R G10 - C3SH7AT</b>. Tiết kiệm 6.300.000đ.</p><p>Core 5 120U, 16GB, 512GB, 1.6kg, 15.6 FHD IPS.</p>"),
    (23, "Elitebook 640 G11", 30000000, 33990000, 5, 5, 1, "U7-165U / 16GB / 512GB / 14 FHD IPS",
     "<p><b>HP Elitebook 640 G11 - A7LB4PT</b> Win 11 Home SL.</p><p>Ultra 7-165U, 16GB, 512GB, 1.4kg, 14 FHD IPS.</p>"),
    (24, "Victus 15 RTX4050", 25000000, 28990000, 8, 6, 1, "i5-13420H / RTX 4050 / 16GB / 512GB",
     "<p><b>HP Victus 15 fa2732TX - B85LPPA</b> gaming.</p><p>i5-13420H, RTX 4050, 16GB, 512GB, 2.2kg, 15.6 FHD 144Hz. Trả góp 0%.</p>"),
    (25, "OmniBook X Flip", 28000000, 31390000, 6, 6, 1, "Ultra 5-226V / 16GB / 512GB / 14 WUXGA",
     "<p><b>HP OmniBook X Flip 14-fm0088TU - BZ7Q2PA</b>.</p><p>U5-226V, 16GB, 512GB, 1.3kg, 14 WUXGA IPS.</p>"),
    (26, "ProBook 4 G1i", 28000000, 32490000, 7, 5, 1, "Ultra 7-255U / 16GB / 512GB / 14 WUXGA",
     "<p><b>HP ProBook 4 G1i - BQ5C7PT</b>. Tiết kiệm 6.700.000đ.</p><p>Ultra 7-255U, 16GB, 512GB, 1.4kg, 14 WUXGA IPS 60Hz.</p>"),
]

pics = ["resizer.jpg", "resizer.png", "resizer (1).jpg", "AMD-Ryzen-5-4600G.jpg",
        "resizer.png", "GSPC-Aphrodite.png", "resizer.jpg", "resizer.png",
        "resizer (1).jpg", "AMD-Ryzen-5-4600G.jpg"]

for i, (id_, name, buy, sell, qty, tid, bid, short, desc) in enumerate(hps):
    pic = pics[i % len(pics)]
    cur.execute(
        """UPDATE Item SET Name=?, PurcharsePrice=?, SellPrice=?, Quantity=?, TypeID=?, BrandID=?,
           Active=1, ShortTitle=?, Describe=?, DateImport=GETDATE() WHERE ID=?""",
        name, buy, sell, qty, tid, bid, short, desc, id_,
    )

cur.execute("SET IDENTITY_INSERT Item ON")
for i, row in enumerate(new_rows):
    id_, name, buy, sell, qty, tid, bid, short, desc = row
    pic = pics[i % len(pics)]
    cur.execute("IF NOT EXISTS (SELECT 1 FROM Item WHERE ID=?) "
                "INSERT INTO Item (ID,Name,PurcharsePrice,SellPrice,DateImport,Quantity,TypeID,BrandID,Picture,Active,ShortTitle,Describe) "
                "VALUES (?,?,?,?,GETDATE(),?,?,?,?,1,?,?) "
                "ELSE UPDATE Item SET Name=?,PurcharsePrice=?,SellPrice=?,Quantity=?,TypeID=?,BrandID=?,Active=1,ShortTitle=?,Describe=?,DateImport=GETDATE() WHERE ID=?",
                id_, id_, name, buy, sell, qty, tid, bid, pic, short, desc,
                name, buy, sell, qty, tid, bid, short, desc, id_)
cur.execute("SET IDENTITY_INSERT Item OFF")
conn.commit()
cur.execute("SELECT ID, Name, SellPrice, TypeID FROM Item WHERE TypeID IN (5,6) ORDER BY ID")
for r in cur.fetchall():
    print(r)
conn.close()
print("OK")
