//
//  IAPManager.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate {
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:[SKProduct] = []
    
    func setupPurchases(_ completion: @escaping (Bool) -> Void) {
        // Check if we can make payments
        if SKPaymentQueue.canMakePayments() {
            completion(true)
            return
        }
        
        completion(false)
    }
    
    func getProductIdentifiers() -> [String] {
        var identifiers:[String] = []
        
        if let fileUrl = Bundle.main.url(forResource: "products", withExtension: "plist") {
            let products = NSArray(contentsOf: fileUrl)!
            
            for product in products as! [String] {
                identifiers.append(product)
            }
        }
        
        return identifiers
    }
    
    func performProductRequestForIdentifiers(identifiers: [String]) {
        let products = NSSet(array: identifiers) as! Set<String>
        
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request.delegate = self
        self.request.start()
    }
    
    // MARK: SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        print("products: \(self.products)")
    }
}
