import SwiftUI

struct EditOperativeSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    let operative: Operative? // nil if adding new
    let onSave: (String, [Int]) -> Void
    
    @State private var name: String = ""
    @State private var pagesString: String = ""
    
    init(operative: Operative? = nil, onSave: @escaping (String, [Int]) -> Void) {
        self.operative = operative
        self.onSave = onSave
        _name = State(initialValue: operative?.name ?? "")
        _pagesString = State(initialValue: operative?.pages.map(String.init).joined(separator: ", ") ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Operative Details") {
                    TextField("Name", text: $name)
                    TextField("Pages (e.g. 1, 2)", text: $pagesString)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
            .navigationTitle(operative == nil ? "Add Operative" : "Edit Operative")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let pages = parsePages(pagesString)
                        if !name.isEmpty && !pages.isEmpty {
                            onSave(name, pages)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || parsePages(pagesString).isEmpty)
                }
            }
        }
    }
    
    private func parsePages(_ input: String) -> [Int] {
        input.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
    }
}
