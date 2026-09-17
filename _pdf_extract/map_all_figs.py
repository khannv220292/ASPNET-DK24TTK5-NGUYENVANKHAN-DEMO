# -*- coding: utf-8 -*-
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

docx = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
out_dir = Path(r"C:\Users\nguye\AppData\Local\Temp\baocao_figs")
out_dir.mkdir(exist_ok=True)
z = zipfile.ZipFile(docx)

rels = {}
rels_xml = ET.fromstring(z.read("word/_rels/document.xml.rels"))
for rel in rels_xml:
    rels[rel.attrib.get("Id")] = rel.attrib.get("Target")

root = ET.fromstring(z.read("word/document.xml"))
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
A = "{http://schemas.openxmlformats.org/drawingml/2006/main}"
R = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"
V = "{urn:schemas-microsoft-com:vml}"

body = root.find(W + "body")
items = []  # (kind, text, embeds)

def para_text(el):
    return "".join((t.text or "") for t in el.iter(W + "t")).strip()

def embeds_in(el):
    found = []
    for blip in el.iter(A + "blip"):
        rid = blip.attrib.get(R + "embed")
        if rid:
            found.append(("blip", rels.get(rid)))
    for im in el.iter(V + "imagedata"):
        rid = im.attrib.get(R + "id") or im.attrib.get("{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id")
        if rid:
            found.append(("vml", rels.get(rid)))
    return found

for child in list(body):
    tag = child.tag.split("}")[-1]
    if tag == "p":
        t = para_text(child)
        em = embeds_in(child)
        items.append(("p", t, em))
    elif tag == "tbl":
        t = para_text(child)
        em = embeds_in(child)
        items.append(("tbl", t[:80], em))
    elif tag == "sdt":
        t = para_text(child)
        em = embeds_in(child)
        if t or em:
            items.append(("sdt", t[:80], em))

# dump all images with +/- 2 neighbors
lines = []
for i, (kind, t, em) in enumerate(items):
    if not em:
        continue
    prev = items[i - 1][1][:100] if i else ""
    nxt = items[i + 1][1][:100] if i + 1 < len(items) else ""
    lines.append(f"--- idx={i} kind={kind} embeds={em}")
    lines.append(f"  prev: {prev}")
    lines.append(f"  self: {t[:100]}")
    lines.append(f"  next: {nxt}")
    for j, (typ, tgt) in enumerate(em):
        if not tgt:
            continue
        src = "word/" + tgt.replace("\\", "/").lstrip("/")
        if src.startswith("word/word/"):
            src = "word/" + tgt.replace("\\", "/").lstrip("/")
            if not src.startswith("word/media") and "media" in tgt:
                src = "word/" + tgt
        try:
            data = z.read(src)
        except KeyError:
            src2 = "word/" + Path(tgt).as_posix()
            try:
                data = z.read(src2)
                src = src2
            except KeyError:
                lines.append(f"  MISSING {tgt}")
                continue
        dest = out_dir / f"img_{i:03d}_{j}_{Path(src).name}"
        dest.write_bytes(data)
        lines.append(f"  saved {dest.name} bytes={len(data)}")

Path(out_dir / "all_map.txt").write_text("\n".join(lines), encoding="utf-8")
print(f"image blocks {sum(1 for x in items if x[2])}")
print("\n".join(lines[:120]))
print("... total lines", len(lines))
