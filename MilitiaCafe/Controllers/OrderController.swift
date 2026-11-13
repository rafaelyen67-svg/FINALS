//
//  OrderController.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation
import Combine

class OrderController: ObservableObject {
    
    @Published var orders: [Order] = []
    
    init() {
        loadOrders()
    }
    
    func createOrder(
        name: String,
        phone: String,
        items: [CartItem],
        branch: String,
        payment: String
    ) -> Order? {
        
        if name.isEmpty || phone.isEmpty || items.isEmpty {
            return nil
        }
        
        let number = Int.random(in: 1000...9999)
        let orderNumber = "MIL\(number)"
        
        let total = items.reduce(0) {
            $0 + ($1.price * Double($1.quantity))
        }
        
        let order = Order(
            orderNumber: orderNumber,
            customerName: name,
            phone: phone,
            items: items,
            total: total,
            branch: branch,
            payment: payment
        )
        
        orders.append(order)
        saveOrders()
        
        return order
    }
    
    func updateStatus(
        order: Order,
        status: String
    ) {
        
        if let index = orders.firstIndex(
            where: { $0.id == order.id }
        ) {
            orders[index].status = status
            saveOrders()
        }
    }
    
    func findOrder(
        orderNumber: String
    ) -> Order? {
        
        orders.first {
            $0.orderNumber == orderNumber
        }
    }
    
    private func saveOrders() {
        
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(
                data,
                forKey: "militiaOrders"
            )
        }
    }
    
    private func loadOrders() {
        
        guard let data = UserDefaults.standard.data(
            forKey: "militiaOrders"
        ) else {
            return
        }
        
        if let savedOrders = try? JSONDecoder().decode(
            [Order].self,
            from: data
        ) {
            orders = savedOrders
        }
    }
}


