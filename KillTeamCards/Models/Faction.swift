import Foundation

struct Operative: Codable, Identifiable {
    var id: String { name }
    let name: String
    let page: Int
}

struct Faction: Codable, Identifiable {
    let id: String
    let name: String
    let pdfFile: String
    let operatives: [Operative]
}
