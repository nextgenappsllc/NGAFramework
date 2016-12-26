//
//  NGASegmentedViewController.swift
//  MCMApp
//
//  Created by Jose Castellanos on 4/20/15.
//  Copyright (c) 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

open class NGASegmentedViewController: NGAViewController {
    
    open weak var titleView:UIView? {
        didSet{
            self.setFramesForSubviews()
        }
    }
    open weak var topView:UIView? {
        didSet{
            self.setFramesForSubviews()
        }
    }
    open weak var bottomView:UIView? {
        didSet{
            self.setFramesForSubviews()
        }
    }
    
    open var segmentXPadding:CGFloat = 10
    open var segmentYPadding:CGFloat = 10
    
    open var titleViewHeightRatio:CGFloat = 0.1
    
    open var topViewYRatio:CGFloat = 0.4 {
        didSet {
            
        }
    }
    open var topViewXRatio:CGFloat = 0.4 {
        didSet {
            
        }
    }
    
//    var bottomViewYRatio:CGFloat = 0.6 {
//        didSet {
//            
//        }
//    }
//    var bottomViewXRatio:CGFloat = 0.6 {
//        didSet {
//            
//        }
//    }
    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        var top = segmentXPadding
        var otherViewsFullRatio:CGFloat = 1.0
        
        if let cTitleView = titleView {
            cTitleView.top = top
            var hRatio = titleViewHeightRatio
            if landscape {
                hRatio += 0.05
            }
            cTitleView.bottom = contentView.frameHeight * hRatio
            cTitleView.left = segmentXPadding
            cTitleView.right = contentView.frameWidth - segmentXPadding
            
            
            otherViewsFullRatio -= titleViewHeightRatio
            top = cTitleView.bottom
            
        }
        
        var topXRatio = bottomView == nil ? 1.0 : topViewXRatio
        var bottomXRatio = topView == nil ? 1.0 : 1.0 - topXRatio
        
        var topYRatio = bottomView == nil ? 1.0 : topViewYRatio
        var bottomYRatio = topView == nil ? 1.0 : 1.0 - topYRatio
        
        func setFrameForView(_ viewToSize:UIView?) {
            
            if let cView = viewToSize {
                
                if landscape {
                    
                    
                    if cView == topView {
                        cView.left = segmentXPadding
                        cView.right = contentView.frameWidth * topXRatio - segmentXPadding
                    }
                    else if cView == bottomView {
                        cView.left = contentView.frameWidth * topXRatio + segmentXPadding
                        cView.right = contentView.frameWidth - segmentXPadding
                        
                    }
                    
                    cView.top = top + segmentYPadding
                    cView.bottom = contentView.frameHeight - segmentYPadding
                    
                }
                else {
                    
                    
                    if cView == topView {
                        cView.top = top + segmentYPadding
                        cView.bottom = contentView.frameHeight * topYRatio - segmentYPadding
                    }
                    else if cView == bottomView {
                        cView.top = contentView.frameHeight * topYRatio + segmentXPadding
                        cView.bottom = contentView.frameHeight - segmentXPadding
                    }
                    
                    cView.left = segmentXPadding
                    cView.right = contentView.frameWidth - segmentXPadding
                    
                }
            }
        }
        
        setFrameForView(topView)
        setFrameForView(bottomView)
        
        
    }
    
    
    
}











