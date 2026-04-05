import SwiftUI

struct OperativeSelectionView: View {
    @StateObject private var viewModel: OperativeListViewModel
    @State private var showBattleMode = false
    @State private var editingOperative: Operative? = nil
    @State private var isAddingNew = false
    
    let onFactionUpdate: (Faction) -> Void

    init(faction: Faction, onFactionUpdate: @escaping (Faction) -> Void) {
        self.onFactionUpdate = onFactionUpdate
        _viewModel = StateObject(wrappedValue: OperativeListViewModel(faction: faction, onSave: onFactionUpdate))
    }

    var body: some View {
        operativeList
            .background(Color.black.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                if !viewModel.isEditMode {
                    battleModeButton
                        .padding(16)
                        .background(Color.black)
                }
            }
            .navigationTitle(viewModel.faction.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(viewModel.isEditMode ? "Done" : "Edit") {
                        viewModel.isEditMode.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showBattleMode) {
                BattleModeView(session: SelectedSession(
                    faction: viewModel.faction,
                    selectedPages: viewModel.selectedPages
                ))
            }
            .sheet(isPresented: $isAddingNew) {
                EditOperativeSheet { name, pages in
                    viewModel.addOperative(name: name, pages: pages)
                }
            }
            .sheet(item: $editingOperative) { operative in
                EditOperativeSheet(operative: operative) { name, pages in
                    viewModel.updateOperative(Operative(name: name, pages: pages))
                    editingOperative = nil
                }
            }
    }

    private var editMode: Binding<EditMode> {
        .constant(viewModel.isEditMode ? .active : .inactive)
    }

    private var operativeList: some View {
        List {
            Section {
                ForEach(viewModel.faction.operatives) { operative in
                    operativeRow(operative)
                }
                .onDelete { offsets in
                    if viewModel.isEditMode {
                        viewModel.deleteOperative(at: offsets)
                    }
                }
            } footer: {
                if viewModel.isEditMode {
                    Button(action: { isAddingNew = true }) {
                        Label("Add Operative", systemImage: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.headline)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .environment(\.editMode, editMode)
    }
    
    private func operativeRow(_ operative: Operative) -> some View {
        Button {
            if viewModel.isEditMode {
                editingOperative = operative
            } else {
                viewModel.toggle(operative)
            }
        } label: {
            HStack(spacing: 14) {
                if !viewModel.isEditMode {
                    Image(systemName: viewModel.selectedIds.contains(operative.id)
                          ? "checkmark.circle.fill"
                          : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(viewModel.selectedIds.contains(operative.id)
                                         ? .white : .white.opacity(0.3))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(operative.name)
                        .foregroundColor(.white)
                        .font(.body)
                    
                    if viewModel.isEditMode {
                        Text("Pages: \(operative.pages.map(String.init).joined(separator: ", "))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                if viewModel.isEditMode {
                    Image(systemName: "pencil.circle")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(Color.white.opacity(0.06))
    }

    private var battleModeButton: some View {
        Button {
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
