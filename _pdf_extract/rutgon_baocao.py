# -*- coding: utf-8 -*-
"""Rút gọn báo cáo theo QUY_DINH_CHUNG_ASP.net.pdf: nội dung 30–50 trang."""
import shutil
from copy import deepcopy
from pathlib import Path

from docx import Document
from docx.enum.text import WD_LINE_SPACING
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, Emu

SRC = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
OUT = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
TMP = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\_bao_gon.docx")


def para_text(p):
    return "".join(p.itertext()).strip() if p is not None else ""


def is_p(el):
    return el.tag == qn("w:p")


def is_tbl(el):
    return el.tag == qn("w:tbl")


def walk_delete(body):
    """Xóa 4.4, phụ lục mở rộng, và đánh dấu."""
    children = list(body)
    mode = None  # None | drop44 | droppl
    remove = []
    for el in children:
        if el.tag == qn("w:sectPr"):
            continue
        t = para_text(el) if is_p(el) else ""
        if t.startswith("4.4. Đối chiếu chức năng theo mã nguồn"):
            mode = "drop44"
        if t.startswith("CHƯƠNG 5"):
            if mode == "drop44":
                mode = None
        if t.startswith("PHỤ LỤC BỔ SUNG") or t.startswith("PHỤ LỤC MỞ RỘNG"):
            mode = "droppl"
        if t.startswith("DANH MỤC TÀI LIỆU") and mode == "droppl":
            mode = None
        # không bao giờ xóa danh mục TL nếu đã thoát drop44
        if mode:
            remove.append(el)
    for el in remove:
        parent = el.getparent()
        if parent is not None:
            parent.remove(el)
    return len(remove)


RENAME = [
    ("CHƯƠNG 1: GIỚI THIỆU TỔNG QUAN", "CHƯƠNG 1. TỔNG QUAN"),
    ("CHƯƠNG 2: CƠ SỞ LÝ THUYẾT", "CHƯƠNG 2. NGHIÊN CỨU LÝ THUYẾT"),
    ("CHƯƠNG 3: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG", "CHƯƠNG 3. HIỆN THỰC HÓA NGHIÊN CỨU"),
    ("CHƯƠNG 4: CÀI ĐẶT VÀ TRIỂN KHAI", "3.4. Cài đặt và triển khai chương trình"),
    ("CHƯƠNG 5: KẾT QUẢ VÀ ĐÁNH GIÁ", "CHƯƠNG 4. KẾT QUẢ NGHIÊN CỨU"),
    ("KẾT LUẬN", "CHƯƠNG 5. KẾT LUẬN VÀ HƯỚNG PHÁT TRIỂN"),
]


def apply_renames(doc):
    for p in doc.paragraphs:
        t = p.text or ""
        for a, b in RENAME:
            if t.strip() == a or t.strip().startswith(a):
                if p.runs:
                    rest = t.replace(a, b, 1)
                    for r in p.runs:
                        r.text = ""
                    p.runs[0].text = rest
                break


def shrink_pictures(doc, max_width_cm=13.0):
    n = 0
    max_emu = int(Cm(max_width_cm))
    for shape in doc.inline_shapes:
        try:
            if shape.width > max_emu:
                ratio = max_emu / shape.width
                shape.width = max_emu
                shape.height = int(shape.height * ratio)
                n += 1
        except Exception:
            pass
    return n


def set_body_format(doc):
    for section in doc.sections:
        section.top_margin = Cm(2)
        section.bottom_margin = Cm(2)
        section.left_margin = Cm(3)
        section.right_margin = Cm(2)


def insert_quydinh_note(doc):
    """Chèn 1 đoạn vào tóm tắt nếu thiếu."""
    pass


def shorten_ch5_duplicate_captions(doc):
    """Chương kết quả: bỏ chú thích Hình 18/19 trùng (đã có ở chương cài đặt)."""
    in_ch4 = False
    remove = []
    body = doc.element.body
    children = list(body)
    for i, el in enumerate(children):
        if not is_p(el):
            continue
        t = para_text(el)
        if t.startswith("CHƯƠNG 4. KẾT QUẢ") or t.startswith("CHƯƠNG 5: KẾT QUẢ"):
            in_ch4 = True
        if t.startswith("CHƯƠNG 5. KẾT LUẬN") or t.strip() == "KẾT LUẬN":
            in_ch4 = False
        if in_ch4 and (
            t.startswith("Hình 18. Giao diện trang chủ")
            or t.startswith("Hình 19. Giao diện trang quản trị Admin – demo")
            or t.startswith("Hình 19. Giao diện trang quản trị Admin – demo kết quả")
        ):
            # xóa chú thích và ảnh ngay trước
            prev = el.getprevious()
            if prev is not None and is_p(prev) and (
                "w:drawing" in prev.xml or "v:imagedata" in prev.xml or "a:blip" in prev.xml
            ):
                remove.append(prev)
            remove.append(el)
    for el in remove:
        parent = el.getparent()
        if parent is not None:
            parent.remove(el)
    return len(remove)


def main():
    doc = Document(str(SRC))
    n44 = walk_delete(doc.element.body)
    apply_renames(doc)
    ncap = shorten_ch5_duplicate_captions(doc)
    nimg = shrink_pictures(doc, 12.5)
    set_body_format(doc)

    # Ghi chú phạm vi trang vào tóm tắt – tìm paragraph TÓM TẮT
    for p in doc.paragraphs:
        if (p.text or "").strip() == "TÓM TẮT ĐỒ ÁN":
            break

    doc.save(str(TMP))
    try:
        shutil.copyfile(TMP, OUT)
        TMP.unlink(missing_ok=True)
        saved = OUT
    except PermissionError:
        saved = TMP
    print("removed_els", n44, "dup_caps", ncap, "shrunk", nimg, "saved", saved)


if __name__ == "__main__":
    main()
