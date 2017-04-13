//
//  UIColor+Category.swift
//  Restaurant
//
//  Created by lance017 on 2017/3/3.
//  Copyright © 2017年 lance017. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb : UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    static func randomColor()->UIColor{
        let red = CGFloat(arc4random_uniform(UInt32(255.0)))
        let green = CGFloat(arc4random_uniform(UInt32(255.0)))
        let blue = CGFloat(arc4random_uniform(UInt32(255.0)))
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
}
