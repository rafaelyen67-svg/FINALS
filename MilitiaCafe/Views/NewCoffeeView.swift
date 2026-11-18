import SwiftUI

struct NewCoffeeView: View {
    let onSave: (String, String, Double, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var imageName = "latte"

    private let imageOptions: [(String, String)] = [
        ("latte", "Latte"),
        ("americano", "Americano"),
        ("cappuccino", "Cappuccino"),
        ("espresso", "Espresso"),
        ("mocha", "Mocha")
    ]
    private var validPrice: Double? { Double(price) }
    private var canPost: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && (validPrice ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("A NEW FAVORITE")
                            .font(.caption2.weight(.heavy)).tracking(1.5).foregroundStyle(AppTheme.gold)
                        Text("Create a coffee")
                            .font(.system(size: 30, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
                        Text("Give your next menu star a name, a story, and a price.")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.top, 12)

                    HStack(spacing: 14) {
                        CoffeeProductImage(name: imageName)
                            .frame(width: 86, height: 86)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(name.isEmpty ? "Your new drink" : name)
                                .font(.headline).foregroundStyle(AppTheme.espresso)
                            Text(description.isEmpty ? "A little cup of happiness." : description)
                                .font(.caption).foregroundStyle(.secondary).lineLimit(2)
                            if let validPrice, validPrice > 0 {
                                Text("₱\(validPrice, specifier: "%.0f")")
                                    .font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.brown)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(14).frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    VStack(alignment: .leading, spacing: 15) {
                        sectionTitle("The details", subtitle: "Make it easy for customers to fall in love.")
                        inputField("Coffee name", placeholder: "e.g. Honey oat latte", text: $name, icon: "cup.and.saucer")
                        VStack(alignment: .leading, spacing: 7) {
                            Text("DESCRIPTION").font(.caption2.weight(.bold)).tracking(0.8).foregroundStyle(.secondary)
                            TextField("Tell us what makes it special", text: $description, axis: .vertical)
                                .lineLimit(2...4).padding(12).background(AppTheme.paper)
                                .clipShape(RoundedRectangle(cornerRadius: 13))
                        }
                        inputField("Price", placeholder: "0.00", text: $price, icon: "₱", numeric: true)
                    }
                    .padding(17).background(.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    VStack(alignment: .leading, spacing: 13) {
                        sectionTitle("Pick a look", subtitle: "Choose the closest photo for your menu.")
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(imageOptions, id: \.0) { option in
                                Button { imageName = option.0 } label: {
                                    VStack(spacing: 7) {
                                        CoffeeProductImage(name: option.0)
                                            .frame(height: 74).clipShape(RoundedRectangle(cornerRadius: 13))
                                        Text(option.1).font(.caption.weight(.semibold)).foregroundStyle(AppTheme.espresso)
                                    }
                                    .padding(7).frame(maxWidth: .infinity)
                                    .background(imageName == option.0 ? AppTheme.cream : AppTheme.paper)
                                    .clipShape(RoundedRectangle(cornerRadius: 17))
                                    .overlay(RoundedRectangle(cornerRadius: 17).stroke(imageName == option.0 ? AppTheme.gold : .clear, lineWidth: 2))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(17).background(.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    Label("This drink will be saved on this device and added to the menu as available.", systemImage: "info.circle")
                        .font(.caption).foregroundStyle(.secondary).padding(.horizontal, 3)
                }
                .padding(20).frame(maxWidth: 600).frame(maxWidth: .infinity)
            }
            .background(AppTheme.paper.ignoresSafeArea())
            .navigationTitle("Add coffee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() }.foregroundStyle(AppTheme.brown) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        guard let validPrice, canPost else { return }
                        onSave(name, description, validPrice, imageName)
                        dismiss()
                    }
                    .fontWeight(.bold).foregroundStyle(AppTheme.brown).disabled(!canPost)
                }
            }
        }
    }

    private func sectionTitle(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline).foregroundStyle(AppTheme.espresso)
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
    }

    private func inputField(_ title: String, placeholder: String, text: Binding<String>, icon: String, numeric: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title.uppercased()).font(.caption2.weight(.bold)).tracking(0.8).foregroundStyle(.secondary)
            HStack(spacing: 10) {
                Image(systemName: icon == "₱" ? "" : icon).foregroundStyle(AppTheme.gold)
                if icon == "₱" { Text("₱").fontWeight(.semibold).foregroundStyle(AppTheme.gold) }
                TextField(placeholder, text: text)
                    .keyboardType(numeric ? .decimalPad : .default)
                    .textInputAutocapitalization(numeric ? .never : .words)
                    .autocorrectionDisabled(numeric)
            }
            .padding(12).background(AppTheme.paper).clipShape(RoundedRectangle(cornerRadius: 13))
        }
    }
}
