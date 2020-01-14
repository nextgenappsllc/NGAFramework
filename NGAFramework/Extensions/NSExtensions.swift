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
    
    
    class func stringFromHTMLString(_ htmlEncodedString:NSString) -> NSString {
        var temp = htmlEncodedString
        let attributedOptions = [convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]
        let attributedString = NSAttributedString(string: htmlEncodedString as String, attributes: convertToOptionalNSAttributedStringKeyDictionary(attributedOptions))
        temp = attributedString.string as NSString
        
        return temp
    }
    
    class func stringForURLFromString(_ stringToEncode:NSString) -> NSString {
        var temp = stringToEncode
        let charactersToEscape = "\\!*'();:@&=+$,/?%#[]\" "
        let allowedCharacters = CharacterSet(charactersIn: charactersToEscape).inverted
        let encodedString = stringToEncode.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        if encodedString != nil {
            temp = encodedString! as NSString
        }
        return temp
    }
    
    class func hashStringFromString(_ string:String) -> String?{
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

extension URL {
    func toRequest() -> URLRequest {
        return URLRequest(url: self)
    }
    
    func toMutableRequest() -> NSMutableURLRequest {
        return NSMutableURLRequest(url: self)
    }
}


extension NSAttributedString {
//    class func compoundAttributedStringFrom(str1:String, withAttributes attr1:[String : Any]?, andStr2 str2:String, withAttributes attr2:[String : Any]?, andConnector connector:String? = nil) -> NSAttributedString? {
//        let firstString = connector == nil ? str1 : str1 + connector!
//        let mutableString = NSMutableAttributedString(string: firstString, attributes: attr1)
//        mutableString.appendAttributedString(NSAttributedString(string: str2, attributes: attr2))
//        return mutableString.copy() as? NSAttributedString
//    }
    
    func append(_ attStr:NSAttributedString?) -> NSAttributedString {
        let mutSelf = toMutableAttributedString()
        if let s = attStr {mutSelf.append(s)}
        return mutSelf.toAttributedString()
    }
    
    func toMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
    
}


extension NSMutableAttributedString {
    func toAttributedString() -> NSAttributedString {
        return NSAttributedString(attributedString: self)
    }
}


extension NSArray {
    
    func toMutableArray() -> NSMutableArray {
        return NSMutableArray(array: self)
    }
    func toArray() -> NSArray {
        return NSArray(array: self)
    }
    
    func containsIfNotNil(_ element:Any?) -> Bool {
        if element == nil {return false}
        return self.contains(element!)
    }
    
}


extension NSDictionary {
    func toMutableDictionary() -> NSMutableDictionary {
        return NSMutableDictionary(dictionary: self)
    }
    func toDictionary() -> NSDictionary {
        return NSDictionary(dictionary: self)
    }
}


extension Data {
    
    func append(_ data:Data?) -> Data {
        var d = self
        guard let data = data else {return d}
        d.append(data)
        return d
    }
    
    init?(filePath:String?) {
        self.init(url: filePath?.fileUrl)
    }
    
    init?(url: URL?) {
        guard let url = url, let d = try? Data(contentsOf: url) else {return nil}
        self = d
    }
}



extension Equatable {
    func isEqualTo<T>(_ other:T?) -> Bool {
        return self == other as? Self
    }
}












// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
