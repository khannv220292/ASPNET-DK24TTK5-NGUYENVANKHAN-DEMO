# -*- coding: utf-8 -*-
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

docx = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
out_dir = Path(r"C:\Users\nguye\AppData\Local\Temp\baocao_figs")
out_dir.mkdir(exist_ok=True)
z = zipfile.ZipFile(docx)

ns = {
    "w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
    "wp": "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
}
rels = {}
rels_xml = ET.fromstring(z.read("word/_rels/document.xml.rels"))
for rel in rels_xml:
    rid = rel.attrib.get("Id")
    tgt = rel.attrib.get("Target")
    rels[rid] = tgt

root = ET.fromstring(z.read("word/document.xml"))
body = root.find("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}body")
seq = []
for child in list(body):
    tag = child.tag.split("}")[-1]
    if tag != "p":
        continue
    texts = "".join((t.text or "") for t in child.iter("{http://schemas.openxmlformats.org/wordprocessingml/2006/main}t")).strip()
    embeds = []
    for blip in child.iter("{http://schemas.openxmlformats.org/drawingml/2006/main}blip"):
        rid = blip.attrib.get("{http://schemas.openxmlformats.org/officeDocument/2006/relationships}embed")
        if rid:
            embeds.append(rels.get(rid, rid))
    if texts or embeds:
        seq.append((texts, embeds))

# dump nearby ch4-ch5
start = False
log = []
img_i = 0
for texts, embeds in seq:
    if texts.startswith("CHƯƠNG 4"):
        start = True
    if not start:
        continue
    if embeds:
        for e in embeds:
            src = "word/" + e.replace("\\", "/").lstrip("/")
            if src.startswith("word/word/"):
                src = src[5:]
            data = z.read(src)
            ext = Path(src).suffix
            dest = out_dir / f"seq_{img_i:02d}_{Path(src).name}"
            dest.write_bytes(data)
            log.append(f"IMG {img_i} file={Path(src).name} next_or_same_text={texts[:80]!r}")
            img_i += 1
    elif texts.startswith("Hình") or texts.startswith("CHƯƠNG") or texts.startswith("4.3") or texts.startswith("5.2"):
        log.append(f"CAP {texts[:120]}")
    if texts.startswith("KẾT LUẬN") or texts.startswith("5.3"):
        break

Path(out_dir / "map.txt").write_text("\n".join(log), encoding="utf-8")
print("\n".join(log))
print("extracted", img_i, "to", out_dir)
