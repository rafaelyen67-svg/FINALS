//
//  OrderCard.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct OrderCard: View {
    
    let order: Order
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Order #\(order.orderNumber)")
                .font(.headline)
                .foregroundStyle(AppTheme.brown)
            
            if let item = order.items.first {
                Text(item.coffee.name)
            }
            
            Text("₱\(order.total, specifier: "%.0f")")
                .font(.headline)
            
            Text(order.branch)
                .foregroundStyle(.secondary)
            
            Text(order.status)
                .font(.subheadline)
                .bold()
                .foregroundStyle(AppTheme.brown)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }
}


