//
//  UIViewExtension.swift
//  NGAFramework
//
//  Created by Jose Castellanos on 3/13/16.
//  Copyright © 2016 NextGen Apps LLC. All rights reserved.
//

import Foundation

public extension UIView {
    
    //// adding subviews make the last one appear on top of the previous so these methods do not re add thus preserving the order
    public func addSubviewIfNeeded(_ subview:UIView?) {
        //// changed to direct descendant
        if subview != nil && !subview!.isDirectDescendantOf(self) {addSubview(subview!)}
    }
    //// same as above but can add many
    public func addSubviewsIfNeeded(_ subviews:UIView?...) {
        for subview in subviews {addSubviewIfNeeded(subview)}
    }
    
    //// considering deprecating
    func centerInView(_ view:UIView) {
        self.frame = self.centeredFrameInBounds(view.bounds)
    }
    //// considering deprecating
    func centeredFrameInBounds(_ superBounds:CGRect) -> CGRect {
        var temp = self.frame
        temp.origin.x = (superBounds.size.width - temp.size.width) / 2
        temp.origin.y = (superBounds.size.height - temp.size.height) / 2
        
        return temp
    }
    
    public func setSizeFromView(_ view:UIView, withXRatio xRatio:CGFloat, andYRatio yRatio:CGFloat) {
        var newFrame = self.frame
        newFrame.size = UIView.sizeFromSize(view.frame.size, withXRatio: xRatio, andYRatio: yRatio)
        self.frame = newFrame
    }
    
    public func setWidthFromView(_ view:UIView, withXRatio xRatio:CGFloat) {
        var newFrame = self.frame
        newFrame.size.width = view.frame.size.width * xRatio
        self.frame = newFrame
    }
    
    public func setHeightFromView(_ view:UIView, withYRatio yRatio:CGFloat) {
        var newFrame = self.frame
        newFrame.size.height = view.frame.size.height * yRatio
        self.frame = newFrame
    }
    
    public class func sizeFromSize(_ superSize:CGSize, withXRatio xRatio:CGFloat, andYRatio yRatio:CGFloat) -> CGSize {
        return CGSize(width: superSize.width * xRatio, height: superSize.height * yRatio)
    }
    
    //// considering deprecating
    func applyInsetsToFrame(xInset:CGFloat, andYInset yInset:CGFloat, shouldApplyToAllSides:Bool) {
        let multiplier:CGFloat = shouldApplyToAllSides ? 2 : 1
        self.changeFrameOrigin(dX: xInset, dY: yInset)
        self.changeFrameSize(dWidth: -xInset * multiplier, dHeight: -yInset * multiplier)
    }
    
    //// the two following functions advance their property by the values inputed
    public func changeFrameOrigin(dX:CGFloat, dY:CGFloat) {
        var temp = self.frame
        temp.origin.x = temp.origin.x + dX
        temp.origin.y = temp.origin.y + dY
        self.frame = temp
    }
    
    public func changeFrameSize(dWidth:CGFloat, dHeight:CGFloat) {
        var temp = self.frame
        temp.size.width  = temp.size.width + dWidth
        temp.size.height  = temp.size.height  + dHeight
        self.frame = temp
    }
    
    //// editing a views frame directly like view.frame.size.height = 20 is not allowed and is tedious so the following methods a for convenience making the previous example view.frameHeight = 20
    public var frameOrigin:CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var temp = self.frame
            temp.origin  = newValue
            self.frame = temp
        }
    }
    public var frameSize:CGSize {
        get {
            return self.frame.size
        }
        set {
            var temp = self.frame
            temp.size  = newValue
            self.frame = temp
        }
    }
    public var frameHeight:CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var temp = self.frame
            temp.size.height  = newValue
            self.frame = temp
        }
    }
    public var frameWidth:CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var temp = self.frame
            temp.size.width  = newValue
            self.frame = temp
        }
    }
    public var frameOriginY:CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
    }
    public var frameOriginX:CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var temp = self.frame
            temp.origin.x  = newValue
            self.frame = temp
        }
    }
    
    //// Top and Left just set position and are equivalent to the short hand above
    public var top:CGFloat {
        get {return frameOriginY}
        set {frameOriginY = newValue}
    }
    public var left:CGFloat {
        get {return frameOriginX}
        set {frameOriginX = newValue}
    }
    //// Bottom and Right adjusts the size to make the bottom or right equal the value so a view with view.top = 10 and view.bottom = 30 will have a y orgigin of 10 and a height of 20
    public var bottom:CGFloat {
        get {return frameOriginY + frameHeight}
        set {frameHeight = newValue - frameOriginY}
    }
    public var right:CGFloat {
        get {return frameOriginX + frameWidth}
        set {frameWidth = newValue - frameOriginX}
    }
    
    public func placeViewInView(view:UIView, andPosition position:NGARelativeViewPosition) {
        self.placeViewInView(view: view, position: position, andPadding: 0)
    }
    public func placeViewAccordingToView(view:UIView, andPosition position:NGARelativeViewPosition) {
        self.placeViewAccordingToView(view: view, position: position, andPadding: 0)
    }
    public func placeViewInView(view:UIView, position:NGARelativeViewPosition, andPadding padding:CGFloat) {
        let otherViewFrame = view.bounds
        placeViewRelativeToRect(rect: otherViewFrame, position: position, andPadding: padding)
    }
    public func placeViewAccordingToView(view:UIView, position:NGARelativeViewPosition, andPadding padding:CGFloat) {
        let otherViewFrame = view.frame
        placeViewRelativeToRect(rect: otherViewFrame, position: position, andPadding: padding)
    }
    public func placeViewRelativeToRect(rect:CGRect, position:NGARelativeViewPosition, andPadding padding:CGFloat) {
        self.frame = self.rectForViewRelativeToRect(rect: rect, position: position, andPadding: padding)
    }
    func rectForViewInView(view:UIView, position:NGARelativeViewPosition, andPadding padding:CGFloat) -> CGRect{
        let otherViewFrame = view.bounds
        return self.rectForViewRelativeToRect(rect: otherViewFrame, position: position, andPadding: padding)
    }
    public func rectForViewAccordingToView(view:UIView, position:NGARelativeViewPosition, andPadding padding:CGFloat) -> CGRect{
        
        let otherViewFrame = view.frame
        return self.rectForViewRelativeToRect(rect: otherViewFrame, position: position, andPadding: padding)
    }
    public func rectForViewRelativeToRect(rect:CGRect, position:NGARelativeViewPosition, andPadding padding:CGFloat) -> CGRect {
        var thisViewFrame = self.frame
        
        switch position {
            
        case NGARelativeViewPosition.aboveTop:
            thisViewFrame.origin.y = rect.origin.y - thisViewFrame.size.height - padding
            
        case NGARelativeViewPosition.belowBottom:
            thisViewFrame.origin.y = rect.origin.y + rect.size.height + padding
            
        case NGARelativeViewPosition.toTheLeft:
            thisViewFrame.origin.x = rect.origin.x - thisViewFrame.size.width - padding
            
        case NGARelativeViewPosition.toTheRight:
            thisViewFrame.origin.x = rect.origin.x + rect.size.width + padding
            
        case NGARelativeViewPosition.alignTop:
            thisViewFrame.origin.y = rect.origin.y + padding
            
        case NGARelativeViewPosition.alignBottom:
            thisViewFrame.origin.y = rect.origin.y + rect.size.height - thisViewFrame.size.height + padding
            
        case NGARelativeViewPosition.alignRight:
            thisViewFrame.origin.x = rect.origin.x + rect.size.width - thisViewFrame.size.width + padding
            
        case NGARelativeViewPosition.alignLeft:
            thisViewFrame.origin.x = rect.origin.x + padding
            
        case NGARelativeViewPosition.alignCenter, NGARelativeViewPosition.alignCenterY, NGARelativeViewPosition.alignCenterX:
            
            let center = (NGARelativeViewPosition.alignCenter == position)
            let centerX = (NGARelativeViewPosition.alignCenterX == position)
            let centerY = (NGARelativeViewPosition.alignCenterY == position)
            
            if center || centerX {
                thisViewFrame.origin.x = rect.origin.x + (rect.size.width - thisViewFrame.size.width) / 2 + padding
            }
            if center || centerY {
                thisViewFrame.origin.y = rect.origin.y + (rect.size.height - thisViewFrame.size.height) / 2 + padding
            }
            
        }
        return thisViewFrame
        
    }
    
    
    
    public var longSide:CGFloat {
        get {
            var temp:CGFloat = 0
            if self.frame.size.height > self.frame.size.width {
                temp = self.frame.size.height
            }
            else  {
                temp = self.frame.size.width
            }
            
            return temp
        }
        set {
            if frame.size.height > frame.size.width {
                frame.size.height = newValue
            }
            else if frame.size.width > frame.size.height {
                frame.size.width = newValue
            }
            else {
                frame.size.height = newValue
                frame.size.width = newValue
            }
        }
    }
    
    public var shortSide:CGFloat {
        get {
            var temp:CGFloat = 0
            if self.frame.size.height > self.frame.size.width {
                temp = self.frame.size.width
            }
            else  {
                temp = self.frame.size.height
            }
            
            return temp
        }
        set {
            if frame.size.height > frame.size.width {
                frame.size.width = newValue
            }
            else if frame.size.width > frame.size.height {
                frame.size.height = newValue
            }
            else {
                frame.size.height = newValue
                frame.size.width = newValue
            }
        }
    }
    
    public func shiftRight(_ to:CGFloat) {left = to - frameWidth}
    public func shiftBottom(_ to:CGFloat) {top = to - frameHeight}
    
    public var aspectRatioWToH:CGFloat {get {return frame.size.aspectRatioWToH}}
    public var aspectRatioHtoW:CGFloat {get {return frame.size.aspectRatioHtoW}}
    
    public func fitViewInCiricleWithRadius(_ radius:CGFloat, xInset:CGFloat = 0, yInset:CGFloat = 0) {
        frame.fitRectInCiricleWithRadius(radius, xInset: xInset, yInset: yInset)
    }
    
    public var topView:UIView? {
        get{
            var v = superview
            while v != nil {
                let s = v?.superview
                if s.isNil || s is UIWindow {return v}
                v = s
            }
            return v
        }
    }
    
    
    public func isDirectDescendantOf(_ view:UIView) -> Bool {
        return view.subviews.contains(self)
    }
    
    public func lowestSubviewBottom() -> CGFloat {
        return subviews.collect(initialValue: 0, iteratorBlock: { (t, v) -> CGFloat in
            let b = v.alpha == 0 ? t : v.bottom
            return b > t ? b : t
        })
    }
    
    //MARK: Layer
    public var borderColor:UIColor? {get{if let temp = layer.borderColor{return UIColor(cgColor: temp)};return nil}set{layer.borderColor = newValue?.cgColor}}
    public var borderWidth:CGFloat {get{return layer.borderWidth}set{layer.borderWidth = newValue}}
    
    public func addBorderWith(width:CGFloat?, color:UIColor?) {
        let w = width ?? 0
        borderWidth = w
        borderColor = color
    }
    
    public func removeBorder() {
        addBorderWith(width: 0, color: UIColor.clear)
    }
    
    public var cornerRadius:CGFloat {get{return layer.cornerRadius}set{layer.cornerRadius = newValue}}
    
    public var shadowRadius:CGFloat {get{return layer.shadowRadius}set{layer.shadowRadius = newValue}}
    public var shadowOffset:CGSize {get{return layer.shadowOffset}set{layer.shadowOffset = newValue}}
    public var shadowOpacity:CGFloat {get{return CGFloat(layer.shadowOpacity)}set{layer.shadowOpacity = Float(newValue)}}
    public var shadowColor:UIColor? {get{if let temp = layer.shadowColor{return UIColor(cgColor: temp)};return nil}set{layer.shadowColor = newValue?.cgColor}}
    public var shadowPath:UIBezierPath? {get{if let temp = layer.shadowPath{return UIBezierPath(cgPath: temp)};return nil}set{layer.shadowPath = newValue?.cgPath}}
    
    public var roundedRectPath:UIBezierPath {get{return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)}}
    
    public func addShadowWith(radius:CGFloat?, offset:CGSize?, opacity:CGFloat?, color:UIColor?, path:UIBezierPath?) {
        let r = radius ?? 0 ; let off = offset ?? CGSize.zero ; let a = opacity ?? 0
        shadowPath = path
        shadowRadius = r
        shadowOpacity = a
        
        if self is UILabel {
            layer.shadowColor = color?.cgColor ?? UIColor.clear.cgColor
            layer.shadowOffset = off
        } else {
            shadowColor = color
            shadowOffset = off
        }
    }
    
    public func removeShadow() {
        addShadowWith(radius: 0, offset: nil, opacity: 0, color: UIColor.clear, path: nil)
    }
    
    
    
    //MARK: Conversions
    public func toImage(_ size:CGSize? = nil) -> UIImage? {
        var temp:UIImage?
        let s = size ?? bounds.size
        autoreleasepool {
            UIGraphicsBeginImageContext(s)
            if let c = UIGraphicsGetCurrentContext() {
                layer.draw(in: c)
                temp = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }        
        return temp
    }
    
    public func toPDF() -> Data? {
        let data = NSMutableData()
        //// default 8 1/2 x 11 is 612 x 792 and setting to CGRectZero will set it to default
        UIGraphicsBeginPDFContextToData(data, bounds, nil)
        UIGraphicsBeginPDFPage()
        if let c = UIGraphicsGetCurrentContext() { layer.render(in: c) }
        UIGraphicsEndPDFContext()
        return data.copy() as? Data
    }
    
    public func toSquare(_ useSmallSide:Bool = true) {
        let s = useSmallSide ? shortSide : longSide
        frameSize = CGSize(width: s, height: s)
    }
    public func toCircle(_ useSmallSide:Bool = true) {
        toSquare(useSmallSide)
        cornerRadius = frameWidth / 2
    }
    
    public func setSizeWithWidth(_ w:CGFloat, aspectRatioHToW:CGFloat) {
        frameSize = CGSize.makeFromWidth(w, aspectRatioHToW: aspectRatioHToW)
    }
    
    public func setSizeWithHeight(_ h:CGFloat, aspectRatioWToH:CGFloat) {
        frameSize = CGSize.makeFromWidth(h, aspectRatioHToW: aspectRatioWToH)
    }
    
}

//// Going to encapsulate the enum in the UIView extension to something along the lines of Position so instead of NGARelativeViewPosition it would be UIView.Position
public enum NGARelativeViewPosition {
    case aboveTop, belowBottom, toTheLeft, toTheRight, alignTop, alignBottom, alignRight, alignLeft, alignCenter, alignCenterX, alignCenterY
    
}
