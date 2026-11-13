//
//  CoffeeController.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation
import Combine

class CoffeeController: ObservableObject {
    
    @Published var coffees: [Coffee] = [
        
        Coffee(
            name: "Militia Latte",
            description: "Smooth, creamy and comforting.",
            basePrice: 145,
            imageName: "militia-latte"
        ),
        
        Coffee(
            name: "Americano",
            description: "Bold and freshly brewed.",
            basePrice: 120,
            imageName: "americano"
        ),
        
        Coffee(
            name: "Cappuccino",
            description: "Rich espresso with creamy foam.",
            basePrice: 140,
            imageName: "cappuccino"
        ),
        
        Coffee(
            name: "Espresso",
            description: "Strong, rich and classic.",
            basePrice: 100,
            imageName: "espresso"
        ),
        
        Coffee(
            name: "Caramel Macchiato",
            description: "Sweet caramel with smooth espresso.",
            basePrice: 160,
            imageName: "caramel-macchiato"
        ),
        
        Coffee(
            name: "Mocha",
            description: "Chocolate and coffee in one cup.",
            basePrice: 155,
            imageName: "mocha"
        ),
        
        Coffee(
            name: "Spanish Latte",
            description: "Creamy, sweet and satisfying.",
            basePrice: 150,
            imageName: "spanish-latte"
        )
    ]
    
    
    func calculatePrice(
        coffee: Coffee,
        size: String,
        topping: String
    ) -> Double {
        
        var price = coffee.basePrice
        
        if size == "Small" {
            price -= 20
        }
        
        if size == "Large" {
            price += 30
        }
        
        if topping != "None" {
            price += 15
        }
        
        return price
    }
}
