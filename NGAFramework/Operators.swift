//
//  Operators.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

//// Equals as
infix operator =? {associativity left}

public func =?<T,U>(inout left:T?, right:U?) {
    left = right as? T
}

public func =?<T,U>(inout left:T, right:U?) {
    if let v = right as? T {
        left = v
    }
}


//// assign if nil
infix operator ?= {associativity left}

public func ?=<T,U>(inout left:T?, right:U?) {
    if left == nil {left = right as? T}
}

infix operator ||= {associativity left}

public func ||=<T,U>(inout left:T?, @autoclosure right:() -> U) {
    if left == nil {left = right() as? T}
}