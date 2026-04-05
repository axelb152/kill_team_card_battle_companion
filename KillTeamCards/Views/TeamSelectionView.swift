import SwiftUI

struct TeamSelectionView: View {
    @StateObject private var viewModel = FactionListViewModel()
    @State private var showingAddFaction = false
    @State private var newFactionName = ""
    @State private var newFactionPDF = ""

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let error = viewModel.loadError {
                errorView(message: error)
            } else {
                factionGrid
            }
        }
        .navigationTitle("Kill Team")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(viewModel.isEditMode ? "Done" : "Edit") {
                    viewModel.isEditMode.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddFaction) {
            addFactionSheet
        }
    }

    private var factionGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.factions) { faction in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink(value: faction) {
                            FactionTileView(faction: faction)
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isEditMode)

                        if viewModel.isEditMode {
                            Button {
                                if let index = viewModel.factions.firstIndex(where: { $0.id == faction.id }) {
                                    viewModel.deleteFaction(at: IndexSet([index]))
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .background(Color.white.cornerRadius(10))
                            }
                            .padding(8)
                        }
                    }
                }
                
                if viewModel.isEditMode {
                    Button {
                        showingAddFaction = true
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32))
                            Text("Add Team")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .foregroundColor(.green)
                }
            }
            .padding(16)
        }
        .navigationDestination(for: Faction.self) { faction in
            OperativeSelectionView(faction: faction) { updatedFaction in
                viewModel.updateFaction(updatedFaction)
            }
        }
    }

    private var addFactionSheet: some View {
        NavigationStack {
            Form {
                TextField("Team Name", text: $newFactionName)
                TextField("PDF Filename (e.g. team.pdf)", text: $newFactionPDF)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .navigationTitle("New Team")
            .toolbar {
                Button("Cancel") { showingAddFaction = false }
                Button("Add") {
                    viewModel.addFaction(name: newFactionName, pdfFile: newFactionPDF)
                    newFactionName = ""
                    newFactionPDF = ""
                    showingAddFaction = false
                }
                .disabled(newFactionName.isEmpty || newFactionPDF.isEmpty)
            }
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red.opacity(0.8))
            Text("Failed to load factions")
                .font(.headline)
                .foregroundColor(.white)
            Text(message)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
