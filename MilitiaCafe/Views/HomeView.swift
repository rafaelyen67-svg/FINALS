import SwiftUI

struct HomeView: View {
    let customer: Customer?
    @Binding var selectedTab: Int
    @EnvironmentObject private var coffeeController: CoffeeController
    @EnvironmentObject private var cartController: CartController

    private var featuredCoffee: Coffee? { coffeeController.availableCoffees.first }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        header
                        dailySpecial
                        quickActions
                        favorites
                        littleNote
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 28)
                    .frame(maxWidth: 620)
                    .frame(maxWidth: .infinity)
                }
                .background(AppTheme.paper.ignoresSafeArea())
                .toolbar(.hidden, for: .navigationBar)
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(0)

            NavigationStack { CoffeeView() }
                .tabItem { Label("Coffee", systemImage: "cup.and.saucer.fill") }
                .tag(1)

            NavigationStack { CartView() }
                .tabItem { Label("Cart", systemImage: "basket.fill") }
                .badge(cartController.items.count)
                .tag(2)

            NavigationStack { OrdersView() }
                .tabItem { Label("Orders", systemImage: "receipt") }
                .tag(3)

            NavigationStack { ProfileView(customer: customer) }
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(4)
        }
        .tint(AppTheme.brown)
        .onReceive(NotificationCenter.default.publisher(for: .goToHome)) { _ in
            selectedTab = 0
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text(Date.now.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()).uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(1.7)
                    .foregroundStyle(AppTheme.gold)
                Text("Hey, \(firstName)!")
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.espresso)
                Text("Ready for a little coffee joy?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ZStack {
                Circle().fill(AppTheme.cream).frame(width: 52, height: 52)
                Image(systemName: "sun.max.fill")
                    .font(.title3)
                    .foregroundStyle(AppTheme.gold)
            }
            .accessibilityLabel("Good vibes")
        }
    }

    private var dailySpecial: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Label("TODAY'S LITTLE TREAT", systemImage: "sparkles")
                    .font(.caption2.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(AppTheme.gold)
                Spacer()
                Text("☕️")
                    .font(.title2)
            }
            .padding(.bottom, 12)

            Text(featuredCoffee?.name ?? "A good day starts here")
                .font(.system(size: 26, weight: .bold, design: .serif))
                .foregroundStyle(.white)
            Text(featuredCoffee?.description ?? "Explore the menu for something delicious.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.78))
                .lineLimit(2)
                .padding(.top, 5)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("FROM")
                        .font(.caption2.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.65))
                    Text("₱\(featuredCoffee?.basePrice ?? 0, specifier: "%.0f")")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }
                Spacer()
                Button { selectedTab = 1 } label: {
                    HStack(spacing: 8) {
                        Text("Pick me")
                        Image(systemName: "arrow.up.right")
                    }
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.espresso)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background(AppTheme.cream)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 18)
        }
        .padding(20)
        .background {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(colors: [AppTheme.brown, AppTheme.espresso], startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(AppTheme.gold.opacity(0.14))
                    .frame(width: 170, height: 170)
                    .offset(x: 55, y: 58)
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 100, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.08))
                    .rotationEffect(.degrees(-12))
                    .padding(.trailing, 20)
                    .padding(.bottom, 16)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .shadow(color: AppTheme.brown.opacity(0.16), radius: 16, x: 0, y: 9)
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            actionTile(title: "Browse menu", subtitle: "Find your next fave", icon: "menucard.fill", color: AppTheme.sage) {
                selectedTab = 1
            }
            actionTile(title: "Your orders", subtitle: "Track the good stuff", icon: "takeoutbag.and.cup.and.straw.fill", color: AppTheme.gold) {
                selectedTab = 3
            }
        }
    }

    private func actionTile(title: String, subtitle: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.espresso)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var favorites: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(alignment: .firstTextBaseline) {
                Text("Made you look")
                    .font(.system(size: 23, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.espresso)
                Spacer()
                Button("See all") { selectedTab = 1 }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.brown)
            }
            if coffeeController.availableCoffees.isEmpty {
                Text("Fresh cups are taking a tiny break. Check back soon!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                ForEach(Array(coffeeController.availableCoffees.prefix(2))) { coffee in
                    NavigationLink {
                        CoffeeDetailView(coffee: coffee)
                    } label: {
                        CoffeeCard(coffee: coffee)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var littleNote: some View {
        HStack(spacing: 12) {
            Text("💌").font(.title2)
            Text("Made with care, served with a little extra joy.")
                .font(.caption.weight(.medium))
                .foregroundStyle(AppTheme.brown)
            Spacer(minLength: 0)
        }
        .padding(15)
        .background(AppTheme.pink.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 17))
    }

    private var firstName: String {
        let name = customer?.name.split(separator: " ").first.map(String.init)
        return name?.isEmpty == false ? name! : "Coffee Lover"
    }
}
