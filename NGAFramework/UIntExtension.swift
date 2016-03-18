//
//  UIntExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

/// after xcode upgrade the method below no longer works because of distance. Used to in conversion of hex string to color
public extension UInt {
    public init?(_ string: String, radix: UInt) {
        let digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        var result = UInt(0)
        for digit in string.lowercaseString.characters {
            if let range = digits.rangeOfString(String(digit)) {
                let val = UInt(range.count)
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        self = result
    }
}