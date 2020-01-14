//
//  NGAContainerViews.swift
//  NGAClasses
//
//  Created by Jose Castellanos on 9/15/15.
//  Copyright © 2015 NextGen Apps LLC. All rights reserved.
//

import Foundation
import UIKit

open class NGAContainerView: NGAView {
    open var viewToSize:UIView? {
        didSet{
            if viewToSize != oldValue{
                if oldValue?.isDirectDescendantOf(self) ?? false {oldValue?.removeFromSuperview()}
                setFramesForSubviewsOnMainThread()
            }
        }
    }
    open var circular:Bool = false {didSet{if autoUpdateFrames && circular != oldValue{ setFramesForSubviewsOnMainThread()}}}
    open var containerXOffset:CGFloat = 0 {didSet{if containerXOffset > 1{containerXOffset = 1}else if containerXOffset < -1 {containerXOffset = -1}; if autoUpdateFrames && containerXOffset != oldValue {setFramesForSubviewsOnMainThread()}}}
    open var containerYOffset:CGFloat = 0 {didSet{if containerYOffset > 1{containerYOffset = 1}else if containerYOffset < -1 {containerYOffset = -1}; if autoUpdateFrames && containerYOffset != oldValue {setFramesForSubviewsOnMainThread()}}}
    open var squaredCenterView:Bool = false {didSet{if autoUpdateFrames && squaredCenterView != oldValue{ setFramesForSubviewsOnMainThread()}}}
    
    open var xRatio:CGFloat = 1 {
        didSet{
            if xRatio < 0 {xRatio = 0}
            if autoUpdateFrames && xRatio != oldValue{
                setFramesForSubviewsOnMainThread()
            }
        }
    }
    open var yRatio:CGFloat = 1 {
        didSet{
            if yRatio < 0 {yRatio = 0}
            if autoUpdateFrames && yRatio != oldValue{
                setFramesForSubviewsOnMainThread()
            }
        }
    }
    
    open func setEqualRatio(_ r:CGFloat) {
        let old = autoUpdateFrames
        autoUpdateFrames = false
        xRatio = r
        yRatio = r
        autoUpdateFrames = old
    }
    
    
    open override func setFramesForSubviews() {
        super.setFramesForSubviews()
        if circular {
            let side = shortSide > 0 ? shortSide : longSide
            if frameWidth != frameHeight {frameSize = side.toEqualSize()}
            viewToSize?.frameSize = sizeForViewInCircularView()
            layer.cornerRadius = side / 2
        }
        else {viewToSize?.setSizeFromView(self, withXRatio: xRatio, andYRatio: yRatio)}
        if let s = viewToSize?.shortSide , squaredCenterView { viewToSize?.frameSize = s.toEqualSize()}
        var xPadding:CGFloat = 0 ; var yPadding:CGFloat = 0
        if let size = viewToSize?.frameSize {
            xPadding = (frameWidth - size.width) * containerXOffset
            yPadding = (frameHeight - size.height) * containerYOffset
        }
        viewToSize?.placeViewInView(view: self, position: .alignCenterX, andPadding: xPadding)
        viewToSize?.placeViewInView(view: self, position: .alignCenterY, andPadding: yPadding)
        addSubviewIfNeeded(viewToSize)
    }
    
    open func sizeForViewInCircularView() -> CGSize {
        let s = sideSizeForViewInCircularView(self)
        return CGSize(width: s * xRatio, height: s * yRatio)
    }
    
    open func sideSizeForViewInCircularView(_ v:UIView) -> CGFloat {
        let side = v.shortSide / sqrt(2)
        return side
    }
    
}

open class NGATapView: NGAContainerView {
    open var callBack:VoidBlock?
    open var callBackWithSender:((_ sender:Any?) -> Void)?
    open var tapRecognizer:UITapGestureRecognizer? {didSet{addTapGestureRecognizer(tapRecognizer, old: oldValue, toSelf: recognizeTapOnWholeContainer)}}
    open var recognizeTapOnWholeContainer:Bool = true {didSet{addTapGestureRecognizer(tapRecognizer, old: tapRecognizer, toSelf: recognizeTapOnWholeContainer)}}
    
    open override var viewToSize:UIView? {
        didSet{
            if let t = tapRecognizer {oldValue?.removeGestureRecognizer(t)}
            if !recognizeTapOnWholeContainer{addTapGestureRecognizer(tapRecognizer, old: tapRecognizer, toSelf: recognizeTapOnWholeContainer)}
        }
    }
    
    open override func postInit() {
        super.postInit()
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped(_:)))
        addTapGestureRecognizer(tapRecognizer, old: nil, toSelf: recognizeTapOnWholeContainer)
    }
    
    open func addTapGestureRecognizer(_ new:UITapGestureRecognizer?, old:UITapGestureRecognizer?, toSelf b:Bool) {
        if let o = old {viewToSize?.removeGestureRecognizer(o); removeGestureRecognizer(o)}
        if let n = new {if b{addGestureRecognizer(n)}else {viewToSize?.addGestureRecognizer(n); viewToSize?.isUserInteractionEnabled = true}}
    }
    
    
    @objc open func userTapped(_ sender:Any?) {
        //        print("tapped")
        callBack?()
        callBackWithSender?(self)
    }
}



open class NGATapLabelView: NGATapView {
    
    open let label = UILabel()
    open var text:String? {get{return label.text}set{label.text = newValue; setFramesForSubviewsOnMainThread()}}
    open var attributedText:NSAttributedString? {get{return label.attributedText}set{label.attributedText = newValue; setFramesForSubviewsOnMainThread()}}
    open var textColor:UIColor? {get{return label.textColor}set{label.textColor = newValue}}
    open var font:UIFont? {get{return label.font}set{if label.font != newValue {label.font = newValue; setFramesForSubviewsOnMainThread()}}}
    open var textAlignment:NSTextAlignment {get{return label.textAlignment}set{label.textAlignment = newValue}}
    open var fitFontToLabel:Bool = true
    open var constrainFontToLabel = false
    
    open override func postInit() {
        super.postInit()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        viewToSize = label
    }
    
    open override func setFramesForSubviews() {
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



open class NGATapImageView: NGATapView {
    open let imageView = UIImageView()
    open var image:UIImage? {get{return imageView.image}set{imageView.image = alwaysTemplate ? newValue?.withRenderingMode(.alwaysTemplate) : newValue}}
    open var imageTintColor:UIColor? {get{return imageView.tintColor}set{imageView.tintColor = newValue}}
    open var imageContentMode:UIView.ContentMode {get{return imageView.contentMode} set{imageView.contentMode = newValue}}
    open var alwaysTemplate:Bool = true {didSet{if alwaysTemplate != oldValue {imageView.image = imageView.image}}}
    
    open override func postInit() {
        super.postInit()
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageTintColor = UIColor.black
        viewToSize = imageView
    }
    
}





