import SwiftUI

struct LoginView: View {
    @StateObject private var loginController = LoginController()
    @State private var email = ""
    @State private var password = ""
    @State private var selectedTab = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("YOUR DAILY RITUAL")
                        .font(.caption.weight(.bold))
                        .tracking(2.2)
                        .foregroundStyle(AppTheme.gold)
                    Text("Welcome back.")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.espresso)
                    Text("Sign in to make your next cup a good one.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                HStack(spacing: 10) {
                    roleButton("Customer", icon: "person.fill", role: .customer)
                    roleButton("Admin", icon: "cup.and.saucer.fill", role: .admin)
                }

                VStack(spacing: 14) {
                    credentialField("Email address", text: $email, icon: "envelope")
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                        .padding(15)
                        .background(AppTheme.cream.opacity(0.65))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .accessibilityLabel("Password")
                }

                if loginController.isAdminSelected {
                    Text("Demo admin: admin@militiacafe.com · letmein")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if !loginController.errorMessage.isEmpty {
                    Label(loginController.errorMessage, systemImage: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Button(action: signIn) {
                    HStack {
                        Text(loginController.isAdminSelected ? "Open dashboard" : "Sign in")
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(17)
                    .background(AppTheme.brown)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(loginController.selectedRole == .none)
                .opacity(loginController.selectedRole == .none ? 0.55 : 1)

                Text("Customer accounts use this demo sign-in form. Connect a secure authentication provider before using real customer or staff accounts.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $loginController.isLoggedIn) {
            if loginController.isAdminSelected {
                AdminDashboardView(admin: loginController.currentAdmin)
            } else {
                HomeView(customer: loginController.currentCustomer, selectedTab: $selectedTab)
            }
        }
    }

    private func roleButton(_ title: String, icon: String, role: LoginController.UserRole) -> some View {
        let selected = loginController.selectedRole == role
        return Button {
            loginController.chooseRole(role)
        } label: {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundStyle(selected ? .white : AppTheme.brown)
                .background(selected ? AppTheme.brown : AppTheme.cream)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private func credentialField(_ title: String, text: Binding<String>, icon: String) -> some View {
        HStack(spacing: 11) {
            Image(systemName: icon).foregroundStyle(AppTheme.gold)
            TextField(title, text: text)
        }
        .padding(15)
        .background(AppTheme.cream.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 14))
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
