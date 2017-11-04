//
//  IAPManager.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit
import StoreKit

class IAPManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    static let sharedInstance = IAPManager()
    
    var request:SKProductsRequest!
    var products:[SKProduct] = []
    
    func setupPurchases(_ handler: @escaping (Bool) -> Void){
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            handler(true)
            return
        }
        
        handler(false)
    }
    
    // MARK - SKProductsRequest
    func getProductIdentifiers() -> [String] {
        var identifiers:[String] = []
        
        if let fileUrl = Bundle.main.url(forResource: "products", withExtension: "plist"){
            let products = NSArray(contentsOf: fileUrl)
            
            for product in products as! [String]{
                identifiers.append(product)
            }
            
        }
        
        return identifiers
        
    }
    func performProductRequestForIdentifiers(identifiers:[String]){
        let products = NSSet(array: identifiers) as! Set<String>
        
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request.delegate = self
        self.request.start()
        
    }
    
    func requestProducts() {
        self.performProductRequestForIdentifiers(identifiers: self.getProductIdentifiers())
    }
    
    // MARK - Payment Request
    func createPaymentRequestForProduct(product:SKProduct){
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1
        
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK - Receipt Validation
    func validateReceipt(completion: @escaping (Bool) -> Void){
        guard let receiptURL = Bundle.main.appStoreReceiptURL, let receipt = try? Data(contentsOf: receiptURL) else { return }
        
        ReceiptValidator().validateReceipt(receipt: receipt as NSData) { (success:Bool, purchases:[NSDictionary]?, error:Error?) in
            //
            if success {
                //Unlock functionality with returned purchases array
                guard purchases != nil else { return }
                purchases!.forEach({ (purchase) in
                    ProductManager.handleProductPurchase(purchase)
                })
            } else {
                print("validateReceipt: \(error?.localizedDescription ?? "No Error Returned")")
            }
            
            completion(success)
        }
    }
    
    // MARK - Restore Purchases
    func restorePurchasedItems(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK - SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        //
        self.products = response.products
    }
    
    // MARK - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState{
            // handle appropriate transaction state
            case .purchasing:
                print("purchasing")
            case .deferred:
                print("deferred")
            case .failed:
                print("failed")
                print(transaction.error?.localizedDescription ?? "No Error Returned")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.validateReceipt(completion: { (success) in
                    if success {
                        SKPaymentQueue.default().finishTransaction(transaction)
                    } else {
                        print("There was a problem validating the receipt")
                    }
                })
            case .restored:
                print("restored")
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
        print("paymentQueueRestoreCompletedTransactionsFinished")
    }
    
}
