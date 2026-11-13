import SwiftUI

struct CoffeeView: View {
    @EnvironmentObject private var coffeeController: CoffeeController
    @State private var searchText = ""
    @State private var selectedCategory = "All"

    private let categories = ["All", "Espresso", "Milky", "Chocolate"]

    private var filteredCoffees: [Coffee] {
        coffeeController.availableCoffees.filter { coffee in
            let matchesSearch = searchText.isEmpty || coffee.name.localizedCaseInsensitiveContains(searchText) || coffee.description.localizedCaseInsensitiveContains(searchText)
            let name = coffee.name.lowercased()
            let matchesCategory: Bool
            switch selectedCategory {
            case "Espresso": matchesCategory = name.contains("espresso") || name.contains("americano")
            case "Milky": matchesCategory = name.contains("latte") || name.contains("cappuccino") || name.contains("macchiato")
            case "Chocolate": matchesCategory = name.contains("mocha")
            default: matchesCategory = true
            }
            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("THE HAPPY PLACE")
                        .font(.caption2.weight(.bold))
                        .tracking(1.8)
                        .foregroundStyle(AppTheme.gold)
                    Text("What's your\nkind of coffee?")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.espresso)
                    Text("Good beans. Good mood. Great choice.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ZStack(alignment: .trailing) {
                    Image("coffee menu")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 155)
                        .clipped()
                        .overlay(LinearGradient(colors: [.black.opacity(0.48), .clear], startPoint: .leading, endPoint: .trailing))
                    VStack(alignment: .leading, spacing: 5) {
                        Text("A little sip\nof happiness.")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                        Text("FIND YOUR NEW FAVORITE")
                            .font(.caption2.weight(.bold))
                            .tracking(1.2)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(18)
                }
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay {
                    if UIImage(named: "coffee menu") == nil {
                        RoundedRectangle(cornerRadius: 22).fill(AppTheme.brown)
                    }
                }

                HStack(spacing: 9) {
                    Image(systemName: "magnifyingglass").foregroundStyle(AppTheme.gold)
                    TextField("Search your next favorite", text: $searchText)
                        .textInputAutocapitalization(.never)
                }
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 9) {
                        ForEach(categories, id: \.self) { category in
                            Button { selectedCategory = category } label: {
                                Text(category)
                                    .font(.caption.weight(.bold))
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .foregroundStyle(selectedCategory == category ? .white : AppTheme.brown)
                                    .background(selectedCategory == category ? AppTheme.brown : .white)
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                HStack {
                    Text("Brewed for you")
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.espresso)
                    Spacer()
                    Text("\(filteredCoffees.count) drinks")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                if filteredCoffees.isEmpty {
                    ContentUnavailableView(searchText.isEmpty ? "The bar is resting" : "No coffee found", systemImage: "cup.and.saucer", description: Text(searchText.isEmpty ? "Please check back soon for available coffee." : "Try another name or category."))
                        .padding(.top, 20)
                } else {
                    ForEach(filteredCoffees) { coffee in
                        NavigationLink { CoffeeDetailView(coffee: coffee) } label: {
                            CoffeeCard(coffee: coffee)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle("Coffee")
        .navigationBarTitleDisplayMode(.inline)
    }
}
