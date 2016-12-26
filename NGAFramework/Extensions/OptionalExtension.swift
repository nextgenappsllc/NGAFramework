//
//  OptionalExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Optional {
    
    public var isNil:Bool {
        get {return self == nil}
    }
    
    public var isNotNil:Bool {
        get {return !isNil}
    }
    
    public func or(_ nonNilValue:Wrapped) -> Wrapped {
        return self ?? nonNilValue
    }
    
//    public func printToLog() {
//        if let s = self {print(s)}
//        else {print(self)}
//    }
    
}






