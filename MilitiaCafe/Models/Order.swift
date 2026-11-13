//
//  Order.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation

struct Order: Identifiable, Codable {
    
    let id: UUID
    let orderNumber: String
    let customerName: String
    let phone: String
    let items: [CartItem]
    let total: Double
    let branch: String
    let payment: String
    var status: String
    let date: Date
    
    init(
        id: UUID = UUID(),
        orderNumber: String,
        customerName: String,
        phone: String,
        items: [CartItem],
        total: Double,
        branch: String,
        payment: String,
        status: String = "Preparing",
        date: Date = Date()
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.customerName = customerName
        self.phone = phone
        self.items = items
        self.total = total
        self.branch = branch
        self.payment = payment
        self.status = status
        self.date = date
    }
}


