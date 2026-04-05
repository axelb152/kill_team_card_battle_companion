import Foundation

enum ManifestError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "faction-manifest.json not found in app bundle."
        case .decodingFailed(let error):
            return "Failed to decode manifest: \(error.localizedDescription)"
        }
    }
}

struct ManifestLoader {
    static func load() throws -> FactionManifest {
        print("📋 Loading faction-manifest.json…")
        guard let url = Bundle.main.url(forResource: "faction-manifest", withExtension: "json") else {
            print("❌ faction-manifest.json not found in bundle")
            throw ManifestError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            let manifest = try JSONDecoder().decode(FactionManifest.self, from: data)
            print("📋 Manifest OK — \(manifest.factions.count) faction(s): \(manifest.factions.map(\.name).joined(separator: ", "))")
            return manifest
        } catch let error as DecodingError {
            print("❌ Manifest decode error: \(error)")
            throw ManifestError.decodingFailed(error)
        }
    }
}
