import SwiftUI
import PDFKit

struct BattleModeView: View {
    let session: SelectedSession
    @StateObject private var viewModel = BattleModeViewModel()
    @Environment(\.dismiss) private var dismiss

    private var pages: [PDFPage] {
        session.selectedPages.compactMap {
            PDFPageProvider.shared.page(from: session.faction.pdfFile, pageNumber: $0)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if pages.isEmpty {
                noPDFView
            } else {
                cardPager
                    .allowsHitTesting(!viewModel.isOverlayVisible)

                chrome
                    .opacity(viewModel.isChromeVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.4), value: viewModel.isChromeVisible)

                // Phase 5: QuadrantOverlayView inserted here
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            viewModel.resetTimer()
        }
        .onChange(of: viewModel.currentIndex) { _ in
            viewModel.resetTimer()
        }
        .onAppear {
            OrientationHelper.lock(.landscape)
            viewModel.resetTimer()
        }
        .onDisappear {
            OrientationHelper.lock(.portrait)
            viewModel.cancelTimer()
        }
    }

    // MARK: - Card pager

    private var cardPager: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                PDFPageView(page: page)
                    .tag(index)
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }

    // MARK: - Chrome overlay

    private var chrome: some View {
        VStack {
            HStack {
                Button {
                    viewModel.isOverlayVisible = true
                    viewModel.resetTimer()
                } label: {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Open card grid")

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .accessibilityLabel("Exit Battle Mode")
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer()
        }
    }

    // MARK: - No PDF error state

    private var noPDFView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.35))

            Text("PDF not found")
                .font(.headline)
                .foregroundColor(.white)

            Text("Add \(session.faction.pdfFile) to\nKillTeamCards/Resources/PDFs/\nthen rebuild the app.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Button("Exit") { dismiss() }
                .foregroundColor(.white.opacity(0.6))
                .padding(.top, 8)
        }
        .onAppear { OrientationHelper.lock(.landscape) }
        .onDisappear { OrientationHelper.lock(.portrait) }
    }
}
