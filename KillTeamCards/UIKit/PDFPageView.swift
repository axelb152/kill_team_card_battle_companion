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
        guard uiView.currentPage != page else { return }
        uiView.go(to: page)
    }
}
