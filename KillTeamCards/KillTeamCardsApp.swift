import SwiftUI

@main
struct KillTeamCardsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        verifyManifest()
    }

    var body: some Scene {
        WindowGroup {
            OrientationTestView()
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

// MARK: - Phase 2 test view (replaced in Phase 3)
private struct OrientationTestView: View {
    @State private var isLandscape = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Kill Team Cards")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Current: \(isLandscape ? "Landscape" : "Portrait")")
                .foregroundColor(.gray)

            Button(isLandscape ? "Switch to Portrait" : "Switch to Landscape") {
                isLandscape.toggle()
                OrientationHelper.lock(isLandscape ? .landscape : .portrait)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.15))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }
}
