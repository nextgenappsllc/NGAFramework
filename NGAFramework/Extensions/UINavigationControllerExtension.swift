//
//  UINavigationControllerExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation
//import UIKit

public extension UINavigationController {
    
    //// translucenct property messes with scrollview insets so I found myself turning off that property so made a convenience method
    public convenience init(translucent:Bool) {
        self.init()
        self.navigationBar.isTranslucent = translucent
    }
    
    public convenience init(rootViewController:UIViewController, andTranslucent translucent:Bool) {
        self.init(rootViewController:rootViewController)
        self.navigationBar.isTranslucent = translucent
        
    }
    
    
}

