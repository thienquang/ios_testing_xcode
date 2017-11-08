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
    
    let kSharedSecret = "52afa7a42a5949eba329d1db7dc551b9"
    
    var kAppVersion:String? {
        let dict:[String:Any]? = Bundle.main.infoDictionary
        return dict?["CFBundleShortVersionString"] as? String
    }
    
    var kBundleIdentifier:String? {
        return Bundle.main.bundleIdentifier
    }
    
    //Before sending receipt payload to Apple, you should check that the receipt data is signed with Apple's certificate. The code below is only meant to mimic the verification process so this project can move forward, however it is not considered as secure for production purposes. Check the Receipt Validation Programming Guide for more info: https://developer.apple.com/library/content/releasenotes/General/ValidateAppStoreReceipt/Introduction.html
    
    func validateReceipt(receipt:NSData, handler: @escaping (Bool, [NSDictionary]?, Error?) -> Void){
        //Format JSON
        let receiptData:NSString = receipt.base64EncodedString(options: .init(rawValue: 0)) as NSString
        
        let dict:NSDictionary = ["receipt-data" : receiptData, "password" : kSharedSecret]
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0))
        
        let request = NSMutableURLRequest(url: URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                print("There was a error in validation: \(error?.localizedDescription ?? "Nil Error")")
                handler(false, nil, error)
                return
            }
            
            var products:[NSDictionary] = []
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                if (json.object(forKey: "status") as! NSNumber) == 0 {
                    if let latest_receipt = json["latest_receipt_info"] as? NSArray {
                        latest_receipt.forEach({ (item) in
                            if let purchase = item as? NSDictionary {
                                products.append(purchase)
                            }
                        })
                    } else {
                        if let receipt_dict = json["receipt"] as? NSDictionary {
                            if let purchases = receipt_dict["in_app"] as? NSArray {
                                purchases.forEach({ (item) in
                                    if let purchase = item as? NSDictionary {
                                        products.append(purchase)
                                    }
                                })
                            }
                        }
                    }
                    
                    print("valid receipt")
                    handler(true, products, nil)
                } else {
                    print("invalid receipt code: \(json.object(forKey: "status") as! NSNumber)")
                    handler(false, nil, nil)
                }
            } catch {
                print("error in deserialization: \(error.localizedDescription)")
                handler(false, nil, error)
            }
        }
        
        task.resume()
    }
    
}


