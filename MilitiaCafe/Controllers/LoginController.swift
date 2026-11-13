//
//  LoginController.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//
import Foundation
import Combine

class LoginController: ObservableObject {
    
    @Published var currentCustomer: Customer?
    @Published var currentAdmin: Admin?
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    enum LoginStage { case welcome, roleSelection, credentials }
    @Published var stage: LoginStage = .welcome
    @Published var selectedRole: UserRole = .none
    
    // UI helpers
    var showRoleSelection: Bool { stage == .roleSelection }
    var showCredentials: Bool { stage == .credentials }
    var isCustomerSelected: Bool { selectedRole == .customer }
    var isAdminSelected: Bool { selectedRole == .admin }
    
    enum UserRole { case none, customer, admin }
    var userRole: UserRole {
        if currentAdmin != nil { return .admin }
        if currentCustomer != nil { return .customer }
        return .none
    }
    
    init(autoStart: Bool = true) {
        if autoStart {
            // Immediately present role selection so the user can choose.
            self.stage = .roleSelection
        }
    }
    
    // MARK: - Flow control
    func start() {
        // Called when user taps "Get Started"
        errorMessage = ""
        stage = .roleSelection
        selectedRole = .none
    }

    func chooseRole(_ role: UserRole) {
        selectedRole = role
        errorMessage = ""
        stage = .credentials
    }

    func resetFlow() {
        errorMessage = ""
        stage = .roleSelection
        selectedRole = .none
    }
    
    func login(
        email: String,
        password: String
    ) {
        
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter your email and password."
            return
        }
        
        currentAdmin = nil
        currentCustomer = Customer(
            name: "Rafael",
            email: email,
            phone: ""
        )
        
        isLoggedIn = true
        errorMessage = ""
        stage = .roleSelection
    }
    
    func loginAsAdmin(email: String, password: String) {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please enter your email and password."
            return
        }
        // Simple placeholder admin check. Replace with real authentication later.
        let allowedAdmins: [String: String] = [
            "admin@militiacafe.com": "letmein",
            "owner@militiacafe.com": "ownerpass"
        ]
        guard let expected = allowedAdmins[email.lowercased()], expected == password else {
            errorMessage = "Invalid admin credentials."
            isLoggedIn = false
            currentAdmin = nil
            return
        }
        currentCustomer = nil
        currentAdmin = Admin(name: "Administrator", email: email)
        isLoggedIn = true
        errorMessage = ""
        stage = .roleSelection
    }
    
    func logout() {
        currentAdmin = nil
        currentCustomer = nil
        isLoggedIn = false
        stage = .roleSelection
    }
}

struct Admin: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var email: String
}
