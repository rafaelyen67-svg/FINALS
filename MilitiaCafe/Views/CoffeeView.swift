import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject private var coffeeController: CoffeeController

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Made for your moment.")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.espresso)
                    Text("Small-batch favorites, brewed with care.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 4)

                if coffeeController.availableCoffees.isEmpty {
                    ContentUnavailableView("The bar is resting", systemImage: "cup.and.saucer", description: Text("Please check back soon for available coffee."))
                        .padding(.top, 40)
                } else {
                    ForEach(coffeeController.availableCoffees) { coffee in
                        NavigationLink { CoffeeDetailView(coffee: coffee) } label: {
                            CoffeeCard(coffee: coffee)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle("Coffee")
        .navigationBarTitleDisplayMode(.inline)
    }
}
