import SwiftUI

struct CoffeeCard: View {
    let coffee: Coffee

    var body: some View {
        HStack(spacing: 14) {
            CoffeeProductImage(name: coffee.imageName)
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 17))
            VStack(alignment: .leading, spacing: 6) {
                Text(coffee.name)
                    .font(.system(size: 19, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.espresso)
                Text(coffee.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text("₱\(coffee.basePrice, specifier: "%.0f")")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.brown)
            }
            Spacer(minLength: 0)
            Image(systemName: "arrow.up.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.gold)
        }
        .padding(12)
        .background(.white)
        .clipShape(AppTheme.cardShape)
    }
}
