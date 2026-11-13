import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [AppTheme.espresso, AppTheme.brown, Color(red: 0.55, green: 0.34, blue: 0.22)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                Circle()
                    .fill(AppTheme.gold.opacity(0.14))
                    .frame(width: 320, height: 320)
                    .offset(x: 150, y: -280)

                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 54, weight: .light))
                        .foregroundStyle(AppTheme.gold)
                        .padding(.bottom, 25)
                    Text("SLOW DOWN. SIP SOMETHING GOOD.")
                        .font(.caption.weight(.bold))
                        .tracking(2.2)
                        .foregroundStyle(AppTheme.gold)
                        .padding(.bottom, 12)
                    Text("Militia\nCafé")
                        .font(.system(size: 58, weight: .bold, design: .serif))
                        .lineSpacing(-3)
                        .foregroundStyle(.white)
                    Text("A little comfort, anytime.")
                        .font(.title3.italic())
                        .foregroundStyle(.white.opacity(0.78))
                        .padding(.top, 12)

                    Image("coffee menu")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 145)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).fill(AppTheme.espresso.opacity(0.15)))
                        .padding(.top, 24)
                        .accessibilityLabel("Militia Café coffee menu")

                    Spacer()
                    NavigationLink {
                        LoginView()
                    } label: {
                        HStack {
                            Text("Come on in")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .foregroundStyle(AppTheme.espresso)
                        .padding(18)
                        .background(AppTheme.cream)
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                    }
                    .padding(.bottom, 20)
                }
                .padding(26)
                .frame(maxWidth: 540, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
        }
        .tint(AppTheme.brown)
    }
}

#Preview { WelcomeView() }
