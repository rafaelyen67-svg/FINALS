//
//  CoffeeDetailView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct CoffeeDetailView: View {
    
    let coffee: Coffee
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 18) {
                
                Image(coffee.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 25)
                    )
                
                Text(coffee.name)
                    .font(.system(
                        size: 32,
                        weight: .bold,
                        design: .serif
                    ))
                    .foregroundStyle(AppTheme.brown)
                
                Text(coffee.description)
                    .foregroundStyle(.secondary)
                
                Text(
                    "₱\(coffee.basePrice, specifier: "%.0f")"
                )
                .font(.title2)
                .bold()
                .foregroundStyle(AppTheme.brown)
                
                NavigationLink("Customize Coffee") {
                    CoffeeCustomizationView(
                        coffee: coffee
                    )
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.brown)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
    }
}


