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
        } catch {
            loadError = error.localizedDescription
        }
    }
}
