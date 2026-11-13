//
//  MilitiaCafeApp.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/15/26.
//

import SwiftUI

@main
struct MilitiaCafeApp: App {
    
    @StateObject private var cartController = CartController()
    @StateObject private var orderController = OrderController()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(cartController)
                .environmentObject(orderController)
        }
    }
}
