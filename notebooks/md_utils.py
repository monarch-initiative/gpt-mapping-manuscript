import math
def as_md_table(df, path=None):
    s = ""
    h = False
    SEP = " | "
    def _val(k, v):
        if isinstance(v, float):
            if k and math.isclose(v, max(df[k])):
                v = f"**{v:.3f}**"
            else:
                v = f"{v:.3f}"
        v = str(v)
        return v.ljust(10)
    for _, row in df.iterrows():
        row = dict(row)
        if not h:
            h = True
            s = SEP + SEP.join([_val(None, v) for v in row.keys()]) + SEP + "\n"
            s += SEP + SEP.join([_val(None, ":---") for v in row.keys()]) + SEP + "\n"
        s += SEP + SEP.join([_val(k, v) for k, v in row.items()]) + SEP + "\n"
    if path:
        with open(path, "w") as file:
            file.write(s)
    return s
