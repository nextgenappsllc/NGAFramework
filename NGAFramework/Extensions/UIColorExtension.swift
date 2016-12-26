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
    
    public func toHexString() -> String {
        var rgb = self.rgb();rgb.r *= 255;rgb.g *= 255;rgb.b *= 255
//        return String(format: "%2X%2X%2X", rgb.r.toInt(), rgb.g.toInt(), rgb.b.toInt()).stringByReplacingOccurrencesOfString(" ", withString: "0")
        return String(format: "%02X%02X%02X", rgb.r.toInt(), rgb.g.toInt(), rgb.b.toInt())
    }
    
    public func rgba() -> (r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)? {
        var r,g,b,a:CGFloat;r=0;g=0;b=0;a=1
        guard getRed(&r, green: &g, blue: &b, alpha: &a) else {return nil}
        return (r,g,b,a)
    }
    
    public func rgb() -> (r:CGFloat,g:CGFloat,b:CGFloat) {
        let rgba = self.rgba() ?? (0,0,0,1)
        return (rgba.r,rgba.g,rgba.b)
    }
    
    public var redComponent:CGFloat {get{return red()}}
    public var greenComponent:CGFloat {get{return green()}}
    public var blueComponent:CGFloat {get{return blue()}}
    
    public func red() -> CGFloat {return rgb().r}
    public func blue() -> CGFloat {return rgb().b}
    public func green() -> CGFloat {return rgb().g}
    public func rgbAverage() -> CGFloat {
        let rgb = self.rgb()
        return (rgb.b + rgb.g + rgb.r) / 3
    }
    
    public func whiteAndAlpha() -> (w:CGFloat, a:CGFloat)? {
        var w:CGFloat = 0 ;var a:CGFloat = 1.0
        guard getWhite(&w, alpha: &a) else {return nil}
        return (w,a)
    }
    public func white() -> CGFloat {
        return whiteAndAlpha()?.w ?? 0
    }
    public func hueSaturationBrightnessAndAlpha() -> (h:CGFloat,s:CGFloat,b:CGFloat,a:CGFloat)? {
        var h,s,b,a:CGFloat; h = 0; s = 0; b = 0; a = 1
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {return nil}
        return (h,s,b,a)
    }
    public func hue() -> CGFloat {return hueSaturationBrightnessAndAlpha()?.h ?? 0}
    public func saturation() -> CGFloat {return hueSaturationBrightnessAndAlpha()?.s ?? 0}
    public func brightness() -> CGFloat {return hueSaturationBrightnessAndAlpha()?.b ?? 0}
    
    public class func chooseColor(_ darker:Bool, color1 c1:UIColor, color2 c2:UIColor) -> UIColor {
        if let w1 = c1.whiteAndAlpha()?.w, let w2 = c2.whiteAndAlpha()?.w {
            if darker && w1 < w2 {return c1} else {return c2}
        } else if let b1 = c1.hueSaturationBrightnessAndAlpha()?.b, let b2 = c2.hueSaturationBrightnessAndAlpha()?.b {
            if darker && b1 < b2 {return c1} else {return c2}
        } else {
            if darker && c1.rgbAverage() < c2.rgbAverage() {return c1} else {return c2}
        }
    }
    
    public class func chooseDarkerColor(firstColor color1:UIColor, secondColor color2:UIColor) -> UIColor {
        return chooseColor(true, color1: color1, color2: color2)
    }
    public class func chooseLighterColor(firstColor color1:UIColor, secondColor color2:UIColor) -> UIColor {
        return chooseColor(false, color1: color1, color2: color2)
    }
    
    public func oppositeColor() -> UIColor {
        return UIColor.oppositeColorOf(self)
    }
    
    public class func oppositeColorOf(_ color:UIColor) -> UIColor {
        let rgba = color.rgba() ?? (0,0,0,1)
        return UIColor(red: 1 - rgba.r, green: 1 - rgba.g, blue: 1 - rgba.b, alpha: rgba.a)
    }
}

