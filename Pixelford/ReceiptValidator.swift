//
//  ReceiptValidator.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/2/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit
import StoreKit

class ReceiptValidator: NSObject, SKRequestDelegate {
    
    let kSharedSecret = "880dc35591414995b498d911cf043259"
    let kAppVersion = "1.0"
    let kBundleIdentifier = "com.pixelford.test"
    
    //Before sending receipt payload to Apple, you should check that the receipt data is signed with Apple's certificate. The code below is only meant to mimic the verification process so this project can move forward, however it is not considered as secure for production purposes. Check the Receipt Validation Programming Guide for more info: https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Introduction.html
    
    func validateReceipt(receipt:NSData, handler: @escaping (Bool, [NSDictionary]?, Error?) -> Void){
        
        let receiptdata: NSString = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) as NSString
        
        let dict:NSDictionary = ["receipt-data" : receiptdata, "password" : kSharedSecret]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let request = NSMutableURLRequest(url: URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!)
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error  in
            
            guard error == nil else {
                print("There was an error in validation: \(error?.localizedDescription ?? "Nil Error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                
                //Check if receipt is valid
                if (json.object(forKey: "status") as! NSNumber) == 0 {
                    //print(">>json receipt: \n\(json)")
                    var products:[NSDictionary] = []
                    
                    //Check bundle ID
                    //Use guard
                    
                    //Check version number
                    //Use guard
                    
                    //If all checks out, verify individual purchases
                    
                    //Check if there is an auto-renewing subscription
                    if let latest_receipt = json["latest_receipt_info"] {
                        //Check if subscription has expired, if not add product ID to array
                        
                    }
                    
                    // Check for consumables, non-consumables and non-renewing subscriptions
                    if let receipt_dict = json["receipt"] as? NSDictionary{
                        let purchases = receipt_dict["in_app"] as! NSArray
                        //Iterate through purchases, add product ID to array
                        purchases.forEach({ (item) in
                            if let purchase = item as? NSDictionary {
                                products.append(purchase)
                            }
                        })
                    }
                    
                    //Call completion handler with success
                    handler(true, products, nil)
                    
                } else {
                    //Invalid receipt, debug
                    print("error validating receipt: \(json.object(forKey: "status") as! NSNumber)")
                    handler(false, nil, nil)
                }
                
            } catch {
                handler(false, nil, error)
                print("error: \(error)")
            }
            
        })
        
        task.resume()
        
    }
    
    func validatePurchaseArray(purchases:NSArray){
        
        for purchase in purchases as! [NSDictionary]{
            //If handling consumable items that you need to keep track of, you should compare purchased quantity to how many remain and update any stored values here.
            print("purchase: \(purchase)")
        }
        
        
    }
    
    func validateSubscription(purchases:NSArray){
        for purchase in purchases as! [NSDictionary]{
            //Check if purchase has expiration date, this determines if subscription or not. Handling expired products accordingly
            if let expires_date_ms_string = purchase["expires_date_ms"] as? String{
                let expires_date_ms = NumberFormatter().number(from: expires_date_ms_string)
                
                //Check if date is expired
                if self.isDateExpired(expires_date: expires_date_ms as! Double){
                    print("expired")
                    //self.lockFunctionalityForProductIdentifier((purchase["product_id"] as! String))
                } else {
                    print("active")
                    //self.unlockPurchasedFunctionalityForProductIdentifier((purchase["product_id"] as! String))
                }
            }
        }
    }
    
    //Helper - checks if date (in ms) is expired or not
    func isDateExpired(expires_date:Double) -> Bool {
        var isExpired:Bool = false
        let currentDate = (NSDate().timeIntervalSince1970 * 1000) as TimeInterval
        
        if currentDate > expires_date {
            isExpired = true
        }
        
        return isExpired
    }
    
}


