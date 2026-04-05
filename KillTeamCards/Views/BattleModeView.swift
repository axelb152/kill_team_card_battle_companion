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

                if viewModel.isOverlayVisible {
                    QuadrantOverlayView(pages: pages, viewModel: viewModel)
                        .transition(.opacity)
                }
            }
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.2), value: viewModel.isOverlayVisible)
        .onTapGesture {
            viewModel.resetTimer()
        }
        .onChange(of: viewModel.currentIndex) { newIndex in
            print("📄 Card \(newIndex + 1)/\(pages.count)")
            viewModel.resetTimer()
        }
        .onAppear {
            print("⚔️ Battle Mode opened — \(session.faction.name), \(pages.count) card(s), pages: \(session.selectedPages)")
            OrientationHelper.lock(.landscape)
            viewModel.resetTimer()
        }
        .onDisappear {
            print("🚪 Battle Mode closed")
            OrientationHelper.lock(.portrait)
            viewModel.cancelTimer()
        }
    }

    // MARK: - Card pager

    private var cardPager: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                PDFPageView(page: page)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .onAppear {
            print("⚔️ Battle Mode (no PDF) — \(session.faction.pdfFile) not found in bundle")
            OrientationHelper.lock(.landscape)
        }
        .onDisappear { OrientationHelper.lock(.portrait) }
    }
}
