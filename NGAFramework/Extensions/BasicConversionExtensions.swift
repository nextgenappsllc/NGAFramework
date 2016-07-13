//
//  BasicConversionExtensions.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

//MARK: Conversions
extension Int:ToClassType {
    public func toClassType<T>(c:T.Type) -> T? {
        if c == self.dynamicType {
            return self as? T
        } else if c == CGFloat.self {
            return toCGFloat() as? T
        } else if c == Double.self {
            return toDouble() as? T
        } else if c == String.self {
            return toString() as? T
        } else if c == Bool.self {
            return toBool() as? T
        } else if c == Float.self {
            return toFloat() as? T
        }
        return self as? T
    }
    public func toDouble() -> Double {
        return Double(self)
    }
    public func toFloat() -> Float {
        return Float(self)
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    public func toString() -> String {
        return "\(self)"
    }
    public func toBool() -> Bool {
        return toString().toBool() ?? false
    }
    
    public typealias ThisClass = Int
    
    public func withMinValue(v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    public func withMaxValue(v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    public func between(min min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
}

extension Double:ToClassType {
    public func toClassType<T>(c:T.Type) -> T? {
        if c == self.dynamicType {
            return self as? T
        } else if c == CGFloat.self {
            return toCGFloat() as? T
        } else if c == Float.self {
            return toFloat() as? T
        } else if c == String.self {
            return toString() as? T
        } else if c == Bool.self {
            return toBool() as? T
        } else if c == Int.self {
            return toInt() as? T
        }
        return self as? T
    }
    public func toInt() -> Int {
        return Int(round(self))
    }
    
    public func toFloat() -> Float {
        return Float(self)
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    public func toString() -> String {
        return "\(self)"
    }
    
    public func toBool() -> Bool {
        return toString().toBool() ?? false
    }
    
    public typealias ThisClass = Double
    
    public func withMinValue(v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    public func withMaxValue(v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    public func between(min min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
    public func rounded(to:Int = 0) -> Double {
        var i:Int = 1
        for _ in 0..<to {
            i = i * 10
        }
//        var rValue = self
//        rValue = ( rValue * i.toDouble() ).toInt().toDouble() / i.toDouble()
        return ( self * i.toDouble() ).toInt().toDouble() / i.toDouble()
    }
}

extension Float:ToClassType {
    public func toClassType<T>(c:T.Type) -> T? {
        if c == self.dynamicType {
            return self as? T
        } else if c == CGFloat.self {
            return toCGFloat() as? T
        } else if c == Double.self {
            return toDouble() as? T
        } else if c == String.self {
            return toString() as? T
        } else if c == Bool.self {
            return toBool() as? T
        } else if c == Int.self {
            return toInt() as? T
        }
        return self as? T
    }
    public func toInt() -> Int {
        return Int(round(self))
    }
    
    public func toDouble() -> Double {
        return Double(self)
    }
    
    public func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    public func toString() -> String {
        return "\(self)"
    }

    public func toBool() -> Bool {
        return toString().toBool() ?? false
    }
    
    public typealias ThisClass = Float
    
    public func withMinValue(v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    public func withMaxValue(v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    public func between(min min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
    public func rounded(to:Int = 0) -> Float {
        var i:Int = 1
        for _ in 0..<to {
            i = i * 10
        }
        var rValue = self
        rValue = ( rValue * i.toFloat() ).toInt().toFloat() / i.toFloat()
        return rValue
    }
    
}

extension CGFloat:ToClassType {
    public func toClassType<T>(c:T.Type) -> T? {
        if c == self.dynamicType {
            return self as? T
        } else if c == Float.self {
            return toFloat() as? T
        } else if c == Double.self {
            return toDouble() as? T
        } else if c == String.self {
            return toString() as? T
        } else if c == Bool.self {
            return toBool() as? T
        } else if c == Int.self {
            return toInt() as? T
        }
        return self as? T
    }
    
    
    public func toInt() -> Int {
        return Int(round(self))
    }
    
    public func toFloat() -> Float {
        return Float(self)
    }
    
    public func toDouble() -> Double {
        return Double(self)
    }
    public func toString() -> String {
        return "\(self)"
    }
    
//    public func roundTo(decimalPlaces:Int = 0) -> CGFloat {
//        var i = 1
//        for (var index = 0; index < decimalPlaces; index++) {
//            i = i * 10
//        }
//        var rValue = self
//        rValue = ( rValue * i.toCGFloat() ).toInt().toCGFloat() / i.toCGFloat()
//        return rValue
//    }

    public func toEqualSize() -> CGSize {
        return CGSizeMake(self, self)
    }
    
    public func rounded(to:Int = 0) -> CGFloat {
        var i:Int = 1
        for _ in 0..<to {
            i = i * 10
        }
        var rValue = self
        rValue = ( rValue * i.toCGFloat() ).toInt().toCGFloat() / i.toCGFloat()
        return rValue
    }

    
    public func toBool() -> Bool {
        return toString().toBool() ?? false
    }
    
    public typealias ThisClass = CGFloat
    
    public func withMinValue(v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    public func withMaxValue(v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    public func between(min min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
}


public extension NSData {
    public func toString(encoding:NSStringEncoding = NSUTF8StringEncoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    public func toImage() -> UIImage? {
        return UIImage(data: self)
    }
    public func toRawString() -> String {
        return "\(self)"
    }
//    public func toXMLElement() -> NGAXMLElement? {
//        return NGAXMLParser.parseData(self)
//    }
    public func toXmlElement() -> XmlElement? {
        return XmlElement(data: self)
    }
    public func toJSON(options:NSJSONReadingOptions = .AllowFragments) -> AnyObject? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: options)
        } catch let e { print(e);return nil }
    }
    public func toJSONDictionary(options:NSJSONReadingOptions = .AllowFragments) -> [NSObject: AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: options) as? [NSObject: AnyObject]
        } catch let e { print(e);return nil }
    }
    public func toJSONArray(options:NSJSONReadingOptions = .AllowFragments) -> [AnyObject]? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(self, options: options) as? [AnyObject]
        } catch let e { print(e);return nil }
    }
}

public extension Bool {
    public init?(str:String?) {
        let nilStrings = ["nil", "null"]
        if str == nil || (str != nil && nilStrings.contains(str!.lowercaseString)) {return nil}
        let nsstr = str! as NSString
        self = nsstr.boolValue
    }
    
    public func toInt() -> Int {
        return self ? 1 : 0
    }
    
    public func toString(t t:String = "true", f:String = "false") -> String {
        return self ? t : f
    }
    
}

public protocol ToClassType {
    func toClassType<T>(c:T.Type) -> T?
}



extension String:ToClassType {
    
    public func toClassType<T>(c:T.Type) -> T? {
        if c == self.dynamicType {
            return self as? T
        } else if c == Float.self {
            return toFloat() as? T
        } else if c == Double.self {
            return toDouble() as? T
        } else if c == CGFloat.self {
            return toCGFloat() as? T
        } else if c == Bool.self {
            return toBool() as? T
        } else if c == Int.self {
            return toInt() as? T
        }
        return self as? T
    }
    
    public func toInt(nilValue:Int? = nil) -> Int? {
        let trimmed = self.trim()
        return Int(trimmed) ?? toDouble()?.toInt() ?? nilValue
    }
    
    public func toFloat(nilValue:Float? = nil) -> Float? {
        let trimmed = self.trim()
        return Float(trimmed) ?? nilValue
    }
    
    public func toDouble(nilValue:Double? = nil) -> Double? {
        let trimmed = self.trim()
        return Double(trimmed) ?? nilValue
    }
    public func toCGFloat(nilValue:CGFloat? = nil) -> CGFloat? {
        return toDouble()?.toCGFloat() ?? nilValue
    }
    
    public func toBool(nilValue:Bool? = nil) -> Bool? {
        return Bool(str: self.trim().lowercaseString == "si" ? "true" : self)
    }
    
    public func toData(encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = true) -> NSData? {
        return dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion)
    }
}









