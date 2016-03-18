//
//  UIFontExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIFont {
    
    public func fitFontToSize(size:CGSize, forString string:String?) -> UIFont {
        var fontSize:CGFloat = 0.0
        var fontSizeFound = false
        var smallSide:CGFloat = 1
        if size.height > size.width {
            smallSide = size.width
        }
        else {
            smallSide = size.height
        }
        let increment = 1 * smallSide / 10
        
        var temp = self.fontWithSize(fontSize)
        if string != nil {
            while !fontSizeFound {
                let testSize = string!.sizeWithAttributes([NSFontAttributeName:self.fontWithSize(fontSize)])
                if testSize.height > size.height || testSize.width > size.width{
                    fontSizeFound = true
                }
                else {
                    temp = self.fontWithSize(fontSize)
                    fontSize += increment
                }
            }
        }
        return temp
        
    }
    
    
    public func fontIncreasedByAmount(i:CGFloat?) -> UIFont {
        return fontChangeByAmount(i, inc: true)
    }
    public func fontIncreasedByPercent(i:CGFloat?) -> UIFont {
        return fontChangeByPercent(i, inc: true)
    }
    public func fontDecreasedByAmount(i:CGFloat?) -> UIFont {
        return fontChangeByAmount(i, inc: false)
    }
    public func fontDecreasedByPercent(i:CGFloat?) -> UIFont {
        return fontChangeByPercent(i, inc: false)
    }
    
    private func fontChangeByAmount(i:CGFloat?, inc:Bool) -> UIFont {
        let diff = i ?? 0
        let size = inc ? pointSize + diff : pointSize - diff
        return self.fontWithSize(size)
    }
    
    private func fontChangeByPercent(i:CGFloat?, inc:Bool) -> UIFont {
        let r = i ?? 0
        let size = inc ? pointSize + (pointSize * r) : pointSize - (pointSize * r)
        return self.fontWithSize(size)
    }
    
    public class func printAllFonts() {
        for family in UIFont.familyNames() {
            print("Family: \(family)")
            for fontName in UIFont.fontNamesForFamilyName(family) {
                print("\tFont: \(fontName)")
            }
        }
    }
    
}
