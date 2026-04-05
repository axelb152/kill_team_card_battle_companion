import PDFKit
import UIKit

class PDFPageProvider {
    static let shared = PDFPageProvider()

    private var cache: [String: PDFDocument] = [:]
    private let cacheLimit = 3

    private init() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            print("⚠️ Memory warning — clearing PDF cache")
            self?.cache.removeAll()
        }
    }

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
        let url = Bundle.main.bundleURL.appendingPathComponent("PDFs/\(filename)")
        print("📂 Opening PDF: \(filename)")
        guard let document = PDFDocument(url: url) else {
            print("❌ PDF not found: \(filename) — expected at \(url.path)")
            return nil
        }
        print("📂 PDF opened: \(filename) — \(document.pageCount) page(s)")
        evictIfNeeded()
        cache[filename] = document
        return document
    }

    private func evictIfNeeded() {
        guard cache.count >= cacheLimit else { return }
        cache.removeValue(forKey: cache.keys.first!)
    }
}
