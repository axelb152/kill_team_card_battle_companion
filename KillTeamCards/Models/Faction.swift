import Foundation

struct Operative: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let pages: [Int] // Support multiple pages (e.g., front/back)
}

struct Faction: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let pdfFile: String
    let type: String? // e.g., "Bespoke", "Compendium", "Legacy"
    let operatives: [Operative]
}
