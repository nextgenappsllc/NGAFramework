//
//  UIFontExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIFont {
    
    @nonobjc public static let attributeKey = NSFontAttributeName
    
    public func fitFontToSize(size:CGSize, forString string:String?) -> UIFont {
        if String.isEmptyOrNil(string) || size.width == 0 || size.height == 0 {
            return self.fontWithSize(0)
        }
        let smallSide = size.shortSide
        let increment = smallSide / 100
        var fontSize:CGFloat = 0
        var testSize = CGSizeZero
        repeat {
            fontSize += increment
            testSize =? string?.sizeWithAttributes([UIFont.attributeKey: fontWithSize(fontSize)])
        } while testSize.height < size.height && testSize.width < size.width
        fontSize -= increment
        return fontWithSize(fontSize)
        
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
    
    public class func allFontNames() -> [String] {
        var temp:[String] = []
        for family in UIFont.familyNames() {
            for fontName in UIFont.fontNamesForFamilyName(family) {
                temp.append(fontName)
            }
        }
        return temp
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
