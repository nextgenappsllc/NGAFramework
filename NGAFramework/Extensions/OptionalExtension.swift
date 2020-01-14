//
//  OptionalExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

extension Optional {
    
    var isNil:Bool {
        get {return self == nil}
    }
    
    var isNotNil:Bool {
        get {return !isNil}
    }
    
    func or(_ nonNilValue:Wrapped) -> Wrapped {
        return self ?? nonNilValue
    }
    
//    func printToLog() {
//        if let s = self {print(s)}
//        else {print(self)}
//    }
    
}






