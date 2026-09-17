# -*- coding: utf-8 -*-
from pathlib import Path
from docx import Document

docx = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
doc = Document(str(docx))

repls = [
    (
        "Giao diện màu sắc hài hòa – Đạt (Bootstrap, logo laptop.khannv.vn).",
        "Giao diện màu sắc hài hòa — hiện thực bằng Bootstrap và logo laptop.khannv.vn trên layout khách/admin.",
    ),
    (
        "Thực đơn phù hợp bài toán – Đạt (menu bán hàng + admin).",
        "Thực đơn phù hợp bài toán — menu bán hàng (hãng, tìm kiếm, giỏ) và sidebar quản trị (_LayoutAdmin).",
    ),
    (
        "Lưu trữ hoàn chỉnh – Đạt (SQL webgaming, EF6).",
        "Lưu trữ hoàn chỉnh — SQL Server catalog webgaming, ánh xạ Entity Framework 6 (Gear.edmx).",
    ),
    (
        "Thêm/xóa/cập nhật ổn định – Đạt (CRUD Items và danh mục).",
        "Thêm/xóa/cập nhật — ItemsController (Create/Edit/Delete/Active) và CRUD Brand/ItemType/Menu/Customer.",
    ),
    (
        "Tương tác CSDL, ràng buộc – Đạt (FK logic, kiểu số).",
        "Tương tác CSDL, ràng buộc — Item gắn TypeID/BrandID; Order–OrderDetail–Customer; trừ kho khi đặt hàng.",
    ),
    (
        "Tra cứu tiện lợi – Đạt (loại, chi tiết, đơn).",
        "Tra cứu tiện lợi — chi tiết sản phẩm, lọc theo hãng/loại, ListOrderClient và AllListOrder.",
    ),
    (
        "Tìm kiếm tương đối – Đạt (Contains).",
        "Tìm kiếm tương đối — LINQ Contains trên Name, ShortTitle, Describe, loại và hãng (SQL LIKE).",
    ),
    (
        "Báo cáo/thống kê – Đạt (Productnotsold, danh sách đơn).",
        "Báo cáo/thống kê — AdminController.Productnotsold và AllListOrder (tab pending/unpaid, dashboard 12 tháng).",
    ),
    (
        "Mục tiêu: website bán laptop hoàn chỉnh trên ASP.NET MVC 5 + SQL Server → Đạt: chạy ổn định trên IIS Express cổng 51494, thương hiệu laptop.khannv.vn.",
        "Mục tiêu: website bán laptop trên ASP.NET MVC 5 + SQL Server — kết quả triển khai: chạy trên IIS Express cổng 51494, thương hiệu laptop.khannv.vn.",
    ),
    (
        "Mục tiêu: giao diện thân thiện, tìm/xem/mua laptop → Đạt: layout Bootstrap khách/admin; trang chủ, chi tiết, tìm kiếm, giỏ, đặt hàng.",
        "Mục tiêu: giao diện thân thiện, tìm/xem/mua laptop — kết quả triển khai: layout Bootstrap khách/admin; trang chủ, chi tiết, tìm kiếm, giỏ, đặt hàng.",
    ),
    (
        "Mục tiêu: giỏ Session, đặt hàng, tìm kiếm Contains, quản lý đơn → Đạt: CartController + Session[\"Cart\"]; AuraStoreController.Index dùng Contains; ListOrderClient/AllListOrder.",
        "Mục tiêu: giỏ Session, đặt hàng, tìm kiếm Contains, quản lý đơn — kết quả triển khai: CartController + Session[\"Cart\"]; ShopController.Index dùng Contains; ListOrderClient/AllListOrder.",
    ),
    (
        "Mục tiêu: CRUD quản trị Items/Brand/ItemType/Menu/Customer/Order + Productnotsold → Đạt: các Controller scaffolding/admin tương ứng; thống kê sản phẩm chưa bán.",
        "Mục tiêu: CRUD quản trị và Productnotsold — kết quả triển khai: Items/Menus/ItemTypes/Customers/AdminController; thống kê sản phẩm chưa bán.",
    ),
    (
        "Mục tiêu: trình bày lý thuyết, Use Case, CSDL, kiểm thử và công bố GitHub → Đạt: Chương 2–4 và repository GitHub đã nêu.",
        "Mục tiêu: trình bày lý thuyết, Use Case, CSDL, kiểm thử và công bố GitHub — nội dung nằm ở Chương 2–4 và repository GitHub đã nêu.",
    ),
    (
        "Đối chiếu nhanh với phiếu đánh giá học phần: giao diện hài hòa; thực đơn phù hợp; lưu trữ SQL đầy đủ; CRUD ổn định; tra cứu/tìm kiếm tương đối; báo cáo/thống kê Productnotsold – các tiêu chí chính đều đạt ở mức đồ án học phần (chi tiết đã trình bày tại mục 4.3.3).",
        "Đối chiếu với phiếu đánh giá học phần (mục 4.3.3) chỉ nêu minh chứng kỹ thuật tương ứng từng tiêu chí; kết luận Đạt / Không đạt do giảng viên ghi trên phiếu, không phải tự đánh giá trong báo cáo.",
    ),
]

intro = (
    "Bảng dưới đây đối chiếu tiêu chí trên phiếu với cách hiện thực trong mã nguồn và CSDL. "
    "Đây là phần minh chứng để giáo viên kiểm tra khi demo; kết luận Đạt hay Không đạt thuộc phiếu đánh giá của giảng viên."
)

n = 0
for p in doc.paragraphs:
    t = p.text or ""
    if t.strip() == "Bảng 5. Đối chiếu tiêu chí phiếu đánh giá":
        # add note after this paragraph if next isn't already the intro
        pass
    for a, b in repls:
        if a in t:
            if p.runs:
                # replace across runs by rewriting first run
                leftover = t.replace(a, b)
                for r in p.runs:
                    r.text = ""
                p.runs[0].text = leftover
            else:
                p.add_run(b)
            n += 1
            break

# Insert intro after "4.3.3" heading or after Bảng 5 title
for i, p in enumerate(doc.paragraphs):
    if (p.text or "").strip() == "Bảng 5. Đối chiếu tiêu chí phiếu đánh giá":
        nxt = doc.paragraphs[i + 1].text if i + 1 < len(doc.paragraphs) else ""
        if "minh chứng" not in nxt and "giảng viên" not in nxt:
            from docx.oxml import OxmlElement
            from docx.text.paragraph import Paragraph
            new_p = OxmlElement("w:p")
            p._p.addnext(new_p)
            np = Paragraph(new_p, p._parent)
            np.add_run(intro)
        break

try:
    doc.save(str(docx))
    print("saved", n)
except PermissionError:
    alt = docx.with_name("BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
    print("LOCKED")
    raise
