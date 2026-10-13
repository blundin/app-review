import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var showingEdit = false

    var body: some View {
        List {
            Section("Household") {
                Text(name.isEmpty ? " " : name)
                Button("Edit name") { showingEdit = true }
            }
            Section {
                Button("Delete household") {
                    HouseholdStore.shared.deleteAll()
                }
                .foregroundColor(Color(red: 0.86, green: 0.15, blue: 0.15))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: { Text("< Back") }
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        .sheet(isPresented: $showingEdit) {
            EditNameSheet(name: $name)
                .interactiveDismissDisabled(true)
        }
    }
}

struct EditNameSheet: View {
    @Binding var name: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 14) {
            TextField("", text: $name)
                .textFieldStyle(.roundedBorder)
            Button("OK") { dismiss() }
        }
        .padding(16)
    }
}
