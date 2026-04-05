import SwiftUI

@main
struct KillTeamCardsApp: App {
    init() {
        verifyManifest()
    }

    var body: some Scene {
        WindowGroup {
            Text("Kill Team Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        }
    }

    private func verifyManifest() {
        do {
            let manifest = try ManifestLoader.load()
            print("✅ Manifest loaded: \(manifest.factions.count) faction(s)")
            for faction in manifest.factions {
                print("  → \(faction.name): \(faction.operatives.count) operatives")
            }
        } catch {
            print("❌ Manifest load failed: \(error.localizedDescription)")
        }
    }
}
