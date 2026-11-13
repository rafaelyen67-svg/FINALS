//
//  CoffeeCard.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct CoffeeCard: View {
    
    let coffee: Coffee
    
    var body: some View {
        HStack(spacing: 15) {
            
            Image(coffee.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 95, height: 95)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(coffee.name)
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .serif
                        )
                    )
                    .foregroundStyle(AppTheme.brown)
                
                Text(coffee.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                Text("₱\(coffee.basePrice, specifier: "%.0f")")
                    .font(.headline)
                    .foregroundStyle(AppTheme.brown)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(AppTheme.brown)
        }
        .padding()
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}

