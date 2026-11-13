//
//  CartView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartController: CartController
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                if cartController.items.isEmpty {
                    
                    Text("Your cart is empty ☕")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding(.top, 100)
                    
                    Text("Find your favorite coffee and start your order.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    
                } else {
                    
                    ForEach(cartController.items) { item in
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text(item.coffee.name)
                                .font(.title3)
                                .bold()
                            
                            Text("Flavor: \(item.flavor)")
                            Text("Sugar: \(item.sugar)")
                            Text("Temperature: \(item.temperature)")
                            Text("Size: \(item.size)")
                            Text("Topping: \(item.topping)")
                            Text("Quantity: \(item.quantity)")
                            
                            Text(
                                "₱\(item.price * Double(item.quantity), specifier: "%.0f")"
                            )
                            .font(.headline)
                            .foregroundStyle(AppTheme.brown)
                            
                            Button("Remove") {
                                cartController.removeItem(item)
                            }
                            .foregroundStyle(.red)
                        }
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding()
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 18)
                        )
                    }
                    
                    Divider()
                    
                    HStack {
                        
                        Text("Total")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Text(
                            "₱\(cartController.total, specifier: "%.0f")"
                        )
                        .font(.title2)
                        .bold()
                        .foregroundStyle(AppTheme.brown)
                    }
                    
                    NavigationLink("Checkout") {
                        CheckoutView()
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
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("My Cart")
    }
}


