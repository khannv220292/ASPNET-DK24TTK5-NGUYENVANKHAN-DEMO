# -*- coding: utf-8 -*-
from pathlib import Path
from copy import deepcopy
from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.shared import Cm, Pt
from docx.text.paragraph import Paragraph

FOLDER = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án")
SRC = FOLDER / "BaoCao_laptop.khannv.vn.docx"
IMG = FOLDER / "hinh_ch33"
OUT = FOLDER / "BaoCao_laptop.khannv.vn.docx"

NSMAP_R = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"


def set_run_font(run, size=13, bold=False):
    run.bold = bold
    run.font.name = "Times New Roman"
    run.font.size = Pt(size)
    r = run._element
    rPr = r.get_or_add_rPr()
    rFonts = rPr.find("{%s}rFonts" % NSMAP_R)
    if rFonts is None:
        rFonts = OxmlElement("w:rFonts")
        rPr.append(rFonts)
    rFonts.set("{%s}ascii" % NSMAP_R.replace("wordprocessingml/2006/main", "wordprocessingml/2006/main"), "Times New Roman")
    rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}ascii", "Times New Roman")
    rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}hAnsi", "Times New Roman")
    rFonts.set("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}eastAsia", "Times New Roman")


def insert_before(paragraph, img_path, caption):
    pic_elm = OxmlElement("w:p")
    cap_elm = OxmlElement("w:p")
    paragraph._p.addprevious(pic_elm)
    paragraph._p.addprevious(cap_elm)
    pic_p = Paragraph(pic_elm, paragraph._parent)
    cap_p = Paragraph(cap_elm, paragraph._parent)
    pic_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    pic_p.add_run().add_picture(str(img_path), width=Cm(15.8))
    cap_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = cap_p.add_run(caption)
    set_run_font(run, 13, True)
    return pic_p, cap_p


def insert_picture_only_before(paragraph, img_path):
    pic_elm = OxmlElement("w:p")
    paragraph._p.addprevious(pic_elm)
    pic_p = Paragraph(pic_elm, paragraph._parent)
    pic_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    pic_p.add_run().add_picture(str(img_path), width=Cm(15.8))


def insert_after(paragraph, img_path, caption):
    pic_elm = OxmlElement("w:p")
    cap_elm = OxmlElement("w:p")
    paragraph._p.addnext(cap_elm)
    paragraph._p.addnext(pic_elm)
    pic_p = Paragraph(pic_elm, paragraph._parent)
    cap_p = Paragraph(cap_elm, paragraph._parent)
    pic_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    pic_p.add_run().add_picture(str(img_path), width=Cm(15.8))
    cap_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = cap_p.add_run(caption)
    set_run_font(run, 13, True)


def already_has_drawing(paragraph):
    xml = paragraph._p.xml
    return "w:drawing" in xml or "w:pict" in xml


def main():
    doc = Document(str(SRC))
    paras = doc.paragraphs

    # 1) Hình 2 after UC list (before 3.3.2)
    for p in paras:
        if (p.text or "").strip().startswith("3.3.2."):
            prev_el = p._p.getprevious()
            if prev_el is not None and "Hình 2." in "".join(prev_el.itertext() if False else []):
                print("hinh2 caption already before 3.3.2")
                break
            # check previous paragraph text via xml
            skip = False
            if prev_el is not None:
                xml = prev_el.xml
                if "Hình 2." in xml or "Hinh 2." in xml:
                    skip = True
            if skip:
                print("skip hinh2")
                break
            insert_before(p, IMG / "Hinh02_UseCase.png", "Hình 2. Biểu đồ Use Case hệ thống website bán laptop")
            print("inserted hinh2")
            break

    # Refresh paragraphs after insert
    paras = doc.paragraphs

    jobs = [
        ("3.3.2.", "Hinh03_UC01_DangKy.png", "Hình 3. Biểu đồ lớp chức năng đăng ký tài khoản (UC01)"),
        ("3.3.3.", "Hinh04_UC02_DangNhap.png", "Hình 4. Biểu đồ lớp chức năng đăng nhập (UC02)"),
        ("3.3.4.", "Hinh05_UC03_HoSo.png", "Hình 5. Biểu đồ lớp chức năng cập nhật hồ sơ / đổi mật khẩu (UC03)"),
        ("3.3.5.", "Hinh06_UC04_ChiTiet.png", "Hình 6. Biểu đồ lớp chức năng xem chi tiết laptop (UC04)"),
        ("3.3.6.", "Hinh07_UC05_TrangChu.png", "Hình 7. Biểu đồ lớp chức năng trang chủ / danh sách sản phẩm (UC05)"),
        ("3.3.7.", "Hinh08_UC06_TimKiem.png", "Hình 8. Biểu đồ lớp chức năng tìm kiếm tương đối Contains (UC06)"),
        ("3.3.8.", "Hinh09_UC07_DonKhach.png", "Hình 9. Biểu đồ lớp chức năng theo dõi đơn hàng của khách (UC07)"),
        ("3.3.9.", "Hinh10_UC08_HuyDon.png", "Hình 10. Biểu đồ lớp chức năng hủy đơn hàng"),
        ("3.3.10.", "Hinh11_UC09_GioHang.png", "Hình 11. Biểu đồ lớp chức năng quản lý giỏ hàng Session (UC09)"),
        ("3.3.11.", "Hinh12_UC10_DatHang.png", "Hình 12. Biểu đồ lớp chức năng đặt hàng (UC10)"),
        ("3.3.12.", "Hinh13_UC11_CRUDItem.png", "Hình 13. Biểu đồ lớp chức năng quản lý laptop Items CRUD (UC11)"),
        ("3.3.13.", "Hinh14_UC12_DanhMuc.png", "Hình 14. Biểu đồ lớp chức năng Brand / ItemType / Menu (UC12)"),
        ("3.3.14.", "Hinh15_UC13_Customer.png", "Hình 15. Biểu đồ lớp chức năng quản lý khách hàng (UC13)"),
        ("3.3.15.", "Hinh16_UC14_OrderAdmin.png", "Hình 16. Biểu đồ lớp chức năng quản lý đơn hàng Admin (UC14)"),
        ("3.3.16.", "Hinh17_UC15_Productnotsold.png", "Hình 17. Sơ đồ xử lý chức năng Productnotsold theo mô hình MVC"),
    ]

    texts = [(p, (p.text or "").strip()) for p in doc.paragraphs]

    for heading, fname, caption in jobs:
        start = None
        for i, (p, t) in enumerate(texts):
            if t.startswith(heading):
                start = i
                break
        if start is None:
            print("missing heading", heading)
            continue
        # find existing caption in this section
        end = len(texts)
        for j in range(start + 1, len(texts)):
            tj = texts[j][1]
            if tj.startswith("3.3.") or tj.startswith("3.4.") or tj.startswith("CHƯƠNG"):
                end = j
                break
        section = texts[start:end]
        cap_p = None
        for p, t in section:
            if t.startswith("Hình ") and any(ch.isdigit() for ch in t[:12]):
                cap_p = p
                break
        img_path = IMG / fname
        if cap_p is not None:
            prev_xml = cap_p._p.getprevious()
            if prev_xml is not None and ("w:drawing" in prev_xml.xml or "w:pict" in prev_xml.xml):
                print("already image", heading)
                continue
            insert_picture_only_before(cap_p, img_path)
            # refresh caption text
            for r in cap_p.runs:
                r.text = ""
            if cap_p.runs:
                cap_p.runs[0].text = caption
                set_run_font(cap_p.runs[0], 13, True)
            else:
                run = cap_p.add_run(caption)
                set_run_font(run, 13, True)
            cap_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            print("pic before caption", heading)
        else:
            # insert after last paragraph of section (ánh xạ)
            last = section[-1][0]
            insert_after(last, img_path, caption)
            print("pic after section", heading)
        texts = [(p, (p.text or "").strip()) for p in doc.paragraphs]

    try:
        doc.save(str(SRC))
        print("saved original", SRC)
    except PermissionError:
        doc.save(str(OUT))
        print("LOCKED, saved", OUT)


if __name__ == "__main__":
    main()
