import SwiftUI

struct LoginView: View {
    @StateObject private var loginController = LoginController()
    @State private var email = ""
    @State private var password = ""
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                brandHeader

                VStack(alignment: .leading, spacing: 8) {
                    Text("Come on in")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.espresso)
                    Text("Choose your café experience.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    roleButton("Customer", subtitle: "Order a little joy", icon: "person.crop.circle.fill", role: .customer)
                    roleButton("Admin", subtitle: "Manage the café", icon: "cup.and.saucer.fill", role: .admin)
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("YOUR SIGN-IN")
                        .font(.caption2.weight(.bold))
                        .tracking(1.5)
                        .foregroundStyle(AppTheme.gold)
                    field("Email address", icon: "envelope", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    HStack(spacing: 11) {
                        Image(systemName: "lock").foregroundStyle(AppTheme.gold)
                        SecureField("Password", text: $password)
                    }
                    .padding(15)
                    .background(AppTheme.cream.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(18)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                if loginController.isAdminSelected {
                    Label("Demo admin: admin@militiacafe.com · letmein", systemImage: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if loginController.isCustomerSelected {
                    Text("For this demo, any valid email and non-empty password will sign in as a customer.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if !loginController.errorMessage.isEmpty {
                    Label(loginController.errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.red)
                }

                Button(action: signIn) {
                    HStack {
                        Text(loginController.isAdminSelected ? "Open admin studio" : "Let’s get brewing")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(18)
                    .background(AppTheme.brown.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 17))
                    .shadow(color: AppTheme.brown.opacity(0.17), radius: 10, x: 0, y: 5)
                }
                .disabled(loginController.selectedRole == .none)
                .opacity(loginController.selectedRole == .none ? 0.55 : 1)

                Text("By continuing, you’re joining the Militia Café community. Made with care, always.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
            }
            .padding(22)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $loginController.isLoggedIn) {
            if loginController.isAdminSelected {
                AdminView(admin: loginController.currentAdmin)
            } else {
                HomeView(customer: loginController.currentCustomer, selectedTab: $selectedTab)
            }
        }
    }

    private var brandHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 15).fill(AppTheme.brown)
                Image(systemName: "cup.and.saucer.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.cream)
            }
            .frame(width: 48, height: 48)
            VStack(alignment: .leading, spacing: 2) {
                Text("MILITIA CAFÉ")
                    .font(.caption.weight(.black))
                    .tracking(1.8)
                    .foregroundStyle(AppTheme.espresso)
                Text("A little comfort, anytime.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("☕️")
                .font(.title)
                .rotationEffect(.degrees(-9))
        }
        .padding(.top, 16)
    }

    private func roleButton(_ title: String, subtitle: String, icon: String, role: LoginController.UserRole) -> some View {
        let isSelected = loginController.selectedRole == role
        return Button {
            withAnimation(.easeInOut(duration: 0.18)) {
                loginController.chooseRole(role)
            }
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(isSelected ? AppTheme.gold : AppTheme.brown)
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(isSelected ? .white : AppTheme.espresso)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .white.opacity(0.75) : .secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background(isSelected ? AppTheme.brown : .white)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(isSelected ? AppTheme.gold.opacity(0.5) : AppTheme.cream, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func field(_ title: String, icon: String, text: Binding<String>) -> some View {
        HStack(spacing: 11) {
            Image(systemName: icon).foregroundStyle(AppTheme.gold)
            TextField(title, text: text)
        }
        .padding(15)
        .background(AppTheme.cream.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

    private func signIn() {
        if loginController.isAdminSelected {
            loginController.loginAsAdmin(email: email, password: password)
        } else {
            loginController.login(email: email, password: password)
        }
    }
}

#Preview {
    NavigationStack { LoginView() }
}
