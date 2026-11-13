//
//  Coffee.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation

struct Coffee: Identifiable, Codable {
    
    let id: UUID
    let name: String
    let description: String
    let basePrice: Double
    let imageName: String
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        basePrice: Double,
        imageName: String
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.basePrice = basePrice
        self.imageName = imageName
    }
}


