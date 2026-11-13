import SwiftUI

struct CoffeeDetailView: View {
    let coffee: Coffee

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ZStack(alignment: .bottomLeading) {
                    CoffeeProductImage(name: coffee.imageName)
                        .frame(height: 270)
                        .clipped()
                    LinearGradient(colors: [.clear, .black.opacity(0.48)], startPoint: .center, endPoint: .bottom)
                    Text("BREWED WITH CARE")
                        .font(.caption.weight(.bold))
                        .tracking(2)
                        .foregroundStyle(.white)
                        .padding(18)
                }
                .frame(height: 270)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                Text(coffee.name)
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.espresso)
                Text(coffee.description).font(.body).foregroundStyle(.secondary)
                HStack {
                    Label("Made fresh to order", systemImage: "sparkles").font(.caption.weight(.medium)).foregroundStyle(AppTheme.sage)
                    Spacer()
                    Text("₱\(coffee.basePrice, specifier: "%.0f")").font(.title2.bold()).foregroundStyle(AppTheme.brown)
                }
                NavigationLink { CoffeeCustomizationView(coffee: coffee) } label: {
                    HStack {
                        Text("Customize your cup")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline).foregroundStyle(.white).padding(17)
                    .background(AppTheme.brown).clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(20)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoffeeProductImage: View {
    let name: String

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                AppTheme.cream
                let imageName = CoffeeAssetResolver.resolvedName(for: name)
                Image(uiImage: UIImage(named: imageName) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .overlay {
                        if UIImage(named: imageName) == nil {
                            VStack(spacing: 8) {
                                Image(systemName: "cup.and.saucer.fill").font(.system(size: 36))
                                Text("MILITIA CAFÉ").font(.caption2.weight(.bold)).tracking(1.5)
                            }
                            .foregroundStyle(AppTheme.gold)
                        }
                    }
            }
        }
    }
}

enum CoffeeAssetResolver {
    static func resolvedName(for rawName: String) -> String {
        let cleaned = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        switch cleaned.lowercased() {
        case "americano", "americana":
            // The original project resource includes a leading space in its filename.
            return " americano"
        case "latte", "militia latte": return "latte"
        case "cappuccino": return "cappuccino"
        case "espresso": return "espresso"
        case "mocha": return "mocha"
        case "coffee menu": return "coffee menu"
        default: return cleaned.isEmpty ? "latte" : cleaned
        }
    }
}
