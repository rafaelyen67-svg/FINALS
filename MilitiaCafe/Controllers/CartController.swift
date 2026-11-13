//
//  CartController.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation
import Combine

class CartController: ObservableObject {
    
    @Published var items: [CartItem] = []
    
    func addItem(_ item: CartItem) {
        items.append(item)
    }
    
    func removeItem(_ item: CartItem) {
        items.removeAll {
            $0.id == item.id
        }
    }
    
    func updateQuantity(
        for item: CartItem,
        quantity: Int
    ) {
        
        guard quantity >= 1 else {
            return
        }
        
        if let index = items.firstIndex(
            where: { $0.id == item.id }
        ) {
            items[index].quantity = quantity
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    var total: Double {
        items.reduce(0) {
            $0 + ($1.price * Double($1.quantity))
        }
    }
}

