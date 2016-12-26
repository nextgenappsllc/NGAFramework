//
//  NGAPseudoDictionary.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 8/25/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation



open class NGAPseudoDictionary:Sequence {
    
    fileprivate let valueKey = "v"
    fileprivate let attributeKey = "a"
    fileprivate var privateValues = [String: [String: Any]]()
    public init() {}
    public init(dictionary:[String: Any]?){
        if dictionary != nil {
            for (key, value) in dictionary! {
                self[key] = value
            }
        }
        
    }
    open subscript(key: String?) -> Any? {
        get {
            if key == nil {return nil}
            return privateValues[key!]?[valueKey]
        }
        set {
            if key == nil {return}
            var dict = privateValues[key!] ?? [String: Any]()
            dict[valueKey] = newValue
            privateValues[key!] = dict
            
        }
    }
    
    open func attributesForProperty(_ prop:String?) -> [String: Any]? {
        if prop == nil {return nil}
        var temp = privateValues[prop!]
        temp?[valueKey] = nil
        return temp
    }
    
    open func setAttributes(_ attrs:[String: Any]?, forPropertyNamed prop:String?) {
        if prop == nil {return}
        let temp = self[prop!]
        var new = attrs ?? Dictionary()
        new[valueKey] = temp
        privateValues[prop!] = new

    }
    
    open func addAttributes(_ attrs:[String: Any]?, forPropertyNamed prop:String?) {
        if prop == nil || attrs == nil{return}
        let old = self[prop!]
        var temp = privateValues[prop!]
        for (key, value) in attrs! {
            temp?[key] = value
        }
        temp?[valueKey] = old
        privateValues[prop!] = temp
        
    }
    
    open func setAttribute(_ attr:String?, toAttributeValue val:Any?, forPropertyNamed prop:String?) {
        if prop == nil || attr == nil {return}
        privateValues[prop!]?[attr!] = val
    }
    
    
    open func makeIterator() -> DictionaryIterator<String, Any> {
        return privateValues.mapToNewDictionary { (key:String, value:[String: Any]) -> Any? in
            return value[self.valueKey]
        }.makeIterator()
    }
    
    
    
    
}






