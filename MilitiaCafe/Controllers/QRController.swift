//
//  QRController.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import Foundation
import Combine

class QRController: ObservableObject {
    
    @Published var scannedCode = ""
    @Published var scannedOrder: Order?
    
    func scan(
        code: String,
        orderController: OrderController
    ) {
        
        scannedCode = code
        
        scannedOrder = orderController.findOrder(
            orderNumber: code
        )
    }
    
    func clearScan() {
        scannedCode = ""
        scannedOrder = nil
    }
}


