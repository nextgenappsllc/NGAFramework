//
//  UIColorExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIColor {
    @nonobjc public static let textColorAttributeKey = NSForegroundColorAttributeName
    public convenience init(hexString:String) {
        
        if let intValue = UInt(hexString, radix: 16) {
            let red = CGFloat((intValue & 0xFF0000) >> 16)/255.0
            let green = CGFloat((intValue & 0xFF00) >> 8)/255.0
            let blue = CGFloat(intValue & 0xFF)/255.0
            
            self.init(red:red, green:green, blue:blue, alpha:1.0)
        }
        else {
            self.init()
        }
    }
    
    public class func chooseLighterColor(firstColor color1:UIColor, secondColor color2:UIColor) -> UIColor {
        
        var color1Whiteness:CGFloat = 1.0
        var color1Alpha:CGFloat = 1.0
        var color1Hue:CGFloat = 1.0
        var color1Saturation:CGFloat = 1.0
        var color1Brightness:CGFloat = 1.0
        
        
        var color2Whiteness:CGFloat = 1.0
        var color2Alpha:CGFloat = 1.0
        var color2Hue:CGFloat = 1.0
        var color2Saturation:CGFloat = 1.0
        var color2Brightness:CGFloat = 1.0
        
        let converted1ToWhite = color1.getWhite(&color1Whiteness, alpha: &color1Alpha)
        let converted2ToWhite = color2.getWhite(&color2Whiteness, alpha: &color2Alpha)
        
        var failed = false
        
        if converted1ToWhite && converted2ToWhite {
            if color2Whiteness > color1Whiteness {
                return color2
            }
        }
        else {
            failed = true
        }
        
        let converted1ToBrightness = color1.getHue(&color1Hue, saturation: &color1Saturation, brightness: &color1Brightness, alpha: &color1Alpha)
        let converted2ToBrightness = color1.getHue(&color2Hue, saturation: &color2Saturation, brightness: &color2Brightness, alpha: &color2Alpha)
        
        if converted1ToBrightness && converted2ToBrightness {
            failed = false
            if color2Brightness > color1Brightness {
                return color2
            }
        }
        else {
            failed = true
        }
        
        if failed {
            print("converting color failed")
        }
        
        
        return color1
        
    }
    
    public var redComponent:CGFloat {get{
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return red
        }}
    public var greenComponent:CGFloat {get{
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return green
        }}
    public var blueComponent:CGFloat {get{
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return blue
        }}
    
    
    public class func chooseDarkerColor(firstColor color1:UIColor, secondColor color2:UIColor) -> UIColor {
        
        var color1Whiteness:CGFloat = 1.0
        var color1Alpha:CGFloat = 1.0
        var color1Hue:CGFloat = 1.0
        var color1Saturation:CGFloat = 1.0
        var color1Brightness:CGFloat = 1.0
        
        
        var color2Whiteness:CGFloat = 1.0
        var color2Alpha:CGFloat = 1.0
        var color2Hue:CGFloat = 1.0
        var color2Saturation:CGFloat = 1.0
        var color2Brightness:CGFloat = 1.0
        
        let converted1ToWhite = color1.getWhite(&color1Whiteness, alpha: &color1Alpha)
        let converted2ToWhite = color2.getWhite(&color2Whiteness, alpha: &color2Alpha)
        
        if converted1ToWhite && converted2ToWhite {
            if color2Whiteness < color1Whiteness {
                return color2
            }
        }
        
        let converted1ToBrightness = color1.getHue(&color1Hue, saturation: &color1Saturation, brightness: &color1Brightness, alpha: &color1Alpha)
        let converted2ToBrightness = color1.getHue(&color2Hue, saturation: &color2Saturation, brightness: &color2Brightness, alpha: &color2Alpha)
        
        if converted1ToBrightness && converted2ToBrightness {
            if color2Brightness < color1Brightness {
                return color2
            }
        }
        
        
        return color1
        
    }
    
    
    public class func oppositeColorOf(color:UIColor) -> UIColor {
        
        var red:CGFloat = 1.0
        var green:CGFloat = 1.0
        var blue:CGFloat = 1.0
        var alpha:CGFloat = 1.0
        
        _ = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let temp = UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
        
        return temp
    }
}