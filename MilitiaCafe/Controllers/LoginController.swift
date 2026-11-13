import Foundation
import Combine

@MainActor
class LoginController: ObservableObject {
    @Published var currentCustomer: Customer?
    @Published var currentAdmin: Admin?
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    @Published var stage: LoginStage = .roleSelection
    @Published var selectedRole: UserRole = .none

    enum LoginStage { case welcome, roleSelection, credentials }
    enum UserRole { case none, customer, admin }

    var isCustomerSelected: Bool { selectedRole == .customer }
    var isAdminSelected: Bool { selectedRole == .admin }

    func start() {
        errorMessage = ""
        stage = .roleSelection
        selectedRole = .none
    }

    func chooseRole(_ role: UserRole) {
        selectedRole = role
        errorMessage = ""
        stage = .credentials
    }

    func resetFlow() { start() }

    func login(email: String, password: String) {
        guard selectedRole == .customer else {
            errorMessage = "Choose Customer to sign in."
            return
        }
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedEmail.contains("@"), !password.isEmpty else {
            errorMessage = "Enter a valid email address and password."
            return
        }
        currentAdmin = nil
        currentCustomer = Customer(name: customerName(from: normalizedEmail), email: normalizedEmail, phone: "")
        isLoggedIn = true
        errorMessage = ""
    }

    func loginAsAdmin(email: String, password: String) {
        let allowedAdmins = ["admin@militiacafe.com": "letmein"]
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let expected = allowedAdmins[normalizedEmail], expected == password else {
            errorMessage = "Admin email or password is incorrect."
            isLoggedIn = false
            currentAdmin = nil
            return
        }
        currentCustomer = nil
        currentAdmin = Admin(name: "Café Admin", email: normalizedEmail)
        isLoggedIn = true
        errorMessage = ""
    }

    func logout() {
        currentAdmin = nil
        currentCustomer = nil
        isLoggedIn = false
        start()
    }

    private func customerName(from email: String) -> String {
        let firstPart = email.split(separator: "@").first.map(String.init) ?? "Coffee Lover"
        return firstPart.replacingOccurrences(of: ".", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}

struct Admin: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var email: String
}
