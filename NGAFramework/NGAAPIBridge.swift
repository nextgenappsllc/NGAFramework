//
//  NGAAPIBridge.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 6/11/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit


class NGAAPIBridge: NSObject {
    
    typealias ElementToObjectBlock = (NGAXMLElement?) -> AnyObject?
    
    //    class func getObjectArrayFromElements(elements:NSArray?, creationBlock:ElementToObjectBlock?) -> NSArray? {
    //        var temp:NSArray?
    //        if let cElements = elements {
    //            var mutArray = NSMutableArray()
    //            for object in cElements {
    //                var element = object as? NGAXMLElement
    //                if let block = creationBlock {
    //                    if let createdObject: AnyObject = block(element) {
    //                        mutArray.addObject(createdObject)
    //                    }
    //                }
    //
    //            }
    //            temp = mutArray.copy() as? NSArray
    //        }
    //
    //        return temp
    //    }
    
    class func getObjectArrayFromElements(elements:NSArray?) -> NSArray? {
        var temp:NSArray?
        if let cElements = elements {
            let mutArray = NSMutableArray()
            for object in cElements {
                let element = object as? NGAXMLElement
                if let createdObject: AnyObject = objectFromXMLElement(element) {
                    mutArray.addObject(createdObject)
                }
            }
            temp = mutArray.copy() as? NSArray
        }
        
        return temp
    }
    
    
    class func bridgeXMLDataToArray(data:NSData?, elementName:String) -> NSArray? {
        var temp:NSArray?
        let mainElement = NGAXMLParser.parseData(data)
        temp = bridgeXMLElementToArray(mainElement, elementName: elementName)
        return temp
    }
    
    class func bridgeXMLElementToArray(element:NGAXMLElement?, elementName:String) -> NSArray? {
        var temp:NSArray?
        let mainElement = element
        if mainElement?.elementName == elementName && mainElement != nil{
            temp = [mainElement!]
        }
        else {
            let elements = mainElement?.getSubElementsNamed(elementName)
            temp = getObjectArrayFromElements(elements)
        }
        
        return temp
    }
    
    class func objectFromXMLElement(xmlElement:NGAXMLElement?) -> AnyObject? {
        var temp:AnyObject?
        if let name = xmlElement?.elementName {
            temp = creationBlockForElementNamed(name)?(xmlElement)
        }
        return temp
    }
    
    class func creationBlockForElementNamed(elementName:String) -> ElementToObjectBlock? {
        let temp:ElementToObjectBlock? = nil
        switch elementName {
        default:
            break
        }
        
        return temp
    }
    
    class func bridgeDataFromXMLToObjectsArray(data:NSData?, objectNames:NSArray?) -> NSArray?{
        var temp:NSArray?
        let mainElement = NGAXMLParser.parseData(data)
        temp = bridgeXMLToObjectsArray(mainElement, objectNames: objectNames)
        return temp
    }
    
    class func bridgeXMLToObjectsArray(xmlElement:NGAXMLElement?, objectNames:NSArray?) -> NSArray?{
        var temp:NSArray?
        let objectNamesProvided = objectNames != nil && objectNames!.count > 0
        if objectNamesProvided && xmlElement != nil {
            let cObjectNames = objectNames!
            let mutArray = NSMutableArray()
            for item in cObjectNames {
                if let name = item as? String {
                    if let arr = bridgeXMLElementToArray(xmlElement, elementName: name) {
                        for object in arr {
                            mutArray.addObject(object)
                        }
                    }
                }
            }
            temp = mutArray.count > 0 ? mutArray.copy() as? NSArray : nil
        }
        
        
        return temp
    }
    
    
    class func bridgeDataFromXMLToObjects(data:NSData?, objectNames:NSArray?) -> AnyObject? {
        var temp:AnyObject?
        let mainElement = NGAXMLParser.parseData(data)
        temp = mainElement
        let objectNamesProvided = objectNames != nil && objectNames!.count > 0
        if objectNamesProvided && mainElement != nil {
            let cObjectNames = objectNames!
            let count = cObjectNames.count
            if count == 1 {
                if let name = cObjectNames.firstObject as? String {
                    if name == mainElement?.elementName {
                        let creationBlock = creationBlockForElementNamed(name)
                        temp = creationBlock?(mainElement)
                    }
                    else {
                        temp = bridgeXMLElementToArray(mainElement, elementName: name)
                    }
                }
            }
            else if count > 1{
                let dict = NSMutableDictionary()
                for object in cObjectNames {
                    if let name = object as? String {
                        if let arr = bridgeXMLElementToArray(mainElement, elementName: name) {
                            dict[name] = arr
                        }
                    }
                }
                temp = dict.copy() as? NSDictionary
            }
            
            
        }
        
        return temp
    }
    
}
