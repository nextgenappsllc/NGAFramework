//
//  NGAArranger.swift
//  MCMApp
//
//  Created by Jose Castellanos on 5/25/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


//// deprecate, use array and dictionary extensions instead
class NGAArranger {
    
    class func arrangeArrayIntoDictionaryAndKeyArray(array:NSArray?, objectOrderedBefore:((AnyObject?, AnyObject?) -> Bool)?, keyGenerator:(AnyObject?) -> String?, keyOrderedBeforeBlock:((String, String) -> Bool)?) -> (dictionary:NSDictionary?, keyArray:NSArray?) {
        var temp:(dictionary:NSDictionary?, keyArray:NSArray?) = (nil,nil)
        if var arr = array?.mutableCopy() as? [AnyObject] {
            let dict = NSMutableDictionary()
            var keyMutableArray = NSMutableArray()
            if let objOrder = objectOrderedBefore {
                arr.sortInPlace(objOrder)
            }
            for object in arr {
                if let key = keyGenerator(object) {
                    let mutArray = (dict[key] as? NSArray)?.mutableCopy() as? NSMutableArray ?? NSMutableArray()
                    mutArray.addObject(object)
                    dict[key] = mutArray.copy()
                    if !keyMutableArray.containsObject(key) {keyMutableArray.addObject(key)}
                }
            }
            if let keyOrder = keyOrderedBeforeBlock {
                if var keyArray = keyMutableArray.mutableCopy() as? [String] {
                    keyArray.sortInPlace(keyOrder)
                    keyMutableArray = (keyArray as NSArray).mutableCopy() as? NSMutableArray ?? keyMutableArray
                }
            }
            temp.dictionary = dict.copy() as? NSDictionary
            temp.keyArray = keyMutableArray.copy() as? NSArray
        }
        return temp
    }
    
    class func isStringBeforeString(string1:String?, string2:String?, ascending:Bool = true, caseInsensitive:Bool = true) -> Bool {
        var str1 = string1 ?? ""
        var str2 = string2 ?? ""
        if caseInsensitive {
            str1 = str1.lowercaseString
            str2 = str2.lowercaseString
        }
        return ascending ? str1 < str2 : str1 > str2
    }
    
}