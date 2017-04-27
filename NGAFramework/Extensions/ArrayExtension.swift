//
//  ArrayExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

//TODO: Remove
import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


public extension Array {
    
    @discardableResult public mutating func appendIfNotNil(_ element:Element?) -> Array<Element> {
        if element != nil {append(element!)}
        return self
    }
    
    //    func containsIfNotNil(element:Element?) -> Bool {
    //        if element == nil {return false}
    //        do {
    //            return try contains({ (e:Element) -> Bool in
    //                return e == element
    //            })
    //        }
    //        return self.contains(element!)
    //    }
    
    //    public func containsElement(_ e:Element?) -> Bool {
    //        for element in self {
    //            if let obj1 = e as? String, let obj2 = element as? String {if obj1 == obj2 {return true}}
    //            else if let obj1 = e as? Int, let obj2 = element as? Int {if obj1 == obj2 {return true}}
    //            else if let obj1 = e as? CGFloat, let obj2 = element as? CGFloat {if obj1 == obj2 {return true}}
    //            else if let obj1 = e as? Float, let obj2 = element as? Float {if obj1 == obj2 {return true}}
    //            else if let obj1 = e as? Double, let obj2 = element as? Double {if obj1 == obj2 {return true}}
    //            else if let obj1 = e as? AnyObject, let obj2 = element as? AnyObject {if obj1 === obj2 {return true}}
    //            //            else if let c1 = e as? AnyClass, let c2 = element as? AnyClass {if c1 == c2{ return true}}
    //        }
    //        return false
    //    }
    
    public func containsElement<T:Equatable>(_ e:T?,checkType:Bool = true) -> Bool {
        guard let e = e else {return false}
        for element in self {
            var eq = equals(l:e , r: element)
            if !checkType && !eq, let e = e as? NSObject, let element = element as? NSObject {
                eq = e == element
            }
            if eq {return true}
            
        }
        return false
    }
    
    public func containsElement<T>(_ e:T?,checkType:Bool = true) -> Bool {
        guard let e = e as? Element else {return false}
        for element in self {
            let eq = equals(l:e , r: element)
            if eq {return true}
        }
        return false
    }
    
//    public func containsEquatable<T>(_ obj:T?) -> Bool where T:Equatable {
//        for element in self {if let e = element as? T {if e == obj {return true}}}
//        return false
//    }
    
    public func itemAtIndex(_ i:Int) -> Element? {
        let c = count
        if i >= 0 && i < c {
            return self[i]
        } else {return nil}
    }
    
    public func itemAtIndexWithClass<T>(_ i:Int, c:T.Type) -> T? {
        return itemAtIndex(i) as? T
    }
    
    
    @discardableResult public mutating func safeRemove(_ i:Int?) -> Element? {
        if i != nil && i < count && i >= 0 {return remove(at: i!)} else {return nil}
    }
    
    @discardableResult public mutating func safeSet(_ i:Int?, toElement element:Element?) -> [Element] {
        if let e = element, let index = i {
            if index >= count {
                append(e)
            } else if index < 0 {
                let _=unshift(e)
            } else {
                self[index] = e
            }
        }
        return self
    }
    
    @discardableResult public mutating func shift() -> Element? {
        return safeRemove(0)
    }
    
    @discardableResult public mutating func unshift(_ element:Element?) -> Array {
        if let e = element {insert(e, at: 0)}
        return self
    }
    
    public func toDictionary<T:Hashable>(_ keyForElement:((Element) -> T?)) -> [T:Element] {
        var temp:[T:Element] = [:]
        for element in self {
            if let k = keyForElement(element) {temp[k] = element}
        }
        return temp
    }
    
    public func toMultiDictionary<T:Hashable>(_ keysForElement:((Element) -> [T]?)) -> [T:[Element]] {
        var temp:[T:[Element]] = [:]
        for element in self {
            if let keys = keysForElement(element) {for key in keys {
                var arr = temp[key] ?? [Element]()
                arr.append(element)
                temp[key] = arr
                }}
        }
        return temp
    }
    
    
    public func collect<T>(initialValue iVal:T, iteratorBlock b:(_ total:T, _ element:Element) -> T) -> T {
        var temp = iVal
        for element in self {temp = b(temp, element)}
        return temp
    }
    
    public func mapToNewArray<T>(iteratorBlock b:(_ element:Element) -> T?) -> [T] {
        var temp:[T] = []
        for val in self {
            let _=temp.appendIfNotNil(b(val))
        }
        return temp
    }
    
    public mutating func mapInPlace(iteratorBlock b:(_ element:Element) -> Element?) {
        var vCount = count
        var i = 0
        while i < vCount {
            if let newElement = b(self[i]) {
                self[i] = newElement
                i += 1
            } else {
                remove(at: i)
                vCount -= 1
            }
        }
    }
    
    public func convertedToType<T>(_ c: (T.Type)) -> [T]? {
        var arr = [T]()
        for element in self {
            let n = (element as? ToClassType)?.toClassType(c) ?? element as? T
            let _=arr.appendIfNotNil(n)
        }
        return count != arr.count ? nil : arr
    }
    
//    public static func fromAny<T>(_ obj:Any?, classType c:T.Type) -> [T]? {
//        return obj as? [T]
//    }
    
    public func toJSONData(_ prettyPrint:Bool = false) -> Data? {
        do {
            
                if !JSONSerialization.isValidJSONObject(self) {return nil}
                let options = prettyPrint ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions.init(rawValue: 0)
                return try JSONSerialization.data(withJSONObject: self, options: options)
//            if let a = self as? AnyObject {
//                if !JSONSerialization.isValidJSONObject(a) {return nil}
//                let options = prettyPrint ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions.init(rawValue: 0)
//                return try JSONSerialization.data(withJSONObject: a, options: options)
//            }
//            return nil
        } catch {
            return nil
        }
    }
    
    public func toJSONSafe() -> SwiftArray {
        return mapToNewArray { (v:Element) -> Any? in
            var val:Any = v
            if let d = val as? Data {
                val = d.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            } else {val = "\(v)"}
            return val
        }
    }
    
    public func selectIf(_ b:(Element) -> Bool) -> Array {
        var temp = [Element]()
        for (element) in self {
            if b(element) {temp.append(element)}
        }
        return temp
    }
    
    public func rejectIf(_ b:(Element) -> Bool) -> Array {
        var temp = [Element]()
        for (element) in self {
            if !b(element) {temp.append(element)}
        }
        return temp
    }
    
    
    public func selectFirst(_ b:(Element) -> Bool) -> Element? {
        for e in self  {
            if b(e) {return e}
        }
        return nil
    }
    //    func hasObject<Elemen>(obj:Element) -> Bool {
    //        for object in self {
    //
    //        }
    //        return false
    //    }
    
    public func elementalCast<T>(_ to:T.Type, allOrNothing:Bool = true) -> [T]? {
        guard allOrNothing else {return mapToNewArray() {e -> T? in return e as? T}}
        var t = [T]()
        for element in self {
            guard let e = element as? T else {return nil}
            t.append(e)
        }
        return t
    }
    
    
}

public extension Array where Element : Equatable {
    
    public func hasObject(_ obj:Element) -> Bool {
        for object in self {
            return obj == object
        }
        return false
    }
    
    public mutating func removeElement(_ e:Element?) {
        if e == nil {return}
        if let i = index(of: e!) {
            remove(at: i)
        }
    }
}



fileprivate func equals<T:Equatable,U>(l:T,r:U) -> Bool{
    guard let r = r as? T else {return false}
    return l == r
}


fileprivate func equals<T:Equatable>(l:T,r:T) -> Bool{
    return l == r
}


fileprivate func equals<T>(l:T,r:T) -> Bool{
    guard let l = l as AnyObject?, let r = r as AnyObject? else {return false}
    return l === r
    
}


//public extension Array where Element:Integer, Element.IntegerLiteralType == UInt8 {
//    init(hex2: String){
//        self.init()
//        self.reserveCapacity(hex2.unicodeScalars.lazy.underestimatedCount)
//        do{
//            try hex2.streamHexBytes{ byte in
//                self.append(byte as! Element)
//            }
//        } catch _ {
//            self.removeAll()
//        }
//    }
//}







