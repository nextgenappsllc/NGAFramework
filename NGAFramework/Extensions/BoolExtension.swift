//
//  BoolExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 2/13/17.
//  Copyright © 2017 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension Bool {
    public static let trueValues:Array<AnyHashable> = [true, 1 as Int, 1 as Float, 1 as CGFloat, 1 as Double, 1 as NSNumber, "1", "t", "y", "true", "si", "on", "yes"]
    
    
    public init(hashable:AnyHashable) {
        guard var v = hashable as? String else {
            self = Bool.trueValues.containsElement(hashable)
            return
        }
        v = v.lowercased()
        self = Bool.trueValues.containsElement(v)
    }
    

}
