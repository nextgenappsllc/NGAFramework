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
    func toClassType<T>(_ c:T.Type) -> T? {
        if c == type(of: self) {
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
    func toDouble() -> Double {
        return Double(self)
    }
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    func toString() -> String {
        return "\(self)"
    }
    func toBool() -> Bool {
        return Bool(hashable: self)
    }
    
    typealias ThisClass = Int
    
    func withMinValue(_ v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    func withMaxValue(_ v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    func between(min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
}

extension Double:ToClassType {
    func toClassType<T>(_ c:T.Type) -> T? {
        if c == type(of: self) {
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
    func toInt() -> Int {
//        return Int(self.round)
        return Int(self)
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    func toString() -> String {
        return "\(self)"
    }
    
    func toBool() -> Bool {
        return Bool(hashable: self)
    }
    
    typealias ThisClass = Double
    
    func withMinValue(_ v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    func withMaxValue(_ v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    func between(min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
    func rounded(_ to:Int = 0) -> Double {
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
    func toClassType<T>(_ c:T.Type) -> T? {
        if c == type(of: self) {
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
    func toInt() -> Int {
//        return Int(round(self))
        return Int(self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    func toString() -> String {
        return "\(self)"
    }

    func toBool() -> Bool {
        return Bool(hashable: self)
    }
    
    typealias ThisClass = Float
    
    func withMinValue(_ v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    func withMaxValue(_ v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    func between(min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
    func rounded(_ to:Int = 0) -> Float {
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
    func toClassType<T>(_ c:T.Type) -> T? {
        if c == type(of: self) {
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
    
    
    func toInt() -> Int {
//        return Int(round(self))
        return Int(self)
    }
    
    func toFloat() -> Float {
        return Float(self)
    }
    
    func toDouble() -> Double {
        return Double(self)
    }
    func toString() -> String {
        return "\(self)"
    }
    
//    func roundTo(decimalPlaces:Int = 0) -> CGFloat {
//        var i = 1
//        for (var index = 0; index < decimalPlaces; index++) {
//            i = i * 10
//        }
//        var rValue = self
//        rValue = ( rValue * i.toCGFloat() ).toInt().toCGFloat() / i.toCGFloat()
//        return rValue
//    }

    func toEqualSize() -> CGSize {
        return CGSize(width: self, height: self)
    }
    
    func rounded(_ to:Int = 0) -> CGFloat {
        var i:Int = 1
        for _ in 0..<to {
            i = i * 10
        }
        var rValue = self
        rValue = ( rValue * i.toCGFloat() ).toInt().toCGFloat() / i.toCGFloat()
        return rValue
    }

    
    func toBool() -> Bool {
        return Bool(hashable: self)
    }
    
    typealias ThisClass = CGFloat
    
    func withMinValue(_ v:ThisClass) -> ThisClass {
        return self < v ? v : self
    }
    func withMaxValue(_ v:ThisClass) -> ThisClass {
        return self > v ? v : self
    }
    func between(min:ThisClass, max:ThisClass) -> ThisClass {
        return withMinValue(min).withMaxValue(max)
    }
}


extension Data {
    func toString(_ encoding:String.Encoding = String.Encoding.utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    func toImage() -> UIImage? {
        return UIImage(data: self)
    }
    func toRawString() -> String {
        return "\(self)"
    }
//    func toXMLElement() -> NGAXMLElement? {
//        return NGAXMLParser.parseData(self)
//    }
    func toXmlElement() -> XmlElement? {
        return XmlElement(data: self)
    }
    func toJSON(_ options:JSONSerialization.ReadingOptions = .allowFragments) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: options)
        } catch let e { print(e);return nil }
    }
    func toJSONDictionary(_ options:JSONSerialization.ReadingOptions = .allowFragments) -> [AnyHashable: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: options) as? [AnyHashable: Any]
        } catch let e { print(e);return nil }
    }
    func toJSONArray(_ options:JSONSerialization.ReadingOptions = .allowFragments) -> SwiftArray? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: options) as? SwiftArray
        } catch let e { print(e);return nil }
    }
}

extension Bool {
    init?(str:String?) {
        let nilStrings = ["nil", "null"]
        if str == nil || (str != nil && nilStrings.contains(str!.lowercased())) {return nil}
        let nsstr = str! as NSString
        self = nsstr.boolValue
    }
    
    func toInt() -> Int {
        return self ? 1 : 0
    }
    
    func toString(t:String = "true", f:String = "false") -> String {
        return self ? t : f
    }
    
}

protocol ToClassType {
    func toClassType<T>(_ c:T.Type) -> T?
}



extension String:ToClassType {
    
    func toClassType<T>(_ c:T.Type) -> T? {
        if c == type(of: self) {
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
    
    func toInt(_ nilValue:Int? = nil) -> Int? {
        let trimmed = self.trim()
        return Int(trimmed) ?? toDouble()?.toInt() ?? nilValue
    }
    
    func toFloat(_ nilValue:Float? = nil) -> Float? {
        let trimmed = self.trim()
        return Float(trimmed) ?? nilValue
    }
    
    func toDouble(_ nilValue:Double? = nil) -> Double? {
        let trimmed = self.trim()
        return Double(trimmed) ?? nilValue
    }
    func toCGFloat(_ nilValue:CGFloat? = nil) -> CGFloat? {
        return toDouble()?.toCGFloat() ?? nilValue
    }
    
    func toBool() -> Bool {
        return Bool(hashable: self)
    }
    
    func toData(_ encoding: String.Encoding = String.Encoding.utf8, allowLossyConversion: Bool = true) -> Data? {
        return data(using: encoding, allowLossyConversion: allowLossyConversion)
    }
}









