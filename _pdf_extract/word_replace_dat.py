# -*- coding: utf-8 -*-
import win32com.client as win32

pairs = [
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
        "Thêm/xóa/cập nhật — ItemsController (Create/Edit/Delete) và CRUD Brand/ItemType/Menu/Customer.",
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
        "Báo cáo/thống kê — AdminController.Productnotsold và AllListOrder (tab pending/unpaid).",
    ),
    (" – Đạt (", " — hiện thực ("),
    (" – Đạt:", " — kết quả triển khai:"),
    (" → Đạt:", " — kết quả triển khai:"),
    ("→ Đạt:", "— kết quả triển khai:"),
    (
        "các tiêu chí chính đều đạt ở mức đồ án học phần (chi tiết đã trình bày tại mục 4.3.3).",
        "minh chứng kỹ thuật đã trình bày tại mục 4.3.3; kết luận Đạt/Không đạt do giảng viên ghi trên phiếu.",
    ),
]


def replace_all(doc, old, new):
    find = doc.Content.Find
    find.ClearFormatting()
    find.Replacement.ClearFormatting()
    find.Text = old
    find.Replacement.Text = new
    find.Forward = True
    find.Wrap = 1  # wdFindContinue
    find.MatchCase = False
    find.MatchWholeWord = False
    find.MatchWildcards = False
    # wdReplaceAll = 2
    return find.Execute(
        FindText=old,
        MatchCase=False,
        MatchWholeWord=False,
        MatchWildcards=False,
        MatchSoundsLike=False,
        MatchAllWordForms=False,
        Forward=True,
        Wrap=1,
        Format=False,
        ReplaceWith=new,
        Replace=2,
    )


word = win32.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = 0
path = r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx"
try:
    doc = word.ActiveDocument
    print("using active", doc.FullName)
except Exception:
    doc = word.Documents.Open(path, ReadOnly=False)
    print("opened", doc.FullName)
count = 0
for old, new in pairs:
    try:
        ok = replace_all(doc, old, new)
        if ok:
            count += 1
            print("ok", old[:40])
        else:
            print("miss", old[:50])
    except Exception as e:
        print("err", old[:30], e)

# extra: any remaining 'Đạt ('
replace_all(doc, "– Đạt", "— minh chứng")
replace_all(doc, "- Đạt", "— minh chứng")
doc.Save()
print("saved replacements_tried", count)
