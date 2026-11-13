import Foundation
import Combine

@MainActor
final class CartController: ObservableObject {
    @Published private(set) var items: [CartItem]

    init() {
        items = CafeDatabase.load([CartItem].self, from: "cart.json", default: [])
    }

    func addItem(_ item: CartItem) {
        items.append(item)
        save()
    }

    func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func updateQuantity(for item: CartItem, quantity: Int) {
        guard quantity >= 1, let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity = quantity
        save()
    }

    func clearCart() {
        items.removeAll()
        save()
    }

    var total: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private func save() {
        CafeDatabase.save(items, to: "cart.json")
    }
}
