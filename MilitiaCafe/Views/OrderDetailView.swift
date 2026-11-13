//
//  OrderDetailView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct OrderDetailView: View {
    
    let order: Order
    
    @EnvironmentObject var orderController: OrderController
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 18) {
                
                Text("Order #\(order.orderNumber)")
                    .font(.system(
                        size: 30,
                        weight: .bold,
                        design: .serif
                    ))
                    .foregroundStyle(AppTheme.brown)
                
                QRCodeView(
                    code: order.orderNumber
                )
                .frame(maxWidth: .infinity)
                
                Text("Customer")
                    .font(.headline)
                
                Text(order.customerName)
                
                Text("Phone")
                    .font(.headline)
                
                Text(order.phone)
                
                Divider()
                
                Text("Coffee")
                    .font(.title2)
                    .bold()
                
                ForEach(order.items) { item in
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(item.coffee.name)
                            .font(.headline)
                        
                        Text("Flavor: \(item.flavor)")
                        Text("Sugar: \(item.sugar)")
                        Text("Temperature: \(item.temperature)")
                        Text("Size: \(item.size)")
                        Text("Topping: \(item.topping)")
                        Text("Quantity: \(item.quantity)")
                        
                        Text(
                            "₱\(item.price * Double(item.quantity), specifier: "%.0f")"
                        )
                        .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                }
                
                Divider()
                
                Text("Total")
                    .font(.headline)
                
                Text(
                    "₱\(order.total, specifier: "%.0f")"
                )
                .font(.title2)
                .bold()
                .foregroundStyle(AppTheme.brown)
                
                Text("Pickup")
                    .font(.headline)
                
                Text(order.branch)
                
                Text("Payment")
                    .font(.headline)
                
                Text(order.payment)
                
                Text("Status")
                    .font(.headline)
                
                Text(order.status)
                    .foregroundStyle(AppTheme.brown)
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("Order Details")
    }
}


