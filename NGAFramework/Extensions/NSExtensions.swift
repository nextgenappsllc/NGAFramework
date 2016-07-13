//
//  NSExtensions.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation



//// DEPRECATE
extension NSString {
    
    
    class func stringFromHTMLString(htmlEncodedString:NSString) -> NSString {
        var temp = htmlEncodedString
        let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        let attributedString = NSAttributedString(string: htmlEncodedString as String, attributes: attributedOptions)
        temp = attributedString.string
        
        return temp
    }
    
    class func stringForURLFromString(stringToEncode:NSString) -> NSString {
        var temp = stringToEncode
        let charactersToEscape = "\\!*'();:@&=+$,/?%#[]\" "
        let allowedCharacters = NSCharacterSet(charactersInString: charactersToEscape).invertedSet
        let encodedString = stringToEncode.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
        if encodedString != nil {
            temp = encodedString!
        }
        return temp
    }
    
    class func hashStringFromString(string:String) -> String?{
        let temp:String? = string.crc32CheckSum()
        //        if let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
        //            let length = data.length
        //            let buff = UnsafePointer<Bytef>(data.bytes)
        //            let checkSum = crc32(0, buff, uInt(length))
        //            temp = "\(checkSum)"
        //        }
        return temp
        
    }
}

public extension NSURL {
    public func toRequest() -> NSURLRequest {
        return NSURLRequest(URL: self)
    }
    
    public func toMutableRequest() -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: self)
    }
}


public extension NSAttributedString {
//    public class func compoundAttributedStringFrom(str1:String, withAttributes attr1:[String : AnyObject]?, andStr2 str2:String, withAttributes attr2:[String : AnyObject]?, andConnector connector:String? = nil) -> NSAttributedString? {
//        let firstString = connector == nil ? str1 : str1 + connector!
//        let mutableString = NSMutableAttributedString(string: firstString, attributes: attr1)
//        mutableString.appendAttributedString(NSAttributedString(string: str2, attributes: attr2))
//        return mutableString.copy() as? NSAttributedString
//    }
    
    public func append(attStr:NSAttributedString?) -> NSAttributedString {
        let mutSelf = toMutableAttributedString()
        if let s = attStr {mutSelf.appendAttributedString(s)}
        return mutSelf.toAttributedString()
    }
    
    public func toMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
    
}


public extension NSMutableAttributedString {
    func toAttributedString() -> NSAttributedString {
        return NSAttributedString(attributedString: self)
    }
}


public extension NSArray {
    
    public func toMutableArray() -> NSMutableArray {
        return NSMutableArray(array: self)
    }
    public func toArray() -> NSArray {
        return NSArray(array: self)
    }
    
    public func containsIfNotNil(element:AnyObject?) -> Bool {
        if element == nil {return false}
        return self.containsObject(element!)
    }
    
}


public extension NSDictionary {
    public func toMutableDictionary() -> NSMutableDictionary {
        return NSMutableDictionary(dictionary: self)
    }
    public func toDictionary() -> NSDictionary {
        return NSDictionary(dictionary: self)
    }
}


public extension NSData {
    public func toMutableData() -> NSMutableData {
        return self.mutableCopy() as! NSMutableData
    }
    
    public func append(data:NSData?) -> NSData {
        if let d = data {
            let mut = d.toMutableData()
            mut.appendData(d)
            return mut.toData()
        } else {
            return self
        }
    }
    
    public convenience init?(filePath:String?) {
        guard let filePath = filePath else {return nil}
        self.init(contentsOfFile: filePath)
    }
}

public extension NSMutableData {
    func toData() -> NSData {
        return self.copy() as! NSData
    }
}



public extension Equatable {
    public func isEqualTo<T>(other:T?) -> Bool {
        return self == other as? Self
    }
}











