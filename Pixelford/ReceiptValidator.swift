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
    
    let kSharedSecret = "CHANGE ME"
    
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
        
        let dict:NSDictionary = ["receipt-data" : receiptData]
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
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSDictionary
                if (json.object(forKey: "status") as! NSNumber) == 0 {
                    print("valid receipt")
                    handler(true, nil, nil)
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


