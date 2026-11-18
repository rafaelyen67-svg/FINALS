import SwiftUI

struct CoffeeCustomizationView: View {
    let coffee: Coffee
    @EnvironmentObject var cartController: CartController
    @StateObject private var coffeeController = CoffeeController()
    @State private var flavor = "Vanilla"
    @State private var sugar = "Regular"
    @State private var temperature = "Iced"
    @State private var size = "Medium"
    @State private var topping = "None"
    @State private var quantity = 1
    @State private var addedToCart = false

    private let flavors = ["Vanilla", "Caramel", "Mocha", "Hazelnut", "Strawberry"]
    private let sugars = ["No Sugar", "Less Sugar", "Regular", "Extra Sugar"]
    private let temperatures = ["Hot", "Iced"]
    private let sizes = ["Small", "Medium", "Large"]

    private struct ToppingOption: Identifiable {
        let name: String
        let emoji: String
        let detail: String
        var id: String { name }
    }

    private let toppings = [
        ToppingOption(name: "None", emoji: "☕️", detail: "Just the good stuff"),
        ToppingOption(name: "Whipped Cream", emoji: "🍦", detail: "Cloud-soft cream"),
        ToppingOption(name: "Caramel Drizzle", emoji: "🍯", detail: "Sweet golden swirls"),
        ToppingOption(name: "Chocolate Drizzle", emoji: "🍫", detail: "A little extra cocoa"),
        ToppingOption(name: "Coffee Jelly", emoji: "🧋", detail: "Bouncy coffee bites")
    ]

    private var price: Double {
        coffeeController.calculatePrice(coffee: coffee, size: size, topping: topping)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 19) {
                hero
                VStack(alignment: .leading, spacing: 5) {
                    Text("Make it yours")
                        .font(.system(size: 30, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
                    Text("Pick your perfect little coffee moment.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }

                choiceCard(title: "Choose a flavor", subtitle: "A little twist makes it yours.", icon: "sparkles") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(flavors, id: \.self) { option in
                            selectionChip(option, selected: flavor == option) { flavor = option }
                        }
                    }
                }

                choiceCard(title: "Temperature", subtitle: "Hot and cozy or iced and lively?", icon: "thermometer.medium") {
                    HStack(spacing: 9) {
                        ForEach(temperatures, id: \.self) { option in
                            selectionChip(option == "Hot" ? "☕️  Hot" : "🧊  Iced", selected: temperature == option) { temperature = option }
                        }
                    }
                }

                choiceCard(title: "Pick your size", subtitle: "More room for your good mood.", icon: "cup.and.saucer") {
                    HStack(spacing: 9) {
                        ForEach(sizes, id: \.self) { option in
                            selectionChip(option, selected: size == option) { size = option }
                        }
                    }
                }

                choiceCard(title: "Sugar level", subtitle: "Find your just-right sweetness.", icon: "heart") {
                    Menu {
                        ForEach(sugars, id: \.self) { option in
                            Button { sugar = option } label: {
                                if sugar == option { Label(option, systemImage: "checkmark") } else { Text(option) }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "drop.fill").foregroundStyle(AppTheme.gold)
                            Text(sugar).fontWeight(.semibold).foregroundStyle(AppTheme.espresso)
                            Spacer()
                            Image(systemName: "chevron.down").font(.caption.bold()).foregroundStyle(AppTheme.brown)
                        }
                        .padding(12).background(AppTheme.paper).clipShape(RoundedRectangle(cornerRadius: 13))
                    }
                }

                choiceCard(title: "Add a happy extra", subtitle: "Choose a topping to finish your cup.", icon: "wand.and.stars") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(toppings) { option in
                            Button {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.72)) { topping = option.name }
                            } label: {
                                VStack(alignment: .leading, spacing: 7) {
                                    HStack {
                                        Text(option.emoji).font(.title2)
                                        Spacer()
                                        if topping == option.name {
                                            Image(systemName: "checkmark.circle.fill").foregroundStyle(AppTheme.sage)
                                        }
                                    }
                                    Text(option.name).font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.espresso).lineLimit(1).minimumScaleFactor(0.8)
                                    Text(option.detail).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                                    Text(option.name == "None" ? "No extra charge" : "+₱15")
                                        .font(.caption2.weight(.bold)).foregroundStyle(AppTheme.brown)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading).padding(12)
                                .background(topping == option.name ? AppTheme.cream : AppTheme.paper)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(topping == option.name ? AppTheme.gold : .clear, lineWidth: 2))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(option.name), \(option.detail)\(topping == option.name ? ", selected" : "")")
                        }
                    }
                }

                choiceCard(title: "How many?", subtitle: "Sharing is optional.", icon: "plus.forwardslash.minus") {
                    QuantityControl(quantity: $quantity)
                }

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your total").font(.caption.weight(.medium)).foregroundStyle(.secondary)
                        Text("₱\(price * Double(quantity), specifier: "%.0f")")
                            .font(.system(size: 27, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
                    }
                    Spacer()
                    Text("\(quantity) cup\(quantity == 1 ? "" : "s")")
                        .font(.caption.weight(.semibold)).foregroundStyle(AppTheme.brown)
                        .padding(.horizontal, 11).padding(.vertical, 7).background(AppTheme.cream).clipShape(Capsule())
                }
                .padding(16).background(.white).clipShape(RoundedRectangle(cornerRadius: 19))

                Button {
                    let item = CartItem(coffee: coffee, flavor: flavor, sugar: sugar, temperature: temperature,
                                        size: size, topping: topping, price: price, quantity: quantity)
                    cartController.addItem(item)
                    withAnimation(.spring()) { addedToCart = true }
                } label: {
                    HStack(spacing: 9) {
                        Image(systemName: addedToCart ? "checkmark" : "cart.fill")
                        Text(addedToCart ? "Added to your cart!" : "Add to cart")
                        Spacer()
                        Text("₱\(price * Double(quantity), specifier: "%.0f")")
                    }
                    .font(.headline).foregroundStyle(.white).padding(17)
                    .background(LinearGradient(colors: [AppTheme.brown, AppTheme.espresso], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
                }
                .buttonStyle(.plain)
                NavigationLink { CartView() } label: {
                    Text("Ready to check out? View cart →")
                        .font(.subheadline.weight(.semibold)).foregroundStyle(AppTheme.brown)
                        .frame(maxWidth: .infinity).padding(.vertical, 7)
                }
            }
            .padding(20).frame(maxWidth: 600).frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle(coffee.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            CoffeeProductImage(name: coffee.imageName)
                .frame(height: 215).frame(maxWidth: .infinity).clipped()
            LinearGradient(colors: [.clear, AppTheme.espresso.opacity(0.72)], startPoint: .center, endPoint: .bottom)
            VStack(alignment: .leading, spacing: 5) {
                Text("MADE FRESH FOR YOU").font(.caption2.weight(.heavy)).tracking(1.3).foregroundStyle(AppTheme.cream)
                Text(coffee.name).font(.system(size: 25, weight: .bold, design: .serif)).foregroundStyle(.white)
            }
            .padding(17)
        }
        .clipShape(RoundedRectangle(cornerRadius: 23, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Text("₱\(coffee.basePrice, specifier: "%.0f")")
                .font(.caption.weight(.heavy)).foregroundStyle(AppTheme.espresso)
                .padding(.horizontal, 11).padding(.vertical, 8).background(AppTheme.cream).clipShape(Capsule()).padding(12)
        }
    }

    private func choiceCard<Content: View>(title: String, subtitle: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 10) {
                Image(systemName: icon).font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.brown)
                    .frame(width: 34, height: 34).background(AppTheme.cream).clipShape(RoundedRectangle(cornerRadius: 11))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundStyle(AppTheme.espresso)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
            }
            content()
        }
        .padding(15).background(.white).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func selectionChip(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.caption.weight(.semibold)).lineLimit(1).minimumScaleFactor(0.75)
                .foregroundStyle(selected ? .white : AppTheme.brown)
                .frame(maxWidth: .infinity).padding(.horizontal, 9).padding(.vertical, 11)
                .background(selected ? AppTheme.brown : AppTheme.paper).clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
