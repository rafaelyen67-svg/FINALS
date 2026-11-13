import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Image("cafe-background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    Text("☕")
                        .font(.system(size: 65))
                    
                    Text("Militia Café")
                        .font(
                            .system(
                                size: 42,
                                weight: .bold,
                                design: .serif
                            )
                        )
                        .foregroundStyle(.white)
                    
                    Text("A little comfort, anytime.")
                        .font(.title3)
                        .italic()
                        .foregroundStyle(.white)
                    
                    Text("Coffee")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundStyle(AppTheme.brown)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 18)
                            )
                    }
                }
                .padding(30)
            }
        }
    }
}

#Preview {
    WelcomeView()
}


