import Foundation

enum ManifestError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(Error)
    case encodingFailed(Error)
    case writeFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "faction-manifest.json not found."
        case .decodingFailed(let error):
            return "Failed to decode manifest: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode manifest: \(error.localizedDescription)"
        case .writeFailed(let error):
            return "Failed to save manifest: \(error.localizedDescription)"
        }
    }
}

struct ManifestLoader {
    private static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("faction-manifest.json")
    }

    private static var bundleURL: URL? {
        Bundle.main.url(forResource: "faction-manifest", withExtension: "json")
    }

    static func load() throws -> FactionManifest {
        print("📋 Loading faction-manifest.json from Documents…")
        
        // 1. Ensure initial file exists in Documents
        try copyInitialManifestIfNeeded()
        
        // 2. Load from Documents
        do {
            let data = try Data(contentsOf: documentsURL)
            let manifest = try JSONDecoder().decode(FactionManifest.self, from: data)
            print("📋 Manifest OK — \(manifest.factions.count) faction(s)")
            return manifest
        } catch {
            print("❌ Manifest decode error: \(error)")
            throw ManifestError.decodingFailed(error)
        }
    }

    static func save(manifest: FactionManifest) throws {
        print("💾 Saving manifest to Documents…")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(manifest)
            try data.write(to: documentsURL, options: .atomic)
            print("💾 Manifest saved successfully")
        } catch let error as EncodingError {
            throw ManifestError.encodingFailed(error)
        } catch {
            throw ManifestError.writeFailed(error)
        }
    }

    private static func copyInitialManifestIfNeeded() throws {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: documentsURL.path) {
            print("🚚 First launch: Copying bundled manifest to Documents…")
            guard let bundleURL = bundleURL else {
                throw ManifestError.fileNotFound
            }
            try fileManager.copyItem(at: bundleURL, to: documentsURL)
        }
    }
}
