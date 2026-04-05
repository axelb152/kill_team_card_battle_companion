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
        guard let url = Bundle.main.url(forResource: "faction-manifest", withExtension: "json") else {
            throw ManifestError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(FactionManifest.self, from: data)
        } catch let error as DecodingError {
            throw ManifestError.decodingFailed(error)
        }
    }
}
