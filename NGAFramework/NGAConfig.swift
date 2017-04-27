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





// Queue Wrapper

open class QueueWrapper {
    
    open let queue:DispatchQueue
    
    open let queueKey:DispatchSpecificKey<Any> = DispatchSpecificKey<Any>()
    
    public init(_ queue:DispatchQueue){
        self.queue = queue
    }
    
    public convenience init(label:String, qos:DispatchQoS, attributes:DispatchQueue.Attributes, autoreleaseFrequency:DispatchQueue.AutoreleaseFrequency, target:DispatchQueue?){
        self.init(DispatchQueue(label: label, qos: qos, attributes: attributes, autoreleaseFrequency: autoreleaseFrequency, target: target))
    }
    
    public convenience init(label:String){
        self.init(DispatchQueue(label: label))
    }
    
    public convenience init(){
        self.init(DispatchQueue(label: ""))
    }
    
    
    public func registerQueue(){
        queue.setSpecific(key: queueKey, value: ())
    }
    
    
    open func performOnQueue(async:Bool = true, _ b:VoidBlock?) {
        guard let b = b else {return}
        isQueue ? b() : queueExecute(async: async, b)
    }
    
    
    open var isQueue:Bool {get {return DispatchQueue.getSpecific(key: queueKey) != nil}}
    
    open func queueExecute(async:Bool = true, _ b:@escaping VoidBlock) {
        async ? queue.async(execute: b) : queue.sync(execute: b)
    }
    
    
    
}





//MARK: Thread handler

open class NGAExecute {
    
    static let queueWrapper = QueueWrapper(DispatchQueue.main)
    
    open static func performOnMainQueue(async:Bool = true, _ b:VoidBlock?) {queueWrapper.performOnQueue(async: async, b)}
    
    open static var isMainQueue:Bool {get {return queueWrapper.isQueue}}
    
    open static func performOnMainThread(async:Bool = true, _ b:VoidBlock?) {
        guard let b = b else {return}
        Thread.isMainThread ? b() : queueWrapper.queueExecute(async: async, b)
    }
    
}



//open class NGAExecute {
//    
//    static var mainQueue:DispatchQueue {get{return DispatchQueue.main}}
//    
//    open static let mainQueueKey = DispatchSpecificKey<Any>()
//    
//    static var mainQueueRegistered = false
//    
//    open class func performOnMainThread(async:Bool = true, _ b:VoidBlock?) {
//        guard let b = b else {return}
//        Thread.isMainThread ? b() : mainQueueExecute(async: async, b)
//    }
//    
//    open class func performOnMainQueue(async:Bool = true, _ b:VoidBlock?) {
//        guard let b = b else {return}
//        isMainQueue ? b() : mainQueueExecute(async: async, b)
//    }
//    
//    open class func registerMainQueue(){
//        mainQueue.setSpecific(key: mainQueueKey, value: ())
//        mainQueueRegistered = true
//    }
//    
//    open static var isMainQueue:Bool {
//        get {
//            if !mainQueueRegistered {registerMainQueue()}
//            return DispatchQueue.getSpecific(key: mainQueueKey) != nil
//        }
//    }
//    
//    open class func mainQueueExecute(async:Bool = true, _ b:@escaping VoidBlock) {
//        async ? mainQueue.async(execute: b) : mainQueue.sync(execute: b)
//    }
//}






