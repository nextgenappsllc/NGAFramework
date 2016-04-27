//
//  NGAContainerViews.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 9/15/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

public class NGAContainerView: NGAView {
    public var viewToSize:UIView? {
        didSet{
            if viewToSize != oldValue{
                if oldValue?.isDirectDescendantOf(self) ?? false {oldValue?.removeFromSuperview()}
                setFramesForSubviewsOnMainThread()
            }
        }
    }
    public var circular:Bool = false {didSet{if autoUpdateFrames && circular != oldValue{ setFramesForSubviewsOnMainThread()}}}
    public var containerXOffset:CGFloat = 0 {didSet{if containerXOffset > 1{containerXOffset = 1}else if containerXOffset < -1 {containerXOffset = -1}; if autoUpdateFrames && containerXOffset != oldValue {setFramesForSubviewsOnMainThread()}}}
    public var containerYOffset:CGFloat = 0 {didSet{if containerYOffset > 1{containerYOffset = 1}else if containerYOffset < -1 {containerYOffset = -1}; if autoUpdateFrames && containerYOffset != oldValue {setFramesForSubviewsOnMainThread()}}}
    public var squaredCenterView:Bool = false {didSet{if autoUpdateFrames && squaredCenterView != oldValue{ setFramesForSubviewsOnMainThread()}}}
    
    public var xRatio:CGFloat = 1 {
        didSet{
            if xRatio < 0 {xRatio = 0}
            if autoUpdateFrames && xRatio != oldValue{
                setFramesForSubviewsOnMainThread()
            }
        }
    }
    public var yRatio:CGFloat = 1 {
        didSet{
            if yRatio < 0 {yRatio = 0}
            if autoUpdateFrames && yRatio != oldValue{
                setFramesForSubviewsOnMainThread()
            }
        }
    }
    
    public func setEqualRatio(r:CGFloat) {
        let old = autoUpdateFrames
        autoUpdateFrames = false
        xRatio = r
        yRatio = r
        autoUpdateFrames = old
    }
    
    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        if circular {
            let side = shortSide > 0 ? shortSide : longSide
            if frameWidth != frameHeight {frameSize = side.toEqualSize()}
            viewToSize?.frameSize = sizeForViewInCircularView()
            layer.cornerRadius = side / 2
        }
        else {viewToSize?.setSizeFromView(self, withXRatio: xRatio, andYRatio: yRatio)}
        if let s = viewToSize?.shortSide where squaredCenterView { viewToSize?.frameSize = s.toEqualSize()}
        var xPadding:CGFloat = 0 ; var yPadding:CGFloat = 0
        if let size = viewToSize?.frameSize {
            xPadding = (frameWidth - size.width) * containerXOffset
            yPadding = (frameHeight - size.height) * containerYOffset
        }
        viewToSize?.placeViewInView(view: self, position: .AlignCenterX, andPadding: xPadding)
        viewToSize?.placeViewInView(view: self, position: .AlignCenterY, andPadding: yPadding)
        addSubviewIfNeeded(viewToSize)
    }
    
    public func sizeForViewInCircularView() -> CGSize {
        let s = sideSizeForViewInCircularView(self)
        return CGSizeMake(s * xRatio, s * yRatio)
    }
    
    public func sideSizeForViewInCircularView(v:UIView) -> CGFloat {
        let side = v.shortSide / sqrt(2)
        return side
    }
    
}

public class NGATapView: NGAContainerView {
    public var callBack:VoidBlock?
    public var callBackWithSender:((sender:AnyObject?) -> Void)?
    public var tapRecognizer:UITapGestureRecognizer? {didSet{addTapGestureRecognizer(tapRecognizer, old: oldValue, toSelf: recognizeTapOnWholeContainer)}}
    public var recognizeTapOnWholeContainer:Bool = true {didSet{addTapGestureRecognizer(tapRecognizer, old: tapRecognizer, toSelf: recognizeTapOnWholeContainer)}}
    
    public override var viewToSize:UIView? {
        didSet{
            if let t = tapRecognizer {oldValue?.removeGestureRecognizer(t)}
            if !recognizeTapOnWholeContainer{addTapGestureRecognizer(tapRecognizer, old: tapRecognizer, toSelf: recognizeTapOnWholeContainer)}
        }
    }
    
    public override func postInit() {
        super.postInit()
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped(_:)))
        addTapGestureRecognizer(tapRecognizer, old: nil, toSelf: recognizeTapOnWholeContainer)
    }
    
    public func addTapGestureRecognizer(new:UITapGestureRecognizer?, old:UITapGestureRecognizer?, toSelf b:Bool) {
        if let o = old {viewToSize?.removeGestureRecognizer(o); removeGestureRecognizer(o)}
        if let n = new {if b{addGestureRecognizer(n)}else {viewToSize?.addGestureRecognizer(n); viewToSize?.userInteractionEnabled = true}}
    }
    
    
    public func userTapped(sender:AnyObject?) {
        //        print("tapped")
        callBack?()
        callBackWithSender?(sender: self)
    }
}



public class NGATapLabelView: NGATapView {
    
    public let label = UILabel()
    public var text:String? {get{return label.text}set{label.text = newValue; setFramesForSubviewsOnMainThread()}}
    public var attributedText:NSAttributedString? {get{return label.attributedText}set{label.attributedText = newValue; setFramesForSubviewsOnMainThread()}}
    public var textColor:UIColor? {get{return label.textColor}set{label.textColor = newValue}}
    public var font:UIFont? {get{return label.font}set{if label.font != newValue {label.font = newValue; setFramesForSubviewsOnMainThread()}}}
    public var textAlignment:NSTextAlignment {get{return label.textAlignment}set{label.textAlignment = newValue}}
    public var fitFontToLabel:Bool = true
    public var constrainFontToLabel = false
    
    public override func postInit() {
        super.postInit()
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.backgroundColor = UIColor.clearColor()
        viewToSize = label
    }
    
    public override func setFramesForSubviews() {
        super.setFramesForSubviews()
        guard frameHeight > 0 && frameWidth > 0 else {return}
        if fitFontToLabel {font = font?.fitFontToSize(label.frameSize, forString: label.text)}
//        else if constrainFontToLabel {
//            let s = UILabel.sizeToFitLabel(label)
//            guard s.height > label.frameHeight || s.width > label.frameWidth else {return}
//            font = font?.fitFontToSize(label.frameSize, forString: label.text)
//        }
    }
    
    
}



public class NGATapImageView: NGATapView {
    public let imageView = UIImageView()
    public var image:UIImage? {get{return imageView.image}set{imageView.image = alwaysTemplate ? newValue?.imageWithRenderingMode(.AlwaysTemplate) : newValue}}
    public var imageTintColor:UIColor? {get{return imageView.tintColor}set{imageView.tintColor = newValue}}
    public var imageContentMode:UIViewContentMode {get{return imageView.contentMode} set{imageView.contentMode = newValue}}
    public var alwaysTemplate:Bool = true {didSet{if alwaysTemplate != oldValue {imageView.image = imageView.image}}}
    
    public override func postInit() {
        super.postInit()
        imageView.backgroundColor = UIColor.clearColor()
        imageView.userInteractionEnabled = true
        imageView.contentMode = .ScaleAspectFit
        imageTintColor = UIColor.blackColor()
        viewToSize = imageView
    }
    
}





