# -*- coding: utf-8 -*-
import zipfile
from io import BytesIO
from pathlib import Path
from lxml import etree

DOC = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")

def main():
    data = DOC.read_bytes()
    zin = zipfile.ZipFile(BytesIO(data))
    rels_root = etree.fromstring(zin.read("word/_rels/document.xml.rels"))
    drop_rids = set()
    for rel in rels_root:
        tgt = rel.get("Target") or ""
        rid = rel.get("Id")
        # image3.jpeg .. image17.jpeg là lưu đồ UC; giữ image1,2 (mvc, erd), 18+ screenshot, png 18 hinh17
        name = Path(tgt.replace("\\", "/")).name.lower()
        if name.startswith("image") and name.endswith((".jpeg", ".jpg")):
            # image3 - image17
            num = "".join(ch for ch in name if ch.isdigit())
            if num.isdigit() and 3 <= int(num) <= 17:
                drop_rids.add(rid)
                print("drop rid", rid, name)

    root = etree.fromstring(zin.read("word/document.xml"))
    W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
    body = root.find(W + "body")
    removed = 0
    for p in list(body.iter(W + "p")):
        xml = etree.tostring(p, encoding="unicode")
        if any(rid in xml for rid in drop_rids):
            parent = p.getparent()
            parent.remove(p)
            removed += 1
    print("removed paras", removed)

    new_xml = etree.tostring(root, xml_declaration=True, encoding="UTF-8", standalone=True)
    out = BytesIO()
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as zout:
        for info in zin.infolist():
            payload = new_xml if info.filename == "word/document.xml" else zin.read(info.filename)
            zout.writestr(info, payload)
    DOC.write_bytes(out.getvalue())
    print("size", DOC.stat().st_size)

if __name__ == "__main__":
    main()
