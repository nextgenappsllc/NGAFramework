//
//  NGAPseudoDictionary.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 8/25/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation



public class NGAPseudoDictionary:SequenceType {
    
    private let valueKey = "v"
    private let attributeKey = "a"
    private var privateValues = [String: [String: AnyObject]]()
    public init() {}
    public init(dictionary:[String: AnyObject]?){
        if dictionary != nil {
            for (key, value) in dictionary! {
                self[key] = value
            }
        }
        
    }
    public subscript(key: String?) -> AnyObject? {
        get {
            if key == nil {return nil}
            return privateValues[key!]?[valueKey]
        }
        set {
            if key == nil {return}
            var dict = privateValues[key!] ?? [String: AnyObject]()
            dict[valueKey] = newValue
            privateValues[key!] = dict
            
        }
    }
    
    public func attributesForProperty(prop:String?) -> [String: AnyObject]? {
        if prop == nil {return nil}
        var temp = privateValues[prop!]
        temp?[valueKey] = nil
        return temp
    }
    
    public func setAttributes(attrs:[String: AnyObject]?, forPropertyNamed prop:String?) {
        if prop == nil {return}
        let temp = self[prop!]
        var new = attrs ?? Dictionary()
        new[valueKey] = temp
        privateValues[prop!] = new

    }
    
    public func addAttributes(attrs:[String: AnyObject]?, forPropertyNamed prop:String?) {
        if prop == nil || attrs == nil{return}
        let old = self[prop!]
        var temp = privateValues[prop!]
        for (key, value) in attrs! {
            temp?[key] = value
        }
        temp?[valueKey] = old
        privateValues[prop!] = temp
        
    }
    
    public func setAttribute(attr:String?, toAttributeValue val:AnyObject?, forPropertyNamed prop:String?) {
        if prop == nil || attr == nil {return}
        privateValues[prop!]?[attr!] = val
    }
    
    
    public func generate() -> DictionaryGenerator<String, AnyObject> {
        return privateValues.mapToNewDictionary { (key:String, value:[String: AnyObject]) -> AnyObject? in
            return value[self.valueKey]
        }.generate()
    }
    
    
    
    
}






