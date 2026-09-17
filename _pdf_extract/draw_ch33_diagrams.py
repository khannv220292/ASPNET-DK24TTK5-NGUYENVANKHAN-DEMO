# -*- coding: utf-8 -*-
"""Vẽ biểu đồ Use Case tổng + biểu đồ lớp UC01–UC15 cho mục 3.3."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

OUT = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án") / "hinh_ch33"
OUT.mkdir(parents=True, exist_ok=True)
PROJ = Path(r"D:\HỌC TẬP\ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO-restore\_pdf_extract\hinh_ch33")
PROJ.mkdir(parents=True, exist_ok=True)

FONT = r"C:\Windows\Fonts\arial.ttf"
NAVY = (15, 55, 95)
HEADER = (21, 67, 120)
LINE = (40, 40, 40)
FILL = (255, 255, 255)
WHITE = (255, 255, 255)
NOTE = (250, 248, 240)
ACCENT = (160, 70, 20)
OVAL = (232, 244, 252)
ADMIN_FILL = (255, 243, 224)


def fonts():
    return {
        "title": ImageFont.truetype(FONT, 32),
        "class": ImageFont.truetype(FONT, 24),
        "stereo": ImageFont.truetype(FONT, 16),
        "body": ImageFont.truetype(FONT, 18),
        "small": ImageFont.truetype(FONT, 16),
        "caption": ImageFont.truetype(FONT, 18),
        "uc": ImageFont.truetype(FONT, 15),
        "actor": ImageFont.truetype(FONT, 22),
    }


def stick(draw, cx, ay, name, f):
    draw.ellipse([cx - 26, ay, cx + 26, ay + 52], outline=LINE, width=2)
    draw.line([(cx, ay + 52), (cx, ay + 122)], fill=LINE, width=2)
    draw.line([(cx - 46, ay + 76), (cx + 46, ay + 76)], fill=LINE, width=2)
    draw.line([(cx, ay + 122), (cx - 36, ay + 178)], fill=LINE, width=2)
    draw.line([(cx, ay + 122), (cx + 36, ay + 178)], fill=LINE, width=2)
    tw = draw.textlength(name, font=f["actor"])
    draw.text((cx - tw / 2, ay + 186), name, font=f["actor"], fill=LINE)


def uml_box(draw, f, x, y, w, h, name, stereo, attrs, methods):
    hh = 64 if stereo else 44
    draw.rounded_rectangle([x, y, x + w, y + h], radius=4, outline=LINE, width=2, fill=FILL)
    draw.rectangle([x, y, x + w, y + hh], fill=HEADER, outline=LINE, width=2)
    cx = x + w / 2
    ty = y + 6
    if stereo:
        tw = draw.textlength(stereo, font=f["stereo"])
        draw.text((cx - tw / 2, ty), stereo, font=f["stereo"], fill=(200, 220, 240))
        ty += 22
    tw = draw.textlength(name, font=f["class"])
    draw.text((cx - tw / 2, ty), name, font=f["class"], fill=WHITE)
    ay = y + hh + 8
    for a in attrs:
        draw.text((x + 14, ay), a, font=f["body"], fill=LINE)
        ay += 24
    if methods:
        draw.line([(x, ay + 2), (x + w, ay + 2)], fill=LINE, width=1)
        ay += 10
        for m in methods:
            draw.text((x + 14, ay), m, font=f["body"], fill=LINE)
            ay += 24


def arrow(draw, x1, y1, x2, y2, label="", f=None):
    draw.line([(x1, y1), (x2, y2)], fill=LINE, width=2)
    # simple chevron
    if x2 >= x1:
        draw.polygon([(x2, y2), (x2 - 12, y2 - 6), (x2 - 12, y2 + 6)], fill=LINE)
    else:
        draw.polygon([(x2, y2), (x2 + 12, y2 - 6), (x2 + 12, y2 + 6)], fill=LINE)
    if label and f:
        mx = (x1 + x2) / 2
        my = min(y1, y2) - 22
        tw = draw.textlength(label, font=f["small"])
        draw.text((mx - tw / 2, my), label, font=f["small"], fill=ACCENT)


def save(img, name):
    p2 = PROJ / name
    img.save(p2, "PNG")
    p1 = OUT / name
    try:
        img.save(p1, "PNG")
    except OSError:
        alt = OUT / ("_" + name)
        img.save(alt, "PNG")
        print("locked, saved", alt.name)
        return
    print("saved", p1.name)


def draw_usecase():
    W, H = 2600, 1750
    img = Image.new("RGB", (W, H), "#FFFFFF")
    draw = ImageDraw.Draw(img)
    f = fonts()
    title = "Hình 2. Biểu đồ Use Case hệ thống website bán laptop"
    tw = draw.textlength(title, font=f["title"])
    draw.text(((W - tw) / 2, 24), title, font=f["title"], fill=NAVY)
    sub = "laptop.khannv.vn  |  hai tác nhân: Khách hàng và Quản trị viên  |  UC01–UC15"
    tw = draw.textlength(sub, font=f["caption"])
    draw.text(((W - tw) / 2, 72), sub, font=f["caption"], fill=(80, 80, 80))

    sys = [380, 130, 2220, 1620]
    draw.rounded_rectangle(sys, radius=8, outline=HEADER, width=3, fill=(248, 251, 255))
    sys_name = "Hệ thống website bán laptop (laptop.khannv.vn)"
    tw = draw.textlength(sys_name, font=f["class"])
    draw.text(((sys[0] + sys[2]) / 2 - tw / 2, 148), sys_name, font=f["class"], fill=HEADER)

    stick(draw, 160, 520, "Khách hàng", f)
    stick(draw, 2440, 520, "Quản trị viên", f)

    customer = [
        "UC01 Đăng ký tài khoản",
        "UC02 Đăng nhập",
        "UC03 Cập nhật hồ sơ / đổi MK",
        "UC04 Xem chi tiết laptop",
        "UC05 Trang chủ / danh sách SP",
        "UC06 Tìm kiếm Contains",
        "UC07 Theo dõi đơn hàng",
        "UC08 Hủy đơn (phía khách)",
        "UC09 Quản lý giỏ Session",
        "UC10 Đặt hàng COD/MoMo",
    ]
    admin = [
        "UC08 Cập nhật trạng thái đơn",
        "UC11 CRUD Items (laptop)",
        "UC12 Brand / ItemType / Menu",
        "UC13 Quản lý Customer",
        "UC14 Quản lý Order (Admin)",
        "UC15 Productnotsold (báo cáo)",
    ]

    def oval(x, y, w, h, text, fill):
        draw.ellipse([x, y, x + w, y + h], outline=LINE, width=2, fill=fill)
        tw = draw.textlength(text, font=f["uc"])
        draw.text((x + (w - tw) / 2, y + h / 2 - 10), text, font=f["uc"], fill=LINE)
        return x, y + h / 2, x + w, y + h / 2

    # left column customer
    cy = 210
    left_pts = []
    for t in customer:
        x, midy, xr, _ = oval(520, cy, 520, 92, t, OVAL)
        left_pts.append((x, midy))
        draw.line([(210, 700), (x, midy)], fill=LINE, width=1)
        cy += 132

    # right column admin
    cy = 280
    for t in admin:
        fill = ADMIN_FILL
        x, midy, xr, _ = oval(1480, cy, 560, 100, t, fill)
        draw.line([(xr, midy), (2360, 700)], fill=LINE, width=1)
        cy += 200

    note = (
        "Ghi chú: UC08 dùng chung hai tác nhân (khách hủy đơn khi còn điều kiện; admin xác nhận/cập nhật trạng thái). "
        "UC16–UC20 (MoMo, khách vãng lai, FeaturedBrand, Blog, dashboard) bổ sung ở mục 4.4."
    )
    draw.rounded_rectangle([80, 1660, 2520, 1725], outline=(180, 180, 180), fill=NOTE)
    draw.text((100, 1675), note, font=f["small"], fill=LINE)
    save(img, "Hinh02_UseCase.png")


SPECS = [
    dict(
        file="Hinh03_UC01_DangKy.png",
        caption="Hình 3. Biểu đồ lớp chức năng đăng ký tài khoản (UC01)",
        sub="LoginController.Register  |  bảng Customer",
        actor="Khách hàng",
        ctrl=("LoginController", "<<Controller>>", ["- db : ProTechTiveGearEntities"],
              ["+ Register() : ActionResult", "+ Register(POST) : ActionResult"]),
        view=("Register.cshtml", "<<View>>", ["+ Username, Password", "+ Name, Phone, Email, Address"],
              ["Hiển thị form đăng ký"]),
        ent=("Customer", "<<Entity>>", ["+ ID, Username, Passwords", "+ Name, Phone, Address, Email"],
             ["SaveChanges()"]),
        steps=["1. chọn Đăng ký", "2. POST form", "3. lưu Customer"],
    ),
    dict(
        file="Hinh04_UC02_DangNhap.png",
        caption="Hình 4. Biểu đồ lớp chức năng đăng nhập (UC02)",
        sub="LoginController.Login  |  Customer / Admin  |  Session",
        actor="Khách / Admin",
        ctrl=("LoginController", "<<Controller>>", ["- db : ProTechTiveGearEntities"],
              ["+ Login() : ActionResult", "+ VerifyPassword(...)"]),
        view=("Login.cshtml", "<<View>>", ["+ Username", "+ Password"], ["Form đăng nhập"]),
        ent=("Customer / Admin", "<<Entity>>", ["+ Username PK", "+ Passwords (hash)"],
             ["Session[\"usr\"] / Session[\"Account\"]"]),
        steps=["1. nhập TK/MK", "2. kiểm tra hash", "3. tạo Session"],
    ),
    dict(
        file="Hinh05_UC03_HoSo.png",
        caption="Hình 5. Biểu đồ lớp chức năng cập nhật hồ sơ / đổi mật khẩu (UC03)",
        sub="ShopController.Profile  |  LoginController.Changepassword",
        actor="Khách hàng",
        ctrl=("Login / Shop", "<<Controller>>", ["Session[\"usr\"]"],
              ["+ Profile()", "+ Changepassword()"]),
        view=("Profile / Change password", "<<View>>", ["Họ tên, SĐT, địa chỉ", "Mật khẩu cũ / mới"],
              ["Cập nhật form"]),
        ent=("Customer", "<<Entity>>", ["+ Name, Phone, Address", "+ Passwords"], ["Update + SaveChanges"]),
        steps=["1. mở hồ sơ", "2. sửa & lưu", "3. cập nhật SQL"],
    ),
    dict(
        file="Hinh06_UC04_ChiTiet.png",
        caption="Hình 6. Biểu đồ lớp chức năng xem chi tiết laptop (UC04)",
        sub="ShopController.Detail / DetailProduct  |  Item",
        actor="Khách hàng",
        ctrl=("ShopController", "<<Controller>>", ["- data : ProTechTiveGearEntities"],
              ["+ Detail(id)", "+ Relatedproducts(id)"]),
        view=("Detail.cshtml", "<<View>>", ["Ảnh, giá, mô tả", "Hãng / loại, nút giỏ"], ["Owl / related"]),
        ent=("Item", "<<Entity>>", ["+ ID, Name, SellPrice", "+ Picture, Describe, Quantity"],
             ["Include ItemType.Menu"]),
        steps=["1. chọn Xem chi tiết", "2. truy vấn theo ID", "3. render View"],
    ),
    dict(
        file="Hinh07_UC05_TrangChu.png",
        caption="Hình 7. Biểu đồ lớp chức năng trang chủ / danh sách sản phẩm (UC05)",
        sub="ShopController.Index  |  Item, Banner, Menu",
        actor="Khách hàng",
        ctrl=("ShopController", "<<Controller>>", ["Active == true"],
              ["+ Index(search, hang, sapxep)", "+ FeaturedBrand()"]),
        view=("_LayoutHomePage / Index", "<<View>>", ["Banner, menu hãng", "Khối nổi bật / mới"], ["Lọc, sắp xếp"]),
        ent=("Item / Banner / Menu", "<<Entity>>", ["Item.SellPrice, Picture", "Menu = hãng laptop"],
             ["LINQ Include"]),
        steps=["1. vào trang chủ", "2. tải catalog", "3. hiển thị danh sách"],
    ),
    dict(
        file="Hinh08_UC06_TimKiem.png",
        caption="Hình 8. Biểu đồ lớp chức năng tìm kiếm tương đối Contains (UC06)",
        sub="ShopController.Index(search)  |  LINQ Contains",
        actor="Khách hàng",
        ctrl=("ShopController", "<<Controller>>", ["search, hang, sapxep"],
              ["+ Index(string search)"]),
        view=("Ô tìm trên header", "<<View>>", ["Placeholder tên laptop", "GET form trang chủ"], ["Kết quả / rỗng"]),
        ent=("Item", "<<Entity>>", ["Name, ShortTitle, Describe", "ItemType.TypeName, Menu.Name"],
             ["Where Contains(key)"]),
        steps=["1. nhập từ khóa", "2. lọc Contains", "3. trả View / Detail"],
    ),
    dict(
        file="Hinh09_UC07_DonKhach.png",
        caption="Hình 9. Biểu đồ lớp chức năng theo dõi đơn hàng của khách (UC07)",
        sub="ShopController.ListOrderClient  |  Order, OrderDetail",
        actor="Khách hàng",
        ctrl=("ShopController", "<<Controller>>", ["Session[\"usr\"]"],
              ["+ ListOrderClient()", "+ ListOrderDetailClient()"]),
        view=("ListOrderClient.cshtml", "<<View>>", ["Mã đơn, ngày, tổng", "Trạng thái"], ["Chi tiết dòng"]),
        ent=("Order / OrderDetail", "<<Entity>>", ["CustomerID, Totalprice", "Status, Deliverystatus"],
             ["Where CustomerID"]),
        steps=["1. Đơn của tôi", "2. lọc theo Session", "3. hiển thị đơn"],
    ),
    dict(
        file="Hinh10_UC08_HuyDon.png",
        caption="Hình 10. Biểu đồ lớp chức năng hủy đơn hàng",
        sub="Shop.CancelOrder  |  Admin.Comfirm  |  bảng Order",
        actor="Khách / Admin",
        ctrl=("Shop / Admin", "<<Controller>>", ["Session vai trò"],
              ["+ CancelOrder(id)", "+ Comfirm(id)"]),
        view=("Đơn khách / AllListOrder", "<<View>>", ["Nút hủy (điều kiện)", "Cập nhật trạng thái"], ["Thông báo"]),
        ent=("Order", "<<Entity>>", ["+ Status, Deliverystatus", "+ Totalprice, CustomerID"],
             ["Update trạng thái"]),
        steps=["1. chọn hủy/xác nhận", "2. kiểm tra điều kiện", "3. cập nhật Order"],
    ),
    dict(
        file="Hinh11_UC09_GioHang.png",
        caption="Hình 11. Biểu đồ lớp chức năng quản lý giỏ hàng Session (UC09)",
        sub="CartController  |  Session[\"Cart\"]  |  Item.Quantity",
        actor="Khách hàng",
        ctrl=("CartController", "<<Controller>>", ["Session[\"Cart\"] : CartEntity"],
              ["+ AddtoCart()", "+ EditCart() / DeleteCart()"]),
        view=("Cart.cshtml", "<<View>>", ["Dòng SP, số lượng", "Tổng tiền, badge"], ["AJAX cập nhật"]),
        ent=("Item (đọc tồn)", "<<Entity>>", ["+ ID, SellPrice", "+ Quantity, Active"],
             ["Chặn hết hàng"]),
        steps=["1. Thêm vào giỏ", "2. ghi Session", "3. sửa/xóa dòng"],
    ),
    dict(
        file="Hinh12_UC10_DatHang.png",
        caption="Hình 12. Biểu đồ lớp chức năng đặt hàng (UC10)",
        sub="CartController.Order  |  COD / MoMo  |  transaction trừ kho",
        actor="Khách hàng",
        ctrl=("CartController", "<<Controller>>", ["Session giỏ + form Order"],
              ["+ Order(POST)", "+ PaymentMoMo()"]),
        view=("Order form", "<<View>>", ["Họ tên, SĐT, địa chỉ", "COD hoặc MoMo"], ["Xác nhận đơn"]),
        ent=("Order + OrderDetail", "<<Entity>>", ["Customer, Totalprice", "ItemId, Quantity"],
             ["BeginTransaction, trừ kho"]),
        steps=["1. Đặt hàng", "2. tạo Order/Detail", "3. commit SQL"],
    ),
    dict(
        file="Hinh13_UC11_CRUDItem.png",
        caption="Hình 13. Biểu đồ lớp chức năng quản lý laptop Items CRUD (UC11)",
        sub="ItemsController  |  bảng Item",
        actor="Quản trị viên",
        ctrl=("ItemsController", "<<Controller>>", ["Session Admin"],
              ["+ Create / Edit / Delete", "+ Active / Unactive"]),
        view=("Items/Index, Create, Edit", "<<View>>", ["Tên, giá, tồn, ảnh", "TypeID, BrandID"], ["Validate form"]),
        ent=("Item", "<<Entity>>", ["Name, SellPrice, Quantity", "Picture, TypeID, BrandID"],
             ["SaveChanges()"]),
        steps=["1. vào Items", "2. CRUD form", "3. lưu SQL"],
    ),
    dict(
        file="Hinh14_UC12_DanhMuc.png",
        caption="Hình 14. Biểu đồ lớp chức năng Brand / ItemType / Menu (UC12)",
        sub="BrandsController, ItemTypesController, MenusController",
        actor="Quản trị viên",
        ctrl=("Danh mục Controllers", "<<Controller>>", ["Session Admin"],
              ["+ Index/Create/Edit/Delete"]),
        view=("Views Brands / Types / Menus", "<<View>>", ["Tên hãng, loại", "Menu ngang trang chủ"], ["CRUD"]),
        ent=("Brand, ItemType, Menu", "<<Entity>>", ["Menu = hãng laptop", "ItemType gắn MenuID"],
             ["Ràng buộc Item"]),
        steps=["1. mở danh mục", "2. thêm/sửa/xóa", "3. cập nhật catalog"],
    ),
    dict(
        file="Hinh15_UC13_Customer.png",
        caption="Hình 15. Biểu đồ lớp chức năng quản lý khách hàng (UC13)",
        sub="CustomersController  |  bảng Customer",
        actor="Quản trị viên",
        ctrl=("CustomersController", "<<Controller>>", ["Session Admin"],
              ["+ Index / Details / Edit"]),
        view=("Customers/Index", "<<View>>", ["Username, Name, Phone", "Email, Address"], ["Danh sách khách"]),
        ent=("Customer", "<<Entity>>", ["+ ID PK", "+ Username, Passwords"], ["Quản lý tập trung"]),
        steps=["1. menu Khách hàng", "2. xem danh sách", "3. chi tiết/sửa"],
    ),
    dict(
        file="Hinh16_UC14_OrderAdmin.png",
        caption="Hình 16. Biểu đồ lớp chức năng quản lý đơn hàng Admin (UC14)",
        sub="AdminController.AllListOrder / OrderDetail / ConfirmPayment",
        actor="Quản trị viên",
        ctrl=("AdminController", "<<Controller>>", ["Session[\"Account\"]"],
              ["+ AllListOrder()", "+ OrderDetail() / Comfirm()"]),
        view=("AllListOrder.cshtml", "<<View>>", ["Tab all/pending/unpaid", "Tìm G{id}, SĐT"], ["Chi tiết đơn"]),
        ent=("Order / Payment", "<<Entity>>", ["Status, Totalprice", "Payment.Payprices"],
             ["Xác nhận thanh toán"]),
        steps=["1. danh sách đơn", "2. xem chi tiết", "3. xác nhận/xóa"],
    ),
    dict(
        file="Hinh17_UC15_Productnotsold.png",
        caption="Hình 17. Biểu đồ lớp chức năng Productnotsold (sản phẩm chưa bán)",
        sub="AdminController.Productnotsold  |  Item không có trong OrderDetail",
        actor="Quản trị viên",
        ctrl=("AdminController", "<<Controller>>", ["- db : ProTechTiveGearEntities"],
              ["+ Productnotsold() : ActionResult"]),
        view=("Productnotsold.cshtml", "<<View>>", ["Ảnh, tên, giá, tồn", "Hãng / loại, ngày nhập"],
              ["Bảng thống kê"]),
        ent=("Item", "<<Entity>>", ["!OrderDetails.Any()", "Quantity, SellPrice"],
             ["Báo cáo chưa bán"]),
        steps=["1. menu Productnotsold", "2. LINQ Item chưa bán", "3. render bảng"],
    ),
]


def draw_class(spec):
    W, H = 2400, 1180
    img = Image.new("RGB", (W, H), "#FFFFFF")
    draw = ImageDraw.Draw(img)
    f = fonts()
    tw = draw.textlength(spec["caption"], font=f["title"])
    draw.text(((W - tw) / 2, 22), spec["caption"], font=f["title"], fill=NAVY)
    draw.line([(80, 72), (W - 80, 72)], fill=HEADER, width=3)
    tw = draw.textlength(spec["sub"], font=f["caption"])
    draw.text(((W - tw) / 2, 84), spec["sub"], font=f["caption"], fill=(80, 80, 80))

    stick(draw, 160, 220, spec["actor"], f)
    uml_box(draw, f, 380, 180, 540, 320, *spec["ctrl"])
    uml_box(draw, f, 1040, 180, 560, 320, *spec["view"])
    uml_box(draw, f, 1720, 180, 560, 320, *spec["ent"])

    arrow(draw, 250, 300, 380, 300, spec["steps"][0], f)
    arrow(draw, 920, 300, 1040, 300, spec["steps"][1], f)
    arrow(draw, 1600, 300, 1720, 300, spec["steps"][2], f)

    draw.rounded_rectangle([80, 620, 2320, 1080], outline=(180, 180, 180), fill=NOTE)
    draw.text((110, 640), "Luồng chính (rút gọn)", font=f["class"], fill=NAVY)
    lines = [
        "Tác nhân kích hoạt chức năng trên giao diện website.",
        "Controller nhận request, kiểm tra Session (nếu cần) và truy vấn Entity Framework 6 (EDMX → SQL Server catalog laptopstore).",
        "View Razor hiển thị kết quả; lỗi form được báo tại chỗ, không chuyển trang.",
        "Hệ thống: ASP.NET MVC 5, laptop.khannv.vn — ánh xạ đúng mã nguồn Shop / Cart / Login / Admin / Items.",
    ]
    y = 700
    for i, line in enumerate(lines, 1):
        draw.text((110, y), f"{i}. {line}", font=f["body"], fill=LINE)
        y += 50
    draw.text((110, 980), "Ghi chú: đây là biểu đồ lớp cộng tác (actor – controller – view – entity), cùng kiểu Hình 3–17 trong báo cáo.",
              font=f["small"], fill=(90, 90, 90))
    save(img, spec["file"])


def main():
    for spec in SPECS:
        if spec["file"].startswith("Hinh17"):
            continue
        draw_class(spec)
    print("done", OUT)


if __name__ == "__main__":
    main()
