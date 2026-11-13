import SwiftUI

/// Main staff workspace: product publishing, availability, orders, and QR pickup scanning.
struct AdminView: View {
    let admin: Admin?
    @EnvironmentObject private var coffeeController: CoffeeController
    @EnvironmentObject private var orderController: OrderController
    @EnvironmentObject private var loginController: LoginController
    @State private var showingNewCoffee = false
    @State private var showingLogoutConfirmation = false

    private var availableCount: Int { coffeeController.availableCoffees.count }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 23) {
                header
                summary
                scannerCard
                menuSection
                ordersSection
                footer
            }
            .padding(20)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle("Café studio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingLogoutConfirmation = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundStyle(AppTheme.brown)
                }
                .accessibilityLabel("Log out")
            }
        }
        .confirmationDialog("Log out of the admin workspace?", isPresented: $showingLogoutConfirmation, titleVisibility: .visible) {
            Button("Log out", role: .destructive) { loginController.logout() }
            Button("Stay signed in", role: .cancel) { }
        }
        .sheet(isPresented: $showingNewCoffee) {
            NewCoffeeView { name, description, price, imageName in
                coffeeController.addCoffee(name: name, description: description, price: price, imageName: imageName)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("STAFF WORKSPACE", systemImage: "sparkles")
                    .font(.caption2.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(AppTheme.gold)
                Spacer()
                Text("ADMIN")
                    .font(.caption2.weight(.heavy))
                    .tracking(1)
                    .foregroundStyle(AppTheme.sage)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.sage.opacity(0.12))
                    .clipShape(Capsule())
            }
            Text("Hello, \(admin?.name ?? "Barista")!")
                .font(.system(size: 31, weight: .bold, design: .serif))
                .foregroundStyle(AppTheme.espresso)
            Text("A little dashboard to keep the good coffee flowing.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private var summary: some View {
        HStack(spacing: 12) {
            summaryCard(value: "\(coffeeController.coffees.count)", title: "MENU ITEMS", icon: "cup.and.saucer.fill", tint: AppTheme.gold)
            summaryCard(value: "\(availableCount)", title: "AVAILABLE", icon: "checkmark.circle.fill", tint: AppTheme.sage)
            summaryCard(value: "\(orderController.orders.count)", title: "ORDERS", icon: "receipt.fill", tint: AppTheme.brown)
        }
    }

    private func summaryCard(value: String, title: String, icon: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).foregroundStyle(tint)
            Text(value).font(.system(size: 25, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
            Text(title).font(.system(size: 9, weight: .heavy)).tracking(0.7).foregroundStyle(.secondary).lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var scannerCard: some View {
        NavigationLink { QRScannerView() } label: {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.15))
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundStyle(AppTheme.gold)
                }
                .frame(width: 53, height: 53)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Scan a pickup QR").font(.headline).foregroundStyle(.white)
                    Text("Verify customer orders at the counter").font(.caption).foregroundStyle(.white.opacity(0.72))
                }
                Spacer(minLength: 0)
                Image(systemName: "arrow.right").font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.gold)
            }
            .padding(17)
            .background(LinearGradient(colors: [AppTheme.brown, AppTheme.espresso], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your coffee board").font(.system(size: 23, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
                    Text("Post a drink or mark it sold out.").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Button { showingNewCoffee = true } label: {
                    Label("Add drink", systemImage: "plus")
                        .font(.caption.weight(.bold)).foregroundStyle(.white)
                        .padding(.horizontal, 13).padding(.vertical, 10)
                        .background(AppTheme.brown).clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            VStack(spacing: 0) {
                ForEach(Array(coffeeController.coffees.enumerated()), id: \.element.id) { index, coffee in
                    HStack(spacing: 12) {
                        CoffeeProductImage(name: coffee.imageName)
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(coffee.name).font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.espresso)
                            Text("₱\(coffee.basePrice, specifier: "%.0f") · \(coffee.isAvailable ? "On the menu" : "Sold out")")
                                .font(.caption).foregroundStyle(coffee.isAvailable ? AppTheme.sage : .secondary)
                        }
                        Spacer(minLength: 8)
                        Toggle("Available", isOn: Binding(
                            get: { coffeeController.coffees.first(where: { $0.id == coffee.id })?.isAvailable ?? false },
                            set: { coffeeController.setAvailability($0, for: coffee) }
                        )).labelsHidden().tint(AppTheme.sage)
                    }
                    .padding(12)
                    if index < coffeeController.coffees.count - 1 { Divider().padding(.leading, 80) }
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
        }
    }

    private var ordersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent orders").font(.system(size: 23, weight: .bold, design: .serif)).foregroundStyle(AppTheme.espresso)
                    Text("Pickup details at a glance.").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "takeoutbag.and.cup.and.straw.fill").font(.title3).foregroundStyle(AppTheme.gold)
            }
            if orderController.orders.isEmpty {
                HStack(spacing: 12) {
                    Text("☕️").font(.title2)
                    Text("No orders just yet. Your next happy customer is on the way!").font(.subheadline).foregroundStyle(.secondary)
                }
                .padding(16).frame(maxWidth: .infinity, alignment: .leading).background(.white).clipShape(RoundedRectangle(cornerRadius: 19))
            } else {
                ForEach(Array(orderController.orders.prefix(5))) { order in
                    NavigationLink { OrderDetailView(order: order) } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "receipt").foregroundStyle(AppTheme.brown).frame(width: 42, height: 42).background(AppTheme.cream).clipShape(RoundedRectangle(cornerRadius: 13))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("#\(order.orderNumber) · \(order.customerName)").font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.espresso)
                                Text("\(order.items.count) item(s) · \(order.status)").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("₱\(order.total, specifier: "%.0f")").font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.brown)
                        }
                        .padding(13).background(.white).clipShape(RoundedRectangle(cornerRadius: 17))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var footer: some View {
        HStack(spacing: 8) {
            Image(systemName: "heart.fill").foregroundStyle(AppTheme.pink)
            Text("Good coffee. Good people. Good day.").font(.caption.weight(.medium)).foregroundStyle(AppTheme.brown)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 9)
    }
}
