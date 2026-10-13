# strain.math.upenn.edu

This folder is the website. The publication list in `pubs.html` is built
from your BibDesk file

    ~/Documents/MathLibrary/MyLaTeXtemplates/MyBIBfiles/RMS3.bib

by `build_pubs.py`, replacing BibBase.

## Updating the publication list

Only `pubs.html` needs rebuilding. The home and teaching pages don't use the
`.bib` file.

1. Edit `RMS3.bib` in BibDesk as usual.
2. In Terminal, run:

   ```
   cd ~/Documents/Claude/website/WEBPAGE
   python3 build_pubs.py
   ```

   It prints something like `Wrote 56 publications from RMS3.bib into pubs.html`.
3. Open `pubs.html` in a browser to check it.
4. Upload `pubs.html` to the server (and to GitHub). If you added a new
   preprint PDF, upload it to `preprints/` as well.

To build from a different file just once: `python3 build_pubs.py /path/to/other.bib`.
To change the file permanently, edit `BIB_FILE` near the top of `build_pubs.py`.

The script needs only Python 3, which is already on a Mac; nothing needs to
be installed.

## How BibTeX fields appear on the page

| Field | Shown as |
|---|---|
| `url_pdf` or `urlpdf` | "PDF" link |
| `url_arxiv`, or `eprint` with an arXiv number | "arXiv" link |
| `doi` | "DOI" link (the paper's title also links here) |
| `url` (when there is no `doi`) | "Journal" link |
| `mrnumber` | "MathSciNet" link |
| `url_proquest` | "ProQuest" link |
| `abstract` | the "abstract" toggle; `$...$` mathematics displays properly |
| `keywords` (comma-separated) | used by "Group by: keyword" |

- Keep full addresses in the `.bib`, e.g.
  `url_pdf = {https://strain.math.upenn.edu/preprints/file.pdf}`. On the page,
  any link to strain.math.upenn.edu becomes a relative link
  (`preprints/file.pdf`), so the Penn site, the GitHub copy, and this folder
  on your computer each open their own copy of the PDF.
- To link only `url_pdf` and not `urlpdf`, run `python3 build_pubs.py --hide-urlpdf`.
- Papers are sorted newest year first; within a year they keep the order of
  the `.bib` file.

## Notes

- The script only replaces the part of `pubs.html` between
  `<!-- PUBLICATIONS:BEGIN -->` and `<!-- PUBLICATIONS:END -->`. Your other
  edits to the page are kept, and you can run it as often as you like.
- If the script reports an error, the cause is usually an unbalanced `{` or `}`
  in the entry you just edited.
- `build_pubs.py` and this README do not need to be on the web server; no page
  loads them.
