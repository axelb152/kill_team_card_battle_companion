# Kill Team Cards

An unofficial fan-made iOS app for Warhammer Kill Team. Select your faction, pick your operatives, and enter a fullscreen landscape card viewer to reference operative data cards during a game — no internet required.

> **Disclaimer:** This is an unofficial fan-made app and is not affiliated with, endorsed by, or connected to Games Workshop in any way. Kill Team, Warhammer, and all related names and imagery are trademarks or registered trademarks of Games Workshop Ltd. Operative data cards are free official downloads from Warhammer Community and remain the property of Games Workshop.

---

## Screenshots

_Coming soon_

---

## Features

- Faction grid — browse and select your Kill Team
- Operative checklist — pick which operatives to bring to the table
- Fullscreen landscape card viewer with left/right swipe navigation
- Grid overlay to jump between cards at a glance
- Chrome UI fades after 3 seconds for a clean reading experience
- Fully offline — no network requests at runtime
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

The filename must exactly match the `pdfFile` field in `faction-manifest.json` (e.g. `angels-of-death.pdf`).

> The `PDFs/` folder at the repo root is for your own local copies and is git-ignored. Only files inside `KillTeamCards/Resources/PDFs/` are bundled into the app.

### 3. Update the manifest

Open `KillTeamCards/Resources/faction-manifest.json` and add or edit entries to match the PDFs you have. Each operative's `page` field is the **1-based page number** in the PDF for that operative's card.

```json
{
  "factions": [
    {
      "id": "angels-of-death",
      "name": "Angels of Death",
      "pdfFile": "angels-of-death.pdf",
      "operatives": [
        { "name": "Assault Intercessor Sergeant", "page": 2 },
        { "name": "Intercessor", "page": 3 }
      ]
    }
  ]
}
```

| Field | Description |
|-------|-------------|
| `id` | Unique lowercase slug, no spaces (e.g. `angels-of-death`) |
| `name` | Display name shown in the app |
| `pdfFile` | Exact filename of the PDF in `KillTeamCards/Resources/PDFs/` |
| `operatives[].name` | Operative name shown in the checklist |
| `operatives[].page` | 1-based page number in the PDF |

### 4. Build and run

Open `KillTeamCards.xcodeproj` in Xcode, select an iPhone simulator or device, and press **Run** (⌘R).

> **Note:** PDF rendering is significantly slower in the iOS Simulator than on a real device. For the smoothest experience, run on hardware.

---

## Requirements

- Xcode 15+
- iOS 16+
- iPhone (portrait navigation, landscape Battle Mode)

---

## Contributing

Pull requests welcome. If you add faction manifests for PDFs you've verified page numbers for, please share them — the community benefits.

---

## License

MIT — see [LICENSE](LICENSE)
