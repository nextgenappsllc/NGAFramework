//
//  DictionaryExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Dictionary {
    public var valueArray:[Value] {get{return Array(values)}}
    public var keyArray:[Key] {get{return Array(keys)}}
    
    public func addDictionary(d:[Key:Value]?) -> Dictionary<Key, Value> {
        var temp = self
        if let dict = d {
            for (key, value) in dict {
                temp[key] = value
            }
        }
        return temp
    }
    
    public func addKeyValue(key:Key?, value:Value?) -> Dictionary<Key, Value> {
        var temp = self
        temp.safeSetKey(key, toValue: value)
        return temp
    }
    
    
    public mutating func append(key:Key?, value:Value?) -> Dictionary<Key,Value> {
        self.safeSetKey(key, toValue: value)
        return self
    }
    public mutating func append(dict:[Key:Value]?) -> Dictionary<Key,Value> {
        if let d  = dict {
            for (key, value) in d {
                self.safeSetKey(key, toValue: value)
            }
        }
        return self
    }
    
    
    public func selectIf(b:(Value) -> Bool) -> Dictionary {
        var temp = [Key:Value]()
        for (key, value) in self {
            if b(value) {temp[key] = value}
        }
        return temp
    }
    
    public func rejectIf(b:(Value) -> Bool) -> Dictionary {
        var temp = [Key:Value]()
        for (key, value) in self {
            if !b(value) {temp[key] = value}
        }
        return temp
    }
    
    public func mapToNewDictionary<T>(b:(Key, Value) -> T?) -> Dictionary<Key, T> {
        var temp = [Key:T]()
        for (key, value) in self {
            temp[key] = b(key, value)
        }
        return temp
    }
    
    public func mapKeysToNewDictionary<K:Hashable>(b:(Key, Value) -> K?) -> Dictionary<K, Value> {
        var temp = [K:Value]()
        for (key, value) in self {
            temp.safeSetKey(b(key, value), toValue: value)
        }
        return temp
    }
    
    public func multiMapKeysToNewDictionary<K:Hashable>(b:(Key, Value) -> [K]?) -> Dictionary<K, [Value]> {
        var temp = [K:[Value]]()
        for (key, value) in self {
            if let keys = b(key, value) {
                for k in keys {
                    var arr = temp.valueForKey(k) ?? [Value]()
                    arr.appendIfNotNil(value)
                    temp.safeSetKey(k, toValue: arr)
                }
            }
        }
        return temp
    }
    
    public func collect<K:Hashable,V>(b:(Key, Value) -> (K?, V?)?) -> Dictionary<K, [V]> {
        var temp = [K:[V]]()
        for (key, value) in self {
            let kv = b(key, value)
            var arr = temp.valueForKey(kv?.0) ?? [V]()
            arr.appendIfNotNil(kv?.1)
            temp.safeSetKey(kv?.0, toValue: arr)
        }
        return temp
    }
    
    public func multiCollect<K:Hashable,V>(b:(Key, Value) -> ([K?], V?)?) -> Dictionary<K, [V]> {
        var temp = [K:[V]]()
        for (key, value) in self {
            let kv = b(key, value)
            if let keys = kv?.0 {
                for k in keys {
                    var arr = temp.valueForKey(k) ?? [V]()
                    arr.appendIfNotNil(kv?.1)
                    temp.safeSetKey(k, toValue: arr)
                }
            }
            
        }
        return temp
    }
    
    
    
    public static func fromAnyObject(obj:AnyObject?) -> Dictionary? {
        return obj as? Dictionary
    }
    public func valueForKey(k:Key?) -> Value? {
        if k == nil {return nil}
        return self[k!]
    }
    public func valueForKeyWithType<T>(k:Key?, type:T.Type) -> T? {
        return valueForKey(k) as? T
    }
    public func stringForKey(k:Key?) -> String? {
        if k == nil {return nil}
        let v = self[k!] as? String ?? (self[k!] as? Double)?.toString()
        return v
    }
    public func doubleForKey(k:Key?) -> Double? {
        if k == nil {return nil}
        let v = self[k!] as? Double ?? (self[k!] as? String)?.toDouble()
        return v
    }
    public func intForKey(k:Key?) -> Int? {
        return doubleForKey(k)?.toInt()
    }
    public func boolForKey(k:Key?) -> Bool? {
        return valueForKey(k) as? Bool ?? stringForKey(k)?.toBool()
    }
    public func dictionaryForKey(k:Key) -> [NSObject:AnyObject]? {
        return valueForKey(k) as? [NSObject:AnyObject]
    }
    public func arrayForKey(k:Key) -> [AnyObject]? {
        return valueForKey(k) as? [AnyObject]
    }
    
    public mutating func safeSetKey(k:Key?, toValue v:Value?) {
        if k != nil {self[k!] = v}
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
    
    public func toJSONSafe() -> Dictionary<Key, AnyObject> {
        return mapToNewDictionary { (k:Key, v:Value) -> AnyObject? in
            var val = v as? AnyObject
            if let d = val as? NSData {
                val = d.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            } else {val = "\(v)"}
            return val
        }
    }
    
    //    func containsValue(v:Value) -> Bool {
    //        return valueArray.
    //    }
    
    
}



public extension Dictionary where Value:Hashable {
    
    public func invert() -> [Value:Key]{
        var r:[Value:Key] = [:]
        for (key, value) in self {
            r[value] = key
        }
        return r
    }
    
}

















