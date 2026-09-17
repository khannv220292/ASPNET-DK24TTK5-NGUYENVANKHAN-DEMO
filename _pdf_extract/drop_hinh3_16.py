# -*- coding: utf-8 -*-
"""Bỏ ảnh lưu đồ Hình 3–16 (chiếm nhiều trang); thu nhỏ ảnh còn lại."""
from pathlib import Path
from lxml import etree

DOC = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
import shutil
import zipfile
from io import BytesIO

NSMAP = {
    "w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
    "wp": "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
}

def ptext(p):
    return "".join(p.xpath(".//w:t/text()", namespaces=NSMAP)).strip()


def has_img(p):
    xml = etree.tostring(p, encoding="unicode")
    return "blip" in xml or "imagedata" in xml


def main():
    buf = BytesIO(DOC.read_bytes())
    zin = zipfile.ZipFile(buf)
    xml = zin.read("word/document.xml")
    root = etree.fromstring(xml)
    body = root.find("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}body")
    children = list(body)
    drop = []
    for i, el in enumerate(children):
        if el.tag != "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}p":
            continue
        t = ptext(el)
        # Hình 3 .. Hình 16 (không lấy 17–20, D)
        if t.startswith("Hình ") and any(t.startswith(f"Hình {n}.") for n in range(3, 17)):
            # xóa ảnh ngay trước
            j = i - 1
            while j >= 0:
                prev = children[j]
                if prev.tag.endswith("}p") and has_img(prev) and not ptext(prev):
                    drop.append(prev)
                    j -= 1
                else:
                    break
            # giữ chú thích (một dòng, không ảnh)
        # Chương 4 kết quả: bỏ Hình 18/19 trùng
        if t.startswith("Hình 18.") or t.startswith("Hình 19."):
            # chỉ xóa nếu nằm sau CHƯƠNG 4. KẾT QUẢ — xử lý bằng cờ
            pass

    # cờ chương
    ch = ""
    for i, el in enumerate(children):
        if not el.tag.endswith("}p"):
            continue
        t = ptext(el)
        if t.startswith("CHƯƠNG "):
            ch = t[:20]
        if ch.startswith("CHƯƠNG 4") and (t.startswith("Hình 18.") or t.startswith("Hình 19.")):
            j = i - 1
            if j >= 0 and children[j].tag.endswith("}p") and has_img(children[j]):
                drop.append(children[j])
            drop.append(el)

    for el in drop:
        parent = el.getparent()
        if parent is not None:
            parent.remove(el)

    # thu nhỏ extent ảnh còn lại: max 11.5 cm
    max_cx = 11.5 * 360000
    for ext in root.xpath(".//wp:extent", namespaces=NSMAP):
        try:
            cx = int(ext.get("cx", "0"))
            cy = int(ext.get("cy", "0"))
            if cx > max_cx and cx > 0:
                r = max_cx / cx
                ext.set("cx", str(int(cx * r)))
                ext.set("cy", str(int(cy * r)))
        except Exception:
            pass

    new_xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    out = BytesIO()
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zout:
        for info in zin.infolist():
            data = new_xml if info.filename == "word/document.xml" else zin.read(info.filename)
            zout.writestr(info, data)
    DOC.write_bytes(out.getvalue())
    print("dropped", len(drop), "saved", DOC.stat().st_size)


if __name__ == "__main__":
    main()
