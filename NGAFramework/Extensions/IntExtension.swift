//
//  IntExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 4/5/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Int {
    public func times(_ b:(Int) -> Void) {
        if self < 0 {return}
        for i in 0..<self {
            b(i)
        }
    }
}
