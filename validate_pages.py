#!/usr/bin/env python3
"""
Validates and corrects faction-manifest.json page references against actual PDF contents.
Uses pdftotext (poppler) to extract text page-by-page.

Logic:
- Each operative's card starts on a specific PDF page (card front).
- Some cards have a separate back page: detected when the operative name is
  the first content line of the next page.
- Summary/rules pages (which also mention operative names) are ignored by
  requiring that "APL" appears near the top of a candidate card-front page.
"""

import json
import subprocess
import re
import copy
from pathlib import Path

MANIFEST_PATH = Path("/Users/axel/projects/kill_team_app_card/KillTeamCards/Resources/faction-manifest.json")
PDF_DIR = Path("/Users/axel/Downloads/pdf_kt_teams")


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True, timeout=30).stdout


def get_page_text(pdf_path, page_num):
    return run(["pdftotext", "-f", str(page_num), "-l", str(page_num), str(pdf_path), "-"])


def get_pdf_page_count(pdf_path):
    for line in run(["pdfinfo", str(pdf_path)]).splitlines():
        if line.startswith("Pages:"):
            return int(line.split(":")[1].strip())
    return 0


def normalize(text):
    return re.sub(r"\s+", " ", re.sub(r"[^a-z0-9 ]", " ", text.lower())).strip()


def name_as_exact_line(op_name, text):
    """Check if op_name appears as its own exact line anywhere in text."""
    norm_name = normalize(op_name)
    return any(normalize(line) == norm_name for line in text.splitlines() if line.strip())


def is_card_front_page(page_text, op_name):
    """A card-front page has 'APL' near the top and contains the operative name as a line."""
    first_chunk = page_text[:150].upper()
    if "APL" not in first_chunk:
        return False
    return name_as_exact_line(op_name, page_text)


def first_line_is_name(page_text, op_name):
    """True if the first non-empty line of page_text exactly matches the operative name."""
    norm_name = normalize(op_name)
    lines = [normalize(l.strip()) for l in page_text.splitlines() if l.strip()]
    return bool(lines) and lines[0] == norm_name


def find_operative_pages(op_name, all_pages):
    """
    Returns the correct [pages] list for an operative.
    - first_card_page: first page where APL + operative name both appear
    - If next page starts with operative name: card has 2 pages
    """
    # Find first card-front page
    first_card_page = None
    for pnum in sorted(all_pages.keys()):
        if is_card_front_page(all_pages[pnum], op_name):
            first_card_page = pnum
            break

    if first_card_page is None:
        return None  # operative not found

    # Check if next page is the card back
    next_page = first_card_page + 1
    if next_page in all_pages and first_line_is_name(all_pages[next_page], op_name):
        return [first_card_page, next_page]
    else:
        return [first_card_page]


def main():
    with open(MANIFEST_PATH) as f:
        manifest = json.load(f)

    changes = []
    unresolved = []

    for faction in manifest["factions"]:
        faction_id = faction["id"]
        pdf_file = faction.get("pdfFile", "")
        pdf_path = PDF_DIR / pdf_file

        if not pdf_path.exists():
            unresolved.append(f"PDF not found: {pdf_path}")
            continue

        num_pages = get_pdf_page_count(pdf_path)
        if num_pages == 0:
            unresolved.append(f"Could not get page count for: {pdf_file}")
            continue

        print(f"\n{'='*60}")
        print(f"Faction: {faction['name']}  ({pdf_file}, {num_pages} pages)")

        # Extract all pages at once
        all_pages = {}
        for p in range(1, num_pages + 1):
            all_pages[p] = get_page_text(pdf_path, p)

        for operative in faction.get("operatives", []):
            op_name = operative["name"]
            current_pages = operative.get("pages", [])

            correct_pages = find_operative_pages(op_name, all_pages)

            if correct_pages is None:
                status = f"[UNRESOLVED] not found in PDF"
                print(f"  {status}: '{op_name}' (current JSON: {current_pages})")
                unresolved.append(f"{faction['name']} / '{op_name}' — not found in PDF (current: {current_pages})")
                continue

            if correct_pages != current_pages:
                print(f"  [CHANGE] '{op_name}': {current_pages} → {correct_pages}")
                changes.append({
                    "faction": faction["name"],
                    "operative": op_name,
                    "old_pages": current_pages,
                    "new_pages": correct_pages,
                })
                operative["pages"] = correct_pages
            else:
                print(f"  [OK]     '{op_name}': {current_pages}")

    # Write corrected manifest
    with open(MANIFEST_PATH, "w") as f:
        json.dump(manifest, f, indent=2)
    print(f"\nManifest written to: {MANIFEST_PATH}")

    # Print summary
    print("\n" + "="*60)
    print("SUMMARY OF CHANGES")
    print("="*60)

    if changes:
        print(f"\nJSON fields changed ({len(changes)}):")
        for c in changes:
            print(f"  {c['faction']} / {c['operative']}: {c['old_pages']} → {c['new_pages']}")
    else:
        print("\nNo JSON changes needed.")

    if unresolved:
        print(f"\nUnresolved ({len(unresolved)}):")
        for u in unresolved:
            print(f"  {u}")
    else:
        print("\nAll operatives resolved successfully.")


if __name__ == "__main__":
    main()
