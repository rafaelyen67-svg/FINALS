import SwiftUI

struct CoffeeView: View {
    
    @StateObject private var coffeeController = CoffeeController()
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 18) {
                
                Text("Our Coffee")
                    .font(
                        .system(
                            size: 32,
                            weight: .bold,
                            design: .serif
                        )
                    )
                    .foregroundStyle(AppTheme.brown)
                
                Text("A little comfort, anytime.")
                    .foregroundStyle(.secondary)
                
                ForEach(coffeeController.coffees) { coffee in
                    
                    NavigationLink {
                        CoffeeDetailView(coffee: coffee)
                    } label: {
                        CoffeeCard(coffee: coffee)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("Coffee")
        .navigationBarTitleDisplayMode(.inline)
    }
}
