import Foundation

struct Operative: Codable, Identifiable, Hashable {
    var id: String { name }
    let name: String
    let page: Int
}

struct Faction: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let pdfFile: String
    let operatives: [Operative]
}
