//
//  UIScrollViewExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIScrollView {
    // calculates the offsets at the end of the content
    public var bottomOffsetY:CGFloat {get{
        var temp = contentSize.height - frameHeight; if temp < 0 {temp = 0}
        return temp
        }}
    public var rightOffsetX:CGFloat {get{
        var temp = contentSize.width - frameWidth; if temp < 0 {temp = 0}
        return temp
        }}
    // sees if scroll is past threshold amount
    public func isAboveContentByMoreThan(_ y:CGFloat) -> Bool {
        return contentOffset.y < -y
    }
    public func isBelowContentByMoreThan(_ y:CGFloat) -> Bool {
        return contentOffset.y > y + bottomOffsetY
    }
    public func isLeftOfContentByMoreThan(_ x:CGFloat) -> Bool {
        return contentOffset.x < -x
    }
    public func isRightOfContentByMoreThan(_ x:CGFloat) -> Bool {
        return contentOffset.x > x + rightOffsetX
    }
    // sees if scroll is past threshold ratio
    public func isAboveContentByMoreThanRatio(_ yRatio:CGFloat) -> Bool {
        return isAboveContentByMoreThan(frameHeight * yRatio)
    }
    public func isBelowContentByMoreThanRatio(_ yRatio:CGFloat) -> Bool {
        return isBelowContentByMoreThan(frameHeight * yRatio)
    }
    public func isLeftOfContentByMoreRatio(_ xRatio:CGFloat) -> Bool {
        return isLeftOfContentByMoreThan(frameWidth * xRatio)
    }
    public func isRightOfContentByMoreThanRatio(_ xRatio:CGFloat) -> Bool {
        return isRightOfContentByMoreThan(frameWidth * xRatio)
    }
    
    public func fitContentSizeHeightToBottom() {
        contentSize.height = lowestSubviewBottom()
    }
    
    
    
    
    
}
