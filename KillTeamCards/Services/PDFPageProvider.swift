import PDFKit

class PDFPageProvider {
    static let shared = PDFPageProvider()

    private var cache: [String: PDFDocument] = [:]
    private let cacheLimit = 3

    /// Returns the PDFPage for a 1-based page number from the named PDF file.
    func page(from pdfFile: String, pageNumber: Int) -> PDFPage? {
        guard let document = loadDocument(named: pdfFile) else { return nil }
        return document.page(at: pageNumber - 1)   // PDFDocument is 0-indexed
    }

    /// All pages in a PDF, in order.
    func allPages(from pdfFile: String) -> [PDFPage] {
        guard let document = loadDocument(named: pdfFile) else { return [] }
        return (0..<document.pageCount).compactMap { document.page(at: $0) }
    }

    private func loadDocument(named filename: String) -> PDFDocument? {
        if let cached = cache[filename] {
            return cached
        }
        // PDFs are bundled via a folder reference — they land at the bundle root inside PDFs/
        let url = Bundle.main.bundleURL.appendingPathComponent("PDFs/\(filename)")
        guard let document = PDFDocument(url: url) else {
            print("PDFPageProvider: could not open \(filename) at \(url.path)")
            return nil
        }
        evictIfNeeded()
        cache[filename] = document
        return document
    }

    private func evictIfNeeded() {
        guard cache.count >= cacheLimit else { return }
        cache.removeValue(forKey: cache.keys.first!)
    }
}
