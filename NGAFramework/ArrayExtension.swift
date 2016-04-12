//
//  ArrayExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Array {
    
    public mutating func appendIfNotNil(element:Element?) -> Array<Element> {
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
    
    public func containsElement(e:Element?) -> Bool {
        for element in self {
            if let obj1 = e as? String, let obj2 = element as? String {if obj1 == obj2 {return true}}
            else if let obj1 = e as? Int, let obj2 = element as? Int {if obj1 == obj2 {return true}}
            else if let obj1 = e as? CGFloat, let obj2 = element as? CGFloat {if obj1 == obj2 {return true}}
            else if let obj1 = e as? Float, let obj2 = element as? Float {if obj1 == obj2 {return true}}
            else if let obj1 = e as? Double, let obj2 = element as? Double {if obj1 == obj2 {return true}}
            else if let obj1 = e as? AnyObject, let obj2 = element as? AnyObject {if obj1 === obj2 {return true}}
            //            else if let c1 = e as? AnyClass, let c2 = element as? AnyClass {if c1 == c2{ return true}}
        }
        return false
    }
    
    public func containsEquatable<T where T:Equatable>(obj:T?) -> Bool {
        for element in self {if let e = element as? T {if e == obj {return true}}}
        return false
    }
    
    public func itemAtIndex(i:Int) -> Element? {
        let c = count
        if i >= 0 && i < c {
            return self[i]
        } else {return nil}
    }
    
    public func itemAtIndexWithClass<T>(i:Int, c:T.Type) -> T? {
        return itemAtIndex(i) as? T
    }
    
    
    public mutating func safeRemove(i:Int?) -> Element? {
        if i != nil && i < count && i >= 0 {return removeAtIndex(i!)} else {return nil}
    }
    
    public mutating func safeSet(i:Int?, toElement element:Element?) -> [Element] {
        if let e = element, let index = i {
            if index >= count {
                append(e)
            } else if index < 0 {
                unshift(e)
            } else {
                self[index] = e
            }
        }
        return self
    }
    
    public mutating func shift() -> Element? {
        return safeRemove(0)
    }
    
    public mutating func unshift(element:Element?) -> Array {
        if let e = element {insert(e, atIndex: 0)}
        return self
    }
    
    public func toDictionary<T:Hashable>(keyForElement:(Element -> T?)) -> [T:Element] {
        var temp:[T:Element] = [:]
        for element in self {
            if let k = keyForElement(element) {temp[k] = element}
        }
        return temp
    }
    
    public func toMultiDictionary<T:Hashable>(keysForElement:(Element -> [T]?)) -> [T:[Element]] {
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
    
    
    public func collect<T>(initialValue iVal:T, iteratorBlock b:(total:T, element:Element) -> T) -> T {
        var temp = iVal
        for element in self {temp = b(total: temp, element: element)}
        return temp
    }
    
    public func mapToNewArray<T>(iteratorBlock b:(element:Element) -> T?) -> [T] {
        var temp:[T] = []
        for val in self {
            temp.appendIfNotNil(b(element: val))
        }
        return temp
    }
    
    public mutating func mapInPlace(iteratorBlock b:(element:Element) -> Element?) {
        var vCount = count
        var i = 0
        while i < vCount {
            if let newElement = b(element: self[i]) {
                self[i] = newElement
                i += 1
            } else {
                removeAtIndex(i)
                vCount -= 1
            }
            
        
        }
        
    }
    
    public func convertedToType<T>(c: (T.Type)) -> [T]? {
        var arr = [T]()
        for element in self {
            let n = (element as? ToClassType)?.toClassType(c) ?? element as? T
            arr.appendIfNotNil(n)
        }
        return count != arr.count ? nil : arr
    }
    
    public static func fromAnyObject<T>(obj:AnyObject?, classType c:T.Type) -> [T]? {
        return obj as? [T]
    }
    
    public func toJSONData(prettyPrint:Bool = false) -> NSData? {
        do {
            if let a = self as? AnyObject {
                if !NSJSONSerialization.isValidJSONObject(a) {return nil}
                let options = prettyPrint ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions.init(rawValue: 0)
                return try NSJSONSerialization.dataWithJSONObject(a, options: options)
            }
            return nil
        } catch {
            return nil
        }
    }
    
    public func toJSONSafe() -> Array<AnyObject> {
        return mapToNewArray { (v:Element) -> AnyObject? in
            var val = v as? AnyObject
            if let d = val as? NSData {
                val = d.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            } else {val = "\(v)"}
            return val
        }
    }
    
    public func selectIf(b:(Element) -> Bool) -> Array {
        var temp = [Element]()
        for (element) in self {
            if b(element) {temp.append(element)}
        }
        return temp
    }
    
    public func rejectIf(b:(Element) -> Bool) -> Array {
        var temp = [Element]()
        for (element) in self {
            if !b(element) {temp.append(element)}
        }
        return temp
    }
    
    
    public func selectFirst(b:(Element) -> Bool) -> Element? {
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
    
    
    
}

public extension Array where Element : Equatable {
    
    public func hasObject(obj:Element) -> Bool {
        for object in self {
            return obj == object
        }
        return false
    }
    
    public mutating func removeElement(e:Element?) {
        if e == nil {return}
        if let i = indexOf(e!) {
            removeAtIndex(i)
        }
    }
}




