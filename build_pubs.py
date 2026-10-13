#!/usr/bin/env python3
"""
build_pubs.py -- builds the publication list in pubs.html from RMS3.bib.

This replaces BibBase.  The list is written into pubs.html between the two
marker comments

    <!-- PUBLICATIONS:BEGIN -->
    <!-- PUBLICATIONS:END -->

and everything else in pubs.html is left exactly as it is.  Run it again
whenever RMS3.bib changes, then upload pubs.html.

Usage (from this folder):

    python3 build_pubs.py                     # uses BIB_FILE below
    python3 build_pubs.py other.bib pubs.html # a different .bib file
    python3 build_pubs.py --hide-urlpdf       # link only `url_pdf`, not `urlpdf`

Only the Python 3 standard library is used; nothing needs to be installed.

What it does with the BibTeX fields
    url_pdf            -> "pdf" link        url_arxiv / eprint -> "arXiv" link
    doi                -> "doi" link        url (no doi)       -> "link"
    url_proquest       -> "ProQuest" link   abstract           -> "abstract" toggle
    keywords           -> "group by keyword"
`urlpdf` is linked too, like `url_pdf`, unless --hide-urlpdf is given.  Mathematics in $...$ is left for MathJax.
Full links to strain.math.upenn.edu in the .bib become relative links in
pubs.html (see SITE_URLS below).
"""

import argparse
import html
import os
import re
import unicodedata

ME_LAST = "Strain"
ME_DISPLAY = "Robert M. Strain"

# The BibTeX file the list is built from (your BibDesk master).
BIB_FILE = os.path.expanduser(
    "~/Documents/MathLibrary/MyLaTeXtemplates/MyBIBfiles/RMS3.bib")

# Links in the .bib that point to this website are written into pubs.html as
# relative links (e.g. "preprints/file.pdf"), so every copy of the site (Penn,
# GitHub, or a folder on your own computer) opens its own copy of the file.
# Keep full URLs in the .bib itself; they are converted only on the page.
SITE_URLS = ["https://strain.math.upenn.edu/", "http://strain.math.upenn.edu/",
             "https://www.math.upenn.edu/~strain/",
             "http://www.math.upenn.edu/~strain/"]


def site_relative(url):
    for base in SITE_URLS:
        if url.startswith(base):
            return url[len(base):] or "index.html"
    return url

BIBTEX_FIELDS = ["author", "title", "journal", "booktitle", "series", "editor",
                 "volume", "number", "pages", "year", "publisher", "address",
                 "school", "note", "doi", "eprint", "issn", "isbn", "mrnumber",
                 "zblnumber"]


# ==========================================================================
# BibTeX parsing
# ==========================================================================

def _read_braced(s, i):
    """s[i] == '{'; return (content, index after the closing brace)."""
    depth, j = 0, i
    while j < len(s):
        c = s[j]
        if c == "\\":
            j += 2
            continue
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return s[i + 1:j], j + 1
        j += 1
    raise ValueError("unbalanced braces near: " + s[i:i + 60])


def _read_quoted(s, i):
    depth, j = 0, i + 1
    while j < len(s):
        c = s[j]
        if c == "\\":
            j += 2
            continue
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
        elif c == '"' and depth == 0:
            return s[i + 1:j], j + 1
        j += 1
    raise ValueError("unterminated string near: " + s[i:i + 60])


def parse_bibtex(text):
    entries = []
    strings = {}
    i = 0
    while True:
        at = text.find("@", i)
        if at < 0:
            break
        m = re.match(r"@\s*([A-Za-z]+)\s*([{(])", text[at:])
        if not m:
            i = at + 1
            continue
        etype = m.group(1).lower()
        j = at + m.end()
        if etype in ("comment", "preamble"):
            _, i = _read_braced(text, j - 1) if m.group(2) == "{" else (None, j)
            continue
        if etype == "string":
            body, i = _read_braced(text, j - 1)
            k, _, v = body.partition("=")
            v = v.strip()
            strings[k.strip().lower()] = v[1:-1] if v[:1] in "{\"" else v
            continue
        # key
        k_end = text.find(",", j)
        key = text[j:k_end].strip()
        j = k_end + 1
        fields = {}
        order = []
        while True:
            while j < len(text) and text[j] in " \t\r\n,":
                j += 1
            if j >= len(text) or text[j] in "})":
                j += 1
                break
            fm = re.match(r"([A-Za-z0-9_\-:.]+)\s*=\s*", text[j:])
            if not fm:
                # skip junk to next comma
                j = text.find(",", j) + 1 or len(text)
                continue
            name = fm.group(1).lower()
            j += fm.end()
            parts = []
            while True:
                c = text[j]
                if c == "{":
                    v, j = _read_braced(text, j)
                elif c == '"':
                    v, j = _read_quoted(text, j)
                else:
                    vm = re.match(r"[A-Za-z0-9_\-:.]+", text[j:])
                    v = vm.group(0)
                    j += vm.end()
                    v = strings.get(v.lower(), v)
                parts.append(v)
                while j < len(text) and text[j] in " \t\r\n":
                    j += 1
                if j < len(text) and text[j] == "#":
                    j += 1
                    while text[j] in " \t\r\n":
                        j += 1
                    continue
                break
            if name not in fields:
                order.append(name)
            fields[name] = "".join(parts)
        entries.append({"type": etype, "key": key, "fields": fields,
                        "order": order})
        i = j
    return entries


# ==========================================================================
# LaTeX -> HTML
# ==========================================================================

ACCENTS = {"'": "\u0301", "`": "\u0300", '"': "\u0308", "^": "\u0302",
           "~": "\u0303", "=": "\u0304", ".": "\u0307", "u": "\u0306",
           "v": "\u030C", "H": "\u030B", "c": "\u0327", "k": "\u0328",
           "r": "\u030A"}
SPECIAL = {"i": "\u0131", "j": "\u0237", "l": "\u0142", "L": "\u0141",
           "o": "\u00F8", "O": "\u00D8", "ss": "\u00DF", "ae": "\u00E6",
           "AE": "\u00C6", "oe": "\u0153", "OE": "\u0152", "aa": "\u00E5",
           "AA": "\u00C5"}

MATH_RE = re.compile(r"(\$\$.+?\$\$|\$.+?\$|\\\(.+?\\\)|\\\[.+?\\\])", re.S)


def _accents(s):
    # \'{\i}, {\'e}, \'e, \' e, \v{c}, \c c ...
    def rep(m):
        acc, base = m.group(1), m.group(2)
        base = base.strip("{} ")
        if base.startswith("\\"):
            base = SPECIAL.get(base[1:], base[1:])
        if base in ("\u0131",):
            base = "i"
        if base in ("\u0237",):
            base = "j"
        if not base:
            return ""
        return unicodedata.normalize("NFC", base[0] + ACCENTS[acc] + base[1:])
    pat = (r"\\([\'`\"^~=.])\s*(\{\\?[A-Za-z]*\}|\\[A-Za-z]+|[A-Za-z])"
           r"|\\([uvHckr])(?:\s+|(?=\{))(\{\\?[A-Za-z]*\}|[A-Za-z])")

    def rep2(m):
        if m.group(1):
            return rep(m)
        class M:  # small shim so rep() can be reused
            def __init__(s2, a, b): s2.a, s2.b = a, b
            def group(s2, n): return s2.a if n == 1 else s2.b
        return rep(M(m.group(3), m.group(4)))
    s = re.sub(pat, rep2, s)
    s = re.sub(r"\\(ss|ae|AE|oe|OE|aa|AA|[ijlLoO])(?![A-Za-z])\s?",
               lambda m: SPECIAL[m.group(1)], s)
    return s


# Surnames joined by an en dash in compound names (Navier–Stokes etc.).
EPONYMS = set("""Vlasov Maxwell Boltzmann Navier Stokes Landau Balescu Lenard
Poisson Glassey Strauss Schaeffer Fourier Mouhot Strain Klainerman Staffilani
Guo Gressman Chemin Lerner Caffarelli Kohn Nirenberg Bouchut Golse Pallard
Tasković Euler Fokker Planck Darcy Hele Shaw Hardy Littlewood Sobolev Besov
Hilbert Chapman Enskog Lorentz Fermi Dirac Bose Einstein Coulomb Hamilton
Jacobi Kolmogorov Kac Nordheim Uehling Uhlenbeck Cauchy Kovalevskaya""".split())


def _name_dashes(m):
    words = m.group(0).split("-")
    if all(w in EPONYMS for w in words):
        return "\u2013".join(words)
    return m.group(0)


def _text_to_html(s, cite=None, names=False):
    """Convert non-math LaTeX text to HTML."""
    s = _accents(s)
    if not names:
        # Vlasov-Maxwell -> Vlasov–Maxwell: en dash between two names
        s = re.sub(r"[A-Z][a-z\u00C0-\u017F]+(?:-[A-Z][a-z\u00C0-\u017F]+)+",
                   _name_dashes, s)
    s = s.replace("\\&", "\x00amp\x00").replace("\\%", "%").replace(
        "\\_", "_").replace("\\$", "\x00dollar\x00").replace("\\#", "#")
    s = html.escape(s, quote=False)
    # citations
    if cite:
        s = re.sub(r"\\cite[tp]?\{([^}]*)\}", lambda m: cite(m.group(1)), s)
    # font commands
    for cmd, tag in (("textit", "i"), ("emph", "i"), ("textbf", "b"),
                     ("textsc", "span class=\"sc\""), ("textrm", "span"),
                     ("text", "span")):
        close = tag.split()[0]
        s = re.sub(r"\\" + cmd + r"\s*\{([^{}]*)\}",
                   r"<%s>\1</%s>" % (tag, close), s)
    s = re.sub(r"\{\\(?:em|it|sl)\s+([^{}]*)\}", r"<i>\1</i>", s)
    s = re.sub(r"\{\\bf\s+([^{}]*)\}", r"<b>\1</b>", s)
    # quotes, dashes, spaces
    s = s.replace("``", "\u201C").replace("''", "\u201D")
    s = s.replace("---", "\u2014").replace("--", "\u2013")
    s = re.sub(r"(?<=\w)'(?=\w)", "\u2019", s)
    s = s.replace("`", "\u2018")
    s = s.replace("~", "\u00A0")
    s = s.replace("\\\\", " ").replace("\\,", "\u2009").replace("\\ ", " ")
    s = s.replace("{", "").replace("}", "")
    s = s.replace("\x00amp\x00", "&amp;").replace("\x00dollar\x00", "$")
    return s


def latex_to_html(s, cite=None, names=False):
    """LaTeX string -> HTML, leaving math for MathJax."""
    if not s:
        return ""
    out = []
    for k, part in enumerate(MATH_RE.split(s)):
        if k % 2 == 1:
            out.append(html.escape(part, quote=False))
        else:
            out.append(_text_to_html(part, cite, names))
    return re.sub(r"\s+", " ", "".join(out)).strip()


def latex_to_plain(s):
    """Plain text (math removed) for searching."""
    s = MATH_RE.sub(" ", s or "")
    s = re.sub(r"<[^>]+>", "", _text_to_html(s))
    s = html.unescape(s)
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if not unicodedata.combining(c))
    s = s.replace("\u0131", "i").replace("\u0142", "l").replace("\u0141", "L")
    return re.sub(r"\s+", " ", s).strip().lower()


def paragraphs(s, cite=None):
    paras = [p for p in re.split(r"\n\s*\n", (s or "").strip()) if p.strip()]
    return "".join("<p>%s</p>" % latex_to_html(p, cite) for p in paras)


# ==========================================================================
# Names
# ==========================================================================

def split_authors(s):
    out, depth, cur, i = [], 0, "", 0
    words = re.split(r"(\s+and\s+)", s)
    for w in words:
        if re.fullmatch(r"\s+and\s+", w) and depth == 0:
            out.append(cur)
            cur = ""
            continue
        depth += w.count("{") - w.count("}")
        cur += w
    if cur.strip():
        out.append(cur)
    return [a.strip() for a in out if a.strip()]


def parse_name(a):
    parts = [p.strip() for p in a.split(",")]
    if len(parts) == 1:
        toks = parts[0].split()
        first, last = " ".join(toks[:-1]), toks[-1] if toks else ""
    elif len(parts) == 2:
        last, first = parts
    else:
        last, first = parts[0], parts[2] + ", " + parts[1]
    first = latex_to_html(first, names=True)
    last = latex_to_html(last, names=True)
    return first, last


def name_html(a):
    first, last = parse_name(a)
    if html.unescape(last) == ME_LAST:
        return '<span class="me">%s</span>' % ME_DISPLAY, True
    full = (first + " " + last).strip()
    return full, False


def join_names(names):
    if len(names) == 1:
        return names[0]
    if len(names) == 2:
        return names[0] + " and " + names[1]
    return ", ".join(names[:-1]) + ", and " + names[-1]


def coauthor_lastnames(authors):
    out = []
    for a in authors:
        _, last = parse_name(a)
        if html.unescape(last) != ME_LAST:
            out.append(last)
    return out


# ==========================================================================
# Entry formatting
# ==========================================================================

def slug(s):
    s = latex_to_plain(s)
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-")


def year_of(e):
    y = re.sub(r"\D", "", e["fields"].get("year", ""))
    return int(y) if y else 0


def is_preprint(f):
    return (f.get("note", "").strip().lower() == "preprint"
            or not (f.get("journal") or f.get("booktitle") or f.get("school")))


def venue_html(e):
    f = e["fields"]
    t = e["type"]
    bits = []
    if t == "phdthesis":
        bits.append("PhD thesis, %s" % latex_to_html(f.get("school", "")))
        if f.get("year"):
            bits[-1] += " (%s)" % f["year"]
        return bits[0] + "."
    if is_preprint(f):
        s = "Preprint"
        if f.get("year"):
            s += " (%s)" % f["year"]
        if f.get("pages"):
            s += ", %s" % latex_to_html(f["pages"])
        return s + "."
    if t == "incollection" or (f.get("booktitle") and not f.get("journal")):
        s = "In <i>%s</i>" % latex_to_html(f.get("booktitle", "")).rstrip(".")
        if f.get("series"):
            s += ", %s" % latex_to_html(f["series"])
            if f.get("volume"):
                s += " %s" % latex_to_html(f["volume"])
        if f.get("year"):
            s += " (%s)" % f["year"]
        if f.get("pages"):
            s += ", %s" % latex_to_html(f["pages"])
        return s + "."
    s = '<span class="journal">%s</span>' % latex_to_html(f.get("journal", ""))
    if f.get("volume"):
        s += ' <span class="vol">%s</span>' % latex_to_html(f["volume"])
    if f.get("year"):
        s += " (%s)" % f["year"]
    if f.get("number"):
        s += ", no.\u00A0%s" % latex_to_html(f["number"])
    if f.get("pages"):
        p = latex_to_html(f["pages"])
        s += ", %s" % (p if "page" in p or "Art" in p else p)
    s += "."
    note = f.get("note", "")
    if note and note.lower() != "preprint" and not note.startswith("("):
        s += ' <span class="note">%s</span>' % latex_to_html(
            note[0].upper() + note[1:]).rstrip(".")
        s += "."
    return s


def links_for(e, show_urlpdf=False):
    f = e["fields"]
    links = []
    pdf = f.get("url_pdf") or (f.get("urlpdf") if show_urlpdf else None)
    if pdf:
        links.append(("pdf", "PDF", pdf, "Preprint PDF"))
    arx = f.get("url_arxiv")
    ep = f.get("eprint", "").strip()
    if not arx and ep and re.match(r"^\d{4}\.\d{4,5}|^[a-z\-]+/\d{7}", ep):
        arx = "https://arxiv.org/abs/" + ep
    if arx:
        m = re.search(r"abs/(.+)$", arx)
        links.append(("arxiv", "arXiv", arx,
                      "arXiv:" + (m.group(1) if m else ep)))
    doi = f.get("doi", "").strip()
    if doi:
        doi = re.sub(r"^https?://(dx\.)?doi\.org/", "", doi)
        links.append(("doi", "DOI", "https://doi.org/" + doi, "doi:" + doi))
    elif f.get("url"):
        links.append(("url", "Journal", f["url"], "Publisher page"))
    if f.get("url_proquest"):
        links.append(("proquest", "ProQuest", f["url_proquest"], "ProQuest"))
    if f.get("mrnumber"):
        mr = f["mrnumber"].strip().split()[0]
        links.append(("mr", "MathSciNet",
                      "https://mathscinet.ams.org/mathscinet-getitem?mr=" + mr,
                      "MR" + mr + " (subscription)"))
    return [(c, label, site_relative(href), tip)
            for c, label, href, tip in links]


def bibtex_text(e):
    f = e["fields"]
    lines = ["@%s{%s," % (e["type"], e["key"])]
    for k in BIBTEX_FIELDS:
        if k in f and f[k].strip():
            if k == "note" and f[k].strip().startswith("("):
                continue
            v = re.sub(r"\s+", " ", f[k].strip())
            lines.append("  %-9s = {%s}," % (k, v))
    lines[-1] = lines[-1].rstrip(",")
    lines.append("}")
    return "\n".join(lines)



# ==========================================================================
# Output (BibBase-style list)
# ==========================================================================

def prepare(entries):
    by_key = {e["key"]: e for e in entries}
    for idx, e in enumerate(entries):
        f = e["fields"]
        e["idx"] = idx
        e["year"] = year_of(e)
        e["id"] = "pub-" + re.sub(r"[^A-Za-z0-9_\-]", "-", e["key"])
        e["authors"] = split_authors(f.get("author", ""))
        e["kws"] = [k.strip() for k in f.get("keywords", "").split(",")
                    if k.strip()]
    # newest first; within a year keep the order of the .bib file
    entries.sort(key=lambda e: (-e["year"], e["idx"]))

    def cite(keys):
        out = []
        for k in keys.split(","):
            t = by_key.get(k.strip())
            if t:
                names = [parse_name(a)[1] for a in t["authors"]]
                out.append('<a href="#%s">%s, %s</a>'
                           % (t["id"], "–".join(names), t["year"]))
            else:
                out.append(html.escape(k.strip()))
        return "[" + "; ".join(out) + "]"
    for e in entries:
        e["cite"] = cite
    return entries


def entry_html(e, show_urlpdf):
    f = e["fields"]
    authors = join_names([name_html(a)[0] for a in e["authors"]])
    title = latex_to_html(f.get("title", "")).rstrip(".")
    links = links_for(e, show_urlpdf)
    # the title links to the published version if there is one, else arXiv
    main = next((l for l in links if l[0] in ("doi", "url")), None) or \
        next((l for l in links if l[0] == "arxiv"), None)
    if main:
        title = '<a class="pub-title" href="%s">%s</a>' % (
            html.escape(main[2], quote=True), title)
    else:
        title = '<span class="pub-title">%s</span>' % title
    kws = "|".join(e["kws"])
    out = ['<li class="pub" id="%s" data-year="%s" data-keywords="%s">'
           % (e["id"], e["year"], html.escape(kws, quote=True))]
    out.append('<span class="pub-authors">%s.</span> ' % authors)
    out.append('%s. ' % title)
    out.append('<span class="pub-venue">%s</span>' % venue_html(e))
    out.append('<span class="pub-links">')
    for cls, label, href, tip in links:
        out.append(' <a class="pub-link" href="%s" title="%s">%s</a>'
                   % (html.escape(href, quote=True),
                      html.escape(tip, quote=True), label))
    out.append('</span>')
    out.append('<div class="pub-extras">')
    if f.get("abstract"):
        out.append('<details class="pub-more"><summary>abstract</summary>'
                   '<div class="pub-abstract">%s</div></details>'
                   % paragraphs(f["abstract"], e["cite"]))
    out.append('<details class="pub-more"><summary>bibtex</summary>'
               '<pre class="pub-bibtex">%s</pre></details>'
               % html.escape(bibtex_text(e)))
    out.append('</div></li>')
    return "".join(out)


def build_list(entries, show_urlpdf=False):
    out = ['<p class="pub-count">%d publications. Group by: '
           '<select id="pub-group" aria-label="Group publications by">'
           '<option value="year">year</option>'
           '<option value="keyword">keyword</option>'
           '</select></p>' % len(entries),
           '<div id="pub-list">']
    year = None
    for e in entries:
        if e["year"] != year:
            if year is not None:
                out.append('</ul></details>')
            year = e["year"]
            out.append('<details class="pub-group" open><summary>%s</summary>'
                       '<ul class="pub-items">' % year)
        out.append(entry_html(e, show_urlpdf))
    out.append('</ul></details>')
    out.append('</div>')
    return "\n".join(out)


def inject(path, name, content):
    with open(path, encoding="utf-8") as fh:
        page = fh.read()
    pat = re.compile(r"(<!-- %s:BEGIN -->)(.*?)(<!-- %s:END -->)"
                     % (name, name), re.S)
    if not pat.search(page):
        return False
    page = pat.sub(lambda m: m.group(1) + "\n" + content + "\n" + m.group(3),
                   page)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(page)
    return True


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    ap = argparse.ArgumentParser(description="Build the publication list "
                                 "in pubs.html from a BibTeX file.")
    ap.add_argument("bib", nargs="?", default=BIB_FILE)
    ap.add_argument("page", nargs="?", default=os.path.join(here, "pubs.html"))
    ap.add_argument("--hide-urlpdf", action="store_true",
                    help="do not link `urlpdf` fields (only `url_pdf`)")
    args = ap.parse_args()

    with open(args.bib, encoding="utf-8") as fh:
        entries = prepare(parse_bibtex(fh.read()))
    if not inject(args.page, "PUBLICATIONS",
                  build_list(entries, not args.hide_urlpdf)):
        raise SystemExit("No <!-- PUBLICATIONS:BEGIN --> marker in "
                         + args.page)
    print("Wrote %d publications from %s into %s"
          % (len(entries), os.path.basename(args.bib),
             os.path.basename(args.page)))


if __name__ == "__main__":
    main()
