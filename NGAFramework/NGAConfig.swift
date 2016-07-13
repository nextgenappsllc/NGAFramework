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
            return UIScreen.mainScreen().bounds
        }
    }
    
    public static var portraitScreenBounds:CGRect {
        get {
            return UIScreen.mainScreen().nativeBounds
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
            guard let w = UIApplication.sharedApplication().delegate?.window else {return nil}
            return w
        }
    }
    
    public static var statusBarFrame:CGRect {get{return UIApplication.sharedApplication().statusBarFrame}}
    
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
        SCNetworkReachabilityFlags.IsWWAN
        temp = (flags.rawValue & SCNetworkReachabilityFlags.IsWWAN.rawValue) != 0
        
        
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
            return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }
    }
    
    public static var iPhone:Bool {
        get {
            return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
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
    public static func remSizeFor(size:CGSize) -> CGFloat {
        return size.diagonalLength * 0.019
    }
    public static func remSizeFor(view:UIView) -> CGFloat {
        return remSizeFor(view.frameSize)
    }
}





//MARK: Thread handler

public class NGAExecute {
    public class func performOnMainThread(b:VoidBlock?) {
        if b == nil {return}
        if NSThread.isMainThread() {
            b?()
        } else {
            dispatch_async(dispatch_get_main_queue(), b!)
        }
    }
}






