//
//  CartItem.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation

struct CartItem: Identifiable, Codable {
    
    let id: UUID
    
    var coffee: Coffee
    var flavor: String
    var sugar: String
    var temperature: String
    var size: String
    var topping: String
    var price: Double
    var quantity: Int
    
    init(
        id: UUID = UUID(),
        coffee: Coffee,
        flavor: String,
        sugar: String,
        temperature: String,
        size: String,
        topping: String,
        price: Double,
        quantity: Int
    ) {
        self.id = id
        self.coffee = coffee
        self.flavor = flavor
        self.sugar = sugar
        self.temperature = temperature
        self.size = size
        self.topping = topping
        self.price = price
        self.quantity = quantity
    }
}


