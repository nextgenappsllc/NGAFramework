//
//  XMLParser.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/21/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

class XmlParser {
    class func parseData(_ data:Data?,autoTrimText:Bool = true) -> XmlElement? {
        var temp:XmlElement?
        if let cData = data {
            let parser = XMLParser(data: cData)
            let parserDelegate = XmlParserDelegate()
            parserDelegate.autoTrimText = autoTrimText
            parser.delegate = parserDelegate
            parser.parse()
            temp = parserDelegate.mainXMLElement
        }
        return temp
    }
}

class XmlParserDelegate: NSObject, XMLParserDelegate {
    var autoTrimText = true
    var mainXMLElement:XmlElement?
    var currentXMLElement:XmlElement?
    func parserDidStartDocument(_ parser: XMLParser) { mainXMLElement = nil }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let newElement = XmlElement(elementName: elementName)
        newElement.attributeDictionary = attributeDict
        if mainXMLElement == nil { mainXMLElement = newElement }
        if currentXMLElement != nil { currentXMLElement?.addSubElement(newElement) }
        currentXMLElement = newElement
    }
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        let data = currentXMLElement?.cdata ?? Data()
        currentXMLElement?.cdata = data.append(CDATABlock)
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let text = currentXMLElement?.text ?? ""
        currentXMLElement?.text = text.appendIfNotNil(string)
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if autoTrimText {currentXMLElement?.text = currentXMLElement?.text?.trim()}
        currentXMLElement = currentXMLElement?.parentElement
    }
    func parserDidEndDocument(_ parser: XMLParser) {}
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {print("parse error \(parseError)")}
}

open class XmlElement {
    open var elementName:String
    open var attributeDictionary:[String:String] = [:]
    open var text:String?
    open var cdata:Data?
    open var subElements:[XmlElement] = []
    open weak var parentElement:XmlElement?
    open var rootElement:XmlElement {get {return parentElement?.rootElement ?? self}}
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
    open class func from(_ data:Data?, autoTrimText:Bool = true) -> XmlElement? {return XmlParser.parseData(data,autoTrimText: autoTrimText)}
    public convenience init?(data:Data?, autoTrimText:Bool = true) {
        guard let el = XmlParser.parseData(data,autoTrimText: autoTrimText) else {return nil}
        self.init(copy: el)
    }
    public convenience init(elementName:String, attributeDictionary:[String:String]) {
        self.init(elementName: elementName)
        self.attributeDictionary = attributeDictionary
    }
    open func addSubElement(_ element:XmlElement?) {
        element?.parentElement = self
        let _=subElements.appendIfNotNil(element)
    }
    open func subElementsNamed(_ name:String?) -> [XmlElement]? {
        if name == nil {return nil}
        return subElements.mapToNewArray() {(element) -> XmlElement? in return element.elementName == name ? element : nil}
    }
    open func subElementNamed(_ name:String?) -> XmlElement? {
        if name == nil {return nil}
        return subElements.selectFirst(){ (element) -> Bool in element.elementName == name }
    }
    open func subElementText(_ name:String?) -> String? {return subElementNamed(name)?.text}
    open func subElementCData(_ name:String?) -> Data? {return subElementNamed(name)?.cdata}
    open func subElementAttributeDictionary(_ name:String?) -> [String:String]? {return subElementNamed(name)?.attributeDictionary}
    open func toXmlString(_ indent:Int = 0, showWhiteSpace:Bool = false) -> String {
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
        func addSubText(_ txt:String) {
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







