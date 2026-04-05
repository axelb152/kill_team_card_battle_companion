# Kill Team Cards

An unofficial fan-made iOS app for Warhammer Kill Team. Select your faction, pick your operatives, and enter a fullscreen card viewer to reference your operative data cards during a game — no internet required.

> **Disclaimer:** This is an unofficial fan-made app and is not affiliated with, endorsed by, or connected to Games Workshop in any way. Kill Team, Warhammer, and all related names and imagery are trademarks or registered trademarks of Games Workshop Ltd. Operative data cards are free official downloads from Warhammer Community and remain the property of Games Workshop.

---

## Screenshots

_Coming soon_

---

## Features

- Browse factions in a grid and select your team
- Checklist to pick which operatives to bring
- Fullscreen landscape card viewer with swipe navigation
- Grid overlay to jump between cards quickly
- Fully offline — no network required
- Dark theme throughout

---

## Setup

### 1. Download PDFs

Operative data card PDFs are **not included** in this repository. Download them free from the official Warhammer Community site:

**https://www.warhammer-community.com/en-gb/downloads/kill-team**

Download the PDF for each faction you want to use.

### 2. Add PDFs to the app

Place your downloaded PDFs inside the Xcode project at:

```
KillTeamCards/Resources/PDFs/
```

The filename must match the `pdfFile` field in `faction-manifest.json` exactly (e.g. `angels-of-death.pdf`).

> The `PDFs/` folder at the repo root is provided for your own local storage and is git-ignored. Only the files inside `KillTeamCards/Resources/PDFs/` are bundled into the app.

### 3. Update the manifest

Open `KillTeamCards/Resources/faction-manifest.json` and add or edit factions to match the PDFs you've downloaded. Each operative's `page` field is the **1-based page number** in the PDF for that operative's card.

```json
{
  "factions": [
    {
      "id": "angels-of-death",
      "name": "Angels of Death",
      "pdfFile": "angels-of-death.pdf",
      "operatives": [
        { "name": "Assault Intercessor Sergeant", "page": 1 },
        { "name": "Assault Intercessor", "page": 2 }
      ]
    }
  ]
}
```

Fields:
| Field | Description |
|-------|-------------|
| `id` | Unique lowercase slug (no spaces) |
| `name` | Display name shown in the app |
| `pdfFile` | Exact filename of the PDF in `KillTeamCards/Resources/PDFs/` |
| `operatives[].name` | Operative display name |
| `operatives[].page` | 1-based page number in the PDF |

### 4. Build and run

Open `KillTeamCards.xcodeproj` in Xcode, select an iPhone simulator, and press **Run** (⌘R).

---

## Requirements

- Xcode 15+
- iOS 16+
- iPhone (portrait + landscape)

---

## License

MIT — see [LICENSE](LICENSE)
