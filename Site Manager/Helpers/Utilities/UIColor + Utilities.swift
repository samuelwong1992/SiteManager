//
//  UIColor + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 13/8/19.
//  Copyright © 2019 Samuel Wong. All rights reserved.
//

import UIKit

//MARK: UIColor
extension UIColor {
    class func colourWithHexStringAndAlpha(_ hex: String, alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    class func colourWithHexString(_ hex: String) -> UIColor {
        return UIColor.colourWithHexStringAndAlpha(hex, alpha: 1)
    }
    
    static func getGradientColor(from: UIColor, to: UIColor, percentage: CGFloat) -> UIColor? {
        precondition(percentage >= 0 && percentage <= 1)
        
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let r = fromRed + CGFloat(toRed - fromRed) * percentage
        let g = fromGreen + CGFloat(toGreen - fromGreen) * percentage
        let b = fromBlue + CGFloat(toBlue - fromBlue) * percentage
        let a = fromAlpha + CGFloat(toAlpha - fromAlpha) * percentage
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    var hexCode: String {
        get{
            let colorComponents = self.cgColor.components!
            if colorComponents.count < 4 {
                return String(format: "%02x%02x%02x", Int(colorComponents[0]*255.0), Int(colorComponents[0]*255.0),Int(colorComponents[0]*255.0)).uppercased()
            }
            return String(format: "%02x%02x%02x", Int(colorComponents[0]*255.0), Int(colorComponents[1]*255.0),Int(colorComponents[2]*255.0)).uppercased()
        }
    }
}
