import SwiftUI
import PDFKit

struct PDFPageView: UIViewRepresentable {
    let page: PDFPage

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.autoScales = true
        pdfView.backgroundColor = .black
        // Disable PDFView's own gestures — TabView owns all swipe input
        pdfView.isUserInteractionEnabled = false
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // document must be set before go(to:) — PDFView silently ignores
        // go(to:) calls made before its document property is populated.
        if let doc = page.document, uiView.document !== doc {
            uiView.document = doc
        }
        if uiView.currentPage != page {
            uiView.go(to: page)
        }
    }
}
