//
//  CoffeeCustomizationView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct CoffeeCustomizationView: View {
    
    let coffee: Coffee
    
    @EnvironmentObject var cartController: CartController
    
    @StateObject private var coffeeController =
        CoffeeController()
    
    @State private var flavor = "Vanilla"
    @State private var sugar = "Regular"
    @State private var temperature = "Iced"
    @State private var size = "Medium"
    @State private var topping = "None"
    @State private var quantity = 1
    @State private var addedToCart = false
    
    let flavors = [
        "Vanilla",
        "Caramel",
        "Mocha",
        "Hazelnut",
        "Strawberry"
    ]
    
    let sugars = [
        "No Sugar",
        "Less Sugar",
        "Regular",
        "Extra Sugar"
    ]
    
    let temperatures = [
        "Hot",
        "Iced"
    ]
    
    let sizes = [
        "Small",
        "Medium",
        "Large"
    ]
    
    let toppings = [
        "None",
        "Whipped Cream",
        "Caramel Drizzle",
        "Chocolate Drizzle",
        "Coffee Jelly"
    ]
    
    var price: Double {
        
        coffeeController.calculatePrice(
            coffee: coffee,
            size: size,
            topping: topping
        )
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                Image(coffee.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22)
                    )
                
                Text("Customize Your Coffee")
                    .font(.system(
                        size: 30,
                        weight: .bold,
                        design: .serif
                    ))
                    .foregroundStyle(AppTheme.brown)
                
                Text(coffee.name)
                    .font(.title2)
                    .bold()
                
                Text("Flavor")
                    .font(.headline)
                
                Picker("Flavor", selection: $flavor) {
                    ForEach(flavors, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Text("Sugar Level")
                    .font(.headline)
                
                Picker("Sugar", selection: $sugar) {
                    ForEach(sugars, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Text("Temperature")
                    .font(.headline)
                
                Picker("Temperature", selection: $temperature) {
                    ForEach(temperatures, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                Text("Size")
                    .font(.headline)
                
                Picker("Size", selection: $size) {
                    ForEach(sizes, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                Text("Topping")
                    .font(.headline)
                
                Picker("Topping", selection: $topping) {
                    ForEach(toppings, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Text("Quantity")
                    .font(.headline)
                
                QuantityControl(
                    quantity: $quantity
                )
                
                HStack {
                    
                    Text("Price")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(
                        "₱\(price * Double(quantity), specifier: "%.0f")"
                    )
                    .font(.title2)
                    .bold()
                    .foregroundStyle(AppTheme.brown)
                }
                
                Button {
                    
                    let item = CartItem(
                        coffee: coffee,
                        flavor: flavor,
                        sugar: sugar,
                        temperature: temperature,
                        size: size,
                        topping: topping,
                        price: price,
                        quantity: quantity
                    )
                    
                    cartController.addItem(item)
                    addedToCart = true
                    
                } label: {
                    
                    HStack {
                        Image(systemName: "cart.fill")
                        Text("Add to Cart")
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
                
                if addedToCart {
                    Text("Added to cart ☕")
                        .foregroundStyle(.green)
                }
                
                NavigationLink("View Cart") {
                    CartView()
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(AppTheme.brown)
            }
            .padding()
        }
        .background(
            AppTheme.cream
                .ignoresSafeArea()
        )
    }
}





