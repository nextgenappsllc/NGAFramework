//
//  UIScrollViewExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

extension UIScrollView {
    // calculates the offsets at the end of the content
    var bottomOffsetY:CGFloat {get{
        var temp = contentSize.height - frameHeight; if temp < 0 {temp = 0}
        return temp
        }}
    var rightOffsetX:CGFloat {get{
        var temp = contentSize.width - frameWidth; if temp < 0 {temp = 0}
        return temp
        }}
    // sees if scroll is past threshold amount
    func isAboveContentByMoreThan(_ y:CGFloat) -> Bool {
        return contentOffset.y < -y
    }
    func isBelowContentByMoreThan(_ y:CGFloat) -> Bool {
        return contentOffset.y > y + bottomOffsetY
    }
    func isLeftOfContentByMoreThan(_ x:CGFloat) -> Bool {
        return contentOffset.x < -x
    }
    func isRightOfContentByMoreThan(_ x:CGFloat) -> Bool {
        return contentOffset.x > x + rightOffsetX
    }
    // sees if scroll is past threshold ratio
    func isAboveContentByMoreThanRatio(_ yRatio:CGFloat) -> Bool {
        return isAboveContentByMoreThan(frameHeight * yRatio)
    }
    func isBelowContentByMoreThanRatio(_ yRatio:CGFloat) -> Bool {
        return isBelowContentByMoreThan(frameHeight * yRatio)
    }
    func isLeftOfContentByMoreRatio(_ xRatio:CGFloat) -> Bool {
        return isLeftOfContentByMoreThan(frameWidth * xRatio)
    }
    func isRightOfContentByMoreThanRatio(_ xRatio:CGFloat) -> Bool {
        return isRightOfContentByMoreThan(frameWidth * xRatio)
    }
    
    func fitContentSizeHeightToBottom() {
        contentSize.height = lowestSubviewBottom()
    }
    
    
    
    
    
}
