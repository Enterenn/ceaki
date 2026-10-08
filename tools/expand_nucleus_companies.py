"""Add brand→company coverage without requiring a fortune link."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "assets" / "library" / "library.json"

LOGO_NOTE = (
    "Monogramme Céaki — identité géométrique, pas une reproduction de marque déposée"
)

COMPANIES = [
    {
        "id": "company.e-leclerc",
        "name": "E.Leclerc",
        "aliases": ["Leclerc", "E Leclerc"],
        "country": "FR",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.intermarche",
        "name": "Intermarché",
        "aliases": ["Les Mousquetaires", "ITM"],
        "country": "FR",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.lidl",
        "name": "Lidl",
        "aliases": ["Lidl France"],
        "country": "DE",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.aldi",
        "name": "Aldi",
        "aliases": ["Aldi Nord", "Aldi Sud"],
        "country": "DE",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.spar",
        "name": "Spar",
        "aliases": [],
        "country": "NL",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.netto",
        "name": "Netto",
        "aliases": [],
        "country": "DK",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.danone",
        "name": "Danone",
        "aliases": ["Danone SA", "Groupe Danone"],
        "country": "FR",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.nestle",
        "name": "Nestlé",
        "aliases": ["Nestlé S.A.", "Nestle"],
        "country": "CH",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.ferrero",
        "name": "Ferrero",
        "aliases": ["Ferrero SpA", "Groupe Ferrero"],
        "country": "IT",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.coca-cola",
        "name": "The Coca-Cola Company",
        "aliases": ["Coca-Cola", "Coca Cola"],
        "country": "US",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.pepsico",
        "name": "PepsiCo",
        "aliases": ["Pepsico"],
        "country": "US",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.mondelez",
        "name": "Mondelez International",
        "aliases": ["Mondelēz", "Mondelez"],
        "country": "US",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.unilever",
        "name": "Unilever",
        "aliases": ["Unilever PLC"],
        "country": "GB",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.loreal",
        "name": "L'Oréal",
        "aliases": ["Loreal", "L'Oreal"],
        "country": "FR",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.beiersdorf",
        "name": "Beiersdorf",
        "aliases": ["Beiersdorf AG"],
        "country": "DE",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.carrefour",
        "name": "Carrefour",
        "aliases": ["Carrefour SA", "Groupe Carrefour"],
        "country": "FR",
        "siren": None,
        "role": "groupe opérationnel",
    },
    {
        "id": "company.madrigall",
        "name": "Madrigall",
        "aliases": [],
        "country": "FR",
        "siren": None,
        "role": "holding",
    },
    {
        "id": "company.gallimard",
        "name": "Éditions Gallimard",
        "aliases": ["Gallimard"],
        "country": "FR",
        "siren": None,
        "role": "maison d'édition",
    },
    {
        "id": "company.flammarion",
        "name": "Flammarion",
        "aliases": ["Groupe Flammarion", "Éditions Flammarion"],
        "country": "FR",
        "siren": None,
        "role": "maison d'édition",
    },
    {
        "id": "company.albin-michel",
        "name": "Albin Michel",
        "aliases": ["Éditions Albin Michel"],
        "country": "FR",
        "siren": None,
        "role": "maison d'édition",
    },
]

BRANDS = [
    # Danone
    ("brand.danone", "Danone", ["Groupe Danone"], "alimentaire", "company.danone", "danone"),
    ("brand.evian", "Evian", ["Évian"], "alimentaire", "company.danone", "evian"),
    ("brand.activia", "Activia", [], "alimentaire", "company.danone", "activia"),
    ("brand.volvic", "Volvic", [], "alimentaire", "company.danone", "volvic"),
    # Nestlé
    ("brand.nestle", "Nestlé", ["Nestle"], "alimentaire", "company.nestle", "nestle"),
    ("brand.nespresso", "Nespresso", [], "alimentaire", "company.nestle", "nespresso"),
    ("brand.nescafe", "Nescafé", ["Nescafe"], "alimentaire", "company.nestle", "nescafe"),
    # Ferrero
    ("brand.nutella", "Nutella", [], "alimentaire", "company.ferrero", "nutella"),
    ("brand.kinder", "Kinder", [], "alimentaire", "company.ferrero", "kinder"),
    # Soft drinks / snacks
    ("brand.coca-cola", "Coca-Cola", ["Coca Cola", "Coke"], "alimentaire", "company.coca-cola", "coca-cola"),
    ("brand.pepsi", "Pepsi", ["Pepsi-Cola"], "alimentaire", "company.pepsico", "pepsi"),
    ("brand.lu", "LU", ["Lefèvre-Utile"], "alimentaire", "company.mondelez", "lu"),
    ("brand.milka", "Milka", [], "alimentaire", "company.mondelez", "milka"),
    # Hygiene
    ("brand.garnier", "Garnier", [], "hygiene", "company.loreal", "garnier"),
    ("brand.loreal-paris", "L'Oréal Paris", ["Loreal Paris", "L'Oreal Paris"], "hygiene", "company.loreal", "loreal-paris"),
    ("brand.dove", "Dove", [], "hygiene", "company.unilever", "dove"),
    ("brand.nivea", "Nivea", ["NIVEA"], "hygiene", "company.beiersdorf", "nivea"),
    # Retail
    ("brand.carrefour", "Carrefour", [], "distribution", "company.carrefour", "carrefour"),
    ("brand.relay", "Relay", ["Relay SA"], "distribution", "company.lagardere-sa", "relay"),
    ("brand.leclerc", "E.Leclerc", ["Leclerc", "E Leclerc"], "distribution", "company.e-leclerc", "leclerc"),
    ("brand.monoprix", "Monoprix", [], "distribution", "company.casino", "monoprix"),
    ("brand.intermarche", "Intermarché", ["Intermarché Super"], "distribution", "company.intermarche", "intermarche"),
    ("brand.lidl", "Lidl", [], "distribution", "company.lidl", "lidl"),
    ("brand.aldi", "Aldi", [], "distribution", "company.aldi", "aldi"),
    ("brand.casino", "Casino", [], "distribution", "company.casino", "casino"),
    ("brand.franprix", "Franprix", [], "distribution", "company.casino", "franprix"),
    ("brand.spar", "Spar", [], "distribution", "company.spar", "spar"),
    ("brand.netto", "Netto", [], "distribution", "company.netto", "netto"),
    # Edition (company known, no fortune in nucleus yet)
    ("brand.gallimard", "Gallimard", ["Éditions Gallimard"], "edition", "company.gallimard", "gallimard"),
    ("brand.folio", "Folio", [], "edition", "company.gallimard", "folio"),
    ("brand.pocket", "Pocket", ["éditions Pocket"], "edition", "company.editis", "pocket"),
    ("brand.flammarion", "Flammarion", ["Éditions Flammarion"], "edition", "company.flammarion", "flammarion"),
    ("brand.jai-lu", "J'ai lu", ["Jai lu"], "edition", "company.flammarion", "jai-lu"),
    ("brand.albin-michel", "Albin Michel", ["Éditions Albin Michel"], "edition", "company.albin-michel", "albin-michel"),
]

OWNERSHIPS = [
    {
        "ownedCompanyId": "company.relay",
        "owner": {"type": "company", "id": "company.lagardere-sa"},
        "capitalPercent": 100,
        "votingPercent": 100,
        "linkType": "control",
        "factDate": "2024-12-31",
        "sourceId": "source.relay-lagardere",
        "status": "active",
        "note": "Relay est une filiale à 100% de Lagardère SA.",
    },
    {
        "ownedCompanyId": "company.lagardere-sa",
        "owner": {"type": "fortune", "id": "fortune.bollore"},
        "capitalPercent": None,
        "votingPercent": None,
        "linkType": "control",
        "factDate": "2024-12-31",
        "sourceId": "source.lagardere-bollore",
        "status": "active",
        "note": "Lagardère SA est contrôlée par la famille Bolloré.",
    },
    {
        "ownedCompanyId": "company.gallimard",
        "owner": {"type": "company", "id": "company.madrigall"},
        "capitalPercent": None,
        "votingPercent": None,
        "linkType": "control",
        "factDate": "2024-12-31",
        "sourceId": "source.madrigall-groupe",
        "status": "active",
        "note": "Contrôle éditorial via le groupe Madrigall.",
    },
    {
        "ownedCompanyId": "company.flammarion",
        "owner": {"type": "company", "id": "company.madrigall"},
        "capitalPercent": None,
        "votingPercent": None,
        "linkType": "control",
        "factDate": "2024-12-31",
        "sourceId": "source.madrigall-groupe",
        "status": "active",
        "note": "Flammarion fait partie du groupe Madrigall.",
    },
]

SOURCES = [
    {
        "id": "source.madrigall-groupe",
        "title": "Le groupe Madrigall",
        "url": "https://www.gallimard.fr/",
        "publisher": "Gallimard / Madrigall",
    },
    {
        "id": "source.relay-lagardere",
        "title": "Relay - Filiale de Lagardère",
        "url": "https://www.relay.com/fr",
        "publisher": "Lagardère SA",
    },
    {
        "id": "source.lagardere-bollore",
        "title": "Lagardère - Contrôle par la famille Bolloré",
        "url": "https://www.lagardere.com/fr",
        "publisher": "Lagardère SA",
    },
]


def upsert(items: list[dict], key: str, rows: list[dict]) -> list[dict]:
    by_id = {row[key]: row for row in items}
    for row in rows:
        by_id[row[key]] = row
    return list(by_id.values())


def main() -> None:
    data = json.loads(PATH.read_text(encoding="utf-8"))
    data["version"] = "2026.10.3"
    data["updatedOn"] = "2026-10-06"
    for sector in ("alimentaire", "hygiene", "distribution"):
        if sector not in data["sectors"]:
            data["sectors"].append(sector)

    data["sources"] = upsert(data["sources"], "id", SOURCES)
    data["companies"] = upsert(data["companies"], "id", COMPANIES)

    brand_rows = []
    for brand_id, name, aliases, sector, company_id, slug in BRANDS:
        logo = ROOT / "assets" / "logos" / f"{slug}.png"
        row = {
            "id": brand_id,
            "name": name,
            "aliases": aliases,
            "sectors": [sector],
            "companyId": company_id,
        }
        if logo.exists():
            row["logoAsset"] = f"assets/logos/{slug}.png"
            row["logoSource"] = LOGO_NOTE
        brand_rows.append(row)
    data["brands"] = upsert(data["brands"], "id", brand_rows)

    # Ownerships: append if not already present for same owned+owner+status
    existing = {
        (
            o["ownedCompanyId"],
            o["owner"]["type"],
            o["owner"]["id"],
            o["status"],
        )
        for o in data["ownerships"]
    }
    for link in OWNERSHIPS:
        key = (
            link["ownedCompanyId"],
            link["owner"]["type"],
            link["owner"]["id"],
            link["status"],
        )
        if key not in existing:
            data["ownerships"].append(link)

    PATH.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        f"wrote {PATH} · brands={len(data['brands'])} "
        f"companies={len(data['companies'])} version={data['version']}"
    )


if __name__ == "__main__":
    main()
