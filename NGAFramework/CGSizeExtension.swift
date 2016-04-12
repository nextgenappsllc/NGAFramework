//
//  CGSizeExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension CGSize {
    
//    public mutating func fitInCircleWithRadius(radius:CGFloat, xInset:CGFloat = 0, yInset:CGFloat = 0) {
//        let wToHRatio = width * height == 0 ? 1 : width / height
//        let hToWRatio = 1 / wToHRatio
//        var w = sqrt((radius * radius) / (1 + (hToWRatio * hToWRatio)))
////        var w = sqrt((2 * radius) / (1 + (hToWRatio * hToWRatio)))
//        w = w > xInset ? w - xInset : 0
//        var h = w * hToWRatio
//        h = h > yInset ? h - yInset : 0
//        let newSize = CGSizeMake(w, h)
//        self = newSize
//    }
    
    public mutating func fitInCircleWithRadius(radius:CGFloat, xInset:CGFloat = 0, yInset:CGFloat = 0) {
//        let wToHRatio = width * height == 0 ? 1 : width / height
//        let hToWRatio = 1 / wToHRatio
        var w = sqrt((radius * radius) / 2)
        w = w > xInset ? w - xInset : 0
        var h = w
        h = h > yInset ? h - yInset : 0
        let newSize = CGSizeMake(w, h)
        self = newSize
    }

    
    public var shortSide:CGFloat {
        get {return width > height ? height : width}
    }
    
    public var longSide:CGFloat {
        get {return width > height ? width : height}
    }
    
    public var aspectRatioWToH:CGFloat {get {return safeDivide(numerator: width, denominator: height)}}
    public var aspectRatioHtoW:CGFloat {get {return safeDivide(numerator: height, denominator: width)}}
    
    
    private func safeDivide(numerator num:CGFloat, denominator den:CGFloat) -> CGFloat {
        if den == 0 { return num == 0 ? 1 : CGFloat.infinity }
        return num / den
    }
    
    public static func squareSizeWithLength(l:CGFloat) -> CGSize{
        return l.toEqualSize()
    }
    
    public static func makeFromHeight(h:CGFloat, aspectRatioWToH:CGFloat) -> CGSize {
        return CGSizeMake(h * aspectRatioWToH, h)
    }
    
    
    public static func makeFromWidth(w:CGFloat, aspectRatioHToW:CGFloat) -> CGSize {
        return CGSizeMake(w, w * aspectRatioHToW)
    }
    
    public static func makeFromHeight(h:CGFloat, aspectRatioHToW:CGFloat) -> CGSize {
        return CGSizeMake(h / aspectRatioHToW, h)
    }
    
    
    public static func makeFromWidth(w:CGFloat, aspectRatioWToH:CGFloat) -> CGSize {
        return CGSizeMake(w, w / aspectRatioWToH)
    }
    
}
