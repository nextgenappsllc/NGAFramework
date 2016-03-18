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



struct NGADevice {
    static var currentScreenBounds:CGRect {
        get {
            return UIScreen.mainScreen().bounds
        }
    }
    
    static var portraitScreenBounds:CGRect {
        get {
            return UIScreen.mainScreen().nativeBounds
        }
    }
    
    static var screenLongSide:CGFloat {
        get {
            var temp:CGFloat = 0
            temp = currentScreenBounds.size.height > currentScreenBounds.size.width ? currentScreenBounds.size.height : currentScreenBounds.size.width
            
            return temp
        }
    }
    static var screenShortSide:CGFloat {
        get {
            var temp:CGFloat = 0
            temp = currentScreenBounds.size.height < currentScreenBounds.size.width ? currentScreenBounds.size.height : currentScreenBounds.size.width
            
            return temp
        }
    }
    
    static var windowShortSide:CGFloat {
        get {
            return (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.bounds.shortSide ?? screenShortSide
        }
    }
    
    static var windowLongSide:CGFloat {
        get {
            return (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.bounds.longSide ?? screenLongSide
        }
    }
    
    static var cellularConnected:Bool {
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
    
    static var networkConnected:Bool {
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
    
    static var wifiConnected:Bool {
        var temp = false
        temp = cellularConnected ? false : networkConnected
        return temp
    }
    
    
    static var iPad:Bool {
        get {
            return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
        }
    }
    
    static var iPhone:Bool {
        get {
            return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
        }
    }
    
    static var multitasking:Bool {
        get {
            var temp = false
            if #available(iOS 9.0, *) {
                temp = screenShortSide > windowShortSide
//                if let windowShortSide = (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.bounds.shortSide {
//                    temp = UIScreen.mainScreen().bounds.shortSide > windowShortSide
//                }
            }
            return temp
        }
    }
    

    
}





//MARK: Thread handler

class NGAExecute {
    class func performOnMainThread(b:VoidBlock?) {
        if b == nil {return}
        if NSThread.isMainThread() {
            b?()
        } else {
            dispatch_async(dispatch_get_main_queue(), b!)
        }
    }
}






