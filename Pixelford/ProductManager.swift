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
        if let product_id = product["product_id"] as? String {
            if product_id == "com.pixelford.test.singleCredit" {
                //Handle increment of credits
                guard let quantity = product["quantity"] as? String else { return }
                ProductManager.incrementCredit(product_id: product_id, quantity: Int(quantity)!)
            }
            
            if product_id == "com.pixelford.test.blurFilter" || product_id == "com.pixelford.test.crop" {
                //Unlock functionality
                ProductManager.unlockFunctionalityForProduct(productID: product_id)
            }
            
            if product_id == "com.pixelford.test.cloudbackup" {
                //Validate subscription
                guard let expires_date_ms = product["expires_date_ms"] as? String else { return }
                let expires_date = Double(expires_date_ms)
                validateSubscription(product_id: product_id, expires_date_ms: expires_date!)
            }
        }
    }
    
    static func incrementCredit(product_id: String, quantity: Int) {
        // Check for existing value, add on if exists
        if let value = UserDefaults.standard.value(forKey: product_id) as? Int {
            let updated = value + quantity
            UserDefaults.standard.set(updated, forKey: product_id)
            UserDefaults.standard.synchronize()
            return
        }
        
        // No existing value, set product quantity as initial value
        UserDefaults.standard.set(quantity, forKey: product_id)
        UserDefaults.standard.synchronize()
        
    }
    
    static func validateSubscription(product_id: String, expires_date_ms: Double) {
        if let expires = TimeInterval(exactly: expires_date_ms) {
            let expirationDate = Date(timeIntervalSince1970: expires / 1000)

            if Date().compare(expirationDate) == .orderedAscending {
                ProductManager.unlockFunctionalityForProduct(productID: product_id)
            } else { ProductManager.lockFunctionalityForProduct(productID: product_id) }
        }
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
}
