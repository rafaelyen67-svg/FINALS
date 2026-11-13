//
//  QuantityControl.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct QuantityControl: View {
    
    @Binding var quantity: Int
    
    var body: some View {
        
        HStack(spacing: 20) {
            
            Button("-") {
                if quantity > 1 {
                    quantity -= 1
                }
            }
            
            Text("\(quantity)")
                .font(.title3)
                .frame(width: 40)
            
            Button("+") {
                quantity += 1
            }
        }
        .font(.title2)
        .foregroundStyle(AppTheme.brown)
    }
}


