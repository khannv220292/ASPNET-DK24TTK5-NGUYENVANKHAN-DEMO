# -*- coding: utf-8 -*-
"""Bỏ khung mẫu 'luồng sự kiện / luồng cơ bản / use case kết thúc'."""
from pathlib import Path
import shutil
from docx import Document

DOC = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
TMP = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\_gon_uc.docx")

DROP_EXACT = {
    "- Luồng sự kiện:",
    "+ Luồng cơ bản:",
    "Use case kết thúc.",
    "+ Luồng rẽ nhánh:",
    "- Luồng sự kiện",
    "+ Luồng cơ bản",
    "+ Luồng rẽ nhánh",
}

REPL = [
    (
        "1. Nếu không kết nối được SQL Server thì hệ thống hiển thị thông báo lỗi và use case kết thúc.",
        "1. Nếu nhập thiếu hoặc sai, hệ thống báo lỗi trên form (không chuyển trang).",
    ),
    (
        "1. Nếu không kết nối được SQL Server thì hệ thống hiển thị thông báo lỗi và use case kết thúc",
        "1. Nếu nhập thiếu hoặc sai, hệ thống báo lỗi trên form (không chuyển trang).",
    ),
]


def main():
    doc = Document(str(DOC))
    drop = []
    nrep = 0
    for p in doc.paragraphs:
        t = (p.text or "").strip()
        if t in DROP_EXACT:
            drop.append(p._element)
            continue
        if t.startswith("1. Nếu không kết nối được SQL Server"):
            drop.append(p._element)
            continue
    for el in drop:
        parent = el.getparent()
        if parent is not None:
            parent.remove(el)
    alt = DOC.with_name("BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
    doc.save(str(TMP))
    try:
        shutil.copyfile(TMP, DOC)
        TMP.unlink(missing_ok=True)
        print("ok drop", len(drop), "repl", nrep)
    except PermissionError:
        keep = DOC.with_name("BaoCao_RutGon_UseCase.docx")
        shutil.copyfile(TMP, keep)
        print("LOCKED, saved", keep, "drop", len(drop))


if __name__ == "__main__":
    main()
