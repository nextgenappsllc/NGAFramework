//
//  UIViewControllerExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 4/6/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var window:UIWindow? {
        get {
            guard view != nil else {return nil}
            return view.window
        }
    }
    var topSuperview:UIView? {
        get {
            guard view != nil else {return nil}
            return view.topView
        }
    }
}
