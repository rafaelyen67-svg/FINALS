import SwiftUI

struct NewCoffeeView: View {
    let onSave: (String, String, Double, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var imageName = "latte"

    private let imageOptions: [(String, String)] = [
        ("latte", "Latte"), (" americano", "Americano"), ("cappuccino", "Cappuccino"),
        ("espresso", "Espresso"), ("mocha", "Mocha")
    ]
    private var validPrice: Double? { Double(price) }

    var body: some View {
        NavigationStack {
            Form {
                Section("Product details") {
                    TextField("Coffee name", text: $name)
                    TextField("Short description", text: $description, axis: .vertical).lineLimit(2...4)
                    TextField("Price (₱)", text: $price).keyboardType(.decimalPad)
                }
                Section("Choose a product photo") {
                    Picker("Photo", selection: $imageName) {
                        ForEach(imageOptions, id: \.0) { option in
                            Text(option.1).tag(option.0)
                        }
                    }
                    HStack(spacing: 12) {
                        CoffeeProductImage(name: imageName)
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Text("This photo will appear on the customer menu.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                Section {
                    Text("New products are saved on this device and added as available. To share menu updates across devices, connect a hosted database.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add coffee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        guard let validPrice else { return }
                        onSave(name, description, validPrice, imageName)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (validPrice ?? 0) <= 0)
                }
            }
        }
    }
}
