//
//  DictionaryExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

extension Dictionary {
    var valueArray:[Value] {get{return Array(values)}}
    var keyArray:[Key] {get{return Array(keys)}}
    
    func addDictionary(_ d:[Key:Value]?) -> Dictionary<Key, Value> {
        var temp = self
        if let dict = d {
            for (key, value) in dict {
                temp[key] = value
            }
        }
        return temp
    }
    
    func addKeyValue(_ key:Key?, value:Value?) -> Dictionary<Key, Value> {
        var temp = self
        temp.safeSetKey(key, toValue: value)
        return temp
    }
    
    
    mutating func append(_ key:Key?, value:Value?) -> Dictionary<Key,Value> {
        self.safeSetKey(key, toValue: value)
        return self
    }
    mutating func append(_ dict:[Key:Value]?) -> Dictionary<Key,Value> {
        if let d  = dict {
            for (key, value) in d {
                self.safeSetKey(key, toValue: value)
            }
        }
        return self
    }
    
    
    func selectIf(_ b:(Value) -> Bool) -> Dictionary {
        var temp = [Key:Value]()
        for (key, value) in self {
            if b(value) {temp[key] = value}
        }
        return temp
    }
    
    func rejectIf(_ b:(Value) -> Bool) -> Dictionary {
        var temp = [Key:Value]()
        for (key, value) in self {
            if !b(value) {temp[key] = value}
        }
        return temp
    }
    
    func mapToNewDictionary<T>(_ b:(Key, Value) -> T?) -> Dictionary<Key, T> {
        var temp = [Key:T]()
        for (key, value) in self {
            temp[key] = b(key, value)
        }
        return temp
    }
    
    func mapKeysToNewDictionary<K:Hashable>(_ b:(Key, Value) -> K?) -> Dictionary<K, Value> {
        var temp = [K:Value]()
        for (key, value) in self {
            temp.safeSetKey(b(key, value), toValue: value)
        }
        return temp
    }
    
    func multiMapKeysToNewDictionary<K:Hashable>(_ b:(Key, Value) -> [K]?) -> Dictionary<K, [Value]> {
        var temp = [K:[Value]]()
        for (key, value) in self {
            if let keys = b(key, value) {
                for k in keys {
                    var arr = temp.valueForKey(k) ?? [Value]()
                    let _=arr.appendIfNotNil(value)
                    temp.safeSetKey(k, toValue: arr)
                }
            }
        }
        return temp
    }
    
    func collect<K:Hashable,V>(_ b:(Key, Value) -> (K?, V?)?) -> Dictionary<K, [V]> {
        var temp = [K:[V]]()
        for (key, value) in self {
            let kv = b(key, value)
            var arr = temp.valueForKey(kv?.0) ?? [V]()
            let _=arr.appendIfNotNil(kv?.1)
            temp.safeSetKey(kv?.0, toValue: arr)
        }
        return temp
    }
    
    func multiCollect<K:Hashable,V>(_ b:(Key, Value) -> ([K?], V?)?) -> Dictionary<K, [V]> {
        var temp = [K:[V]]()
        for (key, value) in self {
            let kv = b(key, value)
            if let keys = kv?.0 {
                for k in keys {
                    var arr = temp.valueForKey(k) ?? [V]()
                    let _=arr.appendIfNotNil(kv?.1)
                    temp.safeSetKey(k, toValue: arr)
                }
            }
            
        }
        return temp
    }
    
    
    
//    static func fromAnyObject(_ obj:AnyObject?) -> Dictionary? {
//        return obj as? Dictionary
//    }
    func valueForKey(_ k:Key?) -> Value? {
        if k == nil {return nil}
        return self[k!]
    }
    func valueForKeyWithType<T>(_ k:Key?, type:T.Type) -> T? {
        return valueForKey(k) as? T
    }
    func stringForKey(_ k:Key?) -> String? {
        if k == nil {return nil}
        let v = self[k!] as? String ?? (self[k!] as? Double)?.toString()
        return v
    }
    func doubleForKey(_ k:Key?) -> Double? {
        if k == nil {return nil}
        let v = self[k!] as? Double ?? (self[k!] as? String)?.toDouble()
        return v
    }
    func intForKey(_ k:Key?) -> Int? {
        return doubleForKey(k)?.toInt()
    }
    func boolForKey(_ k:Key?) -> Bool? {
        return valueForKey(k) as? Bool ?? stringForKey(k)?.toBool()
    }
    func dictionaryForKey(_ k:Key) -> [AnyHashable: Any]? {
        return valueForKey(k) as? [AnyHashable: Any]
    }
    func arrayForKey(_ k:Key) -> SwiftArray? {
        return valueForKey(k) as? SwiftArray
    }
    
    mutating func safeSetKey(_ k:Key?, toValue v:Value?) {
        if k != nil {self[k!] = v}
    }
    
    func toJSONData(_ prettyPrint:Bool = false) -> Data? {
//        guard var a = self as? AnyObject else {return nil}
        var a:Any = self
        if !JSONSerialization.isValidJSONObject(a) { a =? toJSONSafe()}
        guard JSONSerialization.isValidJSONObject(a) else {return nil}
        let options = prettyPrint ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions.init(rawValue: 0)
        return try? JSONSerialization.data(withJSONObject: a, options: options)
    }
    
    
    func toJSONSafe() -> [String:Any] {
        var temp:[String:Any] = [:]
        for (k,v) in self {
            let key = k as? String ?? "\(k)"
            let value:Any = (v as? SwiftDictionary)?.toJSONSafe() ?? (v as? Data)?.base64EncodedString(options: .lineLength64Characters) ??  v
            let _=temp.append(key, value: value)
        }
        return temp
    }
    
    func valueCast<T>(_ to:T.Type, allOrNothing:Bool = true) -> [Key:T]? {
        guard allOrNothing else {return mapToNewDictionary(){(k,v) -> T? in return v as? T}}
        var t:[Key:T] = [:]
        for (k,v) in self {
            guard let v = v as? T else {return nil}
            t[k] = v
        }
        return t
    }
    func keyCast<T:Hashable>(_ to:T.Type, allOrNothing:Bool = true) -> [T:Value]? {
        guard allOrNothing else {return mapKeysToNewDictionary(){(k,v) -> T? in return k as? T}}
        var t:[T:Value] = [:]
        for (k,v) in self {
            guard let k = k as? T else {return nil}
            t[k] = v
        }
        return t
    }
    func cast<K,V>(_ to:Dictionary<K,V>.Type, allOrNothing:Bool = true) -> [K:V]? {
        var t:[K:V] = [:]
        for (k,v) in self {
            if let k = k as? K, let v = v as? V {t[k] = v}
            else if allOrNothing {return nil}
        }
        return t
    }
    
    //    func containsValue(v:Value) -> Bool {
    //        return valueArray.
    //    }
    
    
}



extension Dictionary where Value:Hashable {
    
    func invert() -> [Value:Key]{
        var r:[Value:Key] = [:]
        for (key, value) in self {
            r[value] = key
        }
        return r
    }
    
}

















