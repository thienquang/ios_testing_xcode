//
//  ProductManager.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/4/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import Foundation

struct ProductManager {
    static func handleProductPurchase(_ product: NSDictionary) {
        // Perform actions based on product identifier
        guard let product_id = product["product_id"] as? String else { return }
        
        if product_id.contains("com.pixelford.photoapp.consumable") {
            ProductManager.incrementCount(product_id: product_id, quantity: 1)
            return
        }
        
        if product_id.contains("com.pixelford.photoapp.filter") {
            ProductManager.unlockFunctionalityForProduct(productID: product_id)
            return
        }
        
        if product_id.contains("com.pixelford.photoapp.subscription") {
            guard let expires_date_ms = product["expires_date_ms"] as? String else { return }
            let expires_date = Double(expires_date_ms)
            validateSubscription(product_id: product_id, expires_date_ms: expires_date!)
        }
    }
    
    /**
     Checks if a given date is current, unlocks functionality accordingly
     */
 
    static func validateSubscription(product_id: String, expires_date_ms: Double) {
        if ProductManager.subscriptionIsValid(expires_date_ms: expires_date_ms) {
            ProductManager.unlockFunctionalityForProduct(productID: product_id)
        } else { ProductManager.lockFunctionalityForProduct(productID: product_id) }
    }
    
    /**
     Converts expiration date and returns result of date comparison to now
     */
    static func subscriptionIsValid(expires_date_ms: Double) -> Bool {
        if let expires = TimeInterval(exactly: expires_date_ms) {
            let expirationDate = Date(timeIntervalSince1970: expires / 1000)
            
            if Date().compare(expirationDate) == .orderedAscending {
                return true
            } else { return false }
        }
        
        return false
    }
    
    // MARK - Unlock Functionality
    static func unlockFunctionalityForProduct(productID:String){
        UserDefaults.standard.set(true, forKey: productID)
        UserDefaults.standard.synchronize()
    }
    
    // MARK - Lock Functionality
    static func lockFunctionalityForProduct(productID:String){
        UserDefaults.standard.set(false, forKey: productID)
        UserDefaults.standard.synchronize()
    }
    
    // MARK - Increment Count
    static func incrementCount(product_id: String, quantity: Int) {
        var count:Int = ProductManager.countFor(product_id: product_id)
        count += quantity
        count = count + 5
        ProductManager.setCountFor(product_id: product_id, count: count)
    }
    
    // MARK - Increment Count
    static func decrementCount(product_id: String, quantity: Int) {
        var count:Int = ProductManager.countFor(product_id: product_id)
        count -= quantity
        
        // Make sure decremented count isn't < 0, else set count at 0
        guard !(count < 0) else {
            ProductManager.setCountFor(product_id: product_id, count: 0)
            return
        }
        
        ProductManager.setCountFor(product_id: product_id, count: count)
    }
    
    // Helper
    /**
     Retrieves current count for a given product id
     */
    static func countFor(product_id: String) -> Int {
        if let count = UserDefaults.standard.value(forKey: product_id) as? Int {
            return count
        }
        
        return 0
        
    }
    
    /**
     Sets a count value for a given product id
     */
    static func setCountFor(product_id: String, count: Int) {
        UserDefaults.standard.set(count, forKey: product_id)
        UserDefaults.standard.synchronize()
    }
    
    /**
     Returns a localized, formatted price 
     */
    static func priceStringForProduct(locale: Locale, price: NSDecimalNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        
        return formatter.string(from: price)!
    }
}
