import SwiftUI

struct HomeView: View {

    let customer: Customer?

    @Binding var selectedTab: Int

    var body: some View {

        TabView(selection: $selectedTab) {

            // MARK: - HOME

            NavigationStack {

                ScrollView {

                    VStack(alignment: .leading, spacing: 20) {

                        Text(
                            "Hello, \(customer?.name ?? "Coffee Lover")! ☕"
                        )
                        .font(
                            .system(
                                size: 30,
                                weight: .bold,
                                design: .serif
                            )
                        )
                        .foregroundStyle(AppTheme.brown)

                        Text("What would you like today?")
                            .foregroundStyle(.secondary)

                        VStack(
                            alignment: .leading,
                            spacing: 10
                        ) {

                            Text("A little comfort, anytime.")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text(
                                "Enjoy your favorite coffee from Militia Café."
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )

                        Button {

                            selectedTab = 1

                        } label: {

                            HStack {

                                VStack(
                                    alignment: .leading,
                                    spacing: 5
                                ) {

                                    Text("Explore Our Coffee")
                                        .font(.headline)

                                    Text("View our coffee menu.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Image(
                                    systemName:
                                        "cup.and.saucer.fill"
                                )
                                .font(.title)
                            }
                            .foregroundStyle(AppTheme.brown)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 20)
                            )
                        }
                    }
                    .padding()
                }
                .background(AppTheme.cream)
                .navigationTitle("Militia Café")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label(
                    "Home",
                    systemImage: "house.fill"
                )
            }
            .tag(0)

            // MARK: - COFFEE

            NavigationStack {

                CoffeeView()
            }
            .tabItem {
                Label(
                    "Coffee",
                    systemImage: "cup.and.saucer.fill"
                )
            }
            .tag(1)

            // MARK: - CART

            NavigationStack {

                CartView()
            }
            .tabItem {
                Label(
                    "Cart",
                    systemImage: "cart.fill"
                )
            }
            .tag(2)

            // MARK: - ORDERS

            NavigationStack {

                OrdersView()
            }
            .tabItem {
                Label(
                    "Orders",
                    systemImage: "clock.fill"
                )
            }
            .tag(3)

            // MARK: - PROFILE

            NavigationStack {

                ProfileView(
                    customer: customer
                )
            }
            .tabItem {
                Label(
                    "Profile",
                    systemImage: "person.fill"
                )
            }
            .tag(4)
        }
        .tint(AppTheme.brown)

        // When "Back to Home" is pressed
        .onReceive(
            NotificationCenter.default.publisher(
                for: .goToHome
            )
        ) { _ in

            selectedTab = 0
        }
    }
}
