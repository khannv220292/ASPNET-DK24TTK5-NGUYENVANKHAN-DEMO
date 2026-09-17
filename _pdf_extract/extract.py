# -*- coding: utf-8 -*-
import os
from PyPDF2 import PdfReader

src = r"C:\Users\nguye\Music\net"
out = r"C:\Users\nguye\Downloads\ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO-restore\_pdf_extract"
os.makedirs(out, exist_ok=True)
files = [
 "220064_Bai1_v1.0.pdf",
 "220064_Bai2_v1.0.pdf",
 "220064_Bai3_P1_v1.0.pdf",
 "220064_Bai4_v1.0.pdf",
 "220064_Bai5_P1_v1.0.pdf",
 "220064_Bai5_P2_v1.0.pdf",
 "220064_TaiLieuHocTap.pdf",
]
for name in files:
    path = os.path.join(src, name)
    reader = PdfReader(path)
    texts = []
    # extract all pages for Bai*, first 40 for TaiLieu
    limit = len(reader.pages) if "TaiLieu" not in name else min(40, len(reader.pages))
    for i in range(limit):
        t = reader.pages[i].extract_text() or ""
        texts.append("--- PAGE %d ---\n%s" % (i+1, t))
    out_path = os.path.join(out, name.replace(".pdf", ".txt"))
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n\n".join(texts))
    print(name, "pages", len(reader.pages), "wrote", limit, "chars", sum(len(x) for x in texts))
