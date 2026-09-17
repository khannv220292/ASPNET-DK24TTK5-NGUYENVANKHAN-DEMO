# -*- coding: utf-8 -*-
import shutil
import zipfile
from io import BytesIO
from pathlib import Path

src = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\BaoCao_laptop.khannv.vn_TheoMauChinh.docx")
tmp = Path(r"C:\Users\nguye\OneDrive\Máy tính\Đồ án\_tmp_laptopstore.docx")

old, new = "webgaming", "laptopstore"
n_files = 0
n_hits = 0
buf = BytesIO()
with zipfile.ZipFile(src, "r") as zin:
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zout:
        for info in zin.infolist():
            data = zin.read(info.filename)
            name = info.filename.lower()
            if name.endswith((".xml", ".rels")):
                try:
                    text = data.decode("utf-8")
                except UnicodeDecodeError:
                    text = data.decode("utf-8", "ignore")
                c = text.lower().count(old)
                if c:
                    n_files += 1
                    n_hits += c
                    # preserve original casing by replacing all common variants
                    text = (
                        text.replace("WEBGAMING", new.upper())
                        .replace("Webgaming", "Laptopstore")
                        .replace("webgaming", new)
                    )
                    data = text.encode("utf-8")
            zout.writestr(info, data)

tmp.write_bytes(buf.getvalue())
shutil.copyfile(tmp, src)
tmp.unlink(missing_ok=True)
print("xml_files", n_files, "replacements", n_hits)

# verify
left = 0
with zipfile.ZipFile(src, "r") as z:
    for n in z.namelist():
        raw = z.read(n)
        if b"webgaming" in raw.lower():
            left += 1
            print("STILL", n)
print("files_still_containing", left)
