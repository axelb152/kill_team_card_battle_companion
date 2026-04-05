import SwiftUI
import PDFKit

struct QuadrantOverlayView: View {
    let pages: [PDFPage]
    @ObservedObject var viewModel: BattleModeViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack {
            // Tappable backdrop — closes overlay without navigating
            Color.black.opacity(0.82)
                .ignoresSafeArea()
                .onTapGesture {
                    print("🔲 Overlay dismissed (background tap)")
                    viewModel.isOverlayVisible = false
                }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        ThumbnailCell(
                            page: page,
                            isSelected: index == viewModel.currentIndex
                        ) {
                            print("🔲 Overlay: jumped to card \(index + 1)/\(pages.count)")
                            viewModel.navigateTo(index: index)
                        }
                    }
                }
                .padding(16)
            }
            // Prevent scroll taps from hitting the backdrop gesture
            .simultaneousGesture(TapGesture().onEnded { })
        }
    }
}

// MARK: - Thumbnail cell

private struct ThumbnailCell: View {
    let page: PDFPage
    let isSelected: Bool
    let onTap: () -> Void

    @State private var thumbnail: UIImage?

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Color.white.opacity(0.06)

                if let image = thumbnail {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    ProgressView()
                        .tint(.white.opacity(0.5))
                }
            }
            .aspectRatio(0.72, contentMode: .fit)   // portrait card ratio
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? Color.white : Color.white.opacity(0.15),
                            lineWidth: isSelected ? 2 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .onAppear {
            guard thumbnail == nil else { return }
            let capturedPage = page
            Task {
                let img = await Task.detached(priority: .utility) {
                    capturedPage.thumbnail(of: CGSize(width: 200, height: 280), for: .mediaBox)
                }.value
                thumbnail = img
            }
        }
    }
}
