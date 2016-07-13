//
//  UIImageExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIImage {
    
    
    public func captionedImageWith(caption caption:String?) -> UIImage {
        let font = UIFont(name: NGAFontNames.ArialRoundedMTBold, size: 12.0)
        return self.captionedImageWith(caption: caption, andFont: font)
    }
    
    
    
    public func captionedImageWith(caption caption:String?, andFont font:UIFont?) -> UIImage {
        
        return self.captionedImageWith(caption: caption, size: self.size, andFont: font)
    }
    
    public func captionedImageWith(caption caption:String?, size:CGSize, andFont font:UIFont?) -> UIImage {
        return captionedImageWith(caption: caption, textHeightRatio: 0.3, size: size, andFont: font)
    }
    
    
    public func captionedImageWith(caption caption:String?, textHeightRatio:CGFloat, size:CGSize, andFont font:UIFont?) -> UIImage {
        //        println(size)
        func frameForLabel() -> CGRect {
            var temp = CGRectZero
            temp.origin.y = size.height
            temp.size = UIView.sizeFromSize(size, withXRatio: 1.0, andYRatio: textHeightRatio)
            
            return temp
        }
        
        let label = UILabel(frame: frameForLabel())
        label.text = caption
        label.textAlignment = NSTextAlignment.Center
        let textFont = font ?? UIFont(name: NGAFontNames.ArialRoundedMTBold, size: 12.0)
        label.font = textFont?.fitFontToSize(label.frame.size, forString: caption)
        
        var imageFrame = CGRectZero
        imageFrame.size = size
        //        println("image frame = \(imageFrame)")
        var totalFrame = imageFrame
        totalFrame.size.height = totalFrame.size.height + label.frame.size.height
        //        println("total frame = \(totalFrame)")
        
        UIGraphicsBeginImageContext(label.frame.size)
        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let labelImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(totalFrame.size)
        self.drawInRect(imageFrame)
        labelImage.drawInRect(label.frame)
        let captionedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return captionedImage
    }
    
    
    public func roundedImage(radius:CGFloat? = nil) -> UIImage {
        let smallSide = size.height > size.width ? size.width : size.height
        let r = radius ?? smallSide / 30
        var temp = self
        let imageView = UIImageView(image: self)
        imageView.sizeToFit()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = r
        UIGraphicsBeginImageContext(imageView.frameSize)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return temp
    }
    
    
    /// maxSize is the max pixel count for any side
    public func compressTo(maxSize:CGFloat) -> UIImage {
        let largeSide = size.height > size.width ? size.height : size.width
        if largeSide > maxSize
        {
            let imageScale = maxSize / largeSide
            let newSize = CGSizeMake(size.width * imageScale, size.height * imageScale)
            UIGraphicsBeginImageContext(newSize)
            drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        else {
            return self
        }
    }
    
    public var aspectRatioWToH:CGFloat {get {return size.aspectRatioWToH}}
    public var aspectRatioHtoW:CGFloat {get {return size.aspectRatioHtoW}}
    
    public func toJPEGData(quality:CGFloat = 1.0) -> NSData? {
        return UIImageJPEGRepresentation(self, quality)
    }
    
    public func toPNGData() -> NSData? {
        return UIImagePNGRepresentation(self)
    }
    
    
}

public extension UIImageView {
    public func sizeToFitImage(s:CGSize? = nil) -> CGSize {
        var s = s ?? frameSize;let imageSize = image?.size ?? CGSizeZero
        guard !imageSize.aSideIsZero() else {return CGSizeZero}
        if imageSize.aspectRatioWToH > s.aspectRatioWToH {
            s.height = s.width * imageSize.aspectRatioHtoW
        } else {
            s.width = s.height * imageSize.aspectRatioWToH
        }
        return s
    }
}





