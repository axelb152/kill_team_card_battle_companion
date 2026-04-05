import Foundation
import Combine

@MainActor
class FactionListViewModel: ObservableObject {
    @Published var factions: [Faction] = []
    @Published var availableFilenames: Set<String> = []
    @Published var loadError: String?
    
    @Published var isEditMode = false

    init() {
        load()
        refreshAvailability()
    }

    func load() {
        do {
            let manifest = try ManifestLoader.load()
            self.factions = manifest.factions
            print("🗂 FactionList ready — \(factions.count) faction(s)")
        } catch {
            print("❌ FactionList load failed: \(error.localizedDescription)")
            loadError = error.localizedDescription
        }
    }

    func refreshAvailability() {
        self.availableFilenames = PDFImportService.availableFilenames()
    }

    func isAvailable(_ faction: Faction) -> Bool {
        availableFilenames.contains(faction.pdfFile)
    }

    // MARK: - Management

    func save() {
        do {
            try ManifestLoader.save(manifest: FactionManifest(factions: factions))
            print("💾 Manifest updated and saved")
        } catch {
            print("❌ Failed to save manifest: \(error)")
        }
    }

    func addFaction(name: String, pdfFile: String, type: String = "Bespoke") {
        let newFaction = Faction(
            id: name.lowercased().replacingOccurrences(of: " ", with: "-"),
            name: name,
            pdfFile: pdfFile,
            type: type,
            operatives: []
        )
        factions.append(newFaction)
        save()
    }

    func deleteFaction(at offsets: IndexSet) {
        factions.remove(atOffsets: offsets)
        save()
    }

    func updateFaction(_ faction: Faction) {
        if let index = factions.firstIndex(where: { $0.id == faction.id }) {
            factions[index] = faction
            save()
        }
    }
}
