import SwiftUI

struct OperativeSelectionView: View {
    @StateObject private var viewModel: OperativeListViewModel
    @State private var showBattleMode = false

    init(faction: Faction) {
        _viewModel = StateObject(wrappedValue: OperativeListViewModel(faction: faction))
    }

    var body: some View {
        // safeAreaInset pins the button to the bottom and shrinks the list's
        // safe area so every row is reachable by scrolling — fixes the VStack
        // layout bug where List stops scrolling before the last rows.
        operativeList
            .background(Color.black.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                battleModeButton
                    .padding(16)
                    .background(Color.black)
            }
            .navigationTitle(viewModel.faction.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .fullScreenCover(isPresented: $showBattleMode) {
                BattleModeView(session: SelectedSession(
                    faction: viewModel.faction,
                    selectedPages: viewModel.selectedPages
                ))
            }
    }

    private var operativeList: some View {
        List {
            ForEach(viewModel.faction.operatives) { operative in
                Button {
                    viewModel.toggle(operative)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: viewModel.selectedIds.contains(operative.id)
                              ? "checkmark.circle.fill"
                              : "circle")
                            .font(.system(size: 22))
                            .foregroundColor(viewModel.selectedIds.contains(operative.id)
                                             ? .white : .white.opacity(0.3))

                        Text(operative.name)
                            .foregroundColor(.white)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(Color.white.opacity(0.06))
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private var battleModeButton: some View {
        Button {
            // Pre-warm: load the PDF into cache now so BattleModeView's
            // resolvePages() hits the cache instantly after the cover presents.
            let pdfFile = viewModel.faction.pdfFile
            let firstPage = viewModel.selectedPages.first ?? 1
            _ = PDFPageProvider.shared.page(from: pdfFile, pageNumber: firstPage)
            showBattleMode = true
        } label: {
            Text("Battle Mode")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(viewModel.hasSelection ? Color.white : Color.white.opacity(0.2))
                .cornerRadius(12)
        }
        .disabled(!viewModel.hasSelection)
        .animation(.easeInOut(duration: 0.15), value: viewModel.hasSelection)
    }
}
