"""Phase 1 probe: GTIN → catalogue → noyau (fortune / entreprise / inconnu).

Usage:
  python tools/phase1_probe.py
  python tools/phase1_probe.py 3017620429484 9782246807230
"""

from __future__ import annotations

import json
import sys
import unicodedata
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIBRARY = ROOT / "assets" / "library" / "library.json"
UA = "Ceaki/0.6.0 Phase1Probe (https://github.com/Enterenn/ceaki)"

# Battery de départ — codes stables / connus FR. Compléter après magasin.
DEFAULT_GTINS = [
    # Livres
    "9782246807230",  # Grasset → Bolloré
    "9782259195409",  # Plon → Křetínský (Phase 2)
    # Jeu (seed local)
    "3558380078180",  # Dobble / Asmodee
    # Seeds locaux Phase 2 + OFF
    "3017620429484",  # Nutella
    "3068320115257",  # Evian (seed)
    "5449000000996",  # Coca-Cola
    "3600541226481",  # Garnier (seed)
    "4005808819203",  # Nivea (seed)
]


def normalize(name: str) -> str:
    # Mirror lib/domain/brand_name.dart (displayBrandName + normalizeBrandName).
    import re

    text = re.sub(r"\s*\([^)]*\)", "", name)
    text = unicodedata.normalize("NFKD", text)
    text = "".join(c for c in text if not unicodedata.combining(c))
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", " ", text)
    tokens = [t for t in text.split() if t]
    legal = {"sa", "sas", "sarl", "se", "sasu", "ltd", "inc", "gmbh"}
    editorial = {"editions", "edition", "ed"}
    while tokens and (tokens[0] in legal or tokens[-1] in legal):
        if tokens[0] in legal:
            tokens.pop(0)
        if tokens and tokens[-1] in legal:
            tokens.pop()
    while tokens and tokens[0] in editorial:
        tokens.pop(0)
    return " ".join(tokens)


def load_index(data: dict) -> dict[str, dict]:
    brands = {b["id"]: b for b in data["brands"]}
    companies = {c["id"]: c for c in data["companies"]}
    ownerships = data["ownerships"]
    index: dict[str, list[str]] = {}
    for brand in data["brands"]:
        keys = {normalize(brand["name"])}
        keys.update(normalize(a) for a in brand.get("aliases", []))
        for key in keys:
            if key:
                index.setdefault(key, []).append(brand["id"])

    fortune_by_company: dict[str, set[str]] = {}

    def walk(company_id: str, seen: set[str]) -> set[str]:
        if company_id in seen:
            return set()
        seen.add(company_id)
        found: set[str] = set()
        for link in ownerships:
            if link.get("status") != "active":
                continue
            if link["ownedCompanyId"] != company_id:
                continue
            owner = link["owner"]
            if owner["type"] == "fortune":
                found.add(owner["id"])
            elif owner["type"] == "company":
                found |= walk(owner["id"], seen)
        return found

    for company_id in companies:
        fortune_by_company[company_id] = walk(company_id, set())

    return {
        "brands": brands,
        "companies": companies,
        "index": index,
        "fortune_by_company": fortune_by_company,
        "version": data.get("version"),
    }


def http_get(url: str) -> bytes | None:
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            return resp.read()
    except (urllib.error.HTTPError, urllib.error.URLError, TimeoutError):
        return None


def lookup_book(gtin: str) -> tuple[str | None, list[str], str]:
    # BnF SRU
    query = urllib.parse.quote(f'bib.fuzzyISBN all "{gtin}"')
    url = (
        "https://catalogue.bnf.fr/api/SRU?version=1.2&operation=searchRetrieve"
        f"&query={query}&recordSchema=dublincore&maximumRecords=5"
    )
    raw = http_get(url)
    if raw and b"<dc:publisher>" in raw:
        import re

        pubs = re.findall(r"<dc:publisher>(.*?)</dc:publisher>", raw.decode("utf-8", "ignore"))
        title = re.findall(r"<dc:title>(.*?)</dc:title>", raw.decode("utf-8", "ignore"))
        if pubs:
            return (title[0] if title else None), pubs, "bnf"
    # Open Library
    url = f"https://openlibrary.org/search.json?isbn={gtin}&fields=title,publisher"
    raw = http_get(url)
    if raw:
        data = json.loads(raw.decode())
        docs = data.get("docs") or []
        if docs:
            doc = docs[0]
            pubs = doc.get("publisher") or []
            if pubs:
                return doc.get("title"), pubs, "open_library"
    # Google Books
    url = "https://www.googleapis.com/books/v1/volumes?" + urllib.parse.urlencode(
        {"q": f"isbn:{gtin}"}
    )
    raw = http_get(url)
    if raw:
        data = json.loads(raw.decode())
        items = data.get("items") or []
        if items:
            info = items[0].get("volumeInfo") or {}
            pubs = info.get("publisher")
            publishers = [pubs] if isinstance(pubs, str) else (pubs or [])
            if publishers:
                return info.get("title"), publishers, "google_books"
    return None, [], "none"


def lookup_other(gtin: str) -> tuple[str | None, list[str], str]:
    url = (
        f"https://world.openfoodfacts.org/api/v2/product/{gtin}.json"
        "?product_type=all&fields=code,product_name,brands,product_type"
    )
    raw = http_get(url)
    if not raw:
        return None, [], "off_error"
    data = json.loads(raw.decode())
    if data.get("status") != 1:
        return None, [], "off_unknown"
    product = data.get("product") or {}
    brands = product.get("brands") or ""
    names = [b.strip() for b in brands.split(",") if b.strip()]
    return product.get("product_name"), names, "open_food_facts"


def classify(gtin: str, brand_names: list[str], nucleus: dict) -> list[dict]:
    rows = []
    for raw in brand_names:
        key = normalize(raw)
        ids = nucleus["index"].get(key, [])
        if not ids:
            rows.append(
                {
                    "raw": raw,
                    "tone": "unknown",
                    "brand": None,
                    "company": None,
                    "fortunes": [],
                }
            )
            continue
        # Homonym: first only for probe summary
        brand = nucleus["brands"][ids[0]]
        company = nucleus["companies"][brand["companyId"]]
        fortunes = sorted(nucleus["fortune_by_company"].get(brand["companyId"], set()))
        rows.append(
            {
                "raw": raw,
                "tone": "fortune" if fortunes else "clear",
                "brand": brand["name"],
                "company": company["name"],
                "fortunes": fortunes,
                "homonyms": len(ids),
            }
        )
    return rows


def probe(gtin: str, nucleus: dict) -> dict:
    is_book = gtin.startswith("978") or (
        gtin.startswith("979") and not gtin.startswith("9790")
    )
    if is_book:
        title, brands, source = lookup_book(gtin)
    else:
        title, brands, source = lookup_other(gtin)
    rows = classify(gtin, brands, nucleus) if brands else []
    tone = "product_unknown"
    if rows:
        if any(r["tone"] == "fortune" for r in rows):
            tone = "fortune"
        elif any(r["tone"] == "clear" for r in rows):
            tone = "clear"
        else:
            tone = "unknown"
    elif source.endswith("unknown") or source == "none":
        tone = "product_unknown"
    return {
        "gtin": gtin,
        "title": title,
        "source": source,
        "brands_api": brands,
        "tone": tone,
        "matches": rows,
    }


def main() -> None:
    # Avoid Windows console encoding crashes on arrows / accents.
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    data = json.loads(LIBRARY.read_text(encoding="utf-8"))
    nucleus = load_index(data)
    gtins = sys.argv[1:] or DEFAULT_GTINS
    print(f"noyau {nucleus['version']} · {len(gtins)} codes\n")
    summary = {"fortune": 0, "clear": 0, "unknown": 0, "product_unknown": 0}
    for gtin in gtins:
        result = probe(gtin, nucleus)
        summary[result["tone"]] = summary.get(result["tone"], 0) + 1
        print(f"{gtin}  [{result['tone']}]  via {result['source']}")
        if result["title"]:
            print(f"  titre : {result['title']}")
        if result["brands_api"]:
            print(f"  API   : {', '.join(result['brands_api'])}")
        for match in result["matches"]:
            if match["tone"] == "unknown":
                print(f"  -> NON RATTACHE « {match['raw']} »")
            else:
                fort = ", ".join(match["fortunes"]) or "-"
                extra = (
                    f" · {match['homonyms']} homonymes"
                    if match.get("homonyms", 1) > 1
                    else ""
                )
                print(
                    f"  -> {match['brand']} · {match['company']} · fortune={fort}{extra}"
                )
        print()
    print("resume", summary)
    print("\nCompleter docs/phase-1-journal.md avec les scans telephone / magasin.")


if __name__ == "__main__":
    main()
