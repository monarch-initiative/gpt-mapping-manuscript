import glob
import json
from io import open

filenames = glob.glob("notebooks/table-*.md")
obj = {}
for filename in filenames:
    basename = filename.split("/")[-1].replace(".md", "").replace("table-", "").replace("-", "_")
    with open(filename) as file:
        content = file.read()
        obj[basename] = content
with open("content/vars.json", "w") as file:
    file.write(json.dumps(obj, indent=2))


