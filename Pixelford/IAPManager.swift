//
//  IAPManager.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager: NSObject {
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:[SKProduct] = []
    
    func setupPurchases(_ completion: @escaping (Bool) -> Void) {
        // Check if we can make payments
    }
}
