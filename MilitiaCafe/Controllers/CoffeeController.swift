import Foundation
import Combine

@MainActor
final class CoffeeController: ObservableObject {
    @Published private(set) var coffees: [Coffee]

    private let storageKey = "militiaCafe.products.v1"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode([Coffee].self, from: data) {
            coffees = saved
        } else {
            coffees = Self.sampleMenu
        }
    }

    var availableCoffees: [Coffee] {
        coffees.filter(\.isAvailable)
    }

    func setAvailability(_ isAvailable: Bool, for coffee: Coffee) {
        guard let index = coffees.firstIndex(where: { $0.id == coffee.id }) else { return }
        coffees[index].isAvailable = isAvailable
        save()
    }

    func addCoffee(name: String, description: String, price: Double) {
        let coffee = Coffee(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            basePrice: price,
            imageName: "latte"
        )
        coffees.insert(coffee, at: 0)
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(coffees) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static let sampleMenu: [Coffee] = [
        Coffee(name: "Militia Latte", description: "Silky espresso, steamed milk, and a little comfort.", basePrice: 145, imageName: "latte"),
        Coffee(name: "Americano", description: "Bold, smooth, and freshly brewed.", basePrice: 120, imageName: " americano"),
        Coffee(name: "Cappuccino", description: "Rich espresso finished with soft milk foam.", basePrice: 140, imageName: "cappuccino"),
        Coffee(name: "Espresso", description: "A short, intense shot with a beautiful crema.", basePrice: 100, imageName: "espresso"),
        Coffee(name: "Caramel Macchiato", description: "Sweet caramel layered over smooth espresso.", basePrice: 160, imageName: "latte"),
        Coffee(name: "Mocha", description: "A cozy meeting of chocolate and coffee.", basePrice: 155, imageName: "mocha"),
        Coffee(name: "Spanish Latte", description: "Creamy, sweet, and made for slow mornings.", basePrice: 150, imageName: "latte")
    ]
}
