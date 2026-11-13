import SwiftUI

@main
struct MilitiaCafeApp: App {
    @StateObject private var cartController = CartController()
    @StateObject private var orderController = OrderController()
    @StateObject private var coffeeController = CoffeeController()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(cartController)
                .environmentObject(orderController)
                .environmentObject(coffeeController)
        }
    }
}
