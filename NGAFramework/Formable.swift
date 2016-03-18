//
//  Formable.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/15/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public protocol Formable {
    init()
}
extension Int:Formable {}
extension String:Formable {}
extension Double:Formable {}
extension NSDate:Formable {}
extension Bool:Formable {}



public enum FormItemType:String {
    case String
    case Integer
    case Text
    case Boolean
    case Date
    case Double
    
    
    
    
}


public class FormItem {
    public typealias Getter = () -> Formable?
    public typealias Setter = Formable? -> Void
    public let type:FormItemType
    public var getter:Getter?
    public var setter:Setter?
    public var title:String?
    public var options:SwiftDictionary = [:]
    
    public var value:Formable? {
        get {return getter?()}
        set {setter?(newValue)}
    }
    
    
    public init(type:FormItemType, getter:Getter?, setter:Setter?) {
        self.type = type
        self.getter = getter
        self.setter = setter
    }
    
    
    
}




