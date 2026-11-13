import SwiftUI

struct ProfileView: View {
    let customer: Customer?
    @EnvironmentObject private var loginController: LoginController
    @EnvironmentObject private var orderController: OrderController
    @AppStorage("militiaCafe.profile.rating") private var savedRating = 0
    @AppStorage("militiaCafe.profile.favoriteDrink") private var favoriteDrink = "Latte"
    @AppStorage("militiaCafe.profile.visitReason") private var visitReason = "A coffee break"
    @State private var showLogoutConfirmation = false
    @State private var showThanks = false

    private let drinks = ["Latte", "Americano", "Cappuccino", "Mocha", "Espresso"]
    private let reasons = ["A coffee break", "Study time", "Meet friends", "Takeaway"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                profileHeader
                favoriteSection
                ratingSection
                visitSection
                faqSection
                logoutButton
            }
            .padding(20)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle("My profile")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thanks for the love! ☕️", isPresented: $showThanks) {
            Button("You're welcome", role: .cancel) { }
        } message: {
            Text("Your rating helps us make every cup even better.")
        }
        .confirmationDialog("Log out of Militia Café?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
            Button("Log out", role: .destructive) { loginController.logout() }
            Button("Stay signed in", role: .cancel) { }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle().fill(AppTheme.latte).frame(width: 92, height: 92)
                Text(initials)
                    .font(.system(size: 30, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.brown)
            }
            VStack(spacing: 4) {
                Text(customer?.name.isEmpty == false ? customer!.name : "Coffee Lover")
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.espresso)
                Text(customer?.email ?? "Your Militia Café account")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let phone = customer?.phone, !phone.isEmpty {
                    Label(phone, systemImage: "phone")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            HStack(spacing: 8) {
                Image(systemName: "cup.and.saucer.fill")
                Text("Militia Café regular")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppTheme.brown)
            .padding(.horizontal, 13)
            .padding(.vertical, 8)
            .background(AppTheme.cream)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(.white)
        .clipShape(AppTheme.cardShape)
    }

    private var favoriteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Your usual", subtitle: "We’ll remember what you love.", icon: "heart.fill")
            HStack {
                Label("Favorite coffee", systemImage: "cup.and.saucer.fill")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppTheme.espresso)
                Spacer()
                Picker("Favorite coffee", selection: $favoriteDrink) {
                    ForEach(drinks, id: \.self) { Text($0).tag($0) }
                }
                .tint(AppTheme.brown)
            }
            .padding(15)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 17))
        }
    }

    private var ratingSection: some View {
        VStack(alignment: .leading, spacing: 13) {
            sectionTitle("How’s your café experience?", subtitle: "A quick rating makes our day.", icon: "star.fill")
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        savedRating = star
                        showThanks = true
                    } label: {
                        Image(systemName: star <= savedRating ? "star.fill" : "star")
                            .font(.system(size: 27))
                            .foregroundStyle(star <= savedRating ? AppTheme.gold : AppTheme.stone)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Rate \(star) out of 5 stars")
                }
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 17))
            if savedRating > 0 {
                Text("Your rating: \(savedRating) out of 5 · Thank you!")
                    .font(.caption)
                    .foregroundStyle(AppTheme.sage)
                    .padding(.leading, 3)
            }
        }
    }

    private var visitSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("A little about you", subtitle: "What brings you by most often?", icon: "sun.max.fill")
            Picker("What brings you by?", selection: $visitReason) {
                ForEach(reasons, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .tint(AppTheme.brown)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 17))
            HStack(spacing: 12) {
                miniStat(value: "\(orderController.orders.count)", title: "ORDERS", icon: "receipt")
                miniStat(value: favoriteDrink, title: "YOUR GO-TO", icon: "heart")
            }
        }
    }

    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Good to know", subtitle: "A few quick answers.", icon: "questionmark.circle.fill")
            VStack(spacing: 0) {
                faqRow(question: "How do I collect my order?", answer: "Show the order QR code from your confirmation screen to our barista at your selected pickup branch.")
                Divider().padding(.leading, 15)
                faqRow(question: "Can I change my coffee?", answer: "Customize the size, temperature, sweetness, flavor, and toppings before adding your drink to the cart.")
                Divider().padding(.leading, 15)
                faqRow(question: "Why is a drink unavailable?", answer: "Our team may mark a drink sold out when ingredients run low. Check back later for availability.")
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }

    private var logoutButton: some View {
        Button(role: .destructive) {
            showLogoutConfirmation = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Log out")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AppTheme.brown)
            .padding(16)
            .background(AppTheme.blush.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }

    private func sectionTitle(_ title: String, subtitle: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.gold)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline).foregroundStyle(AppTheme.espresso)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
    }

    private func miniStat(value: String, title: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Image(systemName: icon).foregroundStyle(AppTheme.gold)
            Text(value).font(.subheadline.weight(.bold)).foregroundStyle(AppTheme.espresso).lineLimit(1)
            Text(title).font(.system(size: 9, weight: .heavy)).tracking(0.7).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func faqRow(question: String, answer: String) -> some View {
        DisclosureGroup {
            Text(answer)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
        } label: {
            Text(question)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.espresso)
        }
        .tint(AppTheme.brown)
        .padding(15)
    }

    private var initials: String {
        let parts = (customer?.name ?? "C").split(separator: " ")
        let letters = parts.prefix(2).compactMap(\.first)
        return letters.isEmpty ? "C" : String(letters).uppercased()
    }
}
