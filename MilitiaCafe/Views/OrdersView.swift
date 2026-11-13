//
//  OrdersView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct OrdersView: View {
    
    @EnvironmentObject var orderController: OrderController
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 15) {
                
                if orderController.orders.isEmpty {
                    
                    Text("No orders yet ☕")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding(.top, 100)
                    
                } else {
                    
                    ForEach(orderController.orders) { order in
                        
                        NavigationLink {
                            OrderDetailView(
                                order: order
                            )
                        } label: {
                            OrderCard(order: order)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
        .navigationTitle("My Orders")
    }
}


