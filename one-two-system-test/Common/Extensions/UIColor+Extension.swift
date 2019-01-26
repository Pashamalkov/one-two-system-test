//
//  UIColor+Extension.swift
//  

import Foundation
import UIKit

extension UIColor {
    static var templateColor: UIColor {
        return UIColor.init(red: 116/255, green: 0, blue: 1, alpha: 1)
    }
    
    static var lightGrayColor: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
    
    static var grayColor: UIColor {
        return UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
    }
    
    static var blackColor: UIColor {
        return UIColor(red: 60.0 / 255.0, green: 60.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    
    static var blueColor: UIColor {
        return UIColor(red: 75.0 / 255.0, green: 155.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    static func buttonShadowColor() -> UIColor {
        return UIColor(red: 65.0 / 255.0, green: 135.0 / 255.0, blue: 215.0 / 255.0, alpha: 0.64)
    }
}
