//
//  ProfileView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct ProfileView: View {
    
    let customer: Customer?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("☕")
                .font(.system(size: 70))
            
            Text("Profile")
                .font(.system(
                    size: 32,
                    weight: .bold,
                    design: .serif
                ))
                .foregroundStyle(AppTheme.brown)
            
            if let customer = customer {
                
                Text(customer.name)
                    .font(.title2)
                    .bold()
                
                Text(customer.email)
                    .foregroundStyle(.secondary)
                
                if !customer.phone.isEmpty {
                    Text(customer.phone)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("Profile")
    }
}




