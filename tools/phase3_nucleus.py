"""Phase 3 — fortunes Bettencourt, Arnault, Mulliez (liens sourcés)."""

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
        prev = by_id.get(row[key], {})
        by_id[row[key]] = {**prev, **row}
    return list(by_id.values())


def add_ownerships(data: dict, links: list[dict]) -> None:
    existing = {
        (
            o["ownedCompanyId"],
            o["owner"]["type"],
            o["owner"]["id"],
            o["status"],
        )
        for o in data["ownerships"]
    }
    for link in links:
        key = (
            link["ownedCompanyId"],
            link["owner"]["type"],
            link["owner"]["id"],
            link["status"],
        )
        if key not in existing:
            data["ownerships"].append(link)
            existing.add(key)


def brand(
    bid: str,
    name: str,
    aliases: list[str],
    sectors: list[str],
    company_id: str,
    slug: str,
    palette_i: int,
) -> dict:
    if not (LOGOS / f"{slug}.png").exists():
        letters = "".join(w[0].upper() for w in name.replace("'", " ").split()[:2])
        monogram(slug, letters or name[:2].upper(), PALETTE[palette_i % 3])
    return {
        "id": bid,
        "name": name,
        "aliases": aliases,
        "sectors": sectors,
        "companyId": company_id,
        "logoAsset": f"assets/logos/{slug}.png",
        "logoSource": LOGO_NOTE,
    }


def main() -> None:
    data = json.loads(PATH.read_text(encoding="utf-8"))
    data["version"] = "2026.10.5"
    data["updatedOn"] = "2026-10-06"
    for sector in ("luxe", "distribution"):
        if sector not in data["sectors"]:
            data["sectors"].append(sector)

    data["sources"] = upsert(
        data["sources"],
        "id",
        [
            {
                "id": "source.loreal-deu-2025",
                "title": "Document d'enregistrement universel 2025",
                "url": "https://www.loreal-finance.com/system/files/2026-03/LOREAL_DEU_2025_FR.pdf",
                "publisher": "L'Oréal",
            },
            {
                "id": "source.christian-dior-ra-2025",
                "title": "Rapport annuel au 31 décembre 2025",
                "url": "https://www.dior-finance.com/pdf/d/1/1186/CD%20SE%20-%20Rapport%20annuel%20au%2031%20d%C3%A9cembre%202025.pdf",
                "publisher": "Christian Dior SE",
            },
            {
                "id": "source.lvmh-deu-2025",
                "title": "Document d'enregistrement universel 2025",
                "url": "https://urd.lvmh.com/fr/2025",
                "publisher": "LVMH",
            },
            {
                "id": "source.elo-rfa-2023",
                "title": "Rapport financier et déclaration de performance extra-financière",
                "url": "https://www.auchan-retail.com/storage/app/uploads/public/66a/c76/e2e/66ac76e2e89c3389924940.pdf",
                "publisher": "ELO / Auchan Retail",
            },
        ],
    )

    data["fortunes"] = upsert(
        data["fortunes"],
        "id",
        [
            {
                "id": "fortune.bettencourt",
                "name": "famille Bettencourt Meyers",
                "aliases": [
                    "Françoise Bettencourt Meyers",
                    "Bettencourt Meyers",
                    "famille Bettencourt",
                ],
                "summary": "Premier actionnaire de L'Oréal, notamment via Téthys SAS et Financière L'Arcouest SAS.",
            },
            {
                "id": "fortune.arnault",
                "name": "famille Arnault",
                "aliases": ["Bernard Arnault", "groupe familial Arnault", "Arnault"],
                "summary": "Contrôle LVMH via Agache, Financière Agache et Christian Dior SE.",
            },
            {
                "id": "fortune.mulliez",
                "name": "famille Mulliez",
                "aliases": [
                    "Association Familiale Mulliez",
                    "AFM",
                    "Gérard Mulliez",
                ],
                "summary": "Actionnariat familial d'ELO (Auchan Retail, New Immo Holding), via l'Association Familiale Mulliez.",
            },
        ],
    )

    data["companies"] = upsert(
        data["companies"],
        "id",
        [
            {
                "id": "company.tethys",
                "name": "Téthys SAS",
                "aliases": ["Tethys", "Téthys"],
                "country": "FR",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.financiere-arcouest",
                "name": "Financière L'Arcouest SAS",
                "aliases": ["Financière L'Arcouest", "L'Arcouest"],
                "country": "FR",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.agache",
                "name": "Agache",
                "aliases": ["Agache SCA"],
                "country": "FR",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.financiere-agache",
                "name": "Financière Agache",
                "aliases": ["Financiere Agache"],
                "country": "FR",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.christian-dior-se",
                "name": "Christian Dior SE",
                "aliases": ["Christian Dior"],
                "country": "FR",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.lvmh",
                "name": "LVMH",
                "aliases": ["LVMH Moët Hennessy Louis Vuitton", "LVMH SE"],
                "country": "FR",
                "siren": None,
                "role": "groupe opérationnel",
            },
            {
                "id": "company.elo",
                "name": "ELO",
                "aliases": ["ELO SA", "Auchan Holding"],
                "country": "FR",
                "siren": None,
                "role": "holding",
            },
            {
                "id": "company.auchan-retail",
                "name": "Auchan Retail",
                "aliases": ["Auchan"],
                "country": "FR",
                "siren": None,
                "role": "groupe opérationnel",
            },
        ],
    )

    add_ownerships(
        data,
        [
            # Bettencourt → L'Oréal (DEU 2025, 31/12/2025)
            {
                "ownedCompanyId": "company.tethys",
                "owner": {"type": "fortune", "id": "fortune.bettencourt"},
                "capitalPercent": None,
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2025-12-31",
                "sourceId": "source.loreal-deu-2025",
                "status": "active",
                "note": "Téthys SAS est contrôlée par Mme Françoise Bettencourt Meyers et sa famille.",
            },
            {
                "ownedCompanyId": "company.financiere-arcouest",
                "owner": {"type": "fortune", "id": "fortune.bettencourt"},
                "capitalPercent": None,
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2025-12-31",
                "sourceId": "source.loreal-deu-2025",
                "status": "active",
                "note": "Financière L'Arcouest SAS est également contrôlée par la famille Bettencourt Meyers.",
            },
            {
                "ownedCompanyId": "company.loreal",
                "owner": {"type": "company", "id": "company.tethys"},
                "capitalPercent": "28.55",
                "votingPercent": "28.55",
                "linkType": "reference_shareholder",
                "factDate": "2025-12-31",
                "sourceId": "source.loreal-deu-2025",
                "status": "active",
                "note": "152 514 292 actions L'Oréal détenues en pleine propriété par Téthys SAS.",
            },
            {
                "ownedCompanyId": "company.loreal",
                "owner": {"type": "company", "id": "company.financiere-arcouest"},
                "capitalPercent": "5.18",
                "votingPercent": "5.18",
                "linkType": "stake",
                "factDate": "2025-12-31",
                "sourceId": "source.loreal-deu-2025",
                "status": "active",
                "note": "27 650 000 actions L'Oréal détenues par Financière L'Arcouest SAS (≈ 5,18 % du capital).",
            },
            {
                "ownedCompanyId": "company.loreal",
                "owner": {"type": "company", "id": "company.nestle"},
                "capitalPercent": "20.16",
                "votingPercent": "20.16",
                "linkType": "stake",
                "factDate": "2025-12-31",
                "sourceId": "source.loreal-deu-2025",
                "status": "active",
                "note": "Via Nestlé Equity Holdings Limited ; Nestlé n'est pas une fortune du noyau.",
            },
            # Arnault → LVMH (Christian Dior RA 2025 / LVMH)
            {
                "ownedCompanyId": "company.agache",
                "owner": {"type": "fortune", "id": "fortune.arnault"},
                "capitalPercent": None,
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2025-12-31",
                "sourceId": "source.christian-dior-ra-2025",
                "status": "active",
                "note": "Agache porte la participation familiale Arnault.",
            },
            {
                "ownedCompanyId": "company.financiere-agache",
                "owner": {"type": "company", "id": "company.agache"},
                "capitalPercent": None,
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2025-12-31",
                "sourceId": "source.christian-dior-ra-2025",
                "status": "active",
                "note": "Financière Agache est dans le périmètre Agache / famille Arnault.",
            },
            {
                "ownedCompanyId": "company.christian-dior-se",
                "owner": {"type": "company", "id": "company.financiere-agache"},
                "capitalPercent": None,
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2025-12-31",
                "sourceId": "source.christian-dior-ra-2025",
                "status": "active",
                "note": "Contrôle de Christian Dior SE dans le périmètre Agache / groupe familial Arnault.",
            },
            {
                "ownedCompanyId": "company.lvmh",
                "owner": {"type": "company", "id": "company.christian-dior-se"},
                "capitalPercent": "42",
                "votingPercent": "56",
                "linkType": "reference_shareholder",
                "factDate": "2025-12-31",
                "sourceId": "source.christian-dior-ra-2025",
                "status": "active",
                "note": "Christian Dior SE détient environ 42 % du capital et 56 % des droits de vote de LVMH (rapport annuel 2025).",
            },
            # Mulliez → Auchan
            {
                "ownedCompanyId": "company.elo",
                "owner": {"type": "fortune", "id": "fortune.mulliez"},
                "capitalPercent": "98",
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2023-12-31",
                "sourceId": "source.elo-rfa-2023",
                "status": "active",
                "note": "Actionnariat familial ≈ 98 % d'ELO ; salariés ≈ 2 % (rapport ELO).",
            },
            {
                "ownedCompanyId": "company.auchan-retail",
                "owner": {"type": "company", "id": "company.elo"},
                "capitalPercent": None,
                "votingPercent": None,
                "linkType": "control",
                "factDate": "2023-12-31",
                "sourceId": "source.elo-rfa-2023",
                "status": "active",
                "note": "ELO réunit Auchan Retail et New Immo Holding.",
            },
        ],
    )

    brands = [
        brand(
            "brand.sephora",
            "Sephora",
            [],
            ["hygiene", "luxe"],
            "company.lvmh",
            "sephora",
            0,
        ),
        brand(
            "brand.louis-vuitton",
            "Louis Vuitton",
            ["LV"],
            ["luxe"],
            "company.lvmh",
            "louis-vuitton",
            1,
        ),
        brand(
            "brand.dior",
            "Dior",
            ["Christian Dior", "Parfums Christian Dior"],
            ["luxe", "hygiene"],
            "company.lvmh",
            "dior",
            2,
        ),
        brand(
            "brand.auchan",
            "Auchan",
            ["Auchan Retail", "Auchan France"],
            ["distribution"],
            "company.auchan-retail",
            "auchan",
            0,
        ),
        brand(
            "brand.maybelline",
            "Maybelline",
            ["Maybelline New York"],
            ["hygiene"],
            "company.loreal",
            "maybelline",
            1,
        ),
        brand(
            "brand.lancome",
            "Lancôme",
            ["Lancome"],
            ["hygiene", "luxe"],
            "company.loreal",
            "lancome",
            2,
        ),
    ]
    data["brands"] = upsert(data["brands"], "id", brands)

    PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        f"wrote {PATH.name} v{data['version']} · fortunes={len(data['fortunes'])} "
        f"brands={len(data['brands'])} ownerships={len(data['ownerships'])}"
    )


if __name__ == "__main__":
    main()
