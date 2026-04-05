import Foundation

@MainActor
class OperativeListViewModel: ObservableObject {
    @Published var faction: Faction
    @Published var selectedIds: Set<String> = []
    @Published var isEditMode = false
    
    var onSave: ((Faction) -> Void)?

    init(faction: Faction, onSave: ((Faction) -> Void)? = nil) {
        self.faction = faction
        self.onSave = onSave
        print("👥 Faction selected: \(faction.name) — \(faction.operatives.count) operatives")
    }

    var hasSelection: Bool {
        !selectedIds.isEmpty
    }

    /// Sorted 1-based page numbers for all selected operatives.
    /// Supports multi-page operatives by flatMapping the pages array.
    var selectedPages: [Int] {
        faction.operatives
            .filter { selectedIds.contains($0.id) }
            .flatMap(\.pages)
            .sorted()
    }

    func toggle(_ operative: Operative) {
        if isEditMode { return }
        
        if selectedIds.contains(operative.id) {
            selectedIds.remove(operative.id)
            print("☑️ Deselected: \(operative.name) — \(selectedIds.count) selected")
        } else {
            selectedIds.insert(operative.id)
            print("☑️ Selected: \(operative.name) — \(selectedIds.count) selected, pages: \(selectedPages)")
        }
    }

    // MARK: - Management

    func addOperative(name: String, pages: [Int]) {
        let newOperative = Operative(name: name, pages: pages)
        var updatedOperatives = faction.operatives
        updatedOperatives.append(newOperative)
        
        // Faction is a struct (value type), so we create a new one
        let newFaction = Faction(
            id: faction.id,
            name: faction.name,
            pdfFile: faction.pdfFile,
            type: faction.type,
            operatives: updatedOperatives
        )
        self.faction = newFaction
        onSave?(newFaction)
    }

    func deleteOperative(at offsets: IndexSet) {
        var updatedOperatives = faction.operatives
        updatedOperatives.remove(atOffsets: offsets)
        
        let newFaction = Faction(
            id: faction.id,
            name: faction.name,
            pdfFile: faction.pdfFile,
            type: faction.type,
            operatives: updatedOperatives
        )
        self.faction = newFaction
        onSave?(newFaction)
    }

    func updateOperative(_ operative: Operative) {
        var updatedOperatives = faction.operatives
        if let index = updatedOperatives.firstIndex(where: { $0.id == operative.id }) {
            updatedOperatives[index] = operative
            
            let newFaction = Faction(
                id: faction.id,
                name: faction.name,
                pdfFile: faction.pdfFile,
                type: faction.type,
                operatives: updatedOperatives
            )
            self.faction = newFaction
            onSave?(newFaction)
        }
    }
}
