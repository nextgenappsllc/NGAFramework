//
//  NGAConfig.swift
//  MCMApp
//
//  Created by Jose Castellanos on 4/8/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


//public protocol WindowHolder {
//    var window:UIWindow? {get set}
//}

public struct NGADevice {
    public static var currentScreenBounds:CGRect {
        get {
            return UIScreen.main.bounds
        }
    }
    
    public static var portraitScreenBounds:CGRect {
        get {
            return UIScreen.main.nativeBounds
        }
    }
    
    public static var screenLongSide:CGFloat {
        get {
            var temp:CGFloat = 0
            temp = currentScreenBounds.size.height > currentScreenBounds.size.width ? currentScreenBounds.size.height : currentScreenBounds.size.width
            return temp
        }
    }
    public static var screenShortSide:CGFloat {
        get {
            var temp:CGFloat = 0
            temp = currentScreenBounds.size.height < currentScreenBounds.size.width ? currentScreenBounds.size.height : currentScreenBounds.size.width
            
            return temp
        }
    }
    
    public static var window:UIWindow? {
        get{
            guard let w = UIApplication.shared.delegate?.window else {return nil}
            return w
        }
    }
    
    public static var statusBarFrame:CGRect {get{return UIApplication.shared.statusBarFrame}}
    
    public static var windowShortSide:CGFloat {
        get {
            return window?.bounds.shortSide ?? screenShortSide
        }
    }
    
    public static var windowLongSide:CGFloat {
        get {
            return window?.bounds.longSide ?? screenLongSide
        }
    }
    
    public static var cellularConnected:Bool {
        var temp = false
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        let netReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com")
        if netReachability != nil {
            SCNetworkReachabilityGetFlags(netReachability!, &flags)
        }
        temp = (flags.rawValue & SCNetworkReachabilityFlags.isWWAN.rawValue) != 0
        
        
        return temp
    }
    
    public static var networkConnected:Bool {
        var temp = false
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        var retrievedFlags = false
        let netReachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com")
        if netReachability != nil {
            retrievedFlags = SCNetworkReachabilityGetFlags(netReachability!, &flags)
        }
        temp = !(!retrievedFlags || flags.rawValue == 0)
        
        return temp
    }
    
    public static var wifiConnected:Bool {
        var temp = false
        temp = cellularConnected ? false : networkConnected
        return temp
    }
    
    
    public static var iPad:Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
        }
    }
    
    public static var iPhone:Bool {
        get {
            return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        }
    }
    
    public static var multitasking:Bool {
        get {
            guard #available(iOS 9.0, *) else {return false}
            return screenShortSide > windowShortSide
        }
    }
    
    public static var remSize:CGFloat {
        get {
            return remSizeFor(currentScreenBounds.size)
        }
    }
    public static var emSize:CGFloat {
        get{
            guard let window = window else {return remSize}
            return remSizeFor(window.frameSize)
        }
    }
    public static func remSizeFor(_ size:CGSize) -> CGFloat {
        return size.diagonalLength * 0.019
    }
    public static func remSizeFor(_ view:UIView) -> CGFloat {
        return remSizeFor(view.frameSize)
    }
}





//MARK: Thread handler

open class NGAExecute {
    open class func performOnMainThread(_ b:VoidBlock?) {
        if b == nil {return}
        if Thread.isMainThread {
            b?()
        } else {
            DispatchQueue.main.async(execute: b!)
        }
    }
}






