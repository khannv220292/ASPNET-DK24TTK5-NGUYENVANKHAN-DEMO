# -*- coding: utf-8 -*-
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

out = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án") / "Hinh17_BieuDoLop_Productnotsold.png"

W, H = 2400, 1600
img = Image.new("RGB", (W, H), "#FFFFFF")
draw = ImageDraw.Draw(img)

font_path = r"C:\Windows\Fonts\arial.ttf"
f_title = ImageFont.truetype(font_path, 34)
f_class = ImageFont.truetype(font_path, 26)
f_stereo = ImageFont.truetype(font_path, 18)
f_body = ImageFont.truetype(font_path, 20)
f_small = ImageFont.truetype(font_path, 18)
f_caption = ImageFont.truetype(font_path, 20)

NAVY = (15, 55, 95)
HEADER_FILL = (21, 67, 120)
LINE = (40, 40, 40)
FILL = (255, 255, 255)
WHITE = (255, 255, 255)
NOTE = (250, 248, 240)
ACCENT = (160, 70, 20)


def uml_box(x, y, w, h, name, stereo, attrs, methods):
    hh = 70 if stereo else 48
    draw.rounded_rectangle([x, y, x + w, y + h], radius=4, outline=LINE, width=2, fill=FILL)
    draw.rectangle([x, y, x + w, y + hh], fill=HEADER_FILL, outline=LINE, width=2)
    draw.line([(x, y + hh), (x + w, y + hh)], fill=LINE, width=2)
    cx = x + w / 2
    ty = y + 8
    if stereo:
        tw = draw.textlength(stereo, font=f_stereo)
        draw.text((cx - tw / 2, ty), stereo, font=f_stereo, fill=(200, 220, 240))
        ty += 24
    tw = draw.textlength(name, font=f_class)
    draw.text((cx - tw / 2, ty), name, font=f_class, fill=WHITE)
    ay = y + hh + 10
    for a in attrs:
        draw.text((x + 16, ay), a, font=f_body, fill=LINE)
        ay += 28
    if methods:
        draw.line([(x, ay + 4), (x + w, ay + 4)], fill=LINE, width=1)
        ay += 14
        for m in methods:
            draw.text((x + 16, ay), m, font=f_body, fill=LINE)
            ay += 28


title = "Hinh 17. Bieu do lop chuc nang Productnotsold (san pham chua ban)"
title_vn = "Hình 17. Biểu đồ lớp chức năng Productnotsold (sản phẩm chưa bán)"
tw = draw.textlength(title_vn, font=f_title)
draw.text(((W - tw) / 2, 28), title_vn, font=f_title, fill=NAVY)
draw.line([(80, 80), (W - 80, 80)], fill=HEADER_FILL, width=3)

subtitle = "ASP.NET MVC 5  |  laptop.khannv.vn  |  UC15 – Báo cáo / thống kê"
tw = draw.textlength(subtitle, font=f_caption)
draw.text(((W - tw) / 2, 92), subtitle, font=f_caption, fill=(80, 80, 80))

# Actor stick figure
ax, ay, aw = 40, 180, 220
cx = ax + aw / 2
draw.ellipse([cx - 28, ay, cx + 28, ay + 56], outline=LINE, width=2)
draw.line([(cx, ay + 56), (cx, ay + 130)], fill=LINE, width=2)
draw.line([(cx - 50, ay + 80), (cx + 50, ay + 80)], fill=LINE, width=2)
draw.line([(cx, ay + 130), (cx - 40, ay + 190)], fill=LINE, width=2)
draw.line([(cx, ay + 130), (cx + 40, ay + 190)], fill=LINE, width=2)
an = "Admin"
tw = draw.textlength(an, font=f_class)
draw.text((cx - tw / 2, ay + 198), an, font=f_class, fill=LINE)

uml_box(
    480, 170, 520, 270, "AdminController", "<<Controller>>",
    ["- db : ProTechTiveGearEntities"],
    [
        "+ Productnotsold() : ActionResult",
        "+ AllListOrder(...) : ActionResult",
        "+ OrderDetail(id) : ActionResult",
    ],
)

uml_box(
    1180, 160, 580, 300, "Productnotsold.cshtml", "<<View / Razor>>",
    ["Layout = _LayoutAdmin", "Model : IEnumerable<Item>"],
    [
        "Bảng: Picture, Name, SellPrice,",
        "DateImport, Quantity, Brand, Type",
        "Liên kết: Edit | Details",
    ],
)

uml_box(
    480, 600, 480, 430, "Item", "<<Entity / Model>>",
    [
        "+ ID : long",
        "+ Name : string",
        "+ SellPrice : decimal",
        "+ DateImport : DateTime?",
        "+ Quantity : int?",
        "+ Picture : string",
        "+ BrandID : long?",
        "+ TypeID : long?",
        "+ Active : bool?",
    ],
    ["+ Brand : Brand", "+ ItemType : ItemType", "+ OrderDetails : ICollection"],
)

uml_box(
    1100, 660, 420, 280, "OrderDetail", "<<Entity / Model>>",
    [
        "+ ID : long",
        "+ ItemId : long?",
        "+ OrderID : long?",
        "+ Quantity : int",
        "+ Totalprice : decimal?",
    ],
    ["+ Item : Item", "+ Order : Order"],
)

uml_box(
    1640, 660, 380, 260, "Order", "<<Entity / Model>>",
    [
        "+ ID : long",
        "+ Orderdate : DateTime?",
        "+ Status : bool?",
        "+ CustomerID : long?",
        "+ Totalprice : decimal?",
    ],
    ["+ OrderDetails : ICollection"],
)

uml_box(
    80, 500, 340, 230, "ProTechTiveGearEntities", "<<DbContext / EF6>>",
    ["+ Items : DbSet<Item>", "+ OrderDetails : DbSet<OrderDetail>", "+ Orders : DbSet<Order>"],
    ["+ SaveChanges()"],
)

# Admin -> Controller
draw.line([(250, 280), (480, 260)], fill=LINE, width=2)
draw.polygon([(480, 260), (464, 252), (464, 272)], fill=LINE)
draw.text((255, 218), "chọn Productnotsold", font=f_small, fill=ACCENT)

# Controller -> View
draw.line([(1000, 290), (1180, 290)], fill=LINE, width=2)
draw.polygon([(1180, 290), (1164, 282), (1164, 298)], fill=LINE)
draw.text((1010, 258), "return View(notSold)", font=f_small, fill=ACCENT)

# Controller -> Item
draw.line([(740, 440), (740, 600)], fill=LINE, width=2)
draw.polygon([(740, 600), (732, 584), (748, 584)], fill=LINE)
draw.text((754, 510), "truy vấn Item chưa bán", font=f_small, fill=ACCENT)

# Controller -> DbContext
draw.line([(480, 310), (420, 500)], fill=LINE, width=2)
draw.polygon([(420, 500), (412, 484), (430, 488)], fill=LINE)

# Item 1 -- * OrderDetail
draw.line([(960, 810), (1100, 810)], fill=LINE, width=2)
draw.text((970, 780), "1", font=f_small, fill=LINE)
draw.text((1070, 780), "*", font=f_small, fill=LINE)
draw.text((980, 820), "OrderDetails", font=f_small, fill=ACCENT)

# OrderDetail * -- 1 Order
draw.line([(1520, 800), (1640, 800)], fill=LINE, width=2)
draw.text((1528, 770), "*", font=f_small, fill=LINE)
draw.text((1618, 770), "1", font=f_small, fill=LINE)

# View uses Item (dashed)
x1, y1, x2, y2 = 1460, 460, 740, 600
dx, dy = x2 - x1, y2 - y1
n = max(1, int(((dx * dx + dy * dy) ** 0.5) / 14))
for i in range(n):
    if i % 2 == 0:
        draw.line(
            [
                (x1 + dx * i / n, y1 + dy * i / n),
                (x1 + dx * (i + 0.55) / n, y1 + dy * (i + 0.55) / n),
            ],
            fill=(100, 100, 100),
            width=2,
        )
draw.text((1080, 520), "<<use>> Model", font=f_small, fill=ACCENT)

def wrap_text(text, font, max_w):
    words = text.split()
    lines, cur = [], ""
    for w in words:
        t = (cur + " " + w).strip()
        if draw.textlength(t, font=font) <= max_w:
            cur = t
        else:
            if cur:
                lines.append(cur)
            cur = w
    if cur:
        lines.append(cur)
    return lines


# Note
nx, ny, nw, nh = 80, 1080, 2240, 280
draw.rounded_rectangle([nx, ny, nx + nw, ny + nh], radius=6, outline=HEADER_FILL, width=2, fill=NOTE)
draw.text(
    (nx + 24, ny + 16),
    "Logic truy vấn LINQ / EF6 – laptop chưa phát sinh trong đơn hàng:",
    font=f_class,
    fill=NAVY,
)
code = [
    "var soldIds = db.OrderDetails.Select(od => od.ItemId).Distinct();",
    "var notSold = db.Items.Where(i => !soldIds.Contains(i.ID)).ToList();",
    "return View(notSold);",
]
yy = ny + 58
for line in code:
    draw.text((nx + 24, yy), line, font=f_body, fill=(20, 70, 40))
    yy += 34
meaning = (
    "Ý nghĩa: AdminController.Productnotsold lấy các Item không xuất hiện trong OrderDetail "
    "(chưa từng được bán), hiển thị trên Views/Admin/Productnotsold.cshtml để quản lý tồn "
    "và tiêu chí báo cáo/thống kê (phiếu đánh giá học phần)."
)
yy += 12
for line in wrap_text(meaning, f_caption, nw - 48):
    draw.text((nx + 24, yy), line, font=f_caption, fill=LINE)
    yy += 28

footer = (
    "Nguồn: ProTechTiveGear — AdminController.Productnotsold; "
    "Views/Admin/Productnotsold.cshtml; mô hình Item – OrderDetail – Order (EF6, catalog webgaming)"
)
tw = draw.textlength(footer, font=f_small)
draw.text(((W - tw) / 2, H - 36), footer, font=f_small, fill=(90, 90, 90))

img.save(out, "PNG", dpi=(200, 200))
print("saved", out.stat().st_size)
