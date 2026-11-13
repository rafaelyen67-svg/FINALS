import SwiftUI

struct AdminDashboardView: View {
    let admin: Admin?
    @EnvironmentObject private var coffeeController: CoffeeController
    @EnvironmentObject private var orderController: OrderController
    @State private var showingNewCoffee = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("STAFF WORKSPACE").font(.caption.weight(.bold)).tracking(2).foregroundStyle(AppTheme.gold)
                    Text("Good day, \(admin?.name ?? "Barista").")
                        .font(.system(size: 30, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
                    Text("Keep the menu fresh and every pickup moving.").font(.subheadline).foregroundStyle(.secondary)
                }
                HStack(spacing: 12) {
                    metricCard(value: "\(coffeeController.coffees.count)", title: "MENU ITEMS", icon: "cup.and.saucer.fill")
                    metricCard(value: "\(orderController.orders.count)", title: "ORDERS", icon: "receipt")
                }
                NavigationLink { QRScannerView() } label: {
                    HStack(spacing: 15) {
                        Image(systemName: "qrcode.viewfinder").font(.title2).frame(width: 48, height: 48).background(.white.opacity(0.14)).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Scan pickup QR").font(.headline)
                            Text("Verify a customer's order").font(.caption).foregroundStyle(.white.opacity(0.78))
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right").font(.subheadline.weight(.bold))
                    }
                    .foregroundStyle(.white).padding(18).background(AppTheme.brown).clipShape(AppTheme.cardShape)
                }
                .buttonStyle(.plain)

                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Coffee menu").font(.title2.bold()).foregroundStyle(AppTheme.espresso)
                        Text("Update products and availability.").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button { showingNewCoffee = true } label: {
                        Label("Add", systemImage: "plus").font(.subheadline.weight(.semibold)).foregroundStyle(AppTheme.brown)
                    }
                }
                VStack(spacing: 0) {
                    ForEach(Array(coffeeController.coffees.enumerated()), id: \.element.id) { index, coffee in
                        HStack(spacing: 12) {
                            CoffeeProductImage(name: coffee.imageName)
                                .frame(width: 46, height: 46)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(coffee.name).font(.subheadline.weight(.semibold)).foregroundStyle(AppTheme.espresso)
                                Text("₱\(coffee.basePrice, specifier: "%.0f") · \(coffee.isAvailable ? "Available" : "Sold out")")
                                    .font(.caption).foregroundStyle(coffee.isAvailable ? AppTheme.sage : .secondary)
                            }
                            Spacer()
                            Toggle("Available", isOn: Binding(
                                get: { coffeeController.coffees.first(where: { $0.id == coffee.id })?.isAvailable ?? false },
                                set: { coffeeController.setAvailability($0, for: coffee) }
                            )).labelsHidden().tint(AppTheme.sage)
                        }
                        .padding(14)
                        if index < coffeeController.coffees.count - 1 { Divider().padding(.leading, 66) }
                    }
                }
                .background(.white).clipShape(AppTheme.cardShape)
            }
            .padding(20).frame(maxWidth: 650).frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingNewCoffee) {
            NewCoffeeView { name, description, price, imageName in
                coffeeController.addCoffee(name: name, description: description, price: price, imageName: imageName)
            }
        }
    }

    private func metricCard(value: String, title: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon).foregroundStyle(AppTheme.gold)
            Text(value).font(.system(size: 27, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
            Text(title).font(.caption2.weight(.bold)).tracking(1).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(16).background(.white).clipShape(AppTheme.cardShape)
    }
}
