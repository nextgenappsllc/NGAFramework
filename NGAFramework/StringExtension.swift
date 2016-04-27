//
//  StringExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import CryptoSwift


public extension String {
    
    public func containsString(str:String, caseInsensitive:Bool = false) -> Bool {
        var temp = false
        let nsStr = caseInsensitive ? str.lowercaseString : str
        let newSelf:NSString = caseInsensitive ? self.lowercaseString : self
        temp = newSelf.containsString(nsStr)
        return temp
    }
    
    public func stringByAddingPathComponent(pathComp: String?) -> String? {
        if let comp = pathComp {
            return (self as NSString).stringByAppendingPathComponent(comp)
        }
        else {return self}
    }
    
    
    public var characterArray:[Character] {get{return Array(characters)}}
    public var substrings:[String] {get {return characterArray.mapToNewArray(iteratorBlock: { (element) -> String? in
        return String(element)
    })}}
    
    public subscript (i: Int) -> String? {
        get{return substrings.itemAtIndex(i)}
        mutating set {
            var arr = substrings
            arr.safeSet(i, toElement: newValue)
            self = arr.joinWithSeparator("")
        }
    }
    
    public subscript (r: Range<Int>) -> String {
        var range = r
        let letterCount = characters.count
        if range.endIndex > letterCount { range.endIndex = letterCount }
        return substringWithRange(startIndex.advancedBy(range.startIndex)..<startIndex.advancedBy(range.endIndex))
    }
    
    
    func abbreviatedStringWithMaxCharacters(maxChars:Int = 3) -> String {
        var temp = self
        let components = temp.componentsSeparatedByString(" ")
        if components.count > 1 {
            temp = ""
            for str in components {
                if !str.isEmpty {
                    temp += str[0] ?? ""
                }
            }
        }
        temp = temp[0..<maxChars]
        
        return temp
    }
    
    var length:Int {get {return self.characters.count}}
    
    
    var isValidEmailFormat:Bool {
        get{
            let components = componentsSeparatedByString("@")
            return components.count == 2 && components.last?.componentsSeparatedByString(".").count ?? 0 >= 2
        }
    }
    
    static func doesExist(str:String?) -> Bool {return !(str?.isEmpty() ?? true)}
    static func isNotEmpty(str:String?) -> Bool {
        return doesExist(str)
    }
    static func isEmptyOrNil(str:String?) -> Bool {
        return !isNotEmpty(str)
    }
    
    var url:NSURL? {get{return NSURL(string: self)}}
    var fileUrl:NSURL? {get{return NSURL(fileURLWithPath: self)}}
    
    static func largerContainsSmaller(string1 str1:String?, string2 str2:String?, caseInsensitive:Bool = true) -> Bool {
        if !doesExist(str1) || !doesExist(str2) {return false}
        let largerString:String ; let smallerString:String
        if str1!.length < str2!.length {largerString = str2!; smallerString = str1!}
        else {largerString = str1!; smallerString = str2!}
        return largerString.containsString(smallerString, caseInsensitive: caseInsensitive)
    }
    
    public func appendIfNotNil(str:String?, separator:String? = nil) -> String {
        return surround(prefix: nil, postfix: "\(separator ?? "")\(str ?? "")")
    }
    
    public func prependIfNotNil(str:String?, separator:String? = nil) -> String {
        return surround(prefix: "\(separator ?? "")\(str ?? "")", postfix: nil)
    }
    
    public func surround(prefix pre:String?, postfix post:String?) -> String{
        return "\(pre ?? "")\(self)\(post ?? "")"
    }
    
    public func regexNumberOfMatches(pattern:String, patternOptions:NSRegularExpressionOptions = NSRegularExpressionOptions.init(rawValue: 0), matchingOptions:NSMatchingOptions = NSMatchingOptions.init(rawValue: 0)) -> Int? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: patternOptions)
            return regex.numberOfMatchesInString(self, options: matchingOptions, range: NSMakeRange(0, self.characters.count))
        } catch {
            return nil
        }
    }
    
    public func regexMatchExists(pattern:String, patternOptions:NSRegularExpressionOptions = NSRegularExpressionOptions.init(rawValue: 0), matchingOptions:NSMatchingOptions = NSMatchingOptions.init(rawValue: 0)) -> Bool {
        return regexNumberOfMatches(pattern, patternOptions: patternOptions, matchingOptions: matchingOptions) ?? 0 > 0
    }
    
    
    public func isEmpty() -> Bool {
        return self.trim().length == 0
    }
    
    
    
    
    public func urlEncode() -> String {
        let charactersToEscape = "\\!*'();:@&=+$,/?%#[]\" "
        let allowedCharacters = NSCharacterSet(charactersInString: charactersToEscape).invertedSet
        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) ?? self
    }
    
    
    public static let xmlEscapeCharMap = [["&":"&amp"],["<":"&lt"], [">": "&gt"], ["'":"&pos"], ["\"":"&quo"]]
    
    public func xmlEncode() -> String {
        var str = self
        for charDictionary in String.xmlEscapeCharMap {
            for (key, value) in charDictionary {
                str = str.stringByReplacingOccurrencesOfString(key, withString: value)
            }
        }
        return str
    }
    public func xmlDecode() -> String {
        var str = self
        for charDictionary in String.xmlEscapeCharMap.reverse() {
            for (key, value) in charDictionary.invert() {
                str = str.stringByReplacingOccurrencesOfString(key, withString: value)
            }
        }
        return str
    }
    
    public func htmlDecode() -> String? {
        let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)
        if encodedData == nil {return nil}
        let attributedOptions : [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding]
        return try? NSAttributedString(data: encodedData!, options: attributedOptions, documentAttributes: nil).string
    }
    
    
    public func crc32CheckSum() -> String? {
        let s = self.crc32()
        if let i = UInt(s, radix: 16) {
            return "\(i)"
        }
        return nil
    }
    
    public func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    public mutating func trimInPlace() {
        self = trim()
    }
    
    public static func fromAnyObject(obj:AnyObject?) -> String? {
        return obj as? String
    }
    
    public func toDateWithFormat(format:String) -> NSDate? {
        return NSDate.dateFromString(self, withFormat: format)
    }
    
    public func toAttributedString(attributes:[String:AnyObject]?) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    public func toAttributedString(font font:UIFont?, color: UIColor?) -> NSAttributedString {
        var attributes = [String:AnyObject]()
        attributes[NSFontAttributeName] = font
        attributes[NSForegroundColorAttributeName] = color
        return toAttributedString(attributes)
    }

    
    public static func repeatedStringOfSize(s:Int, repeatedString:String = " ") -> String {
        var str = ""
        s.times { (i) in
            str += repeatedString
        }
        return str
    }
    
    
    public static let degrees = "°"
    
    
    
    
}










