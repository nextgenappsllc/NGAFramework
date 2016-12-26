//
//  StringExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import CryptoSwift


public extension String {
    
    public func containsString(_ str:String, caseInsensitive:Bool = false) -> Bool {
//        var temp = false
//        let nsStr = caseInsensitive ? str.lowercased() : str
//        let newSelf:NSString = caseInsensitive ? self.lowercased() as NSString : self as NSString
//        temp = newSelf.contains(nsStr)
//        return temp
        return caseInsensitive ? self.lowercased().contains(str.lowercased()) : self.contains(str)
    }
    
    public func stringByAddingPathComponent(_ pathComp: String?) -> String? {
        if let comp = pathComp {
            return (self as NSString).appendingPathComponent(comp)
        }
        else {return self}
    }
    
    
    public var characterArray:[Character] {get{return Array(characters)}}
    public var substrings:[String] {get {return characterArray.mapToNewArray(iteratorBlock: { (element) -> String? in
        return String(element)
    })}}
    
    public subscript (i: Int) -> String? {
        get{return substrings.itemAtIndex(i)}
        mutating set {
            var arr = substrings
            let _=arr.safeSet(i, toElement: newValue)
            self = arr.joined(separator: "")
        }
    }
    
    public subscript (r: Range<Int>) -> String {
        var range = r
        let letterCount = characters.count
        if range.upperBound > letterCount { range = (range.lowerBound..<letterCount) }
        return substring(with: characters.index(startIndex, offsetBy: range.lowerBound)..<characters.index(startIndex, offsetBy: range.upperBound))
//        var range = r
//        let letterCount = characters.count
//        if range.upperBound > letterCount { range.upperBound = letterCount }
//        return substring(with: characters.index(startIndex, offsetBy: range.lowerBound)..<characters.index(startIndex, offsetBy: range.upperBound))
    }
    
    
    public func abbreviatedStringWithMaxCharacters(_ maxChars:Int = 3) -> String {
        var temp = self
        let components = temp.components(separatedBy: " ")
        if components.count > 1 {
            temp = ""
            for str in components {
                if !str.isEmpty() {
                    temp += str[0] ?? ""
                }
            }
        }
        temp = temp[0..<maxChars]
        
        return temp
    }
    
    public var length:Int {get {return self.characters.count}}
    
    
    public var isValidEmailFormat:Bool {
        get{
            let components = self.components(separatedBy: "@")
            return components.count == 2 && components.last?.components(separatedBy: ".").count ?? 0 >= 2
        }
    }
    
    public static func doesExist(_ str:String?) -> Bool {return !(str?.isEmpty() ?? true)}
    public static func isNotEmpty(_ str:String?) -> Bool {
        return doesExist(str)
    }
    public static func isEmptyOrNil(_ str:String?) -> Bool {
        return !isNotEmpty(str)
    }
    
    public var url:URL? {get{return URL(string: self)}}
    public var fileUrl:URL? {get{return URL(fileURLWithPath: self)}}
    
    public static func largerContainsSmaller(string1 str1:String?, string2 str2:String?, caseInsensitive:Bool = true) -> Bool {
        if !doesExist(str1) || !doesExist(str2) {return false}
        let largerString:String ; let smallerString:String
        if str1!.length < str2!.length {largerString = str2!; smallerString = str1!}
        else {largerString = str1!; smallerString = str2!}
        return largerString.containsString(smallerString, caseInsensitive: caseInsensitive)
    }
    
    public func appendIfNotNil(_ str:String?, separator:String? = nil) -> String {
        guard let str = str else {return self}
        return surround(prefix: nil, postfix: "\(separator ?? "")\(str)")
    }
    
    public func prependIfNotNil(_ str:String?, separator:String? = nil) -> String {
        return surround(prefix: "\(separator ?? "")\(str ?? "")", postfix: nil)
    }
    
    public func surround(prefix pre:String?, postfix post:String?) -> String{
        return "\(pre ?? "")\(self)\(post ?? "")"
    }
    
    public func regexNumberOfMatches(_ pattern:String, patternOptions:NSRegularExpression.Options = NSRegularExpression.Options.init(rawValue: 0), matchingOptions:NSRegularExpression.MatchingOptions = NSRegularExpression.MatchingOptions.init(rawValue: 0)) -> Int? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: patternOptions)
            return regex.numberOfMatches(in: self, options: matchingOptions, range: NSMakeRange(0, self.characters.count))
        } catch {
            return nil
        }
    }
    
    public func regexMatchExists(_ pattern:String, patternOptions:NSRegularExpression.Options = NSRegularExpression.Options.init(rawValue: 0), matchingOptions:NSRegularExpression.MatchingOptions = NSRegularExpression.MatchingOptions.init(rawValue: 0)) -> Bool {
        return regexNumberOfMatches(pattern, patternOptions: patternOptions, matchingOptions: matchingOptions) ?? 0 > 0
    }
    
    //TODO rename to isBlank
    public func isEmpty() -> Bool {
        return self.trim().length == 0
    }
    
    
    
    
    public func urlEncode() -> String {
        let charactersToEscape = "\\!*'();:@&=+$,/?%#[]\" "
        let allowedCharacters = CharacterSet(charactersIn: charactersToEscape).inverted
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? self
    }
    
    
    fileprivate static let xmlEscapeCharMap = [["&":"&amp;"],["<":"&lt;"], [">": "&gt;"], ["'":"&pos;"], ["\"":"&quo;"]]
    
    public func xmlEncode() -> String {
        var str = self
        for charDictionary in String.xmlEscapeCharMap {
            for (key, value) in charDictionary {
                str = str.replacingOccurrences(of: key, with: value)
            }
        }
        return str
    }
    public func xmlDecode() -> String {
        var str = self
        for charDictionary in String.xmlEscapeCharMap.reversed() {
            for (key, value) in charDictionary.invert() {
                str = str.replacingOccurrences(of: key, with: value)
            }
        }
        return str
    }
    
//    public func htmlDecode() -> String? {
//        guard let encodedData = dataUsingEncoding(NSUTF8StringEncoding) else {return nil}
//        let attributedOptions : [String: AnyObject] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding]
//        return try? NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil).string
//    }
    
    public func htmlDecode() -> String {
        var result = ""
        var position = startIndex
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                if let decoded = HTMLEntities.decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        result.append(self[position ..< endIndex])
        return result
    }
    
    
    public func crc32CheckSum() -> String? {
        let s = self.crc32()
        if let i = UInt(s, radix: 16) {
            return "\(i)"
        }
        return nil
    }
    
    public func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    public mutating func trimInPlace() {
        self = trim()
    }
    
    public static func fromAny(_ obj:Any?) -> String? {
        return obj as? String
    }
    
    public func toDateWithFormat(_ format:String) -> Date? {
        return Date.date(from: self, withFormat: format)
    }
    
    public func toAttributedString(_ attributes:[String:Any]?) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    public func toAttributedString(font:UIFont?, color: UIColor?) -> NSAttributedString {
        var attributes = [String:Any]()
        attributes[NSFontAttributeName] = font
        attributes[NSForegroundColorAttributeName] = color
        return toAttributedString(attributes)
    }

    
    public static func repeatedStringOfSize(_ s:Int, repeatedString:String = " ") -> String {
        var str = ""
        s.times { (i) in
            str += repeatedString
        }
        return str
    }
    
    
    public static let degrees = "°"
    
    /**
     Encrypts the string with the given 32 bit key.
     
     If you would like to use a passphrase instead of the key then use the md5 hash of the passphrase to ensure it is 32 bit like in the following example.
     ````
     let key = "passphrase".md5()
     let encryptionResult = "encrypt me!".AES256Encrypt(key: key)
     ````
     
     - Parameter key: The key to use for encryption. **Must be 32 bits in length.**
     
     - Returns: A tuple containing the hex string values on the initialization vector and the encrypted data.
     */
    func AES256Encrypt(key:String)->(iv:String, encrypted:String?){
        let _key = key.utf8.map{$0}
        let _iv = AES.randomIV(AES.blockSize)
        var t:(iv:String, encrypted:String?) = (_iv.toHexString(), nil)
        guard _key.count == 32, let aes = try? AES(key: _key, iv: _iv), let encrypted = try? aes.encrypt(Array(self.utf8)) else {return t}
        t.encrypted = encrypted.toHexString()
        return t
    }
    
    /**
     Decrypts the string with the given 32 bit key and initialization vector.
     
     If you would like to use a passphrase instead of the key then use the md5 hash of the passphrase to ensure it is 32 bit like in the following example.
     ````
     let key = "passphrase".md5()
     let encryptionResult = "encrypt me!".AES256Encrypt(key: key)
     let decrypted = encryptionResult.encrypted?.AES256Decrypt(key: key, iv: encryptionResult.iv)
     ````
     
     - Parameter key: The key to use for encryption. **Must be 32 bits in length.**
     
     - Parameter iv: The initialization vector used to encrypt the data as a hex string.
     
     - Returns: A decrypted string if successful
     */
    func AES256Decrypt(key:String, iv:String) -> String?{
        let _key = key.utf8.map{$0}
        let _iv = iv.convertFromHex()
        guard _key.count == 32, let aes = try? AES(key: _key, iv: _iv), let decrypted = try? aes.decrypt(self.convertFromHex()) else {return nil}
        return String(data: Data(decrypted), encoding: .utf8)
    }
    
    /**
     Converts the string into an array of numbers corresponding to the hex value of character pairs.
     
     So the string "ff00" would get broken up into pairs so "ff" and "00" and then converted to numbers.
     The returned array would be [255, 0].
     
     - Returns: An array of 8 bit unsigned integers.
     */
    func convertFromHex() -> [UInt8]{
        var values:[UInt8] = []
        var chars = characters
        var pair = ""
        while let char = chars.popFirst() {
            pair = "\(pair)\(char)"
            if pair.characters.count > 1 {
                if let value = UInt8(pair, radix: 16){values.append(value)}
                pair = ""
            }
        }
        return values
    }
    
    
}



private struct HTMLEntities {
    static let characterEntities : [String: Character] = [
        
        // XML predefined entities:
        "&quot;"     : "\"",
        "&amp;"      : "&",
        "&apos;"     : "'",
        "&lt;"       : "<",
        "&gt;"       : ">",
        
        // HTML character entity references:
        "&nbsp;"     : "\u{00A0}",
        "&iexcl;"    : "\u{00A1}",
        "&cent;"     : "\u{00A2}",
        "&pound;"    : "\u{00A3}",
        "&curren;"   : "\u{00A4}",
        "&yen;"      : "\u{00A5}",
        "&brvbar;"   : "\u{00A6}",
        "&sect;"     : "\u{00A7}",
        "&uml;"      : "\u{00A8}",
        "&copy;"     : "\u{00A9}",
        "&ordf;"     : "\u{00AA}",
        "&laquo;"    : "\u{00AB}",
        "&not;"      : "\u{00AC}",
        "&shy;"      : "\u{00AD}",
        "&reg;"      : "\u{00AE}",
        "&macr;"     : "\u{00AF}",
        "&deg;"      : "\u{00B0}",
        "&plusmn;"   : "\u{00B1}",
        "&sup2;"     : "\u{00B2}",
        "&sup3;"     : "\u{00B3}",
        "&acute;"    : "\u{00B4}",
        "&micro;"    : "\u{00B5}",
        "&para;"     : "\u{00B6}",
        "&middot;"   : "\u{00B7}",
        "&cedil;"    : "\u{00B8}",
        "&sup1;"     : "\u{00B9}",
        "&ordm;"     : "\u{00BA}",
        "&raquo;"    : "\u{00BB}",
        "&frac14;"   : "\u{00BC}",
        "&frac12;"   : "\u{00BD}",
        "&frac34;"   : "\u{00BE}",
        "&iquest;"   : "\u{00BF}",
        "&Agrave;"   : "\u{00C0}",
        "&Aacute;"   : "\u{00C1}",
        "&Acirc;"    : "\u{00C2}",
        "&Atilde;"   : "\u{00C3}",
        "&Auml;"     : "\u{00C4}",
        "&Aring;"    : "\u{00C5}",
        "&AElig;"    : "\u{00C6}",
        "&Ccedil;"   : "\u{00C7}",
        "&Egrave;"   : "\u{00C8}",
        "&Eacute;"   : "\u{00C9}",
        "&Ecirc;"    : "\u{00CA}",
        "&Euml;"     : "\u{00CB}",
        "&Igrave;"   : "\u{00CC}",
        "&Iacute;"   : "\u{00CD}",
        "&Icirc;"    : "\u{00CE}",
        "&Iuml;"     : "\u{00CF}",
        "&ETH;"      : "\u{00D0}",
        "&Ntilde;"   : "\u{00D1}",
        "&Ograve;"   : "\u{00D2}",
        "&Oacute;"   : "\u{00D3}",
        "&Ocirc;"    : "\u{00D4}",
        "&Otilde;"   : "\u{00D5}",
        "&Ouml;"     : "\u{00D6}",
        "&times;"    : "\u{00D7}",
        "&Oslash;"   : "\u{00D8}",
        "&Ugrave;"   : "\u{00D9}",
        "&Uacute;"   : "\u{00DA}",
        "&Ucirc;"    : "\u{00DB}",
        "&Uuml;"     : "\u{00DC}",
        "&Yacute;"   : "\u{00DD}",
        "&THORN;"    : "\u{00DE}",
        "&szlig;"    : "\u{00DF}",
        "&agrave;"   : "\u{00E0}",
        "&aacute;"   : "\u{00E1}",
        "&acirc;"    : "\u{00E2}",
        "&atilde;"   : "\u{00E3}",
        "&auml;"     : "\u{00E4}",
        "&aring;"    : "\u{00E5}",
        "&aelig;"    : "\u{00E6}",
        "&ccedil;"   : "\u{00E7}",
        "&egrave;"   : "\u{00E8}",
        "&eacute;"   : "\u{00E9}",
        "&ecirc;"    : "\u{00EA}",
        "&euml;"     : "\u{00EB}",
        "&igrave;"   : "\u{00EC}",
        "&iacute;"   : "\u{00ED}",
        "&icirc;"    : "\u{00EE}",
        "&iuml;"     : "\u{00EF}",
        "&eth;"      : "\u{00F0}",
        "&ntilde;"   : "\u{00F1}",
        "&ograve;"   : "\u{00F2}",
        "&oacute;"   : "\u{00F3}",
        "&ocirc;"    : "\u{00F4}",
        "&otilde;"   : "\u{00F5}",
        "&ouml;"     : "\u{00F6}",
        "&divide;"   : "\u{00F7}",
        "&oslash;"   : "\u{00F8}",
        "&ugrave;"   : "\u{00F9}",
        "&uacute;"   : "\u{00FA}",
        "&ucirc;"    : "\u{00FB}",
        "&uuml;"     : "\u{00FC}",
        "&yacute;"   : "\u{00FD}",
        "&thorn;"    : "\u{00FE}",
        "&yuml;"     : "\u{00FF}",
        "&OElig;"    : "\u{0152}",
        "&oelig;"    : "\u{0153}",
        "&Scaron;"   : "\u{0160}",
        "&scaron;"   : "\u{0161}",
        "&Yuml;"     : "\u{0178}",
        "&fnof;"     : "\u{0192}",
        "&circ;"     : "\u{02C6}",
        "&tilde;"    : "\u{02DC}",
        "&Alpha;"    : "\u{0391}",
        "&Beta;"     : "\u{0392}",
        "&Gamma;"    : "\u{0393}",
        "&Delta;"    : "\u{0394}",
        "&Epsilon;"  : "\u{0395}",
        "&Zeta;"     : "\u{0396}",
        "&Eta;"      : "\u{0397}",
        "&Theta;"    : "\u{0398}",
        "&Iota;"     : "\u{0399}",
        "&Kappa;"    : "\u{039A}",
        "&Lambda;"   : "\u{039B}",
        "&Mu;"       : "\u{039C}",
        "&Nu;"       : "\u{039D}",
        "&Xi;"       : "\u{039E}",
        "&Omicron;"  : "\u{039F}",
        "&Pi;"       : "\u{03A0}",
        "&Rho;"      : "\u{03A1}",
        "&Sigma;"    : "\u{03A3}",
        "&Tau;"      : "\u{03A4}",
        "&Upsilon;"  : "\u{03A5}",
        "&Phi;"      : "\u{03A6}",
        "&Chi;"      : "\u{03A7}",
        "&Psi;"      : "\u{03A8}",
        "&Omega;"    : "\u{03A9}",
        "&alpha;"    : "\u{03B1}",
        "&beta;"     : "\u{03B2}",
        "&gamma;"    : "\u{03B3}",
        "&delta;"    : "\u{03B4}",
        "&epsilon;"  : "\u{03B5}",
        "&zeta;"     : "\u{03B6}",
        "&eta;"      : "\u{03B7}",
        "&theta;"    : "\u{03B8}",
        "&iota;"     : "\u{03B9}",
        "&kappa;"    : "\u{03BA}",
        "&lambda;"   : "\u{03BB}",
        "&mu;"       : "\u{03BC}",
        "&nu;"       : "\u{03BD}",
        "&xi;"       : "\u{03BE}",
        "&omicron;"  : "\u{03BF}",
        "&pi;"       : "\u{03C0}",
        "&rho;"      : "\u{03C1}",
        "&sigmaf;"   : "\u{03C2}",
        "&sigma;"    : "\u{03C3}",
        "&tau;"      : "\u{03C4}",
        "&upsilon;"  : "\u{03C5}",
        "&phi;"      : "\u{03C6}",
        "&chi;"      : "\u{03C7}",
        "&psi;"      : "\u{03C8}",
        "&omega;"    : "\u{03C9}",
        "&thetasym;" : "\u{03D1}",
        "&upsih;"    : "\u{03D2}",
        "&piv;"      : "\u{03D6}",
        "&ensp;"     : "\u{2002}",
        "&emsp;"     : "\u{2003}",
        "&thinsp;"   : "\u{2009}",
        "&zwnj;"     : "\u{200C}",
        "&zwj;"      : "\u{200D}",
        "&lrm;"      : "\u{200E}",
        "&rlm;"      : "\u{200F}",
        "&ndash;"    : "\u{2013}",
        "&mdash;"    : "\u{2014}",
        "&lsquo;"    : "\u{2018}",
        "&rsquo;"    : "\u{2019}",
        "&sbquo;"    : "\u{201A}",
        "&ldquo;"    : "\u{201C}",
        "&rdquo;"    : "\u{201D}",
        "&bdquo;"    : "\u{201E}",
        "&dagger;"   : "\u{2020}",
        "&Dagger;"   : "\u{2021}",
        "&bull;"     : "\u{2022}",
        "&hellip;"   : "\u{2026}",
        "&permil;"   : "\u{2030}",
        "&prime;"    : "\u{2032}",
        "&Prime;"    : "\u{2033}",
        "&lsaquo;"   : "\u{2039}",
        "&rsaquo;"   : "\u{203A}",
        "&oline;"    : "\u{203E}",
        "&frasl;"    : "\u{2044}",
        "&euro;"     : "\u{20AC}",
        "&image;"    : "\u{2111}",
        "&weierp;"   : "\u{2118}",
        "&real;"     : "\u{211C}",
        "&trade;"    : "\u{2122}",
        "&alefsym;"  : "\u{2135}",
        "&larr;"     : "\u{2190}",
        "&uarr;"     : "\u{2191}",
        "&rarr;"     : "\u{2192}",
        "&darr;"     : "\u{2193}",
        "&harr;"     : "\u{2194}",
        "&crarr;"    : "\u{21B5}",
        "&lArr;"     : "\u{21D0}",
        "&uArr;"     : "\u{21D1}",
        "&rArr;"     : "\u{21D2}",
        "&dArr;"     : "\u{21D3}",
        "&hArr;"     : "\u{21D4}",
        "&forall;"   : "\u{2200}",
        "&part;"     : "\u{2202}",
        "&exist;"    : "\u{2203}",
        "&empty;"    : "\u{2205}",
        "&nabla;"    : "\u{2207}",
        "&isin;"     : "\u{2208}",
        "&notin;"    : "\u{2209}",
        "&ni;"       : "\u{220B}",
        "&prod;"     : "\u{220F}",
        "&sum;"      : "\u{2211}",
        "&minus;"    : "\u{2212}",
        "&lowast;"   : "\u{2217}",
        "&radic;"    : "\u{221A}",
        "&prop;"     : "\u{221D}",
        "&infin;"    : "\u{221E}",
        "&ang;"      : "\u{2220}",
        "&and;"      : "\u{2227}",
        "&or;"       : "\u{2228}",
        "&cap;"      : "\u{2229}",
        "&cup;"      : "\u{222A}",
        "&int;"      : "\u{222B}",
        "&there4;"   : "\u{2234}",
        "&sim;"      : "\u{223C}",
        "&cong;"     : "\u{2245}",
        "&asymp;"    : "\u{2248}",
        "&ne;"       : "\u{2260}",
        "&equiv;"    : "\u{2261}",
        "&le;"       : "\u{2264}",
        "&ge;"       : "\u{2265}",
        "&sub;"      : "\u{2282}",
        "&sup;"      : "\u{2283}",
        "&nsub;"     : "\u{2284}",
        "&sube;"     : "\u{2286}",
        "&supe;"     : "\u{2287}",
        "&oplus;"    : "\u{2295}",
        "&otimes;"   : "\u{2297}",
        "&perp;"     : "\u{22A5}",
        "&sdot;"     : "\u{22C5}",
        "&lceil;"    : "\u{2308}",
        "&rceil;"    : "\u{2309}",
        "&lfloor;"   : "\u{230A}",
        "&rfloor;"   : "\u{230B}",
        "&lang;"     : "\u{2329}",
        "&rang;"     : "\u{232A}",
        "&loz;"      : "\u{25CA}",
        "&spades;"   : "\u{2660}",
        "&clubs;"    : "\u{2663}",
        "&hearts;"   : "\u{2665}",
        "&diams;"    : "\u{2666}",
        ]
    
    // Convert the number in the string to the corresponding
    // Unicode character, e.g.
    //    decodeNumeric("64", 10)   --> "@"
    //    decodeNumeric("20ac", 16) --> "€"
    fileprivate static func decodeNumeric(_ string : String, base : Int32) -> Character? {
        let code = UInt32(strtoul(string, nil, base))
        return Character(UnicodeScalar(code)!)
    }
    
    // Decode the HTML character entity to the corresponding
    // Unicode character, return `nil` for invalid input.
    //     decode("&#64;")    --> "@"
    //     decode("&#x20ac;") --> "€"
    //     decode("&lt;")     --> "<"
    //     decode("&foo;")    --> nil
    fileprivate static func decode(_ entity : String) -> Character? {
        if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
            return decodeNumeric(entity.substring(from: entity.characters.index(entity.startIndex, offsetBy: 3)), base: 16)
        } else if entity.hasPrefix("&#") {
            return decodeNumeric(entity.substring(from: entity.characters.index(entity.startIndex, offsetBy: 2)), base: 10)
        } else {
            return HTMLEntities.characterEntities[entity]
        }
    }
}









