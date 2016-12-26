//
//  Operators.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

infix operator =? : AssignAs
precedencegroup AssignAs {
    associativity: left
    lowerThan: AssignmentPrecedence
}
public func =?<T,U>(left:inout T?, right:U?) {
    left = right as? T
}
public func =?<T,U>(left:inout T, right:U?) {
    if let v = right as? T {
        left = v
    }
}

infix operator ?= : AssignIfNil
precedencegroup AssignIfNil {
    associativity: left
    lowerThan: AssignmentPrecedence
}
public func ?=<T,U>(left:inout T?, right:U?) {
    if left == nil {left = right as? T}
}

infix operator ||= : AssignResultIfNil
precedencegroup AssignResultIfNil {
    associativity: left
    lowerThan: AssignmentPrecedence
}
public func ||=<T,U>(left:inout T?, right:@autoclosure () -> U) {
    if left == nil {left = right() as? T}
}
