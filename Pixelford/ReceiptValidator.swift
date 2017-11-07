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

    }
    
}


