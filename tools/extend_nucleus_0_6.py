from PIL import Image, ImageDraw, ImageFont
from pathlib import Path
import json

marks = [
    ("tf1", "T1", (11, 11, 15), (255, 61, 90)),
    ("bouygues-telecom", "BT", (11, 11, 15), (200, 255, 61)),
    ("geo", "G", (11, 11, 15), (18, 184, 134)),
    ("capital", "C", (11, 11, 15), (200, 255, 61)),
    ("femme-actuelle", "FA", (11, 11, 15), (255, 61, 90)),
    ("tele-loisirs", "TL", (11, 11, 15), (18, 184, 134)),
    ("calmann-levy", "CL", (11, 11, 15), (200, 255, 61)),
    ("larousse", "L", (11, 11, 15), (255, 61, 90)),
    ("livre-de-poche", "LP", (11, 11, 15), (18, 184, 134)),
    ("stock", "S", (11, 11, 15), (200, 255, 61)),
    ("jc-lattes", "JL", (11, 11, 15), (255, 61, 90)),
    ("hachette-livre", "H", (11, 11, 15), (18, 184, 134)),
    ("editis", "E", (11, 11, 15), (92, 92, 102)),
]

size = 256
out = Path("assets/logos")
for slug, text, bg, accent in marks:
    img = Image.new("RGB", (size, size), bg)
    draw = ImageDraw.Draw(img)
    draw.rectangle([0, 0, 28, size], fill=accent)
    draw.rectangle([0, size - 28, size, size], fill=accent)
    try:
        font = ImageFont.truetype("arialbd.ttf", 110 if len(text) == 1 else 78)
    except Exception:
        font = ImageFont.load_default()
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (size - tw) / 2 + 8
    y = (size - th) / 2 - 8
    draw.text((x, y), text, fill=(247, 247, 242), font=font)
    path = out / f"{slug}.png"
    img.save(path, "PNG")
    print("wrote", path)

path = Path("assets/library/library.json")
data = json.loads(path.read_text(encoding="utf-8"))
data["version"] = "2026.10.2"
data["updatedOn"] = "2026-10-06"
if "media" not in data["sectors"]:
    data["sectors"].append("media")

sources = {s["id"]: s for s in data["sources"]}
sources["source.tf1-rapport-2025"] = {
    "id": "source.tf1-rapport-2025",
    "title": "Rapport d'activité 2025",
    "url": "https://groupe-tf1.fr/sites/default/files/pdf-financiers/Rapport%20d%27activit%C3%A9%20TF1%20FY%202025.pdf",
    "publisher": "TF1",
}
sources["source.prisma-activites"] = {
    "id": "source.prisma-activites",
    "title": "Activités",
    "url": "https://www.prismamedia.com/groupe/activites/",
    "publisher": "Prisma Media",
}
data["sources"] = list(sources.values())

companies = {c["id"]: c for c in data["companies"]}
companies["company.tf1"] = {
    "id": "company.tf1",
    "name": "TF1",
    "aliases": ["Groupe TF1", "TF1 SA"],
    "country": "FR",
    "siren": None,
    "role": "groupe opérationnel",
}
companies["company.bouygues-telecom"] = {
    "id": "company.bouygues-telecom",
    "name": "Bouygues Telecom",
    "aliases": ["Bouygues Télécom"],
    "country": "FR",
    "siren": None,
    "role": "groupe opérationnel",
}
data["companies"] = list(companies.values())

logo_source = (
    "Monogramme Céaki — identité géométrique, pas une reproduction de marque déposée"
)
logo_for = {
    "brand.calmann-levy": "assets/logos/calmann-levy.png",
    "brand.larousse": "assets/logos/larousse.png",
    "brand.livre-de-poche": "assets/logos/livre-de-poche.png",
    "brand.stock": "assets/logos/stock.png",
    "brand.jc-lattes": "assets/logos/jc-lattes.png",
    "brand.hachette-livre": "assets/logos/hachette-livre.png",
    "brand.editis": "assets/logos/editis.png",
}
for brand in data["brands"]:
    asset = logo_for.get(brand["id"])
    if asset:
        brand["logoAsset"] = asset
        brand["logoSource"] = logo_source

new_brands = [
    {
        "id": "brand.tf1",
        "name": "TF1",
        "aliases": ["TF1+"],
        "sectors": ["media"],
        "companyId": "company.tf1",
        "logoAsset": "assets/logos/tf1.png",
        "logoSource": logo_source,
    },
    {
        "id": "brand.bouygues-telecom",
        "name": "Bouygues Telecom",
        "aliases": ["Bouygues Télécom", "B&You"],
        "sectors": ["telecom"],
        "companyId": "company.bouygues-telecom",
        "logoAsset": "assets/logos/bouygues-telecom.png",
        "logoSource": logo_source,
    },
    {
        "id": "brand.geo",
        "name": "GEO",
        "aliases": ["Géo"],
        "sectors": ["presse"],
        "companyId": "company.prisma-media",
        "logoAsset": "assets/logos/geo.png",
        "logoSource": logo_source,
    },
    {
        "id": "brand.capital",
        "name": "Capital",
        "aliases": [],
        "sectors": ["presse"],
        "companyId": "company.prisma-media",
        "logoAsset": "assets/logos/capital.png",
        "logoSource": logo_source,
    },
    {
        "id": "brand.femme-actuelle",
        "name": "Femme Actuelle",
        "aliases": [],
        "sectors": ["presse"],
        "companyId": "company.prisma-media",
        "logoAsset": "assets/logos/femme-actuelle.png",
        "logoSource": logo_source,
    },
    {
        "id": "brand.tele-loisirs",
        "name": "Télé-Loisirs",
        "aliases": ["Tele Loisirs", "Télé Loisirs"],
        "sectors": ["presse"],
        "companyId": "company.prisma-media",
        "logoAsset": "assets/logos/tele-loisirs.png",
        "logoSource": logo_source,
    },
]
existing = {b["id"] for b in data["brands"]}
for brand in new_brands:
    if brand["id"] not in existing:
        data["brands"].append(brand)

ownership_keys = {
    (o["ownedCompanyId"], o["owner"]["type"], o["owner"]["id"], o["status"])
    for o in data["ownerships"]
}
new_owns = [
    {
        "ownedCompanyId": "company.tf1",
        "owner": {"type": "company", "id": "company.bouygues"},
        "capitalPercent": "46.8",
        "votingPercent": "46.8",
        "linkType": "reference_shareholder",
        "factDate": "2025-12-31",
        "sourceId": "source.tf1-rapport-2025",
        "status": "active",
        "note": "Actionnaire de référence selon le rapport d'activité TF1 2025.",
    },
    {
        "ownedCompanyId": "company.bouygues-telecom",
        "owner": {"type": "company", "id": "company.bouygues"},
        "capitalPercent": None,
        "votingPercent": None,
        "linkType": "subsidiary",
        "factDate": "2025-12-31",
        "sourceId": "source.bouygues-deu-2025",
        "status": "active",
        "note": "Métier Télécoms du groupe Bouygues. Le document ne donne pas de pourcentage.",
    },
]
for own in new_owns:
    key = (
        own["ownedCompanyId"],
        own["owner"]["type"],
        own["owner"]["id"],
        own["status"],
    )
    if key not in ownership_keys:
        data["ownerships"].append(own)

path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("library updated", data["version"], "brands", len(data["brands"]))
