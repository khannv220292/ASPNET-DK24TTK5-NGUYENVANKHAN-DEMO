# -*- coding: utf-8 -*-
"""Hình 17 — sơ đồ xử lý Productnotsold theo mô hình MVC (UML)."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

OUTS = [
    Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án") / "hinh_ch33" / "Hinh17_UC15_Productnotsold.png",
    Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án") / "Hinh17_BieuDoLop_Productnotsold.png",
    Path(r"D:\HỌC TẬP\ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO-restore\_pdf_extract") / "Hinh17_BieuDoLop_Productnotsold.png",
    Path(r"D:\HỌC TẬP\ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO-restore\_pdf_extract\hinh_ch33") / "Hinh17_UC15_Productnotsold.png",
]

FONT = r"C:\Windows\Fonts\arial.ttf"
FONTB = r"C:\Windows\Fonts\arialbd.ttf"

W, H = 2800, 1880
img = Image.new("RGB", (W, H), "#FFFFFF")
d = ImageDraw.Draw(img)

f_title = ImageFont.truetype(FONTB, 36)
f_h = ImageFont.truetype(FONTB, 26)
f_stereo = ImageFont.truetype(FONT, 18)
f_body = ImageFont.truetype(FONT, 22)
f_code = ImageFont.truetype(r"C:\Windows\Fonts\consola.ttf", 20)
f_small = ImageFont.truetype(FONT, 20)
f_actor = ImageFont.truetype(FONTB, 24)
f_lbl = ImageFont.truetype(FONT, 20)
f_cap = ImageFont.truetype(FONTB, 30)

# palette
CTRL = (37, 99, 168)
CTRL_H = (30, 80, 140)
VIEW = (46, 140, 90)
VIEW_H = (36, 115, 72)
CTX = (124, 92, 191)
CTX_H = (98, 70, 158)
ENT = (37, 99, 168)
LINE = (45, 55, 72)
WHITE = (255, 255, 255)
INK = (30, 41, 59)
CODEBG = (236, 253, 255)
CODEBD = (56, 178, 172)
NOTEBG = (240, 253, 244)
NOTEBD = (74, 167, 110)
CARD = (255, 255, 255)


def rrect(xy, fill, outline, w=2, rad=14):
    d.rounded_rectangle(xy, radius=rad, fill=fill, outline=outline, width=w)


def uml(x, y, w, h, stereo, name, lines, head, head_h=None):
    head_h = head_h or (58 if stereo else 48)
    rrect([x, y, x + w, y + h], CARD, LINE, 2, 12)
    d.rectangle([x, y, x + w, y + head_h], fill=head)
    # clip header corners by redrawing outline
    d.rounded_rectangle([x, y, x + w, y + h], radius=12, outline=LINE, width=2)
    d.line([(x, y + head_h), (x + w, y + head_h)], fill=LINE, width=2)
    cx = x + w / 2
    ty = y + 6
    if stereo:
        tw = d.textlength(stereo, font=f_stereo)
        d.text((cx - tw / 2, ty), stereo, font=f_stereo, fill=(220, 230, 245))
        ty += 22
    tw = d.textlength(name, font=f_h)
    d.text((cx - tw / 2, ty), name, font=f_h, fill=WHITE)
    ay = y + head_h + 14
    split = False
    for line in lines:
        if line == "--":
            d.line([(x + 8, ay), (x + w - 8, ay)], fill=(203, 213, 225), width=1)
            ay += 10
            split = True
            continue
        d.text((x + 18, ay), line, font=f_body, fill=INK)
        ay += 30


def stick(cx, ay, label):
    d.ellipse([cx - 28, ay, cx + 28, ay + 56], outline=LINE, width=3)
    d.line([(cx, ay + 56), (cx, ay + 128)], fill=LINE, width=3)
    d.line([(cx - 48, ay + 82), (cx + 48, ay + 82)], fill=LINE, width=3)
    d.line([(cx, ay + 128), (cx - 38, ay + 188)], fill=LINE, width=3)
    d.line([(cx, ay + 128), (cx + 38, ay + 188)], fill=LINE, width=3)
    tw = d.textlength(label, font=f_actor)
    d.text((cx - tw / 2, ay + 198), label, font=f_actor, fill=INK)


def arrow(x1, y1, x2, y2):
    d.line([(x1, y1), (x2, y2)], fill=LINE, width=2)
    # head
    if abs(x2 - x1) >= abs(y2 - y1):
        if x2 > x1:
            d.polygon([(x2, y2), (x2 - 14, y2 - 7), (x2 - 14, y2 + 7)], fill=LINE)
        else:
            d.polygon([(x2, y2), (x2 + 14, y2 - 7), (x2 + 14, y2 + 7)], fill=LINE)
    else:
        if y2 > y1:
            d.polygon([(x2, y2), (x2 - 7, y2 - 14), (x2 + 7, y2 - 14)], fill=LINE)
        else:
            d.polygon([(x2, y2), (x2 - 7, y2 + 14), (x2 + 7, y2 + 14)], fill=LINE)


def label(text, x, y, fill=(71, 85, 105)):
    d.text((x, y), text, font=f_lbl, fill=fill)


# ---- layout ----
# Actor
stick(150, 70, "Admin")
label("Chọn \"Productnotsold\"", 250, 130)
label("trên menu quản trị", 250, 158)

# Controller
uml(
    560, 50, 720, 280,
    "<<Controller>>", "AdminController",
    [
        "+ Productnotsold() : ActionResult",
        "+ AllListOrder() : ActionResult",
        "+ OrderDetail() : ActionResult",
        "+ Index() : ActionResult",
        "...",
    ],
    CTRL,
)

# View
uml(
    1680, 50, 980, 280,
    "<<View / Razor>>", "Productnotsold.cshtml",
    [
        "+ Layout = _LayoutAdmin",
        "+ Model : IEnumerable<Item>",
        "--",
        "Hiển thị danh sách sản phẩm chưa bán",
        "(ảnh, tên, giá, tồn, hãng, loại)",
    ],
    VIEW,
)

arrow(1280, 150, 1680, 150)
label("return View(model)", 1348, 108)

# DbContext
uml(
    560, 470, 720, 300,
    "<<DbContext>>", "ProTechTiveGearEntities",
    [
        "+ DbSet<Item> Items",
        "+ DbSet<OrderDetail> OrderDetails",
        "+ DbSet<Order> Orders",
        "+ DbSet<Customer> Customers",
        "...",
    ],
    CTX,
)

arrow(920, 330, 920, 470)
label("Sử dụng DbContext (EF6)", 948, 392)

# dashed query path: Controller → khối LINQ (không đè chữ lên class)
d.line([(1280, 220), (1488, 220)], fill=LINE, width=2)
# dashed vertical
y = 220
while y < 500:
    d.line([(1488, y), (1488, min(y + 10, 500))], fill=LINE, width=2)
    y += 18
d.polygon([(1488, 500), (1481, 486), (1495, 486)], fill=LINE)
label("Truy vấn dữ liệu (LINQ)", 1290, 360)

# LINQ box
lx, ly, lw, lh = 1500, 500, 1160, 360
rrect([lx, ly, lx + lw, ly + lh], CODEBG, CODEBD, 3, 14)
tw = d.textlength("Logic truy vấn LINQ / EF6", font=f_h)
d.text((lx + 28, ly + 16), "Logic truy vấn LINQ / EF6", font=f_h, fill=(17, 94, 89))
code = [
    "var soldIds = db.OrderDetails",
    "    .Select(od => od.ItemId)",
    "    .Distinct();",
    "",
    "var notSold = db.Items",
    "    .Where(i => !soldIds.Contains(i.ID))",
    "    .ToList();",
    "",
    "return View(notSold);",
]
cy = ly + 58
for line in code:
    d.text((lx + 36, cy), line, font=f_code, fill=(15, 23, 42))
    cy += 32

# Entities
ey = 920
uml(
    80, ey, 560, 380,
    "<<Entity>>", "Item",
    [
        "+ ID : long",
        "+ Name : string",
        "+ ShortTitle : string",
        "+ SellPrice : decimal",
        "+ Quantity : int",
        "+ BrandID : long?",
        "+ TypeID : long?",
        "+ Picture : string",
        "...",
    ],
    ENT,
)
uml(
    760, ey, 520, 380,
    "<<Entity>>", "OrderDetail",
    [
        "+ ID : long",
        "+ OrderID : long",
        "+ ItemId : long",
        "+ Quantity : int",
        "+ Totalprice : decimal",
        "...",
    ],
    ENT,
)
uml(
    1400, ey, 520, 380,
    "<<Entity>>", "Order",
    [
        "+ ID : long",
        "+ Orderdate : DateTime",
        "+ CustomerID : long",
        "+ Status : bool?",
        "+ Totalprice : decimal",
        "...",
    ],
    ENT,
)

# DbSet arrows
arrow(700, 770, 360, ey)
label("DbSet<Item>", 430, 800)
arrow(920, 770, 1020, ey)
label("DbSet<OrderDetail>", 930, 790)
arrow(1140, 770, 1660, ey)
label("DbSet<Order>", 1240, 800)

# associations Item 1-N OrderDetail N-1 Order
d.line([(640, ey + 180), (760, ey + 180)], fill=LINE, width=2)
d.text((650, ey + 140), "1", font=f_h, fill=INK)
d.text((730, ey + 140), "N", font=f_h, fill=INK)
d.text((660, ey + 196), "chứa", font=f_small, fill=(71, 85, 105))

d.line([(1280, ey + 180), (1400, ey + 180)], fill=LINE, width=2)
d.text((1290, ey + 140), "N", font=f_h, fill=INK)
d.text((1370, ey + 140), "1", font=f_h, fill=INK)
d.text((1288, ey + 196), "thuộc về", font=f_small, fill=(71, 85, 105))

# meaning box
mx, my, mw, mh = 2000, ey, 720, 380
rrect([mx, my, mx + mw, my + mh], NOTEBG, NOTEBD, 3, 14)
# dashed overlay
for i in range(0, mw, 16):
    pass
d.text((mx + 24, my + 16), "Ý nghĩa", font=f_h, fill=(22, 101, 52))
bullets = [
    "• Lấy các Item không có trong",
    "  bảng OrderDetail (chưa bán).",
    "• LINQ → EF6 chuyển thành SQL",
    "  (NOT IN / NOT EXISTS).",
    "• Kết quả hiển thị trên View",
    "  Productnotsold.cshtml.",
    "• Phục vụ tiêu chí báo cáo /",
    "  thống kê của đồ án.",
]
by = my + 64
for b in bullets:
    d.text((mx + 24, by), b, font=f_body, fill=INK)
    by += 36

# caption
cap = "Hình 18. Sơ đồ xử lý chức năng Productnotsold theo mô hình MVC"
tw = d.textlength(cap, font=f_cap)
d.text(((W - tw) / 2, 1788), cap, font=f_cap, fill=(30, 58, 95))

for p in OUTS:
    p.parent.mkdir(parents=True, exist_ok=True)
    img.save(p, "PNG")
    print("saved", p)
