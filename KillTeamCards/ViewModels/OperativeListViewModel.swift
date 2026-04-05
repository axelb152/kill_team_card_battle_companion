import Foundation

@MainActor
class OperativeListViewModel: ObservableObject {
    let faction: Faction
    @Published var selectedIds: Set<String> = []

    init(faction: Faction) {
        self.faction = faction
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
        } else {
            selectedIds.insert(operative.id)
        }
    }
}
