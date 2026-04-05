import Foundation

@MainActor
class FactionListViewModel: ObservableObject {
    @Published var factions: [Faction] = []
    @Published var loadError: String?

    init() {
        load()
    }

    private func load() {
        do {
            let manifest = try ManifestLoader.load()
            factions = manifest.factions
            print("🗂 FactionList ready — \(factions.count) tile(s) visible")
        } catch {
            print("❌ FactionList load failed: \(error.localizedDescription)")
            loadError = error.localizedDescription
        }
    }
}
