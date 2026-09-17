# -*- coding: utf-8 -*-
"""Chèn mục 4.4 đối chiếu chức năng theo mã nguồn + SQL vào báo cáo Word."""
from copy import deepcopy
from pathlib import Path

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.shared import Cm, Pt
from docx.text.paragraph import Paragraph

FOLDER = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án")
CANDIDATES = [
    FOLDER / "BaoCao_laptop.khannv.vn_TheoMauChinh.bak.docx",
    FOLDER / "BaoCao_laptop.khannv.vn_TheoMauChinh_Hinh17.docx",
    FOLDER / "BaoCao_laptop.khannv.vn_TheoMauChinh.docx",
]
OUT = FOLDER / "BaoCao_laptop.khannv.vn_TheoMauChinh.docx"
OUT_ALT = FOLDER / "BaoCao_laptop.khannv.vn_HoanThien_CapNhat.docx"
IMG17 = FOLDER / "Hinh17_BieuDoLop_Productnotsold.png"
MARKER = "4.4. Đối chiếu chức năng theo mã nguồn hoàn thiện"


def load_base():
    for p in CANDIDATES:
        if p.exists():
            try:
                return Document(str(p)), p
            except Exception:
                continue
    raise SystemExit("Không mở được file Word nguồn.")


def set_run_font(run, size=13):
    run.font.name = "Times New Roman"
    run.font.size = Pt(size)
    r = run._element
    rPr = r.get_or_add_rPr()
    rFonts = rPr.find("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}rFonts")
    if rFonts is None:
        rFonts = OxmlElement("w:rFonts")
        rPr.append(rFonts)
    rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}ascii", "Times New Roman")
    rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}hAnsi", "Times New Roman")
    rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}eastAsia", "Times New Roman")


def add_p(doc, text, style="Normal", bold=False, center=False, size=13):
    p = doc.add_paragraph()
    try:
        p.style = style
    except Exception:
        pass
    run = p.add_run(text)
    run.bold = bold
    set_run_font(run, 14 if style.startswith("Heading") else size)
    if center:
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_after = Pt(6)
    p.paragraph_format.line_spacing = 1.15
    return p


def add_table(doc, headers, rows):
    t = doc.add_table(rows=1 + len(rows), cols=len(headers))
    t.style = "Table Grid"
    for i, h in enumerate(headers):
        cell = t.rows[0].cells[i]
        cell.text = ""
        r = cell.paragraphs[0].add_run(h)
        r.bold = True
        set_run_font(r, 12)
    for ri, row in enumerate(rows):
        for ci, val in enumerate(row):
            cell = t.rows[ri + 1].cells[ci]
            cell.text = ""
            r = cell.paragraphs[0].add_run(val)
            set_run_font(r, 12)
    doc.add_paragraph()


def build_fragment():
    d = Document()
    add_p(
        d,
        "4.4. Đối chiếu chức năng theo mã nguồn hoàn thiện (laptop.khannv.vn)",
        "Heading 2",
        bold=True,
    )
    add_p(
        d,
        "Mục này được bổ sung sau khi website chạy ổn định trên IIS Express (http://localhost:51494), "
        "đối chiếu trực tiếp Controllers, Views, Gear.edmx và các script SQL (Database/database.sql, "
        "phan1_csdl_webgaming.sql, seed_laptop.sql). Một số mô tả ở mục 4.1–4.2 còn ghi AuraStoreController "
        "theo bản thiết kế ban đầu; phần dưới đây phản ánh đúng luồng đang vận hành.",
    )

    add_p(d, "4.4.1. Routing và Controller đang chạy", "Heading 3", bold=True)
    add_p(
        d,
        "RouteConfig đặt mặc định controller = Shop, action = Index. URL cũ /AuraStore/{action} vẫn nhận "
        "request nhờ IncomingOnlyRoute (chỉ khớp chiều vào, không sinh link outbound), nên Url.Action "
        "không còn tạo đường dẫn AuraStore. Layout khách là _LayoutHomePage.cshtml (thương hiệu "
        "laptop.khannv.vn, thanh tìm kiếm, menu hãng). Layout quản trị là _LayoutAdmin.cshtml (SB Admin).",
    )
    add_p(
        d,
        "Controller chính phía khách: ShopController (trang chủ, chi tiết, lọc hãng/loại, đơn của khách, "
        "hồ sơ, FeaturedBrand), CartController (giỏ Session, đặt hàng COD/MoMo), LoginController "
        "(đăng nhập khách/admin, đăng ký, quên/đổi mật khẩu). StoreController hỗ trợ catalog phụ "
        "(Index/Details). ShopCartController / ShopAdminController là bản song song theo theme Shop, "
        "luồng demo chính dùng Cart + Admin + Shop.",
    )

    add_p(d, "4.4.2. Chức năng phía khách hàng (đã hoàn thiện)", "Heading 3", bold=True)
    bullets = [
        "Trang chủ ShopController.Index(search, hang, sapxep): chỉ lấy Item.Active = true; tìm kiếm tương đối LINQ Contains trên Name, ShortTitle, Describe, ItemType.TypeName và Menu.Name; lọc theo hãng (Menu); sắp xếp (mặc định gia-asc). Nếu đúng một kết quả thì Redirect sang Detail.",
        "Khối hãng nổi bật FeaturedBrand (FeaturedSetting + Admin/FeaturedBrand): admin chọn Menu hoặc chế độ tự xoay; trang chủ hiển thị tối đa 10 laptop của hãng đó kèm sản phẩm mới (Newdproducts theo DateImport).",
        "Chi tiết: Detail / DetailProduct; sản phẩm liên quan Relatedproducts; banner Owl Carousel từ bảng Banner.",
        "Điều hướng danh mục: ProductbyMenu, ProductbyType, Brandtype, ItemMenuType — Menu đóng vai trò hãng (Lenovo, Dell, HP, ASUS, Acer, Apple, Gigabyte, MSI…) theo seed_laptop.sql.",
        "Giỏ hàng CartController: Session[\"Cart\"] (CartEntity), cookie CartCount; thêm/sửa/xóa/xóa hết; chặn hết hàng (Quantity <= 0); hỗ trợ AJAX. Cart.Count trả JSON số đơn chưa xử lý (Status != true) để đồng bộ badge.",
        "Thanh toán: không bắt buộc đăng nhập. Form Order lấy họ tên, SĐT, địa chỉ/tỉnh-huyện-xã, ghi chú, paymentMethod COD hoặc MoMo. Khách vãng lai được tạo Customer Username = guest_{SĐT}. Đơn COD lưu Order + OrderDetail trong transaction rồi trừ kho Item.Quantity bằng SQL UPDATE. MoMo: PaymentMoMo, ReturnUrl, ConfirmPaymentClient; ghi bảng Payment.",
        "Tài khoản: LoginController.VerifyPassword / HashPassword (Encryption); Session[\"usr\"] khách, Session[\"Account\"] admin; cookie usr/Name/avatar. Register, Forgotpassword, Changepassword; Shop/Profile; Shop/Signout xóa Session và cookie.",
        "Đơn của khách: ListOrderClient, ListOrderDetailClient, CancelOrder khi đủ điều kiện trạng thái.",
        "Nội dung khác: Contact; Blog / BlogDetail / RecentBlog (bảng Blog).",
    ]
    for b in bullets:
        add_p(d, "• " + b)

    add_p(d, "4.4.3. Chức năng phía quản trị (đã hoàn thiện)", "Heading 3", bold=True)
    admin_b = [
        "Đăng nhập AdminController.Login (hoặc LoginController nếu tài khoản thuộc bảng Admin) → AllListOrder. Mật khẩu băm; bản ghi plaintext demo được nâng cấp HashPassword khi đăng nhập thành công.",
        "Dashboard Admin/Index: biểu đồ tổng doanh thu 12 tháng từ Order.Totalprice (cần Session Admin).",
        "Đơn hàng AllListOrder: tab all / pending (Status != true) / unpaid (chưa có Payment); ô tìm G{id}, tên, SĐT, email khách. OrderDetail, Comfirm trạng thái, ConfirmPayment (ghi Payment), DeleteOrder (xóa Payment + OrderDetail + Order).",
        "CRUD laptop ItemsController: Index, Create, Edit, Delete, Itemunactive, UnactiveProduct, Active. Gắn TypeID, BrandID, Picture, ShortTitle, Describe; DateImport khi sửa.",
        "Danh mục: ItemTypesController, MenusController (hãng trên menu ngang), BrandsController (trong seed: Còn hàng / Thanh lý), BannersController, CustomersController, BlogsController.",
        "FeaturedBrand: chọn Menu hiển thị khối nổi bật trang chủ hoặc chế độ tự động.",
        "Báo cáo Productnotsold: danh sách Item phục vụ tiêu chí thống kê; View Views/Admin/Productnotsold.cshtml (layout admin, cột ảnh, giá, ngày nhập, tồn, hãng/loại).",
        "ImageController.UploadImage hỗ trợ tải ảnh sản phẩm.",
    ]
    for b in admin_b:
        add_p(d, "• " + b)

    add_p(d, "4.4.4. Cơ sở dữ liệu SQL Server (catalog webgaming)", "Heading 3", bold=True)
    add_p(
        d,
        "Database First (Gear.edmx, ProTechTiveGearEntities). Script tạo/bổ sung: Database/database.sql, "
        "phan1_csdl_webgaming.sql. Dữ liệu laptop: seed_laptop.sql (đổi tên Menu/ItemType/Item, giá VND, mô tả). "
        "Ảnh: fix_product_images.sql / fix_missing_images.sql. Connection Web.config name=ProTechTiveGearEntities, "
        "Initial Catalog=webgaming.",
    )
    add_table(
        d,
        ["Bảng SQL", "Vai trò nghiệp vụ trên website hoàn thiện"],
        [
            ["Admin", "Tài khoản quản trị (Username PK, Passwords đã hash, Name, Picture)."],
            ["Customer", "Khách đăng ký / khách vãng lai guest_{SĐT}; Name, Phone, Address, EmailAddress."],
            ["Menu", "Hãng trên thanh menu (Lenovo, Dell, HP, ASUS…); lọc hang trên trang chủ."],
            ["ItemType", "Dòng máy / loại (ThinkPad T, Latitude, Elitebook…) gắn MenuID."],
            ["Brand", "Nhãn phụ (seed: Còn hàng, Thanh lý) gắn Item.BrandID."],
            ["Item", "Laptop: Name, SellPrice, Quantity, Active, Picture, ShortTitle, Describe, TypeID, BrandID."],
            ["Order", "Đơn: Orderdate, Status, Deliverystatus, Totalprice, CustomerID."],
            ["OrderDetail", "Dòng đơn: ItemId, OrderID, Quantity, Totalprice."],
            ["Payment", "Thanh toán (Payprices, OrderID) — MoMo / xác nhận admin."],
            ["Banner", "Ảnh carousel trang chủ."],
            ["Blog", "Bài viết Blog/BlogDetail."],
            ["About, Contact, Feedback, ReplyFeedback, Footer, FooterDetail", "Nội dung tĩnh / phản hồi / chân trang (EDMX)."],
        ],
    )
    add_p(
        d,
        "Ràng buộc vận hành: OrderDetail gắn Item và Order; đặt hàng trừ tồn kho; Item.Active = false ẩn khỏi bán "
        "nhưng giữ lịch sử OrderDetail. Customer.Address khi checkout cắt tối đa 100 ký tự theo giới hạn cột.",
    )

    add_p(d, "4.4.5. Bảng ánh xạ chức năng – Controller – SQL (cập nhật)", "Heading 3", bold=True)
    add_p(d, "Bảng 4b. Ánh xạ chức năng website hoàn thiện – Controller – bảng SQL", bold=True, center=True)
    add_table(
        d,
        ["Chức năng trên laptop.khannv.vn", "Controller / Action", "Bảng SQL"],
        [
            ["Trang chủ, tìm, lọc hãng, sắp xếp", "ShopController.Index", "Item, ItemType, Menu, Brand, Banner"],
            ["Hãng nổi bật / sản phẩm mới", "ShopController.FeaturedBrand, Newdproducts; Admin.FeaturedBrand", "Item, Menu"],
            ["Chi tiết laptop, SP liên quan", "ShopController.Detail, DetailProduct, Relatedproducts", "Item"],
            ["Lọc theo menu/loại", "ProductbyMenu, ProductbyType, Brandtype", "Item, Menu, ItemType"],
            ["Đăng nhập / đăng ký / đổi MK", "LoginController", "Customer, Admin"],
            ["Giỏ hàng Session", "CartController (AddtoCart, Cart, EditCart, DeleteCart)", "Item (đọc tồn)"],
            ["Đặt hàng COD, khách vãng lai", "CartController.Order (POST)", "Customer, Order, OrderDetail, Item"],
            ["Thanh toán MoMo", "CartController.PaymentMoMo, ReturnUrl, ConfirmPaymentClient", "Order, OrderDetail, Payment"],
            ["Đơn của khách, hủy đơn, hồ sơ", "ShopController.ListOrderClient, CancelOrder, Profile", "Order, OrderDetail, Customer"],
            ["Blog / liên hệ", "ShopController.Blog, Contact; BlogsController", "Blog, Contact"],
            ["CRUD laptop", "ItemsController", "Item"],
            ["Hãng / loại / banner / khách", "Menus, ItemTypes, Banners, Customers, Brands", "Menu, ItemType, Banner, Customer, Brand"],
            ["Danh sách đơn, tab pending/unpaid", "AdminController.AllListOrder", "Order, Customer, Payment"],
            ["Chi tiết đơn, xác nhận TT, xóa đơn", "OrderDetail, ConfirmPayment, DeleteOrder, Comfirm", "Order, OrderDetail, Payment"],
            ["Báo cáo sản phẩm chưa bán", "AdminController.Productnotsold", "Item, Order, OrderDetail"],
            ["Dashboard doanh thu 12 tháng", "AdminController.Index", "Order"],
        ],
    )

    add_p(d, "4.4.6. Đoạn mã minh họa đúng code hiện tại", "Heading 3", bold=True)
    add_p(
        d,
        "Tìm kiếm trang chủ (ShopController.Index) — Contains trên nhiều trường, không chỉ Name:",
        bold=True,
    )
    add_p(
        d,
        "var q = data.Items.Include(\"ItemType.Menu\").Where(x => x.Active == true);\n"
        "if (!string.IsNullOrEmpty(search)) {\n"
        "  q = q.Where(nv => nv.Name.Contains(key) || nv.ShortTitle.Contains(key)\n"
        "    || nv.Describe.Contains(key) || nv.ItemType.TypeName.Contains(key)\n"
        "    || nv.ItemType.Menu.Name.Contains(key));\n"
        "}",
    )
    add_p(d, "Đặt hàng COD (CartController.Order) — transaction và trừ kho:", bold=True)
    add_p(
        d,
        "using (var tx = db.Database.BeginTransaction()) {\n"
        "  var or = new Order { CustomerID = cus.ID, Orderdate = DateTime.Now,\n"
        "    Status = false, Deliverystatus = false, Totalprice = (decimal)ToTalPrice() };\n"
        "  db.Orders.Add(or); db.SaveChanges();\n"
        "  foreach (var item in crt) {\n"
        "    db.OrderDetails.Add(new OrderDetail { OrderID = or.ID, ItemId = item.IdItem,\n"
        "      Quantity = item.Quantity, Totalprice = (decimal)(item.Prices * item.Quantity) });\n"
        "    db.Database.ExecuteSqlCommand(\n"
        "      \"UPDATE [Item] SET Quantity = CASE WHEN ISNULL(Quantity,0) >= {0} THEN Quantity - {0} ELSE 0 END WHERE ID = {1}\",\n"
        "      item.Quantity, item.IdItem);\n"
        "  }\n"
        "  db.SaveChanges(); tx.Commit();\n"
        "}",
    )
    add_p(
        d,
        "Đăng nhập dùng Encryption.VerifyPassword; mật khẩu mới HashPassword. Session khách: Session[\"usr\"]; "
        "admin: Session[\"Account\"]. Tài khoản demo admin vẫn dùng được sau khi hệ thống tự nâng cấp hash.",
    )

    add_p(d, "4.4.7. Use case bổ sung so với UC01–UC15", "Heading 3", bold=True)
    add_p(
        d,
        "UC16 – Thanh toán MoMo / ghi nhận Payment. UC17 – Đặt hàng khách vãng lai (không bắt buộc login). "
        "UC18 – Cấu hình hãng nổi bật (Admin.FeaturedBrand). UC19 – Quản lý Blog. UC20 – Dashboard thống kê "
        "doanh thu theo tháng (Admin.Index). Các UC này đã hiện thực trên mã nguồn hoàn thiện, bổ sung cho "
        "ma trận tác nhân ở mục 3.3.17.",
    )
    add_p(
        d,
        "Giao diện khách đã hoàn thiện: header xanh laptop.khannv.vn, hotline 0978.111.017, menu hãng, "
        "ô tìm “Nhập tên laptop cần tìm…”, khối sản phẩm nổi bật và sản phẩm mới (đúng màn hình localhost:51494). "
        "Giao diện admin: sidebar sản phẩm, loại, hãng, đơn (pending), FeaturedBrand, banner, khách hàng, Productnotsold.",
    )
    return d


def find_para(doc, pred):
    for p in doc.paragraphs:
        if pred(p.text or ""):
            return p
    return None


def insert_fragment_before(doc, marker_pred, fragment_doc):
    target = find_para(doc, marker_pred)
    if target is None:
        # append before last sectPr by adding at end
        body = doc.element.body
        for child in list(fragment_doc.element.body):
            if child.tag.endswith("sectPr"):
                continue
            body.append(deepcopy(child))
        return "appended-end"
    body = fragment_doc.element.body
    elems = [el for el in list(body) if not el.tag.endswith("sectPr")]
    for el in elems:
        target._p.addprevious(deepcopy(el))
    return "inserted-before"


def ensure_hinh17(doc):
    if not IMG17.exists():
        return
    cap = find_para(
        doc,
        lambda t: "Hình 17" in t and "Productnotsold" in t and "Sinh viên chèn" in t,
    )
    if cap is None:
        return
    prev = cap._p.getprevious()
    if prev is not None and "w:drawing" in prev.xml:
        for r in cap.runs:
            r.text = ""
        if cap.runs:
            cap.runs[0].text = "Hình 17. Biểu đồ lớp / màn hình Productnotsold (sản phẩm chưa bán)"
        return
    pic_elm = OxmlElement("w:p")
    cap._p.addprevious(pic_elm)
    pic_p = Paragraph(pic_elm, cap._parent)
    pic_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    pic_p.add_run().add_picture(str(IMG17), width=Cm(16.0))
    for r in cap.runs:
        r.text = ""
    if cap.runs:
        cap.runs[0].text = "Hình 17. Biểu đồ lớp / màn hình Productnotsold (sản phẩm chưa bán)"
    else:
        cap.add_run("Hình 17. Biểu đồ lớp / màn hình Productnotsold (sản phẩm chưa bán)")
    cap.alignment = WD_ALIGN_PARAGRAPH.CENTER


def already_has_44(doc):
    return any(MARKER in (p.text or "") for p in doc.paragraphs)


def main():
    doc, src = load_base()
    if already_has_44(doc):
        print("already has 4.4, skip insert from", src)
    else:
        frag = build_fragment()
        where = insert_fragment_before(
            doc,
            lambda t: t.strip().startswith("CHƯƠNG 5"),
            frag,
        )
        print("fragment", where, "base", src.name)
    ensure_hinh17(doc)
    try:
        doc.save(str(OUT))
        print("saved", OUT)
    except PermissionError:
        doc.save(str(OUT_ALT))
        print("locked original, saved", OUT_ALT)


if __name__ == "__main__":
    main()
