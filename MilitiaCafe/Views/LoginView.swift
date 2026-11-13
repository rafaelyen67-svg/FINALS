
import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginController = LoginController()
    
    @State private var email = ""
    @State private var password = ""
    @State private var selectedTab = 0
    
    var body: some View {
        
        ZStack {
            
            AppTheme.cream
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("☕")
                    .font(.system(size: 60))
                
                Text("Welcome Back")
                    .font(
                        .system(
                            size: 36,
                            weight: .bold,
                            design: .serif
                        )
                    )
                    .foregroundStyle(AppTheme.brown)
                
                Text("Your favorite coffee is waiting.")
                    .foregroundStyle(.secondary)
                
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                
                if !loginController.errorMessage.isEmpty {
                    Text(loginController.errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
                
                Button {
                    loginController.login(
                        email: email,
                        password: password
                    )
                } label: {
                    Text("Log In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.brown)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                }
                
                Spacer()
            }
            .padding(30)
        }
        .navigationDestination(
            isPresented: $loginController.isLoggedIn
        ) {
            HomeView(
                customer: loginController.currentCustomer,
                selectedTab: $selectedTab
            )
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}


