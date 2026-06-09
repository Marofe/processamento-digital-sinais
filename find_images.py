import os
import re

folder = r"G:\My Drive\Disciplinas\Graduação\SEL343 - Processamento Digital de Sinais\slides\2026"
img_pattern = re.compile(r'<img[^>]+src=["\']([^"\']+)["\']', re.IGNORECASE)

found = {}
for root, dirs, files in os.walk(folder):
    for f in files:
        if f.endswith('.html'):
            path = os.path.join(root, f)
            try:
                with open(path, 'r', encoding='utf-8') as fh:
                    content = fh.read()
            except Exception:
                with open(path, 'r', encoding='latin1') as fh:
                    content = fh.read()
            matches = img_pattern.findall(content)
            if matches:
                found[f] = sorted(list(set(matches)))

for k, v in sorted(found.items()):
    print(f"\n--- {k} ---")
    for img in v:
        print(f"  {img}")
