import Foundation

/// Manages user-imported PDF files stored in the app's Documents/PDFs/ directory.
/// The app no longer bundles PDFs; users download them from Warhammer Community
/// and import them via the iOS Files picker.
enum PDFImportService {

    // MARK: - Paths

    /// The app's Documents/PDFs/ directory. Created on first access.
    static var documentsURL: URL {
        let base = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("PDFs", isDirectory: true)
        // Create the directory if it doesn't exist yet (safe to call repeatedly).
        try? FileManager.default.createDirectory(
            at: base,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return base
    }

    /// Full URL for a specific PDF filename inside Documents/PDFs/.
    static func pdfURL(for filename: String) -> URL {
        documentsURL.appendingPathComponent(filename)
    }

    // MARK: - Availability

    /// Returns true if the PDF for the given filename exists in Documents/PDFs/.
    static func isAvailable(_ filename: String) -> Bool {
        FileManager.default.fileExists(atPath: pdfURL(for: filename).path)
    }

    /// Scans Documents/PDFs/ and returns the set of PDF filenames currently present.
    /// Returns an empty set if the directory doesn't exist or can't be read.
    static func availableFilenames() -> Set<String> {
        guard let items = try? FileManager.default.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        let pdfs = items.filter { $0.pathExtension.lowercased() == "pdf" }
        return Set(pdfs.map { $0.lastPathComponent })
    }

    // MARK: - Import

    /// Imports a PDF picked via the iOS Files picker into Documents/PDFs/ with the
    /// canonical filename defined by the faction manifest. Handles security-scoped
    /// resource access, overwrites any existing file, and propagates FileManager errors.
    ///
    /// - Parameters:
    ///   - sourceURL: The URL returned by the fileImporter result (security-scoped).
    ///   - filename:  The canonical filename to save as (e.g. "angels-of-death.pdf").
    static func importPDF(from sourceURL: URL, as filename: String) throws {
        // 1. Ensure Documents/PDFs/ exists.
        try FileManager.default.createDirectory(
            at: documentsURL,
            withIntermediateDirectories: true,
            attributes: nil
        )

        // 2. Begin security-scoped access (required for URLs from fileImporter).
        let didStartAccess = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccess {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        // 3. Build destination URL.
        let destinationURL = pdfURL(for: filename)

        // 4. Remove any existing file (re-import / replacement flow).
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }

        // 5. Copy from the security-scoped source location into Documents/PDFs/.
        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)

        print("📥 PDF imported: \(filename) → \(destinationURL.path)")
    }
}
