//
//  NGAExtensions.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 2/17/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit
//import Darwin
import MapKit
//import CryptoSwift




open class TimerExecutor {
    open var block:((Timer?) -> Void)?
    open var timer:Timer?
    @objc open func executeBlock() {
        block?(timer)
    }
    public init() {}
}




public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return lhs.latitude == rhs.latitude && rhs.longitude == lhs.longitude
}
extension CLLocationCoordinate2D : Equatable {}

// Deprecate
//extension NSArray {
//    func arrayWithObjectRemoved(_ object:Any?) -> NSArray {
//        var temp = self
//        if let obj = object {
//            if let mut = temp.mutableCopy() as? NSMutableArray {
//                mut.remove(obj)
//                if let array = mut.copy() as? NSArray {
//                    temp = array
//                }
//            }
//        }
//        return temp
//    }
//}






public extension UITextField {
    public var isEmpty:Bool {
        get {
            return text?.trim().isEmpty ?? true
        }
    }
}




















