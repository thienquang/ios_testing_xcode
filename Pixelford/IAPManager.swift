//
//  IAPManager.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:[SKProduct] = []
    
    func setupPurchases(_ completion: @escaping (Bool) -> Void) {
        // Check if we can make payments
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
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
    
    // MARK: SKPaymentObject
    func createPaymentRequestForProduct(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1
        
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
                break
            case .deferred:
                print("deferred")
                break
            case .failed:
                print("failed: \(transaction.error?.localizedDescription ?? "No error returned")")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchased:
                print("purchased")
                self.validateReceipt(completion: { (success) in
                    if success {
                        SKPaymentQueue.default().finishTransaction(transaction)
                    } else {
                        
                    }
                })
                break
            case .restored:
                print("restored")
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        //
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        //
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        //
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        //
    }
    
    // MARK: Receipt Validation
    func validateReceipt(completion: @escaping (Bool) -> Void) {
        guard let receiptUrl = Bundle.main.appStoreReceiptURL, let receipt = try? Data(contentsOf: receiptUrl) else { return }
        
        ReceiptValidator().validateReceipt(receipt: receipt as NSData) { (success, purchases, error) in
            //
            if success {
                print("validation was successful: \(purchases)")
            } else {
                print("validation was not successful")
            }
            
            completion(success)
        }
    }
}
