import Foundation
import Combine

@MainActor
final class OrderController: ObservableObject {
    @Published private(set) var orders: [Order]

    init() {
        orders = CafeDatabase.load([Order].self, from: "orders.json", default: [])
    }

    func createOrder(name: String, phone: String, items: [CartItem], branch: String, payment: String) -> Order? {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !items.isEmpty else { return nil }

        let total = items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let order = Order(
            orderNumber: "MIL\(Int.random(in: 1000...9999))",
            customerName: name,
            phone: phone,
            items: items,
            total: total,
            branch: branch,
            payment: payment
        )
        orders.insert(order, at: 0)
        saveOrders()
        return order
    }

    func updateStatus(order: Order, status: String) {
        guard let index = orders.firstIndex(where: { $0.id == order.id }) else { return }
        orders[index].status = status
        saveOrders()
    }

    func findOrder(orderNumber: String) -> Order? {
        orders.first { $0.orderNumber.caseInsensitiveCompare(orderNumber) == .orderedSame }
    }

    private func saveOrders() {
        CafeDatabase.save(orders, to: "orders.json")
    }
}
