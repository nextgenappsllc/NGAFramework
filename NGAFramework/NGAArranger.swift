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
//class NGAArranger {
//    
//    class func arrangeArrayIntoDictionaryAndKeyArray(_ array:NSArray?, objectOrderedBefore:((Any?, Any?) -> Bool)?, keyGenerator:(Any?) -> String?, keyOrderedBeforeBlock:((String, String) -> Bool)?) -> (dictionary:NSDictionary?, keyArray:NSArray?) {
//        var temp:(dictionary:NSDictionary?, keyArray:NSArray?) = (nil,nil)
//        if var arr = array?.mutableCopy() as? SwiftArray {
//            let dict = NSMutableDictionary()
//            var keyMutableArray = NSMutableArray()
//            if let objOrder = objectOrderedBefore {
//                arr.sort(by: objOrder)
//            }
//            for object in arr {
//                if let key = keyGenerator(object) {
//                    let mutArray = (dict[key] as? NSArray)?.mutableCopy() as? NSMutableArray ?? NSMutableArray()
//                    mutArray.add(object)
//                    dict[key] = mutArray.copy()
//                    if !keyMutableArray.contains(key) {keyMutableArray.add(key)}
//                }
//            }
//            if let keyOrder = keyOrderedBeforeBlock {
//                if var keyArray = keyMutableArray.mutableCopy() as? [String] {
//                    keyArray.sort(by: keyOrder)
//                    keyMutableArray = (keyArray as NSArray).mutableCopy() as? NSMutableArray ?? keyMutableArray
//                }
//            }
//            temp.dictionary = dict.copy() as? NSDictionary
//            temp.keyArray = keyMutableArray.copy() as? NSArray
//        }
//        return temp
//    }
//    
//    class func isStringBeforeString(_ string1:String?, string2:String?, ascending:Bool = true, caseInsensitive:Bool = true) -> Bool {
//        var str1 = string1 ?? ""
//        var str2 = string2 ?? ""
//        if caseInsensitive {
//            str1 = str1.lowercased()
//            str2 = str2.lowercased()
//        }
//        return ascending ? str1 < str2 : str1 > str2
//    }
//    
//}
