import Foundation
import Combine

@MainActor
final class CoffeeController: ObservableObject {
    @Published private(set) var coffees: [Coffee]

    init() {
        coffees = CafeDatabase.load([Coffee].self, from: "products.json", default: Self.sampleMenu)
    }

    var availableCoffees: [Coffee] { coffees.filter(\.isAvailable) }

    func setAvailability(_ isAvailable: Bool, for coffee: Coffee) {
        guard let index = coffees.firstIndex(where: { $0.id == coffee.id }) else { return }
        coffees[index].isAvailable = isAvailable
        save()
    }

    func addCoffee(name: String, description: String, price: Double, imageName: String = "latte") {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty, price > 0 else { return }
        let resolvedImage = CoffeeAssetResolver.resolvedName(for: imageName)
        let coffee = Coffee(
            name: cleanName,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            basePrice: price,
            imageName: resolvedImage
        )
        coffees.insert(coffee, at: 0)
        save()
    }

    func calculatePrice(coffee: Coffee, size: String, topping: String) -> Double {
        var price = coffee.basePrice
        if size == "Small" { price -= 20 }
        if size == "Large" { price += 30 }
        if topping != "None" { price += 15 }
        return price
    }

    private func save() {
        CafeDatabase.save(coffees, to: "products.json")
    }

    private static let sampleMenu: [Coffee] = [
        Coffee(name: "Militia Latte", description: "Silky espresso, steamed milk, and a little comfort.", basePrice: 145, imageName: "latte"),
        Coffee(name: "Americano", description: "Bold, smooth, and freshly brewed.", basePrice: 120, imageName: "americano"),
        Coffee(name: "Cappuccino", description: "Rich espresso finished with soft milk foam.", basePrice: 140, imageName: "cappuccino"),
        Coffee(name: "Espresso", description: "A short, intense shot with a beautiful crema.", basePrice: 100, imageName: "espresso"),
        Coffee(name: "Caramel Macchiato", description: "Sweet caramel layered over smooth espresso.", basePrice: 160, imageName: "latte"),
        Coffee(name: "Mocha", description: "A cozy meeting of chocolate and coffee.", basePrice: 155, imageName: "mocha"),
        Coffee(name: "Spanish Latte", description: "Creamy, sweet, and made for slow mornings.", basePrice: 150, imageName: "latte")
    ]
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
