//
//  NGAXMLParser.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 3/2/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation



//class NGAXMLParser:NSObject {
//    
//    class func parseData(data:NSData?) -> NGAXMLElement? {
//        var temp:NGAXMLElement?
////        let d = data?.toString(NSWindowsCP1251StringEncoding)?.stringByReplacingOccurrencesOfString("&", withString: "&amp;").dataUsingEncoding(NSUTF8StringEncoding)
////        print(d?.toString())
//        if let cData = data {
////            var xmlString = NSString(data: cData, encoding: NSUTF8StringEncoding)
////            println("string from data = \(xmlString)")
//            let parser = NSXMLParser(data: cData)
//            let parserDelegate = NGAXMLParserDelegate()
//            parser.delegate = parserDelegate
//            parser.parse()
////            println("parsed dictionary = \(parserDelegate.parsedDictionary)")
//            if parserDelegate.firstElementName != nil {
//                temp = NGAXMLElement(elementName: parserDelegate.firstElementName!, and: parserDelegate.parsedDictionary as [NSObject : AnyObject])
//            }
//        }
//        
//        return temp
//    }
//    
//}
//
//
//
//class NGAXMLParserDelegate: NSObject, NSXMLParserDelegate {
//    
//    var elementNamesMutableArray = NSMutableArray()
//    var elementsMutableDictionary = NSMutableDictionary()
//    var parsedDictionary = NSDictionary()
//    var firstElementName : String?
//    
//    
//    func parserDidStartDocument(parser: NSXMLParser) {
//        elementNamesMutableArray = NSMutableArray()
//        elementsMutableDictionary = NSMutableDictionary()
//        parsedDictionary = NSDictionary()
//        firstElementName = nil
////        println("starting document\n")
//    }
//    
//    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
////        println("\n element name: \(elementName)\n")
//        if firstElementName == nil {
//            firstElementName = elementName
//        }
//        elementNamesMutableArray.addObject(elementName)
//        let mutableDictionary = NSMutableDictionary()
//        if attributeDict.count > 0 {
////            print("Attribute dictionary = \(attributeDict)")
//            mutableDictionary.setObject(attributeDict, forKey: createAttributeDictionaryKeyForElement(elementName))
//        }
//        elementsMutableDictionary.setObject(mutableDictionary.copy(), forKey: elementName)
//    }
//    
//    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
//        let elementName = elementNamesMutableArray.lastObject as? NSString
//        if elementName != nil {
//            if let mutableDictionary = (elementsMutableDictionary.objectForKey(elementName!) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary{
//            let cdataKey = createCDATAKeyForElement(elementName!)
//            var finalData = CDATABlock
//            if let oldData = mutableDictionary[cdataKey] as? NSData {
//                let newData = oldData.mutableCopy() as! NSMutableData
//                newData.appendData(CDATABlock)
//                finalData = newData.copy() as! NSData
//            }
//            mutableDictionary.setObject(finalData, forKey: cdataKey)
//            
//            
////            var cdataString = NSString(data: CDATABlock, encoding: NSUTF8StringEncoding)
////            if cdataString != nil {
//////                println("cdata string = \(cdataString)")
////                let combinedKey = createTextKeyForElement(elementName!)
////                if let oldCombinedString = mutableDictionary[combinedKey] as? String {
////                    cdataString = oldCombinedString.stringByAppendingString(cdataString! as String)
////                }
////                mutableDictionary.setObject(cdataString!, forKey: combinedKey)
////            }
//            
//            elementsMutableDictionary.setObject(mutableDictionary.copy(), forKey: elementName!)
//            }
//        }
//        
//    }
//    
//    
//    func parser(parser: NSXMLParser, foundCharacters string: String) {
//        let elementName = elementNamesMutableArray.lastObject as? NSString
////        if elementName == "name" {print(string)}
//        
//        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.controlCharacterSet()) as NSArray
//        let filteredString = components.componentsJoinedByString("")
//        
//        if elementName != nil && !filteredString.isEmpty {
//            let mutableDictionary = (elementsMutableDictionary.objectForKey(elementName!) as! NSDictionary).mutableCopy() as! NSMutableDictionary
//            //            println("found characters \(rawString)")
//            var combinedString = string
//            let combinedKey = createTextKeyForElement(elementName!)
//            if let oldCombinedString = mutableDictionary[combinedKey] as? String {
//                combinedString = oldCombinedString.stringByAppendingString(combinedString as String)
//            }
//            mutableDictionary.setObject(combinedString, forKey: combinedKey)
//            
//            elementsMutableDictionary.setObject(mutableDictionary.copy(), forKey: elementName!)
//        }
//        
//        
//        
//        
//    }
//    
//    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
////        println("\\n ended element \(elementName)")
//        if let currentElementMutableDictionary = (elementsMutableDictionary.objectForKey(elementName) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary {
//            if elementNamesMutableArray.count > 0 {
//                if elementNamesMutableArray.count > 1 {
//                    let previousElementName = elementNamesMutableArray[elementNamesMutableArray.count - 2]
//                    let previousElementMutableDictionary = (elementsMutableDictionary.objectForKey(previousElementName) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary
//                    var mutableArray = NSMutableArray()
//                    if let array = previousElementMutableDictionary?.objectForKey(elementName) as? NSArray {
//                        mutableArray = array.mutableCopy() as! NSMutableArray
//                    }
//                    mutableArray.addObject(currentElementMutableDictionary)
//                    previousElementMutableDictionary?.setObject(mutableArray.copy(), forKey: elementName)
//                    if previousElementMutableDictionary != nil && previousElementName is NSCopying {
//                        elementsMutableDictionary[previousElementName as! NSCopying] = previousElementMutableDictionary!.copy()
//                    }
//                    
//                    
//                }
//                else {
//                    parsedDictionary = currentElementMutableDictionary.copy() as! NSDictionary
//                    
//                }
//                
//                elementsMutableDictionary.setObject(NSDictionary(), forKey: elementName)
//                elementNamesMutableArray.removeObject(elementName)
//            }
//        }
//        
//    }
//    
//    func parserDidEndDocument(parser: NSXMLParser) {
////        println("parsedDictionary = \(parsedDictionary)")
//        
//    }
//    
//    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
//        print("parse error \(parseError)")
//    }
//    
//    //MARK: Helper Methods
//    func createAttributeDictionaryKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@AttributeDictionaryKey", string)
//        return newString
//    }
//    func createTextKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@TextKey", string)
//        return newString
//    }
//    func createCDATAKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@CDATAKey", string)
//        return newString
//    }
//    
//    func stringFromHTMLString(inputString:String) -> NSString {
//        /// Refactor for nil
////        print(inputString)
//        let transForm:CFStringRef = "Any-Hex/Java" as CFStringRef
//        let convertedString = (inputString as NSString).mutableCopy() as! CFMutableStringRef
//        CFStringTransform(convertedString, nil, transForm, true)
//        let finalString = NSString(format: convertedString, NSUTF16StringEncoding)
//        
//        
//        
//        
//        return finalString
//    }
//    
//    
//    func mainElement() -> NGAXMLElement? {
//        var mainElement:NGAXMLElement?
//        if self.firstElementName != nil {
//            mainElement = NGAXMLElement(elementName: self.firstElementName!, and: self.parsedDictionary as [NSObject : AnyObject])
//        }
//        
//        return mainElement
//    }
//    
//}
//
//
//
//
///// Took away NSObject conformance
//public class NGAXMLElement {
//    
//    var elementName:String?
//    var attributeDictionary:[NSObject:AnyObject]?
//    var text:String?
////    var cdataString:String?
//    var cdata:NSData?
//    var elements:[AnyObject]?
//    
//    init(elementName:String, and dictionary:[NSObject:AnyObject]?) {
////        super.init()
//        self.elementName = elementName
//        if dictionary != nil {
//            let attributeDictionaryKey = createAttributeDictionaryKeyForElement(self.elementName!) as String
//            let textKey = createTextKeyForElement(self.elementName!) as String
//            let cdataKey = createCDATAKeyForElement(self.elementName!) as String
//            var elementArray:[AnyObject] = []
//            for key in dictionary!.keys {
//                //                println("checking key \(key)")
//                if key == attributeDictionaryKey {
//                    self.attributeDictionary = dictionary![key] as? [NSObject:AnyObject]
//                }
//                else if key == textKey {
//                    self.text = dictionary![key] as? String
//                }
//                else if key == cdataKey {
//                    self.cdata = dictionary![key] as? NSData
//                }
//                else if let subElementArray = dictionary![key] as? NSArray {
//                    if subElementArray.count > 0 {
//                        let newDictionary = [key:subElementArray]
//                        elementArray.append(newDictionary)
//                        
//                    }
//                }
//                
//            }
//            if elementArray.count > 0 {
//                self.elements = elementArray
//                self.convertElementsArray()
//            }
//            
//        }
//        
//    }
//    
////    override init() {
////        super.init()
////    }
//    
//    func convertElementsArray() {
//        if self.elements != nil {
//            var convertedElements:[AnyObject] = []
//            for element in self.elements! {
//                if var element = element as? [NSObject:AnyObject] {
//                    for key in element.keys {
//                        if let subElementArray = element[key] as? [AnyObject] {
//                            for subElementDictionary in subElementArray {
//                                if let subElementDictionary = subElementDictionary as? [NSObject:AnyObject] {
//                                    let convertedElement = NGAXMLElement(elementName: key as! String, and: subElementDictionary)
//                                    convertedElements.append(convertedElement)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            self.elements = convertedElements
//        }
//    }
//    
//    func getSubElementsNamed(name:String) -> NSArray? {
//        let mutableArray = NSMutableArray()
//        
//        if self.elements?.count > 0 {
//            searchForElementsNamed(name, withIn: self.elements!, andPlaceIn: mutableArray)
//        }
//        
//        //        println("element array count = \(mutableArray.count)")
//        if mutableArray.count > 0 {
//            return (mutableArray.copy() as? NSArray)
//        }
//        else {
//            return nil
//        }
//        
//        
//    }
//    
//    
//    func subElementText(name:String) -> String? {
//        return (getSubElementsNamed(name)?.firstObject as? NGAXMLElement)?.text
//    }
//    
//    
//    func searchForElementsNamed(name:String , withIn array:[AnyObject], andPlaceIn mutableArray:NSMutableArray) {
//        for element in array {
//            if let element = element as? NGAXMLElement {
//                
//                if element.elementName == name {
//                    mutableArray.addObject(element)
//                }
//                else {
//                    if element.elements?.count > 0 {
//                        searchForElementsNamed(name, withIn: element.elements!, andPlaceIn: mutableArray)
//                        
//                    }
//                }
//            }
//        }
//        
//    }
//    
////    func makeCDATAString() {
////        if self.cdata != nil {
////            let dataString = NSString(data: self.cdata!, encoding: NSUTF8StringEncoding)
////            self.cdataString = dataString as? String
////        }
////    }
//    
//    
//    func createAttributeDictionaryKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@AttributeDictionaryKey", string)
//        return newString
//    }
//    func createTextKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@TextKey", string)
//        return newString
//    }
//    func createCDATAKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@CDATAKey", string)
//        return newString
//    }
//    func createCombinedValueKeyForElement(string:NSString) -> NSString {
//        let newString = NSString(format: "kNGA%@CombinedValueKey", string)
//        return newString
//    }
//    
//}
//
//
//
//
//
//
//
//
