import Foundation

@MainActor
class OperativeListViewModel: ObservableObject {
    let faction: Faction
    @Published var selectedIds: Set<String> = []

    init(faction: Faction) {
        self.faction = faction
        print("👥 Faction selected: \(faction.name) — \(faction.operatives.count) operatives")
    }

    var hasSelection: Bool {
        !selectedIds.isEmpty
    }

    /// Sorted 1-based page numbers for selected operatives.
    var selectedPages: [Int] {
        faction.operatives
            .filter { selectedIds.contains($0.id) }
            .map(\.page)
            .sorted()
    }

    func toggle(_ operative: Operative) {
        if selectedIds.contains(operative.id) {
            selectedIds.remove(operative.id)
            print("☑️ Deselected: \(operative.name) — \(selectedIds.count) selected")
        } else {
            selectedIds.insert(operative.id)
            print("☑️ Selected: \(operative.name) — \(selectedIds.count) selected, pages: \(selectedPages)")
        }
    }
}
