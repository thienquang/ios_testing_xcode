//
//  Styles.swift
//  Pixelford
//
//  Created by Ron Buencamino on 11/3/17.
//  Copyright © 2017 Ron Buencamino. All rights reserved.
//

import UIKit

struct Colors {
    //Primary
    static let darkGray = UIColor(red: 74.0/255.0, green: 86.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    static let mediumGray = UIColor(red: 153.0/255.0, green: 163.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    static let lightGray = UIColor(red: 205.0/255.0, green: 206.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    
    //Secondary
    static let mediumPurple = UIColor(red: 125.0/255.0, green: 96.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    static let rosePink = UIColor(red: 242.0/255.0, green: 225.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    static let lightBrown = UIColor(red: 176.0/255.0, green: 143.0/255.0, blue: 130.0/255.0, alpha: 1.0)
}

struct Border {
    let width:CGFloat = 1.0
    let color:CGColor = Colors.mediumGray.cgColor
    let radius:CGFloat = 5.0
}
