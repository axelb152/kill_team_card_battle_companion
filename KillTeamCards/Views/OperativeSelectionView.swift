import SwiftUI

struct OperativeSelectionView: View {
    @StateObject private var viewModel: OperativeListViewModel
    @State private var showBattleMode = false

    init(faction: Faction) {
        _viewModel = StateObject(wrappedValue: OperativeListViewModel(faction: faction))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                operativeList

                battleModeButton
                    .padding(16)
            }
        }
        .navigationTitle(viewModel.faction.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .fullScreenCover(isPresented: $showBattleMode) {
            // Phase 4: BattleModeView goes here
            Color.black.ignoresSafeArea()
                .overlay(
                    Button("Close") { showBattleMode = false }
                        .foregroundColor(.white)
                )
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
