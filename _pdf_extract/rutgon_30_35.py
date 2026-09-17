# -*- coding: utf-8 -*-
"""Rút gọn BaoCao về ~30–35 trang: bỏ khung UC lặp, thu nhỏ hình, siết khoảng cách."""
from pathlib import Path
import shutil

from docx import Document
from docx.enum.text import WD_LINE_SPACING
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, Twips
from PIL import Image

FOLDER = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án")
SRC = FOLDER / "BaoCao_laptop.khannv.vn.docx"
TMP = FOLDER / "_bao_gon.docx"
IMGDIR = FOLDER / "hinh_ch33"
PROJ = Path(r"D:\HỌC TẬP\ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO-restore\_pdf_extract\hinh_ch33")

DROP_EXACT = {
    "- Luồng sự kiện:",
    "+ Luồng cơ bản:",
    "Use case kết thúc.",
    "+ Luồng rẽ nhánh:",
    "- Luồng sự kiện",
    "+ Luồng cơ bản",
    "+ Luồng rẽ nhánh",
    "- Điểm mở rộng: Không có.",
    "- Điểm mở rộng: Không có",
    "- Các yêu cầu đặc biệt: Không.",
    "- Các yêu cầu đặc biệt: Không",
}

DROP_PREFIX = (
    "1. Nếu không kết nối được SQL Server",
    "Ghi chú: Sinh viên chèn hình ảnh đầy đủ khi hoàn thiện",
)


def crop_class_pngs():
    """Cắt bỏ khối 'Luồng chính' trùng ở nửa dưới Hình 3–16."""
    n = 0
    for folder in (IMGDIR, PROJ):
        if not folder.exists():
            continue
        for p in folder.glob("Hinh*.png"):
            name = p.name.upper()
            if name.startswith("HINH02") or name.startswith("HINH17"):
                continue
            im = Image.open(p)
            w, h = im.size
            if h < 800:
                continue
            cut = int(h * 0.52)  # giữ actor + 3 class
            im.crop((0, 0, w, cut)).save(p)
            n += 1
    # thu Hình 2 (use case cao)
    for folder in (IMGDIR, PROJ):
        p = folder / "Hinh02_UseCase.png"
        if p.exists():
            im = Image.open(p)
            w, h = im.size
            im.crop((0, 0, w, int(h * 0.92))).save(p)
    return n


def para_text(el):
    return "".join(el.itertext()).strip()


def drop_boilerplate(doc):
    drop = []
    for p in doc.paragraphs:
        t = (p.text or "").strip()
        if t in DROP_EXACT:
            drop.append(p._element)
            continue
        if any(t.startswith(x) for x in DROP_PREFIX):
            drop.append(p._element)
            continue
        # nhánh rẽ SQL lặp
        if t.startswith("2. Khi nhập thiếu") or t.startswith("2. Nếu sai thông tin"):
            # keep one validation line is useful - keep
            pass
    n = 0
    for el in drop:
        parent = el.getparent()
        if parent is not None:
            parent.remove(el)
            n += 1
    return n


def shrink_pictures(doc, max_width_cm=11.2):
    n = 0
    max_emu = int(Cm(max_width_cm))
    for shape in doc.inline_shapes:
        try:
            if shape.width > max_emu:
                ratio = max_emu / float(shape.width)
                shape.width = max_emu
                shape.height = int(shape.height * ratio)
                n += 1
        except Exception:
            pass
    return n


def tighten_spacing(doc):
    """Giữ Times 13; siết space after, line 1.15 (vẫn đọc được, giảm trang)."""
    n = 0
    for p in doc.paragraphs:
        t = (p.text or "").strip()
        pf = p.paragraph_format
        try:
            pf.space_after = Pt(4)
            pf.space_before = Pt(0)
            # không đụng heading quá
            style = (p.style.name or "") if p.style else ""
            if style.startswith("Heading"):
                pf.space_before = Pt(8)
                pf.space_after = Pt(6)
            else:
                pf.line_spacing = 1.15
            n += 1
        except Exception:
            pass
    return n


def replace_cropped_images(doc):
    """Gắn lại PNG đã crop vào đúng chú thích Hình 2–16 (thân bài, không danh mục)."""
    from docx.enum.text import WD_ALIGN_PARAGRAPH
    from docx.oxml import OxmlElement
    from docx.text.paragraph import Paragraph

    mapping = {
        "Hình 2. Biểu đồ Use Case": "Hinh02_UseCase.png",
        "Hình 3. Biểu đồ lớp chức năng đăng ký tài khoản": "Hinh03_UC01_DangKy.png",
        "Hình 4. Biểu đồ lớp chức năng đăng nhập (UC02)": "Hinh04_UC02_DangNhap.png",
        "Hình 5. Biểu đồ lớp chức năng cập nhật hồ sơ": "Hinh05_UC03_HoSo.png",
        "Hình 6. Biểu đồ lớp chức năng xem chi tiết laptop": "Hinh06_UC04_ChiTiet.png",
        "Hình 7. Biểu đồ lớp chức năng trang chủ": "Hinh07_UC05_TrangChu.png",
        "Hình 8. Biểu đồ lớp chức năng tìm kiếm tương đối": "Hinh08_UC06_TimKiem.png",
        "Hình 9. Biểu đồ lớp chức năng theo dõi đơn hàng của khách": "Hinh09_UC07_DonKhach.png",
        "Hình 10. Biểu đồ lớp chức năng hủy đơn hàng": "Hinh10_UC08_HuyDon.png",
        "Hình 11. Biểu đồ lớp chức năng quản lý giỏ hàng Session": "Hinh11_UC09_GioHang.png",
        "Hình 12. Biểu đồ lớp chức năng đặt hàng (UC10)": "Hinh12_UC10_DatHang.png",
        "Hình 13. Biểu đồ lớp chức năng quản lý laptop Items CRUD": "Hinh13_UC11_CRUDItem.png",
        "Hình 14. Biểu đồ lớp chức năng Brand": "Hinh14_UC12_DanhMuc.png",
        "Hình 15. Biểu đồ lớp chức năng quản lý khách hàng": "Hinh15_UC13_Customer.png",
        "Hình 16. Biểu đồ lớp chức năng quản lý đơn hàng Admin (UC14)": "Hinh16_UC14_OrderAdmin.png",
    }
    n = 0
    in_body = False
    for p in doc.paragraphs:
        t = (p.text or "").strip()
        if t.startswith("3.3. Thiết kế") or t.startswith("3.3.1."):
            in_body = True
        if not in_body:
            continue
        for prefix, fname in mapping.items():
            if t.startswith(prefix) or (prefix[:18] in t and t.startswith("Hình")):
                img = IMGDIR / fname
                if not img.exists():
                    img = PROJ / fname
                if not img.exists():
                    break
                prev = p._p.getprevious()
                if prev is not None and ("w:drawing" in prev.xml or "w:pict" in prev.xml):
                    parent = prev.getparent()
                    parent.remove(prev)
                pic_elm = OxmlElement("w:p")
                p._p.addprevious(pic_elm)
                pic_p = Paragraph(pic_elm, p._parent)
                pic_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
                pic_p.add_run().add_picture(str(img), width=Cm(11.2))
                n += 1
                break
    return n


def drop_duplicate_danh_muc_images(doc):
    """Nếu danh mục hình (trước 3.1) có ảnh nhầm thì xóa — báo cáo chính không có."""
    return 0


def main():
    nc = crop_class_pngs()
    print("cropped_pngs", nc)
    doc = Document(str(SRC))
    nd = drop_boilerplate(doc)
    print("dropped_paras", nd)
    nr = replace_cropped_images(doc)
    print("replaced_figs", nr)
    ns = shrink_pictures(doc, 11.2)
    print("shrunk", ns)
    nt = tighten_spacing(doc)
    print("spacing", nt)
    doc.save(str(TMP))
    try:
        shutil.copyfile(TMP, SRC)
        TMP.unlink(missing_ok=True)
        print("saved", SRC)
    except PermissionError:
        print("LOCKED, saved", TMP)


if __name__ == "__main__":
    main()
