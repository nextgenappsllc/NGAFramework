//
//  XMLParser.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/21/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

class XmlParser {
    class func parseData(data:NSData?,autoTrimText:Bool = true) -> XmlElement? {
        var temp:XmlElement?
        if let cData = data {
            let parser = NSXMLParser(data: cData)
            let parserDelegate = XmlParserDelegate()
            parserDelegate.autoTrimText = autoTrimText
            parser.delegate = parserDelegate
            parser.parse()
            temp = parserDelegate.mainXMLElement
        }
        return temp
    }
}

class XmlParserDelegate: NSObject, NSXMLParserDelegate {
    var autoTrimText = true
    var mainXMLElement:XmlElement?
    var currentXMLElement:XmlElement?
    func parserDidStartDocument(parser: NSXMLParser) { mainXMLElement = nil }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let newElement = XmlElement(elementName: elementName)
        newElement.attributeDictionary = attributeDict
        if mainXMLElement == nil { mainXMLElement = newElement }
        if currentXMLElement != nil { currentXMLElement?.addSubElement(newElement) }
        currentXMLElement = newElement
    }
    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        let data = currentXMLElement?.cdata ?? NSData()
        currentXMLElement?.cdata = data.append(CDATABlock)
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let text = currentXMLElement?.text ?? ""
        currentXMLElement?.text = text.appendIfNotNil(string)
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if autoTrimText {currentXMLElement?.text = currentXMLElement?.text?.trim()}
        currentXMLElement = currentXMLElement?.parentElement
    }
    func parserDidEndDocument(parser: NSXMLParser) {}
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {print("parse error \(parseError)")}
}

public class XmlElement {
    public var elementName:String
    public var attributeDictionary:[String:String] = [:]
    public var text:String?
    public var cdata:NSData?
    public var subElements:[XmlElement] = []
    public weak var parentElement:XmlElement?
    public var rootElement:XmlElement {get {return parentElement?.rootElement ?? self}}
    public init(elementName:String) {
        self.elementName = elementName
    }
    public init(copy:XmlElement) {
        self.elementName = copy.elementName
        self.attributeDictionary = copy.attributeDictionary
        self.text = copy.text
        self.cdata = copy.cdata
        self.text = copy.text
        self.subElements = copy.subElements
    }
    public class func from(data:NSData?, autoTrimText:Bool = true) -> XmlElement? {return XmlParser.parseData(data,autoTrimText: autoTrimText)}
    public convenience init?(data:NSData?, autoTrimText:Bool = true) {
        guard let el = XmlParser.parseData(data,autoTrimText: autoTrimText) else {return nil}
        self.init(copy: el)
    }
    public convenience init(elementName:String, attributeDictionary:[String:String]) {
        self.init(elementName: elementName)
        self.attributeDictionary = attributeDictionary
    }
    public func addSubElement(element:XmlElement?) {
        element?.parentElement = self
        subElements.appendIfNotNil(element)
    }
    public func subElementsNamed(name:String?) -> [XmlElement]? {
        if name == nil {return nil}
        return subElements.mapToNewArray() {(element) -> XmlElement? in return element.elementName == name ? element : nil}
    }
    public func subElementNamed(name:String?) -> XmlElement? {
        if name == nil {return nil}
        return subElements.selectFirst(){ (element) -> Bool in element.elementName == name }
    }
    public func subElementText(name:String?) -> String? {return subElementNamed(name)?.text}
    public func subElementCData(name:String?) -> NSData? {return subElementNamed(name)?.cdata}
    public func subElementAttributeDictionary(name:String?) -> [String:String]? {return subElementNamed(name)?.attributeDictionary}
    public func toXmlString(indent:Int = 0, showWhiteSpace:Bool = false) -> String {
        var str = indent == 0 ? "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" : ""
        let spacer = showWhiteSpace ? " " : ""
        let tab = String.repeatedStringOfSize(indent, repeatedString: spacer)
        let oneLine = subElements.count == 0
        str += "\(tab)<\(elementName)"
        for (key, value) in attributeDictionary {str += " \(key.xmlEncode())=\"\(value.xmlEncode())\""}
        let text = self.text?.xmlEncode()
        let textExists = String.isNotEmpty(text)
        guard !oneLine || cdata != nil || textExists else {str += "/>";return str}
        str += ">"
        if !oneLine {str += "\n"}
        func addSubText(txt:String) {
            if !oneLine {str += "\(tab)\(spacer)"}
            str += txt
            if !oneLine {str += "\n"}
        }
        if textExists {addSubText(text!)}
        if let cdata = cdata {addSubText("<![CDATA[\(cdata)]]>")}
        for element in subElements {str += "\(element.toXmlString(indent + 1,showWhiteSpace: showWhiteSpace))\n"}
        if !oneLine {str += tab}
        str += "</\(elementName)>"
        return str
    }
}







