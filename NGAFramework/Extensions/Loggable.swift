//
//  Loggable.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 4/20/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation




//public protocol Loggable {}
//public extension Loggable {
//    public func printToLog() {print(self)}
//}
//extension Optional:Loggable {
//    public func printToLog() {
//        if let v = self {
//            print(v)
//        } else {print(self)}
//    }
//}

public protocol Loggable {}
public extension Loggable {
    public func printToLog() {
        if let s = self as? UnWrappable, let v = s.unwrap() {
            print(v)
        } else {print(self)}
    }
    
}
//extension Optional:Loggable {}
//extension NSObject:Loggable {}
//extension String:Loggable {}


private protocol UnWrappable {
    func unwrap() -> Any?
}
extension Optional:UnWrappable {
    fileprivate func unwrap() -> Any? {
        switch self {
        case .none:
            return nil
        case .some(let v):
            if let v = v as? UnWrappable {
                return v.unwrap()
            } else {return v}
        }
    }
}
