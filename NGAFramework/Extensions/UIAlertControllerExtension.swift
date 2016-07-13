//
//  UIAlertControllerExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIAlertController {
    
    public var messageAlignment:NSTextAlignment? {
        get {
            return messageLabel?.textAlignment
        }
        set {
            if let n = newValue { messageLabel?.textAlignment = n }
        }
    }
    
    
    public var messageLabel:UILabel? {
        get {
            var messageLabel:UILabel? = nil
            var subviews:[UIView]? = view.subviews
            while messageLabel == nil && subviews != nil {
                messageLabel = subviews?.first as? UILabel
                if messageLabel != nil {messageLabel = subviews?.itemAtIndex(1) as? UILabel}
                let subview = subviews?.first
                subviews = subview?.subviews
            }
            return messageLabel
        }
    }
    
    
    public var titleAlignment:NSTextAlignment? {
        get {
            return titleLabel?.textAlignment
        }
        set {
            if let n = newValue { titleLabel?.textAlignment = n }
        }
    }
    
    
    public var titleLabel:UILabel? {
        get {
            var messageLabel:UILabel? = nil
            var subviews:[UIView]? = view.subviews
            while messageLabel == nil && subviews != nil {
                messageLabel = subviews?.first as? UILabel
                //                if messageLabel != nil {messageLabel = subviews?.itemAtIndex(1) as? UILabel}
                let subview = subviews?.first
                subviews = subview?.subviews
            }
            return messageLabel
        }
    }
    
    
    
    
}




