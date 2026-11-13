import SwiftUI

struct CoffeeCard: View {
    let coffee: Coffee

    var body: some View {
        HStack(spacing: 14) {
            CoffeeProductImage(name: coffee.imageName)
                .frame(width: 94, height: 94)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "sparkle")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(AppTheme.gold)
                        .clipShape(Circle())
                        .offset(x: 4, y: 4)
                }
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 5) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundStyle(AppTheme.gold)
                    Text("CAFÉ FAVORITE").font(.system(size: 9, weight: .bold)).tracking(1).foregroundStyle(AppTheme.gold)
                }
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
                .foregroundStyle(AppTheme.brown)
                .frame(width: 30, height: 30)
                .background(AppTheme.cream)
                .clipShape(Circle())
        }
        .padding(13)
        .background(.white)
        .clipShape(AppTheme.cardShape)
        .shadow(color: AppTheme.brown.opacity(0.045), radius: 9, x: 0, y: 4)
    }
}
