//
//  CGRectExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension CGRect {
    
    // see if this is better than just length / 2
    mutating func fitRectInCiricleWithRadius(radius:CGFloat, xInset:CGFloat = 0, yInset:CGFloat = 0) {
        self.size.fitInCircleWithRadius(radius, xInset:xInset, yInset:yInset)
    }
    
    var shortSide:CGFloat {
        get {return size.shortSide}
    }
    
    var longSide:CGFloat {
        get {return size.longSide}
    }
    
    var aspectRatioWToH:CGFloat {get {return size.aspectRatioWToH}}
    var aspectRatioHtoW:CGFloat {get {return size.aspectRatioHtoW}}
    
    
}