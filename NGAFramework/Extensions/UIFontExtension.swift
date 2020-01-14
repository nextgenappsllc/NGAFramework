//
//  UIFontExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIFont {
    
    @nonobjc public static let attributeKey = convertFromNSAttributedStringKey(NSAttributedString.Key.font)
    
    public func fitFontToSize(_ size:CGSize, forString string:String?) -> UIFont {
        if String.isEmptyOrNil(string) || size.width == 0 || size.height == 0 {
            return self.withSize(0)
        }
        let smallSide = size.shortSide
        let increment = smallSide / 100
        var fontSize:CGFloat = 0
        var testSize = CGSize.zero
        repeat {
            fontSize += increment
            testSize =? string?.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([UIFont.attributeKey: withSize(fontSize)]))
        } while testSize.height < size.height && testSize.width < size.width
        fontSize -= increment
        return withSize(fontSize)
        
    }
    
    public func fontIncreasedByAmount(_ i:CGFloat?) -> UIFont {
        return fontChangeByAmount(i, inc: true)
    }
    public func fontIncreasedByPercent(_ i:CGFloat?) -> UIFont {
        return fontChangeByPercent(i, inc: true)
    }
    public func fontDecreasedByAmount(_ i:CGFloat?) -> UIFont {
        return fontChangeByAmount(i, inc: false)
    }
    public func fontDecreasedByPercent(_ i:CGFloat?) -> UIFont {
        return fontChangeByPercent(i, inc: false)
    }
    fileprivate func fontChangeByAmount(_ i:CGFloat?, inc:Bool) -> UIFont {
        let diff = i ?? 0
        let size = inc ? pointSize + diff : pointSize - diff
        return self.withSize(size)
    }
    
    fileprivate func fontChangeByPercent(_ i:CGFloat?, inc:Bool) -> UIFont {
        let r = i ?? 0
        let size = inc ? pointSize + (pointSize * r) : pointSize - (pointSize * r)
        return self.withSize(size)
    }
    
    public class func allFontNames() -> [String] {
        var temp:[String] = []
        for family in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: family) {
                temp.append(fontName)
            }
        }
        return temp
    }
    
    public class func printAllFonts() {
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("\tFont: \(fontName)")
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
