import SwiftUI

struct CoffeeProductImage: View {
    let name: String

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                AppTheme.cream

                let resolvedName = CoffeeAssetResolver.resolvedName(for: name)
                Image(resolvedName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .overlay {
                        if UIImage(named: resolvedName) == nil {
                            VStack(spacing: 8) {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 36))
                                Text("MILITIA CAFÉ")
                                    .font(.caption2.weight(.bold))
                                    .tracking(1.5)
                            }
                            .foregroundStyle(AppTheme.gold)
                        }
                    }
            }
        }
    }
}

private enum CoffeeAssetResolver {
    static func resolvedName(for rawName: String) -> String {
        let cleaned = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        switch cleaned.lowercased() {
        case "americano", " american", " americano", " americana":
            return "americano"
        case "latte", "militia latte":
            return "latte"
        case "cappuccino":
            return "cappuccino"
        case "espresso":
            return "espresso"
        case "mocha":
            return "mocha"
        case "coffee menu":
            return "coffee menu"
        default:
            return cleaned.isEmpty ? "latte" : cleaned
        }
    }
}
