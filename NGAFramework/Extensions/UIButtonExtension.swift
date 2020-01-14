//
//  UIButtonExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/14/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIButton {
    
    public func captionImageWithTitle(_ title:String?) {
        let font = UIFont(name: "ArialRoundedMTBold", size: 12.0)
        self.captionImageWith(title: title, andFont: font)
    }
    
    public func captionImageWith(title:String?, andFont font:UIFont?) {
        var buttonFrame = self.frame
        var totalFrame = buttonFrame
        var newFrame = totalFrame
        
        let captionLabel = self.captionLabelWithTitle(title, andFont: font)
        var captionLabelFrame = captionLabel.frame
        
        //// set context to not nil
        UIGraphicsBeginImageContext(buttonFrame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let buttonImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(captionLabelFrame.size)
        captionLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        let captionImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        buttonFrame.origin = CGPoint.zero
        totalFrame.origin = CGPoint.zero
        captionLabelFrame.origin = CGPoint.zero
        captionLabelFrame.origin.y = totalFrame.size.height
        totalFrame.size.height = totalFrame.size.height + captionLabel.frame.size.height
        
        UIGraphicsBeginImageContext(totalFrame.size)
        buttonImage?.draw(in: buttonFrame)
        captionImage?.draw(in: captionLabelFrame)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setImage(finalImage, for: UIControl.State())
        newFrame.size.height = totalFrame.size.height
        self.frame = newFrame
        
    }
    
    
    public func captionLabelWithTitle(_ title:String?, andFont font:UIFont?) -> UILabel {
        let temp = UILabel()
        temp.text = title
        
        temp.setSizeFromView(self, withXRatio: 1.0, andYRatio: 0.2)
        temp.placeViewAccordingToView(view: self, andPosition: NGARelativeViewPosition.belowBottom)
        temp.placeViewAccordingToView(view: self, andPosition: NGARelativeViewPosition.alignLeft)
        
        //        temp.frame = self.frameForCaptionLabel(temp)
        temp.textAlignment = NSTextAlignment.center
        temp.font = font?.fitFontToSize(temp.frame.size, forString: title)
        
        return temp
    }
    
    public func frameForCaptionLabel(_ label:UILabel) -> CGRect {
        let frame = self.frame
        var temp = frame
        temp.origin.y = frame.origin.y + frame.size.height
        temp.size.height = frame.size.height * 0.2
        
        return temp
    }
    
}
