"""Phase 2 nucleus: Editis→IMI→Křetínský, DV Bolloré, marques Editis, logos."""

from __future__ import annotations

import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "assets" / "library" / "library.json"
LOGOS = ROOT / "assets" / "logos"
LOGO_NOTE = (
    "Monogramme Céaki — identité géométrique, pas une reproduction de marque déposée"
)

PALETTE = [
    ((11, 11, 15), (200, 255, 61)),
    ((11, 11, 15), (255, 61, 90)),
    ((11, 11, 15), (18, 184, 134)),
]


def monogram(slug: str, letters: str, colors: tuple) -> None:
    bg, accent = colors
    size = 256
    img = Image.new("RGB", (size, size), bg)
    draw = ImageDraw.Draw(img)
    draw.rectangle([0, 0, 28, size], fill=accent)
    draw.rectangle([0, size - 28, size, size], fill=accent)
    try:
        font = ImageFont.truetype("arialbd.ttf", 110 if len(letters) == 1 else 72)
    except OSError:
        font = ImageFont.load_default()
    bbox = draw.textbbox((0, 0), letters, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(
        ((size - tw) / 2 + 8, (size - th) / 2 - 8),
        letters,
        fill=(247, 247, 242),
        font=font,
    )
    LOGOS.mkdir(parents=True, exist_ok=True)
    img.save(LOGOS / f"{slug}.png", "PNG")


def upsert(items: list[dict], key: str, rows: list[dict]) -> list[dict]:
    by_id = {row[key]: row for row in items}
    for row in rows:
        by_id[row[key]] = {**by_id.get(row[key], {}), **row}
    return list(by_id.values())


def main() -> None:
    data = json.loads(PATH.read_text(encoding="utf-8"))
    data["version"] = "2026.10.4"
    data["updatedOn"] = "2026-10-06"

    data["sources"] = upsert(
        data["sources"],
        "id",
        [
            {
                "id": "source.vivendi-editis-closing-2023",
                "title": "Closing of the Editis sale to IMI",
                "url": "https://www.vivendi.com/en/press-release/vivendi-closing-of-the-editis-sale-to-imi/",
                "publisher": "Vivendi",
            },
            {
                "id": "source.eu-editis-imi-2023",
                "title": "Case M.11153 – CMI / Editis (public version)",
                "url": "https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX%3A32023M11153",
                "publisher": "European Commission",
            },
        ],
    )

    data["fortunes"] = upsert(
        data["fortunes"],
        "id",
        [
            {
                "id": "fortune.kretinsky",
                "name": "Daniel Křetínský",
                "aliases": ["Daniel Kretinsky", "Křetínský", "Kretinsky"],
                "summary": "Homme d'affaires ; via Czech Media Invest et International Media Invest, contrôle notamment Editis depuis 2023.",
            }
        ],
    )

    data["companies"] = upsert(
        data["companies"],
        "id",
        [
            {
                "id": "company.imi",
                "name": "International Media Invest",
                "aliases": ["IMI", "International Media Invest a.s."],
                "country": "CZ",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.cmi",
                "name": "Czech Media Invest",
                "aliases": ["CMI", "Czech Media Invest a.s."],
                "country": "CZ",
                "siren": None,
                "role": "holding",
            },
        ],
    )

    # DV Bolloré → LHG: align CDC (empty unless source separates votes).
    for link in data["ownerships"]:
        if (
            link.get("ownedCompanyId") == "company.louis-hachette-group"
            and link.get("owner", {}).get("id") == "company.bollore-se"
        ):
            link["votingPercent"] = None

    # Ownerships for Editis chain — keep Vivendi historical.
    ownership_keys = {
        (
            o["ownedCompanyId"],
            o["owner"]["type"],
            o["owner"]["id"],
            o["status"],
        )
        for o in data["ownerships"]
    }
    new_links = [
        {
            "ownedCompanyId": "company.editis",
            "owner": {"type": "company", "id": "company.imi"},
            "capitalPercent": "100",
            "votingPercent": None,
            "linkType": "subsidiary",
            "factDate": "2023-11-14",
            "sourceId": "source.vivendi-editis-closing-2023",
            "status": "active",
            "note": "Cession Vivendi → IMI ; 100 % du capital.",
        },
        {
            "ownedCompanyId": "company.imi",
            "owner": {"type": "company", "id": "company.cmi"},
            "capitalPercent": "100",
            "votingPercent": None,
            "linkType": "subsidiary",
            "factDate": "2023-11-14",
            "sourceId": "source.eu-editis-imi-2023",
            "status": "active",
            "note": "IMI est une filiale à 100 % de CMI (décision UE M.11153).",
        },
        {
            "ownedCompanyId": "company.cmi",
            "owner": {"type": "fortune", "id": "fortune.kretinsky"},
            "capitalPercent": None,
            "votingPercent": None,
            "linkType": "control",
            "factDate": "2023-11-14",
            "sourceId": "source.eu-editis-imi-2023",
            "status": "active",
            "note": "Contrôle de CMI / véhicule IMI pour l'acquisition d'Editis.",
        },
    ]
    for link in new_links:
        key = (
            link["ownedCompanyId"],
            link["owner"]["type"],
            link["owner"]["id"],
            link["status"],
        )
        if key not in ownership_keys:
            data["ownerships"].append(link)

    editis_brands = [
        ("brand.nathan", "Nathan", ["Éditions Nathan"], "nathan"),
        ("brand.robert-laffont", "Robert Laffont", ["Éditions Robert Laffont", "Laffont"], "robert-laffont"),
        ("brand.bordas", "Bordas", ["Éditions Bordas"], "bordas"),
        ("brand.julliard", "Julliard", ["Éditions Julliard"], "julliard"),
        ("brand.presses-de-la-cite", "Presses de la Cité", ["La Cité"], "presses-de-la-cite"),
    ]
    brand_rows = []
    for i, (bid, name, aliases, slug) in enumerate(editis_brands):
        monogram(slug, "".join(w[0].upper() for w in name.split()[:2]), PALETTE[i % 3])
        brand_rows.append(
            {
                "id": bid,
                "name": name,
                "aliases": aliases,
                "sectors": ["edition"],
                "companyId": "company.editis",
                "logoAsset": f"assets/logos/{slug}.png",
                "logoSource": LOGO_NOTE,
            }
        )

    # Logos for brands still missing assets
    missing = [
        ("ferrero", "FE", 0),
        ("danone", "DA", 1),
        ("evian", "EV", 2),
        ("activia", "AC", 0),
        ("volvic", "VO", 1),
        ("nestle", "NE", 2),
        ("nespresso", "NS", 0),
        ("nescafe", "NC", 1),
        ("nutella", "NU", 2),
        ("kinder", "KI", 0),
        ("coca-cola", "CC", 1),
        ("pepsi", "PE", 2),
        ("lu", "LU", 0),
        ("milka", "MI", 1),
        ("garnier", "GA", 2),
        ("loreal-paris", "LO", 0),
        ("dove", "DO", 1),
        ("nivea", "NI", 2),
        ("carrefour", "CA", 0),
        ("gallimard", "G", 1),
        ("folio", "FO", 2),
        ("pocket", "PO", 0),
        ("flammarion", "FL", 1),
        ("jai-lu", "JL", 2),
        ("albin-michel", "AM", 0),
    ]
    by_id = {b["id"]: b for b in data["brands"]}
    for slug, letters, pi in missing:
        bid = f"brand.{slug}"
        path = LOGOS / f"{slug}.png"
        if not path.exists():
            monogram(slug, letters, PALETTE[pi % 3])
        if bid in by_id and not by_id[bid].get("logoAsset"):
            by_id[bid]["logoAsset"] = f"assets/logos/{slug}.png"
            by_id[bid]["logoSource"] = LOGO_NOTE

    data["brands"] = upsert(list(by_id.values()), "id", brand_rows)

    PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        f"wrote {PATH.name} v{data['version']} · "
        f"brands={len(data['brands'])} fortunes={len(data['fortunes'])} "
        f"ownerships={len(data['ownerships'])}"
    )


if __name__ == "__main__":
    main()
